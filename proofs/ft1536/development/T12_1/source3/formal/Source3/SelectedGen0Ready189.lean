import Source3.SelectedGen0Frame189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGen0Ready189
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open SelectedGen0Call189 (after)
open SelectedTopInit178 (p p0i r2)
open SelectedStepLayout187 (fd gd fs gs gm igm t1)

theorem p_cell : Slot after "p" p := (congrFun SelectedGen0Frame189.locals _).trans SelectedStepPrime188.p_cell
theorem i_cell : Slot after "p0i" p0i := (congrFun SelectedGen0Frame189.locals _).trans SelectedStepPrime188.i_cell
theorem r2_cell : Slot after "R2" r2 := (congrFun SelectedGen0Frame189.locals _).trans SelectedStepPrime188.r2_cell
theorem u_cell : USlot after "u" 0 := rfl
theorem v_declared : after.locals "v".toList=some (.uint64,none) := rfl
theorem x_declared : after.arrays "x".toList=none := rfl
theorem n_cell : USlot after "n" 512 := rfl
theorem hn_cell : USlot after "hn" 256 := rfl
theorem slen_cell : USlot after "slen" 1 := rfl
theorem tlen_cell : USlot after "tlen" 2 := rfl
theorem logn_cell : Slot after "logn" 9 := rfl
theorem ternary_cell : Slot after "ter" 1 := rfl
theorem in_ntt_cell : after.locals "in_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem out_ntt_cell : after.locals "out_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem fd_binding : after.arrays "fd".toList=some fd := rfl
theorem gd_binding : after.arrays "gd".toList=some gd := rfl
theorem fs_binding : after.arrays "fs".toList=some fs := rfl
theorem gs_binding : after.arrays "gs".toList=some gs := rfl
theorem gm_binding : after.arrays "gm".toList=some gm := rfl
theorem igm_binding : after.arrays "igm".toList=some igm := rfl
theorem t1_binding : after.arrays "t1".toList=some t1 := rfl

theorem writable : after.heap.writable 31=true := by
  rw [SelectedGen0Frame189.stable.writable,SelectedStepPrime188.heap]
  exact SelectedStepReady187.scratch_writable

end FT1536.Source3.SelectedGen0Ready189
