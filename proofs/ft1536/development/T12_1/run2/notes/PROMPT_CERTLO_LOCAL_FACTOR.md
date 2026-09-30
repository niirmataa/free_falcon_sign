# PROMPT — new window: tilted local factor for certLo (P2' route)

Workspace: `proofs/ft1536/development/T12_1/run2/` (confirmed working
directory; small commits + push, 3-commit batches with a subagent review of
the whole batch before the push; commit messages in English, standard
cryptography register; WORK_STATE updated per batch).

**File ownership (avoid conflicts):** this window creates and edits ONLY its
own new files: `formal/TiltedLocal.lean`, `sage/check_cert_lo.sage`, and its
own notes under `notes/`. The main lane owns `formal/ConvStruct.lean`,
`formal/FinalDelta.lean`, `formal/ConvolutionCert.lean`, `formal/FinalTails.lean`
— treat them as READ-ONLY dependencies.

## Goal

Close the analytic lower bound for `certLo` (the Cramer-tilted local factor),
i.e. prove kernel-side a rigorous lower bound for the window probability of
the 1535-fold convolution in the tilted measure, precise enough to support

    certLo : engineLo - aliasCap <= 4*768*engineTriangleLo

with the required relative accuracy **~7.83e-10** (the wrap allowance
`aliasCap/engineLo`; L0 pre-check result).

## Exact math shape (owner correction 2026-09-30 — use it verbatim)

    P(S in I) = M(lambda)^1535 * E_lambda[e^{-lambda S} * 1_I]
    M^1535 * e^{-lambda*T2} * P_lambda(I) <= P(S in I)
      <= M^1535 * e^{-lambda*T1} * P_lambda(I)

with the weight `e^{-lambda S}` kept VARIABLE inside the window (no
single-factor `e^{-Lambda*}` shortcut). The upper side is already closed in
`ConvStruct.windowSandwich` + `weightedWindowMass_le_full` + `mgf1_eq`;
this window's job is the LOWER side: bound `P_lambda(I)` from below
(equivalently the complement tails `P_lambda(I^c)` from above) at the
sector windows, and compose with `windowSandwich`'s lower factor.

Available kernel toolkit (ConvStruct, all clean 0/0, standard axioms):
- `weightedWindowMass`, `windowSandwich` (two-sided, variable weight),
  `weightedWindowMass_true`, `weightedWindowMass_mono`,
  `weightedWindowMass_le_full`, `weightedWindowMass_split`;
- `sum_imp_exp_bound`, `sum_imp_exp_bound_neg` (Chernoff, both half-lines);
- `mgf1_eq` (`mgf_1(ell) = blockSum (c0-ell) / blockSum c0` — the theta
  layer; `blockSum`/`c0` from `MgfProduct`/`BlockTheta`);
- `hex_twist_shift`, `hex_twist_shift_exp`, `hex_twist_shift_exp_delta`,
  `twist_exponent_identity` (sector twist: shift `u = kappa/s`,
  `kappa = ell*18433`, `s = c0 - ell`);
- `a2Tower`, `a2Tower_atom`, `a2Tower_total`, `a2Tower_mass_bounds`
  (TriangularGaussian tower with real LDL shear; generic
  `triangular_mass_bounds` at n=2, error ~2^-46);
- `box_sum_le_tsum`, `centeredEnergy_region1` (Qc - Q = 18433*delta,
  delta = 18433-2a-b on the sector), `engineGapHi_le`, `hiT1_ge`,
  `exp_neg_hiT1_le`, `shiftedBlockQ` (+ unfolding), `blockWeight_eq_exp`.
REUSE from the T5/REFINE lanes (read-only): `Run2/T5ScalarMass`
(`uniform_shifted_mass_3072`, `rowRatio = 2^-48`, `CoefficientRange`),
`Run2/TriangularGaussian` (`Tower`, `atom`, `scale`, `total`,
`triangular_mass_bounds`), `Run2/ShiftedGaussian` (`complex_poisson_shift`,
`dual_series_deviation`, `shiftedMass`, `continuousMass`), `Run2/A2Theta`.

