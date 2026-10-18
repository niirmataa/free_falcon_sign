import Source3.GeneratorCubeLoop180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorCubeSetup180
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenMkgm3Program
open KeygenModpR2Exec (Slot)
open SelectedTopInit178 (p p0i)
open SelectedTopLayout177 (gm igm)

noncomputable def before := SelectedGeneratorRow179.after
noncomputable def logged := ModularAtoms178.set before "k" 9
noncomputable def after := ModularAtoms178.set logged "k" 8

theorem logn_cell : Slot before "logn" 10 :=
  ((KeygenMkgm3Control.frame _ _ _ (by decide) SelectedGeneratorRow179.source).2.2 _ (by decide)).trans
    SelectedGeneratorRowTable179.ready.logn

theorem full_cell : Slot before "full" 1 :=
  ((KeygenMkgm3Control.frame _ _ _ (by decide) SelectedGeneratorRow179.source).2.2 _ (by decide)).trans
    SelectedGeneratorRowTable179.ready.full

theorem params : KeygenMkgm3Atoms.Params before p0i :=
  KeygenMkgm3Atoms.params_transport _ SelectedGeneratorRow179.before ⟨before,.normal⟩ p0i
    (by decide) (by decide) (by decide) SelectedGeneratorRowTable179.ready.params SelectedGeneratorRow179.source

theorem pointers : KeygenMkgm3Upward.Pointers before gm igm :=
  KeygenMkgm3Upward.pointers_after _ SelectedGeneratorRow179.before ⟨before,.normal⟩ gm igm (by decide)
    SelectedGeneratorRowTable179.pointers SelectedGeneratorRow179.source

theorem source : Exec kFromLogn before ⟨logged,.normal⟩ :=
  ModularAtoms178.assign before "k" (some (.uint32 1)) _ 9 SelectedGeneratorRowTable179.k_cell
    (.scalar _ _ (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn_cell) (.literal .int32 1)
      (.step .minus (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))))

theorem decrement : Exec (dec "k") logged ⟨after,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 9)) (.uint32 8)
    (ModularAtoms178.slot before "k" 9)
    (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ (ModularAtoms178.slot before "k" 9)) (.literal .int32 1)
      (.step .minus (.uint32 9) (.int32 1) .uint32 rfl (.uint32 9) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible)))))

theorem heap : after.heap=before.heap := by
  dsimp only [after,logged,ModularAtoms178.set,C99ArrayReference.bindValue]

theorem fixed : GeneratorCubeFixed180.Fixed after gm igm p p0i := by
  refine ⟨params.1,params.2,ModularAtoms178.slot logged "k" 8,pointers.forward,pointers.inverse,
    by decide,by decide,?_,?_,?_,?_,?_,?_⟩
  · intro j hj
    rw [heap]
    exact SelectedGeneratorRowLoop179.fixed.gAllocated j hj
  · intro j hj
    rw [heap]
    exact SelectedGeneratorRowLoop179.fixed.iAllocated j hj
  · rw [heap]; exact SelectedGeneratorRowLoop179.fixed.gWritable
  · rw [heap]; exact SelectedGeneratorRowLoop179.fixed.iWritable
  · intro j lo hi; rw [heap]; exact SelectedGeneratorInitialized180.g_initialized j lo hi
  · intro j lo hi; rw [heap]; exact SelectedGeneratorInitialized180.i_initialized j lo hi

theorem u_cell : KeygenNttLoopSupport.USlot after "u" 512 := SelectedGeneratorRowTable179.u_cell

end FT1536.Source3.SelectedGeneratorCubeSetup180
