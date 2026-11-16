# Пошаговый гайд

Краткая последовательность (полная версия — `GUIDE.md` в репозитории).

## 0. Подготовка
- Бэкапы, драйверы, platform-tools, проверенные образы (см. [Files-and-checksums](Files-and-checksums)).
- Риск: можно получить «кирпич». Не делать `fastboot oem lock`.

## 1. Временный root (сток Android 6)
- Эксплойт CVE-2019-2215 (bhsu98, markw): https://github.com/Begitdj/cve-2019-2215-markw
- Dirty COW не сработал. Цель — `su` для чтения/записи разделов.

## 2. Бэкапы (на ПК)
Снять: `aboot`, `abootbak`, `devinfo`, `persist`, `modemst1`, `modemst2`, `fsg`, `splash`.

## 3. Патченный aboot
Записать `emmc_appsboot.mbn` в `aboot` и `abootbak` (`dd`, `bs=4096`, `sync`). Не патчить `devinfo` без бэкапов.

## 4. TWRP в recovery
- Прошить TWRP **только в `/dev/block/bootdevice/by-name/recovery`**.
- Для установки ROM: TWRP 3.4.0-1 (brotli). TWRP 3.0.2-2 → `E1001`.
- **Не** прошивать TWRP в `boot` (риск crash → DIAG 900E).

## 5. Формат data
```sh
mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata
```
`twrp wipe data` шифрование не снимает; `twrp format data` отсутствует.

## 6. Установка LineageOS 18.1
```sh
adb shell "twrp install /sdcard/lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip"
```

## 7. Magisk 26.1 (sideload)
```sh
adb shell "twrp sideload"
adb sideload Magisk-v26.1.apk
```
`twrp install` APK → `Digest verification failed`; `twrp set tw_zipverify 0` не помогает.

## 8. Обновление TWRP до 3.7.0
`dd` образа `twrp_3.7.0_12-1-markw_by_SonicBSV_18_11_2023.img` в `recovery`, проверить `getprop ro.twrp.version`.

## 9. Первый запуск
Установить APK Magisk, разрешить `su`. Проверить: `sys.boot_completed`, `ro.lineage.version`, `magisk -v`, `su -c id`. См. [Verification](Verification). 
