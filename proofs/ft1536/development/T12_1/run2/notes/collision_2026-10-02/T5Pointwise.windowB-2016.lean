import AttemptWeights
import CenteringClosure
import Run2.T5ScalarMass

/-! # T5Pointwise — the POINTWISE form of the four stage sandwiches

Window `notes/PROMPT_T5_POINTWISE.md`: the T5/REFINE material's current bounds
are TOTAL-mass sandwiches (`Run2.TriangularGaussian.triangular_mass_bounds`,
`Run2.ShiftedGaussian.shifted_mass_bounds`,
`Run2.T5ScalarMass.uniform_shifted_mass_3072`,
`ConvStruct.a2Tower_mass_bounds`, `PerKeyTransport.perKey_mass_bounds` — all
`total`/`scale` whole-space sums through the Poisson /
`Run2.ShiftedGaussian.dual_series_deviation` route), while `AttemptWeights`
needs POINTWISE multiplicative sandwiches on the realized weights per point,
INCLUDING the tail region (`AttemptWeights.bulkOnly_tail_uncontrolled` /
`bulkOnly_normalized_tail_uncontrolled` forbid bulk-only control). Scope of THIS
module (all kernel-checked; every numeric budget is CONSUMED, nothing rebuilt):

1. **The pointwise row road (defs first)** — `RowFactors`/`RowSandwichOn`
   (per-row pointwise factors + per-row pointwise sandwiches) and their
   composition `rowProduct_sandwich_at`/`rowProduct_sandwich`: a product over
   rows of per-row pointwise sandwiches is a per-point sandwich at the PRODUCT
   margins. This is the precise road: per-ROW multiplicative ratios compose to
   per-POINT factors.
2. **Stage 1 `TowerWhole`** — `TowerRowRoad` (the exact pointwise
   strengthening: fiber support + row factorization of `gaussianWeight` +
   per-row pointwise sandwiches at per-row budgets fitting the RECORDED margins
   `towerLo`/`towerHi`) re-shapes to `AttemptWeights.TowerWhole`
   (`towerWhole_of_rowRoad`); `towerWhole_iff` splits the interface exactly into
   fiber support + the on-fiber sandwich (kernel: the pointwise shape FORCES
   exact fiber support of the realized target). Margin arithmetic (kernel):
   the recorded margins are EXACTLY the 2-row product at full `rowBudget`
   (`tower_margin_row2`); a 3072-row product fits at per-row `2^-58`-class
   budgets (`road_fit_3072_rows`) but full `rowBudget` per row over 3072 rows
   BUSTS the whole composite budget (`rowwise_fullBudget_busts`).
3. **Stage 2 `MachineStage`** — the `20/11` shape of the conservative H3 error
   contract (`CenteringClosure.t5lo = t5minus^20/t5plus^11` — the
   `sage/t5_conservative_margin.sage` line `lo=minus^20/plus^11`) is literally a
   product of per-op relative rounding factors; `t5lo_factorization`/
   `t5hi_factorization` pin the endpoints and `machineStage_of_evalRoad`
   re-shapes the per-op transport onto `AttemptWeights.MachineStage` at the
   CONSUMED margin (`SignLayerSupport.machineMargin_lt < 1 + 2^-42`). The
   additive `CenteringClosure.cmul`/`sErr` chains are pointwise ABSOLUTE error
   transports (machine word → value) and do NOT restate multiplicatively
   without a mass floor — kernel counterexample
   `additiveError_no_machineStage` (the "dividing by the mass" trap).
4. **Stage 3 `WrapStage`** — `WrapCoordRoad` (per-coordinate wrap/centering
   distortion factors at `wrapA = CenteringClosure.t5a`) composes over
   `Fin 1536` coordinates to the recorded `(1 ± tauB)` sandwich
   (`wrapStage_of_coordRoad`), consuming the numeric envelope
   `CenteringClosure.tau_budget : (1+t5a)^1536 - 1 < tauB`.
5. **Stage 4 `BoxStage`** — `BoxRetentionRoad` (box truncation as a UNIFORM
   rescaling at whole-space retention `rho ∈ [1-boxB, 1]` — bulk AND tail
   together, per the counter-theorems) re-shapes to `AttemptWeights.BoxStage`
   (`boxStage_of_retention`); numeric margin CONSUMED
   (`AttemptWeights.stage_box_lt : boxFactor < 1 + 1e-30`).
6. **The last plug for `hattempt`** — `PointwiseStageRoad` bundles exactly the
   four pointwise strengthenings with their intended types;
   `stageChain_of_stageRoad`/`attemptWeights_of_stageRoad` deliver
   `AttemptPointwise.AttemptWeights A c w` from them and
   `layer2_of_stageRoad` closes `Divergence.second j (signBody A c) < 1+2^-32`
   through `AttemptWeights.layer2_of_stageChain`.

## Honest boundaries (recorded, not papered over)

- The realized weights `target`/`mach`/`wrapS`/`w` stay ABSTRACT function
  arguments (the `AttemptWeights` interface shape of
  `notes/B4_ATTEMPT_WEIGHTS_WORK_STATE.md`); their DEFINITION and the
  `S.code`/`do_sign` binding (B1/source3) are the deliverers of the four road
  fields. No guessed sampler definition occurs in this module.
- The T5/REFINE toolkit contains NO per-point inequality on the primal side —
  its per-point statements are IDENTITIES (`GramLDL.gaussian_tower_atom`,
  `ConvStruct.a2Tower_atom`, `GramLDL.block_split`,
  `GramLDL.a2_scalar_split`) and its inequalities are TOTAL-mass (row sums of
  `Run2.ShiftedGaussian.shiftedMass` vs `continuousMass` via the dual series;
  `Run2.TriangularGaussian.LocalExponent` /
  `Run2.T5ScalarMass.local_exponents` give per-row DUAL decay ratios
  `rowRatio = 2^-48`, i.e. row-MASS control — not primal per-point ratios).
  Every per-point inequality therefore arrives as the recorded strengthenings;
  nothing here is derived "by dividing by the mass".
- The additive-error caveat of `notes/B4_SYNTHESIS.md` is kept: additive
  machinery (`Adv_PRG`, byte bridges, `cmul`/`sErr` absolute chains) stays OUT
  of the multiplicative shape without a mass floor — as a kernel counterexample
  here, not a footnote.
- `Run2.T5ScalarMass.scalar_power_margins` composes 3072 row budgets to
  `massBudget = 2^-34` TOTAL-mass — consistent with
  `rowwise_fullBudget_busts`: full-rowBudget row products give `2^-34`-class,
  NOT the recorded `1+2^-43`-class pointwise margins.

