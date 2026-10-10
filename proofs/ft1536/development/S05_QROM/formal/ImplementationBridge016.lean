import ProgramLaw016
import RawConditioning016
import RawPairDomination016
import SamplerAC016
import SamplerInterface015

set_option maxRecDepth 8192
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.S05.ImplementationBridge016
open FT1536.Relation FT1536.PublicSimulation FT1536.Run2
open SamplerCode016 ProgramLaw016 ProductLaw016 RawConditioning016
open SamplerMassCondition014 CapExecution016 RejectionDomination016

/- These are local proof obligations, NOT supplied instances and NOT new
   cryptographic assumptions. Raw probability refers to the actual1024-bit code. -/
structure PairLeaves (t : Tables) : Prop where
  rejection : (trialLaw (pairTrial t)).mass none≤(7/16 : ℝ)
  raw : ∀ a,(trialLaw (pairTrial t)).mass (some a)≤
    (1-(trialLaw (pairTrial t)).mass none)*(1+1/2^100)*RawProductLaw.blockLaw.mass a
  zero_mass : 1/(2 : ℝ)^23≤RawProductLaw.blockLaw.mass zeroBlock

def CubeLeaf : Prop := ∀ z, cubeLaw.mass z≤CoarseBudget016.R*boundedRaw.mass z

theorem pair_domination (t : Tables) (leaves : PairLeaves t) :
    ∀ a,(pairLaw t).mass a≤CoarseBudget016.pairFactor*RawProductLaw.blockLaw.mass a := by
  rw [pair_law]
  exact RawPairDomination016.cap80_domination _ _ zeroBlock leaves.rejection leaves.raw leaves.zero_mass

theorem selected_domination (t : Tables) (leaves : PairLeaves t) (cube : CubeLeaf)
    (h : Rq) (hm : MassCondition h) :
    ∀ z,(selectedLaw t).mass z≤(1+1/2^60)*boundedRaw.mass z := by
  have hv : ∀ z,(vectorPair (pairLaw t)).mass z≤CoarseBudget016.C*RawProductLaw.rawLaw.mass z :=
    vectorPair_domination (pairLaw t) CoarseBudget016.pairFactor
      (by norm_num [CoarseBudget016.pairFactor]) (pair_domination t leaves)
  have ht : RawProductLaw.rawLaw.event (fun z => ¬RawConditioning016.good z)≤CoarseBudget016.r :=
    global_tail_from_mass h hm
  have hc : CoarseBudget016.C*CoarseBudget016.r<1 :=
    CoarseBudget016.rejection_budget.2.1.trans_lt CoarseBudget016.rejection_budget.2.2
  have hh := CapDomination016.rejected_fallback_domination
    (vectorPair (pairLaw t)) RawProductLaw.rawLaw cubeLaw
    CoarseBudget016.C CoarseBudget016.r CoarseBudget016.R hv RawConditioning016.good
    raw_good_positive ht hc (by unfold CoarseBudget016.R; positivity) cube 196
  have he := selected_law t
  change selectedLaw t=fallbackLaw (reject (vectorPair (pairLaw t)) RawConditioning016.good) 196 cubeLaw at he
  intro z
  rw [he]
  exact (hh z).trans (mul_le_mul_of_nonneg_right CoarseBudget016.full_density_budget
    (boundedRaw.nonneg z))

@[instance_reducible] def canonicalBoxIndex : Fintype BoxPair := inferInstance
attribute [instance] FT1536.PublicSimulation.boxVecFintype
local instance : Fintype BoxPair := canonicalBoxIndex

theorem reply_domination (t : Tables) (leaves : PairLeaves t) (cube : CubeLeaf)
    (h : Rq) (hm : MassCondition h) (st : State) (m : Bytes) (r : Nonce) :
    ∀ x,(FT1536.Run2.samplerLaw (sampler t) h st m r).mass x≤
      (1+1/2^60)*(SigmaMath.freshPublic h).mass x := by
  classical
  rw [ProgramLaw016.sampler_law]
  have hh := FiniteLaw016.map_domination (selectedLaw t) boundedRaw (1+1/2^60)
    (selected_domination t leaves cube h hm) (fun z => (SigmaMath.syndrome h z,emit z))
  rw [mapped_conditioned] at hh
  exact hh

theorem full_certificate (t : Tables) (leaves : PairLeaves t) (cube : CubeLeaf)
    (h : Rq) (hm : MassCondition h) (st : State) (m : Bytes) (r : Nonce) :
    Divergence.AC (FT1536.Run2.samplerLaw (sampler t) h st m r) (SigmaMath.freshHonest h) ∧
    Divergence.second (FT1536.Run2.samplerLaw (sampler t) h st m r) (SigmaMath.freshHonest h)≤1+1/2^47 :=
  FullMoment015.strengthened_joint_certificate h hm _ (reply_domination t leaves cube h hm st m r)

theorem on_keys (t : Tables) (leaves : PairLeaves t) (cube : CubeLeaf)
    (domain : Rq → Prop) (mass : ∀ h,domain h → MassCondition h) :
    KeySupport011.OnKeys domain (sampler t) (1/2^47) :=
  ⟨by norm_num,fun h _ st m r => SamplerAC016.all_h_ac t h st m r,
    fun h hh st m r => (full_certificate t leaves cube h (mass h hh) st m r).2⟩

#print axioms pair_domination
#print axioms selected_domination
#print axioms reply_domination
#print axioms full_certificate
#print axioms on_keys
#check PairLeaves
#check CubeLeaf
end FT1536.S05.ImplementationBridge016
