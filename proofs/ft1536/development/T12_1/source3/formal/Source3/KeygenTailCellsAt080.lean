import Source3.KeygenLoopAt080
import Source3.KeygenMakeLoopChronology

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenTailCellsAt080
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env TailCells)
open KeygenMakeLoopChronology

theorem attempt_arrays (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenAttemptAt080.Exec ctx before out) (n : Name)
    (outside : n∉KeygenCallerInit.rtNames) : out.state.arrays n=before.arrays n := by
  cases source with
  | earlyRejected idx sample rejected => exact sampled_arrays ctx before out i remaining sample n outside
  | throughCertificate raw sample atCert idx2 gate =>
    have dims := (KeygenMakeSearchPrefix.sampled_remaining ctx before raw i remaining sample).2.1.2.1
    obtain ⟨v,ret,call⟩ := KeygenRetryAt080.gate_call ctx raw.state out gate dims
    rw [(KeygenMakeCertRelocation.callAt_cells ctx.scratch.block ctx raw.state out.state v ret call).2.1]
    exact sampled_arrays ctx before raw i remaining sample n outside

theorem attempt_comp (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenAttemptAt080.Exec ctx before out) :
    out.state.locals "comp".toList=before.locals "comp".toList := by
  cases source with
  | earlyRejected idx sample rejected => exact sampled_comp ctx before out i remaining sample
  | throughCertificate raw sample atCert idx2 gate =>
    have dims := (KeygenMakeSearchPrefix.sampled_remaining ctx before raw i remaining sample).2.1.2.1
    obtain ⟨v,ret,call⟩ := KeygenRetryAt080.gate_call ctx raw.state out gate dims
    rw [(KeygenMakeCertRelocation.callAt_cells ctx.scratch.block ctx raw.state out.state v ret call).1]
    exact sampled_comp ctx before raw i remaining sample

theorem attempt_cells (env : Env) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (cells : TailCells env before) (source : KeygenAttemptAt080.Exec env.ctx before out) :
    TailCells env out.state := by
  have arrays := attempt_arrays env.ctx before out i remaining source
  have dims := (KeygenRetryAt080.attempt_remaining env.ctx before out i remaining source).2.1.2.1
  exact ⟨(arrays _ (by decide)).trans cells.privkey,
    (arrays _ (by decide)).trans cells.privkeyLen,
    (arrays _ (by decide)).trans cells.pubkey,
    (arrays _ (by decide)).trans cells.pubkeyLen,
    (attempt_comp env.ctx before out i remaining source).trans cells.comp,dims.2.1,dims.2.2,
    fun slot => (arrays _ (skeName_not_rt slot)).trans (cells.material slot),
    (arrays _ (by decide)).trans cells.publicCell,(arrays _ (by decide)).trans cells.ske⟩

theorem loop_cells (env : Env) (before : State) (out : Result)
    (attempts : List (KeygenLoopAt080.AttemptExecution env.ctx))
    (source : KeygenLoopAt080.LoopTrace env.ctx before out attempts) :
    ∀ (i : Nat), KeygenMakeSearchPrefix.Remaining before i →
      TailCells env before → out.flow=.normal → TailCells env out.state := by
  induction source with
  | exhausted before out cap exit =>
    intro i remaining cells normal
    exact (exit normal).elim
  | accepted a last =>
    intro i remaining cells normal
    exact attempt_cells env a.before a.out i remaining cells a.source
  | retry a out rest rejected tail ih =>
    intro i remaining cells normal
    exact ih (i+1) (KeygenRetryAt080.attempt_remaining env.ctx a.before a.out i remaining a.source).2.1
      (attempt_cells env a.before a.out i remaining cells a.source) normal

end FT1536.Source3.KeygenTailCellsAt080
