import Source3.KeygenDecodedKey111

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenModelLaw111
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenDecodedKey111 (SecretKey joint decode)
open KeygenInputLaw110 (seedLaw)

abbrev Key := SecretKey × Relation.Rq

noncomputable def byteOutcome (env : Env) (input : Input env) (seed : Seed) : Option KeygenWholeBytes088.Packet :=
  KeygenWholeLaw088.forget (KeygenByteGame109.evaluate env input seed)

noncomputable def modelOutcome (env : Env) (input : Input env) (seed : Seed) : Option Key :=
  (byteOutcome env input seed).bind decode

theorem pointwise (env : Env) (input : Input env) (seed : Seed) :
    modelOutcome env input seed = (byteOutcome env input seed).map joint := by
  cases h : KeygenByteGame109.evaluate env input seed with
  | none => simp [modelOutcome, byteOutcome, h, KeygenWholeLaw088.forget]
  | some out =>
      cases out with
      | inl failure => simp [modelOutcome, byteOutcome, h, KeygenWholeLaw088.forget]
      | inr packet =>
          have parsed := KeygenDecodedKey111.source_decode env input seed packet h
          simp [modelOutcome, byteOutcome, h, KeygenWholeLaw088.forget, parsed]

/-- Independently constructed decoded-model experiment, from the same
    source seed outcome and actual partial packet decoders. -/
noncomputable def rawLaw (env : Env) (input : Input env) : Law (Option Key) := by
  classical
  exact seedLaw.map (modelOutcome env input)

theorem raw_binding (env : Env) (input : Input env) :
    rawLaw env input = (KeygenWholeLaw088.packetLaw (KeygenProbability110.law env input)).map (Option.map joint) := by
  classical
  have functions : modelOutcome env input = (Option.map joint) ∘ (KeygenWholeLaw088.forget ∘ KeygenByteGame109.evaluate env input) :=
    funext (pointwise env input)
  unfold rawLaw
  rw [functions]
  change seedLaw.map ((Option.map joint) ∘ (KeygenWholeLaw088.forget ∘ KeygenByteGame109.evaluate env input)) =
    ((seedLaw.map (KeygenByteGame109.evaluate env input)).map KeygenWholeLaw088.forget).map (Option.map joint)
  rw [KeygenLawAlgebra110.map_map, KeygenLawAlgebra110.map_map]
  rfl

noncomputable def successfulLaw (env : Env) (input : Input env) : Option (Law Key) :=
  KeygenLawBoundary087.conditionSuccess (rawLaw env input)

theorem success_mass (env : Env) (input : Input env) :
    KeygenLawBoundary087.successMass (rawLaw env input) = KeygenProbability110.successMass env input := by
  classical
  rw [raw_binding, KeygenConditionMap110.success_map]
  exact KeygenWholeLaw088.packet_success_mass _

theorem conditioned_binding (env : Env) (input : Input env) (q : Law KeygenWholeBytes088.Packet)
    (constructed : KeygenProbability110.successfulLaw env input = some q) :
    successfulLaw env input = some (q.map joint) := by
  classical
  unfold successfulLaw
  rw [raw_binding]
  exact KeygenConditionMap110.condition_map _ joint q constructed

theorem none_iff (env : Env) (input : Input env) :
    successfulLaw env input = none ↔ KeygenProbability110.successMass env input = 0 := by
  rw [successfulLaw, KeygenLawBoundary087.condition_none_iff, success_mass]

end FT1536.Source3.KeygenModelLaw111
