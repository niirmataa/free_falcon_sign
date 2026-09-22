# PRESTART_STATE.md — stan prac i jobów MiMo przed startem S01

Zapisane przed rozpoczęciem FT_FAMILY_SCALING_CORRECTIONS_RUN_003 (S01),
zgodnie z TASK §1 i W/AGENTS ("przed ręcznym startem MiMo zapisuje stan
swoich bieżących prac i jobów"). Czas obserwacji: 2026-09-22T04:53:51Z.

## Bieżąca praca MiMo przejmowana przez ten zapis

- T03 / FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 (W=proofs/ft1536/work/
  FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001): **PAUZA**, oddane w HANDOFF.md
  tego W (szczegóły tam). Ostatni krok 04_exact_ring_checks FAILED
  (AssertionError: synthetic f not invertible mod (q,Phi)). Brak aktywnych
  procesów T03. T03 i jego W zachowane bez zmian poza nowym HANDOFF.md;
  CURRENT_MIMO_TASK.md NIE nadpisany.

## Stan własnych jobów (pełna obserwacja procesów 2026-09-22T04:53Z)

1. Kampania estymatora FT_FAMILY_SEC_ESTIMATE_2026-09-22_RUN_001
   (W=proofs/ft1536/work/FT_FAMILY_SEC_ESTIMATE_2026-09-22_RUN_001):
   PID 589132 (bash -c ... scripts/ntru_models.sage > results_ntru.log)
   + dziecko PID 589138 (python, stan R), etime ~3h36m.
   STATUS w jej W: DIAGNOSTIC_NOT_CANDIDATE_READY (plik STATUS).
   Decyzja: **nie ruszam**. TASK §1: "PID jest obserwacją historyczną, nie
   poleceniem kill"; TASK §5: nie przejmuję ani nie przerywam cudzych jobów;
   R4: nie modyfikuję istniejącego estimator workspace; żywych wyników nie
   biorę jako zatwierdzonych wejść. W razie potrzeby jej stanu — osobna decyzja
   właściciela.
2. Inne joby MiMo: brak (git status czysty, brak buildów/replayów w tle).

## Skutki dla S01

- S01 startuje w istniejącym oknie MiMo po powyższym handoffie. Jeden wykonawca.
  Bez drugiego workera, subagentów, relay, `opencode run --session`.
- Kampania estymatora nadal działa w tle w osobnym W; nie jest to druga
  kampania S01 (S01 nie uruchamia żadnej kampanii estymatora — R4 zakłada
  wycofanie/routing, nie obliczenia).
- Zasoby: moje joby S01 będą bounded/sequential (Lean j1/-M2048, Sage tylko
  jeśli TASK wymaga, 8 GiB limit), HOME/TMPDIR pod trwałym W.

## Piny potwierdzone przed startem (właściciel prosił o kontrolę)

- TASK document SHA-256 = 7a3515324cb0722dc08e40f196d299ba6021712129aba2b84ed46db2bf82cf93 ✓
  (CURRENT_FAMILY_TASK / W/AGENTS).
- Bootstrap MANIFEST.sha256 SHA-256 = 6294e7829bb8b0254e3cfb2d8c1603712fa6f267aefa6a75aa629bb8a09a9e7e ✓
- REVIEW/REPORT.md = 3b4160dca5d613a1c8b8ca3d97bc11257e6ca300face029ce199aaa0c5f8898e ✓
- REVIEW/OUTPUTS.sha256 = 0319da9743a81084ee32c2f276c92539b45c89110ae1168af407cdeb891ab99a ✓
- CANDIDATE_R2/SHA256SUMS = 5ee71952862a0395e9c3d14873f953a9f9a61985d3ff24f2ccf4f34f0dfccd16 ✓
- REVIEW/inputs/CANDIDATE.sha256 = 56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985 ✓
- T01/IID_RETRY_CERTIFICATE.json = 2a91dd43cc3c21486aa8968ebb0e4ae211a603a786e647a257d05174ef39ce2b ✓
- source17: 17/17 plików Extra/c = pin CANDIDATE.sha256 ✓ (dowód:
  logs/00_source17_live.txt vs logs/00_source17_pin.txt).
- Pełna walidacja 197 członków/195 origins/brak symlinków/escapes:
  logs/00_verify_inputs.log (skrypt scripts/verify_inputs.py).

Uwaga: wzmianka o SHA "6294e78…" przy linku do background README w
CURRENT_FAMILY_TASK odnosi się do PIN MANIFESTU bootstrapu (zgodnie z TASK §2
i W/AGENTS); sam background README ma odrębny hash f540b0bea1515b3cc92b9e86e90d9af33a5e6a869eab6b44a280c2fd689d72a4
i nie jest przypięty jako członek bootstrapu.
