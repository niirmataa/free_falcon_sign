import GaussianWitnessRowsAll017
import PairLeaves017
import CubeDensity017
import ActualInterface016

/- Actual instances replace every local016 pair/cube obligation. The remaining
   MassCondition is explicit; this is not a source-KeyGen or QROM theorem. -/
namespace FT1536.S05.ActualInterface017
open FT1536.Run2 FT1536.Relation ActualTables016 ImplementationBridge016

theorem actual_rows : GaussianLiterals017.Rows := GaussianWitness017.all_rows

theorem actual_pair_leaves : PairLeaves tables := PairLeaves017.pair_leaves_of_rows actual_rows

theorem actual_cube_leaf : CubeLeaf := CubeDensity017.cube_leaf_instance

theorem moment_under_mass (h : Rq) (mass : SamplerMassCondition014.MassCondition h)
    (st : State) (m : Bytes) (r : Nonce) :
    Divergence.second (samplerLaw actualSampler h st m r) (SigmaMath.freshHonest h)≤1+1/2^47 :=
  ActualInterface016.moment_if_local_leaves actual_pair_leaves actual_cube_leaf h mass st m r

/-- Operational caller uses public initial; the underlying certificate covers all states. -/
theorem initial_certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h)
    (m : Bytes) (r : Nonce) :
    Divergence.AC (samplerLaw actualSampler h initial m r) (SigmaMath.freshHonest h) ∧
    Divergence.second (samplerLaw actualSampler h initial m r) (SigmaMath.freshHonest h)≤1+1/2^47 :=
  ActualInterface016.initial_if_local_leaves actual_pair_leaves actual_cube_leaf h mass m r

theorem key_law_under_cover (domain : Rq → Prop) (mu : Law Rq)
    (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h)
    (st : Rq → State) (m : Rq → Bytes) (r : Rq → Nonce) :
    Divergence.AC (KeySupport011.jointSim mu actualSampler st m r) (KeySupport011.jointHonest mu) ∧
    Divergence.second (KeySupport011.jointSim mu actualSampler st m r) (KeySupport011.jointHonest mu)≤1+1/2^47 :=
  ActualInterface016.key_law_if_local_leaves actual_pair_leaves actual_cube_leaf domain mu cover mass st m r

#print axioms actual_rows
#print axioms actual_pair_leaves
#print axioms actual_cube_leaf
#print axioms moment_under_mass
#print axioms initial_certificate
#print axioms key_law_under_cover
end FT1536.S05.ActualInterface017