## Numeric facts (from L0/L0b pre-checks — do not re-derive)

- Pinned engine endpoints: `engineLo`/`engineHi`, `aliasCap`, `missCap`
  (RawRadialEnclosure literals); sector vertex arithmetic:
  `Qc_max = 254803968` at `(a,b) = (9217, -9216)`, `Tmin = 1839095392`.
- Required wrap/local allowance <= 7.83e-10 relative; the coarse bound is
  dead by 27 orders of magnitude (route P1 unusable; verdict P2').
- Engine `.so` pin and `arb_radial_result.json` are registered in
  `T12_1/LARGE_ARTIFACTS.json`; repro store path via `FT1536_REPRO`
  (default resolves to the work/ store).

## Hard rules (non-negotiable)

1. ZERO `sorry`/`admit`/`native_decide` — **including placeholders in
   drafts**; drafts live in the conversation, never in the file. On any
   garbage in an edit: restore the clean state immediately.
2. No long inline expressions in theorem statements: define helpers (`def`)
   first, then small pointwise identities, then compose.
3. Compile serially through `tools/original/run_lean_guarded.sh` (it waits
   for free CPU windows); grep for forbidden tactics before EVERY compile;
   logs must be 0 err / 0 warn (the error counter must match `error(\(|:)`).
4. Sage via `sage <file>.sage` with asserts; exact ZZ/QQ; rigorous Arb
   balls; floor on ZZ (`//`), never `//` on QQ (the check_tail_chain lesson).
5. WORK_STATE (notes/GAME_BINDING_WORK_STATE.md) updated at each batch.
6. Path discretion: no locations outside the repository in new materials.

## Known traps (hard-won, from this lane)

- Cast forms: `((x : ℤ) : ℝ)` per-piece vs `↑(Σ+Σ−E)` are DIFFERENT terms;
  statements and rewrites must use matching forms (`exact_mod_cast` bridges).
- `open` with one wrong identifier kills the whole command — prefer full
  opens of the needed namespaces.
- `simp [h]` where `h : a = b ∧ P a` substitutes inside `P` — do
  `rcases ... with ⟨h1, h2⟩; subst h1` first, then `simp [indicator, h2]`.
- `obtain ⟨..⟩ := hp` CONSUMES `hp`; use `hp.2`/`have` if needed later.
- No extra tactics "just in case" (`No goals to be solved`); `field_simp`
  often closes goals alone; `push_cast` doing nothing triggers the linter.
- Names in this fork: `Summable.sum_le_tsum` (method, not `Finset.`),
  `Fin.prod_univ_succ`/`Fin.sum_univ_succ` (ready-made splits),
  `vector_product_sum_family`, `Finset.sum_product` (product -> nested;
  use `←` to collapse), `div_le_div_iff₀`, `Real.exp_le_exp`.
- `git commit --only -- <file>` commits the WHOLE file; plan granularity.

## Deliverables

1. `sage/check_cert_lo.sage` — numeric pre-check of the lower-side bound
   (tilted complement tails at the sector windows; assert the required
   7.83e-10 margin is achievable; verdict record like check_cert_hi).
2. `formal/TiltedLocal.lean` — the kernel lower bound lemmas
   (suggested core: `windowSandwich`-lower + complement split +
   `sum_imp_exp_bound(_neg)` applications in the tilted measure +
   `dual_series_deviation`/`shiftedMass` for the local factor),
   each in small verified steps, 0/0 logs.
3. Notes: the handoff summary (what is closed, what remains for certLo's
   numeric closure) in the WORK_STATE entry.

Coordination: report milestone state to the owner; the main lane composes
your lemmas into `certLo`/`certHi` closure afterwards.
