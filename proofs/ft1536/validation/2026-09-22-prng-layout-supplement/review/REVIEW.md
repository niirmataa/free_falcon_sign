# REVIEW — T02.1 suplement F1–F5 (RUN_003) — `PASS_SCOPED_SUPPLEMENT`

**REVIEW_ID:** `FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001`
**Dokument zlecenia:** `proofs/ft1536/documents/FT1536_PRNG_LAYOUT_SUPPLEMENT_REVIEW_2026-09-22.md`
**Dzień wykonania odbioru:** 2026-09-22
**W (praca recenzenta):** `proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001/`
**W pakietu (źródło odbioru, tylko do odczytu):** `proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_003/`

---

## 1. Identyfikacja recenzenta i niezależność

- **Model recenzenta:** MiMo V2.6 Flash (`opencode/mimo-v2.6-flash-free`),
  **świeży kontekst**, bez wiedzy z sesji wykonawcy suplementu.
- **Zero subagentów i relay** — całość wykonałem osobiście w jednej sesji, jeden
  worker na ten W (zakaz z zlecenia i AGENTS W).
- **Tożsamości wykonawcy RUN_003 nie zgaduję** (zakaz); ustalam tylko niezależność
  techniczną: odbiór wykonuje inny model/proces niż autor suplementu, ekspozycja na
  pakiet wyłącznie do odczytu. Poprzedni odbiorca RUN_002 (`REVIEW_001`) to inny model
  (MiMo V2.6 Pro, świeży kontekst swej sesji) — ja odbieram suplement ponownie,
  nie kontynuując tamtej sesji.
- Polecenie zlecenia zweryfikowane pinem (zgodne z `AGENTS.md` W):

```
f861be76aae60774ee54e3fb747f4815092405d269d3e8d758649287e63aaca3  proofs/ft1536/documents/FT1536_PRNG_LAYOUT_SUPPLEMENT_REVIEW_2026-09-22.md
```

Wszystkie piny w tym raporcie **przeliczyłem od nowa bezpośrednio z plików**
(etap kontrolny — patrz `FAILED_ATTEMPTS.md` G); `INTEGRITY.json` zawiera te same
wartości dla trzech momentów kontrolnych (przed replayem / po replayu / finalnie).

---

## 2. Werdykt

> ## `PASS_SCOPED_SUPPLEMENT`

Wszystkie **5 kryteriów F1–F5** zlecenia i `REVIEW_001` zostało **spełnionych
i zweryfikowanych w plikach** (nie tylko w deklaracjach); **pełny diff
`RUN_002 → RUN_003` rozliczony co do każdego wiersza**, z rozdzieleniem zmian
rachunku od etykiet; rachunek matematyczny **niezmieniony** względem zamrożonego
`RUN_002`; **swój, świeży replay 17 plików PASS** (17/17, exit 0, 525.24 s) na
**odtworzonej przeze mnie kopii**, nie na `SOURCE_W`.

Gdyby któreś kryterium było niespełnione, nieweryfikowalne lub częściowo
odtwarzalne, miałbym obowiązek zwrócić `CHANGES_REQUIRED` — **nie zastosowało
się to tutaj**: komplet dowodów jest spójny i odtwarzalny.

`REVIEW_RESULT.json`: `verdict = "PASS_SCOPED_SUPPLEMENT"`,
**`kernel_complete = false`**, **`B20_P03_formalization_required = true`**,
`owner_accepted = false`, `push_authorized = false`.

---

## 3. Dokładny zakres akceptacji historycznej (obowiązkowy dla PASS)

**Akceptuję (scoped, historycznie):**

1. Suplement T02.1 `RUN_003` względem `RUN_002` — czyli **naprawę findings F1–F5**
   z `REVIEW_001` w zakresie scope/dokumentacji/etykiet/receiptów, przy **niezmienności
   rachunku** (dowód w §6).
2. **Zadeklarowane unchanged numbers** `396 / 25408 / 406528 / 896 / 936`
   (§`scope.open`) — potwierdzone względem pinu poprzednika (OUTPUTS `8eda4cb9…`,
  142/142) **i** własnym rachunkiem `sage check_numbers.sage` (13/13, §6).
