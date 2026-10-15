import Source3.SelectedGsEntry154

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsInvNorm154
open C99ArrayReference (State)
open SelectedGsBinding154 (before bound destination arguments)

def values : Fin 768 → BitVec 64 :=
  GsInvNormInvariant154.result (by decide) GeneratedFftTree153FTriple.word GeneratedFftTree153GTriple.word

theorem exists_body : ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program GsInvNormShape154.function.body bound ⟨after,.normal⟩ ∧
    GsInvNormInvariant154.Fixed after SelectedFftBuffer141.base SelectedFftGInput148.base destination
      1536 768 GeneratedFftTree153FTriple.word GeneratedFftTree153GTriple.word ∧
    C99WordBuffer140.Represents after.heap destination values :=
  GsInvNormCallee154.source bound _ _ _ _ _ SelectedGsEntry154.full SelectedGsEntry154.logn SelectedGsEntry154.fixed

noncomputable def calleeAfter : State := Classical.choose exists_body
noncomputable def after : State := {before with heap := calleeAfter.heap}

theorem body : C99ProcedureReference.Exec KeygenSearchFft.program GsInvNormShape154.function.body bound ⟨calleeAfter,.normal⟩ :=
  (Classical.choose_spec exists_body).1

/-- First actual GS helper call, from the caller state after the accepted raw-norm gate. -/
theorem source : C99ProcedureReference.Exec KeygenSearchFft.program
    (.call "falcon_poly_invnorm2_fft3".toList arguments .discard) before ⟨after,.normal⟩ :=
  .call "falcon_poly_invnorm2_fft3".toList arguments .discard GsInvNormShape154.function
    before bound after ⟨calleeAfter,.normal⟩ none GsInvNormShape154.source SelectedGsBinding154.binding body
    .voidEnd (.discard _ none)

theorem image : C99WordBuffer140.Represents after.heap destination values :=
  (Classical.choose_spec exists_body).2.2
theorem first_image : C99WordBuffer140.Represents after.heap SelectedFftBuffer141.base GeneratedFftTree153FTriple.word :=
  (Classical.choose_spec exists_body).2.1.first
theorem second_image : C99WordBuffer140.Represents after.heap SelectedFftGInput148.base GeneratedFftTree153GTriple.word :=
  (Classical.choose_spec exists_body).2.1.second

end FT1536.Source3.SelectedGsInvNorm154
