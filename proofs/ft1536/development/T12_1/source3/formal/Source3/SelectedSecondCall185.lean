import Source3.SelectedSecondBody185

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSecondCall185
open C99ArrayReference (State)

noncomputable abbrev before := SelectedSecondEntry185.before
noncomputable def after : State := {before with heap:=SelectedSecondBody185.after.heap}

theorem source : KeygenLevelCalls.Call .forward before (TopForwardShape182.args "gs") after :=
  SelectedSecondEntry185.source_call ⟨SelectedSecondBody185.after,.normal⟩ SelectedSecondBody185.source .voidEnd

theorem instruction : KeygenLevelExec.Exec TopForwardShape182.second before ⟨after,.normal⟩ :=
  .call .forward (TopForwardShape182.args "gs") before after source

def both : KeygenLevelExec.Stmt := .seq TopForwardShape182.first TopForwardShape182.second

theorem both_source : KeygenLevelExec.Exec both SelectedForwardCall184.before ⟨after,.normal⟩ :=
  .seqNormal _ _ SelectedForwardCall184.before before ⟨after,.normal⟩ SelectedForwardCall184.instruction instruction

theorem continue_top (out : C99ProcedureReference.Result)
    (rest : KeygenLevelExec.Exec TopForwardShape182.remaining after out) :
    KeygenLevelExec.Exec KeygenMakeFgTop.code SelectedMakeFgTopEntry176.entry out :=
  SelectedForwardCall184.continue_top out (.seqNormal _ _ before after out instruction rest)

end FT1536.Source3.SelectedSecondCall185
