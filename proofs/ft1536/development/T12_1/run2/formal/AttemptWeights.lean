import AttemptPointwise
import ONoneGeometry

/-! # AttemptWeights — the four-stage sandwich transport (the heavy analytic core)

Window `notes/PROMPT_ATTEMPT_WEIGHTS.md` of rung B4/3b: the one-attempt mass
comparison of `AttemptPointwise` factorizes as a TRANSPORT of the realized
attempt weights through FOUR stages, each with a recorded multiplicative
margin. Scope of THIS module (all kernel-checked, no new model, no new numeric
input — every budget is CONSUMED from `SignLayerSupport`/`CenteringClosure`/
`Run2.T5ScalarMass`):

1. **The four-stage interface (named parameters, exact types)** — the realized
   intermediate weight systems `target`/`mach`/`wrapS` arrive from the
   `do_sign` kernel (B1/source3, in progress) as NAMED PARAMETERS with the
   exact stage types of `notes/B4_ATTEMPT_WORK_STATE.md` (`TowerWhole`,
   `MachineStage`, `WrapStage`, `BoxStage`). `attemptWeights_of_stages` is THE
   transport: it instantiates the `AttemptWeights` boundary of
   `AttemptPointwise` with those witnesses; `layer2_of_stageChain` delivers
   `Divergence.second j (signBody A c) < 1 + 2^-32` from the four stage
   statements plus `ReplyShape` + `AttemptShape`.
2. **The WHOLE tail-region transport (the named heavy item)** — the stage-1
   sandwich must hold over the ENTIRE candidate space including the tail
   region `¬ Q (decode z) < B` (the miss numerator region), not just the bulk.
   The region machinery (`regionMass`, `RegionSandwich`,
   `sandwich_regionMass`) is the global tail-region statement of the
   transport: any per-point stage sandwich restricts to EVERY region at the
   SAME margins (`sandwich_tailMass`, `sandwich_bulkMass`, `tail_ratio_le`).
   The kernel counterexamples `bulkOnly_tail_uncontrolled` /
   `bulkOnly_normalized_tail_uncontrolled` discharge the trap recorded in
   `notes/B4_ATTEMPT_WORK_STATE.md` §3: a BULK-ONLY sandwich does NOT control
   the miss point (neither the unnormalized nor the normalized tail
   comparison), so the whole-tail-region sandwich is a non-optional part of
   the `AttemptWeights` premise.
3. **The stage margin table (exact-ℚ, `norm_num` style of `CenteringClosure`)**:
   stage 1 `towerMargin < 1 + 2^-43` and stage 2 `machineMargin < 1 + 2^-42`
   (both CONSUMED: `SignLayerSupport.towerMargin_lt`/`machineMargin_lt`),
   stage 3 `wrapFactor < 1 + 1/(2^39 - 1)` at `tauB = 2^-40` (consumed), stage 4
   `boxFactor < 1 + 10^-30` at `boxB = 1e-1000` (consumed; the stage slack
   bound keeps the recorded `1e-1000` scale). `attemptFactor_comp_lt` composes
   the four stage bounds to `attemptFactor < 1 + 2^-38` — FROM the stage table,
   not by re-expanding the composite — and `e2_comp_lt` records
   `e2 attemptFactor < 2^-32` (`e2 k = k^32 - 1`).
4. **Which attempt shape the transport proves — and the delta** — the
   transport proves the UNCONDITIONED sample-then-check shape (`AttemptShape`
   over the full realized target `w`, miss = out-of-box), so
   `CenteringClosure.rejB = 2^-24` stays OUTSIDE the multiplicative factor. The
   recorded shape trap is discharged as an exact delta: the
   ACCEPTANCE-CONDITIONED shape (draw-until-short WITHIN one attempt =
   `attemptCondWeights`, the in-box truncation of `w`) transports the BULK
   sandwich only, and its some-side comparison picks up exactly `1/(1-rejB)`
   from the honest miss budget (`conditioned_ratio_le`,
   `conditioned_attemptOf_le`, `attemptPointwise_of_conditionedChain`) — i.e.
   `rejB` moves INSIDE at `conditionedFactor = attemptFactor/(1-rejB) <
   1 + 2^-23` with `e2 < 2^-17` (kernel-checked; the analytic scale is
   `~ 2^-19`).

## Honest boundaries (recorded, not papered over)

- The DEFINITION of the realized attempt weights `w`/`target`/`mach`/`wrapS`
  comes from the `AttemptShape` interface (B1/source3 `S.code` binding, in
  progress) and is taken as NAMED PARAMETERS with the exact stage types above.
  This module proves the TRANSPORT for any weights satisfying that interface;
  it does not close the sampler-side binding.
- The analytic kernel mass sandwiches of stage 1
  (`TriangularGaussian.triangular_mass_bounds`,
  `ConvStruct.a2Tower_mass_bounds`, `Run2.ShiftedGaussian.shifted_mass_bounds`,
  `Run2.T5ScalarMass.uniform_shifted_mass_3072`,
  `PerKeyTransport.perKey_mass_bounds`) are TOTAL-mass statements (whole-space
  sums — bulk and tail together). Their per-point transport onto the realized
  `target` over the WHOLE candidate space (the `TowerWhole` field) is the EXACT
  missing lemma with its intended type; it is the input for the T5/REFINE
  material owners and the `do_sign` kernel, and is NEVER assumed here (see
  `notes/B4_ATTEMPT_WEIGHTS_WORK_STATE.md` for the proven/assumed split).
- Additive errors (`Adv_PRG`, byte bridges) stay OUT of the multiplicative
  shape (mass-floor caveat of `notes/B4_SYNTHESIS.md`, unchanged) — not forced
  in here.

No unfinished-proof markers; standard axioms only.
-/

namespace FT1536.AttemptWeights
set_option maxRecDepth 8192
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry FT1536.SignLayerSupport
  FT1536.AttemptPointwise

/-! ## 0. The four-stage transport interface (named parameters, exact types) -/

/-- **Stage 1 (A2 tower / fiber-tilt — the heavy item)**: the per-point mass
sandwich of the sampler's realized target weights `target` against the pinned
fiber weights `fiberWeight A c` over the WHOLE candidate space — every
`z : BoxPair`, INCLUDING the tail region `¬ Q (decode z) < B` (the miss
numerator region of `tailMass`; see Part 2). Analytic kernel inputs (CONSUMED,
cited): `TriangularGaussian.triangular_mass_bounds`,
`ConvStruct.a2Tower_mass_bounds`, `Run2.ShiftedGaussian.shifted_mass_bounds`,
`Run2.T5ScalarMass.rowBudget`; their per-point transport onto the sampler
target is the exact missing lemma recorded in
`notes/B4_ATTEMPT_WEIGHTS_WORK_STATE.md` (input for the T5/REFINE material
owners + the B1/source3 `do_sign` kernel). -/
def TowerWhole (A : BoxPair → Relation.Rq) (c : Relation.Rq) (target : BoxPair → ℝ) : Prop :=
  Sandwich towerLo towerHi (fiberWeight A c) target

