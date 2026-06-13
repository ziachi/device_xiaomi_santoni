# Fingerprint HAL (gx_fpd) — libstdc++.so Fix

## Problem
```
CANNOT LINK EXECUTABLE "/vendor/bin/gx_fpd": library "libstdc++.so" not found:
needed by /vendor/lib64/libfpservice.so in namespace (default)
```

## Root Cause
Android 15 VNDK renames `libstdc++.so` → `libstdc++_vendor.so` in vendor partition.
The vendor fingerprint HAL binary (`gx_fpd`) links against `libfpservice.so` which
expects `libstdc++.so` — a name that no longer exists in Android 15.

## Impact
- gx_fpd crashes every 5 seconds → 690-959 error lines per logcat session
- BiometricService reports `Status: 6` (BIOMETRIC_HW_NOT_PRESENT)
- Fingerprint unlock broken
- Apps using biometric auth (Shopee, WhatsApp) fall back to slower auth methods
- Shopee: captcha + WebView fallback → 3 processes → OOM kill on 2GB RAM

## Solution
`install_symlink` in `Android.bp`:
```
install_symlink {
    name: "libstdc++_vendor_compat_symlink",
    vendor: true,
    installed_location: "lib64/libstdc++.so",
    symlink_target: "/vendor/lib64/libstdc++_vendor.so",
}
```

Added to `PRODUCT_PACKAGES` in `symlinks.mk`.

## Version
- Introduced: V18
- Files: `Android.bp`, `symlinks.mk`
