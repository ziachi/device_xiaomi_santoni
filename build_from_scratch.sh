#!/bin/bash
# ========================================
# Matrixx 15 Santoni - Full Build Script
# Run on fresh VPS (Ubuntu, min 16 cores / 32GB RAM / 300GB disk)
# ========================================
set -e

BUILD_DIR="$HOME/matrixx15"
GH_USER="ziachi"

echo "=== Step 1: Install dependencies ==="
sudo apt update
sudo apt install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib \
  git git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev \
  libelf-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev \
  libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc \
  zip zlib1g-dev python3 python-is-python3 repo patchelf

echo "=== Step 2: Init & Sync Matrixx source ==="
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
repo init -u https://github.com/ProjectMatrixx/android.git -b 15.0 --git-lfs
repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags

echo "=== Step 3: Clone device/kernel/vendor from GitHub ==="
rm -rf device/xiaomi/santoni kernel/xiaomi/msm8937 vendor/xiaomi/santoni
git clone -b matrixx-15 https://github.com/$GH_USER/device_xiaomi_santoni.git device/xiaomi/santoni
git clone -b matrixx-15 https://github.com/$GH_USER/kernel_xiaomi_msm8937.git kernel/xiaomi/msm8937
git clone -b matrixx-15 https://github.com/$GH_USER/vendor_xiaomi_santoni.git vendor/xiaomi/santoni

echo "=== Step 4: Apply framework patches ==="
# Settings WiFi NPE fix
cd "$BUILD_DIR/packages/apps/Settings"
git apply "$BUILD_DIR/device/xiaomi/santoni/patches/0001-fix-settings-wifi-npe.patch"
cd "$BUILD_DIR"

# boot-image-profile.txt from AOSP
curl -L -o frameworks/base/config/boot-image-profile.txt \
  "https://android.googlesource.com/platform/frameworks/base/+/refs/heads/main/config/boot-image-profile.txt?format=TEXT" \
  | base64 -d > frameworks/base/config/boot-image-profile.txt

# Chromium WebView LFS
cd external/chromium-webview
git lfs pull
cd "$BUILD_DIR"

echo "=== Step 5: Build ==="
source build/envsetup.sh
lunch lineage_santoni-ap4a-userdebug
mka bacon -j$(nproc)

echo "=== Done! ==="
ls -lah out/target/product/santoni/Matrixx-*.zip 2>/dev/null
md5sum out/target/product/santoni/Matrixx-*.zip 2>/dev/null
