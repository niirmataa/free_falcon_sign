import NormTail015

namespace FT1536.S05.AcceptedMarginal015
open Finset FT1536.Relation FT1536.PublicSimulation
open FT1536.Run2 FT1536.Run2.FiberBinding FT1536.Run2.ExactCounting
open SamplerMassCondition014

noncomputable def rho : ℝ := 1/2^32
noncomputable def u : ℝ := 1/2^24
noncomputable def deviation : ℝ := (rho+u)/(1-u)
noncomputable def acceptedTotal : ℝ := ∑ z, boundedWeight z
noncomputable def zMass (h c : Rq) : ℝ := evalCount (Z h c)
noncomputable def sMass (h c : Rq) : ℝ := evalCount (S h c)

theorem constants : 0≤u ∧ u<1 ∧ 0≤rho ∧ rho<1 ∧ 0≤deviation ∧ deviation<1 ∧
    (1+deviation)*(1-u)=1+rho ∧ 1-deviation≤(1-u)*(1-rho) := by
  norm_num [u,rho,deviation]

theorem accepted_partition (h : Rq) : (∑ c, sMass h c)=acceptedTotal := by
  classical
  simp only [sMass,S_value,acceptedWeight_fiber]
  rw [sum_comm]
  simp only [acceptedTotal]
  apply sum_congr rfl
  intro z _
  simp

theorem z_partition (h : Rq) : (∑ c, zMass h c)=LegalKeyErrorTransfer.totalWeight := by
  simpa only [zMass,GaussianFiberTilt.fiberMass_at_alpha] using
    NormalizerComparison.fiber_partition_at_alpha h

theorem accepted_bounds (h : Rq) (hm : MassCondition h) (c : Rq) :
    (1-u)*zMass h c≤sMass h c ∧ sMass h c≤zMass h c := by
  have he := rejection_exact h c
  have hz := Z_positive h c
  have hr := (NormTail015.actual_rejection h hm c).le
  have hn := (CorrectnessProbability.rejection_bounds h c).1
  change CorrectnessProbability.rejection h c=(zMass h c-sMass h c)/zMass h c at he
  have he' := (eq_div_iff (ne_of_gt hz)).mp he
  have hp := mul_le_mul_of_nonneg_right hr hz.le
  have hp0 := mul_nonneg hn hz.le
  change CorrectnessProbability.rejection h c*zMass h c≤u*zMass h c at hp
  change CorrectnessProbability.rejection h c*zMass h c=zMass h c-sMass h c at he'
  change 0≤CorrectnessProbability.rejection h c*zMass h c at hp0
  constructor <;> nlinarith

theorem s_positive (h : Rq) (hm : MassCondition h) (c : Rq) :
    0<∑ z, acceptedWeight (SigmaMath.syndrome h) c z := by
  rw [←S_value]
  exact (mul_pos (by norm_num [u] : 0<1-u) (Z_positive h c)).trans_le
    (accepted_bounds h hm c).1

theorem total_bounds (h : Rq) (hm : MassCondition h) :
    (1-u)*LegalKeyErrorTransfer.totalWeight≤acceptedTotal ∧
      acceptedTotal≤LegalKeyErrorTransfer.totalWeight := by
  rw [←accepted_partition h,←z_partition h,Finset.mul_sum]
  constructor
  · exact sum_le_sum (fun c _ => (accepted_bounds h hm c).1)
  · exact sum_le_sum (fun c _ => (accepted_bounds h hm c).2)

noncomputable def marginal (h : Rq) : Law Rq where
  mass c := nu (SigmaMath.syndrome h) c
  nonneg c := div_nonneg (sum_nonneg (fun z _ => acceptedWeight_nonneg _ _ z))
    bounded_normalizer_pos.le
  total := by
    change (∑ c, (∑ z, acceptedWeight (SigmaMath.syndrome h) c z)/acceptedTotal)=1
    simp_rw [←S_value]
    rw [←sum_div]
    change (∑ c, sMass h c)/acceptedTotal=1
    rw [accepted_partition,div_self (ne_of_gt (show 0<acceptedTotal from bounded_normalizer_pos))]

