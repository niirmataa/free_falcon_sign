# B4/3a — AttemptPointwise: the one-attempt mass comparison (work state)

Window B4/3a of the B4 pair (`notes/PROMPT_B4_ATTEMPT_POINTWISE.md`). Workspace
`proofs/ft1536/development/T12_1/run2/`. Own files only:
`formal/AttemptPointwise.lean` + this note. Recorded 2026-10-02.

## Status

**DONE — `formal/AttemptPointwise.lean` builds 0/0** (empty log, guarded
serial compile `tools/original/run_lean_guarded.sh`, exit 0). Axiom audit:
46/46 audited declarations (all 30 theorems + all 16 defs) depend
only on `[propext, Classical.choice, Quot.sound]`** (`.build/audit/
AttemptPointwiseAudit.lean` + `.log`, scratch under ignored `.build/`). No
unfinished-proof markers (the only `error`-strings are docstring words
"additive-error", "H3 error contract"). All statements on the pinned MTISIS
types (`FT1536.Law`, `FT1536.Divergence`, `FT1536.PublicSimulation.*`,
`FT1536.MathSign.*`, `FT1536.SignLayerSupport.*`); nothing assumed — the two
source-side interfaces stay named premises.

Bottom line: `layer2_e2_actual` — from `SignLayerSupport.ReplyShape` +
`AttemptShape` + `AttemptWeights` alone,
`Divergence.AC j (signBody A c) ∧ Divergence.second j (signBody A c) <
1 + 2^-32`. The previously CONDITIONAL corollary `e2 < 2^-32` is now ACTUAL
relative to those named boundaries.

## 1. The exact `jatt` — and the honest boundary

`attemptOf w hw : Law (Option BoxPair)` (mirror of the pinned
`PublicSimulation.trial` over an arbitrary machine-realized weight system
`w`): draw `z` from the `w`-weighted fiber (`Law.weighted w`, normalizer
`W = ∑ z, w z`), accept iff `Q (decode z) < B`; empty-fiber abort is
`Law.pure none`. Mass formulas proved for generic `w` (`attemptOf_some`,
`attemptOf_none` with `tailMass w` = the miss numerator). The pinned honest
attempt law is exactly this shape: `trial A c = attemptOf (fiberWeight A c)`
is **`rfl`** (`trial_eq_attemptOf`) — no extra model is introduced.

**NAMED BOUNDARY `AttemptShape jatt w hw`** (consumed, never assumed):
`∀ o, jatt.mass o = (attemptOf w hw).mass o` — identification of the real
`to_sign` one-attempt law with the `attemptOf` shape over its realized
weights. This is source binding (`S.code` / `do_sign` kernel, B1/source3,
same boundary as `SignLayerSupport.ReplyShape`).

**NAMED BOUNDARY `AttemptWeights A c w`** (consumed, never assumed): `w`
decomposes into the four recorded transport stages with EXACTLY the
kernelized margins:

| Stage | Sandwich (per point, all `z : BoxPair`) | Ratio | Kernel budget (consumed) |
|---|---|---|---|
| `tower` | `towerLo * fiberWeight ≤ target ≤ towerHi * fiberWeight`, `towerLo = (1-rowBudget)^2`, `towerHi = (1+rowBudget)^2` | `towerMargin = ((1+2^-46)/(1-2^-46))^2` (`tower_ratio`) | `Run2.T5ScalarMass.rowBudget`; analytic sources `TriangularGaussian.triangular_mass_bounds`, `ConvStruct.a2Tower_mass_bounds`, `ShiftedGaussian` |
| `machine` | `t5lo * target ≤ mach ≤ t5hi * target` | `machineMargin = t5hi/t5lo` | `CenteringClosure.t5lo`/`t5hi` (H3 error contract, kernel `t5_leaf_floor_gt`) |
| `wrapS` | `(1-tauB) * mach ≤ wrapS ≤ (1+tauB) * mach` | `(1+tauB)/(1-tauB)` | `CenteringClosure.tauB = 2^-40` |
| `box` | `1 * wrapS ≤ w ≤ (1/(1-boxB)) * wrapS` | `1/(1-boxB)` | `CenteringClosure.boxB = 1e-1000` |

What the boundary honestly contains: the TRANSPORT of each sandwich onto the
sampler's realized weights (the `do_sign` kernel), in particular the per-point
tower/fiber-tilt sandwich over the WHOLE candidate space including the tail
region (see Part 3). The kernel mass sandwiches listed above are the analytic
inputs that will feed stage 1; their per-point transport is B1/source3 work.

**Attempt-shape caveat (recorded):** `AttemptShape` pins the attempt as
UNCONDITIONED sample-then-check (the full target `w`, miss = out-of-box). If
the real `to_sign` attempt were internally conditioned on acceptance
(draw-until-short within one attempt), the some-side comparison would pick up
an extra miss-mass factor `1 / (1 - rejB)` — exactly where `rejB` would then
live. That shape fact must arrive from the `do_sign` kernel; never assumed.

