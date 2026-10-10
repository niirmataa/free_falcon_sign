import RejectionDomination016
import Run2.RawProductLaw
import AcceptedMarginal015

set_option maxRecDepth 16384
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.S05.RawConditioning016
open Finset FT1536.PublicSimulation FT1536.Geometry FT1536.Relation
open FT1536.Run2 FT1536.Run2.LegalKeyErrorTransfer
open RejectionDomination016 AcceptedMarginal015 SamplerMassCondition014

def good (z : BoxPair) : Prop := Q (decode z)<B
instance : DecidablePred good := fun z => inferInstanceAs (Decidable (Q (decode z)<B))

theorem raw_mass (z : BoxPair) : RawProductLaw.rawLaw.mass z=gaussianWeight z/totalWeight := by
  change gaussianWeight z/(∑ y,gaussianWeight y)=_
  rw [←RawProductLaw.totalWeight_as_sum]

theorem raw_good_event : RawProductLaw.rawLaw.event good=acceptedTotal/totalWeight := by
  unfold Law.event
  simp_rw [raw_mass]
  have he (z : BoxPair) : (if good z then gaussianWeight z/totalWeight else 0)=boundedWeight z/totalWeight := by
    by_cases hz : good z
    · change (if good z then gaussianWeight z/totalWeight else 0)=(if good z then gaussianWeight z else 0)/totalWeight
      simp only [hz,ite_true]
    · change (if good z then gaussianWeight z/totalWeight else 0)=(if good z then gaussianWeight z else 0)/totalWeight
      simp only [hz,ite_false,zero_div]
  simp_rw [he]
  rw [←sum_div]
  unfold acceptedTotal
  rw [RawProductLaw.legacy_box_sum]

theorem raw_good_positive : 0<RawProductLaw.rawLaw.event good := by
  rw [raw_good_event]
  exact div_pos bounded_normalizer_pos totalWeight_pos

attribute [local irreducible] RejectionDomination016.conditioned Law.map Law.uniform

noncomputable def boundedRaw : Law BoxPair :=
  RejectionDomination016.conditioned RawProductLaw.rawLaw good raw_good_positive

theorem conditioned_mass (z : BoxPair) :
    boundedRaw.mass z=(@Law.mass BoxPair boxPairFintype boundedGaussian z) := by
  unfold boundedRaw RejectionDomination016.conditioned
  change (if good z then RawProductLaw.rawLaw.mass z else 0)/RawProductLaw.rawLaw.event good=
    boundedWeight z/acceptedTotal
  rw [raw_mass,raw_good_event]
  have hS : acceptedTotal≠0 := ne_of_gt bounded_normalizer_pos
  have hT : totalWeight≠0 := ne_of_gt totalWeight_pos
  by_cases hz : good z
  · have he : boundedWeight z=gaussianWeight z := ite_eq_left hz
    rw [ite_eq_left hz,he]
    field_simp
  · have he : boundedWeight z=0 := ite_eq_right hz
    rw [ite_eq_right hz,he]
    simp

theorem mapped_conditioned {X : Type} [Fintype X] [DecidableEq X] (f : BoxPair → X) :
    boundedRaw.map f=(@Law.map BoxPair X boxPairFintype _ _ boundedGaussian f) := by
  apply FiberBinding.law_ext
  intro x
  rw [FiberBinding.map_mass,
    @FiberBinding.map_mass BoxPair X boxPairFintype _ _ boundedGaussian f x]
  simp_rw [conditioned_mass]
  exact (RawProductLaw.legacy_box_sum (fun z => if f z=x then (@Law.mass BoxPair boxPairFintype boundedGaussian z) else 0)).symm

/-- The already named M suffices; no new global theta estimate is assumed. -/
theorem global_tail_from_mass (h : Rq) (hm : MassCondition h) :
    RawProductLaw.rawLaw.event (fun z => ¬good z)≤1/2^24 := by
  have hs := (total_bounds h hm).1
  have hc := complement RawProductLaw.rawLaw good
  rw [raw_good_event] at hc
  have hlo : 1-u≤acceptedTotal/totalWeight :=
    (le_div_iff₀ totalWeight_pos).mpr hs
  change RawProductLaw.rawLaw.event (fun z => ¬good z)≤u
  linarith

#print axioms raw_mass
#print axioms raw_good_event
#print axioms raw_good_positive
#print axioms conditioned_mass
#print axioms mapped_conditioned
#print axioms global_tail_from_mass
end FT1536.S05.RawConditioning016
