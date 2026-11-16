# What doesn't work / limitations

## Intentionally not used
- Official Mi Unlock, disassembly/testpoint
- `devinfo` patch without backups

## Did not work
- Dirty COW (kernel patched)
- `fastboot oem edl` → `device locked, oem edl is not allowed`
- DIAG 900E (crash dump): `qc_diag` unresponsive, no transition to 9008
- TWRP 3.0.2-2: `E1001` (no brotli)
- `twrp install Magisk-v26.1.apk`: `Digest verification failed` (sideload works)
- `twrp set tw_zipverify 0` — no effect
- `twrp format data` unavailable; `twrp wipe data` does not remove encryption
- TWRP in `boot` → crash/DIAG 900E
- Magisk v31.1 on Android 6: requires Android 7.0+
- `adb wait-for-device` hangs in TWRP (state `recovery`)

## Do not do
- `fastboot oem lock`
- Reflash `aboot` without backups/rollback understanding

Details: `docs/en/what-doesnt.md`, `research/en/diag-edl.md`. 
