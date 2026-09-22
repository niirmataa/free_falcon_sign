# DIFF AUDIT — pełne porównanie `RUN_002 → RUN_003` (każda różnica wyjaśniona)

**REVIEW_ID:** `FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001`
**Maszynowy odpowiednik:** `DIFF_AUDIT.json` (schema `FT1536_T021_DIFF_AUDIT_V1`)
**Dowody surowe:** `checkers/diff_r2_r3_manifest.json` (manifest po wierszu),
`checkers/diff_r2_r3_tree.txt` (rekurencyjne porównanie katalogów)

Źródła pary:
- `RUN_002/OUTPUTS.sha256` = `8eda4cb98b754c5f20c8db2a34ff5055bffd535f626dc12d87b56c816406e5a7` (**142** wiersze)
- `RUN_003/OUTPUTS.sha256` = `e37b1e97ebcfa65d698c52e175c09e826cdbafe565722cc017b5349c00d3f5dc` (**141** wierszy)

Cel zlecenia: „Porównaj cały RUN_002→RUN_003; każda różnica ma być wyjaśniona.
Nie ograniczaj się do zadeklarowanej listy pięciu plików. Oddziel zmiany rachunku
od etykiet."

---

## 1. Trzy naliczenia (niezależne)

1. **Manifest po wierszu:** 142 → 141 = **115 identycznych + 26 zmienionych
   + 1 usunięty + 0 dodanych**.
2. **Tree-diff** (rekr., oba katalogi całe): **92 wpisy rozróżnialne**
   = **85 plików różniących** + **7 tylko-jednostronnych**.
3. **`INPUTS.sha256` osobno:** **0 zmian treści** — wszystkie 61 haseł identyczne;
   różnica wyłącznie w absolutnych prefiksach `…/RUN_002/…` → `…/RUN_003/…`
   (plik-manifest ma inną sumę: `59943102…` → `8860069a…` — to efekt prefiksów).

**Rachunek vs etykiety:** `DIFF_AUDIT.json:calculation_vs_labels.zmiany_rachunku = []`
— żadna zmiana nie dotyczy arytmetyki; wszystkie26 to scope/tekst/ID/prefiksy/
regeneracje receiptów-logów ( szczegóły §3 i `REVIEW.md` §6).

---

## 2. Zmienione wiersze manifestu — pełne26 z klasyfikacją

Klasyfikacja maszynowa: `DIFF_AUDIT.json:row_classification` (każdy wiersz ma
przypis kategorii F1–F5 lub typu zmiany; poniżej wg kategorii, z esencją diffu
potwierdzoną linią po linii):

### F1 — `scope.open` (2)
| Plik | Esencja diffu |
|---|---|
| `model/prng_checker.sage` | linia300 `open=`: „…owner acceptance; **Lean not used (optional in TASK)**" → „…; **kernel: counter/layout/resource/q-refill in formal/CounterLayout.lean (28 theorems); ChaCha Word32 rounds stay outside the kernel (explicit boundary)**" |
| `artifacts/checker_result.json` | pole `scope.open` (echo checkera) + hash `model_result` (kaskada z F4) |

### F2 — słowo „frame" (2)
| Plik | Esencja diffu |
|---|---|
| `REPORT.md` | linia26: „kernel (`typeOut`, offsets, **frame**)" → „(`typeOut`, offsets; **arytmetyka ramki**)"; + nagłówek/intro suplementu |
| `SOURCE_MODEL_BINDING.md` | „offsets layoutu56 **i ramki**" → „**i arytmetykę granic ramki** (sama niepisalność `state[56..255]` wynika ze **struktury zapisów C + kontroli poisonu** — patrz A.4, **nie z lematu kernela**)" |

### F3 — liczba plików i receipts (1)
| Plik | Esencja diffu |
|---|---|
| `REPLAY.md` | „porównuje **15** plików" → „**17**"; nagłówek tabeli `RUN_002`→`RUN_003`; wiersz rehearsal: kotwica `0ed9dcc1…`/137 → **`e85f95f3…`/136**,26.4 s → **26.0 s**; wiersz „po freeze": „(poniżej)" → „(receipt w DEST; liczby w handoffie)" |

