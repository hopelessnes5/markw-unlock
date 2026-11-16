# Что не работает / ограничения

## Не использовалось
- Официальный Mi Unlock, разборка/тестпоинт
- Патч `devinfo` без бэкапов

## Не сработало
- Dirty COW (ядро пропатчено)
- `fastboot oem edl` → `device locked, oem edl is not allowed`
- DIAG 900E (crash dump): `qc_diag` не отвечает, перехода в 9008 не получено
- TWRP 3.0.2-2: `E1001` (нет brotli)
- `twrp install Magisk-v26.1.apk`: `Digest verification failed` (sideload решает)
- `twrp set tw_zipverify 0` — не помогает
- `twrp format data` отсутствует; `twrp wipe data` шифрование не снимает
- TWRP в `boot` → crash/DIAG 900E
- Magisk v31.1 на Android 6: требует Android 7.0+
- `adb wait-for-device` в TWRP висит (состояние `recovery`)

## Нельзя
- `fastboot oem lock`
- Перепрошивать `aboot` без бэкапов/понимания отката

Подробно: `docs/what-doesnt.md`, `research/diag-edl.md`. 
