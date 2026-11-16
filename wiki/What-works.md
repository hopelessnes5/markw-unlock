# Что работает

## Конфигурация
- LineageOS 18.1 Revived (`18.1-20260901-UNOFFICIAL-markw`, Android 11)
- Ядро `4.9.337-Prototype-v7-Re-based`, SELinux Enforcing
- Magisk 26.1 (`26.1:MAGISK:R`, `uid=0(root) context=u:r:magisk:s0`)
- TWRP 3.7.0_12-1 (SonicBSV) в `recovery`

## Проверки
- IMEI/baseband/SIM в норме
- Wi-Fi, 2 камеры, звук, батарея — работают
- ~24 ГБ на `/data` после чистой установки

## Рабочие приёмы
- CVE-2019-2215 (bhsu98) для временного root на стоке Android 6
- TWRP в `recovery` (не в `boot`), `dd bs=4096`
- Формат data: `mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata`
- ROM: `twrp install <zip>`
- Magisk: `twrp sideload` + `adb sideload Magisk-v26.1.apk`
- В TWRP состояние ADB — `recovery` (не `wait-for-device`), ждать опросом `getprop`

Подробно: `docs/what-works.md`, `docs/verification.md`. 
