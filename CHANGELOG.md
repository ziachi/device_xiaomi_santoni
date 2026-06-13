# Matrixx 15 (Android 15) — Xiaomi Redmi 4X (santoni)

## Development Changelog


## V20 — Maximum Freezer Kill (3-Layer) + DEXopt Fix (2026-06-13)

| # | Fix | File(s) |
|---|-----|---------|
| 110 | Hardcode disable setProcessFrozen at Process.java level (block ALL freeze callers) | Process.java *(frameworks/base)* |
| 111 | Disable LMKD cgroup freezer (ro.lmk.use_cgroup_freezer=false) | system.prop |
| 111 | Revert pm.dexopt.install to speed-profile (fix Play Store frozen 2.5min) | system.prop |
| 111 | Revert pm.dexopt.first-boot to verify (faster first boot) | system.prop |

## V19 — Aggressive DEXopt + Perf HAL Cleanup (2026-06-13)

| # | Fix | File(s) |
|---|-----|---------|
| 107 | Full freezer no-op in Freezer.java (setProcessFrozen + freezeBinder) | Freezer.java *(frameworks/base)* |
| 108 | Aggressive dexopt settings + remove perf HAL manifest | system.prop, manifest.xml |
| 109 | Update CHANGELOG + freezer docs | CHANGELOG.md, docs/ |

---

---

### V16
| # | Change |
|---|--------|
| #97 | Disable cached app freezer — kernel 4.9 no cgroup v2 support |
| #98 | Disable game default frame rate (santoni 60fps max) |
| #99 | SELinux: dontaudit mediaprovider radio_service |
| #100 | SELinux: dontaudit hal_camera_default graphics_allocator |
| #101 | Add dontauditlist.txt — full SELinux dontaudit registry |
| #102 | Convert CHANGELOG to markdown + add docs/bug-analysis/ |

---

### V15
| # | Change |
|---|--------|
| #89 | Overlay: remove GameSpace + Sidebar dead menu entries from Settings |
| #90 | SELinux: dontaudit libutils.so denial (credstore/drmserver/keystore/gatekeeperd) |
| #91 | SELinux: dontaudit system_app binder (netd + suspend_control services) |
| #92 | SELinux: dontaudit platform_app usb_uvc_enabled_prop |
| #93 | Update CHANGELOG.txt |
| #94 | Revert Spectrum property names for Luuvy kernel (persist.spectrum.*) |
| #95 | Inject Luuvy prebuilt kernel 4.9.257 (Checkmate-B.4.0.EOL) |
| #96 | Revert SpectrumTile property to persist.spectrum *(frameworks/base)* |

---

### V14
| # | Change |
|---|--------|
| #83 | Remove LineageSetupWizard from debloat (fix Settings "not provisioned") |
| #84 | Spectrum property alignment (persist.spectrum.* → persist.sys.spectrum.*) |
| #85 | SELinux: allow vendor_init proc_extra_free_kbytes + proc_drop_caches write |
| #86 | SELinux: allow qti_init_shell proc_watermark_scale_factor write |
| #87 | Move ro.hwui.render_ahead from vendor.prop to system.prop |

---

### V13
| # | Change |
|---|--------|
| #79 | Debloat 29 apps via Android.bp overrides (~350MB freed) |
| #80 | Fix idmap2 SEPolicy + disable QuickAccessWallet |
| #81 | Aggressive RAM/LMK/HWUI tuning for 2GB |
| #82 | Spectrum default Balance + per-profile memory tunables |

---

### V12
| # | Change |
|---|--------|
| #72 | Spectrum property setprop fix (persist.sys.spectrum.*) |
| #73 | Switch to AOSP PowerHAL (remove QTI perf) |
| #74 | SELinux dontaudit GMS (adsprpcd, firmware, traced, property_type) |
| #75 | Disable bloat services + tune heap/LMK for 2GB |
| #76 | Debloat 19 apps (initial attempt — BUILD_PHONY_PACKAGE failed) |
| #77 | Disable smart storage (SmartStorageManager spam) |
| #78 | Fix debloat module type |

---

### V11
| # | Change |
|---|--------|
| #69 | Aggressive 2GB RAM optimization (zRAM, swap, bg limits) |
| #70 | Kill bloat services via config overlay |
| #71 | LMK tuning for heavy GApps usage |

---

### V10
| # | Change |
|---|--------|
| #63 | SELinux longgar for external GApps (NikGapps Core) |
| #64 | GMS dontaudit policies (camera, location, etc.) |
| #65 | First-boot optimization (reduce init overhead) |
| #66 | Playstore download fix (GMS network policy) |
| #67 | Disable smart storage spam |
| #68 | Play Core compatibility fix |

---

### V9
| # | Change |
|---|--------|
| #55 | Drop microG (never activated properly) |
| #56 | Update README — microG dropped |
| #57 | Fix TaskPersister recents dir timing (move to boot_completed) |
| #58 | Disable WiFi batched scan (fix getCachedScanData HAL error) |
| #59 | Suppress AccessPersistence fs-verity log (kernel 4.9) |
| #60 | Suppress BluetoothPowerStatsCollector log |
| #61 | Create QTI PowerHAL perfd directories |

