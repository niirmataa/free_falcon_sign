import Source3.ExactLengthLoop217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ExactLengthSource217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenZintCall (Exec)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest ret loop code)

theorem source (s : State) (root : ArrayPointer) (W : Nat → BitVec 32) (n : Nat) (bound : n<2^64)
    (cell : Cell s "xlen".toList n) (binding : s.arrays "x".toList=some root)
    (capacity : root.index+n ≤ root.count) (data : Data s root n W) :
    ∃ out, Exec (KeygenZintCall.calleeBody .exactLen) s
      ⟨out,.returned (some (.uint64 (word (highest W n))))⟩ ∧ out.heap=s.heap := by
  classical
  obtain ⟨⟨mid,flow⟩,scan,heap,status⟩:=ExactLengthLoop217.scan W n bound s root cell binding capacity data
  rw [ExactLengthProgram217.shape]
  by_cases zero : highest W n=0
  · simp only [zero,ite_true] at status
    obtain ⟨flowEq,cell0⟩:=status
    subst flow
    refine ⟨mid,?_,heap⟩
    have tail : Exec (.seq ret ZintNormWord194.wskip) mid ⟨mid,.returned (some (.uint64 (word 0)))⟩ :=
      .seqExit _ _ _ _ (ExactLengthLoop217.ret_run mid 0 cell0) (by intro impossible; cases impossible)
    rw [zero]
    exact .seqNormal _ _ _ _ _ scan tail
  · simp only [zero,ite_false] at status
    subst flow
    exact ⟨mid,.seqExit _ _ _ _ scan (by intro impossible; cases impossible),heap⟩

end FT1536.Source3.ExactLengthSource217
