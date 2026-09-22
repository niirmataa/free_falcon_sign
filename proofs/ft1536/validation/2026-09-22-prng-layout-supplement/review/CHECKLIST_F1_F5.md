# CHECKLIST F1–F5 — odbiór suplementu T02.1 (RUN_003)

**REVIEW_ID:** `FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001`
**Kryteria:** zlecenie `FT1536_PRNG_LAYOUT_SUPPLEMENT_REVIEW_2026-09-22.md`
(`f861be76aae60774ee54e3fb747f4815092405d269d3e8d758649287e63aaca3`, §Zakres kontroli, pkt2)
+ findings `REVIEW_001/REVIEW.md` (`2e9630e595ce95898ad1fb595e8f88bf734297f205090b91490e80328d68ed2c`)
**Recenzent:** MiMo V2.6 Flash (`opencode/mimo-v2.6-flash-free`), świeży kontekst,
zero subagentów.

Legenda: **DOBRZE** = spełnione i zweryfikowane w plikach/pomiarze;
**NIE** = niespełnione; **POZA ZAKRESEM** = świadomie poza zakresem suplementu.

---

## F1 — „scope.open prawdziwie odzwierciedla 28 theoremów Lean"

| Krok | Weryfikacja | Wynik |
|---|---|---|
| 1 | Stare fałszywe zdanie „Lean not used (optional in TASK)" usunięte ze `scope.open` | **DOBRZE** — `model/prng_checker.sage:300` → `artifacts/checker_result.json:2111` |
| 2 | Nowe brzmienie: kernel wymieniony + jawna granica ChaCha | **DOBRZE** — „kernel: counter/layout/resource/q-refill in formal/CounterLayout.lean **(28 theorems)**; **ChaCha Word32 rounds stay outside the kernel (explicit boundary)**" |
| 3 | „28" prawdziwe i core-only | **DOBRZE** — `grep -c '^theorem' formal/CounterLayout.lean` = **28**; `grep -c '^import'` = **0** |
| 4 | Twierdzenia niezmienione R2↔R3 | **DOBRZE** — `formal/CounterLayout.lean` `64384dff…` wierszem identyczny (115 identycznych OUTPUTS), aksjomaty `[propext, Quot.sound]` w stdout Lean obu RUN (`75713141…`) |

**Werdykt F1: DOBRZE (naprawiony).**

---

## F2 — „kernel dowodzi arytmetyki/frame bounds; niepisalność i ChaCha nie stają się refinement proofem przez poison test"

| Krok | Weryfikacja | Wynik |
|---|---|---|
| 1 | Słowo „frame" w `REPORT.md:23` doprecyzowane | **DOBRZE** — `REPORT.md:26`: „(`typeOut`, offsets; **arytmetyka ramki**)" |
| 2 | `SOURCE_MODEL_BINDING.md:23-24` doprecyzowany | **DOBRZE** — „**arytmetykę granic ramki**; sama niepisalność `state[56..255]` wynika ze **struktury zapisów C + kontroli poisonu** — patrz A.4, **nie z lematu kernela**" |
| 3 | Niepisalność/poison **nie** roszczone jako twierdzenie kernelowe | **DOBRZE** — brak takiego twierdzenia w `formal/CounterLayout.lean` (28 twierdzeń = licznik/layout/zasoby/q-refill); niepisalność jawnie strukturalna |
| 4 | Poison/fixtures/C **nie** prezentowane jako refinement proof | **DOBRZE** — grep „refinement" w `REPORT.md` + `SOURCE_MODEL_BINDING.md` = **0 trafień**; zlecenie i REPORT jawnie: suplement, nie KERNEL_COMPLETE (`REPORT.md:7-10` wymienia F1–F5 i „matematyka bez zmian") |
| 5 | Rundy ChaCha jawne poza kernelem | **DOBRZE** — F1 `scope.open` + `SOURCE_MODEL_BINDING.md` §„Poza kernelem (celowo)" (bez zmian R2→R3, spójne) |

