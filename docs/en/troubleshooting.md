# Troubleshooting

## TWRP / installation

### `E1001` when installing a zip (TWRP 3.0.2-2)
**Cause:** no brotli support.  
**Fix:** use TWRP 3.4.0-1 or newer (for markw). Ensure the image is flashed to `recovery`, not `boot`.

### `Digest verification failed` on `twrp install Magisk-v26.1.apk`
**Cause:** TWRP expects a checksum file not present alongside the APK. `twrp set tw_zipverify 0` did not help here.  
**Fix:** sideload:
```sh
adb shell "twrp sideload"   # in TWRP
adb sideload Magisk-v26.1.apk
```

### `twrp format data` not found
**Fix:** format userdata manually:
```sh
adb shell "mke2fs -t ext4 -m 0 -L data /dev/block/bootdevice/by-name/userdata"
```

### `twrp wipe data` does not remove encryption
**Fix:** same — `mke2fs` on `/dev/block/bootdevice/by-name/userdata`. This wipes user data.

### `adb wait-for-device` hangs while the phone is in TWRP
**Cause:** `adb devices` reports state `recovery`, not `device`.  
**Fix:** do not rely on `wait-for-device`; poll instead:
```powershell
for ($i=0; $i -lt 60; $i++) {
  $v = (& adb shell getprop ro.twrp.version 2>$null | Out-String).Trim()
  if ($v -match '3\.') { break }
  Start-Sleep -Seconds 2
}
```

### After flashing TWRP to `boot` — crash / device enters DIAG 900E
**Cause:** wrong target partition for this scenario.  
**Fix:** flash TWRP **only** to `recovery`. Recovery from 900E may be non-trivial (see [research/en/diag-edl.md](../../research/en/diag-edl.md)).

## Magisk

### `su -c id` → `Permission denied` but `magisk -v` shows a version
**Cause:** superuser request auto-denied without UI.  
**Fix:** install the Magisk APK, open it, retry the request, and tap Grant.

### Magisk v31.1 won't install on Android 6
**Cause:** requires Android 7.0+.  
**Fix:** use v26.1 (verified in this path; also used on Android 11 here).

### `adb push` writes to stderr and PowerShell treats it as an error
**Cause:** adb progress can land in the error stream.  
**Fix:** capture as text (`2>&1 | Out-String`) and verify the actual result (e.g. `md5sum` on device).

## EDL / DIAG

### `fastboot oem edl` → `device locked, oem edl is not allowed`
Locked state prevents a software entry to EDL via fastboot.

### Device in 900E (Qualcomm HS-USB Diagnostics 900E)
In this case it was a crash dump; `qc_diag.py` did not respond and no transition to 9008 was achieved. Do not confuse 900E with 9008. See [research/en/diag-edl.md](../../research/en/diag-edl.md).

## Safety

- Do not run `fastboot oem lock`.
- Do not reflash `aboot` or critical partitions without verified backups.
- Always verify MD5/SHA256 before `dd`. 
