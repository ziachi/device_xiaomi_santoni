# Matrixx 15 (Android 15) — Xiaomi Redmi 4X (santoni)

Unofficial ProjectMatrixx v11.9.0 for santoni.
Optimized for 2GB RAM, SELinux enforcing, Vanilla only.

> **Vanilla only** — no bundled Google Services or microG.
> Use external GApps (NikGapps Core recommended) after flashing.

## Device Specs

| Spec | Detail |
|------|--------|
| SoC | Qualcomm MSM8937 (Snapdragon 430) |
| CPU | 4× A53 @1.4GHz + 4× A53 @1.2GHz |
| GPU | Adreno 505 |
| RAM | 2GB / 3GB |
| Kernel | 4.9.227 (`santoni_treble_defconfig`) |

## Repositories

| Repo | Branch | Path |
|------|--------|------|
| [device_xiaomi_santoni](https://github.com/ziachi/device_xiaomi_santoni/tree/matrixx-15) | `matrixx-15` | `device/xiaomi/santoni` |
| [vendor_xiaomi_santoni](https://github.com/ziachi/vendor_xiaomi_santoni/tree/matrixx-15) | `matrixx-15` | `vendor/xiaomi/santoni` |
| [kernel_xiaomi_msm8937](https://github.com/ziachi/kernel_xiaomi_msm8937/tree/matrixx-15) | `matrixx-15` | `kernel/xiaomi/msm8937` |
| [frameworks_base](https://github.com/ziachi/frameworks_base/tree/15.0) | `15.0` | `frameworks/base` |

> **Note:** `frameworks/base` is a fork of `ProjectMatrixx/frameworks_base` containing
> Spectrum QS tile patches and santoni-specific API fixes.
> To build without custom patches, remove the fork entry from `local_manifests/santoni.xml`.

## Build Instructions

### Prerequisites

- Ubuntu 22.04+ (or WSL2), 16GB+ RAM (22GB recommended), 300GB+ disk
- OpenJDK 11, Python 3.10+, `repo`, `git`, `git-lfs`, `ccache`

```bash
# Install dependencies
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

# Setup ccache (recommended — cuts rebuild time 80%+)
ccache -M 40G
```

### Build

```bash
# 1. Init source
repo init -u https://github.com/AnierinBliss/matrixx_android.git -b 15.0 --git-lfs --depth=1

# 2. Add local manifest
mkdir -p .repo/local_manifests
curl -o .repo/local_manifests/santoni.xml \
  https://raw.githubusercontent.com/ziachi/device_xiaomi_santoni/matrixx-15/local_manifests/santoni.xml

# 3. Sync
repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags

# 4. Build
source build/envsetup.sh
lunch lineage_santoni-ap4a-userdebug
mka bacon
```

## Features

- **Spectrum Kernel Manager** — 4 CPU/GPU/RAM profiles via QS tile
- **28-app debloat** — ~350MB freed via Android.bp overrides
- **2GB RAM tuning** — aggressive LMK, reduced heap, zRAM, background limits
- **SELinux Enforcing** — targeted vendor policies, no permissive

### Spectrum Profiles

| Profile | Governor | CPU Max | GPU Max | Use Case |
|---------|----------|---------|---------|----------|
| 0 Balance | interactive | 1.4/1.0 GHz | 450 MHz | Daily use (default) |
| 1 Performance | interactive | 1.5/1.2 GHz | 450 MHz | Heavy apps |
| 2 Battery | conservative | 1.0/0.9 GHz | 375 MHz | Max battery life |
| 3 Gaming | performance | 1.5/1.2 GHz | 450 MHz | Locked max clocks |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Settings won't open after format data | Make sure LineageSetupWizard is NOT debloated — it sets provisioning flags |
| `FAILED: vendor_sepolicy.cil.raw` private types | Don't reference `system_suspend` / `storaged` in vendor policy |
| `sepolicy_neverallows` platform_app + vendor prop | Use `persist.sys.*` prefix (system_prop context) |
| webview.apk build error (134 bytes) | `cd external/chromium-webview/prebuilt/arm64 && git lfs pull` |
| Spectrum profile not switching | Properties must use `persist.sys.spectrum.*` (not `persist.spectrum.*`) |
| Dirty flash crash / boot loop | Format data (not just wipe) when major version changes |

## Downloads

[GitHub Releases](https://github.com/ziachi/device_xiaomi_santoni/releases)

## Changelog

See [CHANGELOG.txt](CHANGELOG.txt) for full development history.

## Credits

- [androidsantoni](https://github.com/androidsantoni) — device tree, vendor, kernel base
- [omansh-krishn](https://github.com/omansh-krishn) — keeping the source alive
- [LineageOS](https://github.com/LineageOS) — original santoni device tree & kernel
- [ProjectMatrixx](https://github.com/ProjectMatrixx) — ROM base

## Maintainer

**@kalomakan / @ziachi**
