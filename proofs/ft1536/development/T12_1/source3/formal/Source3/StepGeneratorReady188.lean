import Source3.StepGeneratorPrefix188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepGeneratorReady188
open KeygenModpR2Exec (Slot)
open StepGeneratorInverseCall188 (after ig)
open SelectedTopInit178 (p p0i r2)
open StepGeneratorScalar188 (r)
open StepGeneratorSquare188 (g1)
open SelectedStepLayout187 (gm igm fs gs)
open KeygenFullData127 (rev)

theorem heap : after.heap=SelectedStepMove187.after.heap := StepGeneratorPrefix188.heap.trans StepGeneratorEntry188.entry_heap

theorem k_cell : Slot after "k" 12 :=
  (ModularAtoms178.outside StepGeneratorInverseCall188.before "ig" "k" ig (by decide)).trans StepGeneratorSquare188.k_cell

theorem g_cell : Slot after "g" g1 :=
  (ModularAtoms178.outside StepGeneratorInverseCall188.before "ig" "g" ig (by decide)).trans StepGeneratorSquare188.g_cell

theorem ig_cell : Slot after "ig" ig := ModularAtoms178.slot StepGeneratorInverseCall188.before "ig" ig

theorem scalar_r : Slot StepGeneratorScalar188.after "R" r :=
  (ModularAtoms178.outside StepGeneratorScalar188.converted "k" "R" 9 (by decide)).trans
    ((ModularAtoms178.outside StepGeneratorScalar188.withR2 "g" "R" StepGeneratorScalar188.g0 (by decide)).trans
      ((ModularAtoms178.outside StepGeneratorScalar188.withR "R2" "R" r2 (by decide)).trans
        (ModularAtoms178.slot StepGeneratorScalar188.before "R" r)))

theorem scalar_r2 : Slot StepGeneratorScalar188.after "R2" r2 :=
  (ModularAtoms178.outside StepGeneratorScalar188.converted "k" "R2" 9 (by decide)).trans
    ((ModularAtoms178.outside StepGeneratorScalar188.withR2 "g" "R2" StepGeneratorScalar188.g0 (by decide)).trans
      (ModularAtoms178.slot StepGeneratorScalar188.withR "R2" r2))

theorem r_cell : Slot after "R" r :=
  KeygenNttControl.keep_u32 StepGeneratorInverseCall188.source (by decide) "R" r (by decide)
    (KeygenNttControl.keep_u32 StepGeneratorSquare188.loop_source (by decide) "R" r (by decide)
      (KeygenNttControl.keep_u32 StepGeneratorCube188.source (by decide) "R" r (by decide) scalar_r))

theorem r2_cell : Slot after "R2" r2 :=
  KeygenNttControl.keep_u32 StepGeneratorInverseCall188.source (by decide) "R2" r2 (by decide)
    (KeygenNttControl.keep_u32 StepGeneratorSquare188.loop_source (by decide) "R2" r2 (by decide)
      (KeygenNttControl.keep_u32 StepGeneratorCube188.source (by decide) "R2" r2 (by decide) scalar_r2))

theorem u_declared : after.locals "u".toList=some (.uint64,none) :=
  ((KeygenNttControl.frame _ _ _ (by decide) StepGeneratorPrefix188.scalar_source).2.1 "u".toList (by decide)).trans rfl

theorem w_declared : after.locals "w".toList=some (.uint32,none) :=
  ((KeygenNttControl.frame _ _ _ (by decide) StepGeneratorPrefix188.scalar_source).2.1 "w".toList (by decide)).trans rfl

theorem p_cell : Slot after "p" p :=
  KeygenNttControl.keep_u32 StepGeneratorPrefix188.source (by decide) "p" p (by decide) rfl

theorem i_cell : Slot after "p0i" p0i :=
  KeygenNttControl.keep_u32 StepGeneratorPrefix188.source (by decide) "p0i" p0i (by decide) rfl

theorem logn_cell : Slot after "logn" 9 :=
  KeygenNttControl.keep_u32 StepGeneratorPrefix188.source (by decide) "logn" 9 (by decide) rfl

theorem full_cell : Slot after "full" 0 :=
  KeygenNttControl.keep_u32 StepGeneratorPrefix188.source (by decide) "full" 0 (by decide) rfl

theorem gm_binding : after.arrays "gm".toList=some gm :=
  KeygenNttControl.keep_pointer StepGeneratorPrefix188.source (by decide) "gm" gm (by decide) rfl

theorem igm_binding : after.arrays "igm".toList=some igm :=
  KeygenNttControl.keep_pointer StepGeneratorPrefix188.source (by decide) "igm" igm (by decide) rfl

theorem rev_binding : after.arrays "REV10".toList=some rev :=
  KeygenNttControl.keep_pointer StepGeneratorPrefix188.source (by decide) "REV10" rev (by decide) StepGeneratorEntry188.rev_binding

theorem rev_source : KeygenMkgm3RevMemory.SourceTable after.heap rev := by
  rw [heap]
  exact SelectedStepReady187.rev_source

theorem f_read (j : Nat) (bound : j<512) : ∃ word, C99MemoryReference.Load32 after.heap (KeygenSmallOutput.element fs j) word := by
  rw [heap]
  exact SelectedStepMove187.f_read j bound

theorem g_read (j : Nat) (bound : j<512) : ∃ word, C99MemoryReference.Load32 after.heap (KeygenSmallOutput.element gs j) word := by
  rw [heap]
  exact SelectedStepMove187.g_read j bound

theorem allocated (index : Nat) (inside : index<71680) :
    C99MemoryReference.Allocated after.heap {KeygenFullData127.env.ctx.scratch with index:=index} := by
  rw [heap]
  exact SelectedStepMove187.allocated index inside

theorem writable : after.heap.writable 31=true := by
  rw [heap]
  exact SelectedStepReady187.scratch_writable

end FT1536.Source3.StepGeneratorReady188
