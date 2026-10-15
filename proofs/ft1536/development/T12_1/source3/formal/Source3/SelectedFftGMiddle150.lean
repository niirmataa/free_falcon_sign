import Source3.SelectedFftGFirst150
import Source3.FftMiddleSetup150

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGMiddle150
open C99ArrayReference (State Name)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open SelectedFftGInput148 (base)

noncomputable def before := SelectedFftGFirst150.after
noncomputable def initial := FftMiddleSetup150.initial before

theorem declared (name : Name) (member : name∈FftSetup150.names)
    (notN : name≠"n".toList) (notHn : name≠"hn".toList) (notU : name≠"u".toList) :
    before.locals name=some (.uint64,none) :=
  (SelectedFftGFirst150.frame.locals name notU).trans
    (FftSetup150.remaining_declared SelectedFftGFirst150.before name member notN notHn notU)

theorem setup : C99ProcedureReference.Exec KeygenSearchFft.program
    (C99ProcedureParser.chain [FftMiddleShape139.setT,FftMiddleShape139.setMinimum,FftMiddleShape139.outerInitial])
    before ⟨initial,.normal⟩ :=
  .seqNormal _ _ _ (FftMiddleSetup150.setT before) _
    (FftMiddleSetup150.set_t before (declared _ (by decide) (by decide) (by decide) (by decide)) SelectedFftGFirst150.after_fixed.hnCell)
    (.seqNormal _ _ _ (FftMiddleSetup150.minimum before) _
      (FftMiddleSetup150.set_minimum before (declared _ (by decide) (by decide) (by decide) (by decide))
        ((SelectedFftGFirst150.local_cell _ (by decide) (by decide)).trans SelectedFftGEntry150.full))
      (.seqNormal _ _ _ initial _ (FftMiddleSetup150.initialization before (declared _ (by decide) (by decide) (by decide) (by decide)))
        (.base _ _ _ (.skip _))))

theorem context : FftOuterInvariant144.Context initial base 1536 768 := by
  refine ⟨by decide,by decide,by decide,by decide,SelectedFftGFirst150.after_fixed.binding,?_,?_,
    SelectedFftGFirst150.after_fixed.writable,SelectedFftGFirst150.pinned⟩
  · change SelectedFftGFirst150.after.arrays "fpr_gm3_square".toList=_
    rw [SelectedFftGFirst150.frame.arrays]
    exact SelectedFftGEntry150.square
  · exact ((FftMiddleSetup150.frame before).locals _ (by decide)).trans SelectedFftGFirst150.after_fixed.hnCell

theorem plan : FftOuterSchedule144.Plan 768 3 8 768 2 := by
  simp only [FftOuterSchedule144.Plan,FftOuterSchedule144.Ready]
  decide +kernel
def finalValues := FftOuterSchedule144.values 1536 768 (by decide) 8 768 2 SelectedFftGFirst150.finalValues

theorem exists_source : ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.outerLoop initial ⟨after,.normal⟩ ∧
    FftOuterInvariant144.Context after base 1536 768 ∧ Cell after "t".toList 3 ∧ Cell after "m".toList 512 ∧
    Represents after.heap base finalValues ∧ FftOuterFrame144.Frame base 1536 initial after :=
  FftOuterInduction144.source initial base 1536 768 3 8 768 2 SelectedFftGFirst150.finalValues context plan (by decide)
    (FftMiddleSetup150.minimum_cell before) (FftMiddleSetup150.t_cell before) (FftMiddleSetup150.m_cell before) SelectedFftGFirst150.image

noncomputable def after : State := Classical.choose exists_source
theorem source : C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.outerLoop initial ⟨after,.normal⟩ :=
  (Classical.choose_spec exists_source).1
theorem after_context : FftOuterInvariant144.Context after base 1536 768 := (Classical.choose_spec exists_source).2.1
theorem t : Cell after "t".toList 3 := (Classical.choose_spec exists_source).2.2.1
theorem m : Cell after "m".toList 512 := (Classical.choose_spec exists_source).2.2.2.1
theorem image : Represents after.heap base finalValues := (Classical.choose_spec exists_source).2.2.2.2.1
theorem frame : FftOuterFrame144.Frame base 1536 initial after := (Classical.choose_spec exists_source).2.2.2.2.2

theorem local_cell (name : Name) (first : name∉FftSetup150.names) (middle : name∉FftMiddleSetup150.names)
    (notU : name≠"u".toList) (notT : name≠"t".toList) (notM : name≠"m".toList) :
    after.locals name=SelectedFftGBinding148.bound.locals name :=
  (frame.locals name notT notM).trans
    (((FftMiddleSetup150.frame before).locals name middle).trans (SelectedFftGFirst150.local_cell name notU first))

theorem u : Cell after "u".toList 768 :=
  (frame.locals _ (by decide) (by decide)).trans
    (((FftMiddleSetup150.frame before).locals _ (by decide)).trans SelectedFftGFirst150.u)

theorem cubic : after.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic) := by
  rw [frame.arrays]
  change SelectedFftGFirst150.after.arrays "fpr_gm3_cubic".toList=_
  rw [SelectedFftGFirst150.frame.arrays]
  exact SelectedFftGEntry150.cubic

theorem continue_body (out : C99ProcedureReference.Result)
    (continuation : C99ProcedureReference.Exec KeygenSearchFft.program (.seq FftMiddleShape139.tripling (.base .skip)) after out) :
    C99ProcedureReference.Exec KeygenSearchFft.program GeneratedFft138Syntax.function.body SelectedFftGBinding148.bound out := by
  apply SelectedFftGFirst150.continue_body out
  obtain ⟨one,two,setT,setMinimum,setM⟩ := C99ChainSplit144.three _ _ _ _ _ _ setup
  rw [FftMiddleShape139.remaining_shape]
  exact .seqNormal _ _ _ one _ setT (.seqNormal _ _ _ two _ setMinimum
    (.seqNormal _ _ _ after _ (.seqNormal _ _ _ initial _ setM source) continuation))

end FT1536.Source3.SelectedFftGMiddle150
