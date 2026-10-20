import SignLayerSupport

/-! # AttemptPointwise — the one-attempt mass comparison (the analytic core)

Rung B4/3a (window `notes/PROMPT_B4_ATTEMPT_POINTWISE.md`): the one-attempt
mass comparison consumed by `SignLayerSupport.layer2_of_obligations`. Scope of
THIS module (all kernel-checked, no new model, no new numeric input — every
budget is CONSUMED from `SignLayerSupport`/`CenteringClosure`):

1. **The exact `jatt`** — the one-attempt law shape of the real `to_sign`
   sampler: `attemptOf w` draws a candidate `z` from the `w`-weighted fiber and
   accepts it iff `Q (decode z) < B`, otherwise it is the attempt-level miss —
   a literal mirror of the pinned `PublicSimulation.trial` over an arbitrary
   machine-realized weight system `w` (`trial A c = attemptOf (fiberWeight A c)`
   is `rfl`, `trial_eq_attemptOf`). The identification of the real `S.code`
   attempt law with `attemptOf w` is the NAMED boundary `AttemptShape` (source
   binding: the `do_sign` kernel, B1/source3 + `ReplyShape` territory) and is
   NEVER assumed here. The decomposition of `w` into the four recorded
   transport stages (A2/tower fiber tilt, machine rounding of weights,
   wrap/centering, box truncation) is the NAMED boundary `AttemptWeights`;
   everything below is proved DOWN FROM these two interfaces.
2. **The some-side comparison over the `emit` image** — the two-sided weight
   sandwich gives the pointwise factor `k = chainHi / chainLo` on every
   candidate `some z` with the NORMALIZER ABSORBED (no separate `fiberMass`
   premise is needed — `attemptOf_le_of_sandwich`); on the `emit` image
   (in-box `z` with `signed16` tails) the honest mass is strictly positive
   (`some_le_on_emit_image`), and the reply-level `some` bound rides the
   proved `cap`/`map` propagation at factor `k^16` (`reply_some_le`).
3. **The none-side comparison — the four `none` cases** of
   `SignLayerSupport`, each discharged separately: empty fiber
   (`none_case_empty_fiber`), norm reject (`none_case_norm_reject` — the miss
   comparison is a genuine TAIL weight comparison, independent of the
   some-side), cap exhaustion (`none_case_cap_exhaustion`) and the `emit`
   encode-failure tag `¬ signed16` (`none_case_encode_flag`), assembled in
   `reply_none_le`. `CenteringClosure.rejB = 2^-24` stays OUTSIDE the
   multiplicative factor, as recorded in `notes/B4_LAYER2_WORK_STATE.md`: it
   is the absolute miss-mass budget of the `delta` bridge (`bridgeUb`) and of
   the `second_cond_le` fallback, not a per-attempt factor.
4. **The numeric kernel checks of the composed `attemptFactor`** — the chain
   ratio `chainHi / chainLo = attemptFactor` (`chain_ratio`, exact ℚ literals
   in the style of `CenteringClosure`), consuming the kernelized budgets: the
   T5 machine sandwich `machineMargin < 1 + 2^-42`
   (`CenteringClosure.t5lo`/`t5hi`), the A2/tower sandwich
   `towerMargin < 1 + 2^-43` (`Run2.T5ScalarMass.rowBudget`), and the wrap
   budgets `tauB = 2^-40`, `boxB = 1e-1000`. With the consumed
   `SignLayerSupport.e2_attemptFactor_lt` the conditional corollary
   `e2 < 2^-32` upgrades from conditional to ACTUAL (`layer2_e2_actual`):
   from `ReplyShape` + `AttemptShape` + `AttemptWeights` alone,
   `Divergence.second j (signBody A c) < 1 + 2^-32`.

## Honest boundaries (recorded, not papered over)

- **The additive-error caveat** (kept OUT of `e`, per `notes/B4_SYNTHESIS.md`):
  any ADDITIVE perturbation budget (e.g. `Adv_PRG` of the D2 route-(b) PRNG,
  or a byte-codec decode-artifact budget) does NOT fit the multiplicative
  `AttemptPointwise` shape without a point-mass floor of the honest attempt law
  at the perturbed points (type `μ ≤ (trial A c).mass (some z)` on the
  affected `z` — UNPROVEN and plausibly tiny; never assume it). A floor would
  be needed in exactly two places: (a) an additive error on the realized
  weights `w` (the `AttemptWeights` premise is purely multiplicative);
  (b) mass landing outside the `emit` image through the byte bridge (there
  `SignLayerSupport.chi2_top_of_out_of_support` applies and only the
  conditioning route `SecondMoment.second_cond_le` survives). Such terms
  belong to the outer bound (Section 1 of the scope), not to `e`.
- **The attempt-shape boundary**: `AttemptShape` pins the one-attempt law as
  UNCONDITIONED sample-then-check (`attemptOf w` over the full target `w`).
  If the real `to_sign` attempt were internally conditioned on acceptance
  (draw-until-short within a single attempt), the some-side comparison would
  pick up the additional miss-mass factor `1 / (1 - rejB)` — exactly the kind
  of shape fact that must arrive from the `do_sign` kernel (B1/source3), and
  exactly where the miss-mass budget `rejB` would then live. Never assumed.
- `S.code` binding itself, `SignLayerSupport.ReplyShape`, the O-NONE box point
  and the byte-codec bridge remain open; unchanged by this module.

No unfinished-proof markers; standard axioms only.
-/

namespace FT1536.AttemptPointwise
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry FT1536.SignLayerSupport

/-! ## 0. The exact one-attempt law `jatt` (the `attemptOf` shape) -/

