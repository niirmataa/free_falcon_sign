# PACKAGE — FT_FAMILY_SCALING_CORRECTIONS_RUN_003 (S01): zawartość i odtwarzanie

Poprawiony pakiet rodziny FT po niezależnym odbiorze
`FT_FAMILY_SCALING_REVIEW_RUN_001` (`RESEARCH_REVIEW_CHANGES_REQUIRED`,
ustalenia R1–R7). Materiał wejściowy: przypięty, **nieodebrany** snapshot
CANDIDATE_R2 (`FT_FAMILY_SCALING_2026-09-22_RUN_002`, manifest
`5ee71952…`) — reuse oznaczony pinem (`REUSED_RESULTS.md`), nie wynik tej
pracy. Wejścia bootstrap: 197 członków/195 origins, MANIFEST
`6294e782…` (walidacja: `proof/checks/00_verify_inputs.log`).

Tryb rachunku: **zasada właściciela `FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22`**
(kopia: `supplements/`, SHA `b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241`).
Autorytatywny rachunek i nowe checkery: `scripts/lemma_*.sage`, uruchamiane
`sage scripts/lemma_*.sage` (preparser, `ZZ`/`QQ`, kule `RealBallField`).
`.py` służy organizacji/runnerom. Historyczne przypięte skrypty CANDIDATE_R2
zachowują format i tryb (REUSED).

## 0. Zmiany względem CANDIDATE_R2 (mapowanie w `CORRECTION_MATRIX.md/.json`)

- **R1–R3** — zweryfikowane (REUSED) + nowe wykonawcze kontrole N1–N4
  (`results/controls.json`), diagram strzałek w `ATTACK_PROBLEMS.md` §1.
- **R4** — **naprawione wycofaniem**: aktywny runner
  `scripts/estimator_campaign/run_campaign.sage` (guarded;
  `NOT_RUN_MODEL_UNRESOLVED` przed backendem, SIS→P2 odrzucany przed
  importem), historyczna kopia bajtowa + etykieta
  `scripts/historical/INVALID_FOR_P2.md`, testy mock T1–T8
  (`results/r4_tests.json`). Estymator **nie był uruchamiany**.
- **R5** — rygorystyczny rachunek `scripts/lemma_chi_tail.sage`
  (`results/chi_tail.json`): wyprowadzenie Erlang/Poisson, certyfikowane
  `ogon > 2^−40` (dawna hipoteza obalona — zachowane) i `ogon < 2^−28`;
  próg `2^−28` jawno **PROPOSED** (nie cel projektu / nie poziom bezpieczeństwa).
- **R6** — szkic dowodu FFT3: perturbacja twiddles wymaga osobnego
  wyprowadzenia (mnożnik to placeholder); 12 przypadków nie ustala
  c/domenu/FPEMU; spójność statusu PROPOSED (N6).
- **R7** — tabela layoutu generowana jednoźródłowo
  (`scripts/gen_layout_table.py` + markery + `--check`), FT3072 high-water
  16384 niezależnie przeliczone (N7); taksonomia 9 klas dowodowych w
  `CLAIMS.md` + `CLAIMS.json` z eksportami/przesłankami.

## 1. Zawartość

| plik | rola |
|---|---|
| `REPORT.md`, `RESULT.json` | raport i status |
| `CLAIMS.md`, `CLAIMS.json` | ledger twierdzeń (9 klas, eksporty/przesłanki) |
| `CORRECTION_MATRIX.md/.json` | R1–R7 → stare/nowe miejsca, disposition, evidence |
| `CORRECTIONS.md` | ledger wycofań (§10) + odpowiedzi RUN_002 (§11) i RUN_003 (§12) |
| `ATTACK_PROBLEMS.md` | P1/P2/P3 + strzałki redukcji + kontrolki negatywne |
| `SOURCE_MAP.md` | mapa profili źródeł (REUSED) |
| `PARAMETRIC_TASK_LAYOUT.md` | rekurencje layoutu; tabela z `results/layout.json` |
| `RESEARCH_NOTES_PL.md` | ustalenia/hipotezy; H-B (R5) z wyprowadzeniem |
| `MODEL_BOUNDARIES.md` | granice modeli/klas dowodowych/mapa zależności |
| `FAILED_ROUTES.md` | ścieżki błędne i porzucone (zachowane) |
| `NEXT_INTERFACE.md` | następny interfejs prac |
| `REUSED_RESULTS.md` | reuse z pinami (CANDIDATE_R2, REVIEW, M0/L_V/T01/JOINT/H6P) |
| `HANDOFF.md` | handoff do niezależnego recenzenta |
| `INPUTS.sha256`, `TOOLCHAIN.txt`, `COMMANDS.log` | piny wejść, toolchain, ślad komend |
| `OUTPUT_SCOPE.md`, `REPLAY.md`, `SEMANTIC_FILES.json`, `OUTPUTS.sha256` | zakres/replay/szczelność |
| `supplements/` | kopia zasady SageMath + SHA (wymóg TASK) |
| `paper/` | `main.tex`, `references.bib`, `main.pdf`, `compile.log` |
| `lean/` | FTA2, FTLayout, FTRoots, FTBounds (kernel Lean 4.34) |
| `scripts/lemma_*.sage` | autorytatywny rachunek/checkery (R5, kontrole) |
| `scripts/*.py` | organizacja: hashe, runnery, generator tabeli, testy R4 |
| `scripts/estimator_campaign/` | guarded runner + README (NOT_RUN) |
| `scripts/historical/` | bajtowa kopia wadliwego runnera + etykieta INVALID_FOR_P2 |
| `results/` | wyniki i logi (w tym `chi_tail.json`, `controls.json`, `r4_tests.json`) |
| `proof/checks|checkers|receipts|diffs|drafts/` | kontrole wejść, aksjomaty Lean, receipty, diffy old→new, szkice |
| `artifacts/fresh_replay.json` | sealed wynik fresh replayu autora |

