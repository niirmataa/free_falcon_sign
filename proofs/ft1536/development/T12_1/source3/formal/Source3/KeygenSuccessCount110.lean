import Source3.KeygenProbability110
import Source3.KeygenConditionMap110

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSuccessCount110
open Finset
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenWholeLaw088 (CallOutcome)
open KeygenInputLaw110 (seedLaw)

def Successful (out : CallOutcome) : Prop := ∃ packet, out = some (.inr packet)

instance successfulDecidable : DecidablePred Successful := by
  intro out
  cases out with
  | none => exact isFalse (by rintro ⟨packet, equal⟩; cases equal)
  | some result =>
      cases result with
      | inl failure => exact isFalse (by rintro ⟨packet, equal⟩; cases equal)
      | inr packet => exact isTrue ⟨packet, rfl⟩

theorem success_none : ¬ Successful none := by rintro ⟨packet, equal⟩; cases equal

theorem success_failure (cause : KeygenWholeCall088.Failure) : ¬ Successful (some (.inl cause)) := by
  rintro ⟨packet, equal⟩
  cases equal

theorem success_packet (packet : KeygenWholeBytes088.Packet) : Successful (some (.inr packet)) := ⟨packet, rfl⟩

theorem successful_event (p : Law CallOutcome) : p.event Successful = KeygenWholeLaw088.emittedMass p := by
  classical
  simp [Law.event, KeygenWholeLaw088.emittedMass, Fintype.sum_option, Fintype.sum_sum_type,
    success_none, success_failure, success_packet]

theorem uniform_event (event : Seed → Prop) [DecidablePred event] :
    seedLaw.event event = ((univ.filter event).card : ℝ) / (2:ℝ)^256 := by
  classical
  unfold Law.event
  simp_rw [KeygenInputLaw110.seed_mass]
  rw [← sum_filter]
  simp [div_eq_mul_inv]

theorem success_count (env : Env) (input : Input env) :
    KeygenProbability110.successMass env input =
      ((univ.filter (fun seed : Seed => Successful (KeygenByteGame109.evaluate env input seed))).card : ℝ) / (2:ℝ)^256 := by
  classical
  rw [KeygenProbability110.successMass, ← successful_event]
  change (seedLaw.map (KeygenByteGame109.evaluate env input)).event Successful = _
  rw [KeygenLawAlgebra110.map_event, uniform_event]

end FT1536.Source3.KeygenSuccessCount110
