# Matrixx 15 (Android 15) — Xiaomi Redmi 4X (santoni)

Unofficial ProjectMatrixx v11.9.0 build for santoni.  
Optimized for 2GB RAM, SELinux enforcing.  
Available in two variants: **Vanilla** (pure AOSP) and **microG** (with GmsCore + Vending).

## Repositories

| Repo | GitHub | Branch | Path |
|------|--------|--------|------|
| Device tree | [device_xiaomi_santoni](https://github.com/ziachi/device_xiaomi_santoni) | `matrixx-15` | `device/xiaomi/santoni` |
| Vendor blobs | [vendor_xiaomi_santoni](https://github.com/ziachi/vendor_xiaomi_santoni) | `matrixx-15` | `vendor/xiaomi/santoni` |
| Kernel | [kernel_xiaomi_msm8937](https://github.com/ziachi/kernel_xiaomi_msm8937) | `matrixx-15` | `kernel/xiaomi/msm8937` |

**Also required:** `frameworks/base` from `ProjectMatrixx/frameworks_base` (branch `15.0`)  
> Note: Matrixx renamed `android_frameworks_base` → `frameworks_base`, so the default manifest won't find it. The local manifest override handles this.

## Build Instructions

### 1. Initialize Matrixx source
```bash
repo init -u https://github.com/AnierinBliss/matrixx_android.git -b 15.0 --git-lfs --depth=1
```

### 2. Add local manifest
```bash
mkdir -p .repo/local_manifests
cp device/xiaomi/santoni/manifests/santoni.xml .repo/local_manifests/
# Or if device tree not yet cloned:
curl -o .repo/local_manifests/santoni.xml \
  https://raw.githubusercontent.com/ziachi/device_xiaomi_santoni/matrixx-15/manifests/santoni.xml
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

# microG (with GmsCore + Vending):
WITH_MICROG=true mka bacon
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

### v6 (latest)

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

## microG Integration

Prebuilt microG GmsCore (v0.3.15.250932) and Vending, built from source.  
Controlled by `WITH_MICROG` build flag (default: `false`).

| Package | Location | Size |
|---------|----------|------|
| GmsCore | `prebuilt/microg/GmsCore.apk` | 89 MB |
| GmcVending | `prebuilt/microg/GmcVending.apk` | 4.4 MB |

Permissions: `configs/permissions/privapp-permissions-microg.xml`  
Source: [microg/GmsCore](https://github.com/microg/GmsCore)

## Spectrum Profiles

| Profile | Governor | CPU Max | GPU Max | Use Case |
|---------|----------|---------|---------|----------|
| 0 Balance | interactive | 1.4/1.0 GHz | 450 MHz | Daily use |
| 1 Performance | interactive (aggressive) | 1.5/1.2 GHz | 450 MHz | Gaming, heavy apps |
| 2 Battery | conservative | 1.0/0.9 GHz | 375 MHz | Max battery life |
| 3 Gaming | performance | 1.5/1.2 GHz | 450 MHz | Locked max clocks |

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
