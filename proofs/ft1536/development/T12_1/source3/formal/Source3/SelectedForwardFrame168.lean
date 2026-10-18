import Source3.SelectedForwardH168
import Source3.NormProtected158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedForwardFrame168
open C99ArrayReference (State)
open KeygenPublicExec (Exec)
open SelectedPublicBinding157 (h)
open SelectedPublicStart157 (t)

theorem tables : SelectedPublicConvert158.after.tables=SelectedAttemptPrefix156.prepared.tables :=
  SelectedPublicNttEntry158.tables.trans
    (KeygenCallerPrefix134.ternary_slots KeygenFullData127.env.ctx SelectedAttemptPrefix156.prepared
      ⟨SelectedGsNorm155.after,.normal⟩ SelectedAttemptPrefix156.ternary).2

theorem t_tables : KeygenPublicFrame.Tables SelectedPublicConvert158.after t.block := by
  intro name p binding
  rw [tables] at binding
  exact of_decide_eq_true (NormProtected158.lookup_property SelectedFullSampler128.prepared.tables
    (fun p => decide (p.block≠t.block)) (by decide +kernel) name p binding)

theorem t_same : ShakeExtractFrame.SameBlock SelectedPublicConvert158.after.heap SelectedForwardH168.output.heap t.block :=
  KeygenPublicInputCalls.forward_other _ _ h t SelectedPublicNttEntry158.h_binding (by decide) t_tables
    (PublicForwardMemory167.live _ t SelectedForwardInputs168.t_data) SelectedForwardH168.source

theorem t_data : PublicForwardMemory167.Data SelectedForwardH168.output.heap t :=
  ⟨(congrFun t_same.2.1 t.block).trans SelectedForwardInputs168.t_data.writable,
    KeygenPublicRangeMemory.initialized_same_block _ _ t 1536 t_same SelectedForwardInputs168.t_data.written⟩

theorem second_fresh : KeygenRngSource.Fresh (KeygenPublicExec.allocated SelectedForwardH168.output.heap 33 2048) 34 :=
  SelectedForwardInputs168.allocated_fresh_other _ 33 2048 34 (by decide) SelectedForwardH168.i_fresh

end FT1536.Source3.SelectedForwardFrame168
