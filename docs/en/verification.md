# Post-install Verification

Checks performed after installing LineageOS 18.1 + Magisk 26.1 + TWRP 3.7.0.

## Commands

```sh
adb shell getprop sys.boot_completed
adb shell getprop ro.build.version.release
adb shell getprop ro.lineage.version
adb shell getprop ro.build.date
adb shell getprop ro.product.device
adb shell uname -r
adb shell getenforce
adb shell getprop ro.boot.verifiedbootstate
adb shell getprop ro.boot.flash.locked
adb shell getprop gsm.version.baseband
adb shell getprop gsm.sim.state
adb shell dumpsys battery
adb shell ip addr show wlan0
adb shell df -h /data
adb shell magisk -v
adb shell magisk -V
adb shell su -c id
```

## Observed values

| Property | Value |
|---|---|
| `sys.boot_completed` | `1` |
| Android | 11 |
| LineageOS | `18.1-20260901-UNOFFICIAL-markw` |
| Build date (prop) | `Wed Sep  2 00:47:30 MSK 2026` |
| Device | `markw` |
| Kernel | `4.9.337-Prototype-v7-Re-based` |
| SELinux | Enforcing |
| `ro.boot.verifiedbootstate` | `green` |
| `ro.boot.flash.locked` | `1` |
| Baseband | `c1-00063-8953_GEN_PACK-1.97777.1.98470.1_V052` |
| SIM | `LOADED,ABSENT` (single SIM) |
| Battery | status 2, health 2, level 98 (at check time) |
| Wi-Fi | `192.168.31.184/24` (example) |
| `/data` | ~24 GB available |
| Cameras | 2 devices |
| Magisk | `26.1:MAGISK:R` (code 26100) |
| `su -c id` | `uid=0(root) gid=0(root) groups=0(root) context=u:r:magisk:s0` |
| TWRP (recovery) | `3.7.0_12-1` |

> Some values (IP, battery, boot time) depend on environment and timing. 
