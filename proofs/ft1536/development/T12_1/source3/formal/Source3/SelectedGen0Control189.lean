import Source3.SelectedGen0Row189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGen0Control189
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open SelectedStepLayout187 (gm igm)
open SelectedTopInit178 (p p0i)

noncomputable abbrev before := SelectedGen0Row189.after
noncomputable def after := ModularAtoms178.set before "k" 8

theorem k_before : Slot before "k" 2 := SelectedGen0RowLoop189.fixed.kCell

theorem logn_cell : Slot before "logn" 9 :=
  KeygenNttControl.keep_u32 SelectedGen0Row189.source (by decide) "logn" 9 (by decide) StepGeneratorReady188.logn_cell

theorem full_cell : Slot before "full" 0 :=
  KeygenNttControl.keep_u32 SelectedGen0Row189.source (by decide) "full" 0 (by decide) StepGeneratorReady188.full_cell

theorem k_source : Exec KeygenMkgm3Program.kFromLogn before ⟨after,.normal⟩ :=
  ModularAtoms178.assign before "k" (some (.uint32 2)) _ 8 k_before
    (.scalar _ _ (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn_cell) (.literal .int32 1)
      (.step .minus (.uint32 9) (.int32 1) .uint32 rfl (.uint32 9) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))))

theorem skip_cube : Exec KeygenMkgm3Program.ifFull after ⟨after,.normal⟩ :=
  .branchFalse _ _ _ after ⟨after,.normal⟩ (.uint32 0) (.variable _ _ _ full_cell) rfl (.base .skip after after (.skip after))

theorem initialized : GeneratorSquareDomains181.From after.heap gm igm 0 :=
  GeneratorSquareDomains181.from_transport _ _ gm igm 0
    (C99InitializationTrace.steps_preserve _ _ (KeygenMkgm3RevMemory.memory_steps _ _ _ SelectedGen0Row189.source)) Gen0RawInitialized189.initialized

theorem fixed : GeneratorCubeFixed180.Fixed after gm igm p p0i := by
  have stable := KeygenMemoryStability.modular _ _ _ SelectedGen0Row189.source
  have control := KeygenNttControl.frame _ _ _ (by decide) SelectedGen0Row189.source
  refine ⟨?_,?_,ModularAtoms178.slot before "k" 8,?_,?_,by decide,by decide,?_,?_,?_,?_,?_,?_⟩
  · exact (control.2.1 "p".toList (by decide)).trans StepGeneratorReady188.p_cell
  · exact (control.2.1 "p0i".toList (by decide)).trans StepGeneratorReady188.i_cell
  · exact (control.2.2 "gm".toList (by decide)).trans StepGeneratorReady188.gm_binding
  · exact (control.2.2 "igm".toList (by decide)).trans StepGeneratorReady188.igm_binding
  · intro j hj
    change C99MemoryReference.Allocated before.heap (KeygenSmallOutput.element gm j)
    unfold C99MemoryReference.Allocated
    rw [show before.heap.size=StepGeneratorInverseCall188.after.heap.size from stable.size]
    exact StepGeneratorReady188.allocated (2718+j) (by omega)
  · intro j hj
    change C99MemoryReference.Allocated before.heap (KeygenSmallOutput.element igm j)
    unfold C99MemoryReference.Allocated
    rw [show before.heap.size=StepGeneratorInverseCall188.after.heap.size from stable.size]
    exact StepGeneratorReady188.allocated (3230+j) (by omega)
  · change before.heap.writable 31=true
    rw [stable.writable]
    exact StepGeneratorReady188.writable
  · change before.heap.writable 31=true
    rw [stable.writable]
    exact StepGeneratorReady188.writable
  · intro j lo hi; exact (initialized j (by omega) hi).1
  · intro j lo hi; exact (initialized j (by omega) hi).2

theorem u_cell : KeygenNttLoopSupport.USlot after "u" 256 := SelectedGen0RowLoop189.end_counter

end FT1536.Source3.SelectedGen0Control189
