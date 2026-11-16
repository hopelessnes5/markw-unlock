# File Checksums

Verify images before flashing: `Get-FileHash <file> -Algorithm SHA256` (PowerShell) or `sha256sum <file>`.

| File | Size (bytes) | MD5 | SHA256 |
|---|---:|---|---|
| `lineage-rev-18.1-20260901-UNOFFICIAL-markw.zip` | 854946797 | `6D0B3B3F0DFC09CFE3A883B3CA947E27` | `359819415B14B3785036ED1E64281FAFB275DCB0B6384EEE92440B2BB3CF4C86` |
| `twrp_3.7.0_12-1-markw_by_SonicBSV_18_11_2023.img` | 36519936 | `BDBE82BE15D2A0057B5CA77F3BEE242B` | `D28E68061EF87E2CDC66070D8CD175712F3E0FABA341DF965775BFC917372A00` |
| `twrp-3.4.0-1-markw.img` | 36118528 | `A410F492425FC521422EC93AF03DD2FA` | `0FD837A1FF2A34A23AB746A182AB3401A093388402D7AE78D52DD9619330CDEE` |
| `Magisk-v26.1.apk` | 11411692 | `6794A570B8EBFBAA5F596EDA3639EF56` | `AE1A02B1AB608A51D5BC9B323E0588D06D30D9987AC8DA01F4710D76F705DCCB` |
| `Magisk-v31.1.apk` (not for Android 6/11 in this path — see guide) | 10679283 | `47976DF1A67877E4A46886D8CF664845` | `89CEFAC0A318AFA39FB3880C45C87B036C05BC1EBF02A7A715B7F8D7C26AC6E7` |

## Stock ROM (reference)

| File | MD5 | Source |
|---|---|---|
| `markw_global_images_V10.2.2.0.MBEMIXM_20190422.0000.00_6.0_global_7e9366b564.tgz` | `7e9366b5647da312547c22e7f4ce228d` | [Xiaomi BigOTA](https://bigota.d.miui.com/V10.2.2.0.MBEMIXM/markw_global_images_V10.2.2.0.MBEMIXM_20190422.0000.00_6.0_global_7e9366b564.tgz) |

## Partition backups (taken from the device before patching, not published)

Device-specific and contain unique data (EFS/modem/calibration). Keep locally:

- `devinfo.img` — 1,048,576 bytes
- `fsg.img` — 1,572,864 bytes
- `modemst1.img` — 1,572,864 bytes
- `modemst2.img` — 1,572,864 bytes
- `persist.img` — 33,554,432 bytes
- `splash.img` — 20,971,520 bytes
- `aboot.orig`, `abootbak.orig`, `devinfo.orig` — before writing patched `emmc_appsboot.mbn` 