/-- The one-attempt law shape of the real `to_sign` sampler over a realized
weight system `w`: draw `z` from the `w`-weighted fiber (normalizing over all
candidates with `0 < ∑ z, w z`; an empty-fiber abort is `Law.pure none`) and
accept it iff the norm gate `Q (decode z) < B` passes. This is a literal
mirror of the pinned `PublicSimulation.trial` over an arbitrary weight system
(`trial_eq_attemptOf`); the identification of the real attempt law with
`attemptOf w` over the machine-realized `w` is the NAMED boundary
`AttemptShape` below. -/
noncomputable def attemptOf (w : BoxPair → ℝ) (hw : ∀ z, 0 ≤ w z) : Law (Option BoxPair) := by
  classical
  exact if h : 0 < ∑ z, w z then
    (Law.weighted w hw h).map (fun z => if Q (decode z) < B then some z else none)
  else Law.pure none

/-- The pinned honest attempt law is the `attemptOf` shape over the fiber
weights — definitional. -/
theorem trial_eq_attemptOf (A : BoxPair → Relation.Rq) (c : Relation.Rq) :
    attemptOf (fiberWeight A c) (fun z => fiberWeight_nonneg A c z) = trial A c := rfl

/-- Unnormalized miss (tail) mass of a weight system: the weight outside the
norm gate. `tailMass (fiberWeight A c)` is `RejectionBound.fiberTailMass`. -/
noncomputable def tailMass (u : BoxPair → ℝ) : ℝ :=
  ∑ z, u z * (if Q (decode z) < B then (0:ℝ) else 1)

theorem tailMass_fiber (A : BoxPair → Relation.Rq) (c : Relation.Rq) :
    tailMass (fiberWeight A c) = RejectionBound.fiberTailMass A c := rfl

theorem tailMass_nonneg (u : BoxPair → ℝ) (hu : ∀ z, 0 ≤ u z) : 0 ≤ tailMass u := by
  show 0 ≤ ∑ z, u z * (if Q (decode z) < B then (0:ℝ) else 1)
  exact sum_nonneg (fun z _ => mul_nonneg (hu z) (by split_ifs <;> norm_num))

/-- Exact mass of `attemptOf` at `some z` (mirror of
`Run2.FiberBinding.trial_some` for a generic weight system). -/
theorem attemptOf_some (w : BoxPair → ℝ) (hw : ∀ z, 0 ≤ w z)
    (hW : 0 < ∑ z, w z) (z : BoxPair) :
    (attemptOf w hw).mass (some z) =
      (if Q (decode z) < B then w z else 0) / (∑ y, w y) := by
  classical
  rw [attemptOf, dite_eq_left hW, Run2.FiberBinding.map_mass]
  have he (x : BoxPair) :
      (if (if Q (decode x) < B then some x else none) = some z then
        (Law.weighted w hw hW).mass x else 0) =
      if x = z then
        (if Q (decode z) < B then w z else 0) / (∑ y, w y) else 0 := by
    by_cases hx : x = z
    · subst x
      split_ifs <;> simp_all [Law.weighted]
    · split_ifs <;> simp_all
  simp_rw [he]
  simp

/-- Exact mass of `attemptOf` at `none` (mirror of
`RejectionBound.trial_none_mass`): the tail mass over the normalizer, or `1`
for the empty-fiber abort. -/
theorem attemptOf_none (w : BoxPair → ℝ) (hw : ∀ z, 0 ≤ w z) :
    (attemptOf w hw).mass none =
      if 0 < ∑ z, w z then tailMass w / (∑ y, w y) else 1 := by
  classical
  by_cases h : 0 < ∑ z, w z
  · have hif : (if 0 < ∑ z, w z then tailMass w / (∑ y, w y) else (1:ℝ))
        = tailMass w / (∑ y, w y) := by
      simp [h]
    rw [hif, attemptOf, dite_eq_left h]
    show ((Law.weighted w hw h).map
        (fun z => if Q (decode z) < B then some z else none)).mass none = _
    rw [Law.map]
    show (∑ x, (Law.weighted w hw h).mass x *
        (Law.pure (if Q (decode x) < B then some x else none)).mass none) = _
    show (∑ x, (w x / ∑ y, w y) *
        (Law.pure (if Q (decode x) < B then some x else none)).mass none) = _
    show (∑ x, (w x / ∑ y, w y) *
        (Law.pure (if Q (decode x) < B then some x else none)).mass none)
      = (∑ z, w z * (if Q (decode z) < B then (0:ℝ) else 1)) / ∑ y, w y
    rw [Finset.sum_div]
    apply Finset.sum_congr rfl
    intro z hz
    show (w z / ∑ y, w y) *
        (Law.pure (if Q (decode z) < B then some z else none)).mass none =
      w z * (if Q (decode z) < B then (0:ℝ) else 1) / ∑ y, w y
    by_cases hq : Q (decode z) < B <;> simp [Law.pure, hq]
  · have hif : (if 0 < ∑ z, w z then tailMass w / (∑ y, w y) else (1:ℝ)) = 1 := by
      simp [h]
    rw [hif, attemptOf, dite_eq_right h]
    simp [Law.pure]

/-- NAMED BOUNDARY `AttemptShape` — identification of the real `to_sign`
one-attempt law `jatt` with the pinned attempt shape `attemptOf w` over its own
machine-realized weight system `w`. Source binding (`S.code` / `do_sign`
kernel, B1/source3, the same boundary as `SignLayerSupport.ReplyShape`);
consumed as a premise and NEVER assumed in this module. -/
def AttemptShape (jatt : Law (Option BoxPair)) (w : BoxPair → ℝ)
    (hw : ∀ z, 0 ≤ w z) : Prop :=
  ∀ o : Option BoxPair, jatt.mass o = (attemptOf w hw).mass o

/-! ## 1. Two-sided weight sandwiches and the normalizer absorption -/

/-- Two-sided multiplicative sandwich of weight systems:
`lo * a z ≤ b z ≤ hi * a z` for every candidate `z`. -/
def Sandwich (lo hi : ℝ) (a b : BoxPair → ℝ) : Prop :=
  ∀ z : BoxPair, lo * a z ≤ b z ∧ b z ≤ hi * a z