3. **Liczby `*_max` z T01**: `abandoned_at_reinit_max = 61320`,
   `final_unused_tail_max = 4088` — zgodne z pinem
   `inputs/bootstrap/T01/RESOURCE_BOUND.json` = `4fc5e10ba15ae5fe806282fc29ccac70311e9803ef23c3d049ce2a8e6859b085`
   (sprawdzone w moim `.sage`), jako **maxima przy wspólnym warunku eventu**
   (`reinit_abandonments = 15`), **nie** jako twierdzenia o równości zużycia.
4. **Ekspozycja `FT1536_FPEMU_COUNTER_RNG_RUN_001`** — bez roszczenia o PRNG
   producenta, bez identyfikacji wariantu in-place, bez uogólnienia na implementacje.
5. **Bezpieczeństwo liczb losowych, redukcję mod p, algebraiczność, klasy
   błędów/STAT, ścieżki wycofania, „idealne IID"** — pozostają **OPEN** i ta
   akceptacja **ich nie obejmuje**.

**Obowiązki formalne, których ten odbiór NIE zdejmuje (jawne):**

- **`kernel_complete = false`** — rdzeń Lean (28 twierdzeń) dowodzi arytmetyki
  licznika/layoutu/zasobów/q-refill dla pinned source model, ale **brak pełnego
  formalnego source-bindingu do binariów/exe i brak kernelizacji rund ChaCha**;
  niepisalność `state[56..255]` pozostaje argumentem strukturalnym (A.4) + poison,
  **nie twierdzeniem kernelowym**.
- **`B20_P03_formalization_required = true`** — domknięcie tych obowiązków w B20/P03
  (SageMath + Lean4 + Mathlib, formalny proof + formalny source binding).
- **T02 parent, real PRNG→IID, security — `OPEN`** (`T02_parent_open=true`,
  wszystkie flagi bezpieczeństwa `false` — `REVIEW_RESULT.json:declared_flags`).
- **PASS ≠ KERNEL_COMPLETE, ≠ owner acceptance, ≠ zgoda na publikację.**

---

## 4. Integralność wejść i piny zewnętrzne (przed / po replayu / finalnie)

