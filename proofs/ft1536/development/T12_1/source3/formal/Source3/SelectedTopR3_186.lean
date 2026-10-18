import Source3.TopProductLoop186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopR3_186
open C99ArrayReference (State)
open KeygenLevelExec (Exec)
open SelectedTopInit178 (p p0i r2)
open SelectedTopLayout177 (fd gd gs)
open KeygenSmallOutput (element)

def r3 := KeygenModpWord.montgomery r2 r2 p p0i
noncomputable abbrev before := SelectedSecondCall185.after
noncomputable def after := ModularAtoms178.set before "R3" r3

theorem source : Exec TopProductShape185.r3Set before ⟨after,.normal⟩ :=
  .modular _ _ _ (ModularAtoms178.assign before "R3" none _ r3 SelectedSecondMetadata185.r3_declared
    (ModularAtoms178.mont before _ _ r2 r2 p p0i
      (ModularAtoms178.cell before "R2" r2 SelectedSecondMetadata185.r2_cell)
      (ModularAtoms178.cell before "R2" r2 SelectedSecondMetadata185.r2_cell)
      SelectedSecondMetadata185.p_cell SelectedSecondMetadata185.i_cell))

theorem fixed : TopProductFixed186.Fixed after p p0i r3 := by
  refine ⟨SelectedSecondMetadata185.p_cell,SelectedSecondMetadata185.i_cell,ModularAtoms178.slot before "R3" r3,
    SelectedSecondMetadata185.out_ntt_cell,SelectedSecondMetadata185.n_cell,
    SelectedSecondMetadata185.fd_binding,SelectedSecondMetadata185.gd_binding,
    SelectedSecondMetadata185.fs_binding,SelectedSecondMetadata185.gs_binding,?_,?_,
    SelectedSecondMetadata185.scratch_writable,SelectedSecondFrame185.f_readable,SelectedSecondFrame185.g_readable⟩
  · intro j hj
    exact TopProductMemory186.relocate after.heap (element gs 0) (670+j)
      (by change 670+j<71680; omega) (SelectedSecondBody185.fixed.allocated 0 (by decide))
  · intro j hj
    exact TopProductMemory186.relocate after.heap (element gs 0) (1182+j)
      (by change 1182+j<71680; omega) (SelectedSecondBody185.fixed.allocated 0 (by decide))

theorem u_declared : after.locals "u".toList=some (.uint64,none) := SelectedSecondMetadata185.u_declared
theorem v_declared : after.locals "v".toList=some (.uint64,none) := SelectedSecondMetadata185.v_declared

end FT1536.Source3.SelectedTopR3_186
