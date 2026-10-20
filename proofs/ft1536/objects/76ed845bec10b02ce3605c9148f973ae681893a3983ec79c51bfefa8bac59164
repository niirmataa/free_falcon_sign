import Run2.A2Theta
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Analysis.Complex.ExponentialBounds

namespace FT1536.Run2.T5ThetaNumeric
open Finset A2Theta

noncomputable def kappa : ℝ := 8*Real.pi^2*768^2/(3*18433^2)
noncomputable def dyadic : ℝ := 1/2^65
noncomputable def blockBudget : ℝ := 1/2^61

theorem kappa_positive : 0 < kappa := by unfold kappa; positivity

theorem leaf_exponent (leaf : ℝ) (hl : 991 ≤ leaf) :
    (65 : ℝ)*Real.log 2 < kappa*leaf := by
  have hp := Real.pi_gt_d2
  have hp0 := Real.pi_pos
  have hps : (314/100 : ℝ)^2 < Real.pi^2 := by nlinarith
  have hlog := Real.log_two_lt_d9
  have hbase : (65 : ℝ)*Real.log 2 < kappa*991 := by
    unfold kappa
    norm_num at hps ⊢
    nlinarith
  exact hbase.trans_le (mul_le_mul_of_nonneg_left hl kappa_positive.le)

theorem dyadic_base (leaf : ℝ) (hl : 991 ≤ leaf) :
    Real.exp (-(kappa*leaf)) ≤ dyadic := by
  have he : Real.exp (-(65 : ℝ)*Real.log 2) = dyadic := by
    have hh := Real.exp_nat_mul (Real.log 2) 65
    norm_num only [Nat.cast_ofNat] at hh
    rw [Real.exp_log (by norm_num : (0 : ℝ)<2)] at hh
    rw [neg_mul, Real.exp_neg, hh]
    simp only [dyadic, one_div]
  rw [← he]
  exact Real.exp_le_exp.mpr (by linarith [leaf_exponent leaf hl])

theorem one_block (leaf : ℝ) (hl : 991 ≤ leaf) :
    (∑' z : ℤ×ℤ, gaussianAtom (kappa*leaf) z) ≤ 1+blockBudget := by
  have hk : 0 < kappa*leaf := mul_pos kappa_positive (by linarith)
  have hh := gaussian_theta_bound (kappa*leaf) dyadic hk
    (by norm_num [dyadic]) (by norm_num [dyadic]) (dyadic_base leaf hl)
  have hn : 8*dyadic/(1-dyadic)^2 ≤ blockBudget := by
    norm_num [dyadic, blockBudget]
  linarith only [hh, hn]

theorem power_geometric_upper (a : ℝ) (ha : 0 ≤ a) (ha1 : a ≤ 1) (n : ℕ)
    (hn : (n : ℝ)*a < 1) : (1+a)^n ≤ 1/(1-(n : ℝ)*a) := by
  have hb : 1-(n : ℝ)*a ≤ (1-a)^n := by
    have hh := one_add_mul_le_pow (a := -a) (by linarith : -2 ≤ -a) n
    convert hh using 1
    ring
  apply (le_div_iff₀ (by linarith : 0 < 1-(n : ℝ)*a)).2
  calc
    _ ≤ (1+a)^n*(1-a)^n :=
      mul_le_mul_of_nonneg_left hb (pow_nonneg (by linarith) _)
    _ = ((1-a)*(1+a))^n := by rw [mul_pow]; ring
    _ ≤ 1 := pow_le_one₀ (mul_nonneg (by linarith) (by linarith))
      (by nlinarith [sq_nonneg a])

theorem factor1536_margin : (1+blockBudget)^1536-1 < 1/(2 : ℝ)^40 := by
  have hp := power_geometric_upper blockBudget (by norm_num [blockBudget])
    (by norm_num [blockBudget]) 1536 (by norm_num [blockBudget])
  have hn : 1/(1-(1536 : ℝ)*blockBudget)-1 < 1/(2 : ℝ)^40 := by
    norm_num [blockBudget]
  exact (sub_le_sub_right hp 1).trans_lt hn

/- This proves the numerical infinite-theta part for arbitrary real leaves,
   rather than checking a few finite lattices. The source-to-leaf and shifted
   lattice decomposition are distinct obligations and are not asserted here. -/
theorem centered_product_theta (leaf : Fin 1536 → ℝ) (hl : ∀ j, 991 ≤ leaf j) :
    (∏ j, ∑' z : ℤ×ℤ, gaussianAtom (kappa*leaf j) z)-1 < 1/(2 : ℝ)^40 := by
  have hp : (∏ j, ∑' z : ℤ×ℤ, gaussianAtom (kappa*leaf j) z) ≤
      (1+blockBudget)^1536 := by
    calc
      _ ≤ ∏ _j : Fin 1536, (1+blockBudget) := prod_le_prod₀
        (fun _ _ => tsum_nonneg fun z => (Real.exp_pos _).le)
        (fun j _ => one_block (leaf j) (hl j))
      _ = _ := by simp
  exact (sub_le_sub_right hp 1).trans_lt factor1536_margin

end FT1536.Run2.T5ThetaNumeric
