import Source3.KeygenDecodeWordOps
import Source3.KeygenDecodeNoneRead

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticWordOps
open C99IntegerReference
open KeygenDecodeWordOps

theorem unsigned_nat32 (n : Nat) (bound : n<2^32) : (Value.uint32 (BitVec.ofNat 32 n)).integer=(n : Int) := by
  change ((BitVec.ofNat 32 n).toNat : Int)=(n : Int)
  rw [BitVec.toNat_ofNat,Nat.mod_eq_of_lt bound]

theorem convert_int32 (n : Nat) (bound : n<2^31) :
    convert .uint32 (Value.int32 (BitVec.ofNat 32 n)).integer=.uint32 (BitVec.ofNat 32 n) := by
  rw [Value.integer,KeygenCodecNoneCursor.signed_nat32 n bound]
  rfl

theorem plus_int32 (word : BitVec 32) (n : Nat) (bound : n<2^31) :
    ArithmeticExec .plus (.uint32 word) (.int32 (BitVec.ofNat 32 n)) (.uint32 (word+BitVec.ofNat 32 n)) := by
  have source := ArithmeticExec.step .plus (.uint32 word) (.int32 (BitVec.ofNat 32 n)) .uint32 rfl
    (.uint32 word) (.uint32 (BitVec.ofNat 32 n)) (self32 word).symm (convert_int32 n bound).symm (by intro h; cases h)
  have same : convert .uint32 ((Value.uint32 word).integer+(Value.uint32 (BitVec.ofNat 32 n)).integer)=.uint32 (word+BitVec.ofNat 32 n) := by
    simp only [convert,Value.integer,BitVec.ofInt_add,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem minus_int32 (word : BitVec 32) (n : Nat) (bound : n<2^31) :
    ArithmeticExec .minus (.uint32 word) (.int32 (BitVec.ofNat 32 n)) (.uint32 (word-BitVec.ofNat 32 n)) := by
  have source := ArithmeticExec.step .minus (.uint32 word) (.int32 (BitVec.ofNat 32 n)) .uint32 rfl
    (.uint32 word) (.uint32 (BitVec.ofNat 32 n)) (self32 word).symm (convert_int32 n bound).symm (by intro h; cases h)
  have same : convert .uint32 ((Value.uint32 word).integer-(Value.uint32 (BitVec.ofNat 32 n)).integer)=.uint32 (word-BitVec.ofNat 32 n) := by
    simp only [convert,Value.integer,C99ArithmeticBridge.ofInt_sub,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem and_int32 (word : BitVec 32) (n : Nat) (bound : n<2^31) :
    BitwiseExec .and (.uint32 word) (.int32 (BitVec.ofNat 32 n)) (.uint32 (word &&& BitVec.ofNat 32 n)) := by
  have source := BitwiseExec.step .and (.uint32 word) (.int32 (BitVec.ofNat 32 n)) .uint32 rfl
    (.uint32 word) (.uint32 (BitVec.ofNat 32 n)) (self32 word).symm (convert_int32 n bound).symm
  have same : convert .uint32 (bitResult .and (Value.uint32 word).bits (Value.uint32 (BitVec.ofNat 32 n)).bits)=.uint32 (word &&& BitVec.ofNat 32 n) := by
    change Value.uint32 (BitVec.ofNat 32 (word &&& BitVec.ofNat 32 n).toNat)=_
    rw [BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem right_uint32 (a : BitVec 32) (n : Nat) (bound : n<32) :
    ShiftExec .right (.uint32 a) (.uint32 (BitVec.ofNat 32 n)) (.uint32 (a >>> n)) := by
  have count : (Value.uint32 (BitVec.ofNat 32 n)).integer=(n : Int) :=
    unsigned_nat32 n (by omega)
  have source := ShiftExec.right (.uint32 a) (.uint32 (BitVec.ofNat 32 n)) n count bound
  have same : convert .uint32 ((Value.uint32 a).integer/2^n)=.uint32 (a >>> n) := by
    change Value.uint32 (BitVec.ofInt 32 ((a.toNat : Int)/2^n))=_
    rw [show (a.toNat : Int)/2^n=((a.toNat/2^n : Nat) : Int) by simp only [Int.natCast_ediv,Int.natCast_pow]; rfl,BitVec.ofInt_natCast]
    congr 1
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_ofNat,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
    exact Nat.mod_eq_of_lt (lt_of_le_of_lt (Nat.div_le_self _ _) a.isLt)
  exact same ▸ source

theorem left_uint32 (a : BitVec 32) (n : Nat) (bound : n<32) :
    ShiftExec .left (.uint32 a) (.uint32 (BitVec.ofNat 32 n)) (.uint32 (a <<< n)) := by
  have count : (Value.uint32 (BitVec.ofNat 32 n)).integer=(n : Int) :=
    unsigned_nat32 n (by omega)
  have source := ShiftExec.unsignedLeft (.uint32 a) (.uint32 (BitVec.ofNat 32 n)) n rfl count bound
  have same : convert .uint32 ((Value.uint32 a).integer*2^n)=.uint32 (a <<< n) := by
    change Value.uint32 (BitVec.ofInt 32 ((a.toNat : Int)*2^n))=_
    rw [show (a.toNat : Int)*2^n=((a.toNat*2^n : Nat) : Int) by simp only [Int.natCast_mul,Int.natCast_pow]; rfl,BitVec.ofInt_natCast]
    congr 1
    change BitVec.ofNat 32 (a.toNat*2^n)=BitVec.ofNat 32 (a.toNat <<< n)
    rw [Nat.shiftLeft_eq]
  exact same ▸ source

end FT1536.Source3.KeygenDecodeStaticWordOps