### F4 — klucze `*_max` (5)
| Plik | Esencja diffu |
|---|---|
| `model/prng_model.sage` | linie441,447,452: `abandoned_bytes`→`abandoned_bytes_max`, `final_unused_bytes`→`final_unused_bytes_max`; **wartości `61320`/`4088` i wzory assertów bez zmian** |
| `model/prng_checker.sage` | linia249: odczyt `t01['abandoned_bytes_max']` (wartości te same) |
| `RESOURCE_INTERFACE.json` | `received_T01`: dwa klucze z sufiksem `_max`, wartości `61320`/`4088` bez zmian |
| `artifacts/model_result.json` | te same dwa klucze w sekcji `t01`/`ghost_budget` |
| `artifacts/checker_result.json` | kaskada: hash `model_result` (reszta identyczna) |

### F5 — `task_id`/ID (6)
| Plik | Esencja diffu |
|---|---|
| `LAYOUT.json` | `task_id`: `…RUN_001` → `…RUN_003` |
| `SEMANTIC_FILES.json` | `task_id`: `…RUN_001` → `…RUN_003` +5 kaskadowych hashów (`model_result`, `checker_result`, `LAYOUT`, `RESOURCE_INTERFACE`, `certificate`) |
| `RESULT.json` | `task_id` `RUN_002`→`RUN_003`, `continues_from` `RUN_001`→`RUN_002`, hash certyfikatu + kaskady |
| `PRNG_LAYOUT_CERTIFICATE.json` | jw. + `predecessor_outputs_sha256` `34c49d61…`→`8eda4cb9…` |
| `scripts/claims.py` | linie21-23: `TASK_ID`/`PREDECESSOR`/`PREDECESSOR_OUTPUTS` na `RUN_003`/`RUN_002`/`8eda4cb9…`; linia43: `task_id='…RUN_001'` → `task_id=TASK_ID` |
| `scripts/semantic.py` | linia23: `task_id='…RUN_001'` → `…RUN_003` |

