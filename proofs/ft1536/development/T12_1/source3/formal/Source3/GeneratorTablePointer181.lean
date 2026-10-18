import Source3.SelectedGeneratorSquare181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorTablePointer181
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenSmallOutput (element)

theorem integer (i : Nat) (bound : i < 1024) :
    (C99IntegerReference.convert .int32 (i : Int)).integer=(i : Int) := by
  apply BitVec.toInt_ofInt_eq_self <;> omega

theorem literal (s : State) (name : String) (base : ArrayPointer) (i : Nat) (bound : i < 1024)
    (binding : s.arrays name.toList=some base) (allocated : Allocated s.heap (element base i)) :
    Pointer s name.toList (KeygenMkgm3Program.num i) (element base i) := by
  refine .add _ _ base _ (C99IntegerReference.convert .int32 i) binding (.literal .int32 i) ?_ ?_
  · rw [integer i bound]; omega
  · rw [integer i bound]
    exact .within base i (Nat.le_of_lt allocated.2.2.1)

end FT1536.Source3.GeneratorTablePointer181
