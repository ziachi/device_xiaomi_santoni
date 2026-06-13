# Cached App Freezer — Broken on Kernel 4.9

## Summary
Android 15's `CachedAppOptimizer` uses cgroup v2 freezer to freeze background apps. Luuvy kernel 4.9.257 does **not** support cgroup v2 freezer (requires Linux 5.2+), causing cascading failures.

## Symptoms
- Device lag / not responding
- WhatsApp & Shopee can't login
- Apps freeze randomly, binder communication breaks

## Root Cause
```
E libprocessgroup: No such cgroup attribute: /sys/fs/cgroup/uid_10389/cgroup.freeze
W libprocessgroup: Failed to apply Frozen process profile: No such file or directory
E ActivityManager: Unable to freeze binder for 5359: Unable to freeze/unfreeze binder
```

### Cascade Chain
1. `CachedAppOptimizer` tries to freeze background apps via `cgroup.freeze`
2. Kernel 4.9 has no cgroup v2 freezer → `No such cgroup attribute`
3. Binder freeze/unfreeze fails → `Unable to freeze binder`
4. Apps get stuck in half-frozen state
5. GMS tries to communicate with frozen apps → **80× throttle**, **66× DeadObjectException**
6. GMS persistent floods binder with 1MB replies → **65× Large reply transaction (1,056,768 bytes)**
7. GMS auth services break → WA/Shopee can't authenticate

### Logcat Evidence (32,919 lines)
| Metric | Count |
|--------|-------|
| `throttling freezer binder callback` | 80× |
| `DeadObjectException` | 66× |
| `Large reply transaction 1MB` | 65× |
| `sent binder to frozen apps` | 24× |
| `Failed to apply Frozen/Unfrozen profile` | 2× |
| `Unable to freeze binder` | 3× |

### Affected Processes
| PID | Process | Impact |
|-----|---------|--------|
| 4350 | `com.google.android.gms` | 69× throttle, 12× frozen binder |
| 5131 | `com.android.vending` | 11× throttle, 11× frozen binder |
| 3171 | `com.android.systemui` | 1× frozen binder |
| 3871 | `.gms.persistent` | 65× 1MB binder floods |

## Why Patching Is Impossible
- cgroup v2 freezer controller was introduced in **Linux 5.2**
- Backporting to 4.9 requires rewriting the entire cgroup subsystem (hundreds of commits)
- Android 15 framework (`CachedAppOptimizer` + `libprocessgroup`) hardcoded to use cgroup v2
- Making framework use cgroup v1 freezer requires patching AOSP framework — not worth the effort

## Fix Applied (V16)
```properties
# system.prop
persist.device_config.activity_manager_native_boot.use_freezer=false
```

This tells `CachedAppOptimizer` to skip the freezer entirely. Background apps are still managed normally by OomAdjuster + LMK. No performance impact — freezer was never working anyway.

## Versions
- **First seen:** V15 (after Luuvy kernel inject)
- **Fixed:** V16
- **Kernel:** Luuvy 4.9.257-Checkmate-B.4.0.EOL


## V17 — Final Fix: Hardcode Disable

V16 approach ( prop) FAILED because:
1. Android 15 DeviceConfig migrated from system properties to SettingsProvider DB
2. GMS Phenotype can remotely push , overriding any default
3.  returns true on kernel 4.9 (partial cgroup v2 files exist)

### Fix Applied
-  → hardcoded 
-  → hardcoded 
- Removed broken prop from system.prop

This bypasses ALL conditional logic including GMS server-side overrides.


## V19 — Full No-Op (Nuclear Fix)

V17/V18 disabled freezer at CachedAppOptimizer level, but GMS Phenotype DeviceConfig
could remotely re-enable it. V18 logcat still showed 113 binder errors.

### V19 Fix — 4 Layer Kill-Switch
1. `Freezer.setProcessFrozen()` → return immediately (skip cgroup write)
2. `Freezer.freezeBinder()` → return 0 (skip binder freeze)
3. `Freezer.isFreezerSupported()` → return false
4. `CachedAppOptimizer.mUseFreezer` → hardcoded false

This ensures freezer is 100% dead regardless of any runtime config changes.
