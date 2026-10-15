import Source3.SelectedFftGTripling150

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGComplete150
open C99ArrayReference (State)
open C99CompactState115 (reference)

noncomputable def after : State := {SelectedFftFComplete148.after with heap := SelectedFftGTripling150.after.heap}

/-- Actual second FFT call from the first call's returned caller state. -/
theorem source : C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_FFT3".toList (FftShape138.args "rt2") .discard) SelectedFftFComplete148.after ⟨after,.normal⟩ := by
  refine .call "falcon_FFT3".toList (FftShape138.args "rt2") .discard GeneratedFft138Syntax.function
    SelectedFftFComplete148.after SelectedFftGBinding148.bound after ⟨SelectedFftGTripling150.after,.normal⟩ none
    GeneratedFft138Syntax.source SelectedFftGBinding148.binding SelectedFftGTripling150.function_body ?_ (.discard _ none)
  rw [SelectedFftFComplete148.result_type]
  exact .voidEnd

theorem extended : KeygenSearchExtended133.Exec KeygenFullData127.env.ctx
    (.procedure (.call "falcon_FFT3".toList (FftShape138.args "rt2") .discard)) SelectedFftFComplete148.after ⟨after,.normal⟩ :=
  .procedure _ _ _ source

theorem image : C99WordBuffer140.Represents after.heap SelectedFftGInput148.base SelectedFftGTripling150.finalValues := SelectedFftGTripling150.image
theorem locals : after.locals=(reference SelectedFftFStart138.before).locals := rfl
theorem arrays : after.arrays=(reference SelectedFftFStart138.before).arrays := rfl
theorem globals : after.globals=(reference SelectedFftFStart138.before).globals := rfl
theorem tables : after.tables=(reference SelectedFftFStart138.before).tables := rfl

/-- Both source calls are discharged; the continuation starts after rt2. -/
theorem continue_norm (out : C99ProcedureReference.Result)
    (continuation : KeygenSearchExtended133.Exec KeygenFullData127.env.ctx FftShape138.remaining after out) :
    KeygenSearchExtended133.Exec KeygenFullData127.env.ctx KeygenSmallShape136.remaining
      (reference SelectedFftFStart138.before) out :=
  SelectedFftFComplete148.continue_norm out (.seqNormal _ _ _ after _ extended continuation)

end FT1536.Source3.SelectedFftGComplete150