---

### V8
| # | Change |
|---|--------|
| #41 | Fix microG build variant (WITH_MICROG=true → MicroG tag) *(vendor/lineage)* |
| #42 | Spectrum Tile rootless SystemProperties.set() (no su) *(frameworks/base)* |
| #43 | Spectrum SELinux: persist.sys.spectrum.* → system_prop context |
| #44 | Fingerprint HAL auto-detection (Goodix/FPC sensor check at boot) |
| #45 | Disable LineageOS Health feature (no charging control HW) |
| #46 | Camera SELinux: allow vendor_default_prop read |
| #47 | Disable fs-verity for kernel 4.9 |
| #48 | Disable WiFi background scan cache |
| #49 | Add LiveDisplay mode_0..7 string resources |
| #50 | SELinux shell permissions (qemu_sf, baseband, idmap, bpf) |
| #51 | microG SELinux policy (vendor_default_prop, hal_gnss, udp_socket) |
| #52 | Create recent_tasks directory at boot (TaskPersister fix) |
| #53 | Fix PhoneStatusBarView display cutout (empty cutout overlay) |
| #54 | Suppress gs.intelligence log spam (4839× errors) |

---

### V7
| # | Change |
|---|--------|
| #29 | Remove private SEPolicy types (system_suspend, storaged) from vendor |
| #30 | Remove vendor property set from platform_app SEPolicy (neverallow) |
| #31 | Spectrum QS tile for kernel profile switching *(frameworks/base)* |
| #32 | SpectrumTile su -c setprop fix (neverallow workaround) *(frameworks/base)* |
| #33 | Add missing API stubs (isShell, getModemService, resolveActivityAsUser) *(frameworks/base)* |
| #34 | README for frameworks_base fork *(frameworks/base)* |
| #35 | Add local_manifests to device tree |

---

### V6
| # | Change |
|---|--------|
| #28 | Spectrum QS tile: add to stock + default tile list *(frameworks/base)* |

---

### V5
| # | Change |
|---|--------|
| #22 | Suppress QTI PowerHAL + ANDR-PERF log spam |
| #23 | Remove radio.config HAL (fix poll loop) |
| #24 | Suppress WifiHAL getCachedScanData spam |
| #25 | GMS memory limiter for 2GB RAM |
| #26 | Spectrum QS Tile (quick settings toggle) *(frameworks/base)* |
| #27 | microG GmsCore + Vending integration |

---

### V4
| # | Change |
|---|--------|
| #12 | Disable QTI PowerHAL service |
| #13 | Fix Spectrum profile activation |
| #14 | Suppress Settings Intelligence spam |
| #15 | Disable Dolby audio (no DAX HW) |
| #16 | Aggressive LMK for 2GB + GApps |
| #17 | Disable Google AdServices |
| #18 | Reduce GMS background activity |
| #19 | Play Integrity (Pixel 8a fingerprint) |
| #20 | Enable FRP persistent_data_block |
| #21 | Disable ATFWD-daemon |

---

### V3
| # | Change |
|---|--------|
| #1 | gx_fpd crash loop disable |
| #2 | QTI Perf Qindx 121 spam fix |
| #3 | QTI PowerHAL boost hint disable |
| #4 | flags_health_check loop fix |
| #5 | Settings WiFi NPE crash fix *(frameworks/base)* |
| #6 | Camera libstdc++.so missing (patchelf vendor blobs) |
| #7 | Flashlight no camera IDs (fixed by #6) |
| #8 | gx_fpd libstdc++.so (patchelf vendor blobs) |
| #9 | Maintainer overlay (cr_strings.xml) |
| #10 | DolbyProvider disable |
| #11 | Spectrum profiles (init.spectrum.rc, init.santoni_perf.rc) |


## V18 — Fingerprint HAL Fix + GameSpace Cleanup (2026-06-13)

| # | Fix | File(s) |
|---|-----|---------|
| 1 | Fix gx_fpd crash: libstdc++.so symlink for Android 15 VNDK compat | Android.bp, symlinks.mk |
| 2 | Remove GameSpace Settings entry (debloated app crash fix) | crDroidSettings/crdroid_settings_misc.xml |
| 3 | VM tuning: swappiness 100, vfs_cache_pressure 50, watermark_boost_factor 0 | init.santoni_perf.rc |
| 4 | SELinux: allow vendor_init proc_watermark_boost_factor | vendor_init.te |

**Autofix during compile:** 1x XML mismatched tag in crDroidSettings → clean removal

## V17 — Hardcode Freezer Kill + Fingerprint HAL

| # | Fix | Files |
|---|-----|-------|
| 104 | Hardcode disable cached app freezer (bypass GMS Phenotype) | CachedAppOptimizer.java, Freezer.java |
| 105 | Enable fingerprint HAL (gx_fpd) + cleanup broken freezer prop | biometrics/*.rc, file_contexts, system.prop |

