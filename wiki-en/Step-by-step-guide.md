# Step-by-step guide

Short sequence (full version in `GUIDE.en.md`).

## 0. Preparation
- Backups, drivers, platform-tools, verified images (see [Files and checksums](Files-and-checksums)).
- Risk: permanent brick possible. Do not run `fastboot oem lock`.

## 1. Temporary root (stock Android 6)
- CVE-2019-2215 exploit (bhsu98, markw): https://github.com/Begitdj/cve-2019-2215-markw
- Dirty COW did not work. Goal: `su` for partition read/write.

## 2. Backups (to PC)
Dump: `aboot`, `abootbak`, `devinfo`, `persist`, `modemst1`, `modemst2`, `fsg`, `splash`.

## 3. Patched aboot
Write `emmc_appsboot.mbn` to `aboot` and `abootbak` (`dd`, `bs=4096`, `sync`). Do not patch `devinfo` without backups.

## 4. TWRP in recovery
- Flash TWRP **only to `/dev/block/bootdevice/by-name/recovery`**.
- For ROM install: TWRP 3.4.0-1 (brotli). TWRP 3.0.2-2 → `E1001`.
- **Do not** flash TWRP to `boot` (risk of crash → DIAG 900E).

## 5. Format data
```sh
mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata
```
`twrp wipe data` does not remove encryption; `twrp format data` is unavailable.

## 6. Install LineageOS 18.1
```sh
adb shell "twrp install /sdcard/lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip"
```

## 7. Magisk 26.1 (sideload)
```sh
adb shell "twrp sideload"
adb sideload Magisk-v26.1.apk
```
`twrp install` on APK → `Digest verification failed`; `twrp set tw_zipverify 0` does not help.

## 8. Update TWRP to 3.7.0
`dd` `twrp_3.7.0_12-1-markw_by_SonicBSV_18_11_2023.img` to `recovery`, verify `getprop ro.twrp.version`.

## 9. First boot
Install/open Magisk APK, grant `su`. Verify: `sys.boot_completed`, `ro.lineage.version`, `magisk -v`, `su -c id`. See [Verification](Verification). 
