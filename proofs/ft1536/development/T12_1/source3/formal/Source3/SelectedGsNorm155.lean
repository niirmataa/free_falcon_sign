import Source3.SelectedGsNormEntry155

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsNorm155
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open KeygenNormInvariant151 (Fixed Norm names)
open SelectedGsNormEntry155 (initial)
open SelectedGsStart155 (p q)

def sumWord : BitVec 64 := KeygenNormInduction151.sum SelectedGsAuto155.fValues SelectedGsAuto155.gValues 1536 0 0
def finalWord : BitVec 64 := FprHeadersFast137.double sumWord

theorem exists_loop : ∃ after, KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormShape151.loop initial ⟨after,.normal⟩ ∧
    Fixed after p q 1536 SelectedGsAuto155.fValues SelectedGsAuto155.gValues ∧
    Cell after "u".toList 1536 ∧ Norm after sumWord ∧ C99ScopeFrame147.Frame names initial after ∧ after.heap=initial.heap :=
  KeygenNormInduction151.source _ initial _ _ 1536 0 1536 _ _ 0 SelectedGsNormEntry155.fixed SelectedGsNormEntry155.counter SelectedGsNormEntry155.norm rfl
noncomputable def loopAfter : State := Classical.choose exists_loop
theorem loop_source : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormShape151.loop initial ⟨loopAfter,.normal⟩ :=
  (Classical.choose_spec exists_loop).1
theorem loop_norm : Norm loopAfter sumWord := (Classical.choose_spec exists_loop).2.2.2.1
theorem loop_frame : C99ScopeFrame147.Frame names initial loopAfter := (Classical.choose_spec exists_loop).2.2.2.2.1
theorem loop_heap : loopAfter.heap=initial.heap := (Classical.choose_spec exists_loop).2.2.2.2.2

noncomputable def after := FftLocalCells140.put loopAfter "norm".toList finalWord
theorem double_source : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormShape151.double loopAfter ⟨after,.normal⟩ :=
  KeygenNormBoundary151.double _ loopAfter sumWord loop_norm
theorem source : KeygenSearchExec.Exec KeygenFullData127.env.ctx FftShape138.remaining SelectedGsAuto155.after ⟨after,.normal⟩ := by
  rw [KeygenNormShape151.remaining_shape]
  exact .seqNormal _ _ _ SelectedGsNormEntry155.zero _ SelectedGsNormEntry155.zero_source
    (.seqNormal _ _ _ loopAfter _ (.seqNormal _ _ _ initial _ SelectedGsNormEntry155.initialization loop_source)
      (.seqNormal _ _ _ after _ double_source (.procedure _ _ _ (.base _ _ _ (.skip _)))))
theorem tail : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenAttemptNorm.tailCode SelectedGsScale155.after ⟨after,.normal⟩ :=
  SelectedGsAuto155.source ⟨after,.normal⟩ source

theorem norm_cell : Norm after finalWord := FftLocalCells140.cell_at loopAfter "norm".toList finalWord
theorem bound_cell : after.locals "bound".toList=some (.uint64,some (.uint64 GeneratedBound135.finalWord)) :=
  (FftLocalCells140.outside loopAfter "norm".toList "bound".toList finalWord (by decide)).trans
    ((loop_frame.locals _ (by decide)).trans ((SelectedGsNormEntry155.frame.locals _ (by decide)).trans SelectedGsNormEntry155.bound))
theorem heap : after.heap=SelectedGsAuto155.after.heap := loop_heap
theorem images : C99WordBuffer140.Represents after.heap p SelectedGsAuto155.fValues ∧
    C99WordBuffer140.Represents after.heap q SelectedGsAuto155.gValues := by
  rw [heap]
  exact ⟨SelectedGsAuto155.f_image,SelectedGsAuto155.g_image⟩
theorem comparison : KeygenNormFrame.Compare after (.int32 (FprCompare.spec finalWord GeneratedBound135.finalWord)) :=
  KeygenNormBoundary151.compare after finalWord GeneratedBound135.finalWord norm_cell bound_cell

def NumericalObligation : Prop := FprCompare.spec finalWord GeneratedBound135.finalWord=1

/-- Every source GS computation is supplied; only its exact finite word comparison remains. -/
theorem accepted_of_comparison (checked : NumericalObligation) :
    KeygenAttemptNorm133.GS KeygenFullData127.env.ctx SelectedRawNorm151.after ⟨after,.normal⟩ := by
  apply SelectedGsScale155.continue_gs after ⟨after,.normal⟩ tail
  refine .accept (.int32 (FprCompare.spec finalWord GeneratedBound135.finalWord)) comparison ?_
  change FprCompare.spec finalWord GeneratedBound135.finalWord=1 at checked
  rw [checked]
  decide

theorem norm_prefix (checked : NumericalObligation) :
    KeygenAttemptNorm133.Exec KeygenFullData127.env.ctx (C99CompactState115.reference SelectedBound135.before) ⟨after,.normal⟩ :=
  SelectedNormGate153.continue_gs ⟨after,.normal⟩ (accepted_of_comparison checked)

end FT1536.Source3.SelectedGsNorm155
