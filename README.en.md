# Redmi 4 Prime (markw): Unlock, LineageOS 18.1, Magisk, TWRP

**Русская версия:** [README.md](README.md) · [GUIDE.md](GUIDE.md) · [docs/](docs/) · [wiki/](wiki/) · [prompts/AGENT_PROMPT.md](prompts/AGENT_PROMPT.md)

This repository documents a **real, completed** path to install LineageOS 18.1 + Magisk + TWRP 3.7 on Xiaomi Redmi 4 Prime (`markw`) without official Mi Unlock, without disassembly/testpoint, and without patching `devinfo` (patching it without backups is risky).

> ⚠️ All bootloader/partition operations are at your own risk. Writing the wrong image to `aboot`, locking the bootloader in an incompatible state, or losing EFS/modem data can brick the device. Make backups and verify checksums.

## What works (verified)

- LineageOS 18.1 Revived (`18.1-20260901-UNOFFICIAL-markw`, Android 11, kernel `4.9.337-Prototype-v7-Re-based`, SELinux Enforcing)
- Root: Magisk 26.1 (`su` works, Magisk app installed)
- Recovery: TWRP 3.7.0_12-1 (SonicBSV) in the `recovery` partition
- IMEI/baseband/SIM, Wi-Fi, cameras, audio — functional

Details: [docs/en/verification.md](docs/en/verification.md).

## Working route (summary)

1. **Temporary root on stock (Android 6)** via CVE-2019-2215 (`bhsu98`) to gain `su` and partition write access.
2. **Backups** of `aboot`, `abootbak`, `devinfo`, `persist`, `modemst1/2`, `fsg`, `splash` to PC.
3. **Flash patched `emmc_appsboot.mbn`** to `aboot` and `abootbak`.
4. **TWRP in `recovery` only** (not `boot`): start with a brotli-capable/ROM-installable build (3.4.0-1), then update to 3.7.0.
5. **Format data** with `mke2fs` on `/dev/block/bootdevice/by-name/userdata` (`twrp wipe data` did not remove encryption).
6. **Install LineageOS 18.1** via `twrp install`.
7. **Magisk 26.1 via `adb sideload`** (regular `twrp install` on the APK failed with `Digest verification failed`).
8. First boot, install Magisk APK, grant `su`.

Full step-by-step guide: [GUIDE.en.md](GUIDE.en.md).  
Agent prompt: [prompts/AGENT_PROMPT.en.md](prompts/AGENT_PROMPT.en.md).

## What doesn't work / limitations

- Official Mi Unlock, disassembly/testpoint — **not used** (intentional).
- `devinfo` patch without backups — **not done**.
- `fastboot oem edl` while locked: `device locked, oem edl is not allowed`.
- DIAG 900E in this case was a crash-dump state; `qc_diag` did not respond and no software transition to 9008 was achieved (QPST/QXDM boot did not write).
- Dirty COW — did not work (kernel patched).
- TWRP 3.0.2-2 cannot unpack brotli (`E1001`).
- `twrp format data` command not available; `twrp set tw_zipverify 0` did not disable digest verification — sideload required.
- TWRP flashed to `boot` caused a crash → DIAG 900E; the working setup is TWRP in `recovery`.

See [docs/en/what-works.md](docs/en/what-works.md), [docs/en/what-doesnt.md](docs/en/what-doesnt.md), [docs/en/troubleshooting.md](docs/en/troubleshooting.md).

## Files and links

- Checksums: [files/CHECKSUMS.md](files/CHECKSUMS.md)
- Scripts (fixed): [scripts/](scripts/)
- Research notes: [research/en/](research/en/)
- English wiki pages: [wiki-en/](wiki-en/)

Key sources: [bhsu98/cve-2019-2215-markw](https://github.com/Begitdj/cve-2019-2215-markw), [XDA: unlock/TWRP unofficially](https://xdaforums.com/t/xiaomi-redmi-4-prime-pro-unlock-bootloader-twrp-unofficially.3590006/), [XDA: all-in-one guide](https://xdaforums.com/t/guide-all-in-one-redmi-4-prime-markw-unlock-bootloader-flash-twrp-flash-rom.3587493/), [TWRP 3.4.0-1 (markw)](https://github.com/redispade/device_xiaomi_markw_twrp/releases/tag/twrp-3.4.0-1-markw), [TWRP 3.7.0 SonicBSV](https://androidfilehost.com/?fid=16385555061192795609), [Magisk v26.1](https://github.com/topjohnwu/Magisk/releases/tag/v26.1). 
