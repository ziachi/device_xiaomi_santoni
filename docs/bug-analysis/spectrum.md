# Spectrum Kernel Profiles

## Summary
Spectrum is a kernel profile switcher via Quick Settings tile. Allows switching between performance profiles (Battery, Balance, Performance, Gaming).

## Architecture
```
SpectrumTile.java (frameworks/base)
    → SystemProperties.set("persist.spectrum.profile", "0-3")
        → init.santoni_perf.rc (on property trigger)
            → sets kernel tuning params (CPU gov, I/O sched, VM, etc.)
```

## Property History
| Version | Property | Why |
|---------|----------|-----|
| V7-V13 | `persist.sys.spectrum.*` | Android standard `sys.` prefix |
| V14 | `persist.sys.spectrum.*` | Aligned property_contexts |
| V15+ | `persist.spectrum.*` | Reverted — Luuvy kernel expects non-sys prefix |

### Why Reverted (V15)
Luuvy kernel's init scripts use `persist.spectrum.profile` internally. Using `persist.sys.spectrum.profile` caused a mismatch — kernel didn't react to profile changes.

## SELinux
```
# property_contexts
persist.spectrum.     u:object_r:system_prop:s0

# platform_app.te (for QS tile)
set_prop(platform_app, system_prop)
```

## Profile Mapping
| Value | Profile | Use Case |
|-------|---------|----------|
| 0 | Balance | Default — daily use |
| 1 | Performance | Heavy apps |
| 2 | Battery | Battery saving |
| 3 | Gaming | Max performance |

## Files
- `init.santoni_perf.rc` — profile triggers + kernel tuning
- `property_contexts` — SELinux property type
- `property.te` — property type definition
- `platform_app.te` — QS tile permission
- `system_server.te` — system server permission
- `SpectrumTile.java` — Quick Settings tile *(frameworks/base)*

## Versions
- **V5:** Initial Spectrum QS tile
- **V7:** Rootless SystemProperties.set()
- **V14:** Property alignment (sys prefix)
- **V15:** Revert to non-sys prefix for Luuvy kernel
