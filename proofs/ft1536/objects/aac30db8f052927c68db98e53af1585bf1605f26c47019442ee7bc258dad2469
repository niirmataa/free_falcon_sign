import Run2.RejectionNumericMargin
import Run2.GuaranteedDigits

namespace FT1536.Run2.NormalizerComparison
open Finset PublicSimulation ExactCounting GaussianFiberTilt LegalKeyErrorTransfer
open FT1536.Relation

/- The normalizers below are the actual finite-box sums. In particular this
   partition does not replace the uniform-target signer by the public law. -/
theorem fiber_partition (h : Rq) (a : ℝ) :
    (∑ c, fiberMass h c a) = ∑ z, weight a z := by
  classical
  unfold fiberMass
  rw [sum_comm]
  simp

theorem fiber_partition_at_alpha (h : Rq) :
    (∑ c, fiberMass h c alpha) = totalWeight := by
  rw [fiber_partition]
  simp only [weight_at_alpha]
  rw [totalWeight, eval_count]
  simp

theorem common_scale_total (h : Rq) (v l u : ℝ)
    (bounds : ∀ c, l*v ≤ fiberMass h c alpha ∧ fiberMass h c alpha ≤ u*v) :
    (Fintype.card Rq : ℝ)*(l*v) ≤ totalWeight ∧
      totalWeight ≤ (Fintype.card Rq : ℝ)*(u*v) := by
  rw [← fiber_partition_at_alpha h]
  constructor
  · calc
      _ = ∑ _c : Rq, l*v := by simp
      _ ≤ _ := sum_le_sum fun c _ => (bounds c).1
  · calc
      _ ≤ ∑ _c : Rq, u*v := sum_le_sum fun c _ => (bounds c).2
      _ = _ := by simp

theorem finiteFlat_of_common_scale (h : Rq) (v l u e : ℝ)
    (hv : 0 ≤ v) (he0 : 0 ≤ e) (he1 : e ≤ 1)
    (lower : (1-e)*u ≤ l) (upper : u ≤ (1+e)*l)
    (bounds : ∀ c, l*v ≤ fiberMass h c alpha ∧ fiberMass h c alpha ≤ u*v) :
    FiniteFlat h e := by
  have hc : 0 ≤ (Fintype.card Rq : ℝ) := by positivity
  obtain ⟨htl,htu⟩ := common_scale_total h v l u bounds
  intro c
  rw [← fiberMass_at_alpha]
  constructor
  · calc
      (1-e)*totalWeight ≤ (1-e)*((Fintype.card Rq : ℝ)*(u*v)) :=
        mul_le_mul_of_nonneg_left htu (by linarith)
      _ = (Fintype.card Rq : ℝ)*(((1-e)*u)*v) := by ring
      _ ≤ (Fintype.card Rq : ℝ)*(l*v) :=
        mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right lower hv) hc
      _ ≤ _ := mul_le_mul_of_nonneg_left (bounds c).1 hc
  · calc
      (Fintype.card Rq : ℝ)*fiberMass h c alpha ≤ (Fintype.card Rq : ℝ)*(u*v) :=
        mul_le_mul_of_nonneg_left (bounds c).2 hc
      _ ≤ (Fintype.card Rq : ℝ)*(((1+e)*l)*v) :=
        mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right upper hv) hc
      _ = (1+e)*((Fintype.card Rq : ℝ)*(l*v)) := by ring
      _ ≤ _ := mul_le_mul_of_nonneg_left htl (by linarith)

/- A coarse theta/box budget suffices for the already selected three digits.
   These are numeric margins, not a new admissibility test on KeyGen outputs. -/
noncomputable def thetaBudget : ℝ := 1/2^40
noncomputable def lowerFactor : ℝ := (1-thetaBudget)^2
noncomputable def upperFactor : ℝ := 1+thetaBudget

theorem factor_margins :
    0 < lowerFactor ∧
    (1-GuaranteedDigits.flatBudget)*upperFactor ≤ lowerFactor ∧
    upperFactor ≤ (1+GuaranteedDigits.flatBudget)*lowerFactor ∧
    upperFactor ≤ (17/16 : ℝ)*lowerFactor := by
  norm_num [lowerFactor, upperFactor, thetaBudget, GuaranteedDigits.flatBudget]

theorem finiteFlat_from_box_normalizers (h : Rq) (v : ℝ) (hv : 0 ≤ v)
    (bounds : ∀ c, lowerFactor*v ≤ fiberMass h c alpha ∧
      fiberMass h c alpha ≤ upperFactor*v) :
    FiniteFlat h GuaranteedDigits.flatBudget :=
  finiteFlat_of_common_scale h v lowerFactor upperFactor GuaranteedDigits.flatBudget
    hv (by norm_num [GuaranteedDigits.flatBudget])
    (by norm_num [GuaranteedDigits.flatBudget]) factor_margins.2.1
    factor_margins.2.2.1 bounds

theorem tilted_ratio_from_box_normalizers (h c : Rq) (v : ℝ) (hv : 0 ≤ v)
    (lower : lowerFactor*v ≤ fiberMass h c alpha)
    (upper : fiberMass h c (alpha-alpha/8) ≤ upperFactor*v*((8/7 : ℝ)^1536)) :
    fiberMass h c (alpha-alpha/8)/fiberMass h c alpha ≤
      (17/16 : ℝ)*(8/7)^1536 := by
  have hp : 0 ≤ (8/7 : ℝ)^1536 := pow_nonneg (by norm_num) _
  apply (div_le_iff₀ (fiberMass_pos h c alpha)).2
  calc
    _ ≤ upperFactor*v*((8/7 : ℝ)^1536) := upper
    _ ≤ ((17/16 : ℝ)*lowerFactor)*v*((8/7 : ℝ)^1536) :=
      mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_right factor_margins.2.2.2 hv) hp
    _ = ((17/16 : ℝ)*(8/7)^1536)*(lowerFactor*v) := by
      simp only [mul_assoc, mul_left_comm, mul_comm]
    _ ≤ _ := mul_le_mul_of_nonneg_left lower (mul_nonneg (by norm_num) hp)

theorem actual_rejection_from_box_normalizers (h c : Rq) (v : ℝ) (hv : 0 ≤ v)
    (lower : lowerFactor*v ≤ fiberMass h c alpha)
    (upper : fiberMass h c (alpha-alpha/8) ≤ upperFactor*v*((8/7 : ℝ)^1536)) :
    CorrectnessProbability.rejection h c < GuaranteedDigits.rejectBudget := by
  exact RejectionNumericMargin.actual_rejection_from_tilted_normalizers h c
    (tilted_ratio_from_box_normalizers h c v hv lower upper)

end FT1536.Run2.NormalizerComparison
