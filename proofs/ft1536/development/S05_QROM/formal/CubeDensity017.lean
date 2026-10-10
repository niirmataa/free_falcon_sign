import PairNormalizer017
import CubeUniform017
import RawConditioning016

set_option maxRecDepth 8192
set_option exponentiation.threshold 100000
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype
namespace FT1536.S05.CubeDensity017
open Finset FT1536.Geometry FT1536.PublicSimulation FT1536.Run2
open LegalKeyErrorTransfer RawProductLaw AcceptedMarginal015
open PairNormalizer017 CubeUniform017 RawConditioning016 ProgramLaw016

noncomputable def fullUpper : ℝ := 4300000^1536

theorem accepted_total_upper : acceptedTotal≤fullUpper := by
  have hs : acceptedTotal≤totalWeight := by
    unfold acceptedTotal
    rw [RawProductLaw.legacy_box_sum,RawProductLaw.totalWeight_as_sum]
    apply sum_le_sum
    intro z _
    unfold boundedWeight
    split_ifs
    · rfl
    · exact (Real.exp_pos _).le
  have ht : totalWeight≤fullUpper := by
    rw [actual_normalizer_product]
    exact pow_le_pow_left₀ blockNormalizer_pos.le block_normalizer_upper 1536
  exact hs.trans ht

theorem bounded_mass (z : BoxPair) (hz : Q (decode z)<B) :
    boundedRaw.mass z=gaussianWeight z/acceptedTotal := by
  rw [conditioned_mass]
  change boundedWeight z/acceptedTotal=gaussianWeight z/acceptedTotal
  rw [boundedWeight,ite_eq_left hz]

theorem exp_cube_upper : Real.exp (1024 : ℝ)≤(2 : ℝ)^1500 := by
  have hl := Real.log_two_gt_d9
  have hx : (1024 : ℝ)≤1500*Real.log 2 := by linarith
  have he := Real.exp_nat_mul (Real.log 2) 1500
  norm_num only [Nat.cast_ofNat] at he
  rw [Real.exp_log (by norm_num : (0 : ℝ)<2)] at he
  exact (Real.exp_le_exp.mpr hx).trans_eq he

theorem scalar_density_budget : fullUpper*Real.exp 1024/(2 : ℝ)^30720≤CoarseBudget016.R := by
  have hh := mul_le_mul_of_nonneg_left exp_cube_upper (by unfold fullUpper; positivity : 0≤fullUpper)
  have hd := div_le_div_of_nonneg_right hh (by positivity : 0≤(2 : ℝ)^30720)
  exact hd.trans (by norm_num [fullUpper,CoarseBudget016.R])

theorem support_weight (z : BoxPair) (hz : Q (decode z)≤1207959552) :
    1≤Real.exp 1024*gaussianWeight z := by
  have hq : (Q (decode z) : ℝ)≤1207959552 := by exact_mod_cast hz
  unfold gaussianWeight
  rw [←Real.exp_add]
  apply Real.one_le_exp_iff.mpr
  norm_num
  linarith

theorem density_transfer (u w Z F E N : ℝ) (hZ : 0<Z) (hN : 0<N)
    (hF : Z≤F) (hw : 1≤E*w) (hu : u≤1/N) : u≤(F*E/N)*(w/Z) := by
  have hF0 : 0≤F := (hZ.trans_le hF).le
  have hh := mul_le_mul_of_nonneg_left hw hF0
  have hquot : 1≤(F*E*w)/Z := by
    apply (le_div_iff₀ hZ).mpr
    nlinarith
  have hd := div_le_div_of_nonneg_right hquot hN.le
  exact hu.trans (by convert hd using 1; ring)

theorem cube_leaf_instance : ImplementationBridge016.CubeLeaf := by
  intro z
  by_cases hz : cubeLaw.mass z=0
  · rw [hz]
    exact mul_nonneg (by unfold CoarseBudget016.R; positivity) (boundedRaw.nonneg z)
  · have hnorm := cube_support_norm z hz
    have hgood : Q (decode z)<B := hnorm.trans_lt (by norm_num [B])
    have hd := density_transfer (cubeLaw.mass z) (gaussianWeight z) acceptedTotal fullUpper
      (Real.exp 1024) ((2 : ℝ)^30720) bounded_normalizer_pos (by positivity)
      accepted_total_upper (support_weight z hnorm) (cube_atom_bound z)
    have he := bounded_mass z hgood
    rw [←he] at hd
    exact hd.trans (mul_le_mul_of_nonneg_right scalar_density_budget (boundedRaw.nonneg z))

#print axioms accepted_total_upper
#print axioms bounded_mass
#print axioms exp_cube_upper
#print axioms scalar_density_budget
#print axioms support_weight
#print axioms density_transfer
#print axioms cube_leaf_instance
end FT1536.S05.CubeDensity017
