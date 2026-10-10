import GaussianSandwich017
import GaussianCheck017

set_option maxRecDepth 8192
set_option exponentiation.threshold 100000
namespace FT1536.S05.GaussianLiterals017
open GaussianCheck017 GaussianData017 GaussianSandwich017

def Rows : Prop := ∀ i, i < 61441 → row i=true

theorem recurrence (rows : Rows) (k : ℕ) (hk : k < 30720) :
    lower (k+1)*(GaussianPolynomial017.numerator (2*k+1)*2^400+GaussianPolynomial017.denominator)≤
      lower k*GaussianPolynomial017.denominator*2^400 ∧
    upper k*GaussianPolynomial017.denominator≤upper (k+1)*GaussianPolynomial017.numerator (2*k+1) := by
  have hh := rows k (by omega)
  simp only [row,Bool.and_eq_true] at hh
  simpa only [ite_eq_left hk,recurrenceCheck,decide_eq_true_eq] using hh.1.1

theorem certificate (rows : Rows) : Certificate lower upper where
  lower_zero := initial_lower
  upper_zero := initial_upper
  lower_step k hk := (recurrence rows k hk).1
  upper_step k hk := (recurrence rows k hk).2

theorem cdf_rows (rows : Rows) (i : ℕ) (hi : i < 30721) :
    previous i<TableData016.cdf i ∧
    weight i*2^236≤(2^108+1)*lower ((i : ℤ)-15360).natAbs ∧
    (2^108-1)*upper ((i : ℤ)-15360).natAbs≤weight i*2^236 := by
  have hh := rows i (by omega)
  simp only [row,Bool.and_eq_true] at hh
  simpa only [ite_eq_left hi,cdfCheck,decide_eq_true_eq] using hh.1.2

theorem threshold_rows (rows : Rows) (i : ℕ) (hi : i < 61441) :
    TableData016.threshold i*2^128≤lower ((i : ℤ)-30720).natAbs ∧
    (((i : ℤ)-30720).natAbs≤15360 →
      (2^108-1)*upper ((i : ℤ)-30720).natAbs≤TableData016.threshold i*2^236) := by
  have hh := rows i hi
  simp only [row,Bool.and_eq_true] at hh
  simpa only [thresholdCheck,decide_eq_true_eq] using hh.2

theorem dyadic_bounds (W L U : ℕ) (g : ℝ)
    (hL : (L : ℝ)≤2^384*g) (hU : 2^384*g≤(U : ℝ))
    (hWL : W*2^236≤(2^108+1)*L) (hWU : (2^108-1)*U≤W*2^236) :
    (1-1/(2 : ℝ)^108)*g≤(W : ℝ)/2^256 ∧
    (W : ℝ)/2^256≤(1+1/(2 : ℝ)^108)*g := by
  have hl : (W : ℝ)*2^236≤(2^108+1)*(L : ℝ) := by exact_mod_cast hWL
  have hu : ((2 : ℝ)^108-1)*(U : ℝ)≤(W : ℝ)*2^236 := by
    have h := hWU
    norm_num at h ⊢
    exact_mod_cast h
  have h1 := mul_le_mul_of_nonneg_left hL (by norm_num : (0 : ℝ)≤2^108+1)
  have h2 := mul_le_mul_of_nonneg_left hU (by norm_num : (0 : ℝ)≤2^108-1)
  constructor <;> nlinarith

theorem weight_bounds (rows : Rows) (i : ℕ) (hi : i < 30721) :
    (1-1/(2 : ℝ)^108)*gaussian ((i : ℤ)-15360).natAbs≤(weight i : ℝ)/2^256 ∧
    (weight i : ℝ)/2^256≤(1+1/(2 : ℝ)^108)*gaussian ((i : ℤ)-15360).natAbs := by
  have hk : ((i : ℤ)-15360).natAbs≤30720 := by omega
  have hg := certificate_sound lower upper (certificate rows) _ hk
  have hc := cdf_rows rows i hi
  exact dyadic_bounds _ _ _ _ hg.1 hg.2 hc.2.1 hc.2.2

theorem threshold_upper (rows : Rows) (i : ℕ) (hi : i < 61441) :
    (TableData016.threshold i : ℝ)/2^256≤gaussian ((i : ℤ)-30720).natAbs := by
  have hk : ((i : ℤ)-30720).natAbs≤30720 := by omega
  have hg := (certificate_sound lower upper (certificate rows) _ hk).1
  have hc : (TableData016.threshold i : ℝ)*2^128≤(lower ((i : ℤ)-30720).natAbs : ℝ) := by
    exact_mod_cast (threshold_rows rows i hi).1
  nlinarith

theorem threshold_lower (rows : Rows) (i : ℕ) (hi : i < 61441)
    (hk : ((i : ℤ)-30720).natAbs≤15360) :
    (1-1/(2 : ℝ)^108)*gaussian ((i : ℤ)-30720).natAbs≤(TableData016.threshold i : ℝ)/2^256 := by
  have hg := (certificate_sound lower upper (certificate rows) ((i : ℤ)-30720).natAbs (by omega)).2
  have hc : ((2 : ℝ)^108-1)*(upper ((i : ℤ)-30720).natAbs : ℝ)≤(TableData016.threshold i : ℝ)*2^236 := by
    have h := (threshold_rows rows i hi).2 hk
    norm_num at h ⊢
    exact_mod_cast h
  have hm := mul_le_mul_of_nonneg_left hg (by norm_num : (0 : ℝ)≤2^108-1)
  nlinarith

theorem gaussian_le_one (k : ℕ) : gaussian k≤1 := by
  apply Real.exp_le_one_iff.mpr
  unfold GaussianPolynomial017.c
  exact div_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr (sq_nonneg _)) (by norm_num)

theorem threshold_cap (rows : Rows) (i : ℕ) (hi : i < 61441) : TableData016.threshold i≤2^256 := by
  have hh := (threshold_upper rows i hi).trans (gaussian_le_one _)
  have hh' : (TableData016.threshold i : ℝ)≤2^256 := by linarith
  exact_mod_cast hh'

#print axioms recurrence
#print axioms certificate
#print axioms cdf_rows
#print axioms threshold_rows
#print axioms dyadic_bounds
#print axioms weight_bounds
#print axioms threshold_upper
#print axioms threshold_lower
#print axioms gaussian_le_one
#print axioms threshold_cap
end FT1536.S05.GaussianLiterals017
