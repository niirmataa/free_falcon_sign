import Source3.SelectedSecondInput185

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSecondBody185
open C99ArrayReference (State)
open C99ModularReference (Exec)
open SelectedTopLayout177 (gs gm)
open SelectedTopInit178 (p p0i)
open SelectedSecondEntry185 (entry)
open SelectedSecondInput185 (twiddle input separate table_reads)

theorem exists_execution : ∃ out wNew, Exec KeygenNttForwardPrograms.forwardBody entry ⟨out,.normal⟩ ∧
    NttFirstFixed182.Fixed out gs gm p p0i wNew ∧ KeygenNttLoopSupport.USlot out "u" 1536 ∧
    KeygenNttLoopSupport.USlot out "r" 1024 ∧ NttWriteFrame182.Frame gs 1536 entry.heap out.heap :=
  NttWholeSource185.source entry gs gm p p0i twiddle input separate table_reads

noncomputable def after : State := Classical.choose exists_execution
noncomputable def wNew : BitVec 32 := Classical.choose (Classical.choose_spec exists_execution)

theorem specification : Exec KeygenNttForwardPrograms.forwardBody entry ⟨after,.normal⟩ ∧
    NttFirstFixed182.Fixed after gs gm p p0i wNew ∧ KeygenNttLoopSupport.USlot after "u" 1536 ∧
    KeygenNttLoopSupport.USlot after "r" 1024 ∧ NttWriteFrame182.Frame gs 1536 entry.heap after.heap :=
  Classical.choose_spec (Classical.choose_spec exists_execution)

theorem source : Exec KeygenNttForwardPrograms.forwardBody entry ⟨after,.normal⟩ := specification.1
theorem fixed : NttFirstFixed182.Fixed after gs gm p p0i wNew := specification.2.1
theorem u_cell : KeygenNttLoopSupport.USlot after "u" 1536 := specification.2.2.1
theorem r_cell : KeygenNttLoopSupport.USlot after "r" 1024 := specification.2.2.2.1
theorem frame : NttWriteFrame182.Frame gs 1536 entry.heap after.heap := specification.2.2.2.2

end FT1536.Source3.SelectedSecondBody185