**Werdykt F2: DOBRZE (naprawiony).**

---

## F3 — „17 semantic files, rzeczywiste receipts i prawdziwe liczby plików"

| Krok | Weryfikacja | Wynik |
|---|---|---|
| 1 | Liczba plików w `REPLAY.md:9` poprawna | **DOBRZE** — „porównuje **17 plików** z `SEMANTIC_FILES.json`" (było 15) |
| 2 | 17 faktycznie | **DOBRZE** — `SEMANTIC_FILES.json.count = 17` i 17 wpisów; mój replay: **17/17 wyprodukowanych** w DEST |
| 3 | Receipt rehearsal rzeczywisty i liczby prawdziwe | **DOBRZE** — `artifacts/fresh_replay.json`: `FRESH_REPLAY_PASS`,17/17, **26.0236 s** (tabela: „26.0 s"), kotwica `e85f95f34931d25d00ae3314a3817ee72e8a779c16ce73998365f8e6460f6c7a`, **136 członków** = liczba wierszy `artifacts/rehearsal_anchor.sha256` |
| 4 | Receipt post-freeze istnieje i wskazuje liczby | **DOBRZE** — `tmp/postfreeze-001/REPLAY_RESULT.json`: `FRESH_REPLAY_PASS`,17/17, **25.54 s**, pin `e37b1e97ebcfa65d698c52e175c09e826cdbafe565722cc017b5349c00d3f5dc` (odczytany przeze mnie); komórka „po freeze" odsyła do receiptu/handoffu |
| 5 | Inne liczby w handoffie prawdziwe | **DOBRZE** — `OUTPUTS141/141`, `bootstrap39/39`, `source17/17`, `INPUTS61/61` — wszystko świeżo policzone (`INTEGRITY.json`, `logs/*.log`) |

**Werdykt F3: DOBRZE (naprawiony).**

---

## F4 — „`abandoned_bytes_max`/`final_unused_bytes_max` poprawnie nazwanymi maximami z T01, przy wspólnym warunku eventu, nie twierdzeniami o równości zużycia"

| Krok | Weryfikacja | Wynik |
|---|---|---|
| 1 | Klucze z sufiksem `_max` przywrócone wszędzie wskazanych plikach | **DOBRZE** — `model/prng_model.sage:441,447,452`, `model/prng_checker.sage:249`, `RESOURCE_INTERFACE.json` (`received_T01`), `artifacts/model_result.json` |
| 2 | Wartości niezmienione: `61320` / `4088` | **DOBRZE** — R2 `abandoned_bytes=61320` → R3 `abandoned_bytes_max=61320` (tylko nazwa); asserty wzorów bez zmian (`15·4088 = 61320`, `4096−8 = 4088`) |
| 3 | Zgodność z pinem T01 | **DOBRZE** — `inputs/bootstrap/T01/RESOURCE_BOUND.json` = `4fc5e10ba15ae5fe806282fc29ccac70311e9803ef23c3d049ce2a8e6859b085`; `ghost_budget.abandoned_at_reinit_max=61320`, `final_unused_tail_max=4088` — sprawdzone moim `sage check_numbers.sage` (**13/13 PASS**, exit0, stderr0) |
| 4 | „maxima przy wspólnym warunku eventu, nie równość zużycia" | **DOBRZE** — klucz jawnie „max"; asserty dotyczą **wzoru na maksimum** przy wspólnym `reinit_abandonments=15` (zdarzenie re-init), nie faktycznego zużycia; `REVIEW_001` potwierdził, że liczby `396/25408/406528/896/936` tych kluczy nie używają — **do tych liczb brak wpływu** (mój rachunek: formuły osobno PASS) |
| 5 | Klucze rozłączne R2↔R3 poprawnie obsłużone (etykiety stare↔nowe) | **DOBRZE** — mój checker: wspólne klucze `RESOURCE_INTERFACE` R2==R3; w R3 brak resztkowych starych haseł bez sufiksu (`grep -o 'abandoned_bytes[_a-z]*'` = tylko `abandoned_bytes_max`; `final_unused_bytes[_a-z]*` = tylko `final_unused_bytes_max`) |

**Werdykt F4: DOBRZE (naprawiony).**

---

## F5 — „RUN_003 spójne w bieżących RESULT/CERT/LAYOUT/SEMANTIC; historyczne proweniencje zachowają stare ID"

| Krok | Weryfikacja | Wynik |
|---|---|---|
| 1 | `LAYOUT.json` i `SEMANTIC_FILES.json` mają `RUN_003` | **DOBRZE** — `LAYOUT.json:3`, `SEMANTIC_FILES.json:3` = `…RUN_003` (było `…RUN_001`) |
| 2 | `RESULT.json` / `PRNG_LAYOUT_CERTIFICATE.json` spójne | **DOBRZE** — `task_id=…RUN_003`, `continues_from=…RUN_002`, `predecessor_outputs_sha256=8eda4cb9…` |
| 3 | Generatory ujednolicone | **DOBRZE** — `scripts/claims.py:21-23,43` (`task_id=TASK_ID`), `scripts/semantic.py:23` |
| 4 | **Historia zachowana, bez mechanicznego przepisywania** | **DOBRZE** — `TASK.md:12` nadal `TASK_ID=…RUN_001`; `SOURCE_MODEL_BINDING.md:1,3` nadal „(RUN_002, kernel)"/„Kontynuacja …RUN_001"; treść `INPUTS.sha256` bez zmian (61/61); `AGENTS_RUN001.md` usunięty z pakietu, ale bajt-identyczny w `RUN_001/AGENTS.md` (`fb95dbed2d135f53620ba0b0e44fd35a1dd700b70ee553bbf58ca023a651ff2a`); frozen `RUN_001/002` **153/153** i **142/142** DOBRZE |
| 5 | Resztkowe `task_id=RUN_001` poza zakresem F5 rozliczone | **DOBRZE (jako info)** — `artifacts/freeze.json:3`, `artifacts/fresh_replay.json:3`, `receipts/REPLAY_RESULT.json:3` = stały kod `freeze.py:33`/`replay.py:33` (F5 wskazywał tylko `LAYOUT.json`/`SEMANTIC_FILES.json`); **R1** w `REVIEW_RESULT.json` → backlog |

**Werdykt F5: DOBRZE (naprawiony; resztki R1–R3 info, nieblokujące).**

---

## Podsumowanie checklisty

| Finding | Werdykt |
|---|---|
| F1 | **DOBRZE (naprawiony)** |
| F2 | **DOBRZE (naprawiony)** |
| F3 | **DOBRZE (naprawiony)** |
| F4 | **DOBRZE (naprawiony)** |
| F5 | **DOBRZE (naprawiony)** |

**5/5 DOBRZE.** Żadnego kryterium nie pozostawiam niespełnionym ani częściowym —
gdyby któreś było nieweryfikowalne lub częściowe, werdykt byłby `CHANGES_REQUIRED`.

**Poza zakresem tej checklisty (świadomie, `REVIEW.md` §3/§11):**
`kernel_complete` (**false**), `B20_P03_formalization_required` (**true**),
T02 parent / real PRNG→IID / security (**OPEN**), `owner_accepted` (**false**),
`push_authorized` (**false**).

**Resztki info (pełne w `REVIEW_RESULT.json:residuals_info`):** R1 — stałe
`task_id=RUN_001` w trzech receiptach (kod skryptów; korelacja z moim własnym receiptem);
R2 — historyczny nagłówek `SOURCE_MODEL_BINDING.md`; R3 — komórka „po freeze"
w `REPLAY.md` odsyła do istniejącego, zweryfikowanego receiptu.
