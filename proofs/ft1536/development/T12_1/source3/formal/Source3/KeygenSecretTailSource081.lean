import Source3.KeygenSecretCallerTrace081

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretTailSource081
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)

/-- A recoverable decomposition of the successful source tail. These are
    actual fixed-body derivations and an actual length-store instruction;
    there is no assumed codec value, length, write frame or decoder result. -/
structure Source (env : Env) (before : State) (out : Result) where
  headState : State
  segmentState : State
  suffixState : State
  privateCalls : List (KeygenCodecTypedSegments.Site env)
  publicCalls : List (KeygenPublicCallerSite077.Site env)
  prelude : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain before ⟨headState,.normal⟩
  segments : KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter headState)
    ⟨segmentState,.normal⟩ privateCalls
  lengthHead : KeygenMakeInvocation.Head env KeygenMakeInvocation.privkeyLenWrite segmentState ⟨suffixState,.normal⟩
  privateRun : KeygenMakeInvocation.Encoding env KeygenSecretCallerTrace081.privateCode before ⟨suffixState,.normal⟩
  publicRun : KeygenPublicCallerExecution077.Encoding env KeygenPublicCallerExecution077.code suffixState out publicCalls

/-- The already approved finite virtual-address legality on the ACTUAL
    four read pointers. This is a memory domain, independent of codec values. -/
def Addresses (env : Env) (before : State) (out : Result) (source : Source env before out) : Prop :=
  ∀ c, c∈source.privateCalls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb

theorem from_encoding (env : Env) (before : State) (out : Result)
    (publicCalls : List (KeygenPublicCallerSite077.Site env))
    (source : KeygenPublicCallerExecution077.Encoding env KeygenMakeProgram.encoding before out publicCalls)
    (success : out.flow=.returned (some (.int32 1))) : Nonempty (Source env before out) := by
  obtain ⟨headState,segmentState,suffixState,privateCalls,skoff,prelude,segments,cell,store,lengthHead,privateRun,publicRun⟩ :=
    KeygenSecretCallerTrace081.trace env before out publicCalls source success
  exact ⟨⟨headState,segmentState,suffixState,privateCalls,publicCalls,prelude,segments,lengthHead,privateRun,publicRun⟩⟩

end FT1536.Source3.KeygenSecretTailSource081
