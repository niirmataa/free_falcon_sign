# PACKAGE — FT_FAMILY_SCALING (2026-09-21): zawartość i odtwarzanie

Pakiet roboczy zadania „skalowanie rodziny FT768/FT1536/FT3072"
(zlecenie + przegląd `ft_family_scaling`). Katalog roboczy wg AGENTS:
`proofs/ft1536/work/FT_FAMILY_SCALING_2026-09-21/` (nie jest commitowany
przez wykonawcę; odbiór i ewentualny freeze/archiwizacja należą do
prowadzącego sesję).

## 1. Zawartość

| plik | rola | język |
|---|---|---|
| `SOURCE_MAP.md` | mapa źródeł: tabela profilów, kwarantanna Gaussian-like, dowody braku FT768/3072 (przegląd 10.1) | PL |
| `CORRECTIONS.md` | odpowiedź na każdy punkt przeglądu + ledger wycofań (10.2) | PL |
| `PARAMETRIC_TASK_LAYOUT.md` | jedno prawdziwe zadanie parametryczne: rekurencje layoutu (10.3) | EN |
| `ATTACK_PROBLEMS.md` | poprawne definicje problemów P1/P2/P3 + inwentarz ataków (10.4) | EN |
| `CLAIMS.md` | ledger twierdzeń: zakres, przesłanki, klasa weryfikacji (10.5) | EN |
| `RESEARCH_NOTES_PL.md` | ustalenia, hipotezy, otwarte pytania, następne cykle, ślad bibliografii | PL |
| `paper/main.tex`, `paper/references.bib` | manuskrypt (10.6, LaTeX na końcu) | EN |
| `paper/main.pdf`, `paper/compile.log` | zbudowany PDF + log kompilacji | — |
| `lean/*.lean` | warstwa kernelowa (Lean 4.34.0, czysty log) | — |
| `scripts/*.py`, `scripts/sage_exact.sage` | obliczenia i walidacje | — |
| `scripts/estimator_campaign/` | szkielet kampanii estymatora — **NOT_RUN** | — |
| `results/*.json`, `results/*.csv`, `results/*.log` | pełne wyniki i logi | — |

## 2. Odtwarzanie (względne ścieżki z katalogu pakietu)

```sh
# warstwa kernelowa (Lean 4.34.0; czysty log, bez sorry/admit/native_decide)
LEAN=/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
for f in FTA2 FTLayout FTRoots FTBounds; do $LEAN lean/$f.lean; done

# obliczenia (Python 3.13, biblioteka standardowa)
python3 scripts/check_geometry.py
python3 scripts/check_layout.py
python3 scripts/check_bounds_table.py
sage scripts/check_fft3_error.py      # oracle MPFR 256-bit; czyta tylko
                                      # Extra/c/fpr-emulated.h; UWAGA:
                                      # sage plik.py = Python BEZ preparsera
                                      # (dawne `sage -python` tu nie istnieje)

# warstwa dokładna (SageMath 10.9 z prepapserem; SA1-SA6 + GAP)
sage scripts/sage_exact.sage

# manuskrypt
cd paper && pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex
```

Kampania estymatora: `scripts/estimator_campaign/run_campaign.sage` —
`NOT_RUN`; warunki wstępne w jego README (10.4 przeglądu).

Środowisko użycia: Linux x86_64; skrypty Python nie mają zależności; Sage
używa GAP do spisu podgrup; Lean 4.34.0 bez Mathlib (moduły self-contained).
Wyniki w `results/` pochodzą z wykonania 2026-09-21 w tym środowisku.

## 3. Piny i integralność

- Snapshot repo: `683b71be3e5f988d494431e46ac643169d93764a` (main),
  snapshot zlecenia `56700dd…` — różnica opisana w `SOURCE_MAP.md` §5.
- źródła: manifest `Extra/c` = `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
- Hashy plików pakietu: `SHA256SUMS` (generowany przy odbiorze; patrz niżej).
- Prywatnych kluczy, seedów i cache w pakiecie **nie ma**; KAT-y repo nie są
  tu kopiowane.

## 4. Co pakiet NIE jest

To nie jest oświadczenie o bezpieczeństwie, gotowość FT768/FT3072 ani
benchmark wydajności. Tabele kosztów ataków są `NOT_RUN` (zgodnie z
przeglądem 10.4); statusy twierdzeń w `CLAIMS.md` są rozstrzygające.