Pinned citations (module + name, consumed not rebuilt): `AttemptWeights`
(`TowerWhole`, `MachineStage`, `WrapStage`, `BoxStage`,
`attemptWeights_of_stages`, `layer2_of_stageChain`, `bulkOnly_tail_uncontrolled`,
`stage_box_lt`), `AttemptPointwise` (`Sandwich`, `sandwich_comp`, `towerLo`,
`towerHi`, `AttemptWeights`, `AttemptShape`, `fiberWeight_nonneg`,
`chain_tower_nonneg`), `SignLayerSupport` (`ReplyShape`, `machineMargin_lt`,
`attemptFactor_lt`, `e2`, `pow_succ_le_real`), `CenteringClosure` (`u`, `eps`,
`cmul`, `sErr`, `t5lo`, `t5hi`, `t5minus`, `t5plus`, `t5y`, `t5a`,
`tau_budget`, `tauB`, `boxB`, `rejB`, `t5_g00_bound`, `t5_leaf_floor_gt`),
`Run2.T5ScalarMass` (`rowRatio`, `rowBudget`, `massBudget`, `local_exponents`,
`CoefficientRange`, `dimension_margins`, `scalar_power_margins`,
`uniform_shifted_mass_3072`), `Run2.TriangularGaussian`
(`triangular_mass_bounds`, `atom`, `LocalExponent`),
`Run2.ShiftedGaussian` (`shifted_mass_bounds`, `dual_series_deviation`,
`dual_tail_majorant`), `Run2.A2Theta`, `ConvStruct.a2Tower_atom`,
`ConvStruct.a2Tower_mass_bounds`, `GramLDL.gaussian_tower_atom`,
`GramLDL.block_split`, `PerKeyTransport.perKey_mass_bounds`,
`PerKeyTransport.perKey_fiber_reindex`, `PerKeyTransport.two_mul_len`,
`FT1536.PublicSimulation.fiberWeight`, `FT1536.PublicSimulation.gaussianWeight`.

No unfinished-proof markers; standard axioms only.
-/

namespace FT1536.T5Pointwise
set_option maxRecDepth 8192
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry FT1536.SignLayerSupport
  FT1536.AttemptPointwise FT1536.AttemptWeights

/-! ## 0. Named real envelopes of the consumed machine budgets

Named `ℝ` wrappers around the `CenteringClosure` ℚ literals — keeps `Rat.cast`
unification shallow (toolchain lesson of
`notes/B4_ATTEMPT_WEIGHTS_WORK_STATE.md` §6). No numeric content hidden. -/

/-- Machine relative-rounding unit of the H3 error contract (`CenteringClosure.u = 2^-48`). -/
noncomputable def roundU : ℝ := (CenteringClosure.u : ℝ)

/-- Per-coordinate wrap distortion budget (`CenteringClosure.t5a = 6y/(1-y)^2`, `y = 2^-65`). -/
noncomputable def wrapA : ℝ := (CenteringClosure.t5a : ℝ)

/-- Wrap/centering budget (`CenteringClosure.tauB = 2^-40`). -/
noncomputable def wrapT : ℝ := (CenteringClosure.tauB : ℝ)

/-- Box-truncation budget (`CenteringClosure.boxB = 1e-1000`). -/
noncomputable def boxR : ℝ := (CenteringClosure.boxB : ℝ)

theorem roundU_pos : 0 < roundU := by
  norm_num [roundU, CenteringClosure.u]

theorem one_sub_roundU_pos : 0 < 1 - roundU := by
  norm_num [roundU, CenteringClosure.u]

theorem one_add_roundU_pos : 0 < 1 + roundU := add_pos one_pos roundU_pos

theorem one_add_roundU_inv_pos : 0 < (1 + roundU)⁻¹ := inv_pos.mpr one_add_roundU_pos

theorem wrapA_pos : 0 < 1 + wrapA := by
  norm_num [wrapA, CenteringClosure.t5a, CenteringClosure.t5y]

theorem wrapA_inv_pos : 0 < (1 + wrapA)⁻¹ := inv_pos.mpr wrapA_pos

theorem wrapT_bounds : 0 < 1 - wrapT ∧ 0 < 1 + wrapT := by
  norm_num [wrapT, CenteringClosure.tauB]

theorem boxR_sub_pos : 0 < 1 - boxR := by
  norm_num [boxR, CenteringClosure.boxB]

/-- The pinned ideal per-point weight (`PublicSimulation.gaussianWeight`) is
strictly positive at every candidate. -/
theorem gaussianWeight_pos (z : BoxPair) : 0 < gaussianWeight z := by
  show 0 < Real.exp _
  exact Real.exp_pos _

theorem gaussianWeight_nonneg (z : BoxPair) : 0 ≤ gaussianWeight z :=
  (gaussianWeight_pos z).le

/-- A sandwich widens monotonically in both margins (for a nonnegative
reference system). -/
theorem sandwich_weaken {lo hi lo' hi' : ℝ} {g w : BoxPair → ℝ}
    (hlo : lo' ≤ lo) (hhi : hi ≤ hi') (hg : ∀ z, 0 ≤ g z)
    (hS : Sandwich lo hi g w) : Sandwich lo' hi' g w := by
  intro z
  obtain ⟨hl, hu⟩ := hS z
  constructor
  · calc lo' * g z ≤ lo * g z := mul_le_mul_of_nonneg_right hlo (hg z)
      _ ≤ w z := hl
  · calc w z ≤ hi * g z := hu
      _ ≤ hi' * g z := mul_le_mul_of_nonneg_right hhi (hg z)

theorem prod_const_fin {n : ℕ} (c : ℝ) : (∏ _i : Fin n, c) = c ^ n := by
  rw [Finset.prod_const, Finset.card_fin]

/-! ## 1. The pointwise row road (defs first) -/

/-- **The per-ROW pointwise factorization (road, defs first)**: a weight system
is the product over its rows of per-row factors AT EVERY POINT. The rows of the
pinned ideal weight are the tower rows of the T5/REFINE material:
`gaussianWeight` factors per coefficient pair (`GramLDL.block_split` +
`GramLDL.gaussian_tower_atom`, `ConvStruct.a2Tower_atom` — per-point
identities), each pair into its 2 scalar rows of `Run2.TriangularGaussian.Tower`. -/
def RowFactors {n : ℕ} (w : BoxPair → ℝ) (rows : Fin n → BoxPair → ℝ) : Prop :=
  ∀ z : BoxPair, w z = ∏ i : Fin n, rows i z

/-- **The per-ROW pointwise sandwich (road, defs first)**: row `i`'s realized
factor sits within `(1 ± b i)` of the exact row factor AT EVERY POINT of the
region `R` (the whole region includes the tail — required by the `bulkOnly_*`
counter-theorems). This is the EXACT pointwise strengthening the total-mass
bounds do not provide. -/
def RowSandwichOn {n : ℕ} (R : BoxPair → Prop) (b : Fin n → ℝ)
    (exactRows realRows : Fin n → BoxPair → ℝ) : Prop :=
  ∀ (i : Fin n) (z : BoxPair), R z →
    (1 - b i) * exactRows i z ≤ realRows i z ∧ realRows i z ≤ (1 + b i) * exactRows i z

