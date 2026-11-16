# Troubleshooting

## TWRP / установка

### `E1001` при установке zip (TWRP 3.0.2-2)
**Причина:** нет поддержки brotli.  
**Решение:** использовать TWRP 3.4.0-1 или новее (для markw). Убедиться, что образ записан в `recovery`, не в `boot`.

### `Digest verification failed` при `twrp install Magisk-v26.1.apk`
**Причина:** TWRP требует контрольную сумму, которой нет рядом с APK. `twrp set tw_zipverify 0` в нашем опыте не помог.  
**Решение:** sideload:
```sh
adb shell "twrp sideload"   # на устройстве в TWRP
adb sideload Magisk-v26.1.apk
```

### `twrp format data` — команда не найдена
**Решение:** форматировать userdata вручную:
```sh
adb shell "mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata"
```

### `twrp wipe data` не снимает шифрование
**Решение:** то же — `mke2fs` по `/dev/block/bootdevice/by-name/userdata`. Учтите полную потерю данных.

### `adb wait-for-device` висит, хотя телефон в TWRP
**Причина:** `adb devices` показывает состояние `recovery`, а не `device`.  
**Решение:** не использовать `wait-for-device` без учёта состояния; опрашивать в цикле:
```powershell
for ($i=0; $i -lt 60; $i++) {
  $v = (& adb shell getprop ro.twrp.version 2>$null | Out-String).Trim()
  if ($v -match '3\.') { break }
  Start-Sleep -Seconds 2
}
```

### После прошивки TWRP в `boot` — crash / устройство уходит в DIAG 900E
**Причина:** неверный раздел для данного сценария.  
**Решение:** прошивать TWRP **только** в `recovery`. Восстановление из 900E до рабочего состояния может быть нетривиальным (см. [research/diag-edl.md](../research/diag-edl.md)).

## Magisk

### `su -c id` → `Permission denied`, но `magisk -v` показывает версию
**Причина:** запрос суперпользователя отклонён автоматически без UI.  
**Решение:** установить APK Magisk, открыть его, повторить запрос и нажать «Разрешить».

### Magisk v31.1 не устанавливается на Android 6
**Причина:** требует Android 7.0+.  
**Решение:** использовать v26.1 (проверено в этом пути; для Android 11 также использован v26.1).

### `adb push` пишет в stderr, PowerShell считает это ошибкой
**Причина:** progress adb может попадать в error stream.  
**Решение:** перенаправлять/обрабатывать вывод как текст (`2>&1 | Out-String`) и проверять фактический результат (`md5sum` на устройстве).

## EDL / DIAG

### `fastboot oem edl` → `device locked, oem edl is not allowed`
Заблокированное состояние не позволяет программный вход в EDL через fastboot.

### Устройство в 900E (Qualcomm HS-USB Diagnostics 900E)
В нашем случае это crash dump, `qc_diag.py` не отвечает, софт-перехода в 9008 не получено. Не путать 900E с 9008. Подробности — [research/diag-edl.md](../research/diag-edl.md).

## Безопасность

- Не выполнять `fastboot oem lock`.
- Не перепрошивать `aboot`/критичные разделы без проверенных бэкапов.
- Всегда сверять MD5/SHA256 образов перед `dd`. 
