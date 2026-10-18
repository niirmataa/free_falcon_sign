import Source3.NttMLoop183
import Source3.SelectedFirstMetadata182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedNttMiddle183
open C99ArrayReference (State)
open C99ModularReference (Exec)
open SelectedTopLayout177 (fs gm)
open SelectedTopInit178 (p p0i)
open SelectedFirstInput182 (twiddle)

noncomputable abbrev before := SelectedNttFirst182.after

theorem separate : NttMiddleTable183.Separate fs gm := by
  intro i hi byte
  right; right
  change 0+4*1694+4*1536≤0+4*(4766+i)+byte.val
  omega

theorem table_reads : NttMiddleTable183.Reads before.heap gm := by
  intro i hi
  obtain ⟨w,read,_⟩ := SelectedFirstFrame182.gm_table i hi
  exact ⟨w,read⟩

theorem exists_execution : ∃ out, Exec KeygenNttForwardPrograms.intermediatePass before ⟨out,.normal⟩ ∧
    NttFirstFixed182.Fixed out fs gm p p0i twiddle ∧ KeygenNttLoopSupport.USlot out "m" 512 ∧
    KeygenNttLoopSupport.USlot out "t" 3 ∧ NttWriteFrame182.Frame fs 1536 before.heap out.heap :=
  NttMLoop183.full before fs gm p p0i twiddle SelectedNttFirst182.fixed separate table_reads
    SelectedFirstMetadata182.full_cell none none SelectedFirstMetadata182.t_declared SelectedFirstMetadata182.m_declared

noncomputable def after : State := Classical.choose exists_execution

theorem source : Exec KeygenNttForwardPrograms.intermediatePass before ⟨after,.normal⟩ :=
  (Classical.choose_spec exists_execution).1

theorem fixed : NttFirstFixed182.Fixed after fs gm p p0i twiddle := (Classical.choose_spec exists_execution).2.1
theorem m_cell : KeygenNttLoopSupport.USlot after "m" 512 := (Classical.choose_spec exists_execution).2.2.1
theorem t_cell : KeygenNttLoopSupport.USlot after "t" 3 := (Classical.choose_spec exists_execution).2.2.2.1
theorem frame : NttWriteFrame182.Frame fs 1536 before.heap after.heap := (Classical.choose_spec exists_execution).2.2.2.2

theorem continue_forward (out : C99ProcedureReference.Result)
    (rest : Exec KeygenNttForwardPrograms.triplePass after out) :
    Exec KeygenNttForwardPrograms.forwardBody SelectedForwardEntry182.entry out :=
  SelectedNttFirst182.continue_forward out
    (NttGlue182.source KeygenNttForwardPrograms.intermediatePass before after source
      KeygenNttForwardPrograms.triplePass out rest)

end FT1536.Source3.SelectedNttMiddle183
