import Source3.KeygenSourceToFiber001

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Whole finite calls, including every original return-0 branch. This
   retains the source states and entropy events; no attempt law or IID
   premise is part of the construction. A finite call is not a theorem
   that every seed produces a finite call. -/
namespace FT1536.Source3.KeygenWholeCall088
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result Flow)
open KeygenMakeInvocation (Env)

inductive Failure where
  | readiness | attemptLimit | encoding
  deriving DecidableEq, Repr

instance : Fintype Failure where
  elems := {.readiness, .attemptLimit, .encoding}
  complete x := by cases x <;> simp

abbrev Attempt (env : Env) := KeygenCertificateSource080.AttemptExecution env.ctx

/-- The same four source branches as PinnedExec, retained as trace data.
    The encoded branch can still fail in the public encoding suffix. -/
inductive Trace (env : Env) (caller : State) where
  | readiness (bound : State) (events : List KeygenEntropySource.Event) (raw : Result)
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events raw) (exit : raw.flow ≠ .normal)
  | capped (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut : Result)
      (attempts : List (Attempt env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry, .normal⟩)
      (loop : KeygenCertificateSource080.Loop env.ctx entry loopOut attempts)
      (aborted : loopOut.flow = KeygenCapExecution.abortFlow)
  | tailRejected (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut tailOut : Result)
      (attempts : List (Attempt env)) (publicCalls : List (KeygenPublicCallerSite077.Site env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry, .normal⟩)
      (loop : KeygenCertificateSource080.Loop env.ctx entry loopOut attempts) (normal : loopOut.flow = .normal)
      (tail : KeygenPublicCallerExecution077.Encoding env KeygenMakeProgram.encoding loopOut.state tailOut publicCalls)
      (rejected : tailOut.flow = .returned (some (.int32 0)))
  | encoded (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut tailOut : Result)
      (attempts : List (Attempt env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry, .normal⟩)
      (loop : KeygenCertificateSource080.Loop env.ctx entry loopOut attempts) (normal : loopOut.flow = .normal)
      (tail : KeygenSecretTailSource081.Source env loopOut.state tailOut)
      (addresses : KeygenSecretTailSource081.Addresses env loopOut.state tailOut tail)

def Trace.out : Trace env caller → Result
  | .readiness bound _ raw _ _ _ => KeygenMakeLifetime.close bound env.blocks raw
  | .capped bound _ _ loopOut _ _ _ _ _ => KeygenMakeLifetime.close bound env.blocks loopOut
  | .tailRejected bound _ _ _ tailOut _ _ _ _ _ _ _ _ => KeygenMakeLifetime.close bound env.blocks tailOut
  | .encoded bound _ _ _ tailOut _ _ _ _ _ _ _ => KeygenMakeLifetime.close bound env.blocks tailOut

def Trace.events : Trace env caller → List KeygenEntropySource.Event
  | .readiness _ events _ _ _ _ => events
  | .capped _ _ events _ _ _ _ _ _ => events
  | .tailRejected _ _ events _ _ _ _ _ _ _ _ _ _ => events
  | .encoded _ _ events _ _ _ _ _ _ _ _ _ => events

def Trace.attempts : Trace env caller → List (Attempt env)
  | .readiness _ _ _ _ _ _ => []
  | .capped _ _ _ _ attempts _ _ _ _ => attempts
  | .tailRejected _ _ _ _ _ attempts _ _ _ _ _ _ _ => attempts
  | .encoded _ _ _ _ _ attempts _ _ _ _ _ _ => attempts

theorem Trace.source (t : Trace env caller) :
    KeygenSourceToFiber001.PinnedExec env caller t.out := by
  cases t with
  | readiness bound events raw binding ready exit => exact .readiness bound events raw binding ready exit
  | capped bound entry events loopOut attempts binding ready loop aborted =>
      exact .capped bound entry events loopOut attempts binding ready loop aborted
  | tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected =>
      exact .tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected
  | encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses =>
      exact .encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses

/-- This equivalence prevents a probabilistic consumer from keeping only
    the successful branch or discarding encoding failures. -/
theorem trace_iff_source (env : Env) (caller : State) (out : Result) :
    (∃ t : Trace env caller, t.out = out) ↔ KeygenSourceToFiber001.PinnedExec env caller out := by
  constructor
  · rintro ⟨t, rfl⟩
    exact t.source
  · intro source
    cases source with
    | readiness bound events raw binding ready exit =>
        exact ⟨.readiness bound events raw binding ready exit, rfl⟩
    | capped bound entry events loopOut attempts binding ready loop aborted =>
        exact ⟨.capped bound entry events loopOut attempts binding ready loop aborted, rfl⟩
    | tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected =>
        exact ⟨.tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected, rfl⟩
    | encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses =>
        exact ⟨.encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses, rfl⟩

theorem Trace.returned (t : Trace env caller) :
    t.out.flow = .returned (some (.int32 0)) ∨ t.out.flow = .returned (some (.int32 1)) := by
  cases t with
  | readiness bound events raw binding ready exit =>
      exact Or.inl (KeygenMakeLifetime.failed_prefix_result env.ctx bound env.blocks events raw ready exit)
  | capped bound entry events loopOut attempts binding ready loop aborted => exact Or.inl aborted
  | tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected =>
      exact Or.inl rejected
  | encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses =>
      have whole := KeygenSecretTailBinding081.to_encoding env loopOut.state tailOut tail
      obtain ⟨calls, typed⟩ := KeygenPublicCallerExecution077.erase env _ _ _ _ whole
      have old := KeygenCodecInvocation.encoding_erase env _ _ _ calls typed
      exact (KeygenMakeInvocation.tail_exit env _ _ old).symm

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

theorem Trace.failure_some_iff_zero (t : Trace env caller) :
    t.failure.isSome = true ↔ t.out.flow = .returned (some (.int32 0)) := by
  have hnone := t.failure_none_iff
  rcases t.returned with zero | one
  · have notSuccess : ¬ KeygenSourceToFiber001.Success t.out := by
      simp [KeygenSourceToFiber001.Success, zero]
    have notNone : t.failure ≠ none := fun h => notSuccess (hnone.mp h)
    simp [Option.isSome_iff_ne_none, notNone, zero]
  · have success : KeygenSourceToFiber001.Success t.out := one
    simp [hnone.mpr success, one]

theorem loop_count (env : Env) (caller bound entry : State) (out : Result)
    (primes rev : ArrayPointer) (legal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (events : List KeygenEntropySource.Event) (attempts : List (Attempt env))
    (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
    (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry, .normal⟩)
    (loop : KeygenCertificateSource080.Loop env.ctx entry out attempts) :
    attempts.length ≤ 3000000 := by
  have original : KeygenMakeEntry.Original env.ctx bound primes rev := by
    rw [KeygenMakeArguments.bind_exact caller env.args bound binding]
    exact legal.original
  have shape : KeygenMakeWorkspaceBridge.Shape env.ctx := ⟨legal.workspaceExtent, legal.workspaceAligned⟩
  have remaining := KeygenMakeLoopChronology.entry_remaining env bound entry primes rev events original ready
  have source := KeygenCertificateSource080.loop_projection env.ctx entry out attempts shape loop
  have count := (KeygenLoopAt080.loop_bounds env.ctx entry out _ source 0 remaining).1
  simpa only [List.length_map, Nat.zero_add, KeygenAttemptCap.limit] using count

theorem Trace.attempt_bound (t : Trace env caller) (primes rev : ArrayPointer)
    (legal : KeygenMakeAssembly080.LegalEntry env caller primes rev) : t.attempts.length ≤ 3000000 := by
  cases t with
  | readiness => exact Nat.zero_le _
  | capped bound entry events loopOut attempts binding ready loop aborted =>
      exact loop_count env caller bound entry loopOut primes rev legal events attempts binding ready loop
  | tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected =>
      exact loop_count env caller bound entry loopOut primes rev legal events attempts binding ready loop
  | encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses =>
      exact loop_count env caller bound entry loopOut primes rev legal events attempts binding ready loop

end FT1536.Source3.KeygenWholeCall088
