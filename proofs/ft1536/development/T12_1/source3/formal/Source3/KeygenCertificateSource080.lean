import Source3.KeygenMakeAssembly080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCertificateSource080
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

/-- Evaluated source arguments and fixed body execution only. In particular
    the canonical workspace bridge is NOT supplied in this source relation. -/
inductive Call (ctx : Context) (before : State) : State → Value → Bool → Prop where
  | run (args : CertificateFunctionReference.Arguments)
      (cells : KeygenMakeWorkspaceBridge.Cells before ctx args)
      (base : args.base=ctx.scratch.offset)
      (after : Memory) (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event)
      (ret : Bool)
      (body : KeygenMakeCertRelocation.ExecAt ctx.scratch.block args before.heap after gateTrace events ret)
      (v : Value) (bit : ret=true ↔ v.integer≠0) : Call ctx before {before with heap := after} v ret

theorem call_projection (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) (source : Call ctx before after v ret) :
    KeygenMakeCertRelocation.CallAt ctx.scratch.block ctx before after v ret := by
  cases source with
  | run args cells base after gateTrace events ret body v bit =>
    have canonical := KeygenMakeWorkspaceBridge.cert_bind_relocated before ctx args cells shape base
    have bind := (KeygenMakeCertRelocation.certBindAt_iff ctx.scratch.block before ctx args).mpr canonical
    exact KeygenMakeCertRelocation.callAt_run ctx.scratch.block ctx before args bind after gateTrace events ret body v bit

inductive Gate (ctx : Context) (before : State) : Result → Prop where
  | rejected (after : State) (v : Value) (call : Call ctx before after v false) :
      Gate ctx before ⟨after,.continueLoop⟩
  | accepted (after : State) (v : Value) (call : Call ctx before after v true) :
      Gate ctx before ⟨after,.breakLoop⟩
  | unprofiled (noProfile : ¬KeygenMakeCertCall.Profile before) : Gate ctx before ⟨before,.breakLoop⟩

theorem gate_projection (ctx : Context) (before : State) (out : Result)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) (source : Gate ctx before out) :
    KeygenMakeCertRelocation.CertificateGateAt ctx.scratch.block ctx before out := by
  cases source with
  | rejected after v call =>
    exact KeygenMakeCertRelocation.gateAt_rejected ctx.scratch.block ctx before after v
      (call_projection ctx before after v false shape call)
  | accepted after v call =>
    exact KeygenMakeCertRelocation.gateAt_accepted ctx.scratch.block ctx before after v
      (call_projection ctx before after v true shape call)
  | unprofiled noProfile => exact KeygenMakeCertRelocation.gateAt_unprofiled ctx.scratch.block ctx before noProfile

inductive Attempt (ctx : Context) (before : State) : Result → Prop where
  | earlyRejected (raw : Result) (sample : KeygenMakeSearchPrefix.Sampled ctx before raw)
      (rejected : raw.flow=.continueLoop) : Attempt ctx before raw
  | throughCertificate (raw : Result) (sample : KeygenMakeSearchPrefix.Sampled ctx before raw)
      (atCert : raw.flow=.normal) (out : Result) (gate : Gate ctx raw.state out) : Attempt ctx before out

theorem attempt_projection (ctx : Context) (before : State) (out : Result)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx) (source : Attempt ctx before out) :
    KeygenAttemptAt080.Exec ctx before out := by
  cases source with
  | earlyRejected raw sample rejected => exact .earlyRejected _ sample rejected
  | throughCertificate raw sample atCert out gate =>
    exact .throughCertificate raw sample atCert out (gate_projection ctx raw.state out shape gate)

structure AttemptExecution (ctx : Context) where
  before : State
  out : Result
  source : Attempt ctx before out

def projected (ctx : Context) (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (a : AttemptExecution ctx) : KeygenLoopAt080.AttemptExecution ctx :=
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
    KeygenLoopAt080.LoopTrace ctx before out (attempts.map (projected ctx shape)) := by
  induction source with
  | exhausted before out cap exit => exact .exhausted before out cap exit
  | accepted a accepted => exact .accepted (projected ctx shape a) accepted
  | retry a out rest rejected tail ih => exact .retry (projected ctx shape a) out _ rejected ih

end FT1536.Source3.KeygenCertificateSource080