Wszystkie piny przeliczone od nowa; członkowie liczeni świeżo (locale: `DOBRZE`,
nie „OK"); kompletny rejestr w `INTEGRITY.json` i `logs/*.log`:

| Zbiór | Pin SHA-256 | Członkowie |
|---|---|---|
| zlecenie (dokument) | `f861be76aae60774ee54e3fb747f4815092405d269d3e8d758649287e63aaca3` | zgodny |
| `RUN_003/REPORT.md` | `3b7c2b3bbc7f0b72b3a25d3f2cb32623294f1135acb61d8c65b905eefe1a6168` | — |
| `RUN_003/OUTPUTS.sha256` | `e37b1e97ebcfa65d698c52e175c09e826cdbafe565722cc017b5349c00d3f5dc` | **141/141 DOBRZE** |
| `RUN_003/INPUTS.sha256` (plik) | `8860069a6a7768574ef64e6d3abfa0d8bfde01b9fcaafc76fa39cab129f955dc` | **61/61 DOBRZE**; treść: **0 zmian** vs R2 |
| `RUN_003/TASK.md` | `7b0007c095c51b1fe4c5d94b0b1a0012227aba4df0d1c59cfa8fcd92589fe5f1` | — (`TASK_ID=…RUN_001` historycznie) |
| bootstrap `MANIFEST.sha256` | `03b0612cbe3b18e487bee6399c71c238e5ff3a0527818a7c4330d007b72abae2` | **39/39 DOBRZE** (świeży `sha256sum -c`, log `logs/bootstrap_manifest_check.log`) |
| `CANDIDATE.sha256` (source17) | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` | **17/17 DOBRZE** z katalogu `source/` (`logs/candidate_source17_check.log`) |
| `SAGEMATH_RULE.md` (2 kopie: root + `inputs/documents/`) | `b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241` | obie identyczne |
| `RUN_001/OUTPUTS.sha256` | `34c49d61f159d7b55171f51ca85b53e3b7c0a321512cc26102161dfd497f2e6a` | **153/153 DOBRZE** |
| `RUN_002/OUTPUTS.sha256` | `8eda4cb98b754c5f20c8db2a34ff5055bffd535f626dc12d87b56c816406e5a7` | **142/142 DOBRZE** |
| `REVIEW_001/REVIEW.md` | `2e9630e595ce95898ad1fb595e8f88bf734297f205090b91490e80328d68ed2c` | — |
| `REVIEW_001/REVIEW_OUTPUTS.sha256` | `907586d4e86eeeede8a64f8a8100cbb84d2bd879ffc70cabb7295f7856f77f78` | **210/210 DOBRZE** |
| pin T01 dla F4 (`inputs/bootstrap/T01/RESOURCE_BOUND.json`) | `4fc5e10ba15ae5fe806282fc29ccac70311e9803ef23c3d049ce2a8e6859b085` | `ghost_budget`: `61320`/`4088` ✓ (mój `sage`) |
| moje `INPUTS.sha256` (W recenzenta) | 46 wierszy | **46/46 DOBRZE** (`logs/review_inputs_check.log`) |

Stan zewnętrznych wejść **niezmieniony przed i po replayu** (piny identyczne
w trzech momentach; `logs/before|after_replay_inputs_sha256.txt` — SHA skryptów/
formal/model/harness/source/inputs `BEFORE == AFTER`).

---

## 5. Pełny diff `RUN_002 → RUN_003` — każda różnica wyjaśniona

Trzy niezależne naliczenia: (a) manifest po wierszu, (b) rekurencyjne porównanie
katalogów, (c) `INPUTS` osobno. Dowody: `checkers/diff_r2_r3_manifest.json`,
`checkers/diff_r2_r3_tree.txt`, `DIFF_AUDIT.json`, `DIFF_AUDIT.md`.

**Manifest: 142 → 141 wierszy; 115 identycznych; 26 zmienionych; 1 usunięty;
0 dodanych.** Pełna klasyfikacja26 (`DIFF_AUDIT.json:row_classification`):

| Kategoria | Pliki (26) |
|---|---|
| **F1** (scope.open) | `model/prng_checker.sage`, `artifacts/checker_result.json` (razem z F4) |
| **F2** (słowo „frame") | `REPORT.md`, `SOURCE_MODEL_BINDING.md` |
| **F3** (17 plików + receipts) | `REPLAY.md` |
| **F4** (klucze `*_max`) | `RESOURCE_INTERFACE.json`, `artifacts/model_result.json`, `model/prng_model.sage`, `model/prng_checker.sage`, `artifacts/checker_result.json` |
| **F5** (`task_id`) | `LAYOUT.json`, `SEMANTIC_FILES.json`, `RESULT.json`, `PRNG_LAYOUT_CERTIFICATE.json`, `scripts/claims.py`, `scripts/semantic.py` |
| nagłówki/ kontekst suplementu | `AGENTS.md`, `CLAIM.md`, `FAILED_ROUTES.md` |
| prefiksy ścieżek absolutnych | `INPUTS.sha256` (**0 zmian treści**,61 haseł identycznych) |
| regenerowane receipty/logi | `artifacts/freeze.json`, `artifacts/fresh_replay.json`, `receipts/REPLAY_RESULT.json`, `receipts/build.json`, `receipts/sage_run.json`, `artifacts/COMMANDS.frozen.log`, `logs/recipe_console.log`, `artifacts/rehearsal_anchor.sha256` |

**Usunięty (1):** `AGENTS_RUN001.md` — hash `fb95dbed2d135f53620ba0b0e44fd35a1dd700b70ee553bbf58ca023a651ff2a`
**taki sam jak `RUN_001/AGENTS.md`** (przeliczone) → historyczna kopia przeniesiona
poza pakiet, **historia zachowana** w zamrożonym `RUN_001` (153/153 DOBRZE).

**Tree-diff: 92 wpisy** = **85 plików różniących** + **7 tylko-jednostronnych**:

- root: **31** = 26 manifestowych + 5 spoza manifestu: `OUTPUTS.sha256` (sam manifest),
  `COMMANDS.log` (ścieżki W + znaczniki czasu), `bin/prng-harness-{normal,sanitized,altbranch}`
  (przebudowa — patrz §6: normal/altbranch **21 B**, sanitized **275 B** różnic,
  wyłącznie ścieżki/debug; **dump-y i stdout identyczne**);
- lustra replaya: **54** = 26 w `tmp/postfreeze-001/` + 26 w `tmp/rehearsal-001/`
  + `postfreeze_console.log` + `rehearsal_console.log` — te same kategorie zmian,
  lustra replayów z auto/przed `-freeze` (w tym natura `AGENTS.md`);
- tylko-jednostronne (7): `AGENTS_RUN001.md` w root + w obu lustach R2 oraz
  4 wpisy nazw podkatalogów `cache/hidden_work` (kryjka oryginalnego drzewa —
  w R2 podkatalog `…RUN_002`, w R3 `…RUN_003`; wpis nie jest treścią).

**Zestawienie ze zleceniem:** `REVIEW_001`→`REVIEW_003` w `artifacts/manifest.json`
(`frozen_result_index_ids=[…REVIEW_003]`) i `REPORT.md` — **DOBRZE**;
`AGENTS_RUN001.md` przeniesiony — **DOBRZE**; „tylko nazewnictwo/source-binding,
bez rachunku" — **DOBRZE** (§6).

---

## 6. Rachunek matematyczny — niezmienność (kluczowe dla scoped PASS)

**Kod `.sage`/`.py` — zmiany wyłącznie metadanych, zero arytmetyki** (diff
linia-po-linii obejrzany w całości):

- `model/prng_model.sage`: tylko nazwy `abandoned_bytes(_max)` /
  `final_unused_bytes(_max)` przy **tych samych** wartościach `61320`/`4088`
  i tych samych assertach formuł (`15·4088 = 61320`, `4096−8 = 4088`) — **F4**;
- `model/prng_checker.sage`: odczyt klucza `*_max` + tekst `scope.open` — **F4+F1**;
- `scripts/claims.py`, `scripts/semantic.py`: stałe `TASK_ID`/poprzednik/`task_id` — **F5**.
  Żadnych literałów rachunkowych, formuł ani progów nie zmieniono.

**Dowody niezmienności wyników (obie strony identyczne):**

- **115 identycznych wierszy `OUTPUTS`**, w tym `formal/CounterLayout.lean`
  (`64384dffc511182ac34ebdb530a66179b848cb272c6c208614afecf60604eb15`),
  `artifacts/fixtures.{bin,json}`, `kat_vectors.json`, `mutations.json`,
  `model_dump.json`, `harness_dump{,_sanitized,_altbranch}.json`, `TOOLCHAIN.txt`,
  `TASK.md`, `SAGEMATH_RULE.md`;
- **`artifacts/COMMANDS.frozen.log`**: te same hasła stdout każdego polecenia
  w RUN_002 i RUN_003 — Sage model `705a320ed19b2339…`, Sage checker
  `d738585a2aa6c4b0…`, Lean `75713141acfa50c2…`, C dump normal/sanitized
  `72401466d578aa9b…`, altbranch `b0dee8bc15ae2b6f…` (9 komend, różnią się tylko
  ścieżki W i znaczniki czasu);
- **Lean**: `grep -c '^theorem' = 28`, `grep -c '^import' = 0` (core-only),
  aksjomaty w stdout `[propext, Quot.sound]`; **w moim świeżym DEST** rebuild dał
  **28 twierdzeń** i `propext` w stdout (`logs/dest_logs/`);
- **checker**: `405` checks / `105` pól / `PASS` — **identyczne** w R2 i R3
  (różnią się tylko hash `model_result` i tekst `scope.open`);
- **binaria** (cmp -l): normal/altbranch **21 B**, sanitized **275 B** różnic —
  ściezki W/debug; **zachowania identyczne** (powyższe stdouty i dump-y).

**Wejścia zamrożone:** `INPUTS.sha256` **0 zmian treści** (61/61), bootstrap
**39/39**, source17 **17/17** — wszystko świeżo (§4).

**Mój własny rachunek: `sage check_numbers.sage` → `13/13 PASS`, exit 0,
stderr 0 B** (`logs/sage_check_numbers.stdout`): formuły `396 = ⌊(33·49152−8)/4087⌋`,
`64·(1+396) = 25408`, `64·6352 = 406528`, `56·16 = 896`, `896+40 = 936`,
`26017792`, `15·4088 = 61320`, `4096−8 = 4088` — na `ZZ` — **oraz** zgodność
wartości `*_max` R2↔R3 i z pinem T01 `ghost_budget` (`abandoned_at_reinit_max`,
`final_unused_tail_max`); wspólne klucze `RESOURCE_INTERFACE` R2==R3.

---

## 7. Rozliczenie findings F1–F5 (kryteria zlecenia + REVIEW_001)

| # | Kryterium (zlecenie) | Status | Dowód (plik:linia / pomiar) |
|---|---|---|---|
| **F1** | `scope.open` prawdziwie odzwierciedla 28 theoremów Lean | **DOBRZE** | `model/prng_checker.sage:300` → sealed `artifacts/checker_result.json:2111`: „kernel: counter/layout/resource/q-refill in formal/CounterLayout.lean **(28 theorems)**; **ChaCha Word32 rounds stay outside the kernel (explicit boundary)**"; stare „Lean not used (optional in TASK)" usunięte; **28** policzone, core-only (0 importów) |
| **F2** | kernel dowodzi arytmetyki/frame bounds; niepisalność `state[56..255]` i rundy ChaCha nie stają się refinement proofem przez poison test | **DOBRZE** | `REPORT.md:26`: „(`typeOut`, offsets; **arytmetyka ramki**)" (było „…, frame"); `SOURCE_MODEL_BINDING.md:24-26`: „**arytmetykę granic ramki** (sama niepisalność `state[56..255]` wynika ze **struktury zapisów C + kontroli poisonu** — patrz A.4, **nie z lematu kernela**)"; grep „refinement" w `REPORT.md`/`SOURCE_MODEL_BINDING.md` = **0 trafień** (poison/fixtures nie są prezentowane jako refinement); rundy ChaCha jawne poza kernelem (F1) |
| **F3** | 17 semantic files, rzeczywiste receipts, prawdziwe liczby plików | **DOBRZE** | `REPLAY.md:9`: „porównuje **17 plików**" (było 15); `SEMANTIC_FILES.json.count = 17` ✓; tabela receipts: rehearsal **e85f95f3…**, **136 członków** (= liczba wierszy `artifacts/rehearsal_anchor.sha256`), **PASS 17/17, exit 0, 26.0 s** (= `artifacts/fresh_replay.json`:26.0236 s) — komórka „po freeze" wskazuje receipt w DEST, który **istnieje**: `tmp/postfreeze-001/REPLAY_RESULT.json` = `FRESH_REPLAY_PASS`,17/17, **25.54 s**, pin `e37b1e97…` (przeze mnie odczytany); liczby `OUTPUTS141`/`bootstrap39`/`source17` w handoffie zgadzają się z §4 |
| **F4** | `abandoned_bytes_max`/`final_unused_bytes_max` poprawnie nazwanymi maximami z T01, przy wspólnym warunku eventu, nie twierdzeniami o równości zużycia | **DOBRZE** | klucze `*_max` przywrócone w: `model/prng_model.sage:441,447,452`, `model/prng_checker.sage:249`, `RESOURCE_INTERFACE.json`, `artifacts/model_result.json`; wartości **61320**/**4088** niezmienione i równe pinowi T01 `ghost_budget.abandoned_at_reinit_max/final_unused_tail_max` (`RESOURCE_BOUND.json` = `4fc5e10b…`, mój `sage` 13/13); asserty liczbowe dotyczą **wzoru na maksimum** przy `reinit_abandonments=15` (wspólny event), nie zużycia faktycznego; etykiety „max" jawne |
| **F5** | `RUN_003` spójne w bieżących RESULT/CERT/LAYOUT/SEMANTIC; historyczne proweniencje zachowują stare ID | **DOBRZE** | `LAYOUT.json:3` i `SEMANTIC_FILES.json:3`: `task_id = …RUN_003` (generatory `scripts/claims.py:43`, `scripts/semantic.py:23` ujednolicone); `RESULT.json`/`PRNG_LAYOUT_CERTIFICATE.json`: `task_id=…RUN_003`, `continues_from=…RUN_002`, pin `8eda4cb9…`; **historia zachowana bez przepisywania**: `TASK.md:12` nadal `TASK_ID=…RUN_001`, `SOURCE_MODEL_BINDING.md:1,3` nadal „(RUN_002, kernel) / Kontynuacja …RUN_001", treść `INPUTS` bez zmian, `AGENTS_RUN001.md` w `RUN_001`, frozen `RUN_001/002` nietknięte (153/153 + 142/142) |

**5/5 DOBRZE.** Rejestr: `CHECKLIST_F1_F5.md`.

---

## 8. Mój świeży replay (nie receipt autora)

- **Kopia źródłowa:** `W/seed/pkg_003` (rsync z `SOURCE_W`, bez tmp/cache/bin/
  `.build`/locków) — przed i po replayu **141/141** manifest + **61/61** input
  closure DOBRZE (`INTEGRITY.json`).
- **Przed replayem** przeczytałem `scripts/replay.py` i `REPLAY.md`; pełne walidacje
  przed DEST: pełny manifest + zewnętrzny hash.
- **Standard zlecenia, dokładnie:**
  `python3 -B scripts/replay.py <ABS_DEST> e37b1e97ebcfa65d698c52e175c09e826cdbafe565722cc017b5349c00d3f5dc`
  (`DEST = W/replay/INDEPENDENT_001`, **z mojej kopii, nie ze `SOURCE_W`**;
  pełne polecenie w `COMMANDS.log`).
- **Wynik: `FRESH_REPLAY_PASS`, 17/17, mismatches `[]`, exit 0,
  `elapsed_seconds = 525.2369800560009`** — receipt
  `receipts/INDEPENDENT_001_REPLAY_RESULT.json` (kopia z DEST), pola:
  `fresh_project_cache=True`, `original_trees_hidden=True`,
  `only_destination_written=True`, `source_inputs_readonly=True`,
  `network_off=True`, `controller_exit_code=0`.
- **Niezależne porównanie bajtowe** (`checkers/REPLAY_CHECKS.json`): **17/17
  trojstronnie** DEST ↔ moja kopia ↔ `SOURCE_W`.
- **Logi DEST:** `logs/dest_logs/` — **22 pliki,0 nietomnych stderr**; stderr
  kontrolera pusty (`logs/replay_stderr.log`); Lean stdout = sealed,28 twierdzeń.
- **`SOURCE_W` nietknięty** po replayu (piny REPORT/OUTPUTS bez zmian), moje SHA
  `BEFORE==AFTER` dla wejściowych drzew.
- **Uwaga proceduralna:** w trakcie replaya nastąpił restart sesji OCP; proces
  (wrapper) **przeżył** i sam zakończył PASS. **Nie uruchamiałem drugiego workera**
  — jeden wykonawca na W (`FAILED_ATTEMPTS.md` F).

**`fresh_replay = PASS`.**

---

## 9. Zgodność z ograniczeniami zlecenia

- **Tylko W:** HOME/TMPDIR/DOT_SAGE/XDG/cache pod `W/`; brak systemowego `/tmp`
  i tmpfs (`TMPDIR=W/tmp`); **network-off** (bwrap `--unshare-net`);
  **brak Git/commit/push**; **brak edycji danych frozen** (`source_unchanged=true`,
  `run001_untouched=true`, `run002_untouched=true`); **zero subagentów/relay/dudect**;
  joby zakończone; aktywne procesy Lean w `work/B20_001/P01` (inny wykonawca)
  **nie ruszane**.
- **Werdykt wyłącznie z dozwolonej listy**; przy PASS wpisane osobno
  `kernel_complete=false`, `B20_P03_formalization_required=true` i zakres §3.
- **Locale:** `sha256sum -c` raportuję jako **DOBRZE**.

---

## 10. Resztki info (nieblokujące; pełne w `REVIEW_RESULT.json:residuals_info`)

- **R1:** `artifacts/freeze.json:3`, `artifacts/fresh_replay.json:3`,
  `receipts/REPLAY_RESULT.json:3` mają `task_id=…RUN_001` — **stały kod**
  `scripts/freeze.py:33` / `scripts/replay.py:33` (niezmieniony w suplemencie,
  poza zakresem findings F5, które wskazywały `LAYOUT.json`/`SEMANTIC_FILES.json`;
  `TASK_ID=…RUN_001` w `TASK.md` jest zresztą historycznie poprawny). **Dowód
  korzenia:** mój własny receipt też ma `task_id=…RUN_001`, mimo replaya w moim W.
  Merytorycznie neutralne (`*_replay_id`/`*_run_id=RUN_003` już poprawne);
  poprawa wymaga zmiany kodu + regeneracji → **backlog T02/B20_P03**.
- **R2:** nagłówek `SOURCE_MODEL_BINDING.md` „(RUN_002, kernel)" i „Kontynuacja
  …RUN_001" — **celowo niezmienione** (zakaz przepisywania historii; treść wg F2
  już poprawna).
- **R3:** `REPLAY.md` komórka „po freeze" odsyła liczby do receiptu/handoffu —
  receipt **istnieje i zweryfikowany** (17/17,25.54 s, pin `e37b1e97…`), liczby
  podane też w §7/§8.

---

## 11. Granica odbioru / czego NIE akceptuję

- **Nie jest to** pełny formalny dowód kernel-lean ani source-binding do binariów
  (`kernel_complete=false`); **nie traktuję** poison/C fixtures/tekstu jako
  formalnego refinementu (zakaz zlecenia).
- **Poza akceptacją (OPEN):** real PRNG→IID, rozkłady/security (SHAKE/ChaCha),
  KeyGen/sekrety, pełny Sign, BE-hardware, klasy błędów/STAT, „idealne IID",
  całość T02.
- **Odbiór nie jest owner acceptance** (`owner_accepted=false`) i **nie upoważnia
  do publikacji** (`push_authorized=false`).

---

## 12. SHA-256 podsumowujące (pełne, przeliczone z plików)

```
f861be76aae60774ee54e3fb747f4815092405d269d3e8d758649287e63aaca3  zlecenie (dokument)
3b7c2b3bbc7f0b72b3a25d3f2cb32623294f1135acb61d8c65b905eefe1a6168  RUN_003/REPORT.md
e37b1e97ebcfa65d698c52e175c09e826cdbafe565722cc017b5349c00d3f5dc  RUN_003/OUTPUTS.sha256
8860069a6a7768574ef64e6d3abfa0d8bfde01b9fcaafc76fa39cab129f955dc  RUN_003/INPUTS.sha256 (plik)
7b0007c095c51b1fe4c5d94b0b1a0012227aba4df0d1c59cfa8fcd92589fe5f1  RUN_003/TASK.md
03b0612cbe3b18e487bee6399c71c238e5ff3a0527818a7c4330d007b72abae2  bootstrap MANIFEST.sha256
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985  CANDIDATE.sha256 (source17)
b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241  SAGEMATH_RULE.md (2 kopie)
34c49d61f159d7b55171f51ca85b53e3b7c0a321512cc26102161dfd497f2e6a  RUN_001/OUTPUTS.sha256
8eda4cb98b754c5f20c8db2a34ff5055bffd535f626dc12d87b56c816406e5a7  RUN_002/OUTPUTS.sha256
2e9630e595ce95898ad1fb595e8f88bf734297f205090b91490e80328d68ed2c  REVIEW_001/REVIEW.md
907586d4e86eeeede8a64f8a8100cbb84d2bd879ffc70cabb7295f7856f77f78  REVIEW_001/REVIEW_OUTPUTS.sha256
4fc5e10ba15ae5fe806282fc29ccac70311e9803ef23c3d049ce2a8e6859b085  T01/RESOURCE_BOUND.json (pin F4)
64384dffc511182ac34ebdb530a66179b848cb272c6c208614afecf60604eb15  formal/CounterLayout.lean (identyczny R2/R3)
fb95dbed2d135f53620ba0b0e44fd35a1dd700b70ee553bbf58ca023a651ff2a  RUN_001/AGENTS.md (= usunięty AGENTS_RUN001.md)
```

Hash `REVIEW.md` i `REVIEW_RESULT.json` zawiera manifest `REVIEW_OUTPUTS.sha256`
(cały W poza `seed/`, `replay/`, `cache/`, `home/`, `tmp/`, samym manifestem
i jego logiem weryfikacji `logs/review_outputs_check.log` — ten ostatni powstaje
w trakcie weryfikacji manifestu, więc objęty jest autorefencją jak sam manifest);
sumę samego manifestu podaję w podsumowaniu dla właściciela).

---

## 13. Podsumowanie dla właściciela (po polsku)

**Co udało się wykazać:** suplement faktycznie domyka wszystkie pięć uwag
poprzedniego odbiorcy — nie deklaratywnie, lecz w samych artefaktach: `scope.open`
mówi prawdę o 28 twierdzeniach i jawnej granicy ChaCha (F1), „frame" zszedł do
„arytmetyki ramki" z niepisalnością przypisaną strukturze+poison, nie lematowi
kernela (F2), replay mówi o17 plikach i ma rzeczywiste receipts (F3), klucze
wróciły jako `*_max` zgodne z pinem T01 `61320/4088` (F4), `task_id` są spójne
`RUN_003`, a historia (`TASK_ID=RUN_001`, „Kontynuacja RUN_001") nietknięta (F5).
**Rachunek nie został ruszony**: kod `.sage/.py` zmieniony tylko w metadanych,
115 wierszy OUTPUTS identycznych, stdouty Sage/Lean/C **te same hasła** w obu
pakietach,28 twierdzeń bez zmian; **mój świeży replay17/17** i **własny sage13/13**
potwierdzają odtwarzalność i liczby. Pełny diff rozlicza **każdy** z92 wpisów
(26 zmian manifestu +5 root spoza manifestu +54 lustra tmp +7 tylko-jednostronnych)
— bez nie wyjaśnionych różnic.

**Co nie wyszło / co zostaje otwarte:** to dokumentacyjno-eksperymentalny suplement,
**nie formalny proof** — `kernel_complete=false`, `B20_P03_formalization_required=true`;
T02 parent, real PRNG→IID i security **zostają OPEN**. Trzy resztki info (R1–R3)
są nieblokujące; R1 (stałe `RUN_001` w trzech polach `task_id` ze stałych skryptów —
widać też w moim receiptcie) sugeruję dopisać do backlogu T02/B20.

**Co wynik zmienia:** zatwierdza domknięcie findings T02.1 dla `RUN_003` i utrzymanie
pinów `RUN_001/002` — czyli za zgodą właściciela odblokowuje integrację suplementu
do `stages/`. **Nie rusza bramki P03 ani T02 parent.**

**Następny krok:** (1) właściciel weryfikuje pakiet odbioru (`owner_accepted=false`);
(2) formalizacja B20/P03 (Mathlib/Lean4, source binding) jako osobna bramka;
(3) opcjonalnie backlog na R1. **Publikacja wstrzymana** (`push_authorized=false`).

---

**Weryfikacja pokazowa (dla właściciela):**

```bash
cd proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001
sha256sum -c REVIEW_OUTPUTS.sha256        # → każdy wiersz: DOBRZE
```

**Status:** `PASS_SCOPED_SUPPLEMENT` — scoped do F1–F5 + pełnego diffu + niezmienności
rachunku + własnego fresh replaya; **`kernel_complete=false`**,
**`B20_P03_formalization_required=true`**, T02 parent / real PRNG→IID / security
**`OPEN`**; **`owner_accepted=false`**, **`push_authorized=false`**.
