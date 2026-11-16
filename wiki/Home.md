# Redmi 4 Prime (markw) — Wiki

Эта вики фиксирует рабочий путь разблокировки/прошивки **Xiaomi Redmi 4 Prime (markw)** без официального Mi Unlock, без разборки/тестпоинта и без патча `devinfo` без бэкапов.

## Итоговая конфигурация (проверено)

- **LineageOS 18.1 Revived** (`18.1-20260901-UNOFFICIAL-markw`, Android 11)
- **Magisk 26.1** (root, `su` работает)
- **TWRP 3.7.0_12-1** в разделе `recovery`
- IMEI/baseband/SIM, Wi-Fi, камеры, звук — работают

## Быстрая навигация

- [Пошаговый гайд](Step-by-step-guide)
- [Что работает](What-works)
- [Что не работает](What-doesnt)
- [Troubleshooting](Troubleshooting)
- [Файлы и контрольные суммы](Files-and-checksums)
- [Исследования](Research-notes)
- [Промпт для агента](Agent-prompt)

## Важные предупреждения

- Все операции — на ваш риск. Делайте бэкапы `aboot/abootbak/devinfo/persist/modemst1/modemst2/fsg/splash`.
- **TWRP — только в `recovery`** (запись в `boot` приводила к crash/DIAG 900E).
- **Не делать `fastboot oem lock`** и не перепрошивать `aboot` без понимания.
- DIAG 900E ≠ EDL 9008.

Основной репозиторий содержит полные документы: `README.md`, `GUIDE.md`, `docs/`, `research/`, `scripts/`, `prompts/AGENT_PROMPT.md`. 
