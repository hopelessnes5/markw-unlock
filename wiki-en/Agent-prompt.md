# Agent prompt

Full text: `prompts/AGENT_PROMPT.en.md`. Key rules:

- **Never** suggest `fastboot oem lock`, TWRP in `boot`, patching `devinfo` without backups, or "easy" EDL instructions when in 900E.
- Sequence: diagnostics → CVE-2019-2215 root → backups → patched `aboot` to `aboot/abootbak` → TWRP in `recovery` → `mke2fs` userdata → `twrp install` ROM → Magisk via `twrp sideload` + `adb sideload` → TWRP 3.7.0 → verification.
- Pitfalls: `E1001` (need brotli-capable TWRP), Magisk digest (sideload), `adb wait-for-device` hangs in TWRP (state `recovery`), `twrp wipe/format data` do not remove encryption as expected.
- Always separate verified from unverified, and require backups before writing partitions. 
