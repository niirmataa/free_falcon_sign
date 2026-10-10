import ActualTables016
import ImplementationBridge016

/- Actual public literals and actual finite-tape code, under still-unfilled
   LOCAL analytic proof obligations. No witness of these leaves is declared. -/
namespace FT1536.S05.ActualInterface016
open FT1536.Run2 FT1536.Relation ActualTables016 ImplementationBridge016

theorem moment_if_local_leaves (pair : PairLeaves tables) (cube : CubeLeaf)
    (h : Rq) (mass : SamplerMassCondition014.MassCondition h)
    (st : State) (m : Bytes) (r : Nonce) :
    Divergence.second (samplerLaw actualSampler h st m r) (SigmaMath.freshHonest h)≤1+1/2^47 :=
  (full_certificate tables pair cube h mass st m r).2

theorem initial_if_local_leaves (pair : PairLeaves tables) (cube : CubeLeaf)
    (h : Rq) (mass : SamplerMassCondition014.MassCondition h) (m : Bytes) (r : Nonce) :
    Divergence.AC (samplerLaw actualSampler h initial m r) (SigmaMath.freshHonest h) ∧
    Divergence.second (samplerLaw actualSampler h initial m r) (SigmaMath.freshHonest h)≤1+1/2^47 :=
  ⟨actual_all_h_ac h initial m r,moment_if_local_leaves pair cube h mass initial m r⟩

theorem key_law_if_local_leaves (pair : PairLeaves tables) (cube : CubeLeaf)
    (domain : Rq → Prop) (mu : Law Rq) (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h)
    (st : Rq → State) (m : Rq → Bytes) (r : Rq → Nonce) :
    Divergence.AC (KeySupport011.jointSim mu actualSampler st m r) (KeySupport011.jointHonest mu) ∧
    Divergence.second (KeySupport011.jointSim mu actualSampler st m r) (KeySupport011.jointHonest mu)≤1+1/2^47 :=
  ⟨KeySupport011.key_joint_ac domain mu actualSampler _ cover (on_keys tables pair cube domain mass) st m r,
   KeySupport011.key_joint_moment domain mu actualSampler _ cover (on_keys tables pair cube domain mass) st m r⟩

#print axioms moment_if_local_leaves
#print axioms initial_if_local_leaves
#print axioms key_law_if_local_leaves
#check initial_if_local_leaves
#check key_law_if_local_leaves
end FT1536.S05.ActualInterface016
