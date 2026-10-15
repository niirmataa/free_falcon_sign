import Source3.KeygenCertificateSource080
import Source3.KeygenMakeAssembly080
import Source3.KeygenAttemptAt134
import Source3.KeygenLoopAt134
import Source3.KeygenMakeSearchPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenCertificateSource134
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)




open KeygenCertificateSource080
inductive Attempt (ctx : Context) (before : State) : Result → Prop where
  | earlyRejected (raw : Result) (sample : KeygenMakeSearchPrefix134.Sampled ctx before raw)
      (rejected : raw.flow=.continueLoop) : Attempt ctx before raw
  | throughCertificate (raw : Result) (sample : KeygenMakeSearchPrefix134.Sampled ctx before raw)
      (atCert : raw.flow=.normal) (out : Result) (gate : Gate ctx raw.state out) : Attempt ctx before out

theorem attempt_projection (ctx : Context) (before : State) (out : Result)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) (source : Attempt ctx before out) :
    KeygenAttemptAt134.Exec ctx before out := by
  cases source with
  | earlyRejected raw sample rejected => exact .earlyRejected _ sample rejected
  | throughCertificate raw sample atCert out gate =>
    exact .throughCertificate raw sample atCert out (gate_projection ctx raw.state out shape gate)

structure AttemptExecution (ctx : Context) where
  before : State
  out : Result
  source : Attempt ctx before out

def projected (ctx : Context) (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (a : AttemptExecution ctx) : KeygenLoopAt134.AttemptExecution ctx :=
  ⟨a.before,a.out,attempt_projection ctx a.before a.out shape a.source⟩

inductive Loop (ctx : Context) : State → Result → List (AttemptExecution ctx) → Prop where
  | exhausted (before : State) (out : Result) (cap : KeygenMakeSampling.CappedSetup ctx before out)
      (exit : out.flow≠.normal) : Loop ctx before out []
  | accepted (a : AttemptExecution ctx) (accepted : a.out.flow=.breakLoop) :
      Loop ctx a.before ⟨a.out.state,.normal⟩ [a]
  | retry (a : AttemptExecution ctx) (out : Result) (rest : List (AttemptExecution ctx))
      (rejected : a.out.flow=.continueLoop) (tail : Loop ctx a.out.state out rest) :
      Loop ctx a.before out (a::rest)

theorem loop_projection (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (source : Loop ctx before out attempts) :
    KeygenLoopAt134.LoopTrace ctx before out (attempts.map (projected ctx shape)) := by
  induction source with
  | exhausted before out cap exit => exact .exhausted before out cap exit
  | accepted a accepted => exact .accepted (projected ctx shape a) accepted
  | retry a out rest rejected tail ih => exact .retry (projected ctx shape a) out _ rejected ih

end FT1536.Source3.KeygenCertificateSource134
