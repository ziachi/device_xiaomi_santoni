# Matrixx 15 (Android 15) — Xiaomi Redmi 4X (santoni)

Unofficial ProjectMatrixx v11.9.0 build for santoni.  
Optimized for 2GB RAM, SELinux enforcing.  
**Vanilla only** — pure AOSP, no Google Services.

> **microG Status:** Dropped as of V9. microG GmsCore was bundled but never activated properly despite multiple fix attempts. The build flag `WITH_MICROG=true` is no longer supported.

## Repositories

| Repo | GitHub | Branch | Path |
|------|--------|--------|------|
| Device tree | [device_xiaomi_santoni](https://github.com/ziachi/device_xiaomi_santoni/tree/matrixx-15) | `matrixx-15` | `device/xiaomi/santoni` |
| Vendor blobs | [vendor_xiaomi_santoni](https://github.com/ziachi/vendor_xiaomi_santoni/tree/matrixx-15) | `matrixx-15` | `vendor/xiaomi/santoni` |
| Kernel | [kernel_xiaomi_msm8937](https://github.com/ziachi/kernel_xiaomi_msm8937/tree/matrixx-15) | `matrixx-15` | `kernel/xiaomi/msm8937` |
| Frameworks (fork) | [frameworks_base](https://github.com/ziachi/frameworks_base/tree/15.0) | `15.0` | `frameworks/base` |
| Vendor Lineage (fork) | [vendor_lineage](https://github.com/ziachi/vendor_lineage/tree/15.0) | `15.0` | `vendor/lineage` |

> **Note:** `frameworks/base` uses a fork from `ziachi/frameworks_base` (not upstream `ProjectMatrixx/frameworks_base`).
> This fork contains Spectrum QS tile patches + santoni-specific API fixes.
>
> `vendor/lineage` uses a fork from `ziachi/vendor_lineage` for the microG build variant patch (version.mk).
>
> To rebuild without custom patches, edit `local_manifests/santoni.xml`:
> ```xml
> <!-- Remove these lines: -->
> <remove-project name="ProjectMatrixx/frameworks_base" />
> <project path="frameworks/base" name="frameworks_base" remote="ziachi" revision="15.0" />
>
> <!-- Or replace with upstream: -->
> <!-- <project path="frameworks/base" name="ProjectMatrixx/frameworks_base" remote="github" revision="15.0" /> -->
> ```
> Without these patches, Spectrum QS tile and some API stubs will be missing.

## Prerequisites

| Requirement | Minimum |
|-------------|---------|
| OS | Ubuntu 22.04 LTS (or WSL2) |
| RAM | 16GB+ (22GB recommended, + swap) |
| Disk | 300GB+ free |
| Java | OpenJDK 11 |
| Python | 3.10+ |
| Tools | `repo`, `git`, `git-lfs`, `ccache`, `bc`, `bison`, `flex`, `zip`, `unzip`, `curl` |

```bash
# Install build dependencies (Ubuntu 22.04)
sudo apt update && sudo apt install -y \
  bc bison build-essential ccache curl flex g++-multilib gcc-multilib \
  git git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev \
  lib32z1-dev libelf-dev liblz4-tool libncurses5 libncurses5-dev \
  libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush \
  rsync schedtool squashfs-tools xsltproc zip zlib1g-dev openjdk-11-jdk \
  python3 python-is-python3

# Install repo tool
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

# Setup ccache (optional but recommended — cuts rebuild time 80%+)
ccache -M 40G
```

## Build Instructions

### 1. Initialize Matrixx source
```bash
repo init -u https://github.com/AnierinBliss/matrixx_android.git -b 15.0 --git-lfs --depth=1
```

### 2. Add local manifest
```bash
mkdir -p .repo/local_manifests
cp device/xiaomi/santoni/local_manifests/santoni.xml .repo/local_manifests/
# Or if device tree not yet cloned:
curl -o .repo/local_manifests/santoni.xml \
  https://raw.githubusercontent.com/ziachi/device_xiaomi_santoni/matrixx-15/local_manifests/santoni.xml
```

### 3. Sync
```bash
repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags
```

### 4. Build
```bash
source build/envsetup.sh
lunch lineage_santoni-ap4a-userdebug

# Vanilla (default — no Google, no microG):
mka bacon

```

## Device Specs

| Spec | Detail |
|------|--------|
| SoC | Qualcomm MSM8937 (Snapdragon 430) |
| CPU | 4x A53 @1.4GHz + 4x A53 @1.2GHz |
| GPU | Adreno 505 |
| RAM | 2GB / 3GB |
| Kernel | 4.9.227 |
| Defconfig | `santoni_treble_defconfig` |

## Fixes Applied

### v9 (latest)
| # | Fix | Repo |
|---|-----|------|
| 57 | Fix TaskPersister recents dir timing (move to boot_completed) | device tree |
| 58 | Disable WiFi batched scan (fix getCachedScanData HAL error) | device tree |
| 59 | Suppress AccessPersistence fs-verity log (kernel 4.9 no fs-verity) | device tree |
| 60 | Suppress BluetoothPowerStatsCollector log (vendor HAL limitation) | device tree |
| 61 | Create QTI PowerHAL perfd directories | device tree |

### v8
| # | Fix | Repo |
|---|-----|------|
| 41 | Fix microG build variant (`WITH_MICROG=true` → MicroG tag) | vendor/lineage |
| 42 | Spectrum Tile rootless `SystemProperties.set()` (no su) | frameworks/base |
| 43 | Spectrum SELinux: migrate `persist.sys.spectrum.*` to system_prop context | device tree |
| 44 | Fingerprint HAL auto-detection (Goodix/FPC sensor check at boot) | device tree |
| 45 | Disable LineageOS Health feature (no charging control HW) | device tree |
| 46 | Camera SELinux: allow vendor_default_prop read | device tree |
| 47 | Disable fs-verity for kernel 4.9 (no fs-verity support) | device tree |
| 48 | Disable WiFi background scan cache (wcnss no getCachedScanData) | device tree |
| 49 | Add LiveDisplay mode_0..7 string resources | device tree |
| 50 | SELinux shell permissions (qemu_sf, baseband, idmap, bpf) | device tree |
| 51 | microG SELinux policy (vendor_default_prop, hal_gnss, udp_socket) | device tree |
| 52 | Create recent_tasks directory at boot (TaskPersister fix) | device tree |
| 53 | Fix PhoneStatusBarView display cutout (empty cutout overlay) | device tree |
| 54 | Suppress gs.intelligence log spam (4839x errors) | device tree |

### v7
| # | Fix | Repo |
|---|-----|------|
| 29 | Remove private SEPolicy types (system_suspend, storaged) from vendor policy | device tree |
| 30 | Remove vendor property set from platform_app SEPolicy (neverallow fix) | device tree |
| 31 | Spectrum QS tile for kernel profile switching | frameworks/base |
| 32 | SpectrumTile su -c setprop fix (neverallow workaround) | frameworks/base |
| 33 | Add missing API stubs (isShell, getModemService, resolveActivityAsUser) | frameworks/base |
| 34 | README for frameworks_base fork | frameworks/base |
| 35 | Add local_manifests to device tree | device tree |

### v6

- **#28** — Spectrum QS tile: add to stock + default tile list (was missing from `quick_settings_tiles_stock`, tile existed but not discoverable in Edit QS panel) [frameworks/base]

### v5
| # | Fix | Files |
|---|-----|-------|
| 22 | Suppress QTI PowerHAL + ANDR-PERF log spam | `vendor.prop` |
| 23 | Remove radio.config HAL (fix poll loop) | `manifest.xml` |
| 24 | Suppress WifiHAL getCachedScanData spam | `vendor.prop`, WiFi module patch |
| 25 | GMS memory limiter for 2GB RAM | `system.prop` |
| 26 | Spectrum QS Tile (quick settings toggle) | `frameworks/base`, sepolicy |
| 27 | microG GmsCore + Vending integration | `device.mk`, `prebuilt/microg/`, permissions XML |

### v4
| # | Fix | Files |
|---|-----|-------|
| 12 | Disable QTI PowerHAL service | `init.disable_services.rc` |
| 13 | Fix Spectrum profile activation | `init.santoni_perf.rc`, `init.spectrum.rc` |
| 14 | Suppress Settings Intelligence spam | `system.prop` |
| 15 | Disable Dolby audio (no DAX HW) | `vendor.prop`, `init.disable_services.rc`, vendor APKs removed |
| 16 | Aggressive LMK for 2GB + GApps | `device.mk`, `vendor.prop`, `system.prop` |
| 17 | Disable Google AdServices | `system.prop` |
| 18 | Reduce GMS background activity | `system.prop` |
| 19 | Play Integrity (Pixel 8a fingerprint) | `configs/pif/pif.json`, `vendor.prop` |
| 20 | Enable FRP persistent_data_block | `device.mk` |
| 21 | Disable ATFWD-daemon | `init.disable_services.rc` |

### v3
| # | Fix | Files |
|---|-----|-------|
| 1 | gx_fpd crash loop disable | `init.target.rc` |
| 2 | QTI Perf Qindx 121 spam fix | `vendor.prop` |
| 3 | QTI PowerHAL boost hint disable | `vendor.prop` |
| 4 | flags_health_check loop fix | `system.prop` |
| 5 | Settings WiFi NPE crash fix | `SettingsPreferenceFragment.java` |
| 6 | Camera libstdc++.so missing | patchelf vendor blobs |
| 7 | Flashlight no camera IDs | fixed by #6 |
| 8 | gx_fpd libstdc++.so | patchelf vendor blobs |
| 9 | Maintainer overlay | `cr_strings.xml` |
| 10 | DolbyProvider disable | device.mk |
| 11 | Spectrum profiles | `init.spectrum.rc`, `init.santoni_perf.rc` |

## Device Tree Map

```
device/xiaomi/santoni/
├── Android.mk
├── AndroidProducts.mk
├── BoardConfig.mk
├── README.md
├── biometrics/
│   └── android.hardware.biometrics.fingerprint@2.2-service.custom.rc
├── configs/
│   ├── permissions/
│   │   ├── default-permissions-microg.xml
│   │   ├── disable-health-feature.xml          ← v8 #45
│   │   └── privapp-permissions-microg.xml
│   └── pif/
│       └── pif.json
├── device.mk
├── lineage_santoni.mk
├── local_manifests/
│   └── santoni.xml
├── overlay/
│   ├── frameworks/base/core/res/res/values/
│   │   └── config.xml                          ← v8 #53
│   └── packages/apps/LineageParts/res/values/
│       └── strings.xml                         ← v8 #49
├── prebuilt/microg/
│   ├── Android.mk
│   ├── GmcVending.apk
│   └── GmsCore.apk
├── rootdir/
│   ├── init.disable_services.rc
│   ├── init.fingerprint_detect.sh              ← v8 #44
│   ├── init.santoni_perf.rc
│   ├── init.spectrum.rc
│   └── init.target.rc
├── rro_overlays/
│   └── WifiOverlay/res/values/
│       └── config.xml                          ← v8 #48
├── sepolicy/vendor/
│   ├── cameraserver.te                         ← v8 #46
│   ├── gmscore_app.te                          ← v8 #51
│   ├── hal_camera_default.te                   ← v8 #46
│   ├── platform_app.te                         ← v8 #43
│   ├── property.te                             ← v8 #43
│   ├── property_contexts                       ← v8 #43
│   ├── shell.te                                ← v8 #50
│   └── system_server.te                        ← v8 #43
├── system.prop                                 ← v8 #54
└── vendor.prop
```

## microG Integration (DROPPED)

> **Status: Dropped as of V9.**  
> microG GmsCore (v0.3.15.250932) and Vending were bundled as prebuilt APKs,
> but GmsCore was never detected/activated by the system despite:
> - Correct FAKE_PACKAGE_SIGNATURE permission
> - SELinux policies for gmscore_app
> - Proper privapp-permissions XML
>
> Root cause: unknown — `ActivityManager` reports "Unknown package: com.google.android.gms"
> even with the APK installed. The `WITH_MICROG=true` build flag is no longer supported.
>
> Prebuilt files remain in `prebuilt/microg/` for reference but are not included in builds.

## Spectrum Profiles

| Profile | Governor | CPU Max | GPU Max | Use Case |
|---------|----------|---------|---------|----------|
| 0 Balance | interactive | 1.4/1.0 GHz | 450 MHz | Daily use |
| 1 Performance | interactive (aggressive) | 1.5/1.2 GHz | 450 MHz | Gaming, heavy apps |
| 2 Battery | conservative | 1.0/0.9 GHz | 375 MHz | Max battery life |
| 3 Gaming | performance | 1.5/1.2 GHz | 450 MHz | Locked max clocks |

## Known Issues & Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `FAILED: vendor_sepolicy.cil.raw` referencing `system_suspend` / `storaged` | Private SEPolicy types cannot be used in vendor policy | Remove the offending `allow` lines from `sepolicy/vendor/*.te` |
| `FAILED: sepolicy_neverallows` platform_app + vendor property | AOSP neverallow: coredomain cannot set vendor properties | Use system_prop context (`persist.sys.*`) instead of vendor_prop |
| `FAILED: sepolicy_neverallows` system_app + netd binder | AOSP neverallow: appdomain cannot binder call netd | Remove the `allow system_app netd:binder call` rule |
| `FAILED: webview.apk` Invalid file / zip END header not found | Git LFS pointer not pulled (134 bytes instead of ~250MB) | `cd external/chromium-webview/prebuilt/arm64 && git lfs pull` (same for `arm/`) |
| `debugfs` mount error during OTA packaging | debugfs still mounted from previous build | `sudo umount /home/*/matrixx/out/target/product/santoni/system` before build |
| `PRODUCT_COPY_FILES` with `.apk` blocked | AOSP blocks APK in PRODUCT_COPY_FILES | Use `BUILD_PREBUILT` module with `Android.mk` instead |
| `all-makefiles-under` not finding subdir | Only scans 1 level deep | Add intermediate `Android.mk` with `include $(call all-subdir-makefiles)` |
| OrangeFox fails to flash on 2GB RAM | Recovery can't decompress large system.new.dat.br | Use clean flash, not dirty flash |

### Tips for AI Agents
- Always use `--git-lfs` flag with `repo init`
- After `repo sync --depth=1`, run `git lfs pull` inside `external/chromium-webview/prebuilt/arm64/` and `arm/`
- Lunch target for Android 15 is `lineage_santoni-ap4a-userdebug` (not `ap3a` or `ap2a`)
- Use `nohup ... &` for build so it survives SSH disconnects
- Monitor with `tail -f build.log` and grep for `FAILED:` periodically
- ccache dramatically speeds up rebuilds — first build ~4hrs, subsequent ~20min
- Private SEPolicy types (`system_suspend_server`, `storaged`) cannot be referenced from vendor sepolicy
- Use `persist.sys.*` prefix for properties that platform_app needs to set (system_prop context)

## Maintainer
**@kalomakan / @ziachi**

## Downloads
[GitHub Releases](https://github.com/ziachi/device_xiaomi_santoni/releases)

---

## Thanks To
- [androidsantoni](https://github.com/androidsantoni) — device tree, vendor, and kernel base
- [omansh-krishn](https://github.com/omansh-krishn) — thanks for keeping the source alive
- [LineageOS](https://github.com/LineageOS/android_device_xiaomi_santoni) — original santoni device tree & [kernel upstream](https://github.com/LineageOS/android_kernel_xiaomi_msm8937)
- [ProjectMatrixx / AnierinBliss](https://github.com/AnierinBliss/matrixx_android) — ROM base & [frameworks](https://github.com/ProjectMatrixx/frameworks_base)
