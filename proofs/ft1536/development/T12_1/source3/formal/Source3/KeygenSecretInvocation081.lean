import Source3.KeygenSecretTailBinding081
import Source3.KeygenPinnedInvocation080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretInvocation081
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env inputOf publicOf)
open KeygenSecretTailSource081 (Source Addresses)

/-- Defined source execution retains the actual serialization trace and
    the inherited finite virtual-address legality at its pointer reads.
    No mathematical material, codec result/length/frame or decoder fact
    occurs in this relation. Return0 paths are retained separately. -/
inductive PinnedExec (env : Env) (caller : State) : Result → Prop where
  | readiness (bound : State) (events : List KeygenEntropySource.Event) (raw : Result)
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events raw) (exit : raw.flow≠.normal) :
      PinnedExec env caller (KeygenMakeLifetime.close bound env.blocks raw)
  | capped (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut : Result)
      (attempts : List (KeygenCertificateSource080.AttemptExecution env.ctx))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry,.normal⟩)
      (loop : KeygenCertificateSource080.Loop env.ctx entry loopOut attempts)
      (aborted : loopOut.flow=KeygenCapExecution.abortFlow) :
      PinnedExec env caller (KeygenMakeLifetime.close bound env.blocks loopOut)
  | tailRejected (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut tailOut : Result)
      (attempts : List (KeygenCertificateSource080.AttemptExecution env.ctx))
      (publicCalls : List (KeygenPublicCallerSite077.Site env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry,.normal⟩)
      (loop : KeygenCertificateSource080.Loop env.ctx entry loopOut attempts) (normal : loopOut.flow=.normal)
      (tail : KeygenPublicCallerExecution077.Encoding env KeygenMakeProgram.encoding loopOut.state tailOut publicCalls)
      (rejected : tailOut.flow=.returned (some (.int32 0))) :
      PinnedExec env caller (KeygenMakeLifetime.close bound env.blocks tailOut)
  | encoded (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut tailOut : Result)
      (attempts : List (KeygenCertificateSource080.AttemptExecution env.ctx))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry,.normal⟩)
      (loop : KeygenCertificateSource080.Loop env.ctx entry loopOut attempts) (normal : loopOut.flow=.normal)
      (tail : Source env loopOut.state tailOut) (addresses : Addresses env loopOut.state tailOut tail) :
      PinnedExec env caller (KeygenMakeLifetime.close bound env.blocks tailOut)

theorem projection (env : Env) (caller : State) (out : Result) (source : PinnedExec env caller out) :
    KeygenPinnedInvocation080.PinnedExec env caller out := by
  cases source with
  | readiness bound events raw binding ready exit => exact .readiness bound events raw binding ready exit
  | capped bound entry events loopOut attempts binding ready loop aborted =>
    exact .capped bound entry events loopOut attempts binding ready loop aborted
  | tailRejected bound entry events loopOut tailOut attempts publicCalls binding ready loop normal tail rejected =>
    exact .encoded bound entry events loopOut tailOut attempts publicCalls binding ready loop normal tail
  | encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses =>
    exact .encoded bound entry events loopOut tailOut attempts tail.publicCalls binding ready loop normal
      (KeygenSecretTailBinding081.to_encoding env loopOut.state tailOut tail)

structure Frontier (env : Env) (caller : State) (out : Result) where
  base : KeygenMakeAssembly080.Frontier env caller out
  tail : Source env base.loopOut.state base.tailOut
  addresses : Addresses env base.loopOut.state base.tailOut tail

theorem successful_frontier (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (legal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (source : PinnedExec env caller out) (success : out.flow=.returned (some (.int32 1))) :
    Nonempty (Frontier env caller out) := by
  cases source with
  | readiness bound events raw binding ready exit =>
    have failure := KeygenMakeLifetime.failed_prefix_result env.ctx bound env.blocks events raw ready exit
    rw [KeygenMakeLifetime.close_flow,failure] at success
    cases success
  | capped bound entry events loopOut attempts binding ready loop aborted =>
    rw [KeygenMakeLifetime.close_flow,aborted] at success
    cases success
  | tailRejected bound entry events loopOut tailOut attempts publicCalls binding ready loop normal tail rejected =>
    rw [KeygenMakeLifetime.close_flow,rejected] at success
    cases success
  | encoded bound entry events loopOut tailOut rawAttempts binding ready rawLoop normal tail addresses =>
    have boundEq := KeygenMakeArguments.bind_exact caller env.args bound binding
    have original : KeygenMakeEntry.Original env.ctx bound primes rev := by rw [boundEq]; exact legal.original
    have shape : KeygenMakeWorkspaceBridge.Shape env.ctx := ⟨legal.workspaceExtent,legal.workspaceAligned⟩
    let attempts := rawAttempts.map (KeygenCertificateSource080.projected env.ctx shape)
    have loop := KeygenCertificateSource080.loop_projection env.ctx entry loopOut rawAttempts shape rawLoop
    have space : KeygenMakeCertRelocation.SpaceAt env.ctx.scratch.block entry.heap := by
      change C99Automatic32.align4 (entry.heap.size env.ctx.scratch.block)+4<2^64
      rw [KeygenEntryAt080.scratch_size env.ctx bound entry env.blocks primes rev events original ready,boundEq]
      exact legal.workspaceSpace
    have facts := KeygenEntryAt080.entry_facts env.ctx bound entry env.blocks primes rev events original ready
    have remaining := KeygenMakeLoopChronology.entry_remaining env bound entry primes rev events original ready
    have cells := KeygenTailCellsAt080.loop_cells env entry loopOut attempts loop 0 remaining
      (KeygenMakeLoopChronology.entry_tail_cells env caller bound entry primes rev events original binding ready) normal
    have material := KeygenLoopMaterial080.material env.ctx entry loopOut attempts loop (inputOf env) (publicOf env)
      primes rev shape 0 remaining facts space normal
    have count := (KeygenLoopAt080.loop_bounds env.ctx entry loopOut attempts loop 0 remaining).1
    have certificate := KeygenLoopMaterial080.final_certificate env.ctx entry loopOut attempts loop (inputOf env)
      (publicOf env) primes rev shape 0 remaining facts.initial space normal
    have joined := KeygenSameCertificate080.loop_joined env.ctx entry loopOut attempts loop (inputOf env)
      (publicOf env) primes rev shape 0 remaining facts space normal
    exact ⟨⟨⟨bound,entry,events,loopOut,tailOut,attempts,tail.publicCalls,binding,ready,loop,normal,
      KeygenSecretTailBinding081.to_encoding env loopOut.state tailOut tail,success,rfl,
      cells,material.1,by simpa [KeygenAttemptCap.limit] using count,by simpa using joined,by simpa using certificate⟩,
      tail,addresses⟩⟩

end FT1536.Source3.KeygenSecretInvocation081
