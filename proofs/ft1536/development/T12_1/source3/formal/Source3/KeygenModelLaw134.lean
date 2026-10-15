import Source3.KeygenModelLaw111
import Source3.KeygenDecodedKey111
import Source3.KeygenByteGame134
import Source3.KeygenDecodedKey134
import Source3.KeygenProbability134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenModelLaw134
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenDecodedKey111 (SecretKey joint decode)
open KeygenInputLaw110 (seedLaw)


open KeygenModelLaw111
noncomputable def byteOutcome (env : Env) (input : Input env) (seed : Seed) : Option KeygenWholeBytes088.Packet :=
  KeygenWholeLaw088.forget (KeygenByteGame134.evaluate env input seed)

noncomputable def modelOutcome (env : Env) (input : Input env) (seed : Seed) : Option Key :=
  (byteOutcome env input seed).bind decode

theorem pointwise (env : Env) (input : Input env) (seed : Seed) :
    modelOutcome env input seed = (byteOutcome env input seed).map joint := by
  cases h : KeygenByteGame134.evaluate env input seed with
  | none => simp [modelOutcome, byteOutcome, h, KeygenWholeLaw088.forget]
  | some out =>
      cases out with
      | inl failure => simp [modelOutcome, byteOutcome, h, KeygenWholeLaw088.forget]
      | inr packet =>
          have parsed := KeygenDecodedKey134.source_decode env input seed packet h
          simp [modelOutcome, byteOutcome, h, KeygenWholeLaw088.forget, parsed]

noncomputable def rawLaw (env : Env) (input : Input env) : Law (Option Key) := by
  classical
  exact seedLaw.map (modelOutcome env input)

theorem raw_binding (env : Env) (input : Input env) :
    rawLaw env input = (KeygenWholeLaw088.packetLaw (KeygenProbability134.law env input)).map (Option.map joint) := by
  classical
  have functions : modelOutcome env input = (Option.map joint) ∘ (KeygenWholeLaw088.forget ∘ KeygenByteGame134.evaluate env input) :=
    funext (pointwise env input)
  unfold rawLaw
  rw [functions]
  change seedLaw.map ((Option.map joint) ∘ (KeygenWholeLaw088.forget ∘ KeygenByteGame134.evaluate env input)) =
    ((seedLaw.map (KeygenByteGame134.evaluate env input)).map KeygenWholeLaw088.forget).map (Option.map joint)
  rw [KeygenLawAlgebra110.map_map, KeygenLawAlgebra110.map_map]
  rfl

noncomputable def successfulLaw (env : Env) (input : Input env) : Option (Law Key) :=
  KeygenLawBoundary087.conditionSuccess (rawLaw env input)

theorem conditioned_binding (env : Env) (input : Input env) (q : Law KeygenWholeBytes088.Packet)
    (constructed : KeygenProbability134.successfulLaw env input = some q) :
    successfulLaw env input = some (q.map joint) := by
  classical
  unfold successfulLaw
  rw [raw_binding]
  exact KeygenConditionMap110.condition_map _ joint q constructed

end FT1536.Source3.KeygenModelLaw134
