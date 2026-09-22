# REPORT — FT_FAMILY_SCALING_CORRECTIONS_RUN_003 (S01)

2026-09-22. Autor projektu **Niirmata**. Rachunek/korekty: MiMo 2.6 PRO
(wykonawca S01). Zachowana atrybucja Falcon Project / Thomas Pornin
i licencje. Tryb rachunku: zasada właściciela SageMath
(`supplements/`, SHA `b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241`).

**Status: FT_FAMILY_CORRECTIONS_COMPLETE_FOR_REVIEW**
(gotowość autora do niezależnego odbioru — NIE jest to dowód bezpieczeństwa,
owner acceptance ani gotowość wdrożeniowa).

## 1. Wejścia i kontrola pinów

Bootstrap: 197 członków / 195 origins / 4 967 628 B, MANIFEST
`6294e782…` — pełna walidacja exact set, hashów, brak symlinków/traversal/
duplikatów, ORIGINS (base `a2cdf317…`), source17 (17/17 `Extra/c` = pin
`56974571…`) oraz normalizacja `./` w oryginalnym SHA256SUMS CANDIDATE_R2
(42/42): **PASS** (`proof/checks/00_verify_inputs.log`, checker
`scripts/verify_inputs.py`). Piny TASK (`7a351532…`), REVIEW
(`3b4160dc…`/`0319da97…`), CANDIDATE_R2 (`5ee71952…`), CANDIDATE.sha256
(`56974571…`), T01 (`2a91dd43…`): **zgodne**.

Przed startem: handoff bieżącej pracy T03 (`work/FT1536_REFERENCE_INTEGER_
RECOVERY_RUN_001/HANDOFF.md`; pauza po błędzie kroku 04 — synthetic f nie
odwracalne mod (q,Phi)) + stan jobów (`PRESTART_STATE.md`). Kampania
estymatora FT_FAMILY_SEC_ESTIMATE (PID 589132/589138) obserwowana,
**nie przerwana** (PID = obserwacja historyczna, nie polecenie kill);
jej żywych wyników nie użyto jako wejść. T03 i T02.1 (osobny tor) nietknięte.

## 2. Bilans R1–R7 (szczegóły: CORRECTION_MATRIX.md/.json)

