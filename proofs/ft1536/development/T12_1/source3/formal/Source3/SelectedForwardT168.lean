import Source3.SelectedForwardFrame168

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedForwardT168
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenRngSource (Fresh)
open SelectedPublicStart157 (t)

theorem exists_body : ∃ body, Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT)
    (PublicForwardEntry159.entryT SelectedForwardH168.output t) ⟨body,.normal⟩ ∧ Fresh body.heap 33 ∧ Fresh body.heap 34 :=
  PublicForwardConstruct167.source SelectedForwardH168.output t 33 34 SelectedForwardFrame168.t_data
    SelectedForwardH168.g_fresh SelectedForwardFrame168.second_fresh

noncomputable def body : State := Classical.choose exists_body
noncomputable def output : State := {SelectedPublicConvert158.after with heap := body.heap}

theorem source : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
    KeygenPublicInputProgram.tForward SelectedForwardH168.output ⟨output,.normal⟩ :=
  PublicForwardEntry159.t_exec SelectedForwardH168.body body (Classical.choose_spec exists_body).1

theorem both : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
    KeygenPublicInputCalls.forwards SelectedPublicConvert158.after ⟨output,.normal⟩ :=
  .seqNormal _ _ _ SelectedForwardH168.output _ SelectedForwardH168.source
    (.seqNormal _ _ _ output _ source (.skip output))

theorem continue_suffix (out : Result)
    (suffix : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
      KeygenPublicInputProgram.suffix output out) :
    Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
      KeygenPublicInputCalls.remaining SelectedPublicConvert158.after out :=
  .seqNormal _ _ _ SelectedForwardH168.output _ SelectedForwardH168.source
    (.seqNormal _ _ _ output _ source suffix)

end FT1536.Source3.SelectedForwardT168
