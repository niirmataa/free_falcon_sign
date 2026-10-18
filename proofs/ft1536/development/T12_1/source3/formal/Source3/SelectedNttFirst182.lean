import Source3.SelectedFirstInput182
import Source3.NttGlue182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedNttFirst182
open C99ArrayReference (State)
open C99ModularReference (Exec)
open SelectedTopLayout177 (fs gm)
open SelectedTopInit178 (p p0i)
open SelectedForwardEntry182 (entry)
open SelectedFirstInput182 (twiddle input)

noncomputable def prepared := NttFirstSetup182.after entry twiddle

theorem prologue : Exec KeygenNttForwardPrograms.prologue entry ⟨KeygenNttForwardExec.ready entry,.normal⟩ :=
  NttPrologue182.source entry input.logn input.full

theorem twiddle_source : Exec KeygenNttForwardPrograms.wAssign (KeygenNttForwardExec.ready entry) ⟨prepared,.normal⟩ :=
  NttFirstSetup182.source entry fs gm p p0i twiddle input

theorem exists_execution : ∃ out, Exec KeygenNttForwardPrograms.firstLoop prepared ⟨out,.normal⟩ ∧
    NttFirstFixed182.Fixed out fs gm p p0i twiddle ∧ KeygenNttLoopSupport.USlot out "u" 768 ∧
    out.arrays "r1".toList=some (KeygenSmallOutput.element fs 768) ∧
    out.arrays "r2".toList=some (KeygenSmallOutput.element fs 1536) ∧
    NttWriteFrame182.Frame fs 1536 prepared.heap out.heap :=
  NttFirstLoop182.full prepared fs gm p p0i twiddle (NttFirstSetup182.fixed entry fs gm p p0i twiddle input)
    none (NttFirstSetup182.u_declared entry twiddle)

noncomputable def after : State := Classical.choose exists_execution

theorem loop_source : Exec KeygenNttForwardPrograms.firstLoop prepared ⟨after,.normal⟩ := (Classical.choose_spec exists_execution).1

theorem first_pass : Exec KeygenNttForwardPrograms.firstPass (KeygenNttForwardExec.ready entry) ⟨after,.normal⟩ :=
  .seqNormal _ _ _ prepared _ twiddle_source
    (.seqNormal _ _ prepared after _ loop_source (.base .skip after after (.skip after)))

theorem fixed : NttFirstFixed182.Fixed after fs gm p p0i twiddle := (Classical.choose_spec exists_execution).2.1
theorem counter : KeygenNttLoopSupport.USlot after "u" 768 := (Classical.choose_spec exists_execution).2.2.1
theorem pointers : after.arrays "r1".toList=some (KeygenSmallOutput.element fs 768) ∧
    after.arrays "r2".toList=some (KeygenSmallOutput.element fs 1536) :=
  ⟨(Classical.choose_spec exists_execution).2.2.2.1,(Classical.choose_spec exists_execution).2.2.2.2.1⟩
theorem frame : NttWriteFrame182.Frame fs 1536 entry.heap after.heap := (Classical.choose_spec exists_execution).2.2.2.2.2

def remaining := KeygenNttForwardPrograms.glue KeygenNttForwardPrograms.intermediatePass KeygenNttForwardPrograms.triplePass

theorem continue_forward (out : C99ProcedureReference.Result) (rest : Exec remaining after out) :
    Exec KeygenNttForwardPrograms.forwardBody entry out :=
  NttGlue182.source KeygenNttForwardPrograms.prologue entry (KeygenNttForwardExec.ready entry) prologue _ out
    (NttGlue182.source KeygenNttForwardPrograms.firstPass (KeygenNttForwardExec.ready entry) after first_pass remaining out rest)

end FT1536.Source3.SelectedNttFirst182
