import Source3.PublicReverseStart173
import Source3.SelectedInversePrefix172

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedReverse173
open C99ArrayReference (State)
open KeygenPublicExec (Exec)
open SelectedPublicBinding157 (h)
open PublicInverseBody172 (igmPointer)
open KeygenNttLoopSupport (USlot)
open SelectedInversePrefix172 (last output_domain)

theorem arrays : PublicReverseRoundContext173.Arrays last h (igmPointer 34) :=
  ⟨PublicForwardMemory167.capacity _ h output_domain.data,
    PublicInverseDomains172.table_capacity _ h _ output_domain.toArrays,
    output_domain.aBinding,output_domain.square,output_domain.tableWritten,output_domain.separate,
    PublicForwardMemory167.width _ h output_domain.data,output_domain.data.writable,
    PublicInverseMemory172.allocated _ h _ output_domain.toArrays,output_domain.data.written⟩

def segment := KeygenPublicExec.Stmt.seq KeygenPublicReverseProgram.start KeygenPublicReverseProgram.stages

theorem exists_rounds : ∃ after, Exec KeygenPublicSource.program [] segment last ⟨after,.normal⟩ ∧
    PublicReverseRoundContext173.Arrays after h (igmPointer 34) ∧ USlot after "t" 1536 ∧ USlot after "m" 1 ∧
    (∃ old, after.locals "v".toList=some (.uint64,old)) ∧ PublicMiddleWrites161.MemoryFrame last after h :=
  PublicReverseStart173.source last h (igmPointer 34) arrays output_domain.profile output_domain.nCell
    output_domain.tType output_domain.mType ⟨_,output_domain.vCell⟩

noncomputable def after : State := Classical.choose exists_rounds

theorem source : Exec KeygenPublicSource.program [] segment last ⟨after,.normal⟩ :=
  (Classical.choose_spec exists_rounds).1

theorem output_arrays : PublicInverseDomains172.Arrays after h (igmPointer 34) := by
  have a := (Classical.choose_spec exists_rounds).2.1
  have bindings := (PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.1
  refine ⟨⟨a.writable,a.written⟩,a.binding,a.tableBinding,?_,a.tableWritten,a.separate⟩
  rw [bindings]
  exact output_domain.cubic

theorem n_cell : USlot after "n" 1536 :=
  (PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.2 _ (by decide) |>.trans output_domain.nCell
theorem hn_cell : USlot after "hn" 768 :=
  (PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.2 _ (by decide) |>.trans output_domain.hnCell
theorem u_cell : USlot after "u" 1536 :=
  (PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.2 _ (by decide) |>.trans output_domain.uCell
theorem profile : KeygenPublicTableAtoms.Slot after "logn" 10 :=
  (PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.2 _ (by decide) |>.trans output_domain.profile

theorem r_type : PublicU32Locals165.Declared after "r" := by
  obtain ⟨old,cell⟩ := output_domain.rType
  exact ⟨old,(PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.2 _ (by decide) |>.trans cell⟩
theorem ni_type : PublicU32Locals165.Declared after "ni" := by
  obtain ⟨old,cell⟩ := output_domain.niType
  exact ⟨old,(PublicScopedFrame162.frame _ _ _ _ _ (by decide) source).2.2 _ (by decide) |>.trans cell⟩

theorem continue_inverse (finalState : State)
    (remaining : Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.remaining after ⟨finalState,.normal⟩) :
    Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverseT)
      (PublicForwardEntry159.entryT SelectedQuotient171.after h)
      ⟨PublicInverseBody172.bodyState (PublicForwardEntry159.entryT SelectedQuotient171.after h) 33 34 finalState,.normal⟩ :=
  SelectedInversePrefix172.continue_inverse finalState
    (PublicReverseStart173.continue_section last after ⟨finalState,.normal⟩ source remaining)

end FT1536.Source3.SelectedReverse173