/-- **Stage 2 (T5 machine rounding of the weights)**: the H3 error-contract
sandwich `t5lo * target ≤ mach ≤ t5hi * target` of
`CenteringClosure.t5lo`/`t5hi` (kernel `t5_leaf_floor_gt`), transported onto
the realized machine weights `mach`. -/
def MachineStage (target mach : BoxPair → ℝ) : Prop :=
  Sandwich (CenteringClosure.t5lo : ℝ) (CenteringClosure.t5hi : ℝ) target mach

/-- **Stage 3 (wrap/centering distortion)**: `(1-tauB) * mach ≤ wrapS ≤
(1+tauB) * mach` at the consumed budget `CenteringClosure.tauB = 2^-40` (the
`hbridge`-side all-key transport stays its named premise in `CenteringClosure`). -/
def WrapStage (mach wrapS : BoxPair → ℝ) : Prop :=
  Sandwich (1 - (CenteringClosure.tauB : ℝ)) (1 + (CenteringClosure.tauB : ℝ)) mach wrapS

/-- **Stage 4 (box truncation)**: `1 * wrapS ≤ w ≤ (1/(1-boxB)) * wrapS` at the
consumed budget `CenteringClosure.boxB = 1e-1000`. -/
def BoxStage (wrapS w : BoxPair → ℝ) : Prop :=
  Sandwich 1 (1 / (1 - (CenteringClosure.boxB : ℝ))) wrapS w