/-- THE row composition (pointwise core of the road): per-row pointwise
sandwiches at per-row budgets compose to the per-point sandwich at the PRODUCT
margins — one point, no mass, no division, no averaging. -/
theorem rowProduct_sandwich_at {n : ℕ} {exactRows realRows : Fin n → BoxPair → ℝ}
    {lo hi : Fin n → ℝ} (z : BoxPair)
    (hRS : ∀ i : Fin n, lo i * exactRows i z ≤ realRows i z
        ∧ realRows i z ≤ hi i * exactRows i z)
    (hlo : ∀ i : Fin n, 0 ≤ lo i) (hgn : ∀ i : Fin n, 0 ≤ exactRows i z) :
    (∏ i : Fin n, lo i) * (∏ i : Fin n, exactRows i z) ≤ ∏ i : Fin n, realRows i z
      ∧ (∏ i : Fin n, realRows i z)
          ≤ (∏ i : Fin n, hi i) * (∏ i : Fin n, exactRows i z) := by
  constructor
  · have h1 : (∏ i : Fin n, lo i) * (∏ i : Fin n, exactRows i z)
        = ∏ i : Fin n, lo i * exactRows i z :=
      (Finset.prod_mul_distrib univ (fun i : Fin n => lo i)
        (fun i : Fin n => exactRows i z)).symm
    rw [h1]
    exact Finset.prod_le_prod (fun i _ => mul_nonneg (hlo i) (hgn i))
      (fun i _ => (hRS i).1)
  · have h1 : (∏ i : Fin n, hi i) * (∏ i : Fin n, exactRows i z)
        = ∏ i : Fin n, hi i * exactRows i z :=
      Finset.prod_mul_distrib univ (fun i : Fin n => hi i)
        (fun i : Fin n => exactRows i z)
    rw [h1]
    exact Finset.prod_le_prod
      (fun i _ => le_trans (mul_nonneg (hlo i) (hgn i)) ((hRS i).1))
      (fun i _ => (hRS i).2)

/-- Global form of the row composition: full-system factorizations + per-row
pointwise sandwiches give the whole-space `Sandwich` at the product margins. -/
theorem rowProduct_sandwich {n : ℕ} {g w : BoxPair → ℝ}
    {exactRows realRows : Fin n → BoxPair → ℝ} {lo hi : Fin n → ℝ}
    (hFg : RowFactors g exactRows) (hFw : RowFactors w realRows)
    (hRS : RowSandwichOn (fun _ => True) lo exactRows realRows)
    (hlo : ∀ i : Fin n, 0 ≤ lo i) (hgn : ∀ i z, 0 ≤ exactRows i z) :
    Sandwich (∏ i : Fin n, lo i) (∏ i : Fin n, hi i) g w := by
  intro z
  have hpt : ∀ i : Fin n, lo i * exactRows i z ≤ realRows i z
      ∧ realRows i z ≤ hi i * exactRows i z :=
    fun i => hRS i z trivial
  obtain ⟨hl, hu⟩ := rowProduct_sandwich_at z hpt hlo (fun i => hgn i z)
  constructor
  · calc (∏ i : Fin n, lo i) * g z
        = (∏ i : Fin n, lo i) * (∏ i : Fin n, exactRows i z) := by rw [hFg z]
      _ ≤ ∏ i : Fin n, realRows i z := hl
      _ = w z := (hFw z).symm
  · calc w z
        = ∏ i : Fin n, realRows i z := hFw z
      _ ≤ (∏ i : Fin n, hi i) * (∏ i : Fin n, exactRows i z) := hu
      _ = (∏ i : Fin n, hi i) * g z := by rw [← hFg z]

/-! ## 2. Stage 1 `TowerWhole` — the heavy road, its exact strengthening and
the margin arithmetic -/

/-- **THE exact pointwise strengthening of stage 1** (the missing lemma of
`notes/B4_ATTEMPT_WEIGHTS_WORK_STATE.md` §1, in road form): the realized target
of ONE `to_sign` attempt (i) has EXACTLY the fiber support, (ii) factorizes
pointwise into realized row weights and (iii) each realized row weight is within
`(1 ± budget i)` of the exact tower row factor AT EVERY POINT of the fiber,
where the per-row budgets fit the RECORDED stage-1 margins multiplicatively.
Deliverers: the T5/REFINE material owners (the rows are their tower rows —
`PerKeyTransport.towerOfScaledLeaves` + `GramLDL.gaussian_tower_atom`) + the
B1/source3 `do_sign` kernel (the realization). -/
structure TowerRowRoad (A : BoxPair → Relation.Rq) (c : Relation.Rq)
    (target : BoxPair → ℝ) : Prop where
  /-- Number of realized rows in the pointwise product decomposition. -/
  rows : ℕ
  /-- Exact row factors of the pinned ideal weight (`gaussianWeight`). -/
  exactRows : Fin rows → BoxPair → ℝ
  /-- Realized row factors of the sampler target (B1/source3). -/
  realRows : Fin rows → BoxPair → ℝ
  /-- Per-row admissible pointwise deviation budgets `b i ∈ [0,1)`. -/
  budget : Fin rows → ℝ
  /-- The realized target has EXACTLY the fiber support (forced by
  `towerWhole_iff`, delivered by the `do_sign` kernel). -/
  fiber_support : ∀ z : BoxPair, A z ≠ c → target z = 0
  /-- The ideal weight factors pointwise into exact rows (per-point identity). -/
  exact_factor : RowFactors gaussianWeight exactRows
  /-- The realized target factors pointwise into realized rows ON THE FIBER. -/
  real_factor : ∀ z : BoxPair, A z = c → target z = ∏ i : Fin rows, realRows i z
  /-- Exact rows are nonnegative at every point. -/
  row_nonneg : ∀ (i : Fin rows) (z : BoxPair), 0 ≤ exactRows i z
  /-- THE per-row pointwise sandwich — the whole content that the total-mass
  bounds do not supply. -/
  row_sandwich : RowSandwichOn (fun z => A z = c) budget exactRows realRows
  /-- Budget sanity. -/
  budget_range : ∀ i : Fin rows, 0 ≤ budget i ∧ budget i < 1
  /-- Product fit of the budgets to the RECORDED lower margin `towerLo = (1-rowBudget)^2`. -/
  fit_lo : (1 - Run2.T5ScalarMass.rowBudget) ^ 2
      ≤ ∏ i : Fin rows, 1 - budget i
  /-- Product fit of the budgets to the RECORDED upper margin `towerHi = (1+rowBudget)^2`. -/
  fit_hi : (∏ i : Fin rows, 1 + budget i) ≤ (1 + Run2.T5ScalarMass.rowBudget) ^ 2

