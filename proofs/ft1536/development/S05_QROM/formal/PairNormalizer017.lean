import ImplementationBridge016
import Run2.T5ScalarMass
import Mathlib.Analysis.Real.Pi.Bounds

set_option maxRecDepth 8192
namespace FT1536.S05.PairNormalizer017
open Finset FT1536.Geometry FT1536.Run2
open RawProductLaw ShiftedGaussian T5ScalarMass

noncomputable def ax : ℝ := 3/(4*1179648*Real.pi)
noncomputable def ay : ℝ := 1/(1179648*Real.pi)
noncomputable def rowFactor : ℝ := 1+2*rowRatio/(1-rowRatio)

theorem coefficient_ranges : 0<ax ∧ ax≤maxCoefficient ∧ 0<ay ∧ ay≤maxCoefficient := by
  have hp := Real.pi_pos
  refine ⟨by unfold ax; positivity,?_,by unfold ay; positivity,?_⟩
  · unfold ax maxCoefficient
    apply (div_le_div_iff₀ (by positivity) (by positivity)).mpr
    nlinarith
  · unfold ay maxCoefficient
    apply (div_le_div_iff₀ (by positivity) (by positivity)).mpr
    nlinarith

theorem continuous_upper (a K : ℝ) (ha : 0<a) (hK : 0≤K) (h : 1≤K^2*a) :
    continuousMass a≤K := by
  unfold continuousMass
  rw [←Real.sqrt_eq_rpow]
  have hs := Real.sqrt_pos.mpr ha
  apply (div_le_iff₀ hs).mpr
  have he : (K*Real.sqrt a)^2=K^2*a := by rw [mul_pow,Real.sq_sqrt ha.le]
  have hn : 0≤K*Real.sqrt a := mul_nonneg hK hs.le
  nlinarith

theorem continuous_caps : continuousMass ax≤2224 ∧ continuousMass ay≤1926 := by
  have hp := Real.pi_pos
  have hpi := Real.pi_lt_d4
  constructor
  · apply continuous_upper ax 2224 coefficient_ranges.1 (by norm_num)
    unfold ax
    rw [←mul_div_assoc]
    apply (le_div_iff₀ (by positivity)).mpr
    norm_num
    linarith
  · apply continuous_upper ay 1926 coefficient_ranges.2.2.1 (by norm_num)
    unfold ay
    rw [←mul_div_assoc]
    apply (le_div_iff₀ (by positivity)).mpr
    norm_num
    linarith

def decodeCoord (i : Fin 131071) : ℤ := (i.val : ℤ)-65535

theorem decode_injective : Function.Injective decodeCoord := by
  intro i j he
  apply Fin.ext
  unfold decodeCoord at he
  omega

theorem finite_shifted_le {I : Type} [Fintype I] (e : I → ℤ) (he : Function.Injective e)
    (a t : ℝ) (ha : 0<a) :
    (∑ i,Real.exp (-Real.pi*a*((e i : ℝ)+t)^2))≤shiftedMass a t := by
  let f : ℤ → ℝ := fun z => Real.exp (-Real.pi*a*((z : ℝ)+t)^2)
  have hi : Summable (fun i : I => f (e i)) := (hasSum_fintype _).summable
  have hz : Summable f := shifted_summable a t ha
  have hh := Summable.tsum_le_tsum_of_inj (f:=fun i : I => f (e i)) (g:=f) e he
    (fun _ _ => (Real.exp_pos _).le) (fun _ => le_rfl) hi hz
  rw [tsum_fintype] at hh
  exact hh

theorem finite_shifted_bound (a t K : ℝ) (ha : 0<a) (hu : a≤maxCoefficient)
    (hK : continuousMass a≤K) :
    (∑ i : Fin 131071,Real.exp (-Real.pi*a*((decodeCoord i : ℝ)+t)^2))≤rowFactor*K := by
  have hb := (shifted_mass_bounds a t rowRatio ha (by norm_num [rowRatio])
    (by norm_num [rowRatio]) (row_exponential_bound a ha hu)).2
  have hc := mul_le_mul_of_nonneg_left hK (by norm_num [rowFactor,rowRatio] : 0≤rowFactor)
  exact (finite_shifted_le decodeCoord decode_injective a t ha).trans (hb.trans hc)

theorem block_weight_split (x y : Fin 131071) :
    blockWeight (x,y)=Real.exp (-Real.pi*ax*(decodeCoord x : ℝ)^2)*
      Real.exp (-Real.pi*ay*((decodeCoord y : ℝ)+(decodeCoord x : ℝ)/2)^2) := by
  rw [←Real.exp_add]
  unfold blockWeight blockEnergy blockDecode decodeCoord Geometry.block ax ay
  congr 1
  push_cast
  field_simp
  ring

theorem block_normalizer_upper : blockNormalizer≤4300000 := by
  unfold blockNormalizer
  rw [Fintype.sum_prod_type]
  simp_rw [block_weight_split,←mul_sum]
  have hx := finite_shifted_bound ax 0 2224 coefficient_ranges.1 coefficient_ranges.2.1 continuous_caps.1
  simp only [add_zero] at hx
  have hy (x : Fin 131071) := finite_shifted_bound ay ((decodeCoord x : ℝ)/2) 1926
    coefficient_ranges.2.2.1 coefficient_ranges.2.2.2 continuous_caps.2
  calc
    _ ≤ ∑ x : Fin 131071,Real.exp (-Real.pi*ax*(decodeCoord x : ℝ)^2)*(rowFactor*1926) :=
      sum_le_sum (fun x _ => mul_le_mul_of_nonneg_left (hy x) (Real.exp_pos _).le)
    _ = (∑ x : Fin 131071,Real.exp (-Real.pi*ax*(decodeCoord x : ℝ)^2))*(rowFactor*1926) :=
      (sum_mul _ _ _).symm
    _ ≤ (rowFactor*2224)*(rowFactor*1926) :=
      mul_le_mul_of_nonneg_right hx (by norm_num [rowFactor,rowRatio])
    _ ≤ _ := by norm_num [rowFactor,rowRatio]

theorem zero_mass_instance : 1/(2 : ℝ)^23≤blockLaw.mass SamplerCode016.zeroBlock := by
  have hg := blockNormalizer_pos
  have hu := block_normalizer_upper
  have hz : blockWeight SamplerCode016.zeroBlock=1 := by
    norm_num [blockWeight,blockEnergy,blockDecode,SamplerCode016.zeroBlock,Geometry.block]
  change 1/(2 : ℝ)^23≤blockWeight SamplerCode016.zeroBlock/blockNormalizer
  rw [hz]
  exact one_div_le_one_div_of_le hg (hu.trans (by norm_num))

#print axioms coefficient_ranges
#print axioms continuous_upper
#print axioms continuous_caps
#print axioms decode_injective
#print axioms finite_shifted_le
#print axioms finite_shifted_bound
#print axioms block_weight_split
#print axioms block_normalizer_upper
#print axioms zero_mass_instance
end FT1536.S05.PairNormalizer017
