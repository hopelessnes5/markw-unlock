# What Works (Verified)

Recorded from an actual run on Redmi 4 Prime (markw), November 2026.

## Software configuration

| Component | State |
|---|---|
| ROM | LineageOS 18.1 Revived, `18.1-20260901-UNOFFICIAL-markw`, Android 11 |
| Kernel | `4.9.337-Prototype-v7-Re-based` |
| SELinux | Enforcing |
| Root | Magisk 26.1 (`26.1:MAGISK:R`), `su -c id` → `uid=0(root) context=u:r:magisk:s0` |
| Magisk app | Installed, su prompts granted |
| Recovery | TWRP 3.7.0_12-1 (SonicBSV, 2023-11-18) in `recovery` |
| Boot time | ~26 s to a usable state (observed) |

## Hardware/network checks

| Check | Result |
|---|---|
| IMEI | `863285038799275` present |
| Baseband | `c1-00063-8953_GEN_PACK-1.97777.1.98470.1_V052` |
| SIM | LOADED |
| Wi-Fi | Working (example: `192.168.31.184`) |
| Cameras | 2 detected |
| Audio | Working |
| Battery | Reported correctly (example: 98%) |
| `/data` | ~24 GB available after clean install |

## Working techniques

- **Temporary root:** CVE-2019-2215 (`bhsu98`) on stock Android 6.
- **TWRP:** flash image to `recovery` via `dd ... bs=4096`; initial ROM install with TWRP 3.4.0-1 (brotli), then update to 3.7.0.
- **Remove encryption:** `mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata`.
- **Install ROM:** `twrp install <zip>`.
- **Install Magisk:** `adb shell 'twrp sideload'` on device + `adb sideload Magisk-v26.1.apk` on PC.
- **ADB in TWRP:** device state is `recovery`; wait by polling (`getprop`/`adb devices`), not `adb wait-for-device`.

## Observed bootloader props

After install: `ro.boot.verifiedbootstate=green`, `ro.boot.flash.locked=1` — system and root still work with this setup. **Do not run `fastboot oem lock` and do not reflash `aboot` without a strong reason.** 
