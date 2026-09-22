# REPLAY.md — odtwarzanie pakietu (standard scripts/replay.py)

## 1. Tryb i argumenty

```sh
python3 scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA256
```

- `ABSENT_DEST` — katalog, który **nie może istnieć**; replay tworzy go i tam
  zapisuje wszystko (mirror, wyniki, cache, dziecko `REPLAY_RESULT.json`).
  Po freeze pracujemy wyłącznie do nowych DEST; stary work/cache nie jest
  potrzebny.
- `EXTERNAL_OUTPUTS_SHA256` — zewnętrzny (poza pakietem) pin
  `sha256sum OUTPUTS.sha256`, podany przez prowadzącego/recenzenta.
  Brak cyklu hashy: manifest nie zawiera własnego hasha.

## 2. Kolejność walidacji (TASK §5)

1. **Pełna walidacja manifestu PRZED nowym DEST**: pin zewnętrzny → hash
   `OUTPUTS.sha256`; każdy członek istnieje z zapisanym hashem; zbiór
   członków dokładny (poza wykluczeniami `OUTPUT_SCOPE.md`: `inputs/`,
   `home/`, `tmp/`, `.build/`, sam manifest).
2. Tworzenie DEST i **mirrora** w `DEST/proofs/ft1536/work/pkg/` + kopii
   `DEST/Extra/c/` (historyczna ścieżka 5-poziomowa `check_fft3_error.py`;
   mirror zawiera też `inputs/` dla `verify_inputs.py`).
3. **Fresh project cache**: HOME/TMPDIR/TMP/TEMP/DOT_SAGE pod DEST; żadnych
   zapisów systemowy /tmp/tmpfs; pliki pochodne preparsera Sage pod DEST.
4. **Network-off**: każdy krok pod `unshare -rn` (brak unshare = jawny
   fallback z adnotacją w krokach; bwrap dostępny gdyby potrzebny).
5. Kroki deterministyczne odtwarzają pliki z **prerejestrowanej listy**
   `SEMANTIC_FILES.json → byte_deterministic` (lista ustalona PRZED replayem;
   autorski rehearsal w `artifacts/fresh_replay.json`). Każdy plik listy jest
   porównywany co do bajtów z `OUTPUTS.sha256`: `matches[{path,sha256}]`,
   `mismatches=[]` oczekiwane. **FRESH_REPLAY_PASS = `mismatches==[]` oraz
   exit 0 wszystkich kroków wymaganych** (wymagane = producenci listy
   bajtowej + walidacja wejść `verify_inputs`). Ciężkie kroki semantyczne
   (historyczne `check_fft3_error`/`sage_exact`) są zawsze uruchamiane
   i nagrywane; ich wynik rozliczają `proof/receipts/reproduction_receipt.json`
   i pola `semantic_step_failures` — analogicznie do PDF „osobno" (§2.6).
6. **PDF przebudowany osobno** (semantic, nie w zbiorze dopasowań bajtowych):
   `pdflatex → bibtex → pdflatex ×2`; ocena: powodzenie buildu, liczba stron
  i tekst z `pdftotext` vs PDF pakietu. Wymagana jest zgodność treści, nie
   identyczność bajtów (data/toolchain).
7. Dziecko `REPLAY_RESULT.json` w DEST: `FRESH_REPLAY_PASS`, matches,
   `mismatches=[]`, kroki (argv/exit/sandbox), `pdf_semantic`, scope.

## 3. Pliki semantic_only (reguły)

Reguły poszczególnych wpisów są w `SEMANTIC_FILES.json → semantic_only`
(np. logi z rozwiązaną ścieżką pakietu, wyniki historyczne REUSED, PDF).
`results/fft3_error.json` i `results/sage_exact.json` są rozliczone w
`proof/receipts/reproduction_receipt.json` (reprodukcja pinów
CANDIDATE_R2 — patrz też uwaga o `__name__` w `FAILED_ROUTES.md`).

## 4. Zakazane w replayu

KeyGen/private loader/pełny Sign/`do_sign`, nowe keys/seedy/sekrety, dudect,
sieć, estymator kampanii (komórki pozostają NOT_RUN), cudze joby, zapis do
pakietu źródłowego. Kampania estymatora jest wykluczona z definicji — replay
dotyczy wyłącznie listy z `SEMANTIC_FILES.json`.
