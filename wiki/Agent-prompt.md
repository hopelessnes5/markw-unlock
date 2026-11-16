# Промпт для агента

Полный текст — в `prompts/AGENT_PROMPT.md`. Ключевые правила:

- **Не** предлагать `fastboot oem lock`, TWRP в `boot`, патч `devinfo` без бэкапов, «простые» EDL-инструкции при 900E.
- Последовательность: диагностика → CVE-2019-2215 root → бэкапы → патченный `aboot` в `aboot/abootbak` → TWRP в `recovery` → `mke2fs` userdata → `twrp install` ROM → Magisk через `twrp sideload` + `adb sideload` → TWRP 3.7.0 → верификация.
- Ловушки: `E1001` (нужен brotli-TWRP), digest Magisk (sideload), `adb wait-for-device` висит в TWRP (состояние `recovery`), `twrp wipe/format data` не решают шифрование как ожидалось.
- Всегда разделять проверенное и непроверенное, требовать бэкапы перед записью в разделы. 
