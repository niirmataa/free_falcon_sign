import Source3.SelectedNttTriple184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedForwardCall184
open C99ArrayReference (State)

noncomputable abbrev before := SelectedForwardEntry182.before
noncomputable def after : State := {before with heap:=SelectedNttTriple184.after.heap}

theorem source : KeygenLevelCalls.Call .forward before (TopForwardShape182.args "fs") after :=
  SelectedForwardEntry182.source_call ⟨SelectedNttTriple184.after,.normal⟩ SelectedNttTriple184.body_source .voidEnd

theorem instruction : KeygenLevelExec.Exec TopForwardShape182.first before ⟨after,.normal⟩ :=
  .call .forward (TopForwardShape182.args "fs") before after source

def remaining := KeygenLevelExec.Stmt.seq TopForwardShape182.second TopForwardShape182.remaining

theorem continue_top (out : C99ProcedureReference.Result) (rest : KeygenLevelExec.Exec remaining after out) :
    KeygenLevelExec.Exec KeygenMakeFgTop.code SelectedMakeFgTopEntry176.entry out := by
  apply SelectedGeneratorCall181.continue_top out
  rw [TopForwardShape182.shape]
  exact .seqNormal _ _ before after out instruction rest

end FT1536.Source3.SelectedForwardCall184
