import Source3.SelectedFftGMiddle150
import Source3.FftTriplingInduction148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGTripling150
open C99ArrayReference (State)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open SelectedFftGInput148 (base)
open SelectedTriplingConstants148 (values)

noncomputable def before := SelectedFftGMiddle150.after
noncomputable def initial := FftTriplingSetup148.initial before

theorem before_fixed : FftTriplingInvariant148.Fixed before base values := by
  refine ⟨by decide,by decide,SelectedFftGMiddle150.after_context.writable,SelectedFftGMiddle150.after_context.binding,
    SelectedFftGMiddle150.after_context.hnCell,SelectedFftGMiddle150.cubic,SelectedFftGMiddle150.after_context.pinned,?_,?_,?_,?_⟩
  · exact (SelectedFftGMiddle150.local_cell _ (by decide) (by decide) (by decide) (by decide) (by decide)).trans SelectedFftGEntry150.w2r
  · exact (SelectedFftGMiddle150.local_cell _ (by decide) (by decide) (by decide) (by decide) (by decide)).trans SelectedFftGEntry150.w2i
  · exact (SelectedFftGMiddle150.local_cell _ (by decide) (by decide) (by decide) (by decide) (by decide)).trans SelectedFftGEntry150.w4r
  · exact (SelectedFftGMiddle150.local_cell _ (by decide) (by decide) (by decide) (by decide) (by decide)).trans SelectedFftGEntry150.w4i

theorem initialization : C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.initial
    (FftTriplingSetup148.declared before) ⟨initial,.normal⟩ :=
  FftTriplingSetup148.initialization before (some (.uint64 (C99NatWord141.word 768))) SelectedFftGMiddle150.u
    ((SelectedFftGMiddle150.local_cell _ (by decide) (by decide) (by decide) (by decide) (by decide)).trans SelectedFftGEntry150.logn)

theorem fixed : FftTriplingInvariant148.Fixed initial base values := FftTriplingSetupFixed148.source before base values before_fixed
def finalValues := FftTriplingInduction148.values values 256 0 SelectedFftGMiddle150.finalValues

theorem exists_loop : ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.loop initial ⟨after,.normal⟩ ∧
    FftTriplingInvariant148.Fixed after base values ∧ Cell after "u".toList 768 ∧ Cell after "v".toList 1536 ∧
    Represents after.heap base finalValues ∧ FftTriplingFrame148.Frame base initial after :=
  FftTriplingInduction148.source initial base values 0 SelectedFftGMiddle150.finalValues fixed
    (FftTriplingSetup148.u_cell before) (FftTriplingSetup148.v_cell before) SelectedFftGMiddle150.image (by decide)

noncomputable def loopAfter : State := Classical.choose exists_loop
theorem loop_source : C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.loop initial ⟨loopAfter,.normal⟩ :=
  (Classical.choose_spec exists_loop).1
theorem loop_image : Represents loopAfter.heap base finalValues := (Classical.choose_spec exists_loop).2.2.2.2.1
theorem loop_frame : FftTriplingFrame148.Frame base initial loopAfter := (Classical.choose_spec exists_loop).2.2.2.2.2

noncomputable def after : State := C99ArrayReference.restoreScope before loopAfter ["v".toList] []

theorem yes_source : C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.yes before ⟨after,.normal⟩ := by
  rw [FftTriplingSetup148.yes_shape]
  exact .scope _ _ _ before ⟨loopAfter,.normal⟩
    (.seqNormal _ _ _ (FftTriplingSetup148.declared before) _ (FftTriplingSetup148.declaration_source before)
      (.seqNormal _ _ _ loopAfter _ (.seqNormal _ _ _ initial _ initialization loop_source) (.base _ _ _ (.skip _))))

theorem source : C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.tripling before ⟨after,.normal⟩ := by
  change C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.code before ⟨after,.normal⟩
  rw [FftTriplingSetup148.branch_shape]
  exact .branchTrue _ _ _ before _ (.uint32 1)
    (.variable "full".toList .uint32 (.uint32 1)
      ((SelectedFftGMiddle150.local_cell _ (by decide) (by decide) (by decide) (by decide) (by decide)).trans SelectedFftGEntry150.full))
    (by decide) yes_source

theorem image : Represents after.heap base finalValues := loop_image

theorem function_body : C99ProcedureReference.Exec KeygenSearchFft.program GeneratedFft138Syntax.function.body
    SelectedFftGBinding148.bound ⟨after,.normal⟩ :=
  SelectedFftGMiddle150.continue_body ⟨after,.normal⟩ (.seqNormal _ _ before after _ source (.base _ _ _ (.skip _)))

end FT1536.Source3.SelectedFftGTripling150