/-- Sandwiches compose by multiplying their margins (nonnegative multiplier
stage). -/
theorem sandwich_comp {lo1 hi1 lo2 hi2 : ℝ} {a b c : BoxPair → ℝ}
    (hlo2 : 0 ≤ lo2) (hhi2 : 0 ≤ hi2)
    (hA : Sandwich lo1 hi1 a b) (hB : Sandwich lo2 hi2 b c) :
    Sandwich (lo1 * lo2) (hi1 * hi2) a c := by
  intro z
  obtain ⟨laz, uaz⟩ := hA z
  obtain ⟨lbz, ubz⟩ := hB z
  constructor
  · calc (lo1 * lo2) * a z = lo2 * (lo1 * a z) := by ring
      _ ≤ lo2 * b z := mul_le_mul_of_nonneg_left laz hlo2
      _ ≤ c z := lbz
  · calc c z ≤ hi2 * b z := ubz
      _ ≤ hi2 * (hi1 * a z) := mul_le_mul_of_nonneg_left uaz hhi2
      _ = (hi1 * hi2) * a z := by ring

/-- A sandwich transfers nonnegativity downwards. -/
theorem sandwich_nonneg {lo hi : ℝ} {a b : BoxPair → ℝ} (hlo : 0 ≤ lo)
    (hS : Sandwich lo hi a b) (ha : ∀ z, 0 ≤ a z) (z : BoxPair) : 0 ≤ b z :=
  le_trans (mul_nonneg hlo (ha z)) (hS z).1

/-- A sandwich lifts to the total masses. -/
theorem sandwich_sum {lo hi : ℝ} {a b : BoxPair → ℝ} (hS : Sandwich lo hi a b) :
    lo * ∑ z, a z ≤ ∑ z, b z ∧ ∑ z, b z ≤ hi * ∑ z, a z := by
  constructor
  · have h : (∑ z, lo * a z) ≤ ∑ z, b z := sum_le_sum (fun z _ => (hS z).1)
    rw [← Finset.mul_sum] at h
    exact h
  · have h : (∑ z, b z) ≤ ∑ z, hi * a z := sum_le_sum (fun z _ => (hS z).2)
    rw [← Finset.mul_sum] at h
    exact h

/-- THE normalizer absorption: with two-sided margins `lo ≤ hi` on the
weights, the NORMALIZED laws are within `hi / lo` pointwise — the normalizer
ratio needs no separate premise (it is absorbed by the sandwich). This is the
one-attempt mass comparison (`AttemptPointwise`) at the weight-system level;
the empty-fiber case is carried explicitly (both laws are `pure none`). -/
theorem attemptOf_le_of_sandwich (w g : BoxPair → ℝ) (hw : ∀ z, 0 ≤ w z)
    (hg : ∀ z, 0 ≤ g z) (lo hi : ℝ) (hlo : 0 < lo) (hle : lo ≤ hi)
    (hS : Sandwich lo hi g w) (o : Option BoxPair) :
    (attemptOf w hw).mass o ≤ (hi / lo) * (attemptOf g hg).mass o := by
  obtain ⟨hsum_lo, hsum_hi⟩ := sandwich_sum hS
  have hhi : 0 ≤ hi := le_trans (le_of_lt hlo) hle
  have hW_nonneg : 0 ≤ ∑ z, w z := sum_nonneg fun z _ => hw z
  have hG_nonneg : 0 ≤ ∑ z, g z := sum_nonneg fun z _ => hg z
  by_cases hG : ∑ z, g z = 0
  · -- empty fiber: both laws are `Law.pure none`
    have hW : ∑ z, w z = 0 := by
      apply le_antisymm _ hW_nonneg
      have := hsum_hi
      rwa [hG, mul_zero] at this
    have hnG : ¬ 0 < ∑ z, g z := by
      rw [hG]
      exact lt_irrefl 0
    have hnW : ¬ 0 < ∑ z, w z := by
      rw [hW]
      exact lt_irrefl 0
    rw [attemptOf, dite_eq_right hnW, attemptOf, dite_eq_right hnG]
    cases o with
    | none =>
      have hk : (1:ℝ) ≤ hi / lo := by
        have e : (1:ℝ) = lo / lo := (div_self (ne_of_gt hlo)).symm
        rw [e]
        exact div_le_div_of_nonneg_right hle (le_of_lt hlo)
      simpa [Law.pure] using hk
    | some z =>
      simp [Law.pure]
  · -- nonempty fiber: both normalizers are positive, the sandwich carries the
    -- pointwise comparison INCLUDING the miss point
    have hgz : 0 < ∑ z, g z := lt_of_le_of_ne hG_nonneg (Ne.symm hG)
    have hwz : 0 < ∑ z, w z := lt_of_lt_of_le (mul_pos hlo hgz) hsum_lo
    have hratio (x : ℝ) (hx : 0 ≤ x) :
        hi * x / (∑ z, w z) ≤ (hi / lo) * (x / ∑ z, g z) := by
      have h1 : hi * x / (∑ z, w z) ≤ hi * x / (lo * ∑ z, g z) :=
        div_le_div_of_nonneg_left (mul_nonneg hhi hx) (mul_pos hlo hgz) hsum_lo
      have h2 : hi * x / (lo * ∑ z, g z) = (hi / lo) * (x / ∑ z, g z) := by
        field_simp [ne_of_gt hlo, ne_of_gt hgz]
      rw [← h2]
      exact h1
    cases o with
    | some z =>
      rw [attemptOf_some w hw hwz z, attemptOf_some g hg hgz z]
      by_cases hq : Q (decode z) < B
      · have keyw : (if Q (decode z) < B then w z else 0) = w z := by
          simp [hq]
        have keyg : (if Q (decode z) < B then g z else 0) = g z := by
          simp [hq]
        rw [keyw, keyg]
        have h1 : w z / ∑ y, w y ≤ hi * g z / ∑ y, w y :=
          div_le_div_of_nonneg_right (hS z).2 (le_of_lt hwz)
        exact le_trans h1 (hratio (g z) (hg z))
      · simp [hq]
    | none =>
      rw [attemptOf_none w hw, attemptOf_none g hg]
      have hifw : (if 0 < ∑ z, w z then tailMass w / (∑ y, w y) else (1:ℝ))
          = tailMass w / (∑ y, w y) := by
        simp [hwz]
      have hifg : (if 0 < ∑ z, g z then tailMass g / (∑ y, g y) else (1:ℝ))
          = tailMass g / (∑ y, g y) := by
        simp [hgz]
      rw [hifw, hifg]
      have hn : ∀ z : BoxPair, 0 ≤ (if Q (decode z) < B then (0:ℝ) else 1) := by
        intro z
        by_cases hq : Q (decode z) < B <;> simp [hq]
      have hterm : ∀ z : BoxPair,
          w z * (if Q (decode z) < B then (0:ℝ) else 1)
            ≤ hi * (g z * (if Q (decode z) < B then (0:ℝ) else 1)) := by
        intro z
        have h1 : w z * (if Q (decode z) < B then (0:ℝ) else 1)
            ≤ (hi * g z) * (if Q (decode z) < B then (0:ℝ) else 1) :=
          mul_le_mul_of_nonneg_right (hS z).2 (hn z)
        have h2 : (hi * g z) * (if Q (decode z) < B then (0:ℝ) else 1)
            = hi * (g z * (if Q (decode z) < B then (0:ℝ) else 1)) := by
          ring
        rw [← h2]
        exact h1
      have hsum : (∑ z, w z * (if Q (decode z) < B then (0:ℝ) else 1))
          ≤ ∑ z, hi * (g z * (if Q (decode z) < B then (0:ℝ) else 1)) :=
        sum_le_sum (fun z _ => hterm z)
      have hfold : (∑ z, hi * (g z * (if Q (decode z) < B then (0:ℝ) else 1)))
          = hi * ∑ z, g z * (if Q (decode z) < B then (0:ℝ) else 1) :=
        (Finset.mul_sum univ
          (fun z : BoxPair => g z * (if Q (decode z) < B then (0:ℝ) else 1)) hi).symm
      have htail : tailMass w ≤ hi * tailMass g := by
        show (∑ z, w z * (if Q (decode z) < B then (0:ℝ) else 1))
            ≤ hi * ∑ z, g z * (if Q (decode z) < B then (0:ℝ) else 1)
        rw [← hfold]
        exact hsum
      have h1 : tailMass w / ∑ y, w y ≤ hi * tailMass g / ∑ y, w y :=
        div_le_div_of_nonneg_right htail (le_of_lt hwz)
      exact le_trans h1 (hratio (tailMass g) (tailMass_nonneg g hg))

