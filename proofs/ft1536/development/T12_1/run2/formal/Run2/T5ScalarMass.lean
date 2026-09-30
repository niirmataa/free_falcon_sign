import Run2.T5ThetaNumeric
import Run2.TriangularGaussian

namespace FT1536.Run2.T5ScalarMass
open T5ThetaNumeric TriangularGaussian

/- Splitting a primal leaf lambda*A2 into scalar squares gives pivots
   lambda and 3*lambda/4. Reciprocal leaves >=991 bound both pivots by q^2/991.
   This auxiliary bound loses precision relative to the centered A2 product,
   but remains far inside the margin needed for three significant digits. -/
noncomputable def maxCoefficient : ℝ := 18433^2/(991*2*Real.pi*768^2)
noncomputable def rowRatio : ℝ := 1/2^48
noncomputable def rowBudget : ℝ := 1/2^46
noncomputable def massBudget : ℝ := 1/2^34

theorem scalar_reciprocal_exponent :
    (48 : ℝ)*Real.log 2 < Real.pi/maxCoefficient := by
  have hid : Real.pi/maxCoefficient = (3/4 : ℝ)*(kappa*991) := by
    unfold maxCoefficient kappa
    field_simp
    ring
  rw [hid]
  have hh := leaf_exponent 991 le_rfl
  have hl := Real.log_pos (by norm_num : (1 : ℝ)<2)
  nlinarith

theorem row_exponential_bound (a : ℝ) (ha : 0<a) (hu : a≤maxCoefficient) :
    Real.exp (-Real.pi/a) ≤ rowRatio := by
  have hdiv := div_le_div_of_nonneg_left Real.pi_pos.le ha hu
  have hexp : Real.exp (-(48 : ℝ)*Real.log 2) = rowRatio := by
    have hh := Real.exp_nat_mul (Real.log 2) 48
    norm_num only [Nat.cast_ofNat] at hh
    rw [Real.exp_log (by norm_num : (0 : ℝ)<2)] at hh
    rw [neg_mul, Real.exp_neg, hh]
    simp only [rowRatio, one_div]
  rw [← hexp]
  apply Real.exp_le_exp.mpr
  rw [neg_div]
  linarith only [hdiv, scalar_reciprocal_exponent]

def CoefficientRange : {n : ℕ} → Tower n → Prop
  | _, .nil => True
  | _, .snoc prior a _ => CoefficientRange prior ∧ 0<a ∧ a≤maxCoefficient

theorem local_exponents {n : ℕ} (T : Tower n) (h : CoefficientRange T) :
    LocalExponent rowRatio T := by
  induction T with
  | nil => trivial
  | snoc prior a shift ih =>
    exact ⟨ih h.1, h.2.1, row_exponential_bound a h.2.1 h.2.2⟩

theorem dimension_margins :
    0<rowRatio ∧ rowRatio<1 ∧
    0≤2*rowRatio/(1-rowRatio) ∧ 2*rowRatio/(1-rowRatio)≤rowBudget ∧
    rowBudget≤1 ∧ (3072 : ℝ)*rowBudget<massBudget ∧
    (3072 : ℝ)*rowBudget<1 ∧ 1/(1-(3072 : ℝ)*rowBudget)≤1+massBudget := by
  norm_num [rowRatio, rowBudget, massBudget]

theorem scalar_power_margins :
    1-massBudget ≤ (1-2*rowRatio/(1-rowRatio))^3072 ∧
      (1+2*rowRatio/(1-rowRatio))^3072 ≤ 1+massBudget := by
  obtain ⟨_,_,he0,her,hr1,hsmall,hn,hu⟩ := dimension_margins
  have hr0 : 0≤rowBudget := by norm_num [rowBudget]
  constructor
  · have hb : 1-(3072 : ℝ)*rowBudget ≤ (1-rowBudget)^3072 := by
      have hh := one_add_mul_le_pow (a := -rowBudget)
        (by linarith : -2 ≤ -rowBudget) 3072
      convert hh using 1
      ring
    calc
      _ ≤ 1-(3072 : ℝ)*rowBudget := sub_le_sub_left hsmall.le 1
      _ ≤ _ := hb
      _ ≤ _ := pow_le_pow_left₀ (sub_nonneg.mpr hr1) (sub_le_sub_left her 1) _
  · calc
      _ ≤ (1+rowBudget)^3072 :=
        pow_le_pow_left₀ (add_nonneg zero_le_one he0) (add_le_add (le_refl 1) her) _
      _ ≤ 1/(1-(3072 : ℝ)*rowBudget) := power_geometric_upper rowBudget hr0 hr1 3072 hn
      _ ≤ _ := hu

theorem uniform_shifted_mass_3072 (T : Tower 3072) (h : CoefficientRange T) :
    (1-massBudget)*scale T ≤ total T ∧ total T ≤ (1+massBudget)*scale T := by
  have he := local_exponents T h
  obtain ⟨hr0,hr1,_,her,hrb,_,_,_⟩ := dimension_margins
  obtain ⟨hl,hu⟩ := triangular_mass_bounds T rowRatio hr0 hr1 (her.trans hrb) he
  have hs := (scale_positive T rowRatio he).le
  exact ⟨(mul_le_mul_of_nonneg_right scalar_power_margins.1 hs).trans hl,
    hu.trans (mul_le_mul_of_nonneg_right scalar_power_margins.2 hs)⟩

end FT1536.Run2.T5ScalarMass
