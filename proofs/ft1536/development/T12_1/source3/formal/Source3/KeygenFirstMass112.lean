import Source3.KeygenFirstAttempt112

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenFirstMass112
open Finset
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenInputLaw110 (seedLaw)
open KeygenFirstAttempt112 (Accepted FirstEmitted)

variable {A : Type} [Fintype A]

theorem event_nonneg (p : Law A) (event : A → Prop) [DecidablePred event] : 0 ≤ p.event event := by
  unfold Law.event
  apply sum_nonneg
  intro a _
  split <;> first | exact p.nonneg a | exact le_refl 0

theorem event_mono (p : Law A) (left right : A → Prop) [DecidablePred left] [DecidablePred right]
    (included : ∀ a, left a → right a) : p.event left ≤ p.event right := by
  unfold Law.event
  apply sum_le_sum
  intro a _
  by_cases hl : left a
  · simp [hl, included a hl]
  · simp only [hl, ite_false]
    split <;> first | exact p.nonneg a | exact le_refl 0

noncomputable def acceptMass (env : Env) (input : Input env) : ℝ := by
  classical
  exact seedLaw.event (Accepted env input)

noncomputable def encodedMass (env : Env) (input : Input env) : ℝ := by
  classical
  exact seedLaw.event (FirstEmitted env input)

/-- This ratio denotes P(first encoding succeeds | first acceptance) only
    when acceptMass is positive. Its zero-denominator convention is not a
    fabricated conditional probability law. -/
noncomputable def codingRatio (env : Env) (input : Input env) : ℝ :=
  encodedMass env input / acceptMass env input

theorem encoded_le_accept (env : Env) (input : Input env) : encodedMass env input ≤ acceptMass env input := by
  classical
  exact event_mono seedLaw _ _ (KeygenFirstAttempt112.first_emitted_accepted env input)

theorem whole_success_event (env : Env) (input : Input env) :
    KeygenProbability110.successMass env input =
      seedLaw.event (fun seed => KeygenSuccessCount110.Successful (KeygenByteGame109.evaluate env input seed)) := by
  classical
  rw [KeygenSuccessCount110.success_count, KeygenSuccessCount110.uniform_event]

theorem encoded_le_whole (env : Env) (input : Input env) :
    encodedMass env input ≤ KeygenProbability110.successMass env input := by
  classical
  rw [whole_success_event]
  exact event_mono seedLaw _ _ (KeygenFirstAttempt112.first_emitted_success env input)

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
    acceptMass env input * codingRatio env input ≤ KeygenProbability110.successMass env input := by
  rw [factorization]
  exact encoded_le_whole env input

/-- A quantitative consumer, not a proof of either numerical premise.
    In particular F04 does not supply acceptedLower for KeyGen. -/
theorem quantitative (env : Env) (input : Input env) (a c : ℝ)
    (acceptedLower : a ≤ acceptMass env input) (codingLower : c ≤ codingRatio env input)
    (codingNonnegative : 0 ≤ c) : a*c ≤ KeygenProbability110.successMass env input := by
  classical
  calc
    a*c ≤ acceptMass env input * codingRatio env input :=
      mul_le_mul acceptedLower codingLower codingNonnegative (event_nonneg seedLaw _)
    _ ≤ KeygenProbability110.successMass env input := first_attempt_bound env input

end FT1536.Source3.KeygenFirstMass112
