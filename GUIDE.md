# Подробный гайд: Redmi 4 Prime (markw)

Гайд описывает путь, реально пройденный на устройстве: сток MIUI 10 (Android 6, `MBEMIXM`) → временный root (CVE-2019-2215) → патченный `aboot` → TWRP → LineageOS 18.1 → Magisk 26.1. Официальный Mi Unlock, разборка/тестпоинт и патч `devinfo` не использовались.

## 0. Предупреждения

- **Риск необратимой поломки.** Ошибки с `aboot/boot/recovery`, `fastboot oem lock` или потеря EFS/модема могут сделать телефон неремонтируемым без EDL/программатора.
- **Бэкапы обязательны** перед записью в разделы: `aboot`, `abootbak`, `devinfo`, `persist`, `modemst1`, `modemst2`, `fsg`, `splash`.
- **Не выполняйте `fastboot oem lock`** после установки кастома с данным методом.
- **Не перепрошивайте `aboot`** обратно после успешной разблокировки/установки, если не понимаете последствий.
- Сверяйте **MD5/SHA256** образов ([files/CHECKSUMS.md](files/CHECKSUMS.md)).

## 1. Что потребуется

### ПО на ПК
- Windows + PowerShell (путь пройден на Windows), `adb`/`fastboot` (platform-tools).
- Драйверы ADB/USB (при необходимости Qualcomm/fastboot).
- Git (опционально, для ведения заметок).

