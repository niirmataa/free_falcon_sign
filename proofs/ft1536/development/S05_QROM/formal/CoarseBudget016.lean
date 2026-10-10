import CapDomination016

set_option exponentiation.threshold 100000
namespace FT1536.S05.CoarseBudget016

/-- Avoid expanding a 1536th power into a huge rational certificate. -/
theorem bernoulli_reciprocal (x : ℝ) (hx : 0≤x) (n : ℕ) :
    (1+x)^n*(1-(n : ℝ)*x)≤1 := by
  induction n with
  | zero => simp
  | succ n ih =>
    have hn : 0≤(n : ℝ)+1 := by positivity
    have hs : (1+x)*(1-((n : ℝ)+1)*x)≤1-(n : ℝ)*x := by
      nlinarith [mul_nonneg hn (sq_nonneg x)]
    rw [pow_succ,Nat.cast_add,Nat.cast_one,mul_assoc]
    exact (mul_le_mul_of_nonneg_left hs (pow_nonneg (by linarith) n)).trans ih

theorem power_upper (x : ℝ) (hx : 0≤x) (n : ℕ) (hn : (n : ℝ)*x<1) :
    (1+x)^n≤1/(1-(n : ℝ)*x) :=
  (le_div_iff₀ (by linarith)).mpr (bernoulli_reciprocal x hx n)

noncomputable def pairFactor : ℝ := 1+1/2^72
noncomputable def C : ℝ := pairFactor^1536
noncomputable def r : ℝ := 1/2^24
noncomputable def R : ℝ := 2^4630
noncomputable def zeta : ℝ := 65/2^30

theorem C_bounds : 1≤C ∧ C≤1+1/2^61 := by
  constructor
  · exact one_le_pow₀ (by norm_num [pairFactor])
  · have hh := power_upper (1/(2 : ℝ)^72) (by norm_num) 1536 (by norm_num)
    exact hh.trans (by norm_num)

theorem rejection_budget : 0≤C*r ∧ C*r≤zeta ∧ zeta<1 := by
  have hC := C_bounds
  constructor
  · exact mul_nonneg (by linarith) (by norm_num [r])
  constructor
  · have hh := mul_le_mul_of_nonneg_right hC.2 (by norm_num [r] : 0≤r)
    exact hh.trans (by norm_num [r,zeta])
  · norm_num [zeta]

/-- The original attempted coarse 2^-70 claim is false for THIS envelope. -/
theorem fallback_envelope_range : 1/(2 : ℝ)^70<zeta^196*R ∧ zeta^196*R<1/2^69 := by
  norm_num [zeta,R]

theorem full_density_budget : 1+(C-1)/(1-C*r)+(C*r)^196*R≤1+1/2^60 := by
  have hc := C_bounds
  have hz := rejection_budget
  have hden : 0<1-zeta := by norm_num [zeta]
  have hden2 : 1-zeta≤1-C*r := by linarith
  have hratio := div_le_div_of_nonneg_left (by linarith : 0≤C-1) hden hden2
  have hnum : C-1≤1/2^61 := by linarith
  have hratio2 := div_le_div_of_nonneg_right hnum hden.le
  have hp := mul_le_mul_of_nonneg_right (pow_le_pow_left₀ hz.1 hz.2.1 196) (by unfold R; positivity : 0≤R)
  have hn : 1+(1/(2 : ℝ)^61)/(1-zeta)+1/2^69≤1+1/2^60 := by norm_num [zeta]
  have htail := fallback_envelope_range.2.le
  linarith

#print axioms bernoulli_reciprocal
#print axioms power_upper
#print axioms C_bounds
#print axioms rejection_budget
#print axioms fallback_envelope_range
#print axioms full_density_budget
end FT1536.S05.CoarseBudget016
