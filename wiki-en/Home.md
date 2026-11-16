# Redmi 4 Prime (markw) — Wiki (EN)

This wiki documents a working path to unlock/flash **Xiaomi Redmi 4 Prime (markw)** without official Mi Unlock, without disassembly/testpoint, and without patching `devinfo` without backups.

## Final configuration (verified)

- **LineageOS 18.1 Revived** (`18.1-20260901-UNOFFICIAL-markw`, Android 11)
- **Magisk 26.1** (root, `su` works)
- **TWRP 3.7.0_12-1** in the `recovery` partition
- IMEI/baseband/SIM, Wi-Fi, cameras, audio — working

## Navigation

- [Step-by-step guide](Step-by-step-guide)
- [What works](What-works)
- [What doesn't work](What-doesnt)
- [Troubleshooting](Troubleshooting)
- [Files and checksums](Files-and-checksums)
- [Research notes](Research-notes)
- [Agent prompt](Agent-prompt)
- [Verification](Verification)

## Important warnings

- At your own risk. Back up `aboot/abootbak/devinfo/persist/modemst1/modemst2/fsg/splash`.
- **TWRP in `recovery` only** (flashing to `boot` caused crash/DIAG 900E).
- **Do not run `fastboot oem lock`** and do not reflash `aboot` without understanding.
- DIAG 900E ≠ EDL 9008.

The main repository includes full documents: `README.en.md`, `GUIDE.en.md`, `docs/en/`, `research/en/`, `scripts/`, `prompts/AGENT_PROMPT.en.md`. 
