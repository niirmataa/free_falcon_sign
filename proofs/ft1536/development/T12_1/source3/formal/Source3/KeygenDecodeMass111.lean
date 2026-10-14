import Source3.KeygenModelBinding111

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeMass111
open Finset
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenWholeBytes088 (Packet)
open KeygenDecodedKey111 (decode)

/-- Invalid totalization defaults have zero successful source mass. -/
theorem raw_zero (env : Env) (input : Input env) (packet : Packet)
    (invalid : decode packet = none) :
    (KeygenProbability110.law env input).mass (some (.inr packet)) = 0 := by
  apply le_antisymm _ ((KeygenProbability110.law env input).nonneg _)
  by_contra positive
  obtain ⟨seed, returned⟩ := KeygenProbability110.positive_source env input packet (lt_of_not_ge positive)
  have decoded := KeygenDecodedKey111.source_decode env input seed packet returned
  rw [invalid] at decoded
  cases decoded

theorem conditional_zero (env : Env) (input : Input env) (q : Law Packet)
    (constructed : KeygenProbability110.successfulLaw env input = some q)
    (packet : Packet) (invalid : decode packet = none) : q.mass packet = 0 := by
  rw [KeygenProbability110.conditional_mass env input q constructed packet,
    raw_zero env input packet invalid, zero_div]

theorem decoding_failure_mass (env : Env) (input : Input env) (q : Law Packet)
    (constructed : KeygenProbability110.successfulLaw env input = some q) :
    q.event (fun packet => decode packet = none) = 0 := by
  classical
  unfold Law.event
  apply sum_eq_zero
  intro packet _
  by_cases invalid : decode packet = none
  · simp [invalid, conditional_zero env input q constructed packet invalid]
  · simp [invalid]

/-- Projection to model keys neither gains nor loses whole-call failures. -/
theorem model_failure_mass (env : Env) (input : Input env) :
    (KeygenModelLaw111.rawLaw env input).mass none =
      KeygenWholeLaw088.noReturnMass (KeygenProbability110.law env input) +
      ∑ cause, KeygenWholeLaw088.failureMass (KeygenProbability110.law env input) cause := by
  have total := KeygenLawBoundary087.failure_success (KeygenModelLaw111.rawLaw env input)
  rw [KeygenModelLaw111.success_mass] at total
  have accounted := KeygenProbability110.accounting env input
  linarith

end FT1536.Source3.KeygenDecodeMass111
