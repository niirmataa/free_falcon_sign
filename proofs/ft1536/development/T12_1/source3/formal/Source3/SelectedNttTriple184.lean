import Source3.NttTriplePass184
import Source3.SelectedMiddleMetadata183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedNttTriple184
open C99ArrayReference (State)
open C99ModularReference (Exec)
open SelectedTopLayout177 (fs gm)
open SelectedTopInit178 (p p0i)
open SelectedFirstInput182 (twiddle)

noncomputable abbrev before := SelectedNttMiddle183.after

theorem table_reads : NttMiddleTable183.Reads before.heap gm := by
  intro i hi
  obtain ⟨w,read,_⟩ := SelectedMiddleFrame183.gm_table i hi
  exact ⟨w,read⟩

theorem exists_execution : ∃ out wNew, Exec KeygenNttForwardPrograms.triplePass before ⟨out,.normal⟩ ∧
    NttFirstFixed182.Fixed out fs gm p p0i wNew ∧ KeygenNttLoopSupport.USlot out "u" 1536 ∧
    KeygenNttLoopSupport.USlot out "r" 1024 ∧ NttWriteFrame182.Frame fs 1536 before.heap out.heap :=
  NttTriplePass184.full before fs gm p p0i twiddle SelectedNttMiddle183.fixed SelectedNttMiddle183.separate table_reads
    SelectedMiddleMetadata183.logn_cell SelectedMiddleMetadata183.full_cell (some (KeygenNttLoopSupport.u64 768)) none
    SelectedMiddleMetadata183.u_cell SelectedMiddleMetadata183.r_declared

noncomputable def after : State := Classical.choose exists_execution
noncomputable def wNew : BitVec 32 := Classical.choose (Classical.choose_spec exists_execution)

theorem specification : Exec KeygenNttForwardPrograms.triplePass before ⟨after,.normal⟩ ∧
    NttFirstFixed182.Fixed after fs gm p p0i wNew ∧ KeygenNttLoopSupport.USlot after "u" 1536 ∧
    KeygenNttLoopSupport.USlot after "r" 1024 ∧ NttWriteFrame182.Frame fs 1536 before.heap after.heap :=
  Classical.choose_spec (Classical.choose_spec exists_execution)

theorem source : Exec KeygenNttForwardPrograms.triplePass before ⟨after,.normal⟩ := specification.1
theorem fixed : NttFirstFixed182.Fixed after fs gm p p0i wNew := specification.2.1
theorem u_cell : KeygenNttLoopSupport.USlot after "u" 1536 := specification.2.2.1
theorem r_cell : KeygenNttLoopSupport.USlot after "r" 1024 := specification.2.2.2.1
theorem frame : NttWriteFrame182.Frame fs 1536 before.heap after.heap := specification.2.2.2.2

theorem body_source : Exec KeygenNttForwardPrograms.forwardBody SelectedForwardEntry182.entry ⟨after,.normal⟩ :=
  SelectedNttMiddle183.continue_forward ⟨after,.normal⟩ source

end FT1536.Source3.SelectedNttTriple184
