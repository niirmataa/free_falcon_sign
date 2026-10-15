import Source3.SelectedTripling148
import Source3.KeygenSearchExtended133

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftFComplete148
open C99ArrayReference (State)
open C99CompactState115 (reference)

noncomputable def after : State := {reference SelectedFftFStart138.before with heap := SelectedTripling148.after.heap}

theorem result_type : GeneratedFft138Syntax.function.result=none := by rfl

/-- First actual FFT call, including its source body and caller return boundary. -/
theorem source : C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_FFT3".toList (FftShape138.args "rt1") .discard)
    (reference SelectedFftFStart138.before) ⟨after,.normal⟩ := by
  refine .call "falcon_FFT3".toList (FftShape138.args "rt1") .discard GeneratedFft138Syntax.function
    (reference SelectedFftFStart138.before) (reference SelectedFftFStart138.bound) after
    ⟨SelectedTripling148.after,.normal⟩ none GeneratedFft138Syntax.source SelectedFftFStart138.binding SelectedTripling148.function_body ?_ (.discard _ none)
  rw [result_type]
  exact .voidEnd

theorem extended : KeygenSearchExtended133.Exec KeygenFullData127.env.ctx
    (.procedure (.call "falcon_FFT3".toList (FftShape138.args "rt1") .discard))
    (reference SelectedFftFStart138.before) ⟨after,.normal⟩ := .procedure _ _ _ source

theorem image : C99WordBuffer140.Represents after.heap SelectedFftBuffer141.base SelectedTripling148.finalValues := SelectedTripling148.image

theorem locals : after.locals=(reference SelectedFftFStart138.before).locals := rfl
theorem arrays : after.arrays=(reference SelectedFftFStart138.before).arrays := rfl
theorem globals : after.globals=(reference SelectedFftFStart138.before).globals := rfl
theorem tables : after.tables=(reference SelectedFftFStart138.before).tables := rfl

/-- Continuation now begins with rt2; this is not the completed norm/KeyGen call. -/
theorem continue_norm (out : C99ProcedureReference.Result)
    (continuation : KeygenSearchExtended133.Exec KeygenFullData127.env.ctx
      (.seq (.procedure (.call "falcon_FFT3".toList (FftShape138.args "rt2") .discard)) FftShape138.remaining) after out) :
    KeygenSearchExtended133.Exec KeygenFullData127.env.ctx KeygenSmallShape136.remaining
      (reference SelectedFftFStart138.before) out := by
  rw [FftShape138.caller_shape]
  exact .seqNormal _ _ _ after _ extended continuation

end FT1536.Source3.SelectedFftFComplete148
