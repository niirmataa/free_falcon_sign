import Source3.KeygenTailFunction108
import Source3.KeygenSeedTrace092

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWholeTrace109
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenWholeCall088 (Failure)

/-- The whole actual source chain before the packet/certificate consumer:
    no codec postcondition or Addresses assertion is a constructor field. -/
inductive Trace (env : Env) (caller : State) where
  | readiness (bound : State) (events : List KeygenEntropySource.Event) (raw : Result)
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) bound)
      (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events raw) (exit : raw.flow ≠ .normal)
  | capped (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut : Result)
      (attempts : List (KeygenCertificateSource080.AttemptExecution (canonical env).ctx))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) bound)
      (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩)
      (loop : KeygenCertificateSource080.Loop (canonical env).ctx entry loopOut attempts)
      (aborted : loopOut.flow = KeygenCapExecution.abortFlow)
  | tail (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut tailOut : Result)
      (attempts : List (KeygenCertificateSource080.AttemptExecution (canonical env).ctx))
      (calls : List (KeygenPublicCallerSite077.Site (canonical env)))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values (canonical env).args) bound)
      (ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩)
      (loop : KeygenCertificateSource080.Loop (canonical env).ctx entry loopOut attempts) (normal : loopOut.flow = .normal)
      (encoding : KeygenPublicCallerExecution077.Encoding (canonical env) KeygenMakeProgram.encoding loopOut.state tailOut calls)

def Trace.out : Trace env caller → Result
  | .readiness bound _ raw _ _ _ => KeygenMakeLifetime.close bound (canonical env).blocks raw
  | .capped bound _ _ out _ _ _ _ _ => KeygenMakeLifetime.close bound (canonical env).blocks out
  | .tail bound _ _ _ out _ _ _ _ _ _ _ => KeygenMakeLifetime.close bound (canonical env).blocks out

def Trace.failure : Trace env caller → Option Failure
  | .readiness _ _ _ _ _ _ => some .readiness
  | .capped _ _ _ _ _ _ _ _ _ => some .attemptLimit
  | .tail _ _ _ _ out _ _ _ _ _ _ _ =>
      if out.flow = .returned (some (.int32 1)) then none else some .encoding

def forget (env : Env) (caller : State) : KeygenWholeCall088.Trace (canonical env) caller → Trace env caller
  | .readiness bound events raw binding ready exit => .readiness bound events raw binding ready exit
  | .capped bound entry events loopOut attempts binding ready loop aborted => .capped bound entry events loopOut attempts binding ready loop aborted
  | .tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal encoding _ =>
      .tail bound entry events loopOut tailOut attempts calls binding ready loop normal encoding
  | .encoded bound entry events loopOut tailOut attempts binding ready loop normal source _ =>
      .tail bound entry events loopOut tailOut attempts source.publicCalls binding ready loop normal
        (KeygenSecretTailBinding081.to_encoding (canonical env) loopOut.state tailOut source)

theorem forget_out (env : Env) (caller : State) (source : KeygenWholeCall088.Trace (canonical env) caller) :
    (forget env caller source).out = source.out := by cases source <;> rfl

theorem forget_failure (env : Env) (caller : State) (source : KeygenWholeCall088.Trace (canonical env) caller) :
    (forget env caller source).failure = source.failure := by
  cases source
  all_goals simp_all [forget, Trace.failure, KeygenWholeCall088.Trace.failure]

/-- Every raw source path acquires the consumer's address evidence from
    actual stores/frame/decoding; failures are not discarded by refinement. -/
theorem refine (env : Env) (caller : State) (domain : KeygenWholeBytes088.Domain (canonical env) caller)
    (raw : Trace env caller) : ∃ source : KeygenWholeCall088.Trace (canonical env) caller,
      source.out = raw.out ∧ source.failure = raw.failure := by
  cases raw with
  | readiness bound events out binding ready exit => exact ⟨.readiness bound events out binding ready exit, rfl, rfl⟩
  | capped bound entry events out attempts binding ready loop aborted =>
      exact ⟨.capped bound entry events out attempts binding ready loop aborted, rfl, rfl⟩
  | tail bound entry events loopOut tailOut attempts calls binding ready loop normal encoding =>
      have exits := KeygenMakeInvocation.tail_exit (canonical env) loopOut.state tailOut
        (KeygenEncodingOps108.legacy (canonical env) KeygenMakeProgram.encoding loopOut.state tailOut ⟨calls,encoding⟩)
      rcases exits with success | failure
      · obtain ⟨source⟩ := KeygenSecretTailSource081.from_encoding (canonical env) loopOut.state tailOut calls encoding success
        let input := KeygenTailFunction108.from_loop env caller bound entry loopOut domain events attempts binding ready loop normal
        have addresses := KeygenSkeBinding108.addresses env loopOut.state tailOut input.cells input.separate source
        refine ⟨.encoded bound entry events loopOut tailOut attempts binding ready loop normal source addresses, rfl, ?_⟩
        simp only [KeygenWholeCall088.Trace.failure, Trace.failure, success, ite_true]
      · refine ⟨.tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal encoding failure, rfl, ?_⟩
        simp [KeygenWholeCall088.Trace.failure, Trace.failure, failure]

theorem complete_outputs (env : Env) (caller : State) (domain : KeygenWholeBytes088.Domain (canonical env) caller)
    (out : Result) (failure : Option Failure) :
    (∃ raw : Trace env caller, raw.out = out ∧ raw.failure = failure) ↔
    (∃ source : KeygenWholeCall088.Trace (canonical env) caller, source.out = out ∧ source.failure = failure) := by
  constructor
  · rintro ⟨raw, result, classified⟩
    obtain ⟨source, same, tag⟩ := refine env caller domain raw
    exact ⟨source, same.trans result, tag.trans classified⟩
  · rintro ⟨source, result, classified⟩
    exact ⟨forget env caller source, (forget_out env caller source).trans result,
      (forget_failure env caller source).trans classified⟩

end FT1536.Source3.KeygenWholeTrace109
