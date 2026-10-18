import Source3.GeneratorCubeFixed180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorCubeIndex180
open C99ArrayReference (State Pointer scalar)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)

def twice : CLogic.Expr := .bin .shl (.var "u".toList) (.literal .i32 1)

theorem doubled (s : State) (u : Nat) (bound : u<512) (counter : USlot s "u" u) :
    scalar s twice (u64 (2*u)) :=
  .shift .left _ _ _ _ _ (.variable _ _ _ counter) (.literal .int32 1)
    (PublicGenerateIndex159.shl_one u (by omega) (.int32 1) rfl)

theorem address (s : State) (name : String) (base : ArrayPointer) (i : Nat) (bound : i<1024)
    (expr : CLogic.Expr) (binding : s.arrays name.toList=some base)
    (value : scalar s expr (u64 i)) (allocated : Allocated s.heap (element base i)) :
    Pointer s name.toList expr (element base i) := by
  refine .add _ _ base _ (u64 i) binding value ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer i (by omega)]; omega
  · rw [KeygenNttLoopSupport.u64_toNat i (by omega)]
    exact .within base i (Nat.le_of_lt allocated.2.2.1)

end FT1536.Source3.GeneratorCubeIndex180
