import Source3.StepPrefixProgram187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedStepSizes187
open C99ArrayReference (State bindValue)
open KeygenMakeFgSource (Exec)

noncomputable def before := StepDeclarations187.after FirstStepEntry187.entry
noncomputable def withN := bindValue before "n".toList .uint64 (.uint64 512)
noncomputable def after := bindValue withN "hn".toList .uint64 (.uint64 256)

theorem n_source : Exec StepPrefixProgram187.nSet before ⟨withN,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 none (.uint64 512) rfl
    (.scalar _ _ (.shift .left _ _ _ _ _ (.cast .uint64 _ _ (.literal .int32 1)) (.variable _ _ _ rfl)
      (.unsignedLeft (.uint64 1) (.uint32 9) 9 rfl rfl (by decide))))))

theorem hn_source : Exec StepPrefixProgram187.hnSet withN ⟨after,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 none (.uint64 256) rfl
    (.scalar _ _ (.shift .right _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
      (.right (.uint64 512) (.int32 1) 1 rfl (by decide))))))

theorem n_cell : KeygenNttLoopSupport.USlot after "n" 512 := rfl
theorem hn_cell : KeygenNttLoopSupport.USlot after "hn" 256 := rfl
theorem heap : after.heap=FirstStepEntry187.entry.heap := rfl

end FT1536.Source3.SelectedStepSizes187
