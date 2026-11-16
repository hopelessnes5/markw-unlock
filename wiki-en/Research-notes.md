# Research notes

## DIAG 900E and EDL 9008
- 900E in this case was a crash dump; `qc_diag.py` unresponsive, `fastboot oem edl` denied (`device locked`).
- No software transition 900E→9008 achieved. DIAG/NV commands are meaningful only with a live diagnostic interface.
- Prevention: do not flash TWRP to `boot` (use `recovery`).
- Details: `research/en/diag-edl.md`, https://github.com/bkerler/edl/issues/505

## Buttons and recovery
- Fastboot: Vol Down + Power; Recovery: Vol Up + Power; 3-button (MI-Recovery): Vol Up + Vol Down + Power.
- MI-Recovery does not bypass custom recovery signature checks.
- Details: `research/en/recovery-buttons.md`

## ROM and recovery (overview)
- Working combo: TWRP 3.4.0-1 → 3.7.0-12-1, LineageOS 18.1, Magisk 26.1.
- TWRP 3.0.2-2 unsuitable (brotli/E1001). OrangeFox R12.0 (2026-08-30) is a newer candidate, not tested in this run.
- Details: `research/en/rom-overview.md`

## Sources
- https://4pda.to/forum/index.php?showtopic=794653&view=findpost&p=144900003
- https://www.opendesktop.org/p/1344122/ 
