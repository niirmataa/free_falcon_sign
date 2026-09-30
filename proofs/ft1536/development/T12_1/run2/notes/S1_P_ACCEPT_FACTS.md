# S1 findings — per-attempt acceptance of the C KeyGen (the D1 conditioning event)

Scope step S1 of `development/T12_1/END_TO_END_SCOPE.md`. Source of truth:
the pinned M0 `Extra/c/falcon-keygen.c` (sha256 `0a09b6ed...`, byte-identical
to the M0 profile pin and to live `Extra/c`). All values are
version-invariant under the FLOOR_CT fix (bit-equivalence over all 2^64
words, `FloorWord.all_word64_equivalence`).

## The per-attempt acceptance predicate (the conditioning event)

An attempt samples `f,g` from the secret sampler and runs these gates
IN ORDER (the algorithm comment of `falcon_keygen_make` + the six
`fg_probe_stats.reject_*` counters):

1. `reject_resultant_f` / `reject_resultant_g` — `Res(f,phi)` and
   `Res(g,phi)` must both be odd (the NTRU solver requires it);
2. `reject_norm` — `||(f,g)||` must not exceed the acceptance bound
   (expected norm `1.17*sqrt(q)` in the binary branch);
3. `reject_gs` — the Gram-Schmidt row `B~_{f,g}` norm must not exceed its
   bound (ternary branch: tuned via `TERNARY_KEYGEN_BOUND_SCALE_NUM/DEN`);
4. `reject_public` — `f` invertible mod phi mod q (needed for `h = g/f`);
5. `reject_solve` — `solve_NTRU` must produce `F,G` with `fG - gF = q`;
6. the **mandatory leaf certificate** `ft_keygen_leaf_certificate`
   (function at line 7690, call site line 8110) must return 1.

    Accept(f,g,F,G) := all six gates pass;
    p_accept       := P_{f,g <- sampler}(Accept);
    Law(emitted key) = Law(attempt | Accept)   [D1 refinement (i)]

## Attempt loop and the cap

- Loop: `falcon_keygen_make`'s `for(;;)` (starts line ~7865), ternary
  branch counts `local_attempts`.
- Cap: `TERNARY_KEYGEN_MAX_ATTEMPTS = 3000000` (line 92-93), checked at
  line 7868-7869 (`#if TERNARY_KEYGEN_MAX_ATTEMPTS != 0`; 0 disables the
  cap). Exhaustion: `fg_probe_stats.attempt_limit_hits ++` and `return 0`.
- Call-level availability: `P(keygen returns 1) = 1 - (1-p_accept)^cap`.
  The cap is availability only; it does not shape the emitted-key law.

## Empirical hints and the measurement interface

- The code's own estimate (algorithm comment): the norm step passes
  "about 1/4th of the time" in the binary branch ("we expect sampling new
  (f,g) about 4 times"). Ternary mode: bound tuned by the SCALE macros.
- `FG_DISTRIBUTION_PROBE` (compile-time) instruments exactly the right
  estimators: `attempts`, `successes`, `attempt_limit_hits`, per-gate
  reject counters, coefficient histograms (`falcon_fg_probe_write_csv`).
  A probe run on public synthetic inputs would give `p_hat =
  successes/attempts` and the per-gate conditional chain. This is a
  MEASUREMENT, not a proof; the kernel goal is a rigorous lower bound on
  `p_accept` (or a direct conditional second-moment analysis).

## Consequences for the D1 accounting and the vacuity guard

- The conservative certificate constant is `e^cond <= (e^uncond + gap) /
  p_accept`. With the hint `p_accept = O(1/4)`-ish times the further
  gates, the blow-up factor is modest (single digits), so `e^cond` should
  remain in the usable range — the vacuity guard (D1 refinement (iii)) is
  provisionally UNLIKELY to fire, pending measurement/rigorous bound.
- For B1 (Astra): the attempt-loop semantics deliverable of the adapted
  B1 prompt = exactly the six gates + cap + return structure above; her
  named predicates should mirror this decomposition.
- For B4: the conditional second moment can be analyzed either through
  the conservative `1/p_accept` factor or directly as
  `E[w^2 | Accept] / E[w | Accept]^2` (sharper); the six-gate structure
  above is the conditioning to carry.

## MEASURED (owner-approved control, 2026-10-01 — empirical, not proof)

W=`proofs/ft1536/work/FT1536_FG_PROBE_P_ACCEPT_001` (receipt
`out/RECEIPT.json`). Built with the EXACT derived Makefile profile
(BOUND_SCALE 1250/100 verbatim — the heavy analytic tuning) plus the
single instrumentation define `-DFG_DISTRIBUTION_PROBE`; transparency
control PASS (probe vs clean build, identical seeds -> identical key
digests, so the instrumentation is observation-only and the measured law
is the profile law).

- `p_accept = 8192/23628 = 0.34671` (sigma ~ 0.0031); control run 256/739
  = 0.34641 (consistent). `1/p_accept = 2.88` — SINGLE DIGITS: the D1
  vacuity guard does not fire.
- Per-gate rejects over 23628 attempts (exact accounting
  15436 + 8192 = 23628): `gs = 12303` (79.7% — the Gram-Schmidt gate is
  the dominant filter), `solve = 1551`, `public = 814`, resultants `768`,
  `norm = 0` (the 1250/100 bound rejects nothing — the norm gate is
  effectively pass-through in this profile).
- Conditional chain (first-failing-gate order): resultants 0.9675 ->
  norm 1.0 -> gs 0.4618 -> public 0.9229 -> solve 0.8408 = 0.3467.
- `max_attempts_per_keygen = 24`, `attempt_limit_hits = 0` (cap 3e6 never
  approached); `stddev_f = 0.818 ~ sqrt(2/3)` (uniform ternary).

Open: rigorous `p_accept` lower bound (kernel, S3/B4) — the measurement
is a control and a vacuity check, not a proof. Per-gate conditional rates
above are the conditioning structure to carry into the B4 second moment.
