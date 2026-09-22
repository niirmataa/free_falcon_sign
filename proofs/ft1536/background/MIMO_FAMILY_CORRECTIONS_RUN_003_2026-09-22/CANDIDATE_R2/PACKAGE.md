# PACKAGE — FT_FAMILY_SCALING (2026-09-22, RUN_002): zawartość i odtwarzanie

Poprawiony pakiet zadania „skalowanie rodziny FT768/FT1536/FT3072", wersja
po niezależnym odbiorze `FT_FAMILY_SCALING_REVIEW_RUN_001`
(`RESEARCH_REVIEW_CHANGES_REQUIRED`, ustalenia R1–R7). Wersja 2026-09-21
(`work/FT_FAMILY_SCALING_2026-09-21/`) jest zachowana i niezmieniana;
jej snapshot bajtowy jest w archiwum odbioru.

Katalog roboczy wg AGENTS: `proofs/ft1536/work/FT_FAMILY_SCALING_2026-09-22_RUN_002/`
(niecommitowany; odbiór i ewentualny freeze należą do prowadzącego sesję).

## 0. Zmiany względem wersji 09-21 (mapowanie w `CORRECTIONS.md` §11)

- **R1–R3** — `ATTACK_PROBLEMS.md` przepisane jako *game interface repair*:
  typowane `Forge/Extract/Solve_rel`, poprawne strzałki redukcji, cele z
  tabeli ROM M0 (nie z wyboru przeciwnika), union bound zamiast `(1−p)^Q`,
  rozdzielenie P1a/P1b z brakującym krokiem F,G, kontrole negatywne N1/N2.
- **R5** — MODEL_CHI2_IDEAL dokładnie zdefiniowany; certyfikowany ogon
  `2^−28.32` (kryterium „zgodne z modelem" ≤ 2^−28); jawne: ogon ≠ bity
  bezpieczeństwa. `CLAIMS.md` C19.
- **R6** — status `PROPOSED_BOUND` spójny w abstrakcie, wnioskach i CLAIMS;
  jawny obowiązek wyprowadzenia perturbacji twiddles.
- **R7** — poprawiony wiersz high-water FT3072 (16384) generowany z
  `results/layout.json`; nowa taksonomia klas dowodowych w `CLAIMS.md`.
- **R4 — ODROCZONY decyzją właściciela** („nie ruszaj estymatora"):
  `scripts/estimator_campaign/` bez zmian; sprzeczność szkieletu pozostaje
  OPEN i musi być zamknięta przed jakimkolwiek runem.

## 1. Zawartość

| plik | rola | język |
|---|---|---|
| `SOURCE_MAP.md` | mapa źródeł: tabela profili, kwarantanna Gaussian-like, dowody braku FT768/3072 | PL |
| `CORRECTIONS.md` | odpowiedź na przegląd v1 + ledger wycofań (§10) + odpowiedź R1–R7 (§11) | PL |
| `PARAMETRIC_TASK_LAYOUT.md` | rekurencje layoutu (zadanie parametryczne) | EN |
| `ATTACK_PROBLEMS.md` | modele problemów P1/P2/P3 po naprawie gry (R1–R3) | EN |
| `CLAIMS.md` | ledger twierdzeń (C1–C20) z taksonomią klas | EN |
| `RESEARCH_NOTES_PL.md` | ustalenia, hipotezy (H-B wycofana/wynik ujemny), otwarte pytania, Sage | PL |
| `paper/main.tex`, `paper/references.bib` | manuskrypt | EN |
| `paper/main.pdf`, `paper/compile.log` | PDF + log kompilacji | — |
| `lean/*.lean` | warstwa kernelowa (Lean 4.34.0, czysty log) | — |
| `scripts/*.py`, `scripts/sage_exact.sage` | obliczenia i walidacje | — |
| `scripts/estimator_campaign/` | szkielet kampanii — **NOT_RUN, niezmieniony w tej turze** | — |
| `results/*.json`, `*.csv`, `*.log` | pełne wyniki i logi | — |

## 2. Odtwarzanie (względne ścieżki z katalogu pakietu)

```sh
# warstwa kernelowa (Lean 4.34.0; czysty log, bez sorry/admit/native_decide)
LEAN=/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
for f in FTA2 FTLayout FTRoots FTBounds; do $LEAN lean/$f.lean; done

# obliczenia (Python 3.13, biblioteka standardowa)
python3 scripts/check_geometry.py
python3 scripts/check_layout.py        # tabele layoutu z results/layout.json
python3 scripts/check_bounds_table.py

# kontrola FFT3: oracle MPFR 256-bit przez sage.all (Sage 10.9)
sage scripts/check_fft3_error.py       # UWAGA: sage plik.py = Python BEZ
                                       # preparsera (dawne `sage -python`
                                       # w Sage 10.9 nie istnieje)

# warstwa dokładna całkowita (Sage 10.9 z prepapserem; SA1-SA6 + GAP)
sage scripts/sage_exact.sage

# manuskrypt
cd paper && pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex
```

Kampania estymatora: `scripts/estimator_campaign/` — `NOT_RUN`; przed
jakimkolwiek runem wymagane jest zamknięcie R4 (naprawa szkieletu) oraz
warunki wstępne z `ATTACK_PROBLEMS.md`.

Środowisko: Linux x86_64; Python bez zależności; Sage 10.9 (GAP do spisu
podgrup, MPFR do oracla FFT3); Lean 4.34.0 bez Mathlib. Wyniki w `results/`
pochodzą z wykonania 2026-09-22 w tym środowisku.

## 3. Piny i integralność

- Snapshot repo przy pracy: `main` (właściciela), źródła `Extra/c` = manifest
  `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`
  (niezmienny w obu wersjach).
- Hashy plików pakietu: `SHA256SUMS`.
- Odbiór pierwszej wersji (z zachowanym snapshotem 09-21): checkpoint
  `FT_FAMILY_SCALING_REVIEW_RUN_001`, status
  `RESEARCH_REVIEW_CHANGES_REQUIRED`; publikacja zewnętrzna pozostaje
  wstrzymana do pozytywnego odbioru poprawionego pakietu.

## 4. Co pakiet NIE jest

To nie jest oświadczenie o bezpieczeństwie, gotowość FT768/FT3072 ani
benchmark. Koszty ataków = `NOT_RUN` (estymator odroczony); ogon χ² = 2^−28.32
to statystyka odrzuceń idealnego modelu, nie poziom bezpieczeństwa.
Statusy twierdzeń w `CLAIMS.md` są rozstrzygające.
