import Run2.T5ScalarMass
import Run2.GuaranteedDigits
import Run2.TriangularGaussian
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Analysis.Complex.ExponentialBounds

namespace FT1536.Run2.T5GateBudget
open TriangularGaussian ShiftedGaussian

/- Gate-sharp scalar budgets for the T5 flat/reject obligation.

   The mandatory KeyGen gate (KeygenLeafGate) certifies machine leaf values
   in [1024, 332054] (lowerBits/upperBits). The stable leaf schedule then
   gives a combined primary/reciprocal leaf list with every member >= 1023
   (reciprocals are 18433^2/x with x <= 332054). On the scalar tower path
   each coordinate coefficient is bounded by `gateCoefficientCap`, which
   gives the per-coordinate dual base `gateRatio = 2^-50` and a total mass
   deviation strictly inside the FiniteFlat budget 2^-36. The weaker 991
   route (T5ScalarMass, 2^-34) is preserved untouched and is NOT
   identified with these budgets. -/

noncomputable def gateLeafFloor : ℝ := 1023
noncomputable def gateCoefficientCap : ℝ := 18433^2/(gateLeafFloor*2*Real.pi*768^2)
noncomputable def gateRatio : ℝ := 1/2^50
noncomputable def gateRowDev : ℝ := 2*gateRatio/(1-gateRatio)
noncomputable def productLo : ℝ := 1-(3072 : ℝ)*gateRowDev
noncomputable def productHi : ℝ := 1/(1-(3072 : ℝ)*gateRowDev)

theorem gate_log_margin : (50 : ℝ)*Real.log 2 < Real.pi/gateCoefficientCap := by
  have hps : (314/100 : ℝ)^2 < Real.pi^2 := by nlinarith [Real.pi_gt_d2]
  have hlog := Real.log_two_lt_d9
  have hform : Real.pi/gateCoefficientCap =
      (2*gateLeafFloor*768^2 : ℝ)*Real.pi^2/18433^2 := by
    unfold gateCoefficientCap gateLeafFloor
    field_simp
  rw [hform]
  unfold gateLeafFloor
  norm_num at hps hlog ⊢
  nlinarith

theorem gate_row_exponential (a : ℝ) (ha : 0 < a) (hu : a ≤ gateCoefficientCap) :
    Real.exp (-Real.pi/a) ≤ gateRatio := by
  have hdiv := div_le_div_of_nonneg_left Real.pi_pos.le ha hu
  have hexp : Real.exp (-(50 : ℝ)*Real.log 2) = gateRatio := by
    have hh := Real.exp_nat_mul (Real.log 2) 50
    norm_num only [Nat.cast_ofNat] at hh
    rw [Real.exp_log (by norm_num : (0 : ℝ)<2)] at hh
    rw [neg_mul, Real.exp_neg, hh]
    simp only [gateRatio, one_div]
  rw [← hexp]
  apply Real.exp_le_exp.mpr
  rw [neg_div]
  linarith only [hdiv, gate_log_margin]

theorem gate_row_dev_pos : 0 < gateRowDev := by
  unfold gateRowDev gateRatio
  positivity

theorem gate_row_dev_le : gateRowDev ≤ (1 : ℝ)/2^48 := by
  unfold gateRowDev gateRatio
  norm_num

theorem product_margins :
    (3072 : ℝ)*gateRowDev < 1 ∧
    productLo = 1-(3072 : ℝ)*gateRowDev ∧
    productHi = 1/(1-(3072 : ℝ)*gateRowDev) := by
  unfold productLo productHi gateRowDev gateRatio
  norm_num

theorem productLo_pos : 0 < productLo := by
  unfold productLo
  have hm := product_margins.1
  linarith

/- Exact product bounds for a 3072-coordinate tower with local base
   `gateRatio`; `productHi = 1/(1-3072*gateRowDev)` is the geometric
   majorant used already in T5ThetaNumeric.power_geometric_upper. -/
theorem product_lo_bound : productLo ≤ (1-gateRowDev)^3072 := by
  have hh := one_add_mul_le_pow (a := -gateRowDev)
    (by linarith [gate_row_dev_le]) 3072
  unfold productLo
  convert hh using 1
  ring

