# What Doesn't Work / Limitations

## Intentionally not used

- **Official Mi Unlock** — declined.
- **Disassembly / testpoint** — declined.
- **`devinfo` patch without backups** — declined (risk to partition/identity data).

## Did not work or not applicable

| Attempt / idea | Observation |
|---|---|
| Dirty COW for root | Did not work — kernel patched |
| `fastboot oem edl` | `device locked, oem edl is not allowed` |
| DIAG 900E → EDL 9008 via software | DIAG in crash-dump mode, `qc_diag.py` unresponsive; QPST/QXDM boot did not write; no software transition to 9008 |
| TWRP 3.0.2-2 for modern zips | `E1001` — no brotli support |
| `twrp install Magisk-v26.1.apk` | `Digest verification failed` (missing checksum file) |
| `twrp set tw_zipverify 0` | Did not disable digest verification in this scenario |
| `twrp format data` | Command unavailable in the environment used |
| `twrp wipe data` to remove encryption | Encryption not removed — `mke2fs` on userdata required |
| TWRP flashed to `boot` | Crash → DIAG 900E; **flash TWRP only to `recovery`** |
| Magisk v31.1 on Android 6 | `requires Android 7.0+` (v26.1 used for Android 11 in this path) |
| `adb wait-for-device` while in TWRP | Hangs because device state is `recovery` |

## Risks / prohibitions

- `fastboot oem lock` — **do not run**.
- Reflashing `aboot` after a successful setup — only with full rollback understanding and backups.
- Operations without backups of `persist/modemst/fsg/devinfo/aboot` — high risk of losing radio/calibration/boot.

## Method limitations

- Temporary root via CVE-2019-2215 applies to a vulnerable stock state (Android 6 in this case); different kernels/versions may behave differently.
- DIAG/EDL options depend on hardware/software state; no universal software unlock from 900E was found in this experience — see [research/en/diag-edl.md](../../research/en/diag-edl.md). 
