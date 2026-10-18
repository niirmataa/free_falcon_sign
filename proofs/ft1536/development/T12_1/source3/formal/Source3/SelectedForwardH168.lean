import Source3.SelectedForwardInputs168

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedForwardH168
open C99ArrayReference (State)
open KeygenPublicExec (Exec)
open KeygenRngSource (Fresh)
open SelectedPublicConvert158 (after)
open SelectedPublicBinding157 (h)

theorem exists_body : ∃ body, Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT)
    (PublicForwardEntry159.entryT after h) ⟨body,.normal⟩ ∧ Fresh body.heap 33 ∧ Fresh body.heap 34 :=
  PublicForwardConstruct167.source after h 33 34 SelectedForwardInputs168.h_data
    SelectedForwardInputs168.g_fresh SelectedForwardInputs168.second_fresh

noncomputable def body : State := Classical.choose exists_body
noncomputable def output : State := {after with heap := body.heap}

theorem source : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
    KeygenPublicInputProgram.hForward after ⟨output,.normal⟩ :=
  PublicForwardEntry159.h_exec body (Classical.choose_spec exists_body).1

theorem g_fresh : Fresh output.heap 33 := (Classical.choose_spec exists_body).2.1
theorem i_fresh : Fresh output.heap 34 := (Classical.choose_spec exists_body).2.2

end FT1536.Source3.SelectedForwardH168
