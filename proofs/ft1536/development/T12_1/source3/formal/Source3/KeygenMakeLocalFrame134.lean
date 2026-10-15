import Source3.KeygenMakeLocalFrame
import Source3.KeygenMakeReadySampling
import Source3.KeygenCallerSuccess
import Source3.KeygenAttemptNorm133
import Source3.KeygenCallerPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenMakeLocalFrame134
open C99ArrayReference (State Name)
open C99ProcedureReference (Result Destination)
open KeygenSearchContext (Context)


open KeygenMakeLocalFrame
theorem search (ctx : Context) (code : KeygenSearchExec.Stmt) (before : State) (out : Result)
    (source : KeygenSearchExtended133.Exec ctx code before out) (n : Name) (checked : searchKeep n code=true) :
    out.state.locals n=before.locals n := by
  induction source with
  | procedure code before out source => exact procedure _ _ _ _ source n checked
  | logn dst before ty old word binding source | assign dst e before ty old v binding value =>
    have distinct : n≠dst := by simpa only [searchKeep,bne_iff_ne] using checked
    simp only [C99ArrayReference.bindValue,C99ScalarReference.set,distinct,ite_false]
  | small args before after source => cases source; rfl
  | seqNormal a b before middle out head tail ih1 ih2 =>
    exact (ih2 (Bool.and_eq_true_iff.mp checked).2).trans (ih1 (Bool.and_eq_true_iff.mp checked).1)
  | seqExit _ _ _ _ head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals pointers body before out source ih => exact restored _ _ _ _ n (ih checked)
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact (ih3 checked).trans ((ih2 (Bool.and_eq_true_iff.mp checked).2).trans (ih1 (Bool.and_eq_true_iff.mp checked).1))
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | pointer | store32 | store64 | move | loopFalse => rfl

theorem norm (ctx : Context) (before : State) (out : Result) (source : KeygenAttemptNorm133.Exec ctx before out)
    (n : Name) (member : n∈fixed) : out.state.locals n=before.locals n := by
  obtain ⟨hb,hr,hh,ht⟩ := checked_bodies n member
  cases source with
  | rawRejected bounded out initial source rejected =>
    exact (raw ctx bounded out source n hr).trans (search ctx _ before ⟨bounded,.normal⟩ initial n hb)
  | gs bounded middle out initial source gram =>
    exact (gs ctx middle out gram n hh ht).trans
      ((raw ctx bounded ⟨middle,.normal⟩ source n hr).trans (search ctx _ before ⟨bounded,.normal⟩ initial n hb))

theorem ternary (ctx : Context) (before : State) (out : Result) (source : KeygenCallerPrefix134.Ternary ctx before out)
    (n : Name) (member : n∈fixed) : out.state.locals n=before.locals n := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    rw [resultants _ _ gate,KeygenMakeSampling.sampler_locals _ _ _ _ second,KeygenMakeSampling.sampler_locals _ _ _ _ first]
  | norm middle sampled res out first second gate normed =>
    exact (norm ctx res out normed n member).trans (by
      rw [resultants _ _ gate,KeygenMakeSampling.sampler_locals _ _ _ _ second,KeygenMakeSampling.sampler_locals _ _ _ _ first])

end FT1536.Source3.KeygenMakeLocalFrame134
