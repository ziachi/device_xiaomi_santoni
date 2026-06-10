# Device Tree for Xiaomi Redmi 4X (santoni)

## Matrixx 13 (Android 16) — Build Fixes

> **⚠️ Build masih broken** — stopped di ~3% ninja compilation.

### Quick Setup

```bash
# 1. Init Matrixx 13 repo
repo init -u https://github.com/ProjectMatrixx/android.git -b 16.0 --depth=1

# 2. Copy local manifest (contains all 21 fixed repos)
mkdir -p .repo/local_manifests
cp device/xiaomi/santoni/matrixx_santoni.xml .repo/local_manifests/

# 3. Sync
repo sync -c --no-clone-bundle --no-tags -j$(nproc)

# 4. Build
source build/envsetup.sh
lunch lineage_santoni-ap4a-userdebug
mka bacon
```

### Fixed Repos (21 total)

| Path | GitHub Repo | Original Source |
| :--- | :---------- | :-------------- |
| `art` | [android_art](https://github.com/ziachi/android_art/tree/matrixx-16.0-santoni) | LineageOS / crDroid |
| `bionic` | [android_bionic](https://github.com/ziachi/android_bionic/tree/matrixx-16.0-santoni) | LineageOS / crDroid |
| `hardware/interfaces` | [android_hardware_interfaces](https://github.com/ziachi/android_hardware_interfaces/tree/matrixx-16.0-santoni) | LineageOS / crDroid |
| `frameworks/base` | [android_frameworks_base](https://github.com/ziachi/android_frameworks_base/tree/matrixx-16.0-santoni) | ProjectMatrixx / AOSP |
| `frameworks/opt/telephony` | [android_frameworks_opt_telephony](https://github.com/ziachi/android_frameworks_opt_telephony/tree/matrixx-16.0-santoni) | LineageOS / crDroid |
| `frameworks/native` | [android_frameworks_native](https://github.com/ziachi/android_frameworks_native/tree/matrixx-16.0-santoni) | LineageOS / AOSP |
| `frameworks/av` | [android_frameworks_av](https://github.com/ziachi/android_frameworks_av/tree/matrixx-16.0-santoni) | LineageOS / AOSP |
| `system/sepolicy` | [android_system_sepolicy](https://github.com/ziachi/android_system_sepolicy/tree/matrixx-16.0-santoni) | LineageOS / AOSP |
| `build/soong` | [android_build_soong](https://github.com/ziachi/android_build_soong/tree/matrixx-16.0-santoni) | LineageOS / AOSP |
| `device/xiaomi/santoni` | [device_xiaomi_santoni](https://github.com/ziachi/device_xiaomi_santoni/tree/matrixx-16.0-santoni) | androidsantoni |
| `packages/apps/DocumentsUI` | [android_packages_apps_DocumentsUI](https://github.com/ziachi/android_packages_apps_DocumentsUI/tree/matrixx-16.0-santoni) | LineageOS / crDroid |
| `packages/apps/GameSpace` | [android_packages_apps_GameSpace](https://github.com/ziachi/android_packages_apps_GameSpace/tree/matrixx-16.0-santoni) | ProjectMatrixx |
| `packages/modules/Wifi` | [android_packages_modules_Wifi](https://github.com/ziachi/android_packages_modules_Wifi/tree/matrixx-16.0-santoni) | LineageOS / crDroid |
| `packages/modules/Bluetooth` | [android_packages_modules_Bluetooth](https://github.com/ziachi/android_packages_modules_Bluetooth/tree/matrixx-16.0-santoni) | LineageOS / crDroid |
| `packages/modules/Connectivity` | [android_packages_modules_Connectivity](https://github.com/ziachi/android_packages_modules_Connectivity/tree/matrixx-16.0-santoni) | ProjectMatrixx |
| `packages/services/OmniJaws` | [android_packages_services_OmniJaws](https://github.com/ziachi/android_packages_services_OmniJaws/tree/matrixx-16.0-santoni) | ProjectMatrixx / OmniROM |
| `packages/services/Telecomm` | [android_packages_services_Telecomm](https://github.com/ziachi/android_packages_services_Telecomm/tree/matrixx-16.0-santoni) | LineageOS / AOSP |
| `tools/netsim` | [android_tools_netsim](https://github.com/ziachi/android_tools_netsim/tree/matrixx-16.0-santoni) | AOSP |
| `kernel/xiaomi/msm8937` | [kernel_xiaomi_msm8937](https://github.com/ziachi/kernel_xiaomi_msm8937/tree/matrixx-16.0-santoni) | androidsantoni |
| `cts` | [android_cts](https://github.com/ziachi/android_cts/tree/matrixx-16.0-santoni) | AOSP |
| `platform_testing` | [android_platform_testing](https://github.com/ziachi/android_platform_testing/tree/matrixx-16.0-santoni) | AOSP |

All repos on branch `matrixx-16.0-santoni`.

### Patches Applied
- RAM 2GB optimization (dalvik heap, LMK, zRAM)
- Credit @kalomakan (unofficial build)
- ADB enabled by default with auth
- SELinux enforcing mode
- ~190 missing aconfig flags
- 20+ build system fixes (see commit history per repo)

### Root Cause
Matrixx 13 manifest mixes repos from ProjectMatrixx, crDroid (significantly ahead), and LineageOS/AOSP. Multiple repos had incompatible APIs and needed swapping to LineageOS `lineage-23.0`.

### Maintainer
@ziachi

## Spec Sheet

| Feature                 | Specification                     |
| :---------------------- | :-------------------------------- |
| CPU                     | Octa-core 1.4 GHz Cortex-A53      |
| Chipset                 | Qualcomm MSM8940 Snapdragon 435   |
| GPU                     | Adreno 505                        |
| Memory                  | 2/3 GB                            |
| Shipped Android Version | 6.0.1                             |
| Storage                 | 16/32 GB                          |
| MicroSD                 | Up to 256 GB                      |
| Battery                 | 4100 mAh (non-removable)          |
| Dimensions              | 139 x 69 x 8.65 mm                |
| Display                 | 720 x 1280 pixels, 5" (~294 PPI)   |
| Rear Camera             | 13 MP, LED flash                  |
| Front Camera            | 5 MP                              |
| Release Date            | May 2017                          |

![Redmi 4X](https://cdn.tgdd.vn/Products/Images/42/99145/xiaomi-redmi-4x-400-400x460.png "Redmi 4X")
