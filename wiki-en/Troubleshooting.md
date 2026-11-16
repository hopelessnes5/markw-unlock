# Troubleshooting

| Symptom | Fix |
|---|---|
| `E1001` in TWRP 3.0.2-2 | Use TWRP 3.4.0-1+ (brotli) |
| `Digest verification failed` (Magisk APK) | `twrp sideload` + `adb sideload Magisk-v26.1.apk` |
| `twrp format data` missing | `mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata` |
| Encryption remains after wipe | Format userdata with `mke2fs` |
| `adb wait-for-device` hangs in TWRP | Poll `getprop ro.twrp.version`/`adb devices` (state `recovery`) |
| TWRP in `boot` → 900E | Flash TWRP only to `recovery` |
| `su` Permission denied with Magisk present | Install/open Magisk APK and grant the request |

Details: `docs/en/troubleshooting.md`. 
