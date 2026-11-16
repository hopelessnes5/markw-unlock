# Troubleshooting

| Симптом | Решение |
|---|---|
| `E1001` в TWRP 3.0.2-2 | Использовать TWRP 3.4.0-1+ (brotli) |
| `Digest verification failed` (Magisk APK) | `twrp sideload` + `adb sideload Magisk-v26.1.apk` |
| `twrp format data` нет | `mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata` |
| Шифрование после wipe | Форматировать userdata через `mke2fs` |
| `adb wait-for-device` висит в TWRP | Ждать опросом `getprop ro.twrp.version`/`adb devices` (состояние `recovery`) |
| TWRP в `boot` → 900E | Писать TWRP только в `recovery` |
| `su` Permission denied при работающем Magisk | Установить/открыть APK Magisk и разрешить запрос |

Подробнее: `docs/troubleshooting.md`. 
