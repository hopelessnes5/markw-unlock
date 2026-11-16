param(
    [string]$Adb = "adb",
    [string]$Image = "O:\markw\twrp_3.7.0_12-1-markw_by_SonicBSV_18_11_2023.img"
)

$ErrorActionPreference = 'Continue'

if (-not (Test-Path $Image)) {
    Write-Error "Image not found: $Image"
    exit 1
}

$localMd5 = (Get-FileHash $Image -Algorithm MD5).Hash.ToLower()
Write-Output "local md5: $localMd5"

& $Adb push $Image /sdcard/twrp370.img 2>&1 | Out-String | Write-Output
$devMd5Line = (& $Adb shell md5sum /sdcard/twrp370.img 2>&1 | Out-String).Trim()
Write-Output "device md5: $devMd5Line"
if ($devMd5Line -notmatch $localMd5) {
    Write-Error "MD5 MISMATCH - aborting"
    exit 1
}

& $Adb shell 'dd if=/sdcard/twrp370.img of=/dev/block/bootdevice/by-name/recovery bs=4096; sync; echo WROTE_RECOVERY' 2>&1
& $Adb reboot recovery 2>&1
Start-Sleep -Seconds 8

$v = ''
for ($i = 0; $i -lt 45; $i++) {
    $v = (& $Adb shell getprop ro.twrp.version 2>$null | Out-String).Trim()
    if ($v -match '3\.') { break }
    Start-Sleep -Seconds 2
}
Write-Output "TWRP now: $v"

& $Adb reboot 2>&1
Start-Sleep -Seconds 8

$ok = $false
for ($i = 0; $i -lt 300; $i++) {
    $bc = (& $Adb shell getprop sys.boot_completed 2>$null | Out-String).Trim()
    if ($bc -eq '1') { $ok = $true; break }
    Start-Sleep -Seconds 2
}
Write-Output "boot_completed=$ok after $($i * 2)s"
if ($ok) {
    & $Adb shell 'getprop ro.lineage.version; getprop sys.boot_completed' 2>&1
}
