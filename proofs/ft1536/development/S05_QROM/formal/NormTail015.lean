import BoxTail015

/- Q-SAMPLER obligation: actual finite-box trial, at the exact tN of M.
   Conservative margins are explicit; no replacement by the ROM 7/8 tilt. -/
namespace FT1536.S05.NormTail015
open FT1536.Geometry FT1536.Relation FT1536.PublicSimulation
open FT1536.Run2 FT1536.Run2.GaussianFiberTilt
open BoxSupport015 BoxTail015 SamplerMassCondition014

noncomputable def ratio : ℝ := 2093922385/1811939328
noncomputable def exponent : ℝ := (1-tN)*2093922385/1179648

theorem log_ratio_bound : Real.log ratio≤144665/1000000 := by
  have hh := Real.sum_le_exp_of_nonneg (x:=(144665 : ℝ)/1000000) (by norm_num) 7
  norm_num [Finset.sum_range_succ] at hh
  apply (Real.log_le_iff_le_exp (by norm_num [ratio] : 0<ratio)).2
  norm_num [ratio]
  linarith

theorem norm_exponent_margin : (1536 : ℝ)*Real.log ratio-exponent≤
    -(24 : ℝ)*Real.log 2-1/16 := by
  have hl := log_ratio_bound
  have h2 := Real.log_two_lt_d9
  norm_num only [exponent,tN] at *
  linarith

theorem norm_numeric : Real.exp (-exponent)*((17/16 : ℝ)*ratio^1536)<1/2^24 := by
  have hp : ratio^1536=Real.exp ((1536 : ℝ)*Real.log ratio) := by
    have he := Real.exp_nat_mul (Real.log ratio) 1536
    norm_num only [Nat.cast_ofNat] at he
    rw [Real.exp_log (by norm_num [ratio] : 0<ratio)] at he
    exact he.symm
  have hsmall : (17 : ℝ)/16<Real.exp (1/16) := by
    have hh := Real.sum_le_exp_of_nonneg (x:=(1 : ℝ)/16) (by norm_num) 3
    norm_num [Finset.sum_range_succ] at hh
    linarith
  have hpow : Real.exp (-(24 : ℝ)*Real.log 2)=1/(2 : ℝ)^24 := by
    have he := Real.exp_nat_mul (Real.log 2) 24
    norm_num only [Nat.cast_ofNat] at he
    rw [Real.exp_log (by norm_num : (0 : ℝ)<2)] at he
    rw [neg_mul,Real.exp_neg,he,one_div]
  rw [hp]
  calc
    _ = (17/16)*Real.exp ((1536 : ℝ)*Real.log ratio-exponent) := by
      simp only [Real.exp_sub,Real.exp_neg]
      ring
    _ ≤ (17/16)*Real.exp (-(24 : ℝ)*Real.log 2-1/16) :=
      mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr norm_exponent_margin) (by norm_num)
    _ < Real.exp (1/16)*Real.exp (-(24 : ℝ)*Real.log 2-1/16) :=
      mul_lt_mul_of_pos_right hsmall (Real.exp_pos _)
    _ = _ := by
      rw [←Real.exp_add]
      convert hpow using 2; ring

theorem tilted_ratio (h : Rq) (K : ℝ) (hK : 0<K) (hb : Bounds h K) (c : Rq) :
    fiberMass h c (tN/1179648)/fiberMass h c alpha≤(17/16 : ℝ)*ratio^1536 := by
  have hm := mass_of_bounds h K hK hb
  have ht : Temperature tN := Or.inr (Or.inl rfl)
  have hi : tN⁻¹=ratio := by norm_num [tN,ratio]
  have hs := finite_le_full h c (tN/1179648) (summable_of_mass h hm c tN ht)
  have hu := (hb c tN ht).2
  rw [hi] at hu
  have hlo := (finite_bounds h K hK hb c).1
  apply (div_le_iff₀ (fiberMass_pos h c alpha)).2
  have hp : 0≤ratio^1536 := pow_nonneg (by norm_num [ratio]) _
  calc
    _ ≤ upper*ratio^1536*K := hs.trans hu
    _ ≤ ((17/16)*lower)*ratio^1536*K := by
      exact mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_right factor_bounds.2.2.2 hp) hK.le
    _ = ((17/16)*ratio^1536)*(lower*K) := by ring
    _ ≤ _ := mul_le_mul_of_nonneg_left hlo (mul_nonneg (by norm_num) hp)

theorem actual_rejection (h : Rq) (hm : MassCondition h) (c : Rq) :
    CorrectnessProbability.rejection h c<1/2^24 := by
  obtain ⟨K,hK,hb⟩ := hm
  have hr := tilted_ratio h K hK hb c
  have hc := rejection_chernoff h c ((1-tN)/1179648) (by norm_num [tN])
  have ht : alpha-(1-tN)/1179648=tN/1179648 := by unfold alpha; ring
  have he : -((1-tN)/1179648)*(B : ℝ)= -exponent := by norm_num [exponent,B]; ring
  rw [ht,he] at hc
  exact (hc.trans (mul_le_mul_of_nonneg_left hr (Real.exp_pos _).le)).trans_lt norm_numeric

#print axioms log_ratio_bound
#print axioms norm_exponent_margin
#print axioms norm_numeric
#print axioms tilted_ratio
#print axioms actual_rejection
end FT1536.S05.NormTail015
