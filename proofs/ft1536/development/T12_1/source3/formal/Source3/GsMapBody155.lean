import Source3.GsMapShape155
import Source3.FftWordStoreStep140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsMapBody155
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Load64)
open C99ProcedureReference (Program Exec)
open GsMapShape155 (Operation Extra value)

def output (s : State) (p : ArrayPointer) (word : BitVec 64) : State :=
  {s with heap := C99WordStore140.write s.heap p word}

theorem source (program : Program) (op : Operation) (factor word : BitVec 64) (s : State) (p : ArrayPointer)
    (extra : Extra op factor s) (address : Pointer s "a".toList FftFirstShape149.index0 p)
    (read : Load64 s.heap p word) (writable : s.heap.writable p.block=true) :
    Exec program (GsMapShape155.body op) s ⟨output s p (value op factor word),.normal⟩ := by
  have store := FftWordStoreStep140.source FftLeafPrograms.program s "a".toList FftFirstShape149.index0
    (GsMapShape155.expression op) p (value op factor word) address (GsMapShape155.evaluated op factor word s p extra address read)
    (FftLoadExec140.allocated_of_load s.heap p word read) (FftLoadExec140.width_of_load s.heap p word read) writable
  exact .scope _ _ _ _ _ (.seqNormal _ _ _ _ _ (.base _ _ _ store) (.base _ _ _ (.skip _)))

theorem frame {n : Nat} (s : State) (base : ArrayPointer) (i : Fin n) (word : BitVec 64)
    (width : base.elementBytes=8) :
    FftGroupFrame143.Frame base n s (output s (C99WordBuffer140.element base i) word) := by
  refine ⟨rfl,rfl,rfl,rfl,rfl,rfl,?_⟩
  intro block offset outside
  have separate := FftLoopFrame141.outside_element base width i block offset outside
  have absent : ¬(block=(C99WordBuffer140.element base i).block ∧
      (C99WordBuffer140.element base i).offset ≤ offset ∧ offset<(C99WordBuffer140.element base i).offset+8) := by omega
  simp only [output,C99WordStore140.write,dite_eq_right absent]

end FT1536.Source3.GsMapBody155
