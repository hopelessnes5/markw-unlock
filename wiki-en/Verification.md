# Verification

## Expected checkpoints
- `sys.boot_completed` = `1`
- `ro.lineage.version` = `18.1-20260901-UNOFFICIAL-markw`
- `uname -r` = `4.9.337-Prototype-v7-Re-based`, `getenforce` = `Enforcing`
- `magisk -v` = `26.1:MAGISK:R`
- `su -c id` = `uid=0(root)... context=u:r:magisk:s0`
- `getprop ro.twrp.version` = `3.7.0_12-1` (in recovery)
- Baseband/IMEI/SIM, Wi-Fi, cameras, audio — OK

Actual values and commands: `docs/en/verification.md`. 