/-- Exact structural split of the stage-1 pointwise statement: the sandwich
against `fiberWeight` (with its fiber indicator) is EXACTLY (i) exact fiber
support of the target and (ii) the on-fiber sandwich against `gaussianWeight`.
In particular `TowerWhole` FORCES `target z = 0` off the fiber — the pointwise
shape carries real content a total-mass bound never carries. -/
theorem towerWhole_iff (A : BoxPair → Relation.Rq) (c : Relation.Rq)
    (target : BoxPair → ℝ) :
    TowerWhole A c target ↔
      (∀ z : BoxPair, A z ≠ c → target z = 0) ∧
        ∀ z : BoxPair, A z = c →
          towerLo * gaussianWeight z ≤ target z
            ∧ target z ≤ towerHi * gaussianWeight z := by
  constructor
  · intro h
    constructor
    · intro z hz
      have hfw : fiberWeight A c z = 0 := by
        show (if A z = c then gaussianWeight z else 0) = 0
        simp [hz]
      have h1 : (0:ℝ) ≤ target z := by
        have := (h z).1
        rw [hfw, mul_zero] at this
        exact this
      have h2 : target z ≤ (0:ℝ) := by
        have := (h z).2
        rw [hfw, mul_zero] at this
        exact this
      exact le_antisymm h2 h1
    · intro z hz
      have hfw : fiberWeight A c z = gaussianWeight z := by
        show (if A z = c then gaussianWeight z else 0) = gaussianWeight z
        simp [hz]
      have h1 : towerLo * gaussianWeight z ≤ target z := by
        have := (h z).1
        rwa [hfw] at this
      have h2 : target z ≤ towerHi * gaussianWeight z := by
        have := (h z).2
        rwa [hfw] at this
      exact ⟨h1, h2⟩
  · intro h
    obtain ⟨hsup, hon⟩ := h
    intro z
    by_cases hz : A z = c
    · have hfw : fiberWeight A c z = gaussianWeight z := by
        show (if A z = c then gaussianWeight z else 0) = gaussianWeight z
        simp [hz]
      rw [hfw]
      exact hon z hz
    · have hfw : fiberWeight A c z = 0 := by
        show (if A z = c then gaussianWeight z else 0) = 0
        simp [hz]
      have hz0 : target z = 0 := hsup z hz
      rw [hfw, hz0, mul_zero]
      exact ⟨le_rfl, le_rfl⟩

