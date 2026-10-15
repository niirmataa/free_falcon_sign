import Source3.SelectedNormEntry151

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedRawNorm151
open C99ArrayReference (State)
open C99CompactState115 (reference)
open C99LoopScalar141 (Cell)
open KeygenNormInvariant151 (Fixed Norm names)
open SelectedNormEntry151 (initial)

def sumWord : BitVec 64 := KeygenNormInduction151.sum SelectedTripling148.finalValues SelectedFftGTripling150.finalValues 1536 0 0
def finalWord : BitVec 64 := FprHeadersFast137.double sumWord

theorem exists_loop : ∃ after, KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormShape151.loop initial ⟨after,.normal⟩ ∧
    Fixed after SelectedFftBuffer141.base SelectedFftGInput148.base 1536 SelectedTripling148.finalValues SelectedFftGTripling150.finalValues ∧
    Cell after "u".toList 1536 ∧ Norm after sumWord ∧ C99ScopeFrame147.Frame names initial after ∧ after.heap=initial.heap :=
  KeygenNormInduction151.source _ initial _ _ 1536 0 1536 _ _ 0 SelectedNormEntry151.fixed SelectedNormEntry151.counter SelectedNormEntry151.norm rfl

noncomputable def loopAfter : State := Classical.choose exists_loop
theorem loop_source : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormShape151.loop initial ⟨loopAfter,.normal⟩ :=
  (Classical.choose_spec exists_loop).1
theorem loop_norm : Norm loopAfter sumWord := (Classical.choose_spec exists_loop).2.2.2.1
theorem loop_frame : C99ScopeFrame147.Frame names initial loopAfter := (Classical.choose_spec exists_loop).2.2.2.2.1
theorem loop_heap : loopAfter.heap=initial.heap := (Classical.choose_spec exists_loop).2.2.2.2.2

noncomputable def after := FftLocalCells140.put loopAfter "norm".toList finalWord

theorem double_source : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormShape151.double loopAfter ⟨after,.normal⟩ :=
  KeygenNormBoundary151.double _ loopAfter sumWord loop_norm

theorem source : KeygenSearchExec.Exec KeygenFullData127.env.ctx FftShape138.remaining SelectedFftGComplete150.after ⟨after,.normal⟩ := by
  rw [KeygenNormShape151.remaining_shape]
  exact .seqNormal _ _ _ SelectedNormEntry151.zero _ SelectedNormEntry151.zero_source
    (.seqNormal _ _ _ loopAfter _ (.seqNormal _ _ _ initial _ SelectedNormEntry151.initialization loop_source)
      (.seqNormal _ _ _ after _ double_source (.procedure _ _ _ (.base _ _ _ (.skip _)))))

/-- Full original raw-norm computation, including conversion and both FFT calls. -/
theorem computation : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormFrame.code
    (reference SelectedBound135.after) ⟨after,.normal⟩ := by
  apply NormalizedSmall136.continue_raw
  rw [FftShape138.caller_shape]
  exact .seqNormal _ _ _ SelectedFftFComplete148.after _ (.procedure _ _ _ SelectedFftFComplete148.source)
    (.seqNormal _ _ _ SelectedFftGComplete150.after _ (.procedure _ _ _ SelectedFftGComplete150.source) source)

theorem norm_cell : Norm after finalWord := FftLocalCells140.cell_at loopAfter "norm".toList finalWord
theorem bound_cell : after.locals "bound".toList=some (.uint64,some (.uint64 GeneratedBound135.finalWord)) :=
  (FftLocalCells140.outside loopAfter "norm".toList "bound".toList finalWord (by decide)).trans
    ((loop_frame.locals _ (by decide)).trans ((SelectedNormEntry151.frame.locals _ (by decide)).trans SelectedNormEntry151.bound))
theorem heap : after.heap=SelectedFftGComplete150.after.heap := loop_heap
theorem images : C99WordBuffer140.Represents after.heap SelectedFftBuffer141.base SelectedTripling148.finalValues ∧
    C99WordBuffer140.Represents after.heap SelectedFftGInput148.base SelectedFftGTripling150.finalValues := by
  rw [heap]
  exact SelectedFftGFrame150.both_images

theorem comparison : KeygenNormFrame.Compare after (.int32 (FprCompare.spec finalWord GeneratedBound135.finalWord)) :=
  KeygenNormBoundary151.compare after finalWord GeneratedBound135.finalWord norm_cell bound_cell

/-- Explicit remaining finite word comparison; no inhabitant is supplied here. -/
def NumericalObligation : Prop := FprCompare.spec finalWord GeneratedBound135.finalWord=1

theorem accepted_of_comparison (checked : NumericalObligation) :
    KeygenNormFrame.Exec KeygenFullData127.env.ctx (reference SelectedBound135.after) ⟨after,.normal⟩ := by
  refine .run after _ computation (.accept (.int32 (FprCompare.spec finalWord GeneratedBound135.finalWord)) comparison ?_)
  change FprCompare.spec finalWord GeneratedBound135.finalWord=1 at checked
  rw [checked]
  decide

end FT1536.Source3.SelectedRawNorm151
