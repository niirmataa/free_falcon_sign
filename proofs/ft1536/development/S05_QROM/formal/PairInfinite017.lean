import PairNormalizer017
import Run2.TriangularGaussian

set_option maxRecDepth 8192
namespace FT1536.S05.PairInfinite017
open FT1536.Geometry FT1536.Run2 ShiftedGaussian T5ScalarMass PairNormalizer017

noncomputable def atom (t : ℝ) (z : ℤ×ℤ) : ℝ := Real.exp (-t*(Geometry.block z.1 z.2 : ℝ)/1179648)
noncomputable def mass (t : ℝ) : ℝ := ∑' z : ℤ×ℤ,atom t z
noncomputable def tower (t : ℝ) : TriangularGaussian.Tower 2 :=
  .snoc (.snoc .nil (t*ax) (fun _ => 0)) (t*ay) (fun z => (z.2 : ℝ)/2)

def pairEquiv : (ℤ×ℤ) ≃ TriangularGaussian.Points 2 where
  toFun z := (((),z.1),z.2)
  invFun z := (z.1.2,z.2)
  left_inv _ := rfl
  right_inv z := by rcases z with ⟨⟨u,x⟩,y⟩; cases u; rfl

theorem atom_eq (t : ℝ) (z : ℤ×ℤ) : atom t z=TriangularGaussian.atom (tower t) (pairEquiv z) := by
  change Real.exp (-t*(Geometry.block z.1 z.2 : ℝ)/1179648)=
    (1*Real.exp (-Real.pi*(t*ax)*((z.1 : ℝ)+0)^2))*
      Real.exp (-Real.pi*(t*ay)*((z.2 : ℝ)+(z.1 : ℝ)/2)^2)
  rw [one_mul,add_zero,←Real.exp_add]
  unfold ax ay Geometry.block
  congr 1
  push_cast
  field_simp
  ring

theorem tower_local (t : ℝ) (ht : 0<t) (ht1 : t≤1) :
    TriangularGaussian.LocalExponent rowRatio (tower t) := by
  have hx : 0<t*ax := mul_pos ht coefficient_ranges.1
  have hy : 0<t*ay := mul_pos ht coefficient_ranges.2.2.1
  have hxu : t*ax≤maxCoefficient := by
    have hh := mul_le_mul_of_nonneg_right ht1 coefficient_ranges.1.le
    exact (by simpa only [one_mul] using hh : t*ax≤ax).trans coefficient_ranges.2.1
  have hyu : t*ay≤maxCoefficient := by
    have hh := mul_le_mul_of_nonneg_right ht1 coefficient_ranges.2.2.1.le
    exact (by simpa only [one_mul] using hh : t*ay≤ay).trans coefficient_ranges.2.2.2
  exact ⟨⟨trivial,hx,row_exponential_bound _ hx hxu⟩,hy,row_exponential_bound _ hy hyu⟩

theorem atom_summable (t : ℝ) (ht : 0<t) (ht1 : t≤1) : Summable (atom t) := by
  have hs := TriangularGaussian.tower_summable (tower t) rowRatio
    (by norm_num [rowRatio]) (by norm_num [rowRatio]) (tower_local t ht ht1)
  have hh := hs.comp_injective pairEquiv.injective
  simpa only [Function.comp_def,←atom_eq] using hh

theorem mass_eq_total (t : ℝ) : mass t=TriangularGaussian.total (tower t) := by
  unfold mass TriangularGaussian.total
  rw [←pairEquiv.tsum_eq (TriangularGaussian.atom (tower t))]
  exact tsum_congr (atom_eq t)

theorem mass_bounds (t : ℝ) (ht : 0<t) (ht1 : t≤1) :
    (1-2*rowRatio/(1-rowRatio))^2*(continuousMass (t*ax)*continuousMass (t*ay))≤mass t ∧
    mass t≤(1+2*rowRatio/(1-rowRatio))^2*(continuousMass (t*ax)*continuousMass (t*ay)) := by
  have hh := TriangularGaussian.triangular_mass_bounds (tower t) rowRatio
    (by norm_num [rowRatio]) (by norm_num [rowRatio]) (by norm_num [rowRatio]) (tower_local t ht ht1)
  simpa only [mass_eq_total,tower,TriangularGaussian.scale,one_mul] using hh

