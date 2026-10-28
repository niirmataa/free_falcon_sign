import Source3.ExactLengthProgram217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ExactLengthOps217
open C99IntegerReference (Value ArithmeticExec CompareExec)
open C99NatWord141 (word)
open ExactLengthProgram217 (nonzero)

theorem sub_one (n : Nat) (bound : n<2^64) (positive : 0<n) :
    ArithmeticExec .minus (.uint64 (word n)) (.int32 1) (.uint64 (word (n-1))) := by
  have raw := ArithmeticExec.step .minus (.uint64 (word n)) (.int32 1) .uint64 rfl
    (.uint64 (word n)) (.uint64 1)
    (C99CountedWords.convert_self (.uint64 (word n))).symm rfl (by intro impossible; cases impossible)
  change ArithmeticExec .minus (.uint64 (word n)) (.int32 1)
    (.uint64 (BitVec.ofInt 64 ((Value.uint64 (word n)).integer-1))) at raw
  rw [C99NatWord141.integer n bound] at raw
  have eq : (n : Int)-1=((n-1 : Nat) : Int) := by omega
  rw [eq,BitVec.ofInt_natCast] at raw
  exact raw

theorem positive (n : Nat) (bound : n<2^64) :
    CompareExec .gt (.uint64 (word n)) (.int32 0) (C99ScalarReference.boolean (decide (0<n))) := by
  have raw := CompareExec.step .gt (.uint64 (word n)) (.int32 0) .uint64 rfl
    (.uint64 (word n)) (.uint64 0) (C99CountedWords.convert_self (.uint64 (word n))).symm rfl
  change CompareExec .gt (.uint64 (word n)) (.int32 0)
    (C99ScalarReference.boolean (decide ((0 : Int)<(Value.uint64 (word n)).integer))) at raw
  rw [C99NatWord141.integer n bound] at raw
  have eq : ((0 : Int)<(n : Int)) ↔ 0<n := by omega
  simpa only [eq] using raw

theorem word_nonzero (w : BitVec 32) :
    CompareExec .ne (.uint32 w) (.int32 0) (C99ScalarReference.boolean (decide (nonzero w))) := by
  classical
  have raw := CompareExec.step .ne (.uint32 w) (.int32 0) .uint32 rfl
    (.uint32 w) (.uint32 0) (C99CountedWords.convert_self (.uint32 w)).symm rfl
  change CompareExec .ne (.uint32 w) (.int32 0)
    (C99ScalarReference.boolean (decide ((Value.uint32 w).integer≠0))) at raw
  exact raw

end FT1536.Source3.ExactLengthOps217