## 2. The some-side comparison over the `emit` image

`attemptOf_le_of_sandwich` — THE normalizer absorption: two-sided margins
`0 < lo ≤ hi` give the normalized comparison `attemptOf w ≤ (hi/lo) *
attemptOf (fiberWeight)` pointwise, **with the normalizer ratio absorbed**
(both directions: `lo * G ≤ W ≤ hi * G`, hence `w z / W ≤ (hi/lo) * g z / G`).
So the "plus the normalizer ratio (`fiberMass`)" item of the B4/2 missing-pieces
table needs NO separate premise — it falls out of the sandwich (`sandwich_sum`).

- `attemptPointwise_of_sandwich` → `SignLayerSupport.AttemptPointwise jT A c
  (hi/lo)` (the exact structure consumed by `layer2_of_obligations`);
- `some_le_on_emit_image` — on exactly the `emit` image (in-box `z` with
  `signed16` tails, `emit_eq_some_iff`): the comparison at
  `k = attemptFactor`, plus STRICTLY POSITIVE honest mass on both sides
  (`trial_some_pos_iff`, `emitted_reply_supported`) — so the bound is
  meaningful exactly where reply mass lives;
- `reply_some_le` — reply-level `some x` within `k^16` (proved
  `cap`/`map` propagation consumed, `signBodyOf_le_of_attempt_le`).

## 3. The none-side comparison — the four `none` cases

Each case discharged separately (`AttemptPointwise.none_le` carries (i)+(ii)
at the attempt level; (iii)+(iv) are the two terms of
`signBodyOf_mass_none`):

1. **Empty fiber** (`none_case_empty_fiber`): the sandwich forces `W = 0 ↔
   G = 0` (support match is FREE — `lo * g z ≤ w z ≤ hi * g z` pins the
   support of `w` to the fiber), so both laws are `Law.pure none` and the miss
   mass is `1` on both sides.
2. **Norm reject** (`none_case_norm_reject`): with a nonempty fiber the
   attempt miss is exactly the tail weight comparison
   `tailMass w / W ≤ attemptFactor * fiberTailMass / fiberMass`. It rides the
   SAME two-sided sandwich as the some-side but is GENUINELY INDEPENDENT of it:
   a some-side-only sandwich does not control the miss point (both laws are
   probability laws and `none = 1 - ∑ some` gives the wrong direction), so the
   tail-region comparison is an integral, non-optional part of the named
   premise `AttemptWeights`.
3. **Cap exhaustion** (`none_case_cap_exhaustion`): `jT.mass none^16 ≤
   k^16 * (trial A c).mass none^16` (consumes `pow_mono_base`, `mul_pow`).
4. **Encode-failure tag** (`none_case_encode_flag`, `¬ signed16 z.2`):
   `geo jT 16 * imageMass jT none ≤ k^16 * (geo * imageMass)` — `k^15` from
   the retry factor (`geo_le_of_pointwise`) and `k` from the tagged candidates
   (`imageMass_le_of_pointwise`).

Assembled: `reply_none_le` — `(signBodyOf jT).mass none ≤ k^16 * (signBody A
c).mass none` (the two terms matched AGAINST the two honest terms, no factor-2
loss).

**Where `rejB` lives:** `CenteringClosure.rejB = 2^-24` is the absolute
miss-mass budget of the `delta` bridge (`bridgeUb`) and of the
`second_cond_le` fallback's positive-mass hypothesis — **deliberately OUTSIDE
the multiplicative factor** (as recorded in `notes/B4_LAYER2_WORK_STATE.md`).
It is not needed anywhere in `AttemptPointwise`: the miss comparison here is
multiplicative. Had only an ABSOLUTE miss budget been available (e.g. under
additive perturbations, or under a conditioned attempt shape), the
`AttemptPointwise` shape would NOT close and the fallback would be the
conservative `SecondMoment.second_cond_le` route with
`m ≥ 1 - (delta + rejB + Adv_PRG)`-shaped budgets.

## 4. Numeric kernel checks of the composed `attemptFactor`

Exact ℚ literals via ℝ coercions, `norm_num` in the style of
`CenteringClosure` (nothing re-proved; all budgets CONSUMED):

- `tower_ratio : towerHi / towerLo = towerMargin` (was implicitly the B4/2
  claim; now kernel-checked at the margin level);
- `chain_ratio : chainHi / chainLo = attemptFactor` — the product of the four
  stage margins is EXACTLY the candidate `SignLayerSupport.attemptFactor`;
- `chain_pos : 0 < chainLo`, `chain_le : chainLo ≤ chainHi`;
- `chain_ratio_lt : chainHi / chainLo < 1 + 2^-38` (consumed
  `attemptFactor_lt`);
- `chain_e2_lt : e2 (chainHi / chainLo) < 2^-32` (consumed
  `e2_attemptFactor_lt`).

