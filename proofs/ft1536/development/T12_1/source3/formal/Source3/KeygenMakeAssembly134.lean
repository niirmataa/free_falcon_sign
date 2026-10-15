import Source3.KeygenMakeAssembly080
import Source3.KeygenEntryAt080
import Source3.KeygenTailCellsAt080
import Source3.KeygenLoopMaterial080
import Source3.KeygenPublicCallerExecution077
import Source3.KeygenSameCertificate080
import Source3.KeygenLoopAt134
import Source3.KeygenLoopMaterial134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenMakeAssembly134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env inputOf publicOf)
open KeygenLoopAt080 hiding AttemptAccepted AttemptExecution AttemptRejected BoundFacts LoopTrace Numbered loop_bounds source_bounds
open KeygenLoopAt134
open KeygenMakeAssembly080
structure Frontier (env : Env) (caller : State) (out : Result) where
  bound : State
  entry : State
  events : List KeygenEntropySource.Event
  loopOut : Result
  tailOut : Result
  attempts : List (AttemptExecution env.ctx)
  publicCalls : List (KeygenPublicCallerSite077.Site env)
  binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound
  ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry,.normal⟩
  loop : LoopTrace env.ctx entry loopOut attempts
  loopNormal : loopOut.flow=.normal
  tail : KeygenPublicCallerExecution077.Encoding env KeygenMakeProgram.encoding loopOut.state tailOut publicCalls
  tailSuccess : tailOut.flow=.returned (some (.int32 1))
  output : out=KeygenMakeLifetime.close bound env.blocks tailOut
  cells : KeygenMakeInvocation.TailCells env loopOut.state
  material : KeygenMakeMaterialWitness.Witness loopOut.state.heap (inputOf env) (publicOf env)
  countBound : attempts.length≤3000000
  joined : KeygenSameCertificate080.Joined env.ctx attempts.length (inputOf env) (publicOf env) loopOut.state
  finalCertificate : ∃ rejected final, attempts=rejected++[final] ∧
    (∀ a∈rejected, AttemptRejected a) ∧ AttemptAccepted final ∧ final.out.state=loopOut.state ∧
    KeygenLoopMaterial134.AttemptCertificate env.ctx attempts.length final

def callId (env : Env) (caller : State) (out : Result) (frontier : Frontier env caller out) : Nat :=
  frontier.attempts.length

theorem call_id_bound (env : Env) (caller : State) (out : Result) (frontier : Frontier env caller out) :
    1≤callId env caller out frontier ∧ callId env caller out frontier≤3000000 := by
  obtain ⟨rejected,final,shape,_,_,_,_⟩ := frontier.finalCertificate
  have positive : 1≤frontier.attempts.length := by rw [shape,List.length_append,List.length_singleton]; omega
  exact ⟨positive,frontier.countBound⟩

end FT1536.Source3.KeygenMakeAssembly134