| # | disposition | co wykazano / co otwarte |
|---|---|---|
| R1 | REUSED + nowe kontrole | kierunek dowiedziony to `Extract ∘ Forge = Solve_rel` (sprawdzony wykonawczo na modelu zabawkowym, N3); odwrotny most wymaga `Enc` — **brak** (N3 egzekwuje kontrprzykład); pełna redukcja M0/M7 OPEN |
| R2 | REUSED + nowe kontrole | wycofana definicja „przeciwnik wybiera c" jest trywialna (stopień wygranej **1** vs **1/q** dla celów ROM — dokładna enumeracja, N1); `(1−p)^Q` nieuprawnione dla celów powtórzonych (unia **1/2** vs 3/4, N2); poprawne: cele = wartości tabeli ROM, union bound po nazwach rozłącznych |
| R3 | REUSED + kontrola źródła | sygnatura `falcon_complete_private(G,f,g,F,…)` potwierdzona wprost z przypiętego `falcon-vrfy.c` (N4): liczy G z **(f,g,F)**, nie rozwiązuje NTRU po (f,g); P1a≠P1b, próg per-populacja; EMITTED OPEN |
| R4 | **NAPRAWIONE (wycofanie)** | aktywny runner blokuje backend bez premises (jawny `NOT_RUN_MODEL_UNRESOLVED` **przed** wywołaniem; mock nie jest nawet importowany) i odrzuca SIS→P2 przed backendem (po `model_kind` i po symbolu; brak mappingu/SHA/premises blokuje). Testy T1–T8 PASS (brak wywołań + wykrycie fałszywego SIS→P2 i mutacji + no-op). Historyczny runner: bajtowa kopia + `INVALID_FOR_P2/NOT_RUN`. Estymator **nie uruchamiany** |
| R5 | **NAPRAWIONE (rygorystycznie)** | wyprowadzenie `Pr[Q≥B]=e^(−x)Σ_{k=0}^{1535}x^k/k!`, `x=B/(2·768²)=2093922385/1179648` (postać Erlanga/Poissona); rachunek `.sage` (ZZ/QQ + RealBallField(256)): ogon `>2^−40` **certyfikowane** (dawne kryterium „≥1−2^−40" **obalone** — zachowane) oraz `<2^−28` **certyfikowane**; centrum `2.99254207360324819728314586108746…e−9` = cyfry niezależnego rachunku recenzji; próg `2^−28` jawno **PROPOSED** (model-level target; nie cel projektu, nie poziom bezpieczeństwa); to ujemny test idealnego modelu, nie prawo Sign/atak |
| R6 | REUSED + wzmocnienie | status PROPOSED spójny (abstract/szkic/wnioski/notatki/metadata, N6); mnożnik `(1+ε_tw)^(ℓ+1)` oznaczony jako **założony placeholder** — perturbacja faz/twiddles wymaga osobnego wyprowadzenia; 12 przypadków nie ustala c/domenu/FPEMU (jawne) |
| R7 | REUSED + jedno źródło | wiersze tabeli generowane z `results/layout.json` (markery + `--check`); FT3072 high-water **16384** = 3·3072+7168 niezależnie przeliczone rekurencją (N7; mutacja 15360 wykryta); taksonomia 9 klas (`KERNEL`, `EXACT_INTEGER/RATIONAL`, `RIGOROUS_INTERVAL`, `FLOAT_DIAGNOSTIC`, `ANALYTIC`, `SOURCE_FACT`, `PROPOSED`, `OPEN`, `NOT_RUN`) w `CLAIMS.md/.json` z eksportami/przesłankami |

## 3. Co proved / checked / proposed / withdrawn / open

- **PROVED (kernel Lean 4.34, czysty log, audyt 14/14: tylko
  propext/Quot.sound):** tożsamości/nierówności A2 (C3–C4), rekurencje
  layoutu i wartości instancji w tym high-water 4096/8192/16384 (C5–C6),
  tabele pierwiastków (C2), rachunek progu B (C5).
- **EXACT_INTEGER/RATIONAL (ZZ/QQ):** suma Poissona i porównania ogona (C19),
  rekurencja scratch (N7), enumeracje N1/N2, census podgrup (C13, REUSED).
- **RIGOROUS_INTERVAL:** ogon MODEL_CHI2_IDEAL (C19) z obudową exp
  (RealBallField + ścieżka kontrolna + przedział Taylora).
- **CHECKED (kontrola, nie dowód):** reprodukcje bajtowe geometry/layout/
  bounds (identyczne z pinami CANDIDATE_R2); N1–N7; T1–T8; tabela jednoźródłowa.
- **PROPOSED:** granica FFT3 (C11) i próg `2^−28` (C19) — jawnie niezatwierdzone.
- **WITHDRAWN (zależne wnioski usunięte — ledger §10 CORRECTIONS):** tabele
  kosztów `0.265d log2(q/σ)−100`, `1.7(N/1536)^0.1`, „podgrupy 26/29/32",
  `√N·max|coeff|` i „zapas ≥32 bitów", „binary64 wystarcza", ~59 KB/48 KiB,
  tabela cykli, B=1811939328 jako próg, czynnik 1.1, ePrint-y niezweryfikowane,
  `2^446.2` dla ternary; kryterium „≥1−2^−40" w MODEL_CHI2_IDEAL (obalone rachunkiem).
- **NOT_RUN:** wszystkie koszty ataków P1/P2/P3 i czasy; estymator
  (kampanii nie uruchamiano; `estimator_campaign_executed_in_this_task=false`).
- **OPEN:** prawo samplera po castach/retry, real PRNG, H2P, integer recovery
  (T03 — osobny tor), Sign→Verify, całe real Sign, security/CT, SIG-001,
  równoważność port↔FPEMU, ε_tw, FT768/FT3072 (implementacja/certyfikaty).

## 4. Kontrole i formalizacja

- **Kontrole semanticzne** (`scripts/lemma_controls.sage` →
  `results/controls.json`): N1–N7 wszystkie PASS; mutation/no-op w każdej
  grupie; żadna nie jest testem obecności etykiet (skan etykiet tylko jako
  suplement N6).
- **Kontrole R4** (`scripts/test_r4_routing.py` → `results/r4_tests.json`):
  T1–T8 PASS (mock backend z markerem importu; brak wywołań w stanach
  blokowanych; detekcja SIS→P2 i mutacji; idempotentny no-op).
- **Formalizacja:** 4 moduły Lean świeżo zbudowane (`-j1 -M2048`, logi 0 B),
  `proof/checkers/AxiomAudit.lean`: 14 nazwanych twierdzeń, typy/termy/
  aksjomaty — bez sorry/admit/native_decide/Lean.ofReduceBool/aksjomatu celu
  (`results/lean_AxiomAudit.log`).
- **Rachunek:** `sage scripts/lemma_chi_tail.sage` i `lemma_controls.sage`
  w wymaganym trybie (preflight `parent(1) is ZZ`, `parent(1/3) is QQ`,
  `2^10 == 1024`); szkice `.py` zachowane (`proof/drafts/`), port rozliczony
  (`proof/receipts/port_py_to_sage.json`).

## 5. Replay i PDF

- Fresh replay autora: `scripts/replay.py` (standard: ABSENT_DEST +
  zewnętrzny pin OUTPUTS.sha256, walidacja manifestu przed DEST, świeży
  cache projektu, network-off `unshare -rn`, deterministyczne matches z listy
  prerejestrowanej w `SEMANTIC_FILES.json`): **FRESH_REPLAY_PASS**
  (`artifacts/fresh_replay.json` + dziecko `REPLAY_RESULT.json` w DEST;
  mismatches=[]).
- PDF: przebudowany z poprawionych źródeł (`paper/compile.log`); odtwarzanie
  PDF rozliczone semanticznie (osobno od dopasowań bajtowych — patrz
  `REPLAY.md`).

## 6. Co ten wynik zmienia w projekcie

Warunek właściciela dotyczący publikacji (poprawienie FT_FAMILY_SCALING i
pozytywny niezależny odbiór) ma **komplet gotowego materiału autorskiego**:
R1–R7 zamknięte zgodnie z kryteriami TASK, wyniki negatywne zachowane, R4
rozstrzygnięty bez ruszania estymatora. Decydujący krok: **niezależny odbiór
i replay przez inny model wskazany przez właściciela** (prompt przygotowuje
prowadzący). Dopiero pozytywny odbiór + osobne polecenie właściciela
otwierają publikację; ta pozostaje wstrzymana. Następne prace merytoryczne:
kampania estymatora po zamknięciu warunków (`NEXT_INTERFACE.md`), prawo
samplera/PRNG, T03 integer recovery (osobny tor).

## 7. Piny i artefakty

- `REPORT.md` SHA-256 i `OUTPUTS.sha256` SHA-256: w handoffie poniżej
  (liczone po freeze; podane w komunikacie końcowym i `HANDOFF.md`).
- Kluczowe artefakty: `results/chi_tail.json` (C19), `results/controls.json`
  (N1–N7), `results/r4_tests.json` (T1–T8), `results/lean_AxiomAudit.log`,
  `proof/checks/00_verify_inputs.log`, `proof/receipts/*`, `proof/diffs/*`,
  `artifacts/fresh_replay.json`.

**Flagi (obowiązkowe):** `source_changed=false`,
`production_source_changed=false`, `estimator_campaign_executed_in_this_task=false`,
`new_profiles_implemented=false`, `source_security_proved=false`,
`owner_accepted=false`.