With `attemptPointwise_of_attemptWeights` (k = `attemptFactor` delivered from
the named boundaries) the chain closes:
`layer2_of_attemptWeights` gives `second ≤ 1 + e2 attemptFactor` and
`layer2_e2_actual` upgrades to `second < 1 + 2^-32` — **ACTUAL**, no longer
conditional.

## 5. Honest boundaries (unchanged + this window's)

- **Additive-error caveat (kept OUT of `e`)**: `AttemptWeights` is purely
  multiplicative; an additive perturbation budget needs a point-mass floor
  `μ ≤ (trial A c).mass (some z)` on the affected `z` (UNPROVEN, plausibly
  tiny — never assume). A floor would be needed in exactly two places:
  (a) additive error on the realized weights `w`; (b) byte-bridge decode
  artifacts landing outside the `emit` image (there
  `chi2_top_of_out_of_support` forces `chi2 = ⊤` and only `second_cond_le`
  survives). Such terms stay in the outer bound (Section 1 of the scope).
- `SignLayerSupport.ReplyShape` (reply law = `signBodyOf jatt`) unchanged;
  `S.code` binding = B1/source3, unchanged.
- O-NONE (box point) and the byte-codec bridge remain open (B4/2 caveats);
  `some_le_on_emit_image` consumes `emitted_reply_supported` but does not
  close O-NONE.
- The attempt-shape caveat of Part 1 (conditioned vs sample-then-check).

## 6. Compile receipt

- Source: `formal/AttemptPointwise.lean`; module `AttemptPointwise`; command
  `bash tools/original/run_lean_guarded.sh formal/AttemptPointwise.lean
  .build/check_lib/AttemptPointwise.olean 900 3600` — exit 0.
- Log `.build/check_lib/AttemptPointwise.log`: **empty** = 0 errors / 0
  warnings (no linter warnings; `open` includes `FT1536.SignLayerSupport`, so
  no auto-implicit placeholders anywhere).
- Axiom audit `.build/audit/AttemptPointwiseAudit.lean` + `.log`: **46/46
  declarations (all 30 theorems + all 16 defs), axioms `[propext,
  Classical.choice, Quot.sound]` only**.
- Marker check: no `sorry`/`admit`/`native_decide`/placeholders.
- Dependencies (REUSE, unmodified): `SignLayerSupport` (`AttemptPointwise`
  structure, `layer2_of_obligations`, `attemptFactor`+numeric status,
  `signBodyOf`/`geo`/`imageMass`, `pow_mono_base`/`pow_mono_exp`,
  `trial_some_pos_iff`, `fiberWeight_pos_iff`/`fiberWeight_eq_zero_iff`,
  `emitted_reply_supported`, `signBodyOf_le_of_attempt_le`), `CenteringClosure`
  (`t5lo`/`t5hi`, `tauB`, `boxB`), `Run2.T5ScalarMass` (`rowBudget`),
  `RejectionBound` (`trial_none_mass`, `fiberTailMass`),
  `Run2.FiberBinding` (`map_mass`), pinned `FT1536.*` model types.

## 7. Lessons (toolchain, for the next batch)

- `dite_eq_left (h : p) : dite p f g = f h` — the POSITIVE branch; the
  negative branch is `dite_eq_right (hn : ¬p) : dite p f g = g hn`. Passing a
  negative proof to `dite_eq_left` silently re-parses the condition as `¬q`
  and misses the pattern.
- `Finset.mul_sum (s) (f) (b) : b * ∑ x ∈ s, f x = ∑ x ∈ s, b * f x` (scalar
  on the LEFT); `Finset.sum_div` matches `(∑ i ∈ s, f i) / a` only — if the
  RHS is hidden behind an opaque def (`tailMass`), `show` the unfolded sum
  form first.
- `have h := sum_le_sum (fun z _ => ...)` without an ascription cannot infer
  `s`/`g`; ascribe `have h : (∑ z, f z) ≤ ∑ z, g z := ...`.
- `field_simp [ne_of_gt hx, ne_of_gt hy]` alone closes the cross-multiplication
  step `hi * x / (lo * G) = (hi / lo) * (x / G)` in this build — a trailing
  `ring` errors with "No goals to be solved".
- A `by split_ifs <;> norm_num` argument to `mul_le_mul_of_nonneg_right` can
  hit `maxRecDepth` during elaboration (the same inline proof is fine under
  `mul_nonneg`); extract the `0 ≤ ite` fact into its own `have`.
- Watch numeral elaboration: `le_refl 1` gives `(1:ℕ) ≤ 1`; use `zero_le_one`
  for ℝ.
- ALWAYS `open ... FT1536.SignLayerSupport` (or fully qualify): with
  `autoImplicit` on, a bare `attemptFactor`/`towerMargin`/`signBodyOf` becomes
  an auto-bound variable and only fails much later (`norm_num` "not a
  proposition", `attemptFactor_one_le` type mismatch).
