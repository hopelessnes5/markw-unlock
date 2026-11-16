# Research: Buttons and Recovery Modes (markw)

## Key combinations

| Mode | Combination | Notes |
|---|---|---|
| Fastboot | Vol Down + Power | Standard entry for fastboot commands |
| Recovery | Vol Up + Power | May require specific USB/timing; behavior can depend on installed recovery |
| MI-Recovery (3-button) | Vol Up + Vol Down + Power | Stock/MI recovery; **does not bypass** signature verification for custom recovery |

## Observations

- Having custom recovery in the `recovery` partition and booting via Vol Up+Power is the working path when the image is correctly flashed.
- MI-Recovery is not a way to force-boot an unsigned image.
- After a crash/bad flash, the device may enter emergency modes (including Qualcomm DIAG 900E in this case) instead of familiar fastboot/recovery.

## Recommendations

- Before experimenting with partitions, have a verified way back to fastboot/recovery.
- Do not rely on 3-button MI-Recovery as a verification bypass. 
