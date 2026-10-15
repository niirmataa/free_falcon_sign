import Source3.KeygenWholeCall088
import Source3.KeygenSourceToFiber001
import Source3.KeygenCertificateSource134
import Source3.KeygenSourceToFiber134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenWholeCall134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result Flow)
open KeygenMakeInvocation (Env)


open KeygenWholeCall088
abbrev Attempt (env : Env) := KeygenCertificateSource134.AttemptExecution env.ctx

inductive Trace (env : Env) (caller : State) where
  | readiness (bound : State) (events : List KeygenEntropySource.Event) (raw : Result)
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events raw) (exit : raw.flow ≠ .normal)
  | capped (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut : Result)
      (attempts : List (Attempt env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry, .normal⟩)
      (loop : KeygenCertificateSource134.Loop env.ctx entry loopOut attempts)
      (aborted : loopOut.flow = KeygenCapExecution.abortFlow)
  | tailRejected (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut tailOut : Result)
      (attempts : List (Attempt env)) (publicCalls : List (KeygenPublicCallerSite077.Site env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry, .normal⟩)
      (loop : KeygenCertificateSource134.Loop env.ctx entry loopOut attempts) (normal : loopOut.flow = .normal)
      (tail : KeygenPublicCallerExecution077.Encoding env KeygenMakeProgram.encoding loopOut.state tailOut publicCalls)
      (rejected : tailOut.flow = .returned (some (.int32 0)))
  | encoded (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut tailOut : Result)
      (attempts : List (Attempt env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry, .normal⟩)
      (loop : KeygenCertificateSource134.Loop env.ctx entry loopOut attempts) (normal : loopOut.flow = .normal)
      (tail : KeygenSecretTailSource081.Source env loopOut.state tailOut)
      (addresses : KeygenSecretTailSource081.Addresses env loopOut.state tailOut tail)

def Trace.out : Trace env caller → Result
  | .readiness bound _ raw _ _ _ => KeygenMakeLifetime.close bound env.blocks raw
  | .capped bound _ _ loopOut _ _ _ _ _ => KeygenMakeLifetime.close bound env.blocks loopOut
  | .tailRejected bound _ _ _ tailOut _ _ _ _ _ _ _ _ => KeygenMakeLifetime.close bound env.blocks tailOut
  | .encoded bound _ _ _ tailOut _ _ _ _ _ _ _ => KeygenMakeLifetime.close bound env.blocks tailOut

theorem Trace.source (t : Trace env caller) :
    KeygenSourceToFiber134.PinnedExec env caller t.out := by
  cases t with
  | readiness bound events raw binding ready exit => exact .readiness bound events raw binding ready exit
  | capped bound entry events loopOut attempts binding ready loop aborted =>
      exact .capped bound entry events loopOut attempts binding ready loop aborted
  | tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected =>
      exact .tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected
  | encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses =>
      exact .encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses

def Trace.failure (t : Trace env caller) : Option Failure :=
  match t with
  | .readiness _ _ _ _ _ _ => some .readiness
  | .capped _ _ _ _ _ _ _ _ _ => some .attemptLimit
  | .tailRejected _ _ _ _ _ _ _ _ _ _ _ _ _ => some .encoding
  | .encoded _ _ _ _ tailOut _ _ _ _ _ _ _ =>
      if tailOut.flow = .returned (some (.int32 1)) then none else some .encoding

theorem Trace.failure_none_iff (t : Trace env caller) :
    t.failure = none ↔ KeygenSourceToFiber001.Success t.out := by
  cases t with
  | readiness bound events raw binding ready exit =>
      have failed := KeygenMakeLifetime.failed_prefix_result env.ctx bound env.blocks events raw ready exit
      simp [Trace.failure, Trace.out, KeygenSourceToFiber001.Success, KeygenMakeLifetime.close_flow, failed]
  | capped bound entry events loopOut attempts binding ready loop aborted =>
      simp [Trace.failure, Trace.out, KeygenSourceToFiber001.Success, KeygenMakeLifetime.close_flow,
        aborted, KeygenCapExecution.abortFlow]
  | tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected =>
      simp [Trace.failure, Trace.out, KeygenSourceToFiber001.Success, KeygenMakeLifetime.close_flow, rejected]
  | encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses =>
      simp [Trace.failure, Trace.out, KeygenSourceToFiber001.Success, KeygenMakeLifetime.close_flow]

end FT1536.Source3.KeygenWholeCall134
