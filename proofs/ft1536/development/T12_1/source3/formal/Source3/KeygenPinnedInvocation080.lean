import Source3.KeygenCertificateSource080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Root source relation with evaluated certificate arguments and no supplied
   workspace bridge, frame, material witness, codec result or encoded length. -/
namespace FT1536.Source3.KeygenPinnedInvocation080
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)

inductive PinnedExec (env : Env) (caller : State) : Result → Prop where
  | readiness (bound : State) (events : List KeygenEntropySource.Event) (raw : Result)
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events raw) (exit : raw.flow≠.normal) :
      PinnedExec env caller (KeygenMakeLifetime.close bound env.blocks raw)
  | capped (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut : Result)
      (attempts : List (KeygenCertificateSource080.AttemptExecution env.ctx))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry,.normal⟩)
      (loop : KeygenCertificateSource080.Loop env.ctx entry loopOut attempts) (aborted : loopOut.flow=KeygenCapExecution.abortFlow) :
      PinnedExec env caller (KeygenMakeLifetime.close bound env.blocks loopOut)
  | encoded (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut tailOut : Result)
      (attempts : List (KeygenCertificateSource080.AttemptExecution env.ctx)) (publicCalls : List (KeygenPublicCallerSite077.Site env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry,.normal⟩)
      (loop : KeygenCertificateSource080.Loop env.ctx entry loopOut attempts) (normal : loopOut.flow=.normal)
      (tail : KeygenPublicCallerExecution077.Encoding env KeygenMakeProgram.encoding loopOut.state tailOut publicCalls) :
      PinnedExec env caller (KeygenMakeLifetime.close bound env.blocks tailOut)


theorem projection (env : Env) (caller : State) (out : Result)
    (shape : KeygenMakeWorkspaceBridge.Shape env.ctx) (source : PinnedExec env caller out) :
    KeygenMakeAssembly080.Invocation env caller out := by
  cases source with
  | readiness bound events raw binding ready exit => exact .readiness bound events raw binding ready exit
  | capped bound entry events loopOut attempts binding ready loop aborted =>
    exact .capped bound entry events loopOut (attempts.map (KeygenCertificateSource080.projected env.ctx shape))
      binding ready (KeygenCertificateSource080.loop_projection env.ctx entry loopOut attempts shape loop) aborted
  | encoded bound entry events loopOut tailOut attempts publicCalls binding ready loop normal tail =>
    exact .encoded bound entry events loopOut tailOut (attempts.map (KeygenCertificateSource080.projected env.ctx shape))
      publicCalls binding ready (KeygenCertificateSource080.loop_projection env.ctx entry loopOut attempts shape loop) normal tail

/-- The B1.07 assembly export has only initial memory/profile facts, fixed
    source execution and its observed return. No intermediate correctness
    or workspace bridge is a premise. Full emitted-byte acceptance follows
    only after the separate B1.08/B1.09 observations have been proved. -/
theorem successful_frontier (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (legal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (source : PinnedExec env caller out) (success : out.flow=.returned (some (.int32 1))) :
    Nonempty (KeygenMakeAssembly080.Frontier env caller out) :=
  KeygenMakeAssembly080.successful_frontier env caller out primes rev legal
    (projection env caller out ⟨legal.workspaceExtent,legal.workspaceAligned⟩ source) success

end FT1536.Source3.KeygenPinnedInvocation080