### Файлы
- Эксплойт/пакет CVE-2019-2215 для markw: [bhsu98/cve-2019-2215-markw](https://github.com/Begitdj/cve-2019-2215-markw) (включает `emmc_appsboot.mbn` для записи в `aboot`).
- TWRP 3.4.0-1 (markw, совместим с установкой ROM): [redispade release](https://github.com/redispade/device_xiaomi_markw_twrp/releases/tag/twrp-3.4.0-1-markw) — SHA256 `0fd837a1…`.
- TWRP 3.7.0_12-1 (SonicBSV, 18.11.2023): [AFH fid=16385555061192795609](https://androidfilehost.com/?fid=16385555061192795609) — MD5 `bdbe82be…`.
- LineageOS 18.1 Revived (UNOFFICIAL markw, 2026-09-01): `lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip` — MD5 `6d0b3b3f…`, SHA256 `35981941…` (854 946 797 байт). Источник сборки — уточнить у мейнтейнера/зеркала, откуда скачан ваш zip.
- Magisk v26.1 (подходит для Android 11 и 6.0.1): [GitHub release v26.1](https://github.com/topjohnwu/Magisk/releases/tag/v26.1) — SHA256 `ae1a02b1…`.
- (Справочно) Сток: [MIUI V10.2.2.0.MBEMIXM fastboot tgz](https://bigota.d.miui.com/V10.2.2.0.MBEMIXM/markw_global_images_V10.2.2.0.MBEMIXM_20190422.0000.00_6.0_global_7e9366b564.tgz), MD5 `7e9366b564…`.

### Кнопки/режимы markw
- **Fastboot:** Vol Down + Power.
- **Recovery:** Vol Up + Power (иногда требуется без USB; поведение может отличаться).
- **MI-Recovery (3 кнопки):** Vol Up + Vol Down + Power — не обходит подписи кастомного recovery.

## 2. Временный root (CVE-2019-2215)

Цель: получить root на стоке Android 6 для чтения/записи разделов. Использован эксплойт из [cve-2019-2215-markw](https://github.com/Begitdj/cve-2019-2215-markw) (`bhsu98`).

- Dirty COW на данном ядре **не сработал** (ядро пропатчено).
- Следуйте README эксплойта: включить отладку, собрать/запустить бинарь, убедиться в `uid=0` через `adb shell`.
- Root временный (до перезагрузки в зависимости от метода) — успеть снять бэкапы и записать `aboot`.

> Детали сборки/запуска зависят от версии пакета эксплойта; в репозитории фиксируется факт применения, а не перепаковка чужого кода.

## 3. Бэкапы (обязательно)

С root-доступом снять образы разделов на ПК (пути by-name типичны для 8953/markw):

```sh
adb shell su -c "dd if=/dev/block/bootdevice/by-name/aboot    of=/sdcard/aboot.orig    bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/abootbak of=/sdcard/abootbak.orig bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/devinfo  of=/sdcard/devinfo.orig  bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/persist  of=/sdcard/persist.img   bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/modemst1 of=/sdcard/modemst1.img  bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/modemst2 of=/sdcard/modemst2.img  bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/fsg      of=/sdcard/fsg.img       bs=4096"
adb shell su -c "dd if=/dev/block/bootdevice/by-name/splash   of=/sdcard/splash.img    bs=4096"
adb pull /sdcard/aboot.orig /sdcard/abootbak.orig /sdcard/devinfo.orig /sdcard/persist.img /sdcard/modemst1.img /sdcard/modemst2.img /sdcard/fsg.img /sdcard/splash.img <папка-бэкапов-на-ПК>
```

Проверьте размеры/читаемость. `persist`, `modemst*`, `fsg` критичны для калибровок/модема.

## 4. Запись патченного aboot

Из пакета CVE-2019-2215 (каталог с `miflshaboot/images/emmc_appsboot.mbn` в использованном наборе) записать в **оба** слота A/B-аналога:

```sh
adb push emmc_appsboot.mbn /sdcard/
adb shell su -c "dd if=/sdcard/emmc_appsboot.mbn of=/dev/block/bootdevice/by-name/aboot    bs=4096"
adb shell su -c "dd if=/sdcard/emmc_appsboot.mbn of=/dev/block/bootdevice/by-name/abootbak bs=4096"
adb shell su -c sync
```

Перезагрузка/проверка fastboot — по результатам вашего набора. **Не патчить `devinfo` без бэкапов.**

## 5. Установка TWRP

**Важно:** TWRP писать **только в `recovery`**. Прошивка TWRP в `boot` в нашем случае привела к crash и режиму DIAG 900E.

1. Загрузиться в recovery (стоковое/существующее) или в среду, откуда доступна запись раздела.
2. Прошить совместимый образ (для установки ROM нужен TWRP, умеющий brotli; 3.0.2-2 давал `E1001`):

```sh
adb push twrp-3.4.0-1-markw.img /sdcard/twrp.img
adb shell "dd if=/sdcard/twrp.img of=/dev/block/bootdevice/by-name/recovery bs=4096"
adb shell sync
adb reboot recovery
```

3. После установки системы обновить до TWRP 3.7.0 (см. раздел 8).

## 6. Подготовка data и установка LineageOS

### 6.1 Снятие шифрования
`twrp wipe data` в нашем случае **не снимал шифрование**. Рабочий способ — форматирование раздела:

```sh
adb shell "mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata"
```

> Это уничтожает данные пользователя. `twrp format data` как команда в используемой среде отсутствовала.

### 6.2 Установка ROM
- Скопировать `lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip` на телефон/SD.
- В TWRP: Wipe (cache/dalvik при необходимости) + Install zip.

Через CLI:
```sh
adb push lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip /sdcard/
adb shell "twrp install /sdcard/lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip"
```

## 7. Установка Magisk 26.1

### Почему не `twrp install` для APK
TWRP 3.4 при установке APK как zip выдавал:
- `Отсутствует файл контрольной суммы...`
- `E:Aborting zip install: Digest verification failed`

`twrp set tw_zipverify 0` **не отключил** проверку.

### Рабочий способ: sideload
```sh
# в TWRP запустить режим sideload
adb shell "twrp sideload"
# с ПК
adb sideload Magisk-v26.1.apk
```

После установки — перезагрузка в систему, установка APK Magisk (если нужно UI), подтверждение запроса `su` от shell/приложений.

**Важно:** Magisk **v31.1** требовал Android 7.0+ (`requires Android 7.0+`) и не подходил для Android 6; для Android 11 (LineageOS 18.1) в нашем пути использован **v26.1**. APK Magisk нужен для обработки запросов суперпользователя.

## 8. Обновление TWRP до 3.7.0

После загрузки в систему (с root) или из recovery:

```powershell
$adb = "adb"
$img = "twrp_3.7.0_12-1-markw_by_SonicBSV_18_11_2023.img"
adb push $img /sdcard/twrp370.img
adb shell "dd if=/sdcard/twrp370.img of=/dev/block/bootdevice/by-name/recovery bs=4096"
adb shell sync
adb reboot recovery
# проверить версию
adb shell getprop ro.twrp.version
```

Сверить MD5 на ПК и устройстве (`md5sum`). Пример скрипта — [scripts/flash_twrp370.ps1](scripts/flash_twrp370.ps1).

## 9. Проверка после установки

```sh
adb shell getprop sys.boot_completed
adb shell getprop ro.lineage.version
adb shell uname -r
adb shell getenforce
adb shell getprop gsm.sim.state
adb shell magisk -v
adb shell su -c id
```

Ожидаемо (по нашему прогону): `sys.boot_completed=1`, LineageOS 18.1, SELinux Enforcing, Magisk 26.1, `uid=0(root)` при разрешении в приложении.

См. [docs/verification.md](docs/verification.md).

## 10. Типичные ошибки и нюансы

| Симптом | Причина/решение |
|---|---|
| `E1001` при установке zip в TWRP 3.0.2-2 | Нет поддержки brotli — использовать TWRP 3.4.0-1+ |
| `Digest verification failed` при `twrp install Magisk-v26.1.apk` | Ставить через `adb sideload` (в TWRP: `twrp sideload`) |
| `adb wait-for-device` висит, пока телефон в TWRP | В TWRP устройство в состоянии `recovery`; ждать по `adb shell getprop` в цикле или `adb devices` |
| `twrp format data` не найдена | Использовать `mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata` |
| `twrp wipe data` не убирает шифрование | Форматировать userdata через `mke2fs` |
| После прошивки TWRP в `boot` — crash/DIAG 900E | Прошивать TWRP только в `recovery` |

## 11. Чего не делать

- Не делать `fastboot oem lock`.
- Не перепрошивать `aboot` без понимания (после установки видны `ro.boot.verifiedbootstate=green`, `ro.boot.flash.locked=1` — это нормально для данной конфигурации, но lock-команды опасны).
- Не считать DIAG 900E эквивалентом EDL 9008: в нашем случае `qc_diag` не отвечал, `fastboot oem edl` запрещён (`device locked`).

## 12. Ссылки

- https://github.com/Begitdj/cve-2019-2215-markw
- https://xdaforums.com/t/xiaomi-redmi-4-prime-pro-unlock-bootloader-twrp-unofficially.3590006/
- https://xdaforums.com/t/guide-all-in-one-redmi-4-prime-markw-unlock-bootloader-flash-twrp-flash-rom.3587493/
- https://github.com/redispade/device_xiaomi_markw_twrp/releases/tag/twrp-3.4.0-1-markw
- https://androidfilehost.com/?fid=16385555061192795609 (TWRP 3.7.0_12-1, 18.11.2023)
- https://androidfilehost.com/?w=files&flid=337507
- https://sourceforge.net/projects/recovery-for-xiaomi-devices/files/markw/OrangeFox-R12.0-Unofficial-markw.zip/download
- https://4pda.to/forum/index.php?showtopic=794653&view=findpost&p=144900003
- https://www.opendesktop.org/p/1344122/
- https://github.com/topjohnwu/Magisk/releases/tag/v26.1
- https://bigota.d.miui.com/V10.2.2.0.MBEMIXM/markw_global_images_V10.2.2.0.MBEMIXM_20190422.0000.00_6.0_global_7e9366b564.tgz
- https://github.com/bkerler/edl
- https://github.com/bkerler/edl/issues/505
