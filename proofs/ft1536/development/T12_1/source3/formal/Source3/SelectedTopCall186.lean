import Source3.SelectedTopProducts186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopCall186
open C99ArrayReference (State)

noncomputable abbrev before := SelectedMakeFgConvert176.after
noncomputable def after : State := {before with heap:=SelectedTopProducts186.after.heap}

theorem source : KeygenMakeFgTop.Call before SelectedMakeFgTopEntry176.arguments after :=
  SelectedMakeFgTopEntry176.source_call ⟨SelectedTopProducts186.after,.normal⟩ SelectedTopProducts186.body_source .voidEnd

theorem instruction : KeygenMakeFgSource.Exec (.top SelectedMakeFgTopEntry176.arguments) before ⟨after,.normal⟩ :=
  .top SelectedMakeFgTopEntry176.arguments before after source

theorem locals : after.locals=before.locals := rfl
theorem arrays : after.arrays=before.arrays := rfl

end FT1536.Source3.SelectedTopCall186
