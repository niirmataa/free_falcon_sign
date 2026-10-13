import Source3.KeygenDecodeCalculation
import Source3.KeygenCodecNoneWire

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Reference arithmetic rules used by the actual NONE decoder expressions.
   Unsigned wrap is retained; no decoded output is built into these rules. -/
namespace FT1536.Source3.KeygenDecodeWordOps
open KeygenDecodeValues (castInteger)
open C99IntegerReference

theorem self32 (word : BitVec 32) : convert .uint32 (Value.uint32 word).integer=.uint32 word :=
  KeygenCodecNoneWord.convert32 word

theorem add32 (a b : BitVec 32) : ArithmeticExec .plus (.uint32 a) (.uint32 b) (.uint32 (a+b)) := by
  have source := ArithmeticExec.step .plus (.uint32 a) (.uint32 b) .uint32 rfl
    (.uint32 a) (.uint32 b) (self32 a).symm (self32 b).symm (by intro h; cases h)
  have same : convert .uint32 ((Value.uint32 a).integer+(Value.uint32 b).integer)=.uint32 (a+b) := by
    simp only [convert,Value.integer,BitVec.ofInt_add,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem sub32 (a b : BitVec 32) : ArithmeticExec .minus (.uint32 a) (.uint32 b) (.uint32 (a-b)) := by
  have source := ArithmeticExec.step .minus (.uint32 a) (.uint32 b) .uint32 rfl
    (.uint32 a) (.uint32 b) (self32 a).symm (self32 b).symm (by intro h; cases h)
  have same : convert .uint32 ((Value.uint32 a).integer-(Value.uint32 b).integer)=.uint32 (a-b) := by
    simp only [convert,Value.integer,C99ArithmeticBridge.ofInt_sub,BitVec.ofInt_natCast,
      BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem neg32 (a : BitVec 32) : NegExec (.uint32 a) (.uint32 (-a)) := by
  have source := NegExec.step (.uint32 a) (by intro h; cases h)
  have same : convert .uint32 (-(Value.uint32 a).integer)=.uint32 (-a) := by
    simp only [convert,Value.integer,BitVec.ofInt_neg,BitVec.ofInt_natCast,
      BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem and32 (a b : BitVec 32) : BitwiseExec .and (.uint32 a) (.uint32 b) (.uint32 (a &&& b)) := by
  have source := BitwiseExec.step .and (.uint32 a) (.uint32 b) .uint32 rfl
    (.uint32 a) (.uint32 b) (self32 a).symm (self32 b).symm
  have same : convert .uint32 (bitResult .and (Value.uint32 a).bits (Value.uint32 b).bits)=.uint32 (a &&& b) := by
    change Value.uint32 (BitVec.ofNat 32 (a &&& b).toNat)=_
    rw [BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem or32 (a b : BitVec 32) : BitwiseExec .or (.uint32 a) (.uint32 b) (.uint32 (a ||| b)) := by
  have source := BitwiseExec.step .or (.uint32 a) (.uint32 b) .uint32 rfl
    (.uint32 a) (.uint32 b) (self32 a).symm (self32 b).symm
  have same : convert .uint32 (bitResult .or (Value.uint32 a).bits (Value.uint32 b).bits)=.uint32 (a ||| b) :=
    KeygenCodecStaticAppend.or_word a b
  exact same ▸ source

theorem mask32 (a : BitVec 32) : BitwiseExec .and (.uint32 a) (.int32 32768) (.uint32 (a &&& 32768)) := by
  have source := BitwiseExec.step .and (.uint32 a) (.int32 32768) .uint32 rfl
    (.uint32 a) (.uint32 32768) (self32 a).symm rfl
  have same : convert .uint32 (bitResult .and (Value.uint32 a).bits (Value.uint32 32768).bits)=.uint32 (a &&& 32768) := by
    change Value.uint32 (BitVec.ofNat 32 (a &&& 32768).toNat)=_
    rw [BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem left32 (a : BitVec 32) (n : Nat) (bound : n<32) :
    ShiftExec .left (.uint32 a) (.int32 (BitVec.ofNat 32 n)) (.uint32 (a <<< n)) := by
  have count : (Value.int32 (BitVec.ofNat 32 n)).integer=(n : Int) :=
    KeygenCodecNoneCursor.signed_nat32 n (by omega)
  have source := ShiftExec.unsignedLeft (.uint32 a) (.int32 (BitVec.ofNat 32 n)) n rfl count bound
  have same : convert .uint32 ((Value.uint32 a).integer*2^n)=.uint32 (a <<< n) := by
    change Value.uint32 (BitVec.ofInt 32 ((a.toNat : Int)*2^n))=_
    rw [show (a.toNat : Int)*2^n=((a.toNat*2^n : Nat) : Int) by simp only [Int.natCast_mul,Int.natCast_pow]; rfl,BitVec.ofInt_natCast]
    congr 1
    change BitVec.ofNat 32 (a.toNat*2^n)=BitVec.ofNat 32 (a.toNat <<< n)
    rw [Nat.shiftLeft_eq]
  exact same ▸ source

theorem right32 (a : BitVec 32) (n : Nat) (bound : n<32) :
    ShiftExec .right (.uint32 a) (.int32 (BitVec.ofNat 32 n)) (.uint32 (a >>> n)) := by
  have count : (Value.int32 (BitVec.ofNat 32 n)).integer=(n : Int) :=
    KeygenCodecNoneCursor.signed_nat32 n (by omega)
  have source := ShiftExec.right (.uint32 a) (.int32 (BitVec.ofNat 32 n)) n count bound
  have same : convert .uint32 ((Value.uint32 a).integer/2^n)=.uint32 (a >>> n) := by
    change Value.uint32 (BitVec.ofInt 32 ((a.toNat : Int)/2^n))=_
    rw [show (a.toNat : Int)/2^n=((a.toNat/2^n : Nat) : Int) by simp only [Int.natCast_ediv,Int.natCast_pow]; rfl,BitVec.ofInt_natCast]
    congr 1
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_ofNat,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
    exact Nat.mod_eq_of_lt (lt_of_le_of_lt (Nat.div_le_self _ _) a.isLt)
  exact same ▸ source

theorem joined_bytes (hi lo : BitVec 8) :
    ((hi.setWidth 32) <<< 8) ||| lo.setWidth 32=KeygenDecodeNoneScalar.joined hi lo := by
  have bits (i : Fin 32) : (((hi.setWidth 32) <<< 8) ||| lo.setWidth 32).getLsbD i.val=
      (KeygenDecodeNoneScalar.joined hi lo).getLsbD i.val := by
    fin_cases i <;> simp only [KeygenDecodeNoneScalar.joined,BitVec.getLsbD_or,
      BitVec.getLsbD_setWidth,BitVec.getLsbD_shiftLeft,BitVec.getLsbD_append]
    all_goals simp
  apply BitVec.eq_of_getLsbD_eq
  intro i bound
  exact bits ⟨i,bound⟩

theorem byte_cast32 (word : BitVec 8) :
    castInteger .u32 (.int32 (BitVec.ofNat 32 word.toNat))=some (.uint32 (word.setWidth 32)) := by
  change some (Value.uint32 (BitVec.ofInt 32 (BitVec.ofNat 32 word.toNat).toInt))=_
  rw [KeygenCodecNoneCursor.signed_nat32 word.toNat (by have bound:=word.isLt; omega),
    BitVec.ofInt_natCast,BitVec.ofNat_toNat]

end FT1536.Source3.KeygenDecodeWordOps
