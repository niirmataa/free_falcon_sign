import GaussianPolynomial017

set_option maxRecDepth 8192
set_option exponentiation.threshold 100000
namespace FT1536.S05.GaussianSandwich017
open GaussianPolynomial017 SmallExp017

noncomputable def gaussian (k : ℕ) : ℝ := Real.exp (-(k : ℝ)^2/(c : ℝ))

structure Certificate (L U : ℕ → ℕ) : Prop where
  lower_zero : L 0=2^384
  upper_zero : U 0=2^384
  lower_step : ∀ k,k<30720 →
    L (k+1)*(numerator (2*k+1)*2^400+denominator)≤L k*denominator*2^400
  upper_step : ∀ k,k<30720 →
    U k*denominator≤U (k+1)*numerator (2*k+1)

theorem gaussian_step (k : ℕ) : gaussian (k+1)=gaussian k*Real.exp (-step k) := by
  unfold gaussian step c
  rw [←Real.exp_add]
  congr 1
  push_cast
  ring

theorem lower_transition (L U : ℕ → ℕ) (cert : Certificate L U) (k : ℕ) (hk : k<30720) :
    (L (k+1) : ℝ)≤(L k : ℝ)*Real.exp (-step k) := by
  have hD : (0 : ℝ)<denominator := by exact_mod_cast denominator_positive
  have hB : (0 : ℝ)<(2 : ℝ)^400 := by positivity
  have hNat : (L (k+1) : ℝ)*((numerator (2*k+1) : ℝ)*2^400+denominator)≤
      (L k : ℝ)*denominator*2^400 := by exact_mod_cast cert.lower_step k hk
  have heq : (L (k+1) : ℝ)*((numerator (2*k+1) : ℝ)/denominator+1/2^400)=
      (L (k+1) : ℝ)*((numerator (2*k+1) : ℝ)*2^400+denominator)/(denominator*2^400) := by
    field_simp
  have hFrac : (L (k+1) : ℝ)*((numerator (2*k+1) : ℝ)/denominator+1/2^400)≤(L k : ℝ) := by
    rw [heq]
    apply (div_le_iff₀ (mul_pos hD hB)).mpr
    nlinarith
  have hExp := mul_le_mul_of_nonneg_left (step_polynomial_bounds k hk).2
    (by positivity : (0 : ℝ)≤L (k+1))
  have hm := mul_le_mul_of_nonneg_right (hExp.trans hFrac) (Real.exp_pos (-step k)).le
  have hc : Real.exp (step k)*Real.exp (-step k)=1 := by rw [←Real.exp_add]; simp
  simpa only [mul_assoc,hc,mul_one] using hm

theorem upper_transition (L U : ℕ → ℕ) (cert : Certificate L U) (k : ℕ) (hk : k<30720) :
    (U k : ℝ)*Real.exp (-step k)≤(U (k+1) : ℝ) := by
  have hD : (0 : ℝ)<denominator := by exact_mod_cast denominator_positive
  have hNat : (U k : ℝ)*denominator≤(U (k+1) : ℝ)*numerator (2*k+1) := by
    exact_mod_cast cert.upper_step k hk
  have hFrac : (U k : ℝ)≤(U (k+1) : ℝ)*((numerator (2*k+1) : ℝ)/denominator) := by
    rw [←mul_div_assoc]
    exact (le_div_iff₀ hD).mpr hNat
  have hExp := mul_le_mul_of_nonneg_left (step_polynomial_bounds k hk).1
    (by positivity : (0 : ℝ)≤U (k+1))
  have hm := mul_le_mul_of_nonneg_right (hFrac.trans hExp) (Real.exp_pos (-step k)).le
  have hc : Real.exp (step k)*Real.exp (-step k)=1 := by rw [←Real.exp_add]; simp
  simpa only [mul_assoc,hc,mul_one] using hm

theorem certificate_sound (L U : ℕ → ℕ) (cert : Certificate L U) (k : ℕ) (hk : k≤30720) :
    (L k : ℝ)≤(2 : ℝ)^384*gaussian k ∧ (2 : ℝ)^384*gaussian k≤(U k : ℝ) := by
  induction k with
  | zero =>
    rw [cert.lower_zero,cert.upper_zero]
    norm_num [gaussian]
  | succ k ih =>
    have hk' : k<30720 := by omega
    have hp := ih (by omega)
    rw [gaussian_step]
    constructor
    · have hh := mul_le_mul_of_nonneg_right hp.1 (Real.exp_pos (-step k)).le
      exact (lower_transition L U cert k hk').trans (by simpa only [mul_assoc] using hh)
    · have hh := mul_le_mul_of_nonneg_right hp.2 (Real.exp_pos (-step k)).le
      have hm : (2 : ℝ)^384*(gaussian k*Real.exp (-step k))≤(U k : ℝ)*Real.exp (-step k) := by
        simpa only [mul_assoc] using hh
      exact hm.trans (upper_transition L U cert k hk')

#print axioms gaussian_step
#print axioms lower_transition
#print axioms upper_transition
#print axioms certificate_sound
end FT1536.S05.GaussianSandwich017