/-- Structural corollary: the stage-1 pointwise sandwich forces exact fiber
support of the realized target. -/
theorem towerWhole_support {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {target : BoxPair → ℝ} (h : TowerWhole A c target) :
    ∀ z : BoxPair, A z ≠ c → target z = 0 :=
  (towerWhole_iff A c target).mp h |>.1

/-- Structural corollary: the realized target is nonnegative (derived from the
pointwise shape, no extra premise). -/
theorem towerWhole_nonneg {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {target : BoxPair → ℝ} (h : TowerWhole A c target) (z : BoxPair) :
    0 ≤ target z :=
  le_trans (mul_nonneg chain_tower_nonneg (fiberWeight_nonneg A c z)) (h z).1

/-- **Stage-1 re-shaping (the road, proved)**: the row-product realization with
per-row budgets fitting the recorded margins gives `TowerWhole` AT THE RECORDED
MARGINS — per point, whole region, tail included. -/
theorem towerWhole_of_rowRoad {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {target : BoxPair → ℝ} (h : TowerRowRoad A c target) :
    TowerWhole A c target := by
  rw [towerWhole_iff]
  constructor
  · exact h.fiber_support
  · intro z hz
    have hRS : ∀ i : Fin h.rows, (1 - h.budget i) * h.exactRows i z ≤ h.realRows i z
        ∧ h.realRows i z ≤ (1 + h.budget i) * h.exactRows i z :=
      fun i => h.row_sandwich i z hz
    have hlo : ∀ i : Fin h.rows, 0 ≤ 1 - h.budget i := by
      intro i
      have := h.budget_range i
      linarith
    obtain ⟨hl, hu⟩ := rowProduct_sandwich_at z hRS hlo h.row_nonneg
    rw [← h.exact_factor z, ← h.real_factor z hz] at hl hu
    have hg : 0 ≤ gaussianWeight z := gaussianWeight_nonneg z
    constructor
    · calc towerLo * gaussianWeight z
          ≤ (∏ i : Fin h.rows, 1 - h.budget i) * gaussianWeight z :=
            mul_le_mul_of_nonneg_right h.fit_lo hg
        _ ≤ target z := hl
    · calc target z
          ≤ (∏ i : Fin h.rows, 1 + h.budget i) * gaussianWeight z := hu
        _ ≤ towerHi * gaussianWeight z :=
            mul_le_mul_of_nonneg_right h.fit_hi hg

/-! ### The margin arithmetic of the road (kernel-checked) -/

/-- Provenance identity of the RECORDED stage-1 margins: `towerLo`/`towerHi`
are EXACTLY the 2-row product at full `rowBudget` (the
`ConvStruct.a2Tower_mass_bounds` `n = 2` shape at the conservative
`Run2.T5ScalarMass.rowBudget ≥ 2r/(1-r)` envelope). -/
theorem tower_margin_row2 :
    (∏ _i : Fin 2, (1 - Run2.T5ScalarMass.rowBudget)) = towerLo
      ∧ (∏ _i : Fin 2, (1 + Run2.T5ScalarMass.rowBudget)) = towerHi := by
  constructor
  · rw [prod_const_fin]
    rfl
  · rw [prod_const_fin]
    rfl

/-- Achievability of the recorded margins from a 3072-row product (the full
scalar-row tower — `2 * 1536` rows, `PerKeyTransport.two_mul_len`): per-row
budgets `2^-58`-class fit BOTH recorded margins. This is the numeric envelope
the B1 realization must meet if the road is row-factorized over all 3072 rows. -/
theorem road_fit_3072_rows :
    (1 - Run2.T5ScalarMass.rowBudget) ^ 2 ≤ (1 - 1 / 2 ^ 58) ^ 3072
      ∧ (1 + 1 / 2 ^ 58) ^ 3072 ≤ (1 + Run2.T5ScalarMass.rowBudget) ^ 2 := by
  have hneg2 : (-2:ℝ) ≤ -(1 / 2 ^ 58 : ℝ) := by norm_num
  have hbern : (1:ℝ) + 3072 * (-(1 / 2 ^ 58 : ℝ))
      ≤ (1 + (-(1 / 2 ^ 58 : ℝ))) ^ 3072 := by
    have hh := one_add_mul_le_pow (a := (-(1 / 2 ^ 58 : ℝ))) hneg2 3072
    convert hh using 1
    ring
  have hb0 : (0:ℝ) ≤ 1 / 2 ^ 58 := by norm_num
  have h2n : 2 * (3072:ℝ) * (1 / 2 ^ 58) ≤ 1 := by norm_num
  have hpow : ((1:ℝ) + 1 / 2 ^ 58) ^ 3072 ≤ 1 + 2 * (3072:ℝ) * (1 / 2 ^ 58) :=
    pow_succ_le_real (1 / 2 ^ 58 : ℝ) hb0 3072 h2n
  constructor
  · have hnum : ((1:ℝ) - Run2.T5ScalarMass.rowBudget) ^ 2
        ≤ 1 + 3072 * (-(1 / 2 ^ 58 : ℝ)) := by
      norm_num [Run2.T5ScalarMass.rowBudget]
    have hrew : ((1:ℝ) - 1 / 2 ^ 58) ^ 3072
        = (1 + (-(1 / 2 ^ 58 : ℝ))) ^ 3072 := by
      ring_nf
    calc (1 - Run2.T5ScalarMass.rowBudget) ^ 2
          ≤ 1 + 3072 * (-(1 / 2 ^ 58 : ℝ)) := hnum
      _ ≤ (1 + (-(1 / 2 ^ 58 : ℝ))) ^ 3072 := hbern
      _ = (1 - 1 / 2 ^ 58) ^ 3072 := hrew.symm
  · have hnum : (1:ℝ) + 2 * (3072:ℝ) * (1 / 2 ^ 58)
        ≤ (1 + Run2.T5ScalarMass.rowBudget) ^ 2 := by
      norm_num [Run2.T5ScalarMass.rowBudget]
    exact le_trans hpow hnum

/-- **HONEST FINDING (kernel counter-fact to the naive road)**: a per-row
realization at FULL `rowBudget` over the 3072 scalar rows does NOT fit the
recorded stage-1 margins — its composed ratio alone already EXCEEDS the whole
composite per-attempt budget `1 + 2^-38`
(`SignLayerSupport.attemptFactor_lt`). The pointwise road over `k` rows must
therefore compress the per-row deviations (3072 rows: `2^-58`-class per
`road_fit_3072_rows`) or deliver the aggregate 2-row shape of
`tower_margin_row2`: the recorded `1+2^-43`-class pointwise bound is NOT what a
full-`rowBudget` row product gives (`2^-34`-class instead, cf.
`Run2.T5ScalarMass.scalar_power_margins`). -/
theorem rowwise_fullBudget_busts :
    1 + 1 / 274877906944 <
      (((1 + Run2.T5ScalarMass.rowBudget) / (1 - Run2.T5ScalarMass.rowBudget)) ^ 3072 : ℝ) := by
  have hb0 : (0:ℝ) ≤ Run2.T5ScalarMass.rowBudget := by
    norm_num [Run2.T5ScalarMass.rowBudget]
  have hbase : (1 + Run2.T5ScalarMass.rowBudget)
      ≤ (1 + Run2.T5ScalarMass.rowBudget) / (1 - Run2.T5ScalarMass.rowBudget) := by
    have h1 : (0:ℝ) < 1 - Run2.T5ScalarMass.rowBudget := by
      norm_num [Run2.T5ScalarMass.rowBudget]
    rw [le_div_iff₀ h1]
    nlinarith
  have hmono : ((1 + Run2.T5ScalarMass.rowBudget) : ℝ) ^ 3072
      ≤ ((1 + Run2.T5ScalarMass.rowBudget) / (1 - Run2.T5ScalarMass.rowBudget)) ^ 3072 :=
    pow_le_pow_left₀ (by norm_num [Run2.T5ScalarMass.rowBudget]) hbase 3072
  have hneg2 : (-2:ℝ) ≤ Run2.T5ScalarMass.rowBudget := by
    norm_num [Run2.T5ScalarMass.rowBudget]
  have hbern : (1:ℝ) + 3072 * Run2.T5ScalarMass.rowBudget
      ≤ (1 + Run2.T5ScalarMass.rowBudget) ^ 3072 := by
    have hh := one_add_mul_le_pow (a := Run2.T5ScalarMass.rowBudget) hneg2 3072
    convert hh using 1
    ring
  have hnum : (1:ℝ) + 1 / 274877906944
      < 1 + 3072 * Run2.T5ScalarMass.rowBudget := by
    norm_num [Run2.T5ScalarMass.rowBudget]
  calc 1 + 1 / 274877906944
      < 1 + 3072 * Run2.T5ScalarMass.rowBudget := hnum
    _ ≤ (1 + Run2.T5ScalarMass.rowBudget) ^ 3072 := hbern
    _ ≤ ((1 + Run2.T5ScalarMass.rowBudget) / (1 - Run2.T5ScalarMass.rowBudget)) ^ 3072 := hmono

/-! ## 3. Stage 2 `MachineStage` — re-shaping the H3 error contract -/

/-- Endpoint identity of the multiplicative machine margins (the `20/11` shape
of the conservative H3 error contract — `sage/t5_conservative_margin.sage`:
`lo = minus^20/plus^11`; 20 multiplicative roundings and 11 divisive roundings
at unit `roundU`): `t5lo = (1-u)^20 * (1+u)^-11`. -/
theorem t5lo_factorization :
    (CenteringClosure.t5lo : ℝ) = (1 - roundU) ^ 20 * ((1 + roundU)⁻¹) ^ 11 := by
  have h1 : (CenteringClosure.t5lo : ℝ) = (1 - roundU) ^ 20 / (1 + roundU) ^ 11 := by
    simp only [roundU]
    norm_num [CenteringClosure.t5lo, CenteringClosure.t5minus, CenteringClosure.t5plus]
  rw [h1, div_eq_mul_inv, inv_pow]

/-- Endpoint identity of the upper machine margin: `t5hi = (1+u)^20 * (1-u)^-11`. -/
theorem t5hi_factorization :
    (CenteringClosure.t5hi : ℝ) = (1 + roundU) ^ 20 * ((1 - roundU)⁻¹) ^ 11 := by
  have h1 : (CenteringClosure.t5hi : ℝ) = (1 + roundU) ^ 20 / (1 - roundU) ^ 11 := by
    simp only [roundU]
    norm_num [CenteringClosure.t5hi, CenteringClosure.t5minus, CenteringClosure.t5plus]
  rw [h1, div_eq_mul_inv, inv_pow]

/-- **THE exact pointwise strengthening of stage 2**: the realized machine
weights evaluate as the exact target weights through a SHORT product of
relative-rounding factors — 20 multiplicative roundings within `(1 ± roundU)`
and 11 divisive roundings within `[(1+roundU)^-1, (1-roundU)^-1]` — AT EVERY
POINT. This is the multiplicative endpoint of the same H3 error contract whose
additive absolute chains are `CenteringClosure.cmul`/`sErr`. Deliverers: the
B1/source3 `do_sign` kernel bound to the FPError `FprRefinement` per-op
contracts (`notes/C_TASK_2_FPERROR_CONTRACTS.md`). -/
structure MachineEvalRoad (target mach : BoxPair → ℝ) : Prop where
  /-- Relative-rounding factors of the 20 multiplicative operations. -/
  multF : BoxPair → Fin 20 → ℝ
  /-- Relative-rounding factors of the 11 divisive operations. -/
  divF : BoxPair → Fin 11 → ℝ
  /-- Pointwise evaluation identity (the `do_sign` weight path). -/
  eval_eq : ∀ z : BoxPair,
    mach z = target z * (∏ i : Fin 20, multF z i) * (∏ j : Fin 11, divF z j)
  /-- Each multiplicative rounding within `(1 ± roundU)`. -/
  mult_range : ∀ (z : BoxPair) (i : Fin 20),
    1 - roundU ≤ multF z i ∧ multF z i ≤ 1 + roundU
  /-- Each divisive rounding within `[(1+roundU)^-1, (1-roundU)^-1]`. -/
  div_range : ∀ (z : BoxPair) (j : Fin 11),
    (1 + roundU)⁻¹ ≤ divF z j ∧ divF z j ≤ (1 - roundU)⁻¹

theorem evalRoad_nonneg {target mach : BoxPair → ℝ} (ht : ∀ z, 0 ≤ target z)
    (h : MachineEvalRoad target mach) (z : BoxPair) : 0 ≤ mach z := by
  have hm : ∀ i : Fin 20, 0 ≤ h.multF z i := by
    intro i
    exact le_trans (le_of_lt one_sub_roundU_pos) (h.mult_range z i).1
  have hd : ∀ j : Fin 11, 0 ≤ h.divF z j := by
    intro j
    exact le_trans (le_of_lt one_add_roundU_inv_pos) (h.div_range z j).1
  rw [h.eval_eq z]
  exact mul_nonneg (mul_nonneg (ht z)
    (prod_nonneg fun i _ => hm i)) (prod_nonneg fun j _ => hd j)

/-- **Stage-2 re-shaping (proved)**: the per-op relative-rounding product is the
`MachineStage` sandwich at the recorded `t5lo`/`t5hi` endpoints — the numeric
margin `machineMargin < 1 + 2^-42` stays CONSUMED
(`SignLayerSupport.machineMargin_lt`). -/
theorem machineStage_of_evalRoad {target mach : BoxPair → ℝ}
    (ht : ∀ z, 0 ≤ target z) (h : MachineEvalRoad target mach) :
    MachineStage target mach := by
  intro z
  have hm1 : ∀ _i : Fin 20, (0:ℝ) ≤ 1 - roundU :=
    fun _ => le_of_lt one_sub_roundU_pos
  have hd1 : ∀ _j : Fin 11, (0:ℝ) ≤ (1 + roundU)⁻¹ :=
    fun _ => le_of_lt one_add_roundU_inv_pos
  have hp1l : (1 - roundU) ^ 20 ≤ ∏ i : Fin 20, h.multF z i := by
    have h1 : (∏ _i : Fin 20, (1 - roundU)) ≤ ∏ i : Fin 20, h.multF z i :=
      Finset.prod_le_prod (fun i _ => hm1 i) (fun i _ => (h.mult_range z i).1)
    rwa [prod_const_fin] at h1
  have hp1u : (∏ i : Fin 20, h.multF z i) ≤ (1 + roundU) ^ 20 := by
    have h1 : (∏ i : Fin 20, h.multF z i) ≤ (∏ _i : Fin 20, (1 + roundU)) :=
      Finset.prod_le_prod (fun i _ => le_trans (hm1 i) (h.mult_range z i).1)
        (fun i _ => (h.mult_range z i).2)
    rwa [prod_const_fin] at h1
  have hp2l : ((1 + roundU)⁻¹) ^ 11 ≤ ∏ j : Fin 11, h.divF z j := by
    have h1 : (∏ _j : Fin 11, (1 + roundU)⁻¹) ≤ ∏ j : Fin 11, h.divF z j :=
      Finset.prod_le_prod (fun j _ => hd1 j) (fun j _ => (h.div_range z j).1)
    rwa [prod_const_fin] at h1
  have hp2u : (∏ j : Fin 11, h.divF z j) ≤ ((1 - roundU)⁻¹) ^ 11 := by
    have h1 : (∏ j : Fin 11, h.divF z j) ≤ (∏ _j : Fin 11, (1 - roundU)⁻¹) :=
      Finset.prod_le_prod (fun j _ => le_trans (hd1 j) (h.div_range z j).1)
        (fun j _ => (h.div_range z j).2)
    rwa [prod_const_fin] at h1
  have hprodL : (1 - roundU) ^ 20 * ((1 + roundU)⁻¹) ^ 11
      ≤ (∏ i : Fin 20, h.multF z i) * (∏ j : Fin 11, h.divF z j) :=
    mul_le_mul hp1l hp2l (pow_nonneg (le_of_lt one_add_roundU_inv_pos) 11)
      (prod_nonneg fun i _ => le_trans (hm1 i) (h.mult_range z i).1)
  have hprodU : (∏ i : Fin 20, h.multF z i) * (∏ j : Fin 11, h.divF z j)
      ≤ (1 + roundU) ^ 20 * ((1 - roundU)⁻¹) ^ 11 :=
    mul_le_mul hp1u hp2u (prod_nonneg fun j _ => le_trans (hd1 j) (h.div_range z j).1)
      (pow_nonneg (le_of_lt one_add_roundU_pos) 20)
  rw [t5lo_factorization, t5hi_factorization]
  constructor
  · have hstep := mul_le_mul_of_nonneg_right hprodL (ht z)
    rw [h.eval_eq z]
    calc (1 - roundU) ^ 20 * ((1 + roundU)⁻¹) ^ 11 * target z
          ≤ (∏ i : Fin 20, h.multF z i) * (∏ j : Fin 11, h.divF z j) * target z := hstep
      _ = target z * (∏ i : Fin 20, h.multF z i) * (∏ j : Fin 11, h.divF z j) := by
          ring
  · have hstep := mul_le_mul_of_nonneg_right hprodU (ht z)
    rw [h.eval_eq z]
    calc target z * (∏ i : Fin 20, h.multF z i) * (∏ j : Fin 11, h.divF z j)
          = (∏ i : Fin 20, h.multF z i) * (∏ j : Fin 11, h.divF z j) * target z := by
          ring
      _ ≤ (1 + roundU) ^ 20 * ((1 - roundU)⁻¹) ^ 11 * target z := hstep

/-! ### The additive trap at stage 2 (kernel counterexample) -/

/-- **KERNEL COUNTEREXAMPLE (the "dividing by the mass" trap)**: the additive
pointwise error transports (`CenteringClosure.cmul`/`sErr` — ABSOLUTE machine
word → value errors) do NOT restate multiplicatively as `MachineStage` without a
mass floor: additive accuracy `|mach z − target z| ≤ 1` with nonnegative
weights is compatible with an arbitrarily large pointwise ratio at small
weights. The exact strengthening for the additive route would need the floor
type `∃ mu : ℝ, 0 < mu ∧ ∀ z, mu ≤ target z` — recorded, never assumed. -/
theorem additiveError_no_machineStage :
    ∃ (target mach : BoxPair → ℝ), (∀ z, 0 ≤ target z) ∧ (∀ z, 0 ≤ mach z)
      ∧ (∀ z : BoxPair, |mach z - target z| ≤ 1)
      ∧ ¬ MachineStage target mach := by
  refine ⟨fun _ => 1 / 10 ^ 6, fun _ => 1 + 1 / 10 ^ 6, ?_, ?_, ?_, ?_⟩
  · intro z
    norm_num
  · intro z
    norm_num
  · intro z
    norm_num
  · intro hc
    have hz := (hc zeroPair).2
    show (1:ℝ) + 1 / 10 ^ 6 ≤ (CenteringClosure.t5hi : ℝ) * (1 / 10 ^ 6) at hz
    have hnum : ¬ ((1:ℝ) + 1 / 10 ^ 6 ≤ (CenteringClosure.t5hi : ℝ) * (1 / 10 ^ 6)) := by
      norm_num [CenteringClosure.t5hi, CenteringClosure.t5plus,
        CenteringClosure.t5minus, CenteringClosure.u]
    exact hnum hz

/-! ## 4. Stage 3 `WrapStage` — the wrap/centering map pointwise -/

/-- **THE exact pointwise strengthening of stage 3**: over the wrap/centering
map, the realized weight ratio at every point is a product of 1536
per-coordinate distortion factors (one per scalar coordinate of the reply —
`Geometry.Vec = Fin 768 → ℤ × ℤ`), each within `[(1+wrapA)^-1, 1+wrapA]` at
the consumed budget `wrapA = CenteringClosure.t5a = 6y/(1-y)^2`. Deliverers:
the `hbridge`-side all-key transport of `CenteringClosure` + the B1/source3
`do_sign` kernel. -/
structure WrapCoordRoad (mach wrapS : BoxPair → ℝ) : Prop where
  /-- Per-coordinate wrap distortion factors. -/
  coordF : BoxPair → Fin 1536 → ℝ
  /-- Pointwise evaluation identity through the wrap/centering map. -/
  wrap_eq : ∀ z : BoxPair,
    wrapS z = mach z * (∏ i : Fin 1536, coordF z i)
  /-- Each coordinate distortion within `[(1+wrapA)^-1, 1+wrapA]`. -/
  coord_range : ∀ (z : BoxPair) (i : Fin 1536),
    (1 + wrapA)⁻¹ ≤ coordF z i ∧ coordF z i ≤ 1 + wrapA

theorem coordRoad_nonneg {mach wrapS : BoxPair → ℝ} (hm : ∀ z, 0 ≤ mach z)
    (h : WrapCoordRoad mach wrapS) (z : BoxPair) : 0 ≤ wrapS z := by
  rw [h.wrap_eq z]
  exact mul_nonneg (hm z) (prod_nonneg fun i _ =>
    le_trans (le_of_lt wrapA_inv_pos) (h.coord_range z i).1)

/-- Numeric envelope (CONSUMED `CenteringClosure.tau_budget`): 1536 coordinate
distortions at `wrapA` stay below `1 + wrapT` on the upper side. -/
theorem wrapA_pow_1536_le : (1 + wrapA) ^ 1536 ≤ 1 + wrapT := by
  have hcast : (1 + (CenteringClosure.t5a : ℝ)) ^ 1536 - 1
      < (1:ℝ) / 1099511627776 := by
    exact_mod_cast CenteringClosure.tau_budget
  have htb : ((1:ℝ) / 1099511627776) = wrapT := by
    norm_num [wrapT, CenteringClosure.tauB]
  have hlt : (1 + (CenteringClosure.t5a : ℝ)) ^ 1536 < 1 + wrapT := by
    rw [← htb]
    linarith
  exact hlt.le

/-- Numeric envelope, lower side: the reciprocal product of 1536 coordinate
distortions stays above `1 - wrapT` (through `(1+tauB)^-1 ≥ 1-tauB`). -/
theorem wrapA_pow_inv_1536 : 1 - wrapT ≤ ((1 + wrapA)⁻¹) ^ 1536 := by
  have hrew : ((1 + wrapA)⁻¹) ^ 1536 = ((1 + wrapA) ^ 1536)⁻¹ := inv_pow _ _
  rw [hrew]
  have hpos1 : (0:ℝ) < (1 + wrapA) ^ 1536 := pow_pos wrapA_pos 1536
  have hpos2 : (0:ℝ) < 1 + wrapT := wrapT_bounds.2
  have h1 : (1 + wrapT)⁻¹ ≤ ((1 + wrapA) ^ 1536)⁻¹ :=
    (inv_le_inv₀ hpos1 hpos2).mpr wrapA_pow_1536_le
  have h2 : (1:ℝ) - wrapT ≤ (1 + wrapT)⁻¹ := by
    rw [le_inv_iff₀ wrapT_bounds.1 wrapT_bounds.2]
    have h3 : ((1:ℝ) - wrapT) * (1 + wrapT) = 1 - wrapT ^ 2 := by ring
    rw [h3]
    nlinarith [sq_nonneg (wrapT:ℝ)]
  exact le_trans h2 h1

/-- **Stage-3 re-shaping (proved)**: 1536 per-coordinate distortion factors at
`wrapA` compose to the recorded `WrapStage` sandwich at `wrapT = tauB` — the
numeric margin `wrapFactor < 1 + 1/(2^39-1)` stays CONSUMED
(`AttemptWeights.stage_wrap_lt`). -/
theorem wrapStage_of_coordRoad {mach wrapS : BoxPair → ℝ} (hm : ∀ z, 0 ≤ mach z)
    (h : WrapCoordRoad mach wrapS) : WrapStage mach wrapS := by
  intro z
  have hc1 : ∀ _i : Fin 1536, (0:ℝ) ≤ (1 + wrapA)⁻¹ :=
    fun _ => le_of_lt wrapA_inv_pos
  have hPu : (∏ i : Fin 1536, h.coordF z i) ≤ 1 + wrapT := by
    have h1 : (∏ i : Fin 1536, h.coordF z i) ≤ (∏ _i : Fin 1536, 1 + wrapA) :=
      Finset.prod_le_prod (fun i _ => le_trans (hc1 i) (h.coord_range z i).1)
        (fun i _ => (h.coord_range z i).2)
    rw [prod_const_fin] at h1
    exact le_trans h1 wrapA_pow_1536_le
  have hPl : 1 - wrapT ≤ ∏ i : Fin 1536, h.coordF z i := by
    have h1 : (∏ _i : Fin 1536, (1 + wrapA)⁻¹) ≤ ∏ i : Fin 1536, h.coordF z i :=
      Finset.prod_le_prod (fun i _ => hc1 i) (fun i _ => (h.coord_range z i).1)
    rw [prod_const_fin] at h1
    exact le_trans wrapA_pow_inv_1536 h1
  show (1 - wrapT) * mach z ≤ wrapS z ∧ wrapS z ≤ (1 + wrapT) * mach z
  rw [h.wrap_eq z]
  constructor
  · calc (1 - wrapT) * mach z ≤ (∏ i : Fin 1536, h.coordF z i) * mach z :=
        mul_le_mul_of_nonneg_right hPl (hm z)
      _ = mach z * ∏ i : Fin 1536, h.coordF z i := by ring
  · calc mach z * ∏ i : Fin 1536, h.coordF z i
        = (∏ i : Fin 1536, h.coordF z i) * mach z := by ring
      _ ≤ (1 + wrapT) * mach z := mul_le_mul_of_nonneg_right hPu (hm z)

/-! ## 5. Stage 4 `BoxStage` — the box-truncation transfer pointwise -/

/-- **THE exact pointwise strengthening of stage 4**: the box truncation acts as
a UNIFORM rescaling of the whole weight system at the WHOLE-space retention
fraction `rho` (bulk AND tail mass together — the `bulkOnly_*` counter-theorems
forbid a bulk-only retention bound), with `rho` within `[1-boxR, 1]`.
Deliverers: the B1/source3 `do_sign` kernel + the `hbridge`-side transport. -/
structure BoxRetentionRoad (wrapS w : BoxPair → ℝ) : Prop where
  /-- The uniform whole-space retention fraction. -/
  rho : ℝ
  /-- Retention at least `1 - boxR` over the WHOLE candidate space. -/
  rho_lo : 1 - boxR ≤ rho
  /-- Truncation only removes mass. -/
  rho_hi : rho ≤ 1
  /-- Pointwise uniform rescaling. -/
  scale_eq : ∀ z : BoxPair, w z = wrapS z / rho

theorem retentionRoad_nonneg {wrapS w : BoxPair → ℝ} (hm : ∀ z, 0 ≤ wrapS z)
    (h : BoxRetentionRoad wrapS w) (z : BoxPair) : 0 ≤ w z := by
  have hrpos : 0 < h.rho := lt_of_lt_of_le boxR_sub_pos h.rho_lo
  rw [h.scale_eq z]
  exact div_nonneg (hm z) (le_of_lt hrpos)

/-- **Stage-4 re-shaping (proved)**: uniform whole-space rescaling at
`rho ∈ [1-boxB, 1]` is the `BoxStage` sandwich over the WHOLE region (tail
included — the pointwise statement must not truncate it away). The numeric
margin `boxFactor < 1 + 1e-30` stays CONSUMED (`AttemptWeights.stage_box_lt`). -/
theorem boxStage_of_retention {wrapS w : BoxPair → ℝ} (hm : ∀ z, 0 ≤ wrapS z)
    (h : BoxRetentionRoad wrapS w) : BoxStage wrapS w := by
  intro z
  have hrpos : 0 < h.rho := lt_of_lt_of_le boxR_sub_pos h.rho_lo
  show (1:ℝ) * wrapS z ≤ w z ∧ w z ≤ (1 / (1 - boxR)) * wrapS z
  rw [h.scale_eq z]
  constructor
  · show (1:ℝ) * wrapS z ≤ wrapS z / h.rho
    rw [one_mul, le_div_iff₀ hrpos]
    have h1 : wrapS z * h.rho ≤ wrapS z * (1:ℝ) :=
      mul_le_mul_of_nonneg_left h.rho_hi (hm z)
    rwa [mul_one] at h1
  · have h1 : wrapS z / h.rho ≤ wrapS z / (1 - boxR) :=
      div_le_div_of_nonneg_left (hm z) boxR_sub_pos h.rho_lo
    have h2 : wrapS z / (1 - boxR) = (1 / (1 - boxR)) * wrapS z := by
      rw [div_eq_mul_one_div, mul_comm]
    calc wrapS z / h.rho ≤ wrapS z / (1 - boxR) := h1
      _ = (1 / (1 - boxR)) * wrapS z := h2
      _ = (1 / (1 - (CenteringClosure.boxB : ℝ))) * wrapS z := rfl

/-! ## 6. The last plug for `hattempt` — the four roads bundled -/

/-- **THE exact final interface (the last plug for `hattempt`)**: the four
pointwise realization strengthenings over the ABSTRACT weight interface of
`AttemptWeights` (`target`/`mach`/`wrapS`/`w`-shaped). With
`ReplyShape`/`AttemptShape` (B1/source3) these close `hattempt` completely —
`layer2_of_stageRoad` is the assembled deliverable. -/
structure PointwiseStageRoad (A : BoxPair → Relation.Rq) (c : Relation.Rq)
    (target mach wrapS w : BoxPair → ℝ) : Prop where
  /-- Stage 1 road (tower/fiber-tilt — the heavy item). -/
  tower : TowerRowRoad A c target
  /-- Stage 2 road (machine rounding of the weights). -/
  machine : MachineEvalRoad target mach
  /-- Stage 3 road (wrap/centering map). -/
  wrap : WrapCoordRoad mach wrapS
  /-- Stage 4 road (box truncation). -/
  box : BoxRetentionRoad wrapS w

/-- The four stage sandwiches from the four pointwise roads — at the RECORDED
margins of `AttemptWeights`. -/
theorem stageChain_of_stageRoad {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {target mach wrapS w : BoxPair → ℝ}
    (h : PointwiseStageRoad A c target mach wrapS w) :
    TowerWhole A c target ∧ MachineStage target mach
      ∧ WrapStage mach wrapS ∧ BoxStage wrapS w := by
  have h1 : TowerWhole A c target := towerWhole_of_rowRoad h.tower
  have ht : ∀ z, 0 ≤ target z := towerWhole_nonneg h1
  have h2 : MachineStage target mach := machineStage_of_evalRoad ht h.machine
  have hm : ∀ z, 0 ≤ mach z := evalRoad_nonneg ht h.machine
  have h3 : WrapStage mach wrapS := wrapStage_of_coordRoad hm h.wrap
  have hw : ∀ z, 0 ≤ wrapS z := coordRoad_nonneg hm h.wrap
  have h4 : BoxStage wrapS w := boxStage_of_retention hw h.box
  exact ⟨h1, h2, h3, h4⟩

/-- The realized `w` is nonnegative along the whole road (derived, no premise). -/
theorem stageRoad_nonneg {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {target mach wrapS w : BoxPair → ℝ}
    (h : PointwiseStageRoad A c target mach wrapS w) : ∀ z, 0 ≤ w z :=
  retentionRoad_nonneg
    (coordRoad_nonneg (evalRoad_nonneg (towerWhole_nonneg (towerWhole_of_rowRoad h.tower))
      h.machine) h.wrap) h.box

/-- **THE last plug, boundary form**: the four pointwise roads instantiate the
`AttemptPointwise.AttemptWeights` interface — the remaining content of
`hattempt` after `AttemptShape`. -/
theorem attemptWeights_of_stageRoad {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {target mach wrapS w : BoxPair → ℝ}
    (h : PointwiseStageRoad A c target mach wrapS w) : AttemptWeights A c w := by
  obtain ⟨h1, h2, h3, h4⟩ := stageChain_of_stageRoad h
  exact attemptWeights_of_stages target mach wrapS w h1 h2 h3 h4

/-- **THE deliverable of the window**: with `ReplyShape` + `AttemptShape`
(the B1/source3 `do_sign` binding) and the four pointwise roads, the reply law
satisfies `Divergence.second j (signBody A c) < 1 + 2^-32` — through
`AttemptWeights.layer2_of_stageChain`, margins all CONSUMED. -/
theorem layer2_of_stageRoad {j : Law (Option BoxVec)} {jT : Law (Option BoxPair)}
    {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {target mach wrapS w : BoxPair → ℝ}
    (hw : ∀ z, 0 ≤ w z) (hR : PointwiseStageRoad A c target mach wrapS w)
    (hshapeR : ReplyShape j jT) (hshape : AttemptShape jT w hw) :
    Divergence.AC j (signBody A c) ∧
      Divergence.second j (signBody A c) < 1 + 1 / 4294967296 := by
  obtain ⟨h1, h2, h3, h4⟩ := stageChain_of_stageRoad hR
  exact layer2_of_stageChain hw target mach wrapS h1 h2 h3 h4 hshapeR hshape

end FT1536.T5Pointwise
