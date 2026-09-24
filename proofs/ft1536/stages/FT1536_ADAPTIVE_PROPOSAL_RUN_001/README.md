# FT1536_ADAPTIVE_PROPOSAL_2026-09-24 — wariant obcięty G_S z kosztem ogona

Roboczy W (nie frozen, nie do importu bez handoff). Archiwum `stages/` nietknięte.

## Mrożone piny
- `stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/formal/CDF.lean`:
  bank nonzero 29 / 59 / 118 / 235 / 365.
- `stages/.../source/ft1536-adaptive-cdf-tables.h`:
  nominalne wariancje `[5, 20, 80, 320, 768]`.
- `stages/.../ERROR_LEDGER.json`:
  `conditioning_losses.tail_upper = 25108406.../2^256` (~2^-52),
  metryki TV `1/2^36`, `chi2(K||G)` `1/2^60`, `chi2(G||K) = infinity`.
- `stages/.../SUPPORT_AND_METRICS.md`: `S` skończony, `G` dodatni na całym Z,
  świadek `s_C+367`, koszt warunkowania `t = G(S^c)`.

## Pliki W i wyniki
- `AdaptiveProposal.lean` — logika nośnika w czystym Lean core, bez placeholderów:
  `target_pos`, `proposal_pos_iff`, `counterexample_outside` (z=1000),
  `proposal_covers_support_false` (odrzucenie kierunku `G << K`),
  `proposal_supported_by_target` (`K << G`), `conditioned_covers`
  (pokrycie obciętego celu `G_S` z definicji). `lean`: exit 0, zero warningów,
  tylko standardowe aksjomaty (`propext`, `Quot.sound`, `Classical.choice`).
- `check_support.sage` — exact `ZZ`: okna, kontrprzykład, kierunek. exit 0.
- `check_tail.sage` — rygorystyczne ogony w `RealBallField(256)`:
  wszystkie 5 poziomów `t <= ~2^-112..2^-122`, czyli poniżej mrożonego
  `tail_upper` (~2^-52) i poniżej głównego TV `2^-36`. exit 0.

## Replay
```
lean proofs/ft1536/work/FT1536_ADAPTIVE_PROPOSAL_2026-09-24/AdaptiveProposal.lean
sage proofs/ft1536/work/FT1536_ADAPTIVE_PROPOSAL_2026-09-24/check_support.sage
sage proofs/ft1536/work/FT1536_ADAPTIVE_PROPOSAL_2026-09-24/check_tail.sage
```
HOME/TMPDIR/DOT_SAGE pod W (katalogi `sage-home/`, `tmp/`).

## Jawny zakres / co NIE jest pokazane
- Pokrycie nośnika `G_S` tak; bound ilorazu gęstości `M` nie.
- Dziury w oknie (`n_j,k = 0`, zera kwantyzacji, cutoff `e >= 64`) nie są
  domknięte — odwrotne `chi2(G_S||K)` nie jest tu dowiedzione ani skończone.
- Rozbicie `TV(K,G) <= TV(K,G_S) + t` to tożsamość księgowa lematu;
  Lean dowodzi pokrycie, Sage dowodzi liczbę `t`. Bez podmiany dowodu.
