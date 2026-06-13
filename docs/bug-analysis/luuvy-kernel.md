# Luuvy Kernel Integration

## Summary
Prebuilt Luuvy kernel injected into Matrixx 15 build at V15.

## Kernel Info
| Property | Value |
|----------|-------|
| Version | `4.9.257-Luuvy-Checkmate-B.4.0.Lesion.EOL202601` |
| Compiler | GCC 10.1.0 |
| Format | `Image.gz-dtb` (12MB) |
| Source | AnyKernel3 flashable ZIP |
| Injected at | V15 |

## Integration Method
```makefile
# BoardConfig.mk
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz-dtb
TARGET_FORCE_PREBUILT_KERNEL := true

# Keep source+config for kernel headers
TARGET_KERNEL_SOURCE := kernel/xiaomi/msm8937
TARGET_KERNEL_CONFIG := santoni_defconfig
```

**Important:** `TARGET_KERNEL_SOURCE` and `TARGET_KERNEL_CONFIG` must stay active even with prebuilt kernel — they're needed to generate kernel headers for module compilation.

## Known Limitations
| Feature | Status | Reason |
|---------|--------|--------|
| cgroup v2 freezer | ❌ Not supported | Needs kernel 5.2+ |
| fs-verity | ❌ Not supported | Needs kernel 5.4+ |
| BPF (full) | ⚠️ Limited | Kernel 4.9 has minimal BPF |

## Build Autofixes Required
When building with prebuilt kernel, some kernel headers may mismatch. Autofixes applied in `out/` (not committed):
1. `msmb_camera-legacy.h` — missing header
2. `linux/msm_ion.h` — missing header
3. `sigaction` redefinition — kernel vs bionic conflict
4. `stack_t` typedef — kernel vs bionic conflict

**Note:** These fixes are in build output only. Must be re-applied after `make clean`.

## Files
- `prebuilt/Image.gz-dtb` — Luuvy kernel binary
- `BoardConfig.mk` — prebuilt kernel config
- `init.santoni_perf.rc` — Luuvy 4 profiles + Spectrum bridge

## Versions
- **V15:** Initial Luuvy kernel inject
- **V15:** Spectrum property revert for Luuvy compatibility
