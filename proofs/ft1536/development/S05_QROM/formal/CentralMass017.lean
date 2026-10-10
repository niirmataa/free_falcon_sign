import PairTail017

set_option maxRecDepth 8192
set_option exponentiation.threshold 100000
namespace FT1536.S05.CentralMass017
open Finset FT1536.Run2 RawProductLaw PairInfinite017 PairTail017

def central (z : ℤ×ℤ) : Prop := |z.1|≤15360 ∧ |z.2|≤15360 ∧ |z.1+z.2|≤15360
instance : DecidablePred central := fun z => inferInstanceAs (Decidable (|z.1|≤15360 ∧ |z.2|≤15360 ∧ |z.1+z.2|≤15360))

theorem large_square (x : ℤ) (hx : 15360 < |x|) : (15361 : ℤ)^2≤x^2 := by
  have ha : (15361 : ℤ)≤|x| := by omega
  nlinarith [sq_abs x]

theorem outside_energy (z : ℤ×ℤ) (hz : ¬central z) :
    (3 : ℝ)*15361^2/4≤(FT1536.Geometry.block z.1 z.2 : ℝ) := by
  have hh : (3 : ℤ)*15361^2≤4*FT1536.Geometry.block z.1 z.2 := by
    unfold central at hz
    push Not at hz
    by_cases hx : |z.1|≤15360
    · by_cases hy : |z.2|≤15360
      · have hs := large_square (z.1+z.2) (hz hx hy)
        unfold FT1536.Geometry.block
        nlinarith [sq_nonneg (z.1-z.2)]
      · have hs := large_square z.2 (by omega)
        unfold FT1536.Geometry.block
        nlinarith [sq_nonneg (2*z.1+z.2)]
    · have hs := large_square z.1 (by omega)
      unfold FT1536.Geometry.block
      nlinarith [sq_nonneg (z.1+2*z.2)]
  have hh' : (3 : ℝ)*15361^2≤4*(FT1536.Geometry.block z.1 z.2 : ℝ) := by exact_mod_cast hh
  linarith

theorem exp_central_tail :
    Real.exp (-(3/4 : ℝ)*(3*15361^2/4)/1179648)≤1/2^160 := by
  have hl := Real.log_two_lt_d9
  have hh : -(3/4 : ℝ)*(3*15361^2/4)/1179648≤ -(160 : ℝ)*Real.log 2 := by linarith
  have he := Real.exp_nat_mul (Real.log 2) 160
  norm_num only [Nat.cast_ofNat] at he
  rw [Real.exp_log (by norm_num : (0 : ℝ)<2)] at he
  calc
    _ ≤ Real.exp (-(160 : ℝ)*Real.log 2) := Real.exp_le_exp.mpr hh
    _ = _ := by rw [neg_mul,Real.exp_neg,he,one_div]

attribute [local irreducible] finiteAtoms

theorem discarded_mass :
    (∑ z∈finiteAtoms.filter (fun z => ¬central z),atom 1 z)≤1/(2 : ℝ)^135 := by
  have ht := finite_tail (finiteAtoms.filter (fun z => ¬central z)) (3*15361^2/4)
    (fun z hz => outside_energy z (by
      have hz' : z∈finiteAtoms ∧ ¬central z := Finset.mem_filter.mp hz
      exact hz'.2))
  have hm := mul_le_mul exp_central_tail mass_quarter_upper
    (tsum_nonneg (fun _ => (Real.exp_pos _).le)) (by positivity : (0 : ℝ)≤1/2^160)
  exact (ht.trans hm).trans (by norm_num)

theorem central_mass : (1-1/(2 : ℝ)^130)*blockNormalizer≤
    ∑ z∈finiteAtoms.filter central,atom 1 z := by
  have he := sum_filter_add_sum_filter_not finiteAtoms central (atom 1)
  rw [←finite_mass] at he
  have hn := block_normalizer_lower
  have ht := discarded_mass
  have hn' : (1 : ℝ)/2^135≤blockNormalizer/2^130 := by
    apply (div_le_div_iff₀ (by positivity) (by positivity)).mpr
    nlinarith
  nlinarith

#print axioms large_square
#print axioms outside_energy
#print axioms exp_central_tail
#print axioms discarded_mass
#print axioms central_mass
end FT1536.S05.CentralMass017
