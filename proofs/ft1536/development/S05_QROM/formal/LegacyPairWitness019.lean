import StoredInterface018
import ReferenceJoint019
import ObservationMoment019

set_option maxRecDepth 8192
namespace FT1536.S05.LegacyPairWitness019
open FT1536.Relation FT1536.Run2 JointInterface019 ReferenceJoint019

/-- Actual018 code with no dependency in its interface on either version
    of Run2.Sampler. The proof adapter below lives in the legacy world. -/
def publicCode (h : Rq) : PairCode Rq ReferenceJoint019.Reply where
  bits := 24662538240
  code tape := StoredInterface018.outputView
    (StoredInterface018.run (StoredInterface018.saveKey h) (SamplerCode016.seedEquiv tape))

theorem law_eq (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    pairLaw (publicCode h)=samplerLaw StoredInterface018.sampler h st m r := rfl

theorem all_h_ac (h : Rq) : Divergence.AC (pairLaw (publicCode h)) (reference h) := by
  rw [law_eq h initial [] (List.Vector.replicate 40 0)]
  exact StoredInterface018.all_h_ac h initial [] (List.Vector.replicate 40 0)

theorem certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h) :
    Certificate (publicCode h) (reference h) (1/2^47) := by
  change Divergence.AC _ _ ∧ Divergence.second _ _≤1+1/2^47
  rw [law_eq h initial [] (List.Vector.replicate 40 0)]
  exact StoredInterface018.initial_certificate h mass [] (List.Vector.replicate 40 0)

theorem full_observation {O : Type} [Fintype O] [DecidableEq O] (h : Rq)
    (mass : SamplerMassCondition014.MassCondition h) (f : Rq×ReferenceJoint019.Reply → O) :
    Divergence.AC ((pairLaw (publicCode h)).map f) ((reference h).map f) ∧
    Divergence.second ((pairLaw (publicCode h)).map f) ((reference h).map f)≤1+1/2^47 :=
  ObservationMoment019.full_observation _ _ _ (certificate h mass).1 (certificate h mass).2 f

theorem same_key_law (domain : Rq → Prop) (mu : Law Rq)
    (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h) :
    Divergence.AC (Divergence.joint mu (fun h => pairLaw (publicCode h)))
      (Divergence.joint mu reference) ∧
    Divergence.second (Divergence.joint mu (fun h => pairLaw (publicCode h)))
      (Divergence.joint mu reference)≤1+1/2^47 := by
  have h := StoredInterface018.key_law_under_cover domain mu cover mass
    (fun _ => initial) (fun _ => []) (fun _ => List.Vector.replicate 40 0)
  have eqn : (fun h => pairLaw (publicCode h))=
      (fun h => samplerLaw StoredInterface018.sampler h initial [] (List.Vector.replicate 40 0)) :=
    funext (fun h => law_eq h initial [] (List.Vector.replicate 40 0))
  rw [eqn]
  exact h

#print axioms law_eq
#print axioms all_h_ac
#print axioms certificate
#print axioms full_observation
#print axioms same_key_law
end FT1536.S05.LegacyPairWitness019
