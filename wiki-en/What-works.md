# What works

## Configuration
- LineageOS 18.1 Revived (`18.1-20260901-UNOFFICIAL-markw`, Android 11)
- Kernel `4.9.337-Prototype-v7-Re-based`, SELinux Enforcing
- Magisk 26.1 (`26.1:MAGISK:R`, `uid=0(root) context=u:r:magisk:s0`)
- TWRP 3.7.0_12-1 (SonicBSV) in `recovery`

## Checks
- IMEI/baseband/SIM OK
- Wi-Fi, 2 cameras, audio, battery — working
- ~24 GB on `/data` after clean install

## Working techniques
- CVE-2019-2215 (bhsu98) for temporary root on stock Android 6
- TWRP in `recovery` (not `boot`), `dd bs=4096`
- Format data: `mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata`
- ROM: `twrp install <zip>`
- Magisk: `twrp sideload` + `adb sideload Magisk-v26.1.apk`
- In TWRP ADB state is `recovery` (not `wait-for-device`); wait by polling `getprop`

Details: `docs/en/what-works.md`, `docs/en/verification.md`. 
