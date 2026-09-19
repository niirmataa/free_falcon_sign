# Niezależny odbiór H3_NODE3 — 2026-09-19

**PASS: H3_NODE3_PROVED_FOR_PINNED_MODEL**, w zadanym zakresie
split_top → Adj → LDL_dim3 obu root branches i wszystkich 256 slots każdej.
Zachowano mieszany zakres: dowód analityczny, exact certificates i lematy Lean.

Baza odbioru: `89a29a4ca5c9f3c1ecefcd5ebfa08ac9d0c215f1`.
REPORT: `00cff5cd09b8eb083cbb32943f853911b77710781f76016c4adb9e7938e0ff97`.
OUTPUTS: `a4a4116bcf1bbbdd5e73c49cf15828f81fa2eb6d7e05f6b9f81a06a2b6b7dd72`.
Import sprawdził 598 członków OUTPUTS i 112 publicznych records INPUTS.

## Replay i kontrola wykonania

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_H3_NODE3_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Świeża kopia bez wcześniejszych olean/bin/cache, ukryte Dokumenty/H,
odłączona sieć, zapis tylko w kopii roboczej. Exit0, 36.491 s,
**123/123 plików znaczeniowych zgodnych** z zamrożonym receipt.

- 21 modułów Lean4.34/Std, 115 twierdzeń (16 nowych), pełne czyste final logs;
  15 odziedziczonych modułów identycznych z ROOT_LDL, przebudowanych.
- C normal/ASan/UBSan: 512 physical frequency cases i 8192 raw words,
  176 scalar pairs w rozszerzonej domenie, exact source inverse3.
- QQ/RBF oracle: 4096 complex outputs, porównania independent split/Schur
  oraz projected-H; bez host double jako oracle.
- Osiem mutacji, no-op, real-slot noninterference, repeated const aliases,
  canaries i scratch reuse. Dwa invalid preflights zatrzymane przed C call.

[Execution](execution.json), [review checks](review_checks.json),
[formal audit](artifacts/formal_audit.json), [replay result](REPLAY_RESULT.json).
Wszystkie streams wskazane przez receipts/drivery, także toolchain/model,
sprawdzono SHA-256 i zachowano pod względnymi ścieżkami.
[VALIDATION.sha256](VALIDATION.sha256) obejmuje 136 plików; SHA-256:
`af44c49b29eb564a71a0f98abe9a592926a7229030917fffe606ea1d6e27e670`.

## Przegląd matematyczny i granice

Przejrzano [ANALYTIC_PROOF](../../stages/FT1536_H3_NODE3_RUN_001/ANALYTIC_PROOF.md),
[ROOT_CONSUMPTION](../../stages/FT1536_H3_NODE3_RUN_001/ROOT_CONSUMPTION.md),
[NODE3_FRAME](../../stages/FT1536_H3_NODE3_RUN_001/NODE3_FRAME.md), source,
dataflow model i exact QQ/number-field/RBF certificate. Piny: review_checks.

1. P_key jest niezmienione. Obie branches korzystają ze źródłowo związanego
   ROOT, a branch1 z correlated spectrum envelope, nie luźnego error2^22.
2. Split map i phased unitary Hermitian identities są sprawdzone niezależnie.
   Sześć source mul używa kappa bits `3fd5555555555555`, czyli
   `1/3-1/(3*2^54)`, nie idealnego1/3 w definicji modelu.
3. Hermitian comparison H zachowuje actual offdiagonal words i Re(t0).
   Kernelowy dataflow rozlicza niezależność L/real pivots od samego Im(t0)
   PO split. Nie usuwa imaginary inputs przed split.
4. H≥lambda I oraz near-equal offdiagonal moduli dają bound exact-H L21<3.
   Source kolejność ustanawia t0 domain, d11 positivity przed final div,
   następnie L21<4 i d22 positivity. Domena div[1/16,2^35] ma własny proof.
5. Imaginary errors i storage lifetimes pozostają jawne. Defined-prefix
   frame nie dowodzi totalności wcześniejszej lub niższej rekurencji.

| Eksport | Branch0 | Branch1 |
|---|---|---|
| Re(t0) lower / upper | 1/4 / 2^24 | 16 / 2^33 |
| Re(d11),Re(d22) lower / upper | 1/8 / 2^25 | 8 / 2^34 |
| abs Im(t0) | 0, raw+0 | ≤32 |
| abs Im(d11),abs Im(d22) | ≤1/256 | ≤33,≤34 |
| norms L10,L20 / L21 | <2 / <4 | <2 / <4 |

Pełny c3 i mocniejsze relacje source-to-H:
[NODE3_CERTIFICATE.json](NODE3_CERTIFICATE.json). Granice do niezależnego
exact reference są osobnym wynikiem; nie zastępują positivity argumentu.
`full_node3_theorem_kernelized=false`: pełna kompozycja jest analityczna,
wsparta exact certificates i Lean, nie pełnym kernelowym modelem C/GCC.
Finite controls ani odtworzenie tekstu nie są dowodem tej uniwersalności.

Następny obowiązek to pierwszy split_deep/Adj/LDL_dim2 dla 2×3 diagonal
branches, po 128 frequencies. Potrzebne są eksportowane korelacje real/imag,
nie tylko niezależne endpointy. Lower tree, initial targets, ordered Reach,
sampler law i security reduction pozostają otwarte. Odpowiadające flagi są
false; odbiór nie nadaje owner acceptance.

Przypięte kopie i whitespace zachowano bajtowo. Kontrola nowej dokumentacji
jest oddzielona od frozen źródeł, generowanych slices i surowych logów.
