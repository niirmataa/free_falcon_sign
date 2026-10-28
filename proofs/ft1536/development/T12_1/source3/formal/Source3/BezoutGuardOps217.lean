import Source3.SelectedBezoutLengths217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutGuardOps217
open C99IntegerReference (Value CompareExec BitwiseExec)
open C99NatWord141 (word)

def andWord (x y : BitVec 32) : BitVec 32 := BitVec.ofNat 32 (x.toNat &&& y.toNat)

theorem band (x y : BitVec 32) :
    C99OperatorBridge.Binary .band (.uint32 x) (.uint32 y) (.uint32 (andWord x y)) := by
  have raw := BitwiseExec.step .and (.uint32 x) (.uint32 y) .uint32 rfl (.uint32 x) (.uint32 y)
    (C99CountedWords.convert_self (.uint32 x)).symm (C99CountedWords.convert_self (.uint32 y)).symm
  simpa [C99OperatorBridge.Binary,andWord,C99IntegerReference.bitResult,C99IntegerReference.Value.bits,
    C99IntegerReference.convert,BitVec.ofInt_natCast] using raw

theorem eq_zero64 (n : Nat) (bound : n<2^64) :
    CompareExec .eq (.uint64 (word n)) (.int32 0) (C99ScalarReference.boolean (decide (n=0))) := by
  have raw := CompareExec.step .eq (.uint64 (word n)) (.int32 0) .uint64 rfl (.uint64 (word n)) (.uint64 0)
    (C99CountedWords.convert_self (.uint64 (word n))).symm rfl
  change CompareExec .eq (.uint64 (word n)) (.int32 0)
    (C99ScalarReference.boolean (decide ((Value.uint64 (word n)).integer=0))) at raw
  rw [C99NatWord141.integer n bound] at raw
  have eq : ((n : Int)=0) ↔ n=0 := by omega
  simpa only [eq] using raw

theorem eq_zero32 (x : BitVec 32) :
    CompareExec .eq (.uint32 x) (.int32 0) (C99ScalarReference.boolean (decide ((Value.uint32 x).integer=0))) := by
  have raw := CompareExec.step .eq (.uint32 x) (.int32 0) .uint32 rfl (.uint32 x) (.uint32 0)
    (C99CountedWords.convert_self (.uint32 x)).symm rfl
  change CompareExec .eq (.uint32 x) (.int32 0)
    (C99ScalarReference.boolean (decide ((Value.uint32 x).integer=0))) at raw
  exact raw

end FT1536.Source3.BezoutGuardOps217
