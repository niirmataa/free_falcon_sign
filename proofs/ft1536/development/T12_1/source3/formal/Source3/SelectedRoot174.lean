import Source3.PublicRootStart174
import Source3.SelectedReverse173

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedRoot174
open C99ArrayReference (State)
open KeygenPublicExec (Exec)
open SelectedPublicBinding157 (h)
open PublicInverseBody172 (igmPointer)

theorem exists_root : ∃ after, Exec KeygenPublicSource.program [] PublicRootStart174.segment SelectedReverse173.after ⟨after,.normal⟩ ∧
    PublicRootLoop174.Fixed after h ∧ KeygenNttLoopSupport.USlot after "u" 768 ∧
    PublicMiddleWrites161.MemoryFrame SelectedReverse173.after after h :=
  PublicRootStart174.source SelectedReverse173.after h (igmPointer 34) SelectedReverse173.output_arrays
    SelectedReverse173.hn_cell SelectedReverse173.r_type ⟨_,SelectedReverse173.u_cell⟩

noncomputable def after : State := Classical.choose exists_root
theorem source : Exec KeygenPublicSource.program [] PublicRootStart174.segment SelectedReverse173.after ⟨after,.normal⟩ :=
  (Classical.choose_spec exists_root).1
theorem data : PublicForwardMemory167.Data after.heap h := (Classical.choose_spec exists_root).2.1.data
theorem binding : after.arrays "a".toList=some h := (Classical.choose_spec exists_root).2.1.binding
theorem u_cell : KeygenNttLoopSupport.USlot after "u" 768 := (Classical.choose_spec exists_root).2.2.1
theorem n_cell : KeygenNttLoopSupport.USlot after "n" 1536 :=
  (PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.2 _ (by decide) |>.trans SelectedReverse173.n_cell
theorem profile : KeygenPublicTableAtoms.Slot after "logn" 10 :=
  (PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.2 _ (by decide) |>.trans SelectedReverse173.profile
theorem ni_type : PublicU32Locals165.Declared after "ni" := by
  obtain ⟨old,cell⟩ := SelectedReverse173.ni_type
  exact ⟨old,(PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.2 _ (by decide) |>.trans cell⟩

theorem continue_inverse (finalState : State)
    (remaining : Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.remaining after ⟨finalState,.normal⟩) :
    Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverseT)
      (PublicForwardEntry159.entryT SelectedQuotient171.after h)
      ⟨PublicInverseBody172.bodyState (PublicForwardEntry159.entryT SelectedQuotient171.after h) 33 34 finalState,.normal⟩ :=
  SelectedReverse173.continue_inverse finalState
    (PublicRootStart174.continue_section SelectedReverse173.after after ⟨finalState,.normal⟩ source remaining)

end FT1536.Source3.SelectedRoot174