theorem marginal_mass (h c : Rq) : (marginal h).mass c=sMass h c/acceptedTotal := by
  change (∑ z, acceptedWeight (SigmaMath.syndrome h) c z)/acceptedTotal=_
  rw [←S_value]
  rfl

theorem marginal_interval (h : Rq) (hm : MassCondition h) (c : Rq) :
    1-deviation≤(Fintype.card Rq : ℝ)*(marginal h).mass c ∧
      (Fintype.card Rq : ℝ)*(marginal h).mass c≤1+deviation := by
  have hf := BoxTail015.finite_flat h hm c
  change (1-rho)*LegalKeyErrorTransfer.totalWeight≤(Fintype.card Rq : ℝ)*zMass h c ∧
    (Fintype.card Rq : ℝ)*zMass h c≤(1+rho)*LegalKeyErrorTransfer.totalWeight at hf
  have hb := accepted_bounds h hm c
  have ht := total_bounds h hm
  have hq : 0<acceptedTotal := bounded_normalizer_pos
  have hT := LegalKeyErrorTransfer.totalWeight_pos
  have hM : 0≤(Fintype.card Rq : ℝ) := by positivity
  have hslo := mul_le_mul_of_nonneg_left hb.1 hM
  have hshi := mul_le_mul_of_nonneg_left hb.2 hM
  have hflo := mul_le_mul_of_nonneg_left hf.1 (by norm_num [u] : 0≤1-u)
  have htl := mul_le_mul_of_nonneg_left ht.1 (by norm_num [deviation,rho,u] : 0≤1+deviation)
  have htu := mul_le_mul_of_nonneg_left ht.2 (by norm_num [deviation,rho,u] : 0≤1-deviation)
  have hconst : (1-deviation)*LegalKeyErrorTransfer.totalWeight≤
      ((1-u)*(1-rho))*LegalKeyErrorTransfer.totalWeight :=
    mul_le_mul_of_nonneg_right constants.2.2.2.2.2.2.2 hT.le
  rw [marginal_mass,←mul_div_assoc]
  constructor
  · apply (le_div_iff₀ hq).2
    nlinarith
  · apply (div_le_iff₀ hq).2
    have hEq := constants.2.2.2.2.2.2.1
    nlinarith

/-- Reuse the existing centered-energy identity: the mean term cancels exactly. -/
theorem marginal_second (h : Rq) (hm : MassCondition h) :
    Divergence.second (marginal h) (Law.uniform (α:=Rq))≤1+deviation^2 := by
  have hM : 0<(Fintype.card Rq : ℝ) := by positivity
  let d : Divergence.Density (marginal h) (Law.uniform (α:=Rq)) := {
    ratio := fun c => (Fintype.card Rq : ℝ)*(marginal h).mass c
    nonneg := fun c => mul_nonneg hM.le ((marginal h).nonneg c)
    factor := by intro c; change _=1/(Fintype.card Rq : ℝ)*_; field_simp }
  have he := Divergence.centered_energy (marginal h) (Law.uniform (α:=Rq)) d
  rw [Divergence.energy_eq_second] at he
  have hi (c : Rq) : (d.ratio c-1)^2≤deviation^2 := by
    have hh := marginal_interval h hm c
    change ((Fintype.card Rq : ℝ)*(marginal h).mass c-1)^2≤_
    nlinarith [mul_nonneg (sub_nonneg.mpr hh.2) (sub_nonneg.mpr hh.1)]
  have hs : (∑ c, (Law.uniform (α:=Rq)).mass c*(d.ratio c-1)^2)≤deviation^2 := by
    calc
      _ ≤ ∑ c, (Law.uniform (α:=Rq)).mass c*deviation^2 :=
        sum_le_sum (fun c _ => mul_le_mul_of_nonneg_left (hi c) ((Law.uniform (α:=Rq)).nonneg c))
      _ = _ := by rw [←sum_mul,(Law.uniform (α:=Rq)).total,one_mul]
  linarith

#print axioms constants
#print axioms accepted_partition
#print axioms z_partition
#print axioms accepted_bounds
#print axioms s_positive
#print axioms total_bounds
#print axioms marginal_mass
#print axioms marginal_interval
#print axioms marginal_second
end FT1536.S05.AcceptedMarginal015
