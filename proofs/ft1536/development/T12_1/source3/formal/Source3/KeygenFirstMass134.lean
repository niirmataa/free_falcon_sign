import Source3.KeygenFirstMass112
import Source3.KeygenFirstAttempt112
import Source3.KeygenByteGame134
import Source3.KeygenFirstAttempt134
import Source3.KeygenProbability134
import Source3.KeygenSuccessCount134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenFirstMass134
open Finset
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenInputLaw110 (seedLaw)
open KeygenFirstAttempt134 (Accepted FirstEmitted)

variable {A : Type} [Fintype A]


open KeygenFirstMass112
noncomputable def acceptMass (env : Env) (input : Input env) : ℝ := by
  classical
  exact seedLaw.event (Accepted env input)

noncomputable def encodedMass (env : Env) (input : Input env) : ℝ := by
  classical
  exact seedLaw.event (FirstEmitted env input)

noncomputable def codingRatio (env : Env) (input : Input env) : ℝ :=
  encodedMass env input / acceptMass env input

theorem encoded_le_accept (env : Env) (input : Input env) : encodedMass env input ≤ acceptMass env input := by
  classical
  exact event_mono seedLaw _ _ (KeygenFirstAttempt134.first_emitted_accepted env input)

theorem whole_success_event (env : Env) (input : Input env) :
    KeygenProbability134.successMass env input =
      seedLaw.event (fun seed => KeygenSuccessCount110.Successful (KeygenByteGame134.evaluate env input seed)) := by
  classical
  rw [KeygenSuccessCount134.success_count, KeygenSuccessCount110.uniform_event]

theorem encoded_le_whole (env : Env) (input : Input env) :
    encodedMass env input ≤ KeygenProbability134.successMass env input := by
  classical
  rw [whole_success_event]
  exact event_mono seedLaw _ _ (KeygenFirstAttempt134.first_emitted_success env input)

theorem factorization (env : Env) (input : Input env) :
    acceptMass env input * codingRatio env input = encodedMass env input := by
  classical
  by_cases zero : acceptMass env input = 0
  · have encodedZero : encodedMass env input = 0 :=
      le_antisymm (zero ▸ encoded_le_accept env input) (event_nonneg seedLaw _)
    simp [zero, encodedZero]
  · unfold codingRatio
    field_simp

theorem first_attempt_bound (env : Env) (input : Input env) :
    acceptMass env input * codingRatio env input ≤ KeygenProbability134.successMass env input := by
  rw [factorization]
  exact encoded_le_whole env input

theorem quantitative (env : Env) (input : Input env) (a c : ℝ)
    (acceptedLower : a ≤ acceptMass env input) (codingLower : c ≤ codingRatio env input)
    (codingNonnegative : 0 ≤ c) : a*c ≤ KeygenProbability134.successMass env input := by
  classical
  calc
    a*c ≤ acceptMass env input * codingRatio env input :=
      mul_le_mul acceptedLower codingLower codingNonnegative (event_nonneg seedLaw _)
    _ ≤ KeygenProbability134.successMass env input := first_attempt_bound env input

end FT1536.Source3.KeygenFirstMass134