theorem product_hi_bound : (1+gateRowDev)^3072 ≤ productHi := by
  unfold productHi
  exact T5ThetaNumeric.power_geometric_upper gateRowDev gate_row_dev_pos.le
    (by linarith [gate_row_dev_le]) 3072
    (by unfold gateRowDev gateRatio; norm_num)

theorem product_sandwich {T : Tower 3072} (h : LocalExponent gateRatio T) :
    productLo*scale T ≤ total T ∧ total T ≤ productHi*scale T := by
  have hr0 : 0 < gateRatio := by unfold gateRatio; positivity
  have hr1 : gateRatio < 1 := by unfold gateRatio; norm_num
  have he : 2*gateRatio/(1-gateRatio) ≤ 1 := by
    have hh := gate_row_dev_le
    unfold gateRowDev gateRatio at hh
    unfold gateRatio
    linarith
  obtain ⟨hl,hu⟩ := triangular_mass_bounds T gateRatio hr0 hr1 he h
  have hx : 2*gateRatio/(1-gateRatio) = gateRowDev := rfl
  rw [hx] at hl hu
  exact ⟨(mul_le_mul_of_nonneg_right product_lo_bound
      (scale_positive T gateRatio h).le).trans hl,
    hu.trans (mul_le_mul_of_nonneg_right product_hi_bound
      (scale_positive T gateRatio h).le)⟩

/- Factors consumed by NormalizerComparison.finiteFlat_of_common_scale and
   RejectionNumericMargin.actual_rejection_from_tilted_normalizers. -/
theorem flat_factor_margins :
    (1-GuaranteedDigits.flatBudget)*productHi ≤ productLo ∧
    productHi ≤ (1+GuaranteedDigits.flatBudget)*productLo ∧
    productHi/productLo ≤ (17/16 : ℝ) := by
  unfold productLo productHi gateRowDev gateRatio GuaranteedDigits.flatBudget
  norm_num

/- Exact homogeneity of the continuous scale under a global tilt of the
   Gaussian exponent; this is the (8/7)^1536 factor between the two fiber
   scales alpha and alpha-alpha/8. -/
theorem continuousMass_sqrt (a : ℝ) : continuousMass a = 1/Real.sqrt a := by
  unfold continuousMass
  rw [← Real.sqrt_eq_rpow]

theorem continuousMass_scale (k a : ℝ) (hk : 0 < k) :
    continuousMass (k*a) = (1/Real.sqrt k)*continuousMass a := by
  rw [continuousMass_sqrt (k*a), continuousMass_sqrt a,
    Real.sqrt_mul hk.le]
  exact (one_div_mul_one_div (Real.sqrt k) (Real.sqrt a)).symm

theorem tilt_const_power : (1/Real.sqrt ((7 : ℝ)/8))^3072 = ((8 : ℝ)/7)^1536 := by
  have hsq : ((1/Real.sqrt ((7 : ℝ)/8))^2) = ((8 : ℝ)/7) := by
    rw [div_pow, one_pow, Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 7/8)]
    norm_num
  have hmul : (1/Real.sqrt ((7 : ℝ)/8))^3072 =
      ((1/Real.sqrt ((7 : ℝ)/8))^2)^1536 := by
    show (1/Real.sqrt ((7 : ℝ)/8))^(2*1536) = _
    rw [pow_mul]
  rw [hmul, hsq]

theorem scale_tilt_ratio (s : Fin 3072 → ℝ) :
    (∏ j, continuousMass ((7/8 : ℝ)*s j)) =
      ((8 : ℝ)/7)^1536 * ∏ j, continuousMass (s j) := by
  have hp : ∀ j : Fin 3072, continuousMass ((7/8 : ℝ)*s j) =
      (1/Real.sqrt ((7 : ℝ)/8))*continuousMass (s j) :=
    fun j => continuousMass_scale (7/8) (s j) (by norm_num)
  rw [show (∏ j : Fin 3072, continuousMass ((7/8 : ℝ)*s j))
      = ∏ j : Fin 3072, (1/Real.sqrt ((7 : ℝ)/8))*continuousMass (s j) from
      Finset.prod_congr rfl (fun j _ => hp j)]
  rw [Finset.prod_mul_distrib, Finset.prod_const, Finset.card_univ, Fintype.card_fin,
    tilt_const_power]

end FT1536.Run2.T5GateBudget
