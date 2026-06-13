# Debloat Strategy — Android 15

## Summary
Remove unnecessary apps to free storage and reduce RAM usage for 2GB device.

## Approach History
Multiple approaches were tried before finding what works:

| Approach | Result |
|----------|--------|
| `PRODUCT_PACKAGES_REMOVE` | ❌ Does NOT exist in Android 15 |
| Rezip (remove from ZIP) | ❌ User rejected |
| Fork vendor/lineage | ❌ User cancelled |
| `LOCAL_OVERRIDES_PACKAGES` | ⚠️ Partially works |
| `BUILD_PHONY_PACKAGE` | ❌ Does NOT work (phony modules ignored by build) |
| **Android.bp stub with `overrides:`** | ✅ **WORKS** — used in V13+ |

## How It Works
Create `debloat/Android.bp` with a stub app that overrides target apps:

```blueprint
android_app {
    name: "SantoniDebloat",
    // ... minimal stub config
    overrides: [
        "App1",
        "App2",
        // ... apps to remove
    ],
}
```

The build system sees `overrides:` and excludes those apps from the final image.

## Current Debloat List (28 apps)
- GameSpace, LMOFreeform, LMOFreeformSidebar
- OmniJaws, OmniStyle
- Seedvault, SeedvaultPrebuilt
- DeviceDiagnostics
- LiveWallpapersPicker, WallpaperBackup
- FaceUnlock
- ... (see `debloat/Android.bp` for full list)

## Critical: Never Debloat
**LineageSetupWizard** — Sets `USER_SETUP_COMPLETE=1` and `DEVICE_PROVISIONED=1` on first boot. Without it, Settings app shows "not provisioned" error and QS tiles don't work.

## Verification
Check `out/target/product/santoni/installed-files.txt` — do NOT use `unzip -l` on the ZIP (OTA uses `system.new.dat.br`, not raw files).

## Versions
- **V12:** Initial attempt (19 apps, BUILD_PHONY_PACKAGE — failed)
- **V13:** Android.bp overrides (29 apps — ~350MB freed)
- **V14:** Removed LineageSetupWizard from debloat (fix provisioning bug)
