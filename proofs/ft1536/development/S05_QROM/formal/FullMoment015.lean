import AcceptedMarginal015

/- Q-SAMPLER obligation, full Option-valued reply. No assumption excludes
   none from the accepted emission law. Implementation domination is explicit. -/
namespace FT1536.S05.FullMoment015
open Finset FT1536.Relation FT1536.PublicSimulation
open FT1536.Run2 FT1536.Run2.FiberBinding FT1536.Divergence
open SamplerMassCondition014 AcceptedMarginal015

noncomputable def acceptedReply (h : Rq) (hm : MassCondition h) (c : Rq) : Law (Option BoxVec) :=
  L (SigmaMath.syndrome h) c (s_positive h hm c)

theorem public_is_joint (h : Rq) (hm : MassCondition h) :
    SigmaMath.freshPublic h=joint (marginal h) (acceptedReply h hm) := by
  apply law_ext
  rintro ⟨c,o⟩
  exact public_joint_factor (SigmaMath.syndrome h) c (s_positive h hm c) o

theorem honest_is_joint (h : Rq) : SigmaMath.freshHonest h=
    joint (Law.uniform (α:=Rq)) (fun c => signBody (SigmaMath.syndrome h) c) := rfl

theorem conditional_ac (h : Rq) (hm : MassCondition h) (c : Rq) :
    AC (acceptedReply h hm c) (signBody (SigmaMath.syndrome h) c) := by
  rw [signBody_is_mix _ c (s_positive h hm c)]
  exact EmitMixture.mix_ac _ (pi_bounds _ c (s_positive h hm c)).1
    (pi_bounds _ c (s_positive h hm c)).2 _

theorem pi_lower (h : Rq) (hm : MassCondition h) (c : Rq) :
    1-u^16≤pi (SigmaMath.syndrome h) c := by
  have hr := (NormTail015.actual_rejection h hm c).le
  have hn := (CorrectnessProbability.rejection_bounds h c).1
  have hp : CorrectnessProbability.rejection h c^16≤u^16 := by
    apply pow_le_pow_left₀ hn hr
  change 1-u^16≤1-CorrectnessProbability.rejection h c^16
  linarith

theorem conditional_second (h : Rq) (hm : MassCondition h) (c : Rq) :
    second (acceptedReply h hm c) (signBody (SigmaMath.syndrome h) c)≤1/(1-u^16) := by
  have hpi := pi_bounds (SigmaMath.syndrome h) c (s_positive h hm c)
  have hmix := EmitMixture.second_le_inv _ hpi.1 hpi.2 (acceptedReply h hm c)
  rw [signBody_is_mix _ c (s_positive h hm c)]
  exact hmix.trans (one_div_le_one_div_of_le (by norm_num [u]) (pi_lower h hm c))

theorem public_ac (h : Rq) (hm : MassCondition h) :
    AC (SigmaMath.freshPublic h) (SigmaMath.freshHonest h) := by
  rw [public_is_joint h hm,honest_is_joint]
  apply joint_ac
  · intro c hc
    have hp : 0<(Law.uniform (α:=Rq)).mass c := by change 0<1/(Fintype.card Rq : ℝ); positivity
    exact False.elim (ne_of_gt hp hc)
  · intro c _
    exact conditional_ac h hm c

theorem public_second (h : Rq) (hm : MassCondition h) :
    second (SigmaMath.freshPublic h) (SigmaMath.freshHonest h)≤
      (1+deviation^2)/(1-u^16) := by
  rw [public_is_joint h hm,honest_is_joint]
  have hh := joint_bound (marginal h) (Law.uniform (α:=Rq)) (acceptedReply h hm)
    (fun c => signBody (SigmaMath.syndrome h) c) (1/(1-u^16))
    (fun c _ => conditional_second h hm c)
  have ht := mul_le_mul_of_nonneg_right (marginal_second h hm) (by norm_num [u] : 0≤1/(1-u^16))
  exact hh.trans (by simpa only [mul_one_div] using ht)

