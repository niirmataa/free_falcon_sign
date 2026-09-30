# S3 — provenance of the `~1.27e-24` constant and the exact shape of `e`

Step S3 of `development/T12_1/END_TO_END_SCOPE.md`. Recorded 2026-10-01.

## The constant: `delta`, a miss-probability bound

`1.27e-24` is the rounding bound **`delta` = the probability that a
POSITIVE Sign reply is rejected** (the centering/wrap error channel).

Sources (all byte-tracked):

- `run2/formal/CenteringClosure.lean` (sha256 `b2b9d129...`, byte-identical
  to the GAME_BINDING_RUN_002 copy): the kernel closure with **exactly two
  named premises** — `bridge_lb_rawLo : 1265/10^27 < bridgeLb * rawLo` and
  `honest_upper_lt_claim : honestHi < 127/10^26` (via `norm_num` on the
  rational literals `honestLo`/`honestHi`), giving
  `1.265e-24 < delta < 1.27e-24` with slack;
- the pinned numeric engine result `arb_radial_result.json`:
  `single_change_modular` = `[1.26606846923775048079607e-24 +/- 3.47e-48]`
  .. `[1.26782517099974631855363e-24 +/- 4.13e-48]` (rigorous Arb balls);
- `docs/centering_interval_closure.PINNED.json` (rounded literals
  `1e-24 / 1.3e-24 / 1.27e-24`).

## The exact shape of `e` (from the pinned formal types)

- `FT1536.Divergence` (MTISIS stage):
  `AC j p := forall x, p.mass x = 0 -> j.mass x = 0`;
  `second j p := sum x, j.mass x ^ 2 / p.mass x` (= chi^2 + 1).
- `FT1536.GameLaw.LocalCert`: `second_cert : second sim (joint fill body)
  <= 1 + e` for the FULL `(c,o)` law of ONE fresh `S.run` call against the
  honest fresh-Sign law `honestCO = uniform_Rq(c) x signBody(h,c)(o)`;
  the reply law carries the hit/miss split (`Option BoxVec`).
- `Run2.ConcreteReduction.concrete_euf_cma_to_mt_isis`:
  `AdvEUF <= min 1 (epsColl + phi ((1+e)^qs - 1) (AdvMT (qh+1)
  (SigmaMath.muH muKey) (Reduction.build ...)))`, with
  `epsColl = min 1 ((qs*qh + qs*(qs-1)/2) / 2^320)` exact.

## The gap the audit pointed at (now precisely stated)

`delta` bounds a REJECTION PROBABILITY; `e` must bound a CHI-SQUARE of the
full emitted reply law. These are different functionals and the
**delta -> e composition is exactly the missing B4 bridge**: how the
single-change modular perturbations and the hit/miss split accumulate into
`second sim honest <= 1+e` for one `S.run`. The sign loop structure is
pinned (`SIGN_MAX_ATTEMPTS = 16`, enforced by `#error` since "the FT1536
candidate retry proof requires SIGN_MAX_ATTEMPTS=16").

Where each conditioning belongs (correcting the earlier accounting note):

- key-law conditioning (D1, measured `p_accept = 0.34671`) shapes
  `SigmaMath.muH muKey` — WHICH LAW the MT-ISIS hardness is assumed for;
  no numeric factor of `e`;
- the SIGN sampler's internal rejection (Bernoulli/exp, cap 16) is part of
  `S.run`'s law itself (incl. the miss output) — `e` is for THAT law.

## B4 toolkit lemmas (kernel, next)

- `second_le_of_pointwise`: `(|j x - p x| <= d * p x)` everywhere, `AC j p`
  => `second j p <= (1+d)^2` (hence `e <= (1+d)^2 - 1`);
- conditioning transfer (fallback): `second (j restricted to A / mass j A)
  p <= second j p / (mass j A)^2`;
- hit/miss transfer: moving at most `m` mass to the miss point.
Primary route stays a DIRECT analysis of the emitted law (the heavy
analytic paths); the transfers are conservative fallbacks.
