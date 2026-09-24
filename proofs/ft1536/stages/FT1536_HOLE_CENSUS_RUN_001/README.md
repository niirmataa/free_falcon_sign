# FT1536_HOLE_CENSUS_2026-09-24 — spis dziur proposal

Roboczy W (nie frozen, nie do importu bez handoff). Archiwum `stages/` nietknięte.

## Mrożone wejścia
- `stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/formal/CDF.lean`
  (`d21ee929…`): banki 0..4.
- `stages/.../SUPPORT_AND_METRICS.md` (`17e5eaef…`): definicja S
  (n_j,k>0 AND e_C(k,b)<64), koszty warunkowania.
- `stages/.../ERROR_LEDGER.json` (`5fbeee60…`): `unnormalized_cutoff_tail`,
  `CDF_L1`, `tail_upper`.

## Pliki W i wyniki
- `census_holes.sage` — exact `ZZ`: 5×512 wpisów, nonzero
  [29,59,118,235,365], własność prefiksu, **0 dziur wewnętrznych**.
  exit 0, HOLE_CENSUS_PASS.
- `HoleCensus.lean` — ogólna logika: `isPrefix → pokrycie całego okna`
  (`prefix_covers_window`), dowody indukcją, mini-przykłady `decide`.
  `lean`: exit 0, zero warningów, aksjomaty standardowe
  (`propext`, `Classical.choice`, `Quot.sound`).

## Wniosek i jawny zakres
Dziury tabelowe wewnątrz D_j nie istnieją — jedyne zera to ogony poza oknem
(już rozliczone w `tail_upper`). Wewnątrz okna luka nośnika K_C to wyłącznie
cutoff e>=64, ograniczony w ledgerze (`unnormalized_cutoff_tail`), ale bez
spisu per-(k,b): ten wymaga domen e_C z etapu POST (PARTIAL) i zostaje otwarty.
Odwrotne `chi2(G_S||K)` nadal nie dowiedzione.

## Replay
```
lean proofs/ft1536/work/FT1536_HOLE_CENSUS_2026-09-24/HoleCensus.lean
sage proofs/ft1536/work/FT1536_HOLE_CENSUS_2026-09-24/census_holes.sage
```
HOME/TMPDIR/DOT_SAGE pod W (`sage-home/`, `tmp/`).
