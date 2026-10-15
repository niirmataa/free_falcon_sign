import Source3.C99ControlCells142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ControlShift142
open C99IntegerReference
open C99NatWord141 (word)

/-- Original unsigned left shift, including its modulo2^64 output. -/
theorem left_word (n count : Nat) (inputBound : n<2^64) (countBound : count<64) :
    ShiftExec .left (.uint64 (word n)) (.uint64 (word count)) (.uint64 (word (n*2^count))) := by
  have raw := ShiftExec.unsignedLeft (.uint64 (word n)) (.uint64 (word count)) count rfl
    (C99NatWord141.integer count (by omega)) countBound
  change ShiftExec .left (.uint64 (word n)) (.uint64 (word count))
    (.uint64 (BitVec.ofInt 64 ((Value.uint64 (word n)).integer * 2^count))) at raw
  rw [C99NatWord141.integer n inputBound] at raw
  have product : (n : Int)*2^count=((n*2^count : Nat) : Int) := by simp only [Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat]
  rw [product, BitVec.ofInt_natCast] at raw
  exact raw

theorem double_word (n : Nat) (bound : n<2^64) :
    ShiftExec .left (.uint64 (word n)) (.int32 1) (.uint64 (word (n*2))) := by
  have raw := ShiftExec.unsignedLeft (.uint64 (word n)) (.int32 1) 1 rfl rfl (by change (1 : Nat)<64; decide)
  change ShiftExec .left (.uint64 (word n)) (.int32 1)
    (.uint64 (BitVec.ofInt 64 ((Value.uint64 (word n)).integer * 2))) at raw
  rw [C99NatWord141.integer n bound] at raw
  have product : (n : Int)*2=((n*2 : Nat) : Int) := by omega
  rw [product, BitVec.ofInt_natCast] at raw
  exact raw

theorem double (program : C99ProcedureReference.Program) (s : C99ArrayReference.State)
    (name : C99ArrayReference.Name) (n : Nat) (bound : n<2^64) (cell : C99LoopScalar141.Cell s name n) :
    C99ProcedureReference.Exec program (.base (.scalar (.update name .shl (.literal .i32 1)))) s
      ⟨FftLocalCells140.put s name (word (n*2)),.normal⟩ :=
  C99LoopAssign142.update program s name .shl (.literal .i32 1) n (word (n*2)) cell
    (.shift .left _ _ _ _ _ (C99LoopScalar141.read s name n cell) (.literal .int32 1) (double_word n bound))

end FT1536.Source3.C99ControlShift142