/-- Valid also at zero honest masses: AC is transferred separately. -/
theorem ac_of_domination {X : Type} [Fintype X] (j k p : Law X) (C : ℝ)
    (hk : AC k p) (hd : ∀ x, j.mass x≤C*k.mass x) : AC j p := by
  intro x hx
  have hh := hd x
  rw [hk x hx,mul_zero] at hh
  exact le_antisymm hh (j.nonneg x)

theorem second_of_domination {X : Type} [Fintype X] (j k p : Law X) (C : ℝ)
    (hd : ∀ x, j.mass x≤C*k.mass x) :
    second j p≤C^2*second k p := by
  unfold second
  rw [mul_sum]
  apply sum_le_sum
  intro x _
  have hs : j.mass x^2≤(C*k.mass x)^2 := by
    exact pow_le_pow_left₀ (j.nonneg x) (hd x) 2
  have hq := div_le_div_of_nonneg_right hs (p.nonneg x)
  simpa only [mul_pow,mul_div_assoc] using hq

theorem strengthened_numeric : (1+1/(2 : ℝ)^60)^2*((1+deviation^2)/(1-u^16))<1+1/2^47 := by
  norm_num [deviation,rho,u]

/-- Conditional law certificate; supplying this pointwise bound for actual
    sampler code, and supplying its runtime, are separate proof obligations. -/
theorem strengthened_joint_certificate (h : Rq) (hm : MassCondition h)
    (j : Law (Rq×Option BoxVec))
    (domination : ∀ x, j.mass x≤(1+1/2^60)*(SigmaMath.freshPublic h).mass x) :
    AC j (SigmaMath.freshHonest h) ∧ second j (SigmaMath.freshHonest h)≤1+1/2^47 := by
  refine ⟨ac_of_domination j _ _ _ (public_ac h hm) domination,?_⟩
  have hd := second_of_domination j _ (SigmaMath.freshHonest h) (1+1/2^60)
    domination
  have hb := mul_le_mul_of_nonneg_left (public_second h hm) (sq_nonneg (1+1/2^60))
  exact (hd.trans hb).trans strengthened_numeric.le

/-- Compatibility with the historically stated 007 budget, without rewriting it. -/
theorem dominated_joint_certificate (h : Rq) (hm : MassCondition h)
    (j : Law (Rq×Option BoxVec))
    (domination : ∀ x, j.mass x≤(1+1/2^60)*(SigmaMath.freshPublic h).mass x) :
    AC j (SigmaMath.freshHonest h) ∧ second j (SigmaMath.freshHonest h)≤1+1/2^44 := by
  have hh := strengthened_joint_certificate h hm j domination
  exact ⟨hh.1,hh.2.trans (by norm_num)⟩

#print axioms dominated_joint_certificate

/-- End-to-end mathematical consumer of the actual coefficient geometry.
    Source key coverage and code domination are not inferred from this theorem. -/
theorem actual_harmonic_certificate (f g bigF bigG : Geometry.Vec) (h fInv : Rq)
    (ntru : Run2.CoefficientQuotient.multiply f bigG-Run2.CoefficientQuotient.multiply g bigF=
      Run2.CoefficientQuotient.constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=Run2.CoefficientQuotient.constantCoeffs (1 : ZMod 18433))
    (hf : PrimaryBlock014.Ternary f) (hg : PrimaryBlock014.Ternary g)
    (harmonic : 991≤SpectralDiagonal012.harmonic (Evaluation014.weight f g))
    (j : Law (Rq×Option BoxVec))
    (domination : ∀ x, j.mass x≤(1+1/2^60)*(SigmaMath.freshPublic h).mass x) :
    AC j (SigmaMath.freshHonest h) ∧ second j (SigmaMath.freshHonest h)≤1+1/2^47 :=
  strengthened_joint_certificate h
    (sampler007_mass_condition f g bigF bigG h fInv ntru public_eq inverse_eq hf hg harmonic)
    j domination

#print axioms actual_harmonic_certificate

#print axioms public_is_joint
#print axioms honest_is_joint
#print axioms conditional_ac
#print axioms pi_lower
#print axioms conditional_second
#print axioms public_ac
#print axioms public_second
#print axioms ac_of_domination
#print axioms second_of_domination
#print axioms strengthened_numeric
#print axioms strengthened_joint_certificate
end FT1536.S05.FullMoment015