theorem continuous_lower (a K : ℝ) (ha : 0<a) (hK : 0≤K) (h : K^2*a≤1) :
    K≤continuousMass a := by
  unfold continuousMass
  rw [←Real.sqrt_eq_rpow]
  have hs := Real.sqrt_pos.mpr ha
  apply (le_div_iff₀ hs).mpr
  have he : (K*Real.sqrt a)^2=K^2*a := by rw [mul_pow,Real.sq_sqrt ha.le]
  have hn : 0≤K*Real.sqrt a := mul_nonneg hK hs.le
  nlinarith

theorem continuous_lower_caps : 2222≤continuousMass ax ∧ 1925≤continuousMass ay := by
  have hpi := Real.pi_gt_d4
  constructor
  · apply continuous_lower ax 2222 coefficient_ranges.1 (by norm_num)
    unfold ax
    rw [←mul_div_assoc]
    apply (div_le_iff₀ (by positivity)).mpr
    norm_num
    linarith
  · apply continuous_lower ay 1925 coefficient_ranges.2.2.1 (by norm_num)
    unfold ay
    rw [←mul_div_assoc]
    apply (div_le_iff₀ (by positivity)).mpr
    norm_num
    linarith

theorem continuous_quarter (a : ℝ) (ha : 0<a) : continuousMass ((1/4)*a)=2*continuousMass a := by
  unfold continuousMass
  rw [←Real.sqrt_eq_rpow,←Real.sqrt_eq_rpow,Real.sqrt_mul (by norm_num : (0 : ℝ)≤1/4)]
  have hs : Real.sqrt (1/4 : ℝ)=1/2 := by norm_num
  rw [hs]
  field_simp

theorem mass_one_lower : (4270000 : ℝ)≤mass 1 := by
  have hh := (mass_bounds 1 (by norm_num) le_rfl).1
  simp only [one_mul] at hh
  have hp := mul_le_mul continuous_lower_caps.1 continuous_lower_caps.2 (by norm_num : (0 : ℝ)≤1925)
    (continuousMass_positive _ coefficient_ranges.1).le
  calc
    _ ≤ (1-2*rowRatio/(1-rowRatio))^2*((2222 : ℝ)*1925) := by norm_num [rowRatio]
    _ ≤ (1-2*rowRatio/(1-rowRatio))^2*(continuousMass ax*continuousMass ay) :=
      mul_le_mul_of_nonneg_left hp (sq_nonneg _)
    _ ≤ _ := hh

theorem mass_quarter_upper : mass (1/4)≤17200000 := by
  have hh := (mass_bounds (1/4) (by norm_num) (by norm_num)).2
  rw [continuous_quarter ax coefficient_ranges.1,continuous_quarter ay coefficient_ranges.2.2.1] at hh
  have hx : 2*continuousMass ax≤4448 := by linarith [continuous_caps.1]
  have hy : 2*continuousMass ay≤3852 := by linarith [continuous_caps.2]
  have hp := mul_le_mul hx hy (mul_nonneg (by norm_num) (continuousMass_positive ay coefficient_ranges.2.2.1).le) (by norm_num : (0 : ℝ)≤4448)
  have hm := mul_le_mul_of_nonneg_left hp (sq_nonneg (1+2*rowRatio/(1-rowRatio)))
  exact (hh.trans hm).trans (by norm_num [rowRatio])

#print axioms atom_eq
#print axioms tower_local
#print axioms atom_summable
#print axioms mass_eq_total
#print axioms mass_bounds
#print axioms continuous_lower
#print axioms continuous_lower_caps
#print axioms continuous_quarter
#print axioms mass_one_lower
#print axioms mass_quarter_upper
end FT1536.S05.PairInfinite017
