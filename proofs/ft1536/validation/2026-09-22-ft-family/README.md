# FT_FAMILY_SCALING — indeks niezależnego odbioru, 2026-09-22

**Werdykt: RESEARCH_REVIEW_CHANGES_REQUIRED.**
Pełny [raport prowadzącego](../../stages/FT_FAMILY_SCALING_REVIEW_RUN_001/REPORT.md)
zawiera pozytywne wyniki, siedem konkretnych punktów korekty i ocenę pilotażu MiMo.
[Oryginalny PDF](../../stages/FT_FAMILY_SCALING_REVIEW_RUN_001/paper/main.pdf),
LaTeX, Lean, skrypty i wyniki autora są zachowane w śledzonym checkpointcie.

## Integralność

| Artefakt | SHA-256 |
|---|---|
| Oryginalny SHA256SUMS autora | `9a272b83e167c61e0b413ab35ab21352465f90d0fd04f897b0ffe9b9c7e4fefa` |
| REPORT.md prowadzącego | `3b4160dca5d613a1c8b8ca3d97bc11257e6ca300face029ce199aaa0c5f8898e` |
| OUTPUTS.sha256 checkpointu | `0319da9743a81084ee32c2f276c92539b45c89110ae1168af407cdeb891ab99a` |
| RESULT.json | `f8e4c3ede82abc0dc139aa84b2008c1c524b60d3f88f105e4d265fa49ec7adab` |
| VALIDATION.sha256 | `bfaa05d8cab96d4c03e6732f4c8b3d8686d39b1bb88803c185e327be2bc26b59` |

Po sygnale zakończenia od właściciela sprawdzono43 pozycje oryginalnego
manifestu i zachowano je wraz z samym manifestem, bez zmian bajtów.
Snapshot stabilny podczas kontroli; source17-file pin56974571… zweryfikowany.
Import archiwum:125 outputs,118 inputs,3003517 bajtów,integrity PASS.
Adapter prowadzącego dodaje jawny status odbioru i dowody kontroli, a nie
fikcyjny author REPORT lub deklarację bezpieczeństwa.

## Zakres kontroli

-4 moduły Lean4.34.0 sprawdzone ze świeżych źródeł, czyste logi;
  typy/termy/aksjomaty14 nazwanych twierdzeń skontrolowane osobno.
-3 skrypty Python i5 JSON/CSV odtworzone bajtowo; wartości checks=true.
-Niezależne Sage: pierwszość, cyclotomic/root facts, trace-form przez Newton
  sums i podgrupy142/164/186 dla trzech stopni.
-12/12 FFT-port cases, wszystkie sloty, niezależny ComplexBallField256 oracle.
-Rachunek przedziałowy wykazał, że pod idealnym Q/768²~chi-square3072
  rejection probability wynosi około2.9925420736e-9, więcej niż2^-40.
  To test hipotezy H-B w jej idealnym modelu, nie pomiar realnego Sign.

Dowody/logi są w `stages/FT_FAMILY_SCALING_REVIEW_RUN_001/review/`.
Pierwszy oracle prowadzącego miał interval wrapping; jego logi i diagnoza są
zachowane. Poprawny direct-phase oracle potwierdził wyniki autora.
Nie powtarzano całego monolitycznego Sage SA1–SA6 ani kampanii estymatora;
nie zadeklarowano pełnego standardowego replayu całego manuskryptu.

[VALIDATION.sha256](VALIDATION.sha256) wiąże3 indeksowe JSON/22233 bajty,
powiązane bajtowo z pełnym checkpointem. Wnioski o attack-game/reduction,
trapdoor completion, statusie proposed FFT bound i lokalnej tabeli wymagają
korekt R1–R7. Oryginalna praca pozostaje zachowanym materiałem badawczym.
