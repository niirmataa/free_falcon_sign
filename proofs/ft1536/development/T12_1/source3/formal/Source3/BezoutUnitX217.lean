import Source3.BezoutUnitGuard217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The first source unit case returns from the whole part before its tail. -/
namespace FT1536.Source3.BezoutUnitX217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenZintCall (Exec)
open StepCopyBody190 (elem)
open BezoutUnitGuard217 (unit)

theorem source (s : State) (root : ArrayPointer) (n : Nat) (w : BitVec 32)
    (bound : n<2^64) (cell : Cell s "xlen".toList n) (binding : s.arrays "x".toList=some root)
    (capacity : root.index+1≤root.count) (read : Load32 s.heap (elem root 0) w)
    (yes : unit n w=true) :
    Exec (KeygenZintCall.bezoutPart 6) s ⟨s,.returned (some (.int32 1))⟩ := by
  have run := BezoutUnitGuard217.x_source s root n w bound cell binding capacity read
  rw [yes] at run
  rw [BezoutUnitGuard217.shape]
  exact .seqExit _ _ _ _ run (by intro impossible; cases impossible)

end FT1536.Source3.BezoutUnitX217
