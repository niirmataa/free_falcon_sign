import Source3.StepPrefixProgram187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgScope187
open C99ArrayReference (State restoreScope)
open KeygenMakeFgSource (Exec Stmt)

theorem restore_empty (before after : State) : restoreScope before after [] []=after := by
  cases after
  rfl

theorem source (code : Stmt) (before after : State) (run : Exec code before ⟨after,.normal⟩) :
    Exec (.scope [] [] code) before ⟨after,.normal⟩ := by
  have result := Exec.scope [] [] code before ⟨after,.normal⟩ run
  simpa only [restore_empty] using result

end FT1536.Source3.MakeFgScope187
