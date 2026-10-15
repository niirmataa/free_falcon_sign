import Source3.KeygenSuccessCount110
import Source3.KeygenProbability110
import Source3.KeygenConditionMap110
import Source3.KeygenByteGame134
import Source3.KeygenProbability134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenSuccessCount134
open Finset
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenWholeLaw088 (CallOutcome)
open KeygenInputLaw110 (seedLaw)


open KeygenSuccessCount110
theorem success_count (env : Env) (input : Input env) :
    KeygenProbability134.successMass env input =
      ((univ.filter (fun seed : Seed => Successful (KeygenByteGame134.evaluate env input seed))).card : ℝ) / (2:ℝ)^256 := by
  classical
  rw [KeygenProbability134.successMass, ← successful_event]
  change (seedLaw.map (KeygenByteGame134.evaluate env input)).event Successful = _
  rw [KeygenLawAlgebra110.map_event, uniform_event]

end FT1536.Source3.KeygenSuccessCount134
