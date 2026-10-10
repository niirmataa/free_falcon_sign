import BoxSupport015
import Run2.NormalizerComparison

set_option exponentiation.threshold 100000
namespace FT1536.S05.BoxTail015
open FT1536.Geometry FT1536.Relation FT1536.PublicSimulation
open FT1536.Run2 FT1536.Run2.GaussianFiberTilt
open BoxSupport015 SamplerMassCondition014

noncomputable def eps : ℝ := 1/2^34
noncomputable def lower : ℝ := 1-eps-1/2^160
noncomputable def upper : ℝ := 1+eps
noncomputable def tN : ℝ := 1811939328/2093922385

def Bounds (h : Rq) (K : ℝ) : Prop := ∀ c t, Temperature t →
  (1-eps)*(t⁻¹)^1536*K≤ActualMass014.fullMass h c (t/1179648) ∧
  ActualMass014.fullMass h c (t/1179648)≤upper*(t⁻¹)^1536*K

theorem mass_of_bounds (h : Rq) (K : ℝ) (hK : 0<K) (hb : Bounds h K) : MassCondition h :=
  ⟨K,hK,hb⟩

theorem outside_atom (h c : Rq) (t : ℝ) (ht : t≤1)
    (z : {z : Fiber h c // z ∉ boxFiber h c}) :
    atom (1/1179648) z.val≤Real.exp (-(1-t)*3221225472/1179648)*atom (t/1179648) z.val := by
  have he : (3221225472 : ℝ)≤(Q z.val.val : ℝ) := by
    exact_mod_cast outside_energy h c z.val z.prop
  unfold atom
  rw [←Real.exp_add]
  apply Real.exp_le_exp.mpr
  nlinarith [mul_nonneg (sub_nonneg.mpr ht) (sub_nonneg.mpr he)]

theorem box_tail (h : Rq) (hm : MassCondition h) (c : Rq) (t : ℝ)
    (ht : Temperature t) :
    ActualMass014.fullMass h c (1/1179648)-fiberMass h c (1/1179648)≤
      Real.exp (-(1-t)*3221225472/1179648)*ActualMass014.fullMass h c (t/1179648) := by
  have hs1 := summable_of_mass h hm c 1 (Or.inl rfl)
  have hst := summable_of_mass h hm c t ht
  have hs1' := hs1.subtype (fun z => z ∉ boxFiber h c)
  have hst' := hst.subtype (fun z => z ∉ boxFiber h c)
  have hsplit := finite_add_tail h c (1/1179648) (by simpa using hs1)
  have ht1 := (temperature_range t ht).2
  have ht_bound := Summable.tsum_le_tsum (fun z => outside_atom h c t ht1 z) hs1'
    (hst'.mul_left (Real.exp (-(1-t)*3221225472/1179648)))
  rw [tsum_mul_left] at ht_bound
  have hsub : (∑' z : {z : Fiber h c // z ∉ boxFiber h c}, atom (t/1179648) z.val)≤
      ActualMass014.fullMass h c (t/1179648) := by
    exact Summable.tsum_subtype_le _ _ (fun z => (Real.exp_pos _).le) hst
  have hh := ht_bound.trans (mul_le_mul_of_nonneg_left hsub (Real.exp_pos _).le)
  linarith

theorem exp_box_bound : Real.exp (-(3584/3 : ℝ))≤1/(2 : ℝ)^1700 := by
  have hlog := Real.log_two_lt_d9
  have hh : -(3584/3 : ℝ)≤ -(1700 : ℝ)*Real.log 2 := by linarith
  have he := Real.exp_nat_mul (Real.log 2) 1700
  norm_num only [Nat.cast_ofNat] at he
  rw [Real.exp_log (by norm_num : (0 : ℝ)<2)] at he
  calc
    _ ≤ Real.exp (-(1700 : ℝ)*Real.log 2) := Real.exp_le_exp.mpr hh
    _ = _ := by rw [neg_mul,Real.exp_neg,he,one_div]

theorem box_numeric : Real.exp (-(3584/3 : ℝ))*upper*((16/9 : ℝ)^1536)≤1/2^160 := by
  have hu : upper≤2 := by norm_num [upper,eps]
  have hp : (16/9 : ℝ)^1536≤2^1536 := by gcongr; norm_num
  calc
    _ ≤ (1/(2 : ℝ)^1700)*2*2^1536 := by
      exact mul_le_mul (mul_le_mul exp_box_bound hu (by norm_num [upper,eps]) (by positivity)) hp
        (by positivity) (by positivity)
    _ ≤ _ := by norm_num

theorem finite_bounds (h : Rq) (K : ℝ) (hK : 0<K) (hb : Bounds h K) (c : Rq) :
    lower*K≤fiberMass h c alpha ∧ fiberMass h c alpha≤upper*K := by
  have hm := mass_of_bounds h K hK hb
  have h1 := hb c 1 (Or.inl rfl)
  norm_num only [inv_one,one_pow,mul_one,one_div] at h1
  have hx := (hb c (9/16) (Or.inr (Or.inr rfl))).2
  have ht := box_tail h hm c (9/16) (Or.inr (Or.inr rfl))
  have he : -(1-(9/16 : ℝ))*3221225472/1179648= -(3584/3 : ℝ) := by norm_num
  rw [he] at ht
  have hi : ((9/16 : ℝ)⁻¹)=(16/9 : ℝ) := by norm_num
  rw [hi] at hx
  have hm1 := mul_le_mul_of_nonneg_left hx (Real.exp_pos (-(3584/3 : ℝ))).le
  have hn := mul_le_mul_of_nonneg_right box_numeric hK.le
  have hs := finite_le_full h c (1/1179648) (by simpa using summable_of_mass h hm c 1 (Or.inl rfl))
  constructor
  · change (1-eps-1/2^160)*K≤fiberMass h c (1/1179648)
    nlinarith
  · exact hs.trans h1.2

theorem factor_bounds : 0<lower ∧ (1-1/2^32)*upper≤lower ∧
    upper≤(1+1/2^32)*lower ∧ upper≤(17/16)*lower := by
  norm_num [lower,upper,eps]

theorem finite_flat (h : Rq) (hm : MassCondition h) :
    LegalKeyErrorTransfer.FiniteFlat h (1/2^32) := by
  obtain ⟨K,hK,hb⟩ := hm
  exact NormalizerComparison.finiteFlat_of_common_scale h K lower upper (1/2^32)
    hK.le (by norm_num) (by norm_num) factor_bounds.2.1 factor_bounds.2.2.1
    (finite_bounds h K hK hb)

#print axioms mass_of_bounds
#print axioms outside_atom
#print axioms box_tail
#print axioms exp_box_bound
#print axioms box_numeric
#print axioms finite_bounds
#print axioms factor_bounds
#print axioms finite_flat
end FT1536.S05.BoxTail015
