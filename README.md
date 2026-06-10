# ProjectMatrixx 15.0 for Xiaomi Redmi 4X (santoni)

> ⚠️ **UNOFFICIAL BUILD** — Not affiliated with ProjectMatrixx. Use at your own risk.

## Device Info
| Property | Value |
|----------|-------|
| Device | Xiaomi Redmi 4X |
| Codename | santoni |
| SoC | Qualcomm MSM8937 Snapdragon 435 |
| Architecture | ARM64 |
| RAM | 2GB / 3GB |
| ROM | ProjectMatrixx 11.9.0 (Android 15) |
| Build Type | UNOFFICIAL |
| Variant | Vanilla (no GApps) |
| Maintainer | @kalomakan / @ziachi |

## Optimizations
- 2GB RAM optimized dalvik heap (heapstartsize=8m, heapgrowthlimit=128m, heapsize=256m)
- SELinux enforcing
- ADB enabled by default

## Repository Map

| Repo | Path | Forked From | Changes |
|------|------|-------------|---------|
| [device_xiaomi_santoni](https://github.com/ziachi/device_xiaomi_santoni) | `device/xiaomi/santoni` | [androidsantoni](https://github.com/androidsantoni/device_xiaomi_santoni) | Matrixx adaptation, 2GB RAM optimization, AB_OTA fix, SEPolicy fix |
| [kernel_xiaomi_msm8937](https://github.com/ziachi/kernel_xiaomi_msm8937) | `kernel/xiaomi/msm8937` | [androidsantoni](https://github.com/androidsantoni/kernel_xiaomi_msm8937) | Default AOSP clang toolchain |
| [vendor_xiaomi_santoni](https://github.com/ziachi/vendor_xiaomi_santoni) | `vendor/xiaomi/santoni` | [androidsantoni](https://github.com/androidsantoni/vendor_xiaomi_santoni) | Removed duplicate dalvik heap props |
| [android_packages_services_Telephony](https://github.com/ziachi/android_packages_services_Telephony) | `packages/services/Telephony` | [crDroid](https://github.com/crdroidandroid) | `isShell()` + `getModemService()` API fixes for Android 15 |
| [android_packages_modules_IntentResolver](https://github.com/ziachi/android_packages_modules_IntentResolver) | `packages/modules/IntentResolver` | [LineageOS](https://github.com/AospExtended/platform_packages_modules_IntentResolver) | `resolveActivityAsUser` 4→3 param fix |

## How to Build

```bash
# 1. Init Matrixx repo
repo init -u https://github.com/ProjectMatrixx/android.git -b 15.0 --depth=1

# 2. Copy local manifest
mkdir -p .repo/local_manifests
cp device/xiaomi/santoni/local_manifests/matrixx_santoni.xml .repo/local_manifests/

# 3. Sync
repo sync -c --no-clone-bundle --no-tags -j$(nproc)

# 4. Pull Chromium WebView LFS
cd external/chromium-webview/prebuilt/arm64 && git lfs pull && cd -
cd external/chromium-webview/prebuilt/arm && git lfs pull && cd -

# 5. Build
source build/envsetup.sh
lunch lineage_santoni-ap4a-userdebug
mka bacon
```

## Credits
- **[ProjectMatrixx](https://github.com/ProjectMatrixx)** — ROM base
- **[LineageOS](https://github.com/LineageOS)** — Device/vendor infrastructure
- **[androidsantoni](https://github.com/androidsantoni)** — Original device tree, kernel, and vendor blobs
- **[crDroid](https://github.com/crdroidandroid)** — Telephony source
- **AOSP** — Android Open Source Project

## License
This project inherits licenses from the upstream repositories.
