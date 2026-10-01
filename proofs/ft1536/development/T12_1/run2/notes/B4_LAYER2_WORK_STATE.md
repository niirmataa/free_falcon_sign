# B4/2 — Layer-2 support map for `emit`/`cap` and the emit/cap (delta -> e) analysis

Window B4/2 of the B4 composition plan (`notes/S3_E_PROVENANCE.md`, "next
kernel piece" 3 = Layer 2). Workspace `proofs/ft1536/development/T12_1/run2/`.
Own files only: `formal/SignLayerSupport.lean` + this note. Recorded
2026-10-01.

## Status

**DONE — `formal/SignLayerSupport.lean` builds 0/0** (empty log, guarded
serial compile `tools/original/run_lean_guarded.sh`, exit 0). Axiom audit:
47/47 audited declarations (all 39 theorems + all 8 defs) depend only on
`[propext, Classical.choice, Quot.sound]`. No unfinished-proof markers. All
statements on the pinned MTISIS types (`FT1536.Law`, `FT1536.Divergence`,
`FT1536.PublicSimulation.signBody / trial / emit / fiberWeight`,
`FT1536.MathSign.cap / emit`); nothing assumed — the two missing analytic
inputs stay named premises (`AttemptPointwise`, `ReplyShape`).

## 1. Support map (exact)

Body shape: `signBodyOf jT = (MathSign.cap jT 16).map (MathSign.emit emit)`
over an arbitrary attempt law `jT : Law (Option BoxPair)`; the pinned honest
body is `signBodyOf (trial A c)` (`signBody_eq_signBodyOf`, by `rfl`).
Exact formulas (`geo jT 16 = ∑_{i<16} (jT.mass none)^i`, `imageMass jT r` =
the `emit`-image numerator):

- `signBodyOf_mass_some`: `(signBodyOf jT).mass (some x) = geo jT 16 * imageMass jT (some x)`;
- `signBodyOf_mass_none`: `(signBodyOf jT).mass none = (jT.mass none)^16 + geo jT 16 * imageMass jT none`
  (16-fold exhaustion **plus** the `emit` encode-failure tag `¬ signed16 z.2`).

Which points carry mass (`signBody_some_pos_iff`, `signBody_some_pos_iff_signed16`,
`signBody_none_pos_iff`, `trial_some_pos_iff`, `trial_none_pos_iff`):

- `some v` > 0  <=>  `∃ z1, A (z1,v) = c ∧ Q (decode (z1,v)) < B ∧ signed16 v`
  (the `emit` image of in-box fiber candidates; `emit z = some v <=>
  signed16 z.2 ∧ z.2 = v`, `emit_eq_some_iff`);
- `none` > 0  <=>  `0 < (trial A c).mass none` (empty-fiber abort or an
  out-of-box fiber point, `trial_none_pos_iff`) **or** an in-box fiber
  candidate with `¬ signed16 z.2` (encode failure);
- one attempt: `(trial A c).mass (some z) > 0 <=> A z = c ∧ Q (decode z) < B`
  (fiber weights `gaussianWeight > 0` everywhere on the fiber);
- the retry combinator never invents mass: `cap 16` keeps the support of the
  attempt law, amplified by the positive factor `geo 16 > 0` (`geo16_pos`).

## 2. AC verdict — THE wrap-error question, answered

**The wrap/centering `delta` mass lands INSIDE the support of `signBody` — on
the `some z` image of `emit` over in-box `z` — so the POINTWISE route
(`SecondMoment.second_le_of_pointwise`) applies; the conservative
`second_cond_le` route is NOT needed for this channel.**

Reasoning (both halves kernel-side):

1. `delta` = "probability that a POSITIVE Sign reply is rejected by
   mathematical `Verify`" (CenteringClosure docstring). Rejection is a
   VERIFY-SIDE VERDICT on the emitted reply value — the emitted value is
   `z.2` of an accepted candidate `z` (norm gate `Q (decode z) < B` passed,
   `falcon_is_short` both sides), unchanged by the wrap.
2. Every such reply is in the support: `emitted_reply_supported` /
   `wrap_channel_in_support` — `0 < (signBody (syndrome h) (syndrome h z)).mass
   (some z.2)` for every accepted `z` with `signed16 z.2`, with NO Verify
   hypothesis in the statement. The pinned honest law itself carries mass on
   Verify-rejected replies: `Run2.BadVerify.emitted_bad_mass` (and
   `freshHonest_badVerify_positive`) exhibit exactly such points — the model
   applies no correctness filter at emission (MathSign docstring: "no hidden
   correctness filter").

Honest flip side (recorded, kernel): mass OUTSIDE the `emit` image (e.g. a
byte-codec decode artifact landing on a tail `v` that is not `z.2` of any
in-box fiber candidate, or failing `signed16`) breaks AC and forces
`chi2 = ⊤` — `chi2_top_of_out_of_support` (via
`Divergence.support_mismatch`). Then only `second_cond_le` (condition on the
no-leak event, `1/m^2` factor) would survive. The byte encoding is an
explicit open bridge of the model (`PublicSimulation` docstring), so this
caveat stands until the codec bridge is bound.

AC feasibility in reusable form: `ac_of_reply_support` — `Divergence.AC j
(signBody A c)` follows from (i) `j.mass none ≠ 0 -> (signBody A c).mass none
≠ 0` and (ii) every `some v` with `j.mass (some v) ≠ 0` inside the `emit`
image. MISS-POINT CAVEAT (kernel-exact): if the real sampler can abort while
the honest body has `none` mass 0 (nonempty fiber, entirely in-box, with all
tails `signed16`), AC FAILS at `none`; `signBody_none_pos_iff` is the exact
condition. For real keys the fiber carries out-of-box points (its Gaussian
weight is strictly positive at fiber points beyond the `Q < B` region), but
this is NOT proved here — exact remaining type: `∀ A c (reachable), ∃ z,
A z = c ∧ ¬ Q (decode z) < B` (O-NONE below).

## 3. Mass comparison pieces (the delta -> e reduction)

Proved propagation (kernel): per-attempt pointwise factor `k` becomes `k^16`
at the reply layer:

- `map_le_of_pointwise` — pointwise bounds survive `Law.map`;
- `cap_le_of_pointwise` — `cap n` amplifies `k` to `k^n` (miss powers `k^(n-1)`
  x retained attempt `k`), miss point included;
- `signBodyOf_le_of_attempt_le` — composed: `signBodyOf jT ≤ k^16 * signBodyOf pT`;
- `layer2_of_obligations` — THE Layer-2 reduction: from the two named
  obligations (plus the side condition `1 ≤ k`),
  `Divergence.AC j (signBody A c) ∧ Divergence.second j (signBody
  A c) ≤ 1 + e2 k` with `e2 k = (k^16)^2 - 1 = k^32 - 1`.

### Named analytic obligations (exact types, never assumed)

- **`ReplyShape j jT`** (`def` in the module): `∀ o, j.mass o = (signBodyOf
  jT).mass o` — the real reply law IS the pinned body over its own attempt
  law. Source-bound: `SIGN_MAX_ATTEMPTS = 16` (source `#error`, pinned in
  `notes/S3_E_PROVENANCE.md`), emission `Extra/c/falcon-sign.c:3412-3418`,
  norm gate `falcon_is_short` both sides
  (`notes/VERIFY_BIND_SIGN_SIDE_NOTES.md`). `S.code`-side binding is other
  lanes (B1/source3 per the B4/2 task boundary).
- **`AttemptPointwise jT A c k`** (structure in the module): `∀ z, jT.mass
  (some z) ≤ k * (trial A c).mass (some z)` **and** `jT.mass none ≤ k * (trial
  A c).mass none`. THE remaining analytic input of Layer 2. Decomposition into
  the available analytic inputs and what is missing:

| Ingredient | Available kernel input | Provides | Missing piece |
|---|---|---|---|
| discrete-Gaussian / fiber-tilt comparison (the heavy path) | `TriangularGaussian.triangular_mass_bounds` (sandwich `(1±2r/(1-r))^n`, `rowRatio = 2^-48`, `rowBudget = 2^-46`), `ConvStruct.a2Tower_mass_bounds` (A2 tower, n=2), `Run2.T5ScalarMass.row_exponential_bound`, `ShiftedGaussian`, `A2Theta.powerWeight` | per-point mass sandwich `towerMargin = ((1+2^-46)/(1-2^-46))^2 < 1 + 2^-43` (`towerMargin_lt`) | sampler target law <-> `gaussianWeight` on the fiber, **plus the normalizer ratio** (`fiberMass A c`) and the miss comparison — needs `do_sign` kernel (B1/source3) |
| machine rounding of weights (H3 error contract) | `CenteringClosure.t5lo`/`t5hi`, kernel `t5_leaf_floor_gt` | per-point rounding sandwich `machineMargin = t5hi/t5lo < 1 + 2^-42` (`machineMargin_lt`) | transport of the sandwich onto the sampler's realized weights (same missing binding as above) |
| wrap/centering budgets | `CenteringClosure.tauB = 2^-40`, `boxB = 1e-1000` (kernel) | factor `(1+tauB)/(1-tauB) * 1/(1-boxB)` in `attemptFactor` | `hbridge`-side all-key transport stays its named premise there (consumed, not rebuilt) |
| rejection budget | `CenteringClosure.rejB = 2^-24` (kernel) | miss-mass budget for the `delta` bridge (`bridgeUb`) and the `second_cond_le` fallback's positive-mass hypothesis | not a per-attempt factor (deliberately outside `attemptFactor`) |
| delta itself | `all_keys_bridge_closure`: `1.265e-24 < delta < 1.27e-24` from `hraw`/`hbridge` (consumed) | — | per the verdict of Part 2, the wrap mass rides the candidate-level comparison (reply value unchanged); **no separate pointwise factor for the wrap channel** |

Candidate composite (kernel, upper target only — NOT proved to bound the real
sampler): `attemptFactor = machineMargin * towerMargin * (1+tauB)/(1-tauB) *
1/(1-boxB) < 1 + 2^-38` (`attemptFactor_lt`); were `AttemptPointwise _ _ _
attemptFactor` delivered, `e2 < 2^-32` (`e2_attemptFactor_lt`, conditional
corollary, kernel-checked via `pow_succ_le_real`).

### Honest boundary of the multiplicative shape

`AttemptPointwise` is MULTIPLICATIVE. Additive error terms do not fit it:
any future additive budget (e.g. `Adv_PRG` for the D2 route-(b) PRNG, or a
byte-codec decode-artifact budget) needs either a point-mass floor of the
honest attempt law at the perturbed points (type: `μ ≤ (trial A c).mass
(some z)` on the affected `z` — currently UNPROVEN and plausibly tiny, so do
not assume it) or the conservative `SecondMoment.second_cond_le` route with
`m ≥ 1 - (delta + rejB + Adv_PRG)`-shape. Record, do not paper over.

## 4. What remains of the delta -> e composition

1. Layer 1 (challenge marginal vs `Law.uniform`, `e1 = 0` under the ROM
   identification) — B3/X `HashTo`/`UniformChallenge` window; D2-route
   `Adv_PRG` accounting (other lane).
2. The joint composition and the `LocalJointCertificate` constructor from
   the two layer bounds — window B4/1 (`formal/JointDecomp.lean`,
   `SecondMoment.second_joint_le`); my `layer2_of_obligations` is exactly its
   per-challenge input.
3. The two named analytic obligations above (sampler binding + its
   multiplicative reduction to the tower/machine/wrap budgets) — the heavy
   remaining core, partially other lanes (B1/source3).
4. O-NONE (out-of-box fiber point per reachable challenge) and the byte-codec
   bridge (for the AC caveats of Part 2).

## 5. Compile receipt

- Source: `formal/SignLayerSupport.lean`; module `SignLayerSupport`; command
  `bash tools/original/run_lean_guarded.sh formal/SignLayerSupport.lean
  .build/check_lib/SignLayerSupport.olean 900 3600` — exit 0.
- Log `.build/check_lib/SignLayerSupport.log`: **empty** = 0 errors / 0
  warnings (no `error(` lines, no linter warnings).
- Axiom audit `.build/audit/SignLayerSupportAudit.lean` + `.log` (scratch
  under ignored `.build/`, nothing else touched): **47/47 audited
  declarations (all 39 theorems + all 8 defs of the module),
  axioms `[propext, Classical.choice, Quot.sound]` only**.
- Marker check: no `sorry`/`admit`/`native_decide`/placeholders.
- Dependencies (REUSE, unmodified): `SecondMoment`, `Run2.FiberBinding`
  (`map_mass`, `trial_some`, `law_ext`), `Run2.T5ScalarMass` (`rowBudget`),
  `RejectionBound` (`trial_of_pos/empty`, `trial_none_mass`, `fiberMass`,
  `fiberTailMass`), `CenteringClosure` (`t5lo`/`t5hi`, `tauB`, `rejB`,
  `boxB`), `Run2.BadVerify` (cited verdict exhibit).

## 6. Lessons (toolchain, for the next batch)

- This Mathlib build: `pow_le_pow_left'`, `pow_le_pow_right'`, `one_le_mul`
  need `MulLeftMono ℝ`, which does NOT resolve in this import closure — use
  `mul_le_mul` / `mul_le_mul_of_nonneg_left` (resolve fine) or local helpers
  (`pow_mono_base`, `pow_mono_exp`). `pow_pow` is gone; use
  `pow_mul : a^(m*n) = (a^m)^n`.
- Deprecated: `if_pos`/`if_neg` (use `split_ifs` or `simp [h]` on an
  equation `have`), `push_neg` (use `push Not` or `by_contra` + manual
  `le_antisymm`). Deprecated calls raise warnings -> breaks the 0/0 rule.
- `simp_rw [MathSign.emit]` inside ite CONDITIONS corrupts the `Decidable`
  instance typing ("not type-correct under implicit transparency") and then
  keyed matching fails — do `by_cases` per term + `simp [MathSign.emit, h]`.
- Precedence trap: `if c then t else 0 ↔ _` parses `0 ↔ _` — parenthesize
  ites before `↔`.
- `Finset.mul_sum (s) (f) (a)` has argument order (s, f, a); `Finset.sum_congr`
  needs BOTH sides to be sums (fold with `mul_sum` in a separate `have`).
- `Run2.FiberBinding.trial_some` is specialized to `Relation.Rq` (not
  generic `C`) — specialize the layer statements to `Relation.Rq` (this also
  matches the pinned `signBody (syndrome h) c` comparison exactly).
