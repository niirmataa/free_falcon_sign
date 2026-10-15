import Source3.C99LoopScalar141
import Source3.C99WordBuffer140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99PointerNat141
open C99ArrayReference (State Name Pointer scalar)
open C99MemoryReference (ArrayPointer)

theorem source (s : State) (name : Name) (expr : CLogic.Expr) (base : ArrayPointer) (i : Nat)
    (bound : i<2^64) (within : base.index+i≤base.count)
    (binding : s.arrays name=some base)
    (evaluated : scalar s expr (.uint64 (C99NatWord141.word i))) :
    Pointer s name expr {base with index := base.index+i} := by
  have integer := C99NatWord141.integer i bound
  have nonnegative : (0 : Int)≤(C99IntegerReference.Value.uint64 (C99NatWord141.word i)).integer := by
    rw [integer]
    omega
  have natural : (C99IntegerReference.Value.uint64 (C99NatWord141.word i)).integer.toNat=i := by
    rw [integer]
    rfl
  exact .add name expr base _ (.uint64 (C99NatWord141.word i)) binding evaluated nonnegative
    (by rw [natural]; exact .within base i within)

end FT1536.Source3.C99PointerNat141
