import FullMoment015
import KeySupport011

/- Q-SAMPLER proof obligation: constructor only. The domain comes from the
   source key law; it must not be selected by the desired moment conclusion.
   Q-RESC remains separate: Sampler.bits is not a machine runtime proof. -/
namespace FT1536.S05.SamplerInterface015
open FT1536.Relation FT1536.Run2
open SamplerMassCondition014 KeySupport011 FullMoment015

def InitialDomination (domain : Rq → Prop) (S : Sampler) : Prop :=
  ∀ h, domain h → ∀ m r x,
    (samplerLaw S h initial m r).mass x≤(1+1/2^60)*(SigmaMath.freshPublic h).mass x

/-- Only the public initial is inspected; the resulting certificate covers
    every supplied classical state via the existing reset wrapper. -/
theorem on_keys (domain : Rq → Prop) (S : Sampler)
    (mass : ∀ h, domain h → MassCondition h) (domination : InitialDomination domain S) :
    OnKeys domain (resetInitial S) (1/2^47) := by
  apply resetInitial_of_initial_bounds domain S (1/2^47) (by norm_num)
  · intro h hh m r
    exact (strengthened_joint_certificate h (mass h hh) (samplerLaw S h initial m r)
      (domination h hh m r)).1
  · intro h hh m r
    exact (strengthened_joint_certificate h (mass h hh) (samplerLaw S h initial m r)
      (domination h hh m r)).2

theorem same_key_law (domain : Rq → Prop) (S : Sampler) (mu : Law Rq)
    (cover : Covered mu domain) (mass : ∀ h, domain h → MassCondition h)
    (domination : InitialDomination domain S)
    (st : Rq → State) (m : Rq → Bytes) (r : Rq → Nonce) :
    Divergence.AC (jointSim mu (resetInitial S) st m r) (jointHonest mu) ∧
    Divergence.second (jointSim mu (resetInitial S) st m r) (jointHonest mu)≤1+1/2^47 :=
  ⟨key_joint_ac domain mu (resetInitial S) _ cover (on_keys domain S mass domination) st m r,
   key_joint_moment domain mu (resetInitial S) _ cover (on_keys domain S mass domination) st m r⟩

/-- Limitation of this conservative envelope, not a lower bound for J/P. -/
theorem envelope_above_next_dyadic : 1+1/(2 : ℝ)^48<
    (1+1/2^60)^2*((1+AcceptedMarginal015.deviation^2)/(1-AcceptedMarginal015.u^16)) := by
  norm_num [AcceptedMarginal015.deviation,AcceptedMarginal015.rho,AcceptedMarginal015.u]

#print axioms on_keys
#print axioms same_key_law
#print axioms envelope_above_next_dyadic
#check FullMoment015.actual_harmonic_certificate
#check on_keys
#check same_key_law
end FT1536.S05.SamplerInterface015
