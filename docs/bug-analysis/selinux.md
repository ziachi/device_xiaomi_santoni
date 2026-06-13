# SELinux Dontaudit Policy — Full Analysis

## Policy
SELinux stays **Enforcing** at all times. All suppressions use `dontaudit` — denials are silenced but never allowed.

## Why Dontaudit
Many Android services probe for resources/services they don't actually need. These probes trigger SELinux denials that:
- Flood logcat with noise
- Make real bugs harder to find
- Don't affect functionality (probes fail gracefully)

`dontaudit` = "deny silently" — the action is still blocked, just not logged.

## Private vs Public Types
Android SELinux has two policy layers:
- **Public** (`system/sepolicy/public/`) — types accessible from vendor policy
- **Private** (`system/sepolicy/private/`) — types only for system/platform policy

**Vendor policy** (`device/*/sepolicy/vendor/`) can only reference public types.

### Common Pitfalls
| Type | Layer | Use in Vendor? |
|------|-------|---------------|
| `mediaprovider` | Public | ✅ Yes |
| `mediaprovider_app` | Private | ❌ No — causes `unknown type` |
| `system_app` | Public | ✅ Yes |
| `platform_app` | Public | ✅ Yes |
| `gmscore_app` | Public | ✅ Yes |
| `hal_camera_default` | Public | ✅ Yes |
| `bpffs_type` | Public (attribute) | ✅ Yes — use instead of private `fs_bpf` |

## Dontaudit Rules by Category

### HAL Service Probes
```
# Camera HAL probes graphics allocator (fallback works without it)
dontaudit hal_camera_default hal_graphics_allocator_service:service_manager find;

# Fingerprint HAL probes vendor services + default props
dontaudit hal_fingerprint_default default_android_vndservice:service_manager find;
dontaudit hal_fingerprint_default default_prop:file read;

# Camera HAL reads default properties
dontaudit hal_camera_default default_prop:file read;

# Sensors HAL reads default properties
dontaudit hal_sensors_default default_prop:file read;
```

### GMS / Google Play Services
```
# GMS probes ADSP, firmware filesystem, traced socket
dontaudit gmscore_app adsprpcd_file:filesystem getattr;
dontaudit gmscore_app firmware_file:filesystem getattr;
dontaudit gmscore_app traced_producer_socket:sock_file getattr;

# GMS reads all property types (blanket suppress)
dontaudit gmscore_app property_type:file read;
```

### System App / Platform App
```
# System app probes netd binder + suspend control
dontaudit system_app netd:binder call;
dontaudit system_app system_suspend_control_service:service_manager find;
dontaudit system_app system_suspend_control_internal_service:service_manager find;

# System app probes tracing proxy
dontaudit system_app tracingproxy_service:service_manager find;

# SystemUI reads UVC camera prop
dontaudit platform_app usb_uvc_enabled_prop:file read;
```

### libutils.so HAL Binding
```
# HAL components probe same_process_hal_file — harmless library loading
dontaudit credstore same_process_hal_file:file read;
dontaudit drmserver same_process_hal_file:file read;
dontaudit keystore same_process_hal_file:file read;
dontaudit gatekeeperd same_process_hal_file:file read;
```

### MediaProvider
```
# MediaProvider probes telephony radio service
dontaudit mediaprovider radio_service:service_manager find;
```

### Shell / Debug
```
# Shell probes BPF filesystem — neverallow blocks allow
dontaudit shell bpffs_type:dir search;
dontaudit shell bpffs_type:file { read };
```

### Other
```
# Untrusted apps
dontaudit untrusted_app ashmem_device:chr_file open;
dontaudit untrusted_app virtual_ab_prop:file read;
dontaudit untrusted_app_27 proc_vmstat:file { getattr open };
dontaudit untrusted_app_29 hal_memtrack_hwservice:hwservice_manager { find };

# Camera daemon
dontaudit mm-qcamerad property_socket:sock_file write;
dontaudit mm-qcamerad default_prop:file read;

# Misc
dontaudit domain device:file w_file_perms;
dontaudit qti_init_shell self:capability { dac_override };
dontaudit wcnss_service serialno_prop:file { read getattr open };
dontaudit fsck self:capability { dac_override dac_read_search };
dontaudit traced_probes debugfs_tracing_debug:file read;
dontaudit gx_fpd storage_file:dir search;
dontaudit gx_fpd default_prop:file read;
```

## Neverallow Lessons
Some denials **cannot** be fixed with `allow` because AOSP has `neverallow` rules:
- `platform_app` cannot set vendor properties → use `SystemProperties.set()` with system_prop context
- `shell` cannot access `bpffs` → use `dontaudit` instead of `allow`
- `system_app` cannot binder call `netd` → use `dontaudit`

## File Reference
All dontaudit rules are registered in `dontauditlist.txt` at device tree root.

## Versions
- **V3:** Initial base (17 rules from device tree)
- **V12:** GMS property blanket suppress
- **V13:** bpffs shell dontaudit
- **V15:** HAL + system_app + SystemUI (7 rules)
- **V16:** tracingproxy + mediaprovider + graphics_allocator (3 rules)
