import Source3.ZintModSignedWord194
import Source3.SecondStepInterleave204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtWordOps205
open C99IntegerReference

def widen (w : BitVec 32) : BitVec 64 := BitVec.ofNat 64 w.toNat
def narrow (w : BitVec 64) : BitVec 32 := BitVec.ofNat 32 w.toNat

theorem self64 (w : BitVec 64) : convert .uint64 (Value.uint64 w).integer=.uint64 w :=
  C99CountedWords.convert_self (.uint64 w)

theorem cast_widen (w : BitVec 32) : convert .uint64 (Value.uint32 w).integer=.uint64 (widen w) := by
  change Value.uint64 (BitVec.ofInt 64 (w.toNat : Int))=_
  rw [BitVec.ofInt_natCast]
  rfl

theorem cast_narrow (w : BitVec 64) : convert .uint32 (Value.uint64 w).integer=.uint32 (narrow w) := by
  change Value.uint32 (BitVec.ofInt 32 (w.toNat : Int))=_
  rw [BitVec.ofInt_natCast]
  rfl

theorem add64 (a b : BitVec 64) : ArithmeticExec .plus (.uint64 a) (.uint64 b) (.uint64 (a+b)) := by
  have source:=ArithmeticExec.step .plus (.uint64 a) (.uint64 b) .uint64 rfl
    (.uint64 a) (.uint64 b) (self64 a).symm (self64 b).symm (by intro h; cases h)
  have same : convert .uint64 ((Value.uint64 a).integer+(Value.uint64 b).integer)=.uint64 (a+b) := by
    simp only [convert,Value.integer,BitVec.ofInt_add,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem mul64 (a b : BitVec 64) : ArithmeticExec .times (.uint64 a) (.uint64 b) (.uint64 (a*b)) := by
  have source:=ArithmeticExec.step .times (.uint64 a) (.uint64 b) .uint64 rfl
    (.uint64 a) (.uint64 b) (self64 a).symm (self64 b).symm (by intro h; cases h)
  have same : convert .uint64 ((Value.uint64 a).integer*(Value.uint64 b).integer)=.uint64 (a*b) := by
    simp only [convert,Value.integer,BitVec.ofInt_mul,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem add64_32 (a : BitVec 64) (b : BitVec 32) :
    ArithmeticExec .plus (.uint64 a) (.uint32 b) (.uint64 (a+widen b)) := by
  have source:=ArithmeticExec.step .plus (.uint64 a) (.uint32 b) .uint64 rfl
    (.uint64 a) (.uint64 (widen b)) (self64 a).symm (cast_widen b).symm (by intro h; cases h)
  have same : convert .uint64 ((Value.uint64 a).integer+(Value.uint64 (widen b)).integer)=.uint64 (a+widen b) := by
    simp only [convert,Value.integer,BitVec.ofInt_add,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem right64 (a : BitVec 64) (n : Nat) (bound : n<64) :
    ShiftExec .right (.uint64 a) (.int32 (BitVec.ofNat 32 n)) (.uint64 (a >>> n)) := by
  have count : (Value.int32 (BitVec.ofNat 32 n)).integer=(n : Int) :=
    KeygenCodecNoneCursor.signed_nat32 n (by omega)
  have source:=ShiftExec.right (.uint64 a) (.int32 (BitVec.ofNat 32 n)) n count bound
  have same : convert .uint64 ((Value.uint64 a).integer/2^n)=.uint64 (a >>> n) := by
    change Value.uint64 (BitVec.ofInt 64 ((a.toNat : Int)/2^n))=_
    rw [show (a.toNat : Int)/2^n=((a.toNat/2^n : Nat) : Int) by simp only [Int.natCast_ediv,Int.natCast_pow]; rfl,BitVec.ofInt_natCast]
    congr 1
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_ofNat,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
    exact Nat.mod_eq_of_lt (lt_of_le_of_lt (Nat.div_le_self _ _) a.isLt)
  exact same ▸ source

theorem mask31 (a : BitVec 32) : BitwiseExec .and (.uint32 a) (.int32 2147483647) (.uint32 (a &&& 2147483647)) := by
  have source:=BitwiseExec.step .and (.uint32 a) (.int32 2147483647) .uint32 rfl
    (.uint32 a) (.uint32 2147483647) (KeygenDecodeWordOps.self32 a).symm rfl
  have same : convert .uint32 (bitResult .and (Value.uint32 a).bits (Value.uint32 2147483647).bits)=.uint32 (a &&& 2147483647) := by
    change Value.uint32 (BitVec.ofNat 32 (a &&& 2147483647).toNat)=_
    rw [BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

end FT1536.Source3.CrtWordOps205
