# Detailed Guide: Redmi 4 Prime (markw)

This guide describes the path actually completed on a device: stock MIUI 10 (Android 6, `MBEMIXM`) → temporary root (CVE-2019-2215) → patched `aboot` → TWRP → LineageOS 18.1 → Magisk 26.1. Official Mi Unlock, disassembly/testpoint, and `devinfo` patching were not used.

## 0. Warnings

- **Risk of permanent damage.** Mistakes with `aboot/boot/recovery`, `fastboot oem lock`, or loss of EFS/modem data can make the phone unrepairable without EDL/programmer access.
- **Backups are mandatory** before writing partitions: `aboot`, `abootbak`, `devinfo`, `persist`, `modemst1`, `modemst2`, `fsg`, `splash`.
- **Do not run `fastboot oem lock`** after installing a custom ROM with this method.
- **Do not reflash `aboot`** after a successful setup unless you fully understand the consequences.
- Verify **MD5/SHA256** of images ([files/CHECKSUMS.md](files/CHECKSUMS.md)).

## 1. Requirements

### PC software
- Windows + PowerShell (this path was performed on Windows), `adb`/`fastboot` (platform-tools).
- ADB/USB drivers as needed (Qualcomm/fastboot).

### Files
- CVE-2019-2215 package for markw: [bhsu98/cve-2019-2215-markw](https://github.com/Begitdj/cve-2019-2215-markw) (includes `emmc_appsboot.mbn` for writing to `aboot`).
- TWRP 3.4.0-1 (markw, suitable for ROM install): [redispade release](https://github.com/redispade/device_xiaomi_markw_twrp/releases/tag/twrp-3.4.0-1-markw) — SHA256 `0fd837a1…`.
- TWRP 3.7.0_12-1 (SonicBSV, 2023-11-18): [AFH fid=16385555061192795609](https://androidfilehost.com/?fid=16385555061192795609) — MD5 `bdbe82be…`.
- LineageOS 18.1 Revived (UNOFFICIAL markw, 2026-09-01): `lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip` — MD5 `6d0b3b3f…`, SHA256 `35981941…` (854,946,797 bytes).
- Magisk v26.1 (works for Android 11 and 6.0.1): [GitHub release v26.1](https://github.com/topjohnwu/Magisk/releases/tag/v26.1) — SHA256 `ae1a02b1…`.
- (Reference) Stock: [MIUI V10.2.2.0.MBEMIXM fastboot tgz](https://bigota.d.miui.com/V10.2.2.0.MBEMIXM/markw_global_images_V10.2.2.0.MBEMIXM_20190422.0000.00_6.0_global_7e9366b564.tgz), MD5 `7e9366b564…`.

### Buttons / modes (markw)
- **Fastboot:** Vol Down + Power.
- **Recovery:** Vol Up + Power (sometimes requires timing/USB state).
- **MI-Recovery (3-button):** Vol Up + Vol Down + Power — does not bypass signature checks for custom recovery.

## 2. Temporary root (CVE-2019-2215)

Goal: get root on stock Android 6 to read/write partitions. The exploit from [cve-2019-2215-markw](https://github.com/Begitdj/cve-2019-2215-markw) (`bhsu98`) was used.

- Dirty COW **did not work** (kernel patched).
- Follow the exploit README: enable debugging, build/run the binary, confirm `uid=0` via `adb shell`.
- Root may be temporary — back up partitions and flash `aboot` while access is available.

## 3. Backups (mandatory)

With root, dump partitions to PC (by-name paths typical for 8953/markw):

```sh
adb shell su -c "dd if=/dev/block/bootdevice/by-name/aboot    of=/sdcard/aboot.orig    bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/abootbak of=/sdcard/abootbak.orig bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/devinfo  of=/sdcard/devinfo.orig  bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/persist  of=/sdcard/persist.img   bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/modemst1 of=/sdcard/modemst1.img  bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/modemst2 of=/sdcard/modemst2.img  bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/fsg      of=/sdcard/fsg.img       bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/splash   of=/sdcard/splash.img    bs=4096"
adb pull /sdcard/aboot.orig /sdcard/abootbak.orig /sdcard/devinfo.orig /sdcard/persist.img /sdcard/modemst1.img /sdcard/modemst2.img /sdcard/fsg.img /sdcard/splash.img <backup-dir>
```

Verify sizes/readability. `persist`, `modemst*`, `fsg` are critical for calibration/modem.

## 4. Flash patched aboot

From the CVE-2019-2215 package, write `emmc_appsboot.mbn` to **both** slots:

```sh
adb push emmc_appsboot.mbn /sdcard/
adb shell su -c "dd if=/sdcard/emmc_appsboot.mbn of=/dev/block/bootdevice/by-name/aboot    bs=4096"
adb shell su -c "dd if=/sdcard/emmc_appsboot.mbn of=/dev/block/bootdevice/by-name/abootbak bs=4096"
adb shell su -c sync
```

**Do not patch `devinfo` without backups.**

## 5. Install TWRP

**Important:** flash TWRP **only to `recovery`**. Flashing TWRP to `boot` in this case caused a crash and DIAG 900E.

1. Boot into recovery or an environment where the partition can be written.
2. Flash a brotli-capable image (TWRP 3.0.2-2 gave `E1001`):

```sh
adb push twrp-3.4.0-1-markw.img /sdcard/twrp.img
adb shell "dd if=/sdcard/twrp.img of=/dev/block/bootdevice/by-name/recovery bs=4096"
adb shell sync
adb reboot recovery
```

3. After the system is installed, update to TWRP 3.7.0 (section 8).

## 6. Prepare data and install LineageOS

### 6.1 Remove encryption
`twrp wipe data` **did not remove encryption** here. Working method:

```sh
adb shell "mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata"
```

> This erases user data. `twrp format data` was not available.

### 6.2 Install ROM
```sh
adb push lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip /sdcard/
adb shell "twrp install /sdcard/lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip"
```

## 7. Install Magisk 26.1

### Why not `twrp install` for the APK
TWRP 3.4 reported:
- `Missing checksum file...`
- `E:Aborting zip install: Digest verification failed`

`twrp set tw_zipverify 0` **did not** disable verification.

### Working method: sideload
```sh
adb shell "twrp sideload"   # on device (TWRP)
adb sideload Magisk-v26.1.apk
```

Reboot, install/open the Magisk app if needed, and grant `su` requests.

**Note:** Magisk **v31.1** required Android 7.0+ and was unsuitable for Android 6; v26.1 was used successfully on Android 11 (LineageOS 18.1) in this path.

## 8. Update TWRP to 3.7.0

```powershell
$adb = "adb"
$img = "twrp_3.7.0_12-1-markw_by_SonicBSV_18_11_2023.img"
adb push $img /sdcard/twrp370.img
adb shell "dd if=/sdcard/twrp370.img of=/dev/block/bootdevice/by-name/recovery bs=4096"
adb shell sync
adb reboot recovery
adb shell getprop ro.twrp.version
```

Verify MD5 on PC and device. See [scripts/flash_twrp370.ps1](scripts/flash_twrp370.ps1).

## 9. Post-install verification

```sh
adb shell getprop sys.boot_completed
adb shell getprop ro.lineage.version
adb shell uname -r
adb shell getenforce
adb shell getprop gsm.sim.state
adb shell magisk -v
adb shell su -c id
```

Expected (in this run): `sys.boot_completed=1`, LineageOS 18.1, SELinux Enforcing, Magisk 26.1, `uid=0(root)` when granted. See [docs/en/verification.md](docs/en/verification.md).

## 10. Common issues

| Symptom | Cause / fix |
|---|---|
| `E1001` installing zip in TWRP 3.0.2-2 | No brotli support — use TWRP 3.4.0-1+ |
| `Digest verification failed` on `twrp install Magisk-v26.1.apk` | Use `adb sideload` (`twrp sideload`) |
| `adb wait-for-device` hangs in TWRP | Device state is `recovery`; poll `getprop`/`adb devices` |
| `twrp format data` missing | `mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata` |
| `twrp wipe data` doesn't remove encryption | Format userdata with `mke2fs` |
| TWRP flashed to `boot` → crash/DIAG 900E | Flash TWRP only to `recovery` |

## 11. Do not do

- Do not run `fastboot oem lock`.
- Do not reflash `aboot` without understanding rollback (post-install props may show `verifiedbootstate=green`, `flash.locked=1`, but lock commands are dangerous).
- Do not treat DIAG 900E as EDL 9008.

## 12. Links

- https://github.com/Begitdj/cve-2019-2215-markw
- https://xdaforums.com/t/xiaomi-redmi-4-prime-pro-unlock-bootloader-twrp-unofficially.3590006/
- https://xdaforums.com/t/guide-all-in-one-redmi-4-prime-markw-unlock-bootloader-flash-twrp-flash-rom.3587493/
- https://github.com/redispade/device_xiaomi_markw_twrp/releases/tag/twrp-3.4.0-1-markw
- https://androidfilehost.com/?fid=16385555061192795609
- https://androidfilehost.com/?w=files&flid=337507
- https://sourceforge.net/projects/recovery-for-xiaomi-devices/files/markw/OrangeFox-R12.0-Unofficial-markw.zip/download
- https://4pda.to/forum/index.php?showtopic=794653&view=findpost&p=144900003
- https://www.opendesktop.org/p/1344122/
- https://github.com/topjohnwu/Magisk/releases/tag/v26.1
- https://bigota.d.miui.com/V10.2.2.0.MBEMIXM/markw_global_images_V10.2.2.0.MBEMIXM_20190422.0000.00_6.0_global_7e9366b564.tgz
- https://github.com/bkerler/edl
- https://github.com/bkerler/edl/issues/505 
