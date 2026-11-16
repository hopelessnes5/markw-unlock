# Redmi 4 Prime (markw): разблокировка, LineageOS 18.1, Magisk, TWRP

Репозиторий фиксирует **реально пройденный** путь установки LineageOS 18.1 + Magisk + TWRP 3.7 на Xiaomi Redmi 4 Prime (`markw`) без официального Mi Unlock, без разборки/тестпоинта и без патча `devinfo` (без бэкапов критичных разделов такой патч опасен).

> ⚠️ Все операции с загрузчиком/разделами — на ваш риск. Неправильная прошивка `aboot`, блокировка загрузчика на несовместимом состоянии или потеря EFS/модема могут привести к «кирпичу». Делайте бэкапы и сверяйте контрольные суммы.

## Что в итоге работает

- LineageOS 18.1 Revived (`18.1-20260901-UNOFFICIAL-markw`, Android 11, ядро `4.9.337-Prototype-v7-Re-based`, SELinux Enforcing)
- Root: Magisk 26.1 (`su` работает, приложение Magisk установлено)
- Recovery: TWRP 3.7.0_12-1 (SonicBSV) в разделе `recovery`
- IMEI/baseband/SIM, Wi-Fi, камеры, звук — в рабочем состоянии

Подробности проверки — в [docs/verification.md](docs/verification.md).

## Рабочий маршрут (кратко)

1. **Временный root на стоке (Android 6)** через CVE-2019-2215 (эксплойт `bhsu98`) — получить `su` и доступ к записи разделов.
2. **Бэкапы** `aboot`, `abootbak`, `devinfo`, `persist`, `modemst1/2`, `fsg`, `splash` на ПК.
3. **Запись патченного `emmc_appsboot.mbn`** в `aboot` и `abootbak` (разблокировка fastboot/boot-проверок по пути CVE-2019-2215/markw).
4. **TWRP в `recovery`** (не в `boot`): сначала совместимый с brotli/установкой (3.4.0-1), затем обновление до 3.7.0.
5. **Форматирование data**: `mke2fs` по `/dev/block/bootdevice/by-name/userdata` (`twrp wipe data` шифрование не снимает).
6. **Установка LineageOS 18.1** через `twrp install`.
7. **Magisk 26.1 через `adb sideload`** (обычный `twrp install` на APK падал с `Digest verification failed`).
8. Первый запуск, установка APK Magisk, подтверждение запроса su.

Полная пошаговая инструкция с командами — [GUIDE.md](GUIDE.md).  
Промпт для агента-исполнителя — [prompts/AGENT_PROMPT.md](prompts/AGENT_PROMPT.md).

## Что не работает / ограничения

- Официальный Mi Unlock, разборка/тестпоинт — **не использовались** (осознанный отказ).
- Патч `devinfo` без бэкапов — **не делался**.
- `fastboot oem edl` на заблокированном состоянии: `device locked, oem edl is not allowed`.
- DIAG 900E в нашем случае — crash dump, `qc_diag` не отвечает; софт-перехода в 9008 не получено (QPST/QXDM boot не пишут).
- Dirty COW — не сработал (ядро патчено).
- TWRP 3.0.2-2 не распаковывает brotli (`E1001`).
- `twrp format data` как команда отсутствует; `twrp set tw_zipverify 0` не отключает digest-проверку ZIP — нужен sideload.
- TWRP, прошитый в `boot`, приводил к crash → DIAG 900E; рабочий вариант — TWRP в `recovery`.

Сводка — [docs/what-works.md](docs/what-works.md), [docs/what-doesnt.md](docs/what-doesnt.md), [docs/troubleshooting.md](docs/troubleshooting.md).

## Файлы и ссылки

- Контрольные суммы: [files/CHECKSUMS.md](files/CHECKSUMS.md)
- Скрипты (исправленные): [scripts/](scripts/)
- Собственные исследования: [research/](research/)
- Вики-страницы (для копирования в GitHub Wiki): [wiki/](wiki/)

Ключевые источники: [bhsu98/cve-2019-2215-markw](https://github.com/Begitdj/cve-2019-2215-markw), [XDA: unlock/TWRP unofficially](https://xdaforums.com/t/xiaomi-redmi-4-prime-pro-unlock-bootloader-twrp-unofficially.3590006/), [XDA: all-in-one guide](https://xdaforums.com/t/guide-all-in-one-redmi-4-prime-markw-unlock-bootloader-flash-twrp-flash-rom.3587493/), [TWRP 3.4.0-1 (markw)](https://github.com/redispade/device_xiaomi_markw_twrp/releases/tag/twrp-3.4.0-1-markw), [TWRP 3.7.0 SonicBSV](https://androidfilehost.com/?fid=16385555061192795609), [Magisk v26.1](https://github.com/topjohnwu/Magisk/releases/tag/v26.1).

## Структура репозитория

```
.
├── README.md
├── GUIDE.md                 # подробный гайд
├── docs/                    # доп. заметки и верификация
├── prompts/AGENT_PROMPT.md  # промпт для агента
├── research/                # исследования (DIAG/EDL, кнопки, ROM)
├── scripts/                 # исправленные скрипты
├── files/CHECKSUMS.md       # хэши и размеры
└── wiki/                    # страницы для GitHub Wiki
``` 
