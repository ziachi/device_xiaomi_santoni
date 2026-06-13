# RAM Optimization — 2GB Device (Santoni)

## Summary
Xiaomi Redmi 4X (santoni) has only 2GB RAM. Running Android 15 with GApps requires aggressive memory management.

## Key Tunings Applied

### ZRAM (V11+)
```properties
# 2GB ZRAM — sweet spot for 2GB device
# Smaller = more OOM kills, Larger = CPU overhead from compression
ro.zram.mark_idle_delay_mins=60
ro.zram.first_wb_delay_mins=180
ro.zram.periodic_wb_delay_hours=24
```
- ZRAM size: 2GB (set in `init.santoni_perf.rc`)
- Algorithm: lz4 (fast compression)

### LMK (Low Memory Killer)
```properties
ro.lmk.critical=200
ro.lmk.kill_timeout_ms=300
sys.lmk.minfree_levels=4096:0,8192:100,16384:200,32768:600,65536:900
```

### Heap Limits
```properties
dalvik.vm.heapgrowthlimit=192m
dalvik.vm.heapsize=384m
dalvik.vm.heapminfree=512k
dalvik.vm.heapmaxfree=8m
dalvik.vm.heaptargetutilization=0.75
```

### Background App Limits
```properties
ro.sys.fw.bg_apps_limit=16
ro.vendor.qti.sys.fw.bg_apps_limit=16
```

### Cached App Freezer
```properties
# DISABLED — kernel 4.9 has no cgroup v2 freezer
persist.device_config.activity_manager_native_boot.use_freezer=false
```
See [freezer.md](freezer.md) for full analysis.

## Debloat
28 apps removed via Android.bp `overrides:` stub (~350MB freed).
See `debloat/Android.bp` for full list.

**Never debloat:** LineageSetupWizard (needed for first-boot provisioning).

## Versions
- **V11:** Initial aggressive tuning
- **V13:** Debloat 29 apps
- **V14:** LMK critical 0→200, heap adjustments
- **V16:** Disable cached app freezer
