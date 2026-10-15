import Source3.SelectedFftLoop141
import Source3.FftReferenceCompose141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGroup141
open C99CompactState115 (reference)
open FftMiddleShape139

theorem prior : C99ProcedureSegments136.Prefix KeygenSearchFft.program butterflyCondition butterflyBody
    butterflyIncrement 24 (reference FftMiddleLoad139.initial) (reference SelectedFftBuffer141.before) :=
  C99ProcedureSegments136.append KeygenSearchFft.program butterflyCondition butterflyBody butterflyIncrement
    8 16 _ _ _ NormalizedFftMiddle139.source GeneratedFft140Middle16.closed

theorem loop_source : C99ProcedureReference.Exec KeygenSearchFft.program butterflyLoop
    (reference FftMiddleLoad139.initial) ⟨SelectedFftLoop141.after,.normal⟩ := by
  rw [butterfly_shape]
  have tail := SelectedFftLoop141.source
  rw [butterfly_shape] at tail
  exact C99ProcedureSegments136.finish _ _ _ _ 24 _ _ _ prior tail

noncomputable def after : C99ArrayReference.State := C99ArrayReference.restoreScope
  (reference SelectedFftMiddleStart139.groupInit) SelectedFftLoop141.after
  (scopeLocals groupBody) (scopePointers groupBody)

theorem source : C99ProcedureReference.Exec KeygenSearchFft.program groupBody
    (reference SelectedFftMiddleStart139.groupInit) ⟨after,.normal⟩ :=
  FftReferenceCompose141.group _ _ _ _ FftMiddleLoad139.group_source FftMiddleLoad139.initial_source loop_source

theorem image : C99WordBuffer140.Represents after.heap SelectedFftBuffer141.base SelectedFftLoop141.finalValues :=
  SelectedFftLoop141.after_image

end FT1536.Source3.SelectedFftGroup141
