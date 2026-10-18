import Source3.SelectedSecondFrame185

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSecondMetadata185
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open SelectedSecondCall185 (after)
open SelectedTopInit178 (p p0i r2)
open SelectedTopLayout177 (fd gd fs gs gm igm)

theorem p_cell : Slot after "p" p := SelectedTopInit178.p_cell
theorem i_cell : Slot after "p0i" p0i := SelectedTopInit178.i_cell
theorem r2_cell : Slot after "R2" r2 := SelectedTopInit178.r_cell
theorem logn_cell : Slot after "logn" 10 := SelectedTopPrefix177.logn_cell
theorem n_cell : USlot after "n" 1536 := rfl
theorem dn_cell : USlot after "dn" 1024 := rfl
theorem tn_cell : USlot after "tn" 512 := rfl
theorem out_ntt_cell : after.locals "out_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem r3_declared : after.locals "R3".toList=some (.uint32,none) := rfl
theorem u_declared : after.locals "u".toList=some (.uint64,none) := rfl
theorem v_declared : after.locals "v".toList=some (.uint64,none) := rfl
theorem fd_binding : after.arrays "fd".toList=some fd := rfl
theorem gd_binding : after.arrays "gd".toList=some gd := rfl
theorem fs_binding : after.arrays "fs".toList=some fs := rfl
theorem gs_binding : after.arrays "gs".toList=some gs := rfl
theorem gm_binding : after.arrays "gm".toList=some gm := rfl
theorem igm_binding : after.arrays "igm".toList=some igm := rfl
theorem scratch_writable : after.heap.writable 31=true := SelectedSecondBody185.fixed.writable

end FT1536.Source3.SelectedSecondMetadata185
