# S01 — korekty Family do ręcznego startu MiMo

**TASK_ID=FT_FAMILY_SCALING_CORRECTIONS_RUN_003**,ROADMAP_ID=S01.
Stan2026-09-22: **PREPARED_OWNER_START_AFTER_HANDOFF**. Właściciel poprosił o
zadanie zamykające warunek publikacji. Prowadzący przygotował pliki i piny;
nie uruchomił modelu ani odbioru.

**Obowiązkowe uzupełnienie właściciela2026-09-22:**
[rachunek w `.sage` uruchamiany `sage lemma.sage`](documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md),
SHA `b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241`.
Zastępuje wcześniejszą swobodę wyboru `.py`/Fraction dla nowych rachunków
i checkerów. Dopnij je do INPUTS; zachowaj pierwotne TASK/bootstrap piny.

- [Pełne zadanie](documents/FT1536_ZADANIE_MIMO_FAMILY_CORRECTIONS_RUN_003_2026-09-22.md),
  SHA `7a3515324cb0722dc08e40f196d299ba6021712129aba2b84ed46db2bf82cf93`.
- W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT_FAMILY_SCALING_CORRECTIONS_RUN_003`.
- [Bootstrap197 plików](background/MIMO_FAMILY_CORRECTIONS_RUN_003_2026-09-22/README.md),
  SHA `6294e7829bb8b0254e3cfb2d8c1603712fa6f267aefa6a75aa629bb8a09a9e7e`.
- BASE `a2cdf31733ae1af82c5a523b44305e86a716551c`.
- Źródło uwag: [recenzja R1–R7](stages/FT_FAMILY_SCALING_REVIEW_RUN_001/REPORT.md).

Przypięto także nowszy autorski `FT_FAMILY_SCALING_2026-09-22_RUN_002`:
42 pliki plus SHA256SUMS `5ee71952862a0395e9c3d14873f953a9f9a61985d3ff24f2ccf4f34f0dfccd16`.
To snapshot **nieodebrany**; deklarowane poprawki trzeba sprawdzić i dokończyć.
R4 nadal jawnie OPEN w tej wersji. Dawny CORRECTIONS_RUN_002 pozostaje anulowany.

Przekaż zadanie w istniejącym oknie MiMo po jego kontrolowanym handoffie
bieżących prac. W czasie przygotowania widziano trwającą kampanię estymatora;
ta obserwacja nie upoważnia do kill/restart. [T03](CURRENT_MIMO_TASK.md) zachowuje
oddzielne W/zlecenie; nie przejmuj go i nie startuj drugiego workera.

S01 wymaga spójnego zamknięcia R1–R7,tekstu/kodu/PDF,kontroli i fresh replayu.
COMPLETE_FOR_REVIEW oznacza gotowość autora. Następnie inny model wykonuje
niezależny odbiór. **Blokada publikacji nadal obowiązuje.**
