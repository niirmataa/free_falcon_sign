import SamplerSupport016
import ProductLaw016
import RejectionDomination016
import FiniteIndex016

set_option maxRecDepth 16384
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

set_option maxHeartbeats 200000

namespace FT1536.S05.ProgramLaw016
open Finset FT1536.Run2 FT1536.Run2.FiberBinding FT1536.PublicSimulation
open SamplerCode016 SamplerSupport016 CapExecution016 ProductLaw016 FiniteLaw016

private theorem joint_as_bind {A B : Type} [Fintype A] [Fintype B] [DecidableEq A] [DecidableEq B]
    (p : Law A) (q : Law B) : Divergence.joint p (fun _ => q)=p.bind (fun a => q.map (fun b => (a,b))) := by
  have hh := joint_map p q id
  change (Divergence.joint p (fun _ => q)).bind Law.pure=_ at hh
  rw [FiniteLaw016.bind_pure] at hh
  exact hh

theorem map_product {A B C D : Type} [Fintype A] [Fintype B] [Fintype C] [Fintype D]
    [DecidableEq C] [DecidableEq D] (p : Law A) (q : Law B) (f : A → C) (g : B → D) :
    (Divergence.joint p (fun _ => q)).map (fun z => (f z.1,g z.2))=
      Divergence.joint (p.map f) (fun _ => q.map g) := by
  rw [joint_map,joint_as_bind,FiniteLaw016.map_bind]
  congr 1
  funext a
  rw [FiniteLaw016.map_map]
  rfl

#check map_product

noncomputable def pairLaw (t : Tables) : Law Block :=
  (Law.uniform : Law PairSeed).map (pair t)
noncomputable def vectorLaw (t : Tables) : Law BoxPair :=
  (Law.uniform : Law VectorSeed).map (vector t)
noncomputable def cubeLaw : Law BoxPair :=
  (Law.uniform : Law CubeSeed).map cube
noncomputable def selectedLaw (t : Tables) : Law BoxPair :=
  (Law.uniform : Law Seed).map (selected t)

theorem pair_law (t : Tables) : pairLaw t=
    fallbackLaw (trialLaw (pairTrial t)) 80 (Law.pure zeroBlock) := by
  have he : pair t=(fun o : Option Block => o.getD zeroBlock) ∘ first (pairTrial t) 80 := rfl
  rw [pairLaw,he,←FiniteLaw016.map_map,first_law]
  change (MathSign.cap (trialLaw (pairTrial t)) 80).bind _=_
  unfold fallbackLaw
  congr 1
  funext o
  cases o <;> rfl

#check pair_law

theorem vector_law (t : Tables) : vectorLaw t=vectorPair (pairLaw t) := by
  change (Law.uniform : Law VectorSeed).map
    (fun z => ((fun i => pair t (z.1 i)),(fun i => pair t (z.2 i))))=_
  rw [←uniform_joint,map_product (f:=fun v : Fin 768 → PairSeed => fun i => pair t (v i))
    (g:=fun v : Fin 768 → PairSeed => fun i => pair t (v i)),independent_code]
  rfl

#check vector_law

def good (z : BoxPair) : Prop := Geometry.Q (decode z)<Geometry.B
instance : DecidablePred good := fun z => inferInstanceAs (Decidable (Geometry.Q (decode z)<Geometry.B))

theorem norm_trial_law (t : Tables) : trialLaw (normTrial t)=
    RejectionDomination016.reject (vectorPair (pairLaw t)) good := by
  have he : normTrial t=RejectionDomination016.accept good ∘ vector t := rfl
  change (Law.uniform : Law VectorSeed).map (normTrial t)=_
  rw [he]
  rw [←FiniteLaw016.map_map]
  change (vectorLaw t).map (RejectionDomination016.accept good)=_
  rw [vector_law]
  rfl

#check norm_trial_law

/- Prevent elaboration from executing the concrete196-by1536-by80 loops. -/
attribute [local irreducible] CapExecution016.first SamplerCode016.normTrial Law.map Law.uniform selectedLaw cubeLaw

theorem selected_law (t : Tables) : selectedLaw t=
    fallbackLaw (RejectionDomination016.reject (vectorPair (pairLaw t)) good) 196 cubeLaw := by
  have hh := fallback_code_law (normTrial t) cube 196
  rw [norm_trial_law] at hh
  have he : selected t=(fun input : Seed => finish cube (first (normTrial t) 196 input.1,input.2)) := by
    funext input
    unfold SamplerCode016.selected CapExecution016.finish
    generalize he : CapExecution016.first (SamplerCode016.normTrial t) 196 input.1=o
    cases o <;> rfl
  unfold selectedLaw cubeLaw
  rw [he]
  exact hh

#check selected_law

@[instance_reducible] def canonicalBoxIndex : Fintype BoxPair := inferInstance
attribute [instance] FT1536.PublicSimulation.boxVecFintype
local instance : Fintype BoxPair := canonicalBoxIndex

theorem sampler_law (t : Tables) (h : FT1536.Relation.Rq) (st : State) (m : Bytes) (r : Nonce) :
    FT1536.Run2.samplerLaw (sampler t) h st m r=(selectedLaw t).map
      (fun z => (SigmaMath.syndrome h z,emit z)) := by
  classical
  have he : (sampler t).code h st m r=
      (fun z => (SigmaMath.syndrome h z,emit z)) ∘ (selected t ∘ seedEquiv) := by
    funext tape
    exact code_as_emission t h st m r tape
  unfold FT1536.Run2.samplerLaw
  change (Law.uniform : Law (BitTapes016.Bits 24662538240)).map ((sampler t).code h st m r)=_
  rw [he,←FiniteLaw016.map_map,←FiniteLaw016.map_map,seed_uniform]
  unfold selectedLaw
  rfl

#print axioms map_product
#print axioms pair_law
#print axioms vector_law
#print axioms norm_trial_law
#print axioms selected_law
#print axioms sampler_law
end FT1536.S05.ProgramLaw016
