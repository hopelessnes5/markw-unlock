param(
    [string]$Adb = "adb",
    [string]$Apk = "$env:USERPROFILE\Tools\markw\2215\Magisk-v26.1.apk"
)

# Установка Magisk через sideload в TWRP (обходит Digest verification failed при twrp install).
# Требования: устройство в TWRP, USB-отладка/ADB доступен (состояние recovery/sideload).

$ErrorActionPreference = 'Continue'

if (-not (Test-Path $Apk)) {
    Write-Error "APK not found: $Apk"
    exit 1
}

$push = (& $Adb push $Apk /sdcard/Magisk-v26.1.apk 2>&1 | Out-String)
Write-Output $push.Trim()

# Проверка наличия TWRP (не используем wait-for-device — в TWRP состояние recovery)
$v = (& $Adb shell getprop ro.twrp.version 2>&1 | Out-String).Trim()
if ($v -notmatch '3\.') {
    Write-Warning "TWRP version not detected (got: '$v'). Убедитесь, что устройство в TWRP."
}

Write-Output "Starting sideload on device..."
& $Adb shell 'twrp sideload' 2>&1 | Out-String | Write-Output
Start-Sleep -Seconds 3

Write-Output "adb sideload $Apk"
$sideload = (& $Adb sideload $Apk 2>&1 | Out-String)
Write-Output $sideload.Trim()

Write-Output "Проверьте /tmp/recovery.log и наличие /data/adb/magisk, затем перезагрузитесь: adb reboot" 