/-- THE four-stage transport (constructor direction): stage data delivered by
the sampler-side bindings instantiate the `AttemptWeights` interface — the
intermediate systems `target`/`mach`/`wrapS` ARE the witnesses of the
existential. -/
theorem attemptWeights_of_stages {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    (target mach wrapS w : BoxPair → ℝ)
    (h1 : TowerWhole A c target) (h2 : MachineStage target mach)
    (h3 : WrapStage mach wrapS) (h4 : BoxStage wrapS w) :
    AttemptWeights A c w :=
  ⟨target, mach, wrapS, h1, h2, h3, h4⟩

/-- Projection direction: every `AttemptWeights` chain unpacks into the four
named stage statements (the interface pins the EXACT stage types). -/
theorem stages_of_attemptWeights {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {w : BoxPair → ℝ} (cw : AttemptWeights A c w) :
    ∃ (target mach wrapS : BoxPair → ℝ),
      TowerWhole A c target ∧ MachineStage target mach ∧ WrapStage mach wrapS
        ∧ BoxStage wrapS w := by
  obtain ⟨target, mach, wrapS, h1, h2, h3, h4⟩ := cw
  exact ⟨target, mach, wrapS, h1, h2, h3, h4⟩

/-- Sandwiches compose by multiplying their margins across FOUR stages (the
factorization mechanism of the transport). -/
theorem sandwich_comp4 {l1 h1 l2 h2 l3 h3 l4 h4 : ℝ} {a b c d e : BoxPair → ℝ}
    (n2 : 0 ≤ l2) (N2 : 0 ≤ h2) (n3 : 0 ≤ l3) (N3 : 0 ≤ h3)
    (n4 : 0 ≤ l4) (N4 : 0 ≤ h4)
    (s1 : Sandwich l1 h1 a b) (s2 : Sandwich l2 h2 b c)
    (s3 : Sandwich l3 h3 c d) (s4 : Sandwich l4 h4 d e) :
    Sandwich (l1 * l2 * l3 * l4) (h1 * h2 * h3 * h4) a e :=
  sandwich_comp n4 N4 (sandwich_comp n3 N3 (sandwich_comp n2 N2 s1 s2) s3) s4

/-- THE deliverable of the unconditioned shape (structural): the four stage
statements + `ReplyShape` + `AttemptShape` give `second < 1 + 2^-32` — the
stage table below splits exactly which margins are PROVEN here and which stay
ASSUMED stage data. -/
theorem layer2_of_stageChain {j : Law (Option BoxVec)} {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    (hw : ∀ z, 0 ≤ w z)
    (target mach wrapS : BoxPair → ℝ)
    (h1 : TowerWhole A c target) (h2 : MachineStage target mach)
    (h3 : WrapStage mach wrapS) (h4 : BoxStage wrapS w)
    (hshapeR : ReplyShape j jT) (hshape : AttemptShape jT w hw) :
    Divergence.AC j (signBody A c) ∧
      Divergence.second j (signBody A c) < 1 + 1 / 4294967296 :=
  layer2_e2_actual hshapeR hshape
    (attemptWeights_of_stages target mach wrapS w h1 h2 h3 h4)

/-! ## 2. The WHOLE tail-region transport (the named heavy item) -/

/-- Bulk (in-box) region mass of a weight system: the weight INSIDE the norm
gate. -/
noncomputable def bulkMass (u : BoxPair → ℝ) : ℝ :=
  ∑ z, u z * (if Q (decode z) < B then (1:ℝ) else 0)

/-- Region-restricted mass at an arbitrary region predicate (small def in the
`SecondMoment` style) — the "whole region" accounting unit. -/
noncomputable def regionMass (u : BoxPair → ℝ) (R : BoxPair → Prop) [DecidablePred R] : ℝ :=
  ∑ z, u z * (if R z then (1:ℝ) else 0)

theorem bulk_nonneg (u : BoxPair → ℝ) (hu : ∀ z, 0 ≤ u z) : 0 ≤ bulkMass u := by
  show 0 ≤ ∑ z, u z * (if Q (decode z) < B then (1:ℝ) else 0)
  exact sum_nonneg (fun z _ => mul_nonneg (hu z) (by split_ifs <;> norm_num))

/-- The miss numerator `tailMass` is the TAIL region mass (the whole region
`¬ Q (decode z) < B`). -/
theorem tailMass_eq_regionMass (u : BoxPair → ℝ) :
    tailMass u = regionMass u (fun z => ¬ (Q (decode z) < B)) := by
  simp only [tailMass, regionMass]
  apply sum_congr rfl
  intro z _
  by_cases h : Q (decode z) < B <;> simp [h]

theorem bulkMass_eq_regionMass (u : BoxPair → ℝ) :
    bulkMass u = regionMass u (fun z => Q (decode z) < B) := by
  simp only [bulkMass, regionMass]

/-- Total mass = bulk + tail (the region split of the whole candidate space). -/
theorem bulk_add_tail (u : BoxPair → ℝ) : ∑ y, u y = bulkMass u + tailMass u := by
  have hpt : ∀ z : BoxPair,
      u z = u z * (if Q (decode z) < B then (1:ℝ) else 0)
          + u z * (if Q (decode z) < B then (0:ℝ) else 1) := by
    intro z
    by_cases h : Q (decode z) < B <;> simp [h]
  show (∑ y, u y) = (∑ z, u z * (if Q (decode z) < B then (1:ℝ) else 0))
      + (∑ z, u z * (if Q (decode z) < B then (0:ℝ) else 1))
  calc (∑ y, u y)
        = ∑ z, (u z * (if Q (decode z) < B then (1:ℝ) else 0)
          + u z * (if Q (decode z) < B then (0:ℝ) else 1)) :=
          sum_congr rfl (fun z _ => hpt z)
    _ = (∑ z, u z * (if Q (decode z) < B then (1:ℝ) else 0))
        + (∑ z, u z * (if Q (decode z) < B then (0:ℝ) else 1)) :=
          sum_add_distrib

/-- The stage sandwich RESTRICTED to a region — the exact "whole region" form
required over the entire tail region `¬ Q (decode z) < B`: the multiplicative
weight comparison must hold at EVERY point of the region, not just of the
bulk. -/
def RegionSandwich (lo hi : ℝ) (g w : BoxPair → ℝ) (R : BoxPair → Prop)
    [DecidablePred R] : Prop :=
  ∀ z : BoxPair, R z → lo * g z ≤ w z ∧ w z ≤ hi * g z

/-- A whole-space sandwich restricts to every region at the SAME margins. -/
theorem regionSandwich_of_sandwich {lo hi : ℝ} {g w : BoxPair → ℝ}
    (hS : Sandwich lo hi g w) (R : BoxPair → Prop) [DecidablePred R] :
    RegionSandwich lo hi g w R :=
  fun z _ => hS z

/-- THE global tail-region statement of the transport (pointwise identity,
then compose): a region sandwich composes to the region masses at the SAME
margins — for EVERY region, hence for the whole tail region. -/
theorem sandwich_regionMass {lo hi : ℝ} {g w : BoxPair → ℝ}
    {R : BoxPair → Prop} [DecidablePred R]
    (hRS : RegionSandwich lo hi g w R) :
    lo * regionMass g R ≤ regionMass w R ∧ regionMass w R ≤ hi * regionMass g R := by
  show lo * (∑ z, g z * (if R z then (1:ℝ) else 0)) ≤ ∑ z, w z * (if R z then (1:ℝ) else 0)
      ∧ (∑ z, w z * (if R z then (1:ℝ) else 0)) ≤ hi * (∑ z, g z * (if R z then (1:ℝ) else 0))
  have hn : ∀ z : BoxPair, 0 ≤ (if R z then (1:ℝ) else 0) := by
    intro z
    by_cases h : R z <;> simp [h]
  have hlo : ∀ z : BoxPair, lo * (g z * (if R z then (1:ℝ) else 0))
      ≤ w z * (if R z then (1:ℝ) else 0) := by
    intro z
    by_cases h : R z
    · have hA : (lo * g z) * (if R z then (1:ℝ) else 0)
          ≤ w z * (if R z then (1:ℝ) else 0) :=
        mul_le_mul_of_nonneg_right (hRS z h).1 (hn z)
      have hB : lo * (g z * (if R z then (1:ℝ) else 0))
          = (lo * g z) * (if R z then (1:ℝ) else 0) := by
        ring
      rw [hB]
      exact hA
    · simp [h]
  have hhi : ∀ z : BoxPair, w z * (if R z then (1:ℝ) else 0)
      ≤ hi * (g z * (if R z then (1:ℝ) else 0)) := by
    intro z
    by_cases h : R z
    · have hA : w z * (if R z then (1:ℝ) else 0)
          ≤ (hi * g z) * (if R z then (1:ℝ) else 0) :=
        mul_le_mul_of_nonneg_right (hRS z h).2 (hn z)
      have hB : (hi * g z) * (if R z then (1:ℝ) else 0)
          = hi * (g z * (if R z then (1:ℝ) else 0)) := by
        ring
      rw [← hB]
      exact hA
    · simp [h]
  constructor
  · have h1 : (∑ z, lo * (g z * (if R z then (1:ℝ) else 0)))
        ≤ ∑ z, w z * (if R z then (1:ℝ) else 0) :=
      sum_le_sum (fun z _ => hlo z)
    have hfold : (∑ z, lo * (g z * (if R z then (1:ℝ) else 0)))
        = lo * ∑ z, g z * (if R z then (1:ℝ) else 0) :=
      (Finset.mul_sum univ (fun z : BoxPair => g z * (if R z then (1:ℝ) else 0)) lo).symm
    rw [← hfold]
    exact h1
  · have h1 : (∑ z, w z * (if R z then (1:ℝ) else 0))
        ≤ ∑ z, hi * (g z * (if R z then (1:ℝ) else 0)) :=
      sum_le_sum (fun z _ => hhi z)
    have hfold : (∑ z, hi * (g z * (if R z then (1:ℝ) else 0)))
        = hi * ∑ z, g z * (if R z then (1:ℝ) else 0) :=
      (Finset.mul_sum univ (fun z : BoxPair => g z * (if R z then (1:ℝ) else 0)) hi).symm
    rw [← hfold]
    exact h1

/-- Whole-tail-region sandwich at the SAME margins (the miss numerator of the
one-attempt comparison). -/
theorem sandwich_tailMass {lo hi : ℝ} {g w : BoxPair → ℝ}
    (hRS : RegionSandwich lo hi g w (fun z => ¬ (Q (decode z) < B))) :
    lo * tailMass g ≤ tailMass w ∧ tailMass w ≤ hi * tailMass g := by
  rw [tailMass_eq_regionMass g, tailMass_eq_regionMass w]
  exact sandwich_regionMass hRS

/-- Bulk-region sandwich at the SAME margins. -/
theorem sandwich_bulkMass {lo hi : ℝ} {g w : BoxPair → ℝ}
    (hRS : RegionSandwich lo hi g w (fun z => Q (decode z) < B)) :
    lo * bulkMass g ≤ bulkMass w ∧ bulkMass w ≤ hi * bulkMass g := by
  rw [bulkMass_eq_regionMass g, bulkMass_eq_regionMass w]
  exact sandwich_regionMass hRS

/-- The normalized whole-tail-region transport (the MISS comparison at the
weight level): the tail mass ratio of the two weight systems is within
`hi / lo` — riding the same two-sided sandwich as the some-side and
GENUINELY INDEPENDENT of it (see the counterexamples below). -/
theorem tail_ratio_le {lo hi : ℝ} {g w : BoxPair → ℝ}
    (hlo : 0 < lo) (hle : lo ≤ hi) (hg : ∀ z, 0 ≤ g z)
    (hS : Sandwich lo hi g w) (hG : 0 < ∑ y, g y) :
    tailMass w / ∑ y, w y ≤ (hi / lo) * (tailMass g / ∑ y, g y) := by
  obtain ⟨hsum_lo, _⟩ := sandwich_sum hS
  have hW : 0 < ∑ y, w y := lt_of_lt_of_le (mul_pos hlo hG) hsum_lo
  have htail := (sandwich_tailMass (regionSandwich_of_sandwich hS _)).2
  have hhi : 0 ≤ hi := le_trans (le_of_lt hlo) hle
  have h1 : tailMass w / ∑ y, w y ≤ hi * tailMass g / ∑ y, w y :=
    div_le_div_of_nonneg_right htail (le_of_lt hW)
  have h2 : hi * tailMass g / ∑ y, w y ≤ (hi / lo) * (tailMass g / ∑ y, g y) := by
    have hA : hi * tailMass g / ∑ y, w y ≤ hi * tailMass g / (lo * ∑ y, g y) :=
      div_le_div_of_nonneg_left (mul_nonneg hhi (tailMass_nonneg g hg))
        (mul_pos hlo hG) hsum_lo
    have hB : hi * tailMass g / (lo * ∑ y, g y) = (hi / lo) * (tailMass g / ∑ y, g y) := by
      field_simp [ne_of_gt hlo, ne_of_gt hG]
    rw [← hB]
    exact hA
  exact le_trans h1 h2

/-! ### THE trap: a bulk-only sandwich does NOT control the miss point -/

/-- KERNEL COUNTEREXAMPLE (the recorded trap, unnormalized form): there are
weight systems with an EXACT bulk sandwich at any margins `lo ≤ 1 ≤ hi` whose
tail masses violate `tailMass w ≤ hi * tailMass g` maximally. The
whole-tail-region sandwich of stage 1 is therefore NON-OPTIONAL for the miss
comparison of `AttemptPointwise.none_case_norm_reject`. -/
theorem bulkOnly_tail_uncontrolled {lo hi : ℝ} (hlo : lo ≤ 1) (hhi : 1 ≤ hi) :
    ∃ (g w : BoxPair → ℝ), (∀ z, 0 ≤ g z) ∧ (∀ z, 0 ≤ w z)
      ∧ RegionSandwich lo hi g w (fun z => Q (decode z) < B)
      ∧ ¬ (tailMass w ≤ hi * tailMass g) := by
  refine ⟨fun z => if Q (decode z) < B then (1:ℝ) else 0, fun _ => (1:ℝ),
    ?_, ?_, ?_, ?_⟩
  · intro z
    by_cases h : Q (decode z) < B <;> simp [h]
  · intro z
    exact zero_le_one
  · intro z hz
    have hg : (if Q (decode z) < B then (1:ℝ) else 0) = 1 := by simp [hz]
    show lo * (if Q (decode z) < B then (1:ℝ) else 0) ≤ (1:ℝ)
        ∧ (1:ℝ) ≤ hi * (if Q (decode z) < B then (1:ℝ) else 0)
    rw [hg]
    simp only [mul_one]
    exact ⟨hlo, hhi⟩
  · have hg0 : tailMass (fun z => if Q (decode z) < B then (1:ℝ) else 0) = 0 := by
      show (∑ z, (if Q (decode z) < B then (1:ℝ) else 0)
          * (if Q (decode z) < B then (0:ℝ) else 1)) = 0
      apply sum_eq_zero
      intro z _
      by_cases h : Q (decode z) < B <;> simp [h]
    have hw0 : 0 < tailMass (fun _ => (1:ℝ)) := by
      show 0 < ∑ z, (1:ℝ) * (if Q (decode z) < B then (0:ℝ) else 1)
      have hnn : ∀ z : BoxPair, 0 ≤ (1:ℝ) * (if Q (decode z) < B then (0:ℝ) else 1) := by
        intro z
        by_cases h : Q (decode z) < B <;> simp [h]
      refine sum_pos' (fun z _ => hnn z) ?_
      refine ⟨ONoneGeometry.liftPair zeroPair, mem_univ _, ?_⟩
      have hout : ¬ Q (decode (ONoneGeometry.liftPair zeroPair)) < B :=
        ONoneGeometry.liftPair_out_of_box zeroPair
      show (0:ℝ) < (1:ℝ) * (if Q (decode (ONoneGeometry.liftPair zeroPair)) < B
        then (0:ℝ) else 1)
      simp [hout]
    intro hc
    rw [hg0, mul_zero] at hc
    exact lt_irrefl 0 (lt_of_lt_of_le hw0 hc)

/-- KERNEL COUNTEREXAMPLE (the recorded trap, normalized form): the same bulk
sandwich leaves even the NORMALIZED miss comparison
`tailMass w / ∑ w ≤ (hi/lo) * tailMass g / ∑ g` uncontrolled. -/
theorem bulkOnly_normalized_tail_uncontrolled {lo hi : ℝ} (hlo : lo ≤ 1) (hhi : 1 ≤ hi) :
    ∃ (g w : BoxPair → ℝ), (∀ z, 0 ≤ g z) ∧ (∀ z, 0 ≤ w z)
      ∧ RegionSandwich lo hi g w (fun z => Q (decode z) < B)
      ∧ ¬ (tailMass w / ∑ y, w y ≤ (hi / lo) * (tailMass g / ∑ y, g y)) := by
  refine ⟨fun z => if Q (decode z) < B then (1:ℝ) else 0, fun _ => (1:ℝ),
    ?_, ?_, ?_, ?_⟩
  · intro z
    by_cases h : Q (decode z) < B <;> simp [h]
  · intro z
    exact zero_le_one
  · intro z hz
    have hg : (if Q (decode z) < B then (1:ℝ) else 0) = 1 := by simp [hz]
    show lo * (if Q (decode z) < B then (1:ℝ) else 0) ≤ (1:ℝ)
        ∧ (1:ℝ) ≤ hi * (if Q (decode z) < B then (1:ℝ) else 0)
    rw [hg]
    simp only [mul_one]
    exact ⟨hlo, hhi⟩
  · have hg0 : tailMass (fun z => if Q (decode z) < B then (1:ℝ) else 0) = 0 := by
      show (∑ z, (if Q (decode z) < B then (1:ℝ) else 0)
          * (if Q (decode z) < B then (0:ℝ) else 1)) = 0
      apply sum_eq_zero
      intro z _
      by_cases h : Q (decode z) < B <;> simp [h]
    have hw0 : 0 < tailMass (fun _ => (1:ℝ)) := by
      show 0 < ∑ z, (1:ℝ) * (if Q (decode z) < B then (0:ℝ) else 1)
      have hnn : ∀ z : BoxPair, 0 ≤ (1:ℝ) * (if Q (decode z) < B then (0:ℝ) else 1) := by
        intro z
        by_cases h : Q (decode z) < B <;> simp [h]
      refine sum_pos' (fun z _ => hnn z) ?_
      refine ⟨ONoneGeometry.liftPair zeroPair, mem_univ _, ?_⟩
      have hout : ¬ Q (decode (ONoneGeometry.liftPair zeroPair)) < B :=
        ONoneGeometry.liftPair_out_of_box zeroPair
      show (0:ℝ) < (1:ℝ) * (if Q (decode (ONoneGeometry.liftPair zeroPair)) < B
        then (0:ℝ) else 1)
      simp [hout]
    have hW0 : 0 < ∑ y : BoxPair, (1:ℝ) := by
      refine sum_pos' (fun z _ => zero_le_one) ?_
      exact ⟨zeroPair, mem_univ _, by norm_num⟩
    have hL : 0 < tailMass (fun _ => (1:ℝ)) / ∑ y : BoxPair, (1:ℝ) :=
      div_pos hw0 hW0
    intro hc
    rw [hg0, zero_div, mul_zero] at hc
    exact lt_irrefl 0 (lt_of_lt_of_le hL hc)

/-- The trap at the EXACT stage-1 margins: the tower/fiber-tilt bulk sandwich
alone does not control the miss numerator — the sandwich of `TowerWhole` must
cover the whole tail region. -/
theorem towerBulkOnly_tail_uncontrolled :
    ∃ (g w : BoxPair → ℝ), (∀ z, 0 ≤ g z) ∧ (∀ z, 0 ≤ w z)
      ∧ RegionSandwich towerLo towerHi g w (fun z => Q (decode z) < B)
      ∧ ¬ (tailMass w ≤ towerHi * tailMass g) :=
  bulkOnly_tail_uncontrolled
    (by norm_num [towerLo, Run2.T5ScalarMass.rowBudget])
    (by norm_num [towerHi, Run2.T5ScalarMass.rowBudget])

/-! ## 3. The stage margin table (exact-ℚ kernel arithmetic) -/

/-- Stage-3 margin (wrap/centering): the exact multiplicative factor at
`CenteringClosure.tauB = 2^-40`. -/
noncomputable def wrapFactor : ℝ :=
  (1 + (CenteringClosure.tauB : ℝ)) / (1 - (CenteringClosure.tauB : ℝ))

/-- Stage-4 margin (box truncation): the exact multiplicative factor at
`CenteringClosure.boxB = 1e-1000`. -/
noncomputable def boxFactor : ℝ := 1 / (1 - (CenteringClosure.boxB : ℝ))

/-- Exact margin table: the candidate composite is EXACTLY the product of the
four recorded stage margins. -/
theorem attemptFactor_eq :
    attemptFactor = machineMargin * towerMargin * wrapFactor * boxFactor := by
  rfl

/-- Stage 1 margin (CONSUMED, not re-proved): `towerMargin < 1 + 2^-43`. -/
theorem stage_tower_lt : towerMargin < 1 + 1 / 8796093022208 :=
  SignLayerSupport.towerMargin_lt

/-- Stage 2 margin (CONSUMED, not re-proved): `machineMargin < 1 + 2^-42`. -/
theorem stage_machine_lt : machineMargin < 1 + 1 / 4398046511104 :=
  SignLayerSupport.machineMargin_lt

/-- Stage 3 margin (exact-ℚ): `wrapFactor < 1 + 1/(2^39 - 1)`
(`(1+tauB)/(1-tauB) = 1 + 2^-39/(1-2^-40)`). -/
theorem stage_wrap_lt : wrapFactor < 1 + 1 / 549755813887 := by
  norm_num [wrapFactor, CenteringClosure.tauB]

/-- Stage 4 margin (exact-ℚ): `boxFactor < 1 + 10^-30` — at the recorded
`boxB = 1e-1000` this keeps enormous slack; the EXACT margin consumed by the
chain stays `1/(1-boxB)`. -/
theorem stage_box_lt : boxFactor < 1 + 1 / 10^30 := by
  norm_num [boxFactor, CenteringClosure.boxB]

theorem wrapFactor_one_le : 1 ≤ wrapFactor := by
  norm_num [wrapFactor, CenteringClosure.tauB]

theorem boxFactor_one_le : 1 ≤ boxFactor := by
  norm_num [boxFactor, CenteringClosure.boxB]

/-- THE margin composition (kernel, exact-ℚ in the `norm_num` style of
`CenteringClosure`): the product of the four recorded stage margins is below
`1 + 2^-38` — composed FROM the stage table above (stage 1 `2^-43`, stage 2
`2^-42`, stage 3 `1/(2^39-1)`, stage 4 `10^-30`), not by re-expanding the
composite. -/
theorem attemptFactor_comp_lt : attemptFactor < 1 + 1 / 274877906944 := by
  have hm : machineMargin ≤ 1 + 1 / 4398046511104 := stage_machine_lt.le
  have ht : towerMargin ≤ 1 + 1 / 8796093022208 := stage_tower_lt.le
  have hwr : wrapFactor ≤ 1 + 1 / 549755813887 := stage_wrap_lt.le
  have hbx : boxFactor ≤ 1 + 1 / 10^30 := stage_box_lt.le
  have hNm : 0 ≤ machineMargin := zero_le_one.trans machineMargin_one_le
  have hNt : 0 ≤ towerMargin := zero_le_one.trans towerMargin_one_le
  have hNw : 0 ≤ wrapFactor := zero_le_one.trans wrapFactor_one_le
  have hNb : 0 ≤ boxFactor := zero_le_one.trans boxFactor_one_le
  have hEb : (0:ℝ) ≤ 1 + 1 / 4398046511104 := by norm_num
  have hE12 : (0:ℝ) ≤ (1 + 1 / 4398046511104) * (1 + 1 / 8796093022208) := by norm_num
  have hE123 : (0:ℝ) ≤ (1 + 1 / 4398046511104) * (1 + 1 / 8796093022208)
      * (1 + 1 / 549755813887) := by norm_num
  have hprod12 : machineMargin * towerMargin
      ≤ (1 + 1 / 4398046511104) * (1 + 1 / 8796093022208) :=
    mul_le_mul hm ht hNt hEb
  have hprod123 : machineMargin * towerMargin * wrapFactor
      ≤ (1 + 1 / 4398046511104) * (1 + 1 / 8796093022208) * (1 + 1 / 549755813887) :=
    mul_le_mul hprod12 hwr hNw hE12
  have hprod : machineMargin * towerMargin * wrapFactor * boxFactor
      ≤ (1 + 1 / 4398046511104) * (1 + 1 / 8796093022208) * (1 + 1 / 549755813887)
        * (1 + 1 / 10^30) :=
    mul_le_mul hprod123 hbx hNb hE123
  have hnum : ((1 + 1 / 4398046511104) * (1 + 1 / 8796093022208) * (1 + 1 / 549755813887)
      * (1 + 1 / 10^30) : ℝ) < 1 + 1 / 274877906944 := by
    norm_num
  rw [attemptFactor_eq]
  exact lt_of_le_of_lt hprod hnum

/-- Layer-2 factor at the composed margin (CONSUMED): `e2 attemptFactor <
2^-32` — `SignLayerSupport.e2_attemptFactor_lt`, `e2 k = (k^16)^2 - 1 = k^32-1`. -/
theorem e2_comp_lt : SignLayerSupport.e2 attemptFactor < 1 / 4294967296 :=
  SignLayerSupport.e2_attemptFactor_lt

/-- Cross-check of the table against the composite expansion (CONSUMED):
`attemptFactor < 1 + 2^-38` at the expanded literal product — the independent
kernel path of `SignLayerSupport.attemptFactor_lt`. -/
theorem attemptFactor_expanded_lt : attemptFactor < 1 + 1 / 274877906944 :=
  SignLayerSupport.attemptFactor_lt

/-! ## 4. Which attempt shape the transport proves — and the delta -/

/-- ACCEPTANCE-CONDITIONED realization (draw-until-short WITHIN one attempt):
the realized weights truncated to the in-box region — the norm gate is passed
before the candidate enters the attempt law, so the attempt never misses at
`none`. The four-stage transport of Part 0 proves the UNCONDITIONED
sample-then-check shape (over the full `w`); this truncation is the exact
shape delta of the recorded trap. -/
noncomputable def attemptCondWeights (w : BoxPair → ℝ) : BoxPair → ℝ :=
  fun z => if Q (decode z) < B then w z else 0

theorem attemptCondWeights_nonneg {w : BoxPair → ℝ} (hw : ∀ z, 0 ≤ w z) (z : BoxPair) :
    0 ≤ attemptCondWeights w z := by
  unfold attemptCondWeights
  by_cases h : Q (decode z) < B <;> simp [h, hw]

theorem attemptCondWeights_bulk (w : BoxPair → ℝ) (z : BoxPair) (hz : Q (decode z) < B) :
    attemptCondWeights w z = w z := by
  unfold attemptCondWeights
  simp [hz]

/-- The conditioned shape has ZERO tail mass — its whole tail region is gone,
which is exactly why the tail sandwich of `TowerWhole` cannot transport
through it (cf. `bulkOnly_tail_uncontrolled`). -/
theorem attemptCondWeights_tailMass (w : BoxPair → ℝ) :
    tailMass (attemptCondWeights w) = 0 := by
  simp only [tailMass, attemptCondWeights]
  apply sum_eq_zero
  intro z _
  by_cases h : Q (decode z) < B <;> simp [h]

theorem bulkMass_attemptCondWeights (w : BoxPair → ℝ) :
    bulkMass (attemptCondWeights w) = bulkMass w := by
  simp only [bulkMass, attemptCondWeights]
  apply sum_congr rfl
  intro z _
  by_cases h : Q (decode z) < B <;> simp [h]

theorem sum_attemptCondWeights (w : BoxPair → ℝ) :
    ∑ y, attemptCondWeights w y = bulkMass w := by
  rw [bulk_add_tail, attemptCondWeights_tailMass, bulkMass_attemptCondWeights, add_zero]

/-- The conditioned-shape residual denominator `1 - rejB` as a named `ℝ`
constant — keeps the `Rat.cast` of the `CenteringClosure.rejB` literal out of
unification paths (same toolchain reason as the literal defs of
`CenteringClosure`). -/
noncomputable def rejComp : ℝ := 1 - (CenteringClosure.rejB : ℝ)

theorem rejComp_pos : 0 < rejComp := by
  norm_num [rejComp, CenteringClosure.rejB]

/-- THE delta of the acceptance-conditioned shape (weight level): with only the
BULK sandwich `lo * g ≤ w ≤ hi * g` on the in-box region, plus the honest miss
budget `tailMass g ≤ rejB * ∑ g`, the some-side normalized comparison carries
EXACTLY the extra factor `1/(1-rejB)` — `rejB` moves INSIDE the multiplicative
accounting. -/
theorem conditioned_ratio_le {lo hi : ℝ} {g w : BoxPair → ℝ}
    (hg : ∀ z, 0 ≤ g z) (hlo : 0 < lo) (hle : lo ≤ hi)
    (hbulk : RegionSandwich lo hi g w (fun z => Q (decode z) < B))
    (hGb : 0 < bulkMass g)
    (hmiss : tailMass g ≤ (CenteringClosure.rejB : ℝ) * ∑ y, g y) (z : BoxPair) :
    attemptCondWeights w z / ∑ y, attemptCondWeights w y
      ≤ (hi / lo) / rejComp * (g z / ∑ y, g y) := by
  have hGt : 0 ≤ tailMass g := tailMass_nonneg g hg
  have hSg : ∑ y, g y = bulkMass g + tailMass g := bulk_add_tail g
  have hG : 0 < ∑ y, g y := by nlinarith
  have hWb : lo * bulkMass g ≤ bulkMass w := (sandwich_bulkMass hbulk).1
  have hWb2 : bulkMass w ≤ hi * bulkMass g := (sandwich_bulkMass hbulk).2
  have hW : 0 < ∑ y, attemptCondWeights w y := by
    rw [sum_attemptCondWeights]
    exact lt_of_lt_of_le (mul_pos hlo hGb) hWb
  have hrejEq : rejComp = 1 - (CenteringClosure.rejB : ℝ) := rfl
  have hGb' : rejComp * ∑ y, g y ≤ bulkMass g := by nlinarith [hrejEq]
  have h1rb : 0 < rejComp := rejComp_pos
  have hhi : 0 ≤ hi := le_trans (le_of_lt hlo) hle
  by_cases hz : Q (decode z) < B
  · have hwb : attemptCondWeights w z = w z := attemptCondWeights_bulk w z hz
    rw [hwb]
    have hwz := (hbulk z hz).2
    have hstep1 : w z / ∑ y, attemptCondWeights w y
        ≤ hi * g z / ∑ y, attemptCondWeights w y :=
      div_le_div_of_nonneg_right hwz (le_of_lt hW)
    have hstep2 : hi * g z / ∑ y, attemptCondWeights w y
        ≤ hi * g z / (lo * bulkMass g) := by
      rw [sum_attemptCondWeights]
      exact div_le_div_of_nonneg_left (mul_nonneg hhi (hg z)) (mul_pos hlo hGb) hWb
    have hstep3 : hi * g z / (lo * bulkMass g) = (hi / lo) * (g z / bulkMass g) := by
      field_simp [ne_of_gt hlo, ne_of_gt hGb]
    have hstep4a : g z / bulkMass g
        ≤ g z / (rejComp * ∑ y, g y) :=
      div_le_div_of_nonneg_left (hg z) (mul_pos h1rb hG) hGb'
    have hhl : 0 ≤ hi / lo := by positivity
    have hstep4 : (hi / lo) * (g z / bulkMass g)
        ≤ (hi / lo) * (g z / (rejComp * ∑ y, g y)) :=
      mul_le_mul_of_nonneg_left hstep4a hhl
    have hstep5 : (hi / lo) * (g z / (rejComp * ∑ y, g y))
        = (hi / lo) / rejComp * (g z / ∑ y, g y) := by
      field_simp [ne_of_gt h1rb, ne_of_gt hG, ne_of_gt hlo]
    calc w z / ∑ y, attemptCondWeights w y
          ≤ hi * g z / ∑ y, attemptCondWeights w y := hstep1
      _ ≤ hi * g z / (lo * bulkMass g) := hstep2
      _ = (hi / lo) * (g z / bulkMass g) := hstep3
      _ ≤ (hi / lo) * (g z / (rejComp * ∑ y, g y)) := hstep4
      _ = (hi / lo) / rejComp * (g z / ∑ y, g y) := hstep5
  · have hwb : attemptCondWeights w z = 0 := by
      unfold attemptCondWeights
      simp [hz]
    rw [hwb, zero_div]
    have hfac : 0 ≤ (hi / lo) / rejComp :=
      div_nonneg (div_nonneg hhi (le_of_lt hlo)) (le_of_lt h1rb)
    exact mul_nonneg hfac (div_nonneg (hg z) (le_of_lt hG))

/-- THE delta at the law level: the acceptance-conditioned attempt law
(`attemptOf` over the truncated weights) satisfies the one-attempt comparison
at `k = (hi/lo) / (1-rejB)` on every point — the `1/(1-rejB)` factor of the
recorded shape trap, in BOTH directions of the `Option` space (the miss point
is `0` for this shape). -/
theorem conditioned_attemptOf_le {lo hi : ℝ} {g w : BoxPair → ℝ}
    (hg : ∀ z, 0 ≤ g z) (hw : ∀ z, 0 ≤ w z) (hlo : 0 < lo) (hle : lo ≤ hi)
    (hbulk : RegionSandwich lo hi g w (fun z => Q (decode z) < B))
    (hGb : 0 < bulkMass g)
    (hmiss : tailMass g ≤ (CenteringClosure.rejB : ℝ) * ∑ y, g y) (o : Option BoxPair) :
    (attemptOf (attemptCondWeights w) (attemptCondWeights_nonneg hw)).mass o
      ≤ ((hi / lo) / rejComp) * (attemptOf g hg).mass o := by
  have hGt : 0 ≤ tailMass g := tailMass_nonneg g hg
  have hSg : ∑ y, g y = bulkMass g + tailMass g := bulk_add_tail g
  have hG : 0 < ∑ y, g y := by nlinarith
  have hW : 0 < ∑ y, attemptCondWeights w y := by
    rw [sum_attemptCondWeights]
    exact lt_of_lt_of_le (mul_pos hlo hGb) (sandwich_bulkMass hbulk).1
  have hhi : 0 ≤ hi := le_trans (le_of_lt hlo) hle
  have h1rb : 0 < rejComp := rejComp_pos
  have hnfac : 0 ≤ (hi / lo) / rejComp :=
    div_nonneg (div_nonneg hhi (le_of_lt hlo)) (le_of_lt h1rb)
  cases o with
  | some z =>
    rw [attemptOf_some (attemptCondWeights w) (attemptCondWeights_nonneg hw) hW z,
      attemptOf_some g hg hG z]
    by_cases hz : Q (decode z) < B
    · have keyL : (if Q (decode z) < B then attemptCondWeights w z else 0)
          = attemptCondWeights w z := by simp [hz]
      have keyR : (if Q (decode z) < B then g z else 0) = g z := by simp [hz]
      rw [keyL, keyR]
      exact conditioned_ratio_le hg hlo hle hbulk hGb hmiss z
    · have keyL : (if Q (decode z) < B then attemptCondWeights w z else 0) = 0 := by simp [hz]
      have keyR : (if Q (decode z) < B then g z else 0) = 0 := by simp [hz]
      rw [keyL, keyR]
      simp
  | none =>
    rw [attemptOf_none (attemptCondWeights w) (attemptCondWeights_nonneg hw),
      attemptOf_none g hg]
    have hif : (if 0 < ∑ z, attemptCondWeights w z
        then tailMass (attemptCondWeights w) / ∑ y, attemptCondWeights w y
        else (1:ℝ)) = 0 := by
      rw [attemptCondWeights_tailMass]
      simp [hW]
    rw [hif]
    have hgn : (0:ℝ) ≤ (if 0 < ∑ z, g z then tailMass g / ∑ y, g y else (1:ℝ)) := by
      rw [← attemptOf_none g hg]
      exact (attemptOf g hg).nonneg none
    exact mul_nonneg hnfac hgn

/-- Numeric delta of the conditioned shape: the inside factor
`attemptFactor/(1-rejB)` stays below `1 + 2^-23` (vs `1 + 2^-38` for the
unconditioned shape). -/
noncomputable def conditionedFactor : ℝ := attemptFactor / rejComp

theorem conditionedFactor_one_le : 1 ≤ conditionedFactor := by
  have h : (1:ℝ) - (CenteringClosure.rejB : ℝ) ≤ attemptFactor := by
    have h2 : (0:ℝ) ≤ (CenteringClosure.rejB : ℝ) := by norm_num [CenteringClosure.rejB]
    have h3 := SignLayerSupport.attemptFactor_one_le
    linarith
  show 1 ≤ attemptFactor / rejComp
  rw [le_div_iff₀ rejComp_pos, one_mul]
  exact h

theorem conditionedFactor_lt : conditionedFactor < 1 + 1 / 8388608 := by
  have h2 : conditionedFactor ≤ (1 + 1 / 274877906944) / rejComp := by
    show attemptFactor / rejComp ≤ (1 + 1 / 274877906944) / rejComp
    exact div_le_div_of_nonneg_right SignLayerSupport.attemptFactor_lt.le
      (le_of_lt rejComp_pos)
  have h3 : ((1 + 1 / 274877906944 : ℝ) / rejComp) < 1 + 1 / 8388608 := by
    norm_num [rejComp, CenteringClosure.rejB]
  exact lt_of_le_of_lt h2 h3

/-- Numeric delta at the Layer-2 factor (kernel-checked): `e2
conditionedFactor < 2^-17` (the analytic scale is `~ 2^-19`; the `1+2na`
budget step of `pow_succ_le_real` keeps the recorded slack). -/
theorem e2_conditionedFactor_lt : SignLayerSupport.e2 conditionedFactor < 1 / 131072 := by
  show (conditionedFactor ^ 16) ^ 2 - 1 < 1 / 131072
  have hlt : conditionedFactor - 1 < 1 / 8388608 := by
    have := conditionedFactor_lt
    linarith
  have ha : 0 ≤ conditionedFactor - 1 := by
    have := conditionedFactor_one_le
    linarith
  have h32 : 2 * (32:ℝ) * (conditionedFactor - 1) ≤ 1 := by
    have hle : (2:ℝ) * 32 * (1 / 8388608) ≤ 1 := by norm_num
    nlinarith
  have hle := SignLayerSupport.pow_succ_le_real (conditionedFactor - 1) ha 32 h32
  have hle' : (1 + (conditionedFactor - 1)) ^ 32 - 1
      ≤ 2 * (32:ℝ) * (conditionedFactor - 1) := by
    have := hle
    push_cast at this
    nlinarith
  have hrew : (1 + (conditionedFactor - 1)) ^ 32 = (conditionedFactor ^ 16) ^ 2 := by
    have h1 : (1:ℝ) + (conditionedFactor - 1) = conditionedFactor := by ring
    rw [h1, ← pow_mul]
  rw [← hrew]
  have hz : (2:ℝ) * 32 * (conditionedFactor - 1) < 2 * 32 * (1 / 8388608) :=
    mul_lt_mul_of_pos_left hlt (by norm_num)
  have hc : (2:ℝ) * 32 * (1 / 8388608) = 1 / 131072 := by norm_num
  nlinarith

/-- THE conditioned-shape transport (kernel): from the four-stage chain — used
through its BULK part only — plus the honest miss budget `rejB`, the
acceptance-conditioned attempt law satisfies the one-attempt comparison at
`conditionedFactor = attemptFactor/(1-rejB)`. The unconditioned shape of
Part 0 keeps `rejB` OUTSIDE; for this shape `rejB` is INSIDE. -/
theorem attemptPointwise_of_conditionedChain {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    (cw : AttemptWeights A c w)
    (hshape : AttemptShape jT (attemptCondWeights w)
      (attemptCondWeights_nonneg (attemptWeights_nonneg cw)))
    (hFib : 0 < bulkMass (fiberWeight A c))
    (hmiss : tailMass (fiberWeight A c)
      ≤ (CenteringClosure.rejB : ℝ) * ∑ y, fiberWeight A c y) :
    AttemptPointwise jT A c conditionedFactor := by
  have hw := attemptWeights_nonneg cw
  have hS := attemptWeights_sandwich cw
  have hbulk : RegionSandwich chainLo chainHi (fiberWeight A c) w (fun z => Q (decode z) < B) :=
    regionSandwich_of_sandwich hS _
  have hchain : AttemptPointwise jT A c (chainHi / chainLo / rejComp) := by
    have hdelta := conditioned_attemptOf_le (fun z => fiberWeight_nonneg A c z) hw
      chain_pos chain_le hbulk hFib hmiss
    have hnone : jT.mass none
        ≤ (chainHi / chainLo / rejComp) * (trial A c).mass none := by
      rw [hshape none, ← trial_eq_attemptOf A c]
      exact hdelta none
    refine ⟨fun z => ?_, hnone⟩
    rw [hshape (some z), ← trial_eq_attemptOf A c]
    exact hdelta (some z)
  rw [chain_ratio] at hchain
  exact hchain

/-- THE conditioned-shape deliverable (numeric, kernel-checked): under the
conditioned attempt shape the reply law satisfies `second < 1 + 2^-17` — the
delta against the unconditioned `1 + 2^-32` of `layer2_of_stageChain`, with
`rejB` moved INSIDE the multiplicative factor. -/
theorem layer2_e2_conditioned {j : Law (Option BoxVec)} {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq} {w : BoxPair → ℝ}
    (cw : AttemptWeights A c w)
    (hshapeR : ReplyShape j jT)
    (hshape : AttemptShape jT (attemptCondWeights w)
      (attemptCondWeights_nonneg (attemptWeights_nonneg cw)))
    (hFib : 0 < bulkMass (fiberWeight A c))
    (hmiss : tailMass (fiberWeight A c)
      ≤ (CenteringClosure.rejB : ℝ) * ∑ y, fiberWeight A c y) :
    Divergence.AC j (signBody A c) ∧
      Divergence.second j (signBody A c) < 1 + 1 / 131072 := by
  obtain ⟨hac, hse⟩ := layer2_of_obligations j jT A c conditionedFactor
    conditionedFactor_one_le hshapeR
    (attemptPointwise_of_conditionedChain cw hshape hFib hmiss)
  refine ⟨hac, ?_⟩
  have hnum := e2_conditionedFactor_lt
  linarith

end FT1536.AttemptWeights
