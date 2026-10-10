import PairNormalizer017
import Mathlib.Analysis.Complex.Exponential

set_option exponentiation.threshold 100000
namespace FT1536.S05.SmallExp017
open Finset

noncomputable def taylor (x : ℝ) : ℝ := ∑ k ∈ range 48,x^k/(k.factorial : ℝ)

theorem taylor_lower (x : ℝ) (hx : 0≤x) : taylor x≤Real.exp x :=
  Real.sum_le_exp_of_nonneg hx 48

theorem taylor_upper (x : ℝ) (hx : 0≤x) (hu : x≤1/32) :
    Real.exp x≤taylor x+1/2^400 := by
  have hh := Real.exp_bound' hx (by linarith : x≤1) (n:=48) (by norm_num)
  have hp : x^48≤(1/32 : ℝ)^48 := pow_le_pow_left₀ hx hu 48
  have he : x^48*(48+1)/(Nat.factorial 48*48 : ℝ)≤1/2^400 := by
    have hm := mul_le_mul_of_nonneg_right hp (by norm_num : (0 : ℝ)≤48+1)
    have hd := div_le_div_of_nonneg_right hm (by positivity : (0 : ℝ)≤Nat.factorial 48*48)
    exact hd.trans (by norm_num [Nat.factorial])
  change Real.exp x≤taylor x+x^48*((48 : ℝ)+1)/(Nat.factorial 48*48 : ℝ) at hh
  linarith

noncomputable def step (k : ℕ) : ℝ := (2*(k : ℝ)+1)/2359296

theorem step_range (k : ℕ) (hk : k<30720) : 0≤step k ∧ step k≤1/32 := by
  have hr : (k : ℝ)<30720 := by exact_mod_cast hk
  have hn : (0 : ℝ)≤k := by positivity
  unfold step
  constructor <;> linarith

theorem step_exp_bounds (k : ℕ) (hk : k<30720) :
    taylor (step k)≤Real.exp (step k) ∧ Real.exp (step k)≤taylor (step k)+1/2^400 :=
  ⟨taylor_lower _ (step_range k hk).1,taylor_upper _ (step_range k hk).1 (step_range k hk).2⟩

#print axioms taylor_lower
#print axioms taylor_upper
#print axioms step_range
#print axioms step_exp_bounds
end FT1536.S05.SmallExp017
