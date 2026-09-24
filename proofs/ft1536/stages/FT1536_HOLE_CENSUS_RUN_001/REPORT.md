# REPORT — FT1536_HOLE_CENSUS_RUN_001

Autor projektu: Niirmata. Status: **PARTIAL_PROOF**.
Zakres: spis dziur tablic proposal i ogólna logika pokrycia okna;
spis cutoffu per-(k,b) jawnie otwarty.

## Wejścia (mrożone piny)
- `stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/formal/CDF.lean`
  `d21ee929b96189fc2fd7d98930ac66b0daa78d14cab6cbe98b8319ffa134a035`.
- `stages/.../SUPPORT_AND_METRICS.md`
  `17e5eaef31ba23596e673e79aba72ba6bb9235413ba1bffb16d49048ee44701a`.
- `stages/.../ERROR_LEDGER.json`
  `5fbeee60d4da281443e0eef54d2b76147eb5a1392c8dbad40ecbed0da62738ae`.

## Udowodnione tezy
1. Spis exact (Sage, ZZ): banki 0..4 mają długość 512, nonzero
   [29,59,118,235,365] i własność prefiksu — **0 dziur wewnętrznych**;
   nośnik każdego poziomu to spójne okno k=0..Kmax.
2. Logika kernelowa (Lean): `prefix_covers_window` — tabela prefiksowa
   pokrywa całe okno; dowody indukcją plus mini-przykłady `decide`.

## Weryfikacja (exit 0)
- `lean HoleCensus.lean`: czysty log, zero `sorry/admit/native_decide`,
  aksjomaty standardowe.
- `sage census_holes.sage` (exact ZZ): HOLE_CENSUS_PASS.

## Jawnie otwarte (nie część tezy)
- Luka nośnika wewnątrz okna = wyłącznie cutoff e>=64: ograniczony
  w ledgerze (`unnormalized_cutoff_tail`), ale spis per-(k,b) wymaga domen
  e_C z etapu POST (PARTIAL) — otwarty.
- Odwrotne `chi2(G_S||K)` nadal nie dowiedzione ani skończone.
