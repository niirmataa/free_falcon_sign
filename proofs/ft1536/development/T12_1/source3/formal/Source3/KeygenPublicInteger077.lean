import Source3.KeygenPublicBits077
import Source3.KeygenDecodeStaticOuterCounter
import Source3.KeygenPublicEncodeCertified077
import Source3.KeygenPublicDecodeCertified077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicInteger077
open C99IntegerReference

abbrev i32 (n : Nat) : Value := .int32 (BitVec.ofNat 32 n)
abbrev u64 (n : Nat) : Value := .uint64 (BitVec.ofNat 64 n)

theorem self_i32 (word : BitVec 32) : convert .int32 (Value.int32 word).integer=.int32 word := by
  simp only [convert,Value.integer,BitVec.ofInt_toInt]

theorem plus_i32 (a b : Nat) (bound : a+b<2^31) : ArithmeticExec .plus (i32 a) (i32 b) (i32 (a+b)) := by
  have ai := KeygenCodecNoneCursor.signed_nat32 a (by omega)
  have bi := KeygenCodecNoneCursor.signed_nat32 b (by omega)
  have source := ArithmeticExec.step .plus (i32 a) (i32 b) .int32 rfl (i32 a) (i32 b)
    (self_i32 _).symm (self_i32 _).symm (by
      intro _
      change -(2^(32-1) : Int)≤(i32 a).integer+(i32 b).integer ∧ (i32 a).integer+(i32 b).integer<2^(32-1)
      rw [show (i32 a).integer=(a : Int) from ai,show (i32 b).integer=(b : Int) from bi]
      constructor <;> omega)
  have same : convert .int32 ((i32 a).integer+(i32 b).integer)=i32 (a+b) := by
    rw [show (i32 a).integer=(a : Int) from ai,show (i32 b).integer=(b : Int) from bi]
    change Value.int32 (BitVec.ofInt 32 ((a : Int)+(b : Int)))=_
    rw [←Int.natCast_add,BitVec.ofInt_natCast]
  exact same ▸ source

theorem minus_i32 (a b : Nat) (inside : b≤a) (bound : a<2^31) : ArithmeticExec .minus (i32 a) (i32 b) (i32 (a-b)) := by
  have ai := KeygenCodecNoneCursor.signed_nat32 a bound
  have bi := KeygenCodecNoneCursor.signed_nat32 b (by omega)
  have source := ArithmeticExec.step .minus (i32 a) (i32 b) .int32 rfl (i32 a) (i32 b)
    (self_i32 _).symm (self_i32 _).symm (by
      intro _
      change -(2^(32-1) : Int)≤(i32 a).integer-(i32 b).integer ∧ (i32 a).integer-(i32 b).integer<2^(32-1)
      rw [show (i32 a).integer=(a : Int) from ai,show (i32 b).integer=(b : Int) from bi]
      constructor <;> omega)
  have same : convert .int32 ((i32 a).integer-(i32 b).integer)=i32 (a-b) := by
    rw [show (i32 a).integer=(a : Int) from ai,show (i32 b).integer=(b : Int) from bi]
    change Value.int32 (BitVec.ofInt 32 ((a : Int)-(b : Int)))=_
    rw [←Int.natCast_sub inside,BitVec.ofInt_natCast]
  exact same ▸ source

theorem compare_i32 (op : Comparison) (a b : Nat) (left : a<2^31) (right : b<2^31) :
    CompareExec op (i32 a) (i32 b) (C99ScalarReference.boolean (compare op (a : Int) (b : Int))) := by
  have source := CompareExec.step op (i32 a) (i32 b) .int32 rfl (i32 a) (i32 b) (self_i32 _).symm (self_i32 _).symm
  rw [show (i32 a).integer=(a : Int) from KeygenCodecNoneCursor.signed_nat32 a left,
    show (i32 b).integer=(b : Int) from KeygenCodecNoneCursor.signed_nat32 b right] at source
  exact source

theorem decrement64 (word : BitVec 64) :
    ArithmeticExec .plus (.uint64 word) (.int32 (BitVec.ofInt 32 (-1))) (.uint64 (word-1)) := by
  have source := ArithmeticExec.step .plus (.uint64 word) (.int32 (BitVec.ofInt 32 (-1)))
    .uint64 rfl (.uint64 word) (.uint64 (BitVec.ofInt 64 (-1))) (KeygenDecodeStaticOuterCounter.self64 _).symm rfl
    (by intro impossible; cases impossible)
  have same : convert .uint64 ((Value.uint64 word).integer+(Value.uint64 (BitVec.ofInt 64 (-1))).integer)=.uint64 (word-1) := by
    simp only [convert,Value.integer,BitVec.ofInt_add,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
    change Value.uint64 (word+(-1))=Value.uint64 (word-1)
    rw [BitVec.sub_eq_add_neg]
  exact same ▸ source

end FT1536.Source3.KeygenPublicInteger077
