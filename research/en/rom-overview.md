# Overview: ROMs and Recoveries for markw (Notes)

> Snapshot of considerations at the time of research. Verify current builds/links before flashing.

## ROMs (mentioned)

- **LineageOS 18.1 (Android 11)** — used in this repository: `18.1-20260901-UNOFFICIAL-markw` (Revived/UNOFFICIAL), stable in this case.
- **LineageOS 22.2** and newer branches — may be available in the community but require compatible recovery/kernel/partition layout; not tested here.
- **crDroid 7.x / 11.x** — mentioned as options for markw; check maintainer releases/forums for compatibility and freshness.

## Recoveries

- **TWRP 3.0.2-2** — outdated, no brotli (`E1001` on modern zips).
- **TWRP 3.4.0-1** (redispade) — working minimum for ROM install in this path; digest verification failed on Magisk APK → sideload used.
- **TWRP 3.7.0_12-1** (SonicBSV, 2023-11-18) — current in the final state here, flashed to `recovery`.
- **OrangeFox R12.0 (Unofficial, 2026-08-30)** — mentioned as a newer option for markw; requires separate compatibility checks with your ROM/partitioning (e.g. dynamic partitions). Link: https://sourceforge.net/projects/recovery-for-xiaomi-devices/files/markw/OrangeFox-R12.0-Unofficial-markw.zip/download

## Recommendation

To reproduce the documented path, use **TWRP 3.4.0-1 (install) → 3.7.0 (final) + LineageOS 18.1 + Magisk 26.1** with verified hashes from [files/CHECKSUMS.md](../../files/CHECKSUMS.md). Any deviation (different ROM/recovery) carries a different risk profile. 
