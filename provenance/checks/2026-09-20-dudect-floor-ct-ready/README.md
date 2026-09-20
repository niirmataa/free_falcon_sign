# FLOOR_CT — gotowość nocnego dudect, 2026-09-20

**STATIC_READY_TIMING_DEFERRED**. Liczba nowych fizycznych prób czasowych:0.
To receipt źródeł/builda/fixtures oraz przygotowanego runnera, nie wynik
nocnego testu i nie PREFLIGHT_PASS.

Profil floor-ct wybiera archived candidate, manifest:
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
Header: `6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f`.
Lokalne W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_DUDECT_RUN_002`.
Latest attempt001, binary SHA:
`27ac15a26b238958760e21eb626533e297b8ee0dbbb81dbac47097a65dd86752`.
PREPARATION SHA:
`d6d3b3b4eb431b975e9e4476956eb6b4cb287347289fcba09bcacb7c69884dd4`.

- Sprawdzono wszystkie17 źródeł i przypięty official dudect/vendor z archiwum.
- Literalny Makefile -O/GCC14.2.0-19, normal build, zachowane .s/disassembly.
-28672 publiczne fixture/domain checks, trzy uszkodzone raw-record forms
  odrzucone, target_floor bez jump/call/loop/integer division.
- Cztery testy infrastruktury: dokładne source-profile routing, rozróżnienie
  prawdziwych starych/nowych ASM i mutation, blokada startu bez timing preflight,
  odrzucenie wyłączonych Python assertions.
- Zachowano attempt000; attempt001 dodaje assert guard i jego kontrolę.
  W obu było zero fizycznych pomiarów, bez selekcji wyników timingowych.

Nocny launcher najpierw przebuduje i sprawdzi profil, wybierze aktualny CPU,
wykona krótkie controls/3 floor contrasts i raw-statistics replay. Dopiero
PREFLIGHT_PASS pozwala uruchomić nową usługę `ft1536-dudect-run-002.service`
z limitem28800s. Profil/piny będą zapisane w RUN/RESULT/REPORT. Przygotowanie
nie ustawia timera ani nie rozpoczyna kampanii podczas pracy Astry.

Instrukcja: [tests/ft1536/dudect](../../../tests/ft1536/dudect/README.md).
Build/preflight history źródeł harnessu jest zachowana w attempts/; compiled
objects/binary są w W i hash-bound, nie należą do tego archiwum.

[READINESS.json](READINESS.json), [PREPARATION.json](PREPARATION.json),
pełne compiler/fixture logs, code snapshots i tests stdout/stderr.
CHECKS.sha256 obejmuje204 pliki/3884703bytes, SHA:
`d03c6c960fdf70b738312a865bdce342932114fb50642bd199248d48a8918788`.
README, .gitattributes i sam checksum file są poza wykazem.
