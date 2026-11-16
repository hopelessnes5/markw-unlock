# Research: DIAG 900E, EDL 9008, and Recovery Options

> Status: analytical notes based on diagnostics of a specific device and available information. Not a guaranteed recipe for escaping 900E.

## Observations on the device

- After an incorrect flash of TWRP to the `boot` partition, the phone crashed and was detected on PC as **Qualcomm HS-USB Diagnostics 900E**.
- `fastboot oem edl` in normal conditions returned: `device locked, oem edl is not allowed`.
- `qc_diag.py` (from bkerler/edl) **did not respond** — indicating DIAG was operating as a crash dump rather than a functional diagnostic interface.
- Attempts to use QPST/QXDM boot/commands to write did not lead to a transition to 9008.

**Case conclusion:** 900E here ≠ working EDL (9008). No software path like "run a command and get Sahara/Firehose" was found.

## Ideas considered

- Diagnostic commands such as `4b650100`, `3A`, NV4399 manipulation + induced crash: potentially viable **only with a live/responding DIAG**, which was not the case.
- Using `emmcdl.exe` + `prog_emmc_firehose_8953_ddr.mbn` (bkerler/edl, EDLUnlock toolsets): applicable when actually in 9008/EDL; not helpful from unresponsive 900E.
- Hardware methods (testpoint/disassembly): intentionally not used.

## Practical takeaway

- Do not confuse 900E and 9008 modes in instructions or expectations.
- If 900E appears after writing to `boot`, first consider restoring a correct `boot`/recovery via available modes (fastboot/recovery/real EDL if available), not "magic" DIAG commands.
- Prevention: **do not flash TWRP to `boot` on markw in this scenario**; use the `recovery` partition.

## Links

- https://github.com/bkerler/edl
- https://github.com/bkerler/edl/issues/505
- https://github.com/Begitdj/cve-2019-2215-markw (package/image context) 
