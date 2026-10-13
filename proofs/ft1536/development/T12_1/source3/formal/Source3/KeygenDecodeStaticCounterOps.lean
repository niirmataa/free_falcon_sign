import Source3.KeygenDecodeStaticWordOps
import Source3.KeygenDecodeStaticReady

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticCounterOps
open C99IntegerReference
open KeygenDecodeStaticWordOps KeygenDecodeWordOps

theorem plus_nat32 (n d : Nat) (small : d<2^31) :
    ArithmeticExec .plus (.uint32 (BitVec.ofNat 32 n)) (.int32 (BitVec.ofNat 32 d))
      (.uint32 (BitVec.ofNat 32 (n+d))) := by
  simpa only [BitVec.ofNat_add] using plus_int32 (BitVec.ofNat 32 n) d small

theorem minus_nat32 (n d : Nat) (small : d<2^31) (before : d≤n) :
    ArithmeticExec .minus (.uint32 (BitVec.ofNat 32 n)) (.int32 (BitVec.ofNat 32 d))
      (.uint32 (BitVec.ofNat 32 (n-d))) := by
  rw [←BitVec.ofNat_sub_ofNat_of_le n d (by omega) before]
  exact minus_int32 _ d small

theorem compare32 (op : Comparison) (m n : Nat) (left : m<2^32) (right : n<2^32) :
    CompareExec op (.uint32 (BitVec.ofNat 32 m)) (.uint32 (BitVec.ofNat 32 n))
      (C99ScalarReference.boolean (compare op (m : Int) (n : Int))) := by
  have source := CompareExec.step op (.uint32 (BitVec.ofNat 32 m)) (.uint32 (BitVec.ofNat 32 n))
    .uint32 rfl (.uint32 (BitVec.ofNat 32 m)) (.uint32 (BitVec.ofNat 32 n))
      (self32 _).symm (self32 _).symm
  rw [unsigned_nat32 m left,unsigned_nat32 n right] at source
  exact source

theorem boolean_truth (b : Bool) : KeygenDecodeValues.truth (.integer (C99ScalarReference.boolean b))=b := by
  cases b <;> decide +kernel

theorem decrement32 (word : BitVec 32) :
    ArithmeticExec .plus (.uint32 word) (.int32 (BitVec.ofInt 32 (-1))) (.uint32 (word-1)) := by
  have source := ArithmeticExec.step .plus (.uint32 word) (.int32 (BitVec.ofInt 32 (-1)))
    .uint32 rfl (.uint32 word) (.uint32 (BitVec.ofInt 32 (-1))) (self32 word).symm rfl (by intro h; cases h)
  have same : convert .uint32 ((Value.uint32 word).integer+(Value.uint32 (BitVec.ofInt 32 (-1))).integer)=.uint32 (word-1) := by
    simp only [convert,Value.integer,BitVec.ofInt_add,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
    change Value.uint32 (word+(-1))=Value.uint32 (word-1)
    rw [BitVec.sub_eq_add_neg]
  exact same ▸ source

end FT1536.Source3.KeygenDecodeStaticCounterOps