/-- The per-attempt comparison of `SignLayerSupport.AttemptPointwise` from a
two-sided weight sandwich against `fiberWeight` (the `some`-side and the
miss-side both ride the same sandwich). -/
theorem attemptPointwise_of_sandwich {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    {hw : ∀ z, 0 ≤ w z} {lo hi : ℝ}
    (hshape : AttemptShape jT w hw) (hlo : 0 < lo) (hle : lo ≤ hi)
    (hS : Sandwich lo hi (fiberWeight A c) w) :
    SignLayerSupport.AttemptPointwise jT A c (hi / lo) where
  some_le z := by
    rw [hshape (some z), ← trial_eq_attemptOf]
    exact attemptOf_le_of_sandwich w (fiberWeight A c) hw
      (fun z => fiberWeight_nonneg A c z) lo hi hlo hle hS (some z)
  none_le := by
    rw [hshape none, ← trial_eq_attemptOf]
    exact attemptOf_le_of_sandwich w (fiberWeight A c) hw
      (fun z => fiberWeight_nonneg A c z) lo hi hlo hle hS none

/-- The per-attempt factor is monotone in `k`. -/
theorem attemptPointwise_mono {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {k k' : ℝ}
    (hkk' : k ≤ k') (h : SignLayerSupport.AttemptPointwise jT A c k) :
    SignLayerSupport.AttemptPointwise jT A c k' where
  some_le z := le_trans (h.some_le z)
    (mul_le_mul_of_nonneg_right hkk' ((trial A c).nonneg (some z)))
  none_le := le_trans h.none_le
    (mul_le_mul_of_nonneg_right hkk' ((trial A c).nonneg none))

/-! ## 2. The four recorded transport budgets and the composed `attemptFactor` -/

/-- Stage-1 (A2/tower + fiber-tilt) sandwich margins: the per-point mass
sandwich of `notes/B4_LAYER2_WORK_STATE.md`, ratio
`towerHi / towerLo = towerMargin = ((1 + 2^-46) / (1 - 2^-46))^2` over the
kernel budget `Run2.T5ScalarMass.rowBudget` (from
`TriangularGaussian.triangular_mass_bounds` / `ConvStruct.a2Tower_mass_bounds`
— CONSUMED, not re-proved). -/
noncomputable def towerLo : ℝ := (1 - Run2.T5ScalarMass.rowBudget) ^ 2

noncomputable def towerHi : ℝ := (1 + Run2.T5ScalarMass.rowBudget) ^ 2

theorem tower_ratio : towerHi / towerLo = towerMargin := by
  norm_num [towerHi, towerLo, towerMargin, Run2.T5ScalarMass.rowBudget]

/-- NAMED BOUNDARY `AttemptWeights` — the machine-realized weight system `w`
of one real `to_sign` attempt decomposes into the four recorded transport
stages with EXACTLY the kernelized margins:
1. `tower` — the sampler target law vs `gaussianWeight` on the fiber
   (A2/tower + fiber-tilt comparison; kernel inputs
   `TriangularGaussian.triangular_mass_bounds`,
   `ConvStruct.a2Tower_mass_bounds`, `ShiftedGaussian` — their transport onto
   the sampler target is the heavy analytic work of B1/source3);
2. `machine` — machine rounding of the weights (H3 error contract
   `CenteringClosure.t5lo`/`t5hi`, kernel `t5_leaf_floor_gt`; its transport
   onto the realized weights is the same missing binding);
3. `wrapS` — wrap/centering distortion at `CenteringClosure.tauB = 2^-40`
   (the `hbridge`-side all-key transport stays its named premise in
   `CenteringClosure`);
4. `box` — box truncation at `CenteringClosure.boxB = 1e-1000`.
Consumed as a premise and NEVER assumed in this module. -/
def AttemptWeights (A : BoxPair → Relation.Rq) (c : Relation.Rq) (w : BoxPair → ℝ) : Prop :=
  ∃ (target : BoxPair → ℝ) (mach : BoxPair → ℝ) (wrapS : BoxPair → ℝ),
    Sandwich towerLo towerHi (fiberWeight A c) target ∧
    Sandwich (CenteringClosure.t5lo : ℝ) (CenteringClosure.t5hi : ℝ) target mach ∧
    Sandwich (1 - (CenteringClosure.tauB : ℝ)) (1 + (CenteringClosure.tauB : ℝ)) mach wrapS ∧
    Sandwich 1 (1 / (1 - (CenteringClosure.boxB : ℝ))) wrapS w

theorem chain_tower_nonneg : 0 ≤ towerLo := by
  norm_num [towerLo, Run2.T5ScalarMass.rowBudget]

theorem chain_machine_lo_nonneg : 0 ≤ (CenteringClosure.t5lo : ℝ) := by
  norm_num [CenteringClosure.t5lo, CenteringClosure.t5minus,
    CenteringClosure.t5plus, CenteringClosure.u]

theorem chain_machine_hi_nonneg : 0 ≤ (CenteringClosure.t5hi : ℝ) := by
  norm_num [CenteringClosure.t5hi, CenteringClosure.t5minus,
    CenteringClosure.t5plus, CenteringClosure.u]

theorem chain_wrap_lo_nonneg : 0 ≤ 1 - (CenteringClosure.tauB : ℝ) := by
  norm_num [CenteringClosure.tauB]

theorem chain_wrap_hi_nonneg : 0 ≤ 1 + (CenteringClosure.tauB : ℝ) := by
  norm_num [CenteringClosure.tauB]

theorem chain_box_hi_nonneg : 0 ≤ 1 / (1 - (CenteringClosure.boxB : ℝ)) := by
  norm_num [CenteringClosure.boxB]

/-- The composed lower margin of the four stages. -/
noncomputable def chainLo : ℝ :=
  towerLo * (CenteringClosure.t5lo : ℝ) * (1 - (CenteringClosure.tauB : ℝ)) * 1

/-- The composed upper margin of the four stages. -/
noncomputable def chainHi : ℝ :=
  towerHi * (CenteringClosure.t5hi : ℝ) * (1 + (CenteringClosure.tauB : ℝ))
    * (1 / (1 - (CenteringClosure.boxB : ℝ)))

theorem chain_pos : 0 < chainLo := by
  norm_num [chainLo, towerLo, Run2.T5ScalarMass.rowBudget, CenteringClosure.t5lo,
    CenteringClosure.t5minus, CenteringClosure.t5plus, CenteringClosure.u,
    CenteringClosure.tauB]

theorem chain_le : chainLo ≤ chainHi := by
  norm_num [chainLo, chainHi, towerLo, towerHi, Run2.T5ScalarMass.rowBudget,
    CenteringClosure.t5lo, CenteringClosure.t5hi,
    CenteringClosure.t5minus, CenteringClosure.t5plus, CenteringClosure.u,
    CenteringClosure.tauB, CenteringClosure.boxB]

/-- NUMERIC KERNEL CHECK of the composed factor (exact ℚ literals in the style
of `CenteringClosure`): the product of the four recorded transport margins is
exactly the candidate `attemptFactor` of `SignLayerSupport`. -/
theorem chain_ratio : chainHi / chainLo = attemptFactor := by
  norm_num [chainLo, chainHi, towerLo, towerHi, attemptFactor, machineMargin,
    towerMargin, Run2.T5ScalarMass.rowBudget,
    CenteringClosure.t5lo, CenteringClosure.t5hi,
    CenteringClosure.t5minus, CenteringClosure.t5plus, CenteringClosure.u,
    CenteringClosure.tauB, CenteringClosure.boxB]

/-- Numeric status of the composed factor (consumed): `chainHi / chainLo <
1 + 2^-38` — `SignLayerSupport.attemptFactor_lt`, not re-proved. -/
theorem chain_ratio_lt : chainHi / chainLo < 1 + 1 / 274877906944 := by
  rw [chain_ratio]
  exact SignLayerSupport.attemptFactor_lt

/-- Numeric status of the Layer-2 factor at the composed margin (consumed):
`e2 (chainHi / chainLo) < 2^-32` — `SignLayerSupport.e2_attemptFactor_lt`,
not re-proved. -/
theorem chain_e2_lt : SignLayerSupport.e2 (chainHi / chainLo) < 1 / 4294967296 := by
  rw [chain_ratio]
  exact SignLayerSupport.e2_attemptFactor_lt

/-- The four stages compose to one two-sided sandwich with the composed
margins. -/
theorem attemptWeights_sandwich {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {w : BoxPair → ℝ} (cw : AttemptWeights A c w) :
    Sandwich chainLo chainHi (fiberWeight A c) w := by
  obtain ⟨target, mach, wrapS, ht, hm, hwr, hb⟩ := cw
  have h1 : Sandwich (towerLo * (CenteringClosure.t5lo : ℝ))
      (towerHi * (CenteringClosure.t5hi : ℝ)) (fiberWeight A c) mach :=
    sandwich_comp chain_machine_lo_nonneg chain_machine_hi_nonneg ht hm
  have h2 : Sandwich (towerLo * (CenteringClosure.t5lo : ℝ)
      * (1 - (CenteringClosure.tauB : ℝ)))
      (towerHi * (CenteringClosure.t5hi : ℝ) * (1 + (CenteringClosure.tauB : ℝ)))
      (fiberWeight A c) wrapS :=
    sandwich_comp chain_wrap_lo_nonneg chain_wrap_hi_nonneg h1 hwr
  have h3 : Sandwich (towerLo * (CenteringClosure.t5lo : ℝ)
      * (1 - (CenteringClosure.tauB : ℝ)) * 1)
      (towerHi * (CenteringClosure.t5hi : ℝ) * (1 + (CenteringClosure.tauB : ℝ))
        * (1 / (1 - (CenteringClosure.boxB : ℝ))))
      (fiberWeight A c) w :=
    sandwich_comp zero_le_one chain_box_hi_nonneg h2 hb
  exact h3

/-- The real attempt weights are nonnegative (derived from the chain — no
extra premise). -/
theorem attemptWeights_nonneg {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {w : BoxPair → ℝ} (cw : AttemptWeights A c w) (z : BoxPair) : 0 ≤ w z := by
  obtain ⟨target, mach, wrapS, ht, hm, hwr, hb⟩ := cw
  have htarget : ∀ z, 0 ≤ target z :=
    fun z => sandwich_nonneg chain_tower_nonneg ht
      (fun y => fiberWeight_nonneg A c y) z
  have h1 : ∀ z, 0 ≤ mach z :=
    fun z => sandwich_nonneg chain_machine_lo_nonneg hm htarget z
  have h2 : ∀ z, 0 ≤ wrapS z :=
    fun z => sandwich_nonneg chain_wrap_lo_nonneg hwr h1 z
  exact sandwich_nonneg zero_le_one hb h2 z

/-- THE core reduction: from the two named boundaries (`AttemptShape`,
`AttemptWeights`) the one-attempt law satisfies the exact structure consumed
by `SignLayerSupport.layer2_of_obligations`, at `k = attemptFactor`. -/
theorem attemptPointwise_of_attemptWeights {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    {hw : ∀ z, 0 ≤ w z}
    (hshape : AttemptShape jT w hw) (cw : AttemptWeights A c w) :
    SignLayerSupport.AttemptPointwise jT A c attemptFactor := by
  have hbase := attemptPointwise_of_sandwich hshape chain_pos chain_le
    (attemptWeights_sandwich cw)
  rw [chain_ratio] at hbase
  exact hbase

/-! ## 3. The some-side comparison over the `emit` image -/

/-- THE some-side comparison over the `emit` image: on exactly the candidates
that carry positive reply mass (in-box `z` with `signed16` tails,
`emit_eq_some_iff`), the one-attempt comparison holds at `k = attemptFactor`
and BOTH the attempt law and the pinned honest law carry strictly positive
mass (`SignLayerSupport.trial_some_pos_iff`,
`SignLayerSupport.emitted_reply_supported`). -/
theorem some_le_on_emit_image {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    {hw : ∀ z, 0 ≤ w z}
    (hshape : AttemptShape jT w hw) (cw : AttemptWeights A c w)
    (z : BoxPair) (hz : Q (decode z) < B) (hf : A z = c) (hs : signed16 z.2) :
    jT.mass (some z) ≤ attemptFactor * (trial A c).mass (some z) ∧
      0 < (trial A c).mass (some z) ∧
      0 < (signBody A c).mass (some z.2) := by
  have hpt := (attemptPointwise_of_attemptWeights hshape cw).some_le z
  have htr : 0 < (trial A c).mass (some z) :=
    (SignLayerSupport.trial_some_pos_iff A c z).2 ⟨hf, hz⟩
  have hsb : 0 < (signBody A (A z)).mass (some z.2) :=
    SignLayerSupport.emitted_reply_supported A z hz hs
  refine ⟨hpt, htr, ?_⟩
  rwa [hf] at hsb

/-- The reply-level `some`-side comparison over the `emit` image: the
propagated factor `k^16` on every emitted reply value (consumes the proved
`SignLayerSupport.signBodyOf_le_of_attempt_le`). -/
theorem reply_some_le {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    {hw : ∀ z, 0 ≤ w z}
    (hshape : AttemptShape jT w hw) (cw : AttemptWeights A c w) (x : BoxVec) :
    (signBodyOf jT).mass (some x) ≤ attemptFactor ^ 16 * (signBody A c).mass (some x) :=
  SignLayerSupport.signBodyOf_le_of_attempt_le jT (trial A c) attemptFactor
    SignLayerSupport.attemptFactor_one_le
    (SignLayerSupport.attemptPointwise_le (attemptPointwise_of_attemptWeights hshape cw))
    (some x)

/-! ## 4. The none-side comparison: the four `none` cases -/

/-- None case (i): EMPTY FIBER — the empty-fiber abort puts mass `1` on
`none` in BOTH laws (the sandwich forces `W = 0 ↔ G = 0`, so the support
match is free). -/
theorem none_case_empty_fiber {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    {hw : ∀ z, 0 ≤ w z}
    (hshape : AttemptShape jT w hw) (cw : AttemptWeights A c w)
    (hempty : ∀ z : BoxPair, A z ≠ c) :
    jT.mass none = 1 ∧ (trial A c).mass none = 1 := by
  have hg0 : (∑ z, fiberWeight A c z) = 0 :=
    sum_eq_zero (fun z _ => (fiberWeight_eq_zero_iff A c z).2 (hempty z))
  obtain ⟨hsum_lo, hsum_hi⟩ := sandwich_sum (attemptWeights_sandwich cw)
  have hW : (∑ z, w z) = 0 := by
    apply le_antisymm _ (sum_nonneg fun z _ => attemptWeights_nonneg cw z)
    have := hsum_hi
    rw [hg0, mul_zero] at this
    exact this
  have hnW : ¬ 0 < ∑ z, w z := by
    rw [hW]
    exact lt_irrefl 0
  have hif : (if 0 < ∑ z, w z then tailMass w / (∑ y, w y) else (1:ℝ)) = 1 := by
    simp [hnW]
  rw [hshape none, attemptOf_none, hif]
  have htrial : (trial A c).mass none = 1 := by
    rw [RejectionBound.trial_none_mass]
    have hif' : (if 0 < RejectionBound.fiberMass A c
        then RejectionBound.fiberTailMass A c / RejectionBound.fiberMass A c
        else (1:ℝ)) = 1 := by
      simp [RejectionBound.fiberMass, hg0]
    rw [hif']
  exact ⟨rfl, htrial⟩

/-- None case (ii): NORM REJECT — with a nonempty fiber the attempt-level miss
is exactly the tail (weight) comparison `tailMass w / ∑ w` against
`fiberTailMass / fiberMass`; it rides the SAME two-sided sandwich as the
some-side and is genuinely independent of it. This is where the miss mass
lives; `CenteringClosure.rejB = 2^-24` (the absolute miss-mass budget of the
`delta` bridge `bridgeUb` and of the `second_cond_le` fallback) stays OUTSIDE
the multiplicative factor, as recorded. -/
theorem none_case_norm_reject {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    {hw : ∀ z, 0 ≤ w z}
    (hshape : AttemptShape jT w hw) (cw : AttemptWeights A c w)
    (hne : ∃ z : BoxPair, A z = c) :
    (trial A c).mass none
        = RejectionBound.fiberTailMass A c / RejectionBound.fiberMass A c ∧
      jT.mass none = tailMass w / (∑ y, w y) ∧
      tailMass w / (∑ y, w y) ≤
        attemptFactor * (RejectionBound.fiberTailMass A c / RejectionBound.fiberMass A c) := by
  obtain ⟨z0, hz0⟩ := hne
  have hG : 0 < ∑ z, fiberWeight A c z :=
    sum_pos' (fun z _ => fiberWeight_nonneg A c z)
      ⟨z0, mem_univ z0, (fiberWeight_pos_iff A c z0).2 hz0⟩
  have hW : 0 < ∑ z, w z := by
    obtain ⟨hsum_lo, _⟩ := sandwich_sum (attemptWeights_sandwich cw)
    exact lt_of_lt_of_le (mul_pos chain_pos hG) hsum_lo
  have htr : (trial A c).mass none
      = RejectionBound.fiberTailMass A c / RejectionBound.fiberMass A c := by
    rw [RejectionBound.trial_none_mass]
    have hif : (if 0 < RejectionBound.fiberMass A c
        then RejectionBound.fiberTailMass A c / RejectionBound.fiberMass A c
        else (1:ℝ))
        = RejectionBound.fiberTailMass A c / RejectionBound.fiberMass A c := by
      simp [RejectionBound.fiberMass, hG]
    rw [hif]
  have hjt : jT.mass none = tailMass w / (∑ y, w y) := by
    rw [hshape none, attemptOf_none]
    have hif : (if 0 < ∑ z, w z then tailMass w / (∑ y, w y) else (1:ℝ))
        = tailMass w / (∑ y, w y) := by
      simp [hW]
    rw [hif]
  have hpt := (attemptPointwise_of_attemptWeights hshape cw).none_le
  refine ⟨htr, hjt, ?_⟩
  rw [hjt, htr] at hpt
  exact hpt

/-- None case (iii): CAP EXHAUSTION — the 16-fold exhaustion term of
`SignLayerSupport.signBodyOf_mass_none` carries the miss powers
`k^16 = (k^16)^1` at the attempt factor `k` (consumes
`SignLayerSupport.pow_mono_base`). -/
theorem none_case_cap_exhaustion {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {k : ℝ}
    (hpt : SignLayerSupport.AttemptPointwise jT A c k) :
    jT.mass none ^ 16 ≤ k ^ 16 * (trial A c).mass none ^ 16 := by
  have h1 : jT.mass none ^ 16 ≤ (k * (trial A c).mass none) ^ 16 :=
    SignLayerSupport.pow_mono_base (hpt.none_le) (jT.nonneg none) 16
  have h2 : (k * (trial A c).mass none) ^ 16
      = k ^ 16 * (trial A c).mass none ^ 16 := mul_pow k ((trial A c).mass none) 16
  rw [← h2]
  exact h1

/-- Pointwise monotonicity of `imageMass` (the `emit`-image numerator). -/
theorem imageMass_le_of_pointwise {jT pT : Law (Option BoxPair)} {k : ℝ}
    (hk : 0 ≤ k) (hpt : ∀ o, jT.mass o ≤ k * pT.mass o) (r : Option BoxVec) :
    imageMass jT r ≤ k * imageMass pT r := by
  show (∑ z : BoxPair, if emit z = r then jT.mass (some z) else 0)
      ≤ k * ∑ z : BoxPair, if emit z = r then pT.mass (some z) else 0
  have hterm : ∀ z : BoxPair, (if emit z = r then jT.mass (some z) else 0)
      ≤ k * (if emit z = r then pT.mass (some z) else 0) := by
    intro z
    split_ifs with h
    · exact hpt (some z)
    · exact mul_nonneg hk (le_refl 0)
  calc (∑ z : BoxPair, if emit z = r then jT.mass (some z) else 0)
      ≤ ∑ z : BoxPair, k * (if emit z = r then pT.mass (some z) else 0) :=
        sum_le_sum (fun z _ => hterm z)
    _ = k * ∑ z : BoxPair, if emit z = r then pT.mass (some z) else 0 :=
        (Finset.mul_sum univ
          (fun z : BoxPair => if emit z = r then pT.mass (some z) else 0) k).symm

/-- Monotonicity of the retry factor `geo jT 16 = ∑_{i<16} (jT.mass none)^i`
(mirror of the `hgeo` step of `SignLayerSupport.cap_le_of_pointwise`). -/
theorem geo_le_of_pointwise {jT pT : Law (Option BoxPair)} {k : ℝ}
    (hk : 1 ≤ k) (hpt : ∀ o, jT.mass o ≤ k * pT.mass o) :
    geo jT 16 ≤ k ^ 15 * geo pT 16 := by
  show (∑ i ∈ range 16, jT.mass none ^ i)
      ≤ k ^ 15 * ∑ i ∈ range 16, pT.mass none ^ i
  calc (∑ i ∈ range 16, jT.mass none ^ i)
      ≤ ∑ i ∈ range 16, (k * pT.mass none) ^ i :=
        sum_le_sum (fun i _ =>
          SignLayerSupport.pow_mono_base (hpt none) (jT.nonneg none) i)
    _ = ∑ i ∈ range 16, k ^ i * pT.mass none ^ i := by
        simp only [mul_pow]
    _ ≤ ∑ i ∈ range 16, k ^ 15 * pT.mass none ^ i :=
        sum_le_sum (fun i hi => mul_le_mul_of_nonneg_right
          (SignLayerSupport.pow_mono_exp hk (Nat.le_of_lt_succ (mem_range.mp hi)))
          (pow_nonneg (pT.nonneg none) i))
    _ = k ^ 15 * ∑ i ∈ range 16, pT.mass none ^ i :=
        (Finset.mul_sum (range 16) (fun i => pT.mass none ^ i) (k ^ 15)).symm

/-- None case (iv): the `emit` ENCODE-FAILURE TAG (`¬ signed16 z.2`) — the
second term of `SignLayerSupport.signBodyOf_mass_none` carries `k^15` from the
retry factor and `k` from the tagged candidates, together `k^16`. -/
theorem none_case_encode_flag {jT pT : Law (Option BoxPair)} {k : ℝ}
    (hk : 1 ≤ k) (hpt : ∀ o, jT.mass o ≤ k * pT.mass o) :
    geo jT 16 * imageMass jT none ≤
      k ^ 16 * (geo pT 16 * imageMass pT none) := by
  have h1 : geo jT 16 * imageMass jT none
      ≤ (k ^ 15 * geo pT 16) * (k * imageMass pT none) :=
    mul_le_mul (geo_le_of_pointwise hk hpt)
      (imageMass_le_of_pointwise (le_trans zero_le_one hk) hpt none)
      (imageMass_nonneg jT none)
      (mul_nonneg (pow_nonneg (le_trans zero_le_one hk) 15) (geo16_pos pT).le)
  have h2 : (k ^ 15 * geo pT 16) * (k * imageMass pT none)
      = k ^ 16 * (geo pT 16 * imageMass pT none) := by
    ring
  rw [← h2]
  exact h1

/-- THE none-side assembly: the reply-level miss point (all four cases — the
attempt-level empty-fiber/norm-reject miss powers and the `emit` encode-failure
tag) is within `k^16` of the pinned honest body. `rejB` remains OUTSIDE this
multiplicative factor (see `none_case_norm_reject`). -/
theorem reply_none_le {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {k : ℝ} (hk : 1 ≤ k)
    (hpt : SignLayerSupport.AttemptPointwise jT A c k) :
    (signBodyOf jT).mass none ≤ k ^ 16 * (signBody A c).mass none := by
  rw [signBodyOf_mass_none jT, signBody_eq_signBodyOf A c, signBodyOf_mass_none (trial A c)]
  have e1 := none_case_cap_exhaustion hpt
  have e2 := none_case_encode_flag hk (SignLayerSupport.attemptPointwise_le hpt)
  calc jT.mass none ^ 16 + geo jT 16 * imageMass jT none
      ≤ k ^ 16 * (trial A c).mass none ^ 16
          + k ^ 16 * (geo (trial A c) 16 * imageMass (trial A c) none) :=
        add_le_add e1 e2
    _ = k ^ 16 * ((trial A c).mass none ^ 16
          + geo (trial A c) 16 * imageMass (trial A c) none) :=
        (mul_add _ _ _).symm

/-! ## 5. The Layer-2 deliverable: `e2 < 2^-32` upgraded to ACTUAL -/

/-- THE deliverable (structural form): from the reply binding
(`SignLayerSupport.ReplyShape`) and the two named attempt boundaries
(`AttemptShape`, `AttemptWeights`), one `S.run` satisfies `Divergence.AC` and
`Divergence.second j (signBody A c) ≤ 1 + e2 attemptFactor`. -/
theorem layer2_of_attemptWeights {j : Law (Option BoxVec)} {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    {hw : ∀ z, 0 ≤ w z}
    (hshape : SignLayerSupport.ReplyShape j jT) (atshape : AttemptShape jT w hw)
    (cw : AttemptWeights A c w) :
    Divergence.AC j (signBody A c) ∧
      Divergence.second j (signBody A c)
        ≤ 1 + SignLayerSupport.e2 attemptFactor :=
  SignLayerSupport.layer2_of_obligations j jT A c attemptFactor
    SignLayerSupport.attemptFactor_one_le hshape
    (attemptPointwise_of_attemptWeights atshape cw)

/-- THE deliverable (numeric form, ACTUAL — not conditional): from
`SignLayerSupport.ReplyShape`, `AttemptShape` and `AttemptWeights` alone,
`Divergence.second j (signBody A c) < 1 + 2^-32`. The corollary
`e2 attemptFactor < 2^-32` of `SignLayerSupport` was CONDITIONAL on the
one-attempt comparison being delivered at `k = attemptFactor`;
`attemptPointwise_of_attemptWeights` delivers it from the named boundaries, so
the bound is now actual relative to those boundaries. -/
theorem layer2_e2_actual {j : Law (Option BoxVec)} {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    {hw : ∀ z, 0 ≤ w z}
    (hshape : SignLayerSupport.ReplyShape j jT) (atshape : AttemptShape jT w hw)
    (cw : AttemptWeights A c w) :
    Divergence.AC j (signBody A c) ∧
      Divergence.second j (signBody A c) < 1 + 1 / 4294967296 := by
  obtain ⟨hac, hse⟩ := layer2_of_attemptWeights hshape atshape cw
  refine ⟨hac, ?_⟩
  have hnum : SignLayerSupport.e2 attemptFactor < 1 / 4294967296 :=
    SignLayerSupport.e2_attemptFactor_lt
  linarith

end FT1536.AttemptPointwise