## 2. Odtwarzanie (katalog pakietu jako cwd; tryb wymagany przez zasadę)

```sh
export FT1536_PKG_ROOT=$PWD          # dla lemma_*.sage
# autorytatywny rachunek (SageMath 10.9, preparser):
sage scripts/lemma_chi_tail.sage
sage scripts/lemma_controls.sage
# organizacja / kontrole kodu (Python 3):
python3 scripts/verify_inputs.py
python3 scripts/test_r4_routing.py
python3 scripts/gen_layout_table.py --check PARAMETRIC_TASK_LAYOUT.md
# warstwa kernelowa (Lean 4.34.0; czysty log, brak sorry/admit/native_decide):
LEAN=/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
mkdir -p .build/lean
for f in FTA2 FTLayout FTRoots FTBounds; do
  LEAN_PATH=$PWD/.build/lean $LEAN -j1 -M2048 -o .build/lean/$f.olean lean/$f.lean
done
LEAN_PATH=$PWD/.build/lean $LEAN -j1 -M2048 proof/checkers/AxiomAudit.lean
# historyczne, przypięte skrypty CANDIDATE_R2 (REUSED, ich własny tryb):
python3 scripts/check_geometry.py && python3 scripts/check_layout.py \
  && python3 scripts/check_bounds_table.py
/home/footfalcon/miniforge3/envs/sage/bin/python scripts/check_fft3_error.py
/home/footfalcon/.local/bin/sage scripts/sage_exact.sage   # preparser; SA1–SA6 + GAP
# manuskrypt
cd paper && pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex
# pełny replay (patrz REPLAY.md):
python3 scripts/replay.py ABSENT_DEST <EXTERNAL_OUTPUTS_SHA256>
```

Estymator: **NOT_RUN**; R4 zamknięty wycofaniem, bez uruchomienia kampanii.

## 3. Piny i integralność

- Źródła `Extra/c` = manifest `56974571…` (17 plików, walidacja source17).
- Bootstrap MANIFEST `6294e782…`; CANDIDATE_R2 `5ee71952…`; REVIEW
  `3b4160dc…`/`0319da97…`; zasada SageMath `b6afcdca…` (kopia w `supplements/`).
- Hashy pakietu: `OUTPUTS.sha256` (wszystkie pliki regularne poza nim samym
  i wykluczeniami `OUTPUT_SCOPE.md`); zewnętrzny pin manifestu podaje
  prowadzący poza pakietem (INPUTS.sha256 zawiera także kopię zasady).
- Publikacja zewnętrzna pozostaje wstrzymana do pozytywnego niezależnego
  odbioru i osobnego polecenia właściciela.

## 4. Co pakiet NIE jest

To nie jest oświadczenie o bezpieczeństwie, gotowość FT768/FT3072 ani
benchmark. Koszty ataków = `NOT_RUN`; ogon χ² ≈ 2^−28.32 to statystyka
odrzuceń idealnego modelu ciągłego, nie poziom bezpieczeństwa; próg `2^−28`
jest PROPOSED. Statusy w `CLAIMS.md/.json` są rozstrzygające; kompilacja
lokalnej arytmetyki nie dowodzi C allocatora (`MODEL_BOUNDARIES.md`).