### Nagłówki/kontekst suplementu (3)
`AGENTS.md` (tytuł „suplement F1–F5 (RUN_003)", zakres „TYLKO sprostowania
F1–F5… matematyka bez zmian"), `CLAIM.md`, `FAILED_ROUTES.md` — kontekst i historia
bez zmian merytorycznych.

### Prefiksy ścieżek (1)
`INPUTS.sha256` — wyłącznie `run002/` → `run003/` w ścieżkach absolutnych;
**61/61 treści identycznych**.

### Regenerowane receipty i logi (8)
`artifacts/freeze.json` (hash REPORTU/komend, ścieżka rehearsal),
`artifacts/fresh_replay.json` + `receipts/REPLAY_RESULT.json` (kotwica `e85f95f3…`,
ścieżki pakietu/DEST, kaskady 5 hashów), `receipts/build.json` (3 × `binary_sha256`),
`receipts/sage_run.json` (2 × `script_sha256`), `artifacts/COMMANDS.frozen.log`
(ścieżki W + `started`; **stdouty9 komend te same hasła**),
`logs/recipe_console.log` (3 × `binary_sha256` +2 × `script_sha256`),
`artifacts/rehearsal_anchor.sha256` (aktualne hashy + brak usuniętego
`AGENTS_RUN001.md`).

**Rachunek unikalności:** suma wierszy tabeli =28 pozycji, ale
`model/prng_checker.sage` i `artifacts/checker_result.json` występują w dwóch
kategoriach (F1+F4) → **28 − 2 = 26 unikalnych wierszy zmienionych** ✔
(pełna lista unikalna: `DIFF_AUDIT.json:manifest_rows.changed_detail` — 26 kluczy,
zgodnych z `checkers/diff_r2_r3_manifest.json`).

---

## 3. Usunięte, dodane, tylko-jednostronne

- **Usunięty z manifestu (1):** `AGENTS_RUN001.md`, hash
  `fb95dbed2d135f53620ba0b0e44fd35a1dd700b70ee553bbf58ca023a651ff2a`
  = hash `RUN_001/AGENTS.md` (przeliczone obu stron) → historyczna kopia zachowana
  w zamrożonym `RUN_001` (153/153 DOBRZE). Bez utraty historii, bez przepisywania ID.
- **Dodane względem manifestu R2:** **0** — suplement nie dodaje nowych artefaktów
  wyjściowych.
- **Tree: 92 = 85 + 7:**
  - **root31** = 26 manifestowych + **5 spoza manifestu**:
    `OUTPUTS.sha256` (sam manifest — z definicji inny), `COMMANDS.log`
    (absolutne ścieżki W + znaczniki czasu; wyłączony z manifestu przez
    `scope.EXCLUDED_TOP`), `bin/prng-harness-normal` (**21 B** różnic),
    `bin/prng-harness-altbranch` (**21 B**), `bin/prng-harness-sanitized`
    (**275 B** — ścieżki/debug ASAN); **behavioralnie identyczne**: dump-y
    (`harness_dump*.json`) w manifeście identyczne, stdout `native_*` = `72401466…`/
    `b0dee8bc…` w obu RUN;
  - **lustra replaya54** = 26 w `tmp/postfreeze-001/` + 26 w `tmp/rehearsal-001/`
    (te same katalogi zmian co root — lustra własnego pakietu) +2 pliki
    `*_console.log` replayów;
  - **tylko-jednostronne7:** `AGENTS_RUN001.md` (root R2, lustro R2 ×2 — usunięty
    także z luster) +4 wpisy nazw podkatalogów `cache/hidden_work: FT1536_…RUN_002`
    vs `…RUN_003` (kryjka oryginalnego drzewa replaya — nazwa katalogu w cache,
    nie zawartość).
- **`INPUTS.sha256`: 0 zmian treści** (§1.3).

---

## 4. Elementy wskazane w zleceniu — rozliczenie

| Element | Status |
|---|---|
| `REVIEW_001` → `REVIEW_003` w `artifacts/manifest.json` i `REPORT.md` | **DOBRZE** (`frozen_result_root_id=…RUN_003`, `frozen_result_index_ids=[…REVIEW_003]`) |
| `AGENTS_RUN001.md` przeniesiony | **DOBRZE** (usunięty; hash=`RUN_001/AGENTS.md`) |
| „tylko source binding i nazewnictwo, bez rachunku" | **DOBRZE** — `zmiany_rachunku=[]`; pełne dowody niezmienności w `REVIEW.md` §6 |
| Zamrożone wejścia `INPUTS` | **DOBRZE** —0 zmian treści |
| Każda różnica wyjaśniona (bez ograniczania się do5 plików) | **DOBRZE** —26/26 manifestowych +5 root spoza manifestu +54 lustra +7 tylko-jednostronnych; **brak nie wyjaśnionych** |

---

## 5. Obserwacje procesowe (nie findings)

1. **Kotwica vs finalne bajty:** `artifacts/rehearsal_anchor.sha256` powstaje
   *przed* ostateczną redakcją dokumentów wynikowych (np. `REPLAY.md` raportuje
   wynik rehearsalu) — hash `REPLAY.md` w kotwicy (`4aa6d7e9…`) różni się od
   finalnego w manifeście (`8fdd27d5…`). To **zaprojektowana kolejność**
   („Schemat kotwicy (bez cyklu hashy)" w `REPLAY.md`): kotwica służy rehearsalowi,
   a **finalne bajty weryfikuje replay po freeze** — mój świeży replay przeszedł
   pełną walidację całego manifestu `e37b1e97…` przed DEST, więc wszystkie141
   finalnych hashów (w tym `REPLAY.md`) są zweryfikowane.
2. **`task_id=…RUN_001` w receiptach** (R1 w `REVIEW_RESULT.json`): stały kod
   `freeze.py:33`/`replay.py:33` — widoczny też w moim własnym receiptcie;
   poza findings F5 (wskazywały `LAYOUT.json`/`SEMANTIC_FILES.json`, naprawione);
   do backlogu T02/B20.

**Wniosek:** pełny diff rozliczony; **0 nie wyjaśnionych różnic**;
`complete_diff_audit = true`, `zero_unexplained = true`
(`DIFF_AUDIT.json`).
