import Source3.FftOuterInduction144
import Source3.SelectedFftOuterContext142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftMiddle144
open C99CompactState115 (reference)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open SelectedFftBuffer141 (base)

noncomputable def before := SelectedFftOuterControl142.after

theorem context : FftOuterInvariant144.Context before base 1536 768 := by
  refine ⟨by decide,by decide,by decide,by decide,SelectedFftOuterContext142.binding,?_,SelectedFftOuterContext142.hn,?_,SelectedFftOuterContext142.pinned⟩
  · change SelectedFftOuterControl142.after.arrays "fpr_gm3_square".toList=_
    rw [SelectedFftOuterContext142.arrays]
    decide +kernel
  · change SelectedFftOuterControl142.after.heap.writable 31=true
    rw [SelectedFftOuterContext142.permissions]
    exact SelectedFftBuffer141.writable

def finalValues := FftOuterSchedule144.values 1536 768 context.length 7 384 4 SelectedFftLoop141.finalValues

theorem exists_source : ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.outerLoop before ⟨after,.normal⟩ ∧
    FftOuterInvariant144.Context after base 1536 768 ∧ Cell after "t".toList 3 ∧ Cell after "m".toList 512 ∧
    Represents after.heap base finalValues ∧ FftOuterFrame144.Frame base 1536 before after := by
  have output := FftOuterInduction144.source before base 1536 768 3 7 384 4 SelectedFftLoop141.finalValues
    context FftOuterSchedule144.remaining (by decide) SelectedFftOuterContext142.minimum
    SelectedFftOuterControl142.t SelectedFftOuterControl142.m SelectedFftOuterControl142.image
  simpa only [FftOuterSchedule144.end_t,FftOuterSchedule144.end_m,finalValues] using output

noncomputable def after : C99ArrayReference.State := Classical.choose exists_source

theorem source : C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.outerLoop before ⟨after,.normal⟩ :=
  (Classical.choose_spec exists_source).1

theorem after_context : FftOuterInvariant144.Context after base 1536 768 := (Classical.choose_spec exists_source).2.1
theorem t : Cell after "t".toList 3 := (Classical.choose_spec exists_source).2.2.1
theorem m : Cell after "m".toList 512 := (Classical.choose_spec exists_source).2.2.2.1
theorem image : Represents after.heap base finalValues := (Classical.choose_spec exists_source).2.2.2.2.1
theorem frame : FftOuterFrame144.Frame base 1536 before after := (Classical.choose_spec exists_source).2.2.2.2.2

/-- The original entire middle outer loop, including the prior first pass. -/
theorem complete_loop_source : C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.outerLoop
    (reference SelectedFftMiddleStart139.setup) ⟨after,.normal⟩ := by
  rw [FftMiddleShape139.outer_shape]
  have tail := source
  rw [FftMiddleShape139.outer_shape] at tail
  exact C99ProcedureSegments136.finish _ _ _ _ 1 _ _ _ SelectedFftOuterControl142.source tail

end FT1536.Source3.SelectedFftMiddle144
