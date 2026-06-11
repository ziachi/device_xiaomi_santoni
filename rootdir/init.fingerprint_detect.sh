#!/vendor/bin/sh
# Fingerprint sensor auto-detection for santoni
# Checks for Goodix or FPC sensor presence and starts HAL

FPC_SYSFS="/sys/devices/soc/soc:fpc1020/compatible_all"
FPC_SYSFS_ALT="/sys/devices/platform/soc/soc:fpc1020/compatible_all"
GOODIX_DEV="/dev/goodix_fp"

if [ -f "$FPC_SYSFS" ] || [ -f "$FPC_SYSFS_ALT" ]; then
    # FPC sensor detected
    setprop persist.sys.fp.vendor switchf
elif [ -c "$GOODIX_DEV" ]; then
    # Goodix sensor detected
    setprop ro.hardware.fingerprint goodix
    setprop ro.boot.fpsensor gdx
    setprop persist.sys.fp.onstart 1
else
    # No fingerprint sensor found — do nothing
    setprop persist.sys.fp.vendor none
fi
