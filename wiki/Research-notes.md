# Исследования

## DIAG 900E и EDL 9008
- 900E в нашем кейсе — crash dump; `qc_diag.py` не отвечает, `fastboot oem edl` запрещён (`device locked`).
- Программного перехода 900E→9008 не получено. Команды DIAG/NV имеют смысл только при «живом» диагностическом интерфейсе.
- Профилактика: не прошивать TWRP в `boot` (писать в `recovery`).
- Подробнее: `research/diag-edl.md`, https://github.com/bkerler/edl/issues/505

## Кнопки и recovery
- Fastboot: Vol Down + Power; Recovery: Vol Up + Power; 3 кнопки (MI-Recovery): Vol Up + Vol Down + Power.
- MI-Recovery не обходит подпись кастомного recovery.
- Подробнее: `research/recovery-buttons.md`

## ROM и recovery (обзор)
- Рабочая связка: TWRP 3.4.0-1 → 3.7.0-12-1, LineageOS 18.1, Magisk 26.1.
- TWRP 3.0.2-2 не подходит (brotli/E1001). OrangeFox R12.0 (30.08.2026) — свежий кандидат, отдельно не тестировался в этом прогоне.
- Подробнее: `research/rom-overview.md`

## Источники
- https://4pda.to/forum/index.php?showtopic=794653&view=findpost&p=144900003
- https://www.opendesktop.org/p/1344122/ 
