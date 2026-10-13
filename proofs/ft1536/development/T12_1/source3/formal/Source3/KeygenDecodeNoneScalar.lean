import Source3.KeygenDecodeNoneBinding
import Source3.KeygenCodecStaticLength
import Source3.C99ArithmeticBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Scalar inverse identities for the exact NONE byte/sign/range expressions.
   These do not assert a complete decoder execution or a memory frame. -/
namespace FT1536.Source3.KeygenDecodeNoneScalar

def high (input : BitVec 16) : BitVec 8 := ((input.signExtend 32) >>> 8).setWidth 8
def low (input : BitVec 16) : BitVec 8 := (input.signExtend 32).setWidth 8

def joined (hi lo : BitVec 8) : BitVec 32 := (hi ++ lo).setWidth 32

def signedWord (word : BitVec 32) : BitVec 32 := word ||| -(word &&& 32768)

def adjusted (hi lo : BitVec 8) : BitVec 32 := signedWord (joined hi lo)+18433

def guardWord (word : BitVec 32) : BitVec 32 := ((9216-word) &&& (word-27650)) >>> 31

def Carrier (input : BitVec 16) : Prop := -9216 ≤ input.toInt ∧ input.toInt ≤ 9216

theorem join_bytes (input : BitVec 16) : high input ++ low input=input := by
  have bits (i : Fin 16) : (high input ++ low input).getLsbD i.val=input.getLsbD i.val := by
    fin_cases i <;> simp only [high,low,BitVec.getLsbD_append,BitVec.getLsbD_setWidth,
      BitVec.getLsbD_ushiftRight,BitVec.getLsbD_signExtend] <;> rfl
  apply BitVec.eq_of_getLsbD_eq
  intro i bound
  exact bits ⟨i,bound⟩

theorem sign_mask (input : BitVec 16) :
    (input.setWidth 32 &&& 32768)=(if input.msb then 32768 else 0) := by
  have bits (i : Fin 32) : (input.setWidth 32 &&& 32768).getLsbD i.val=
      (if input.msb then (32768 : BitVec 32) else 0).getLsbD i.val := by
    cases sign : input.msb <;> fin_cases i <;>
      simp only [BitVec.getLsbD_and,BitVec.getLsbD_setWidth]
    all_goals simp_all [BitVec.msb_eq_getLsbD_last]
  apply BitVec.eq_of_getLsbD_eq
  intro i bound
  exact bits ⟨i,bound⟩

theorem sign_extension (input : BitVec 16) : signedWord (input.setWidth 32)=input.signExtend 32 := by
  unfold signedWord
  rw [sign_mask]
  cases sign : input.msb with
  | false =>
    simp only [Bool.false_eq_true,ite_false]
    change input.setWidth 32 ||| (0#32)=input.signExtend 32
    rw [BitVec.or_zero]
    exact (BitVec.signExtend_eq_setWidth_of_msb_false sign).symm
  | true =>
    simp only [ite_true]
    have bits (i : Fin 32) :
        (input.setWidth 32 ||| -(32768 : BitVec 32)).getLsbD i.val=(input.signExtend 32).getLsbD i.val := by
      fin_cases i <;> simp only [BitVec.getLsbD_or,BitVec.getLsbD_setWidth,BitVec.getLsbD_signExtend]
      all_goals simp_all
      all_goals exact (by simpa [BitVec.msb_eq_getLsbD_last] using sign)
    apply BitVec.eq_of_getLsbD_eq
    intro i bound
    exact bits ⟨i,bound⟩

/-- The encoder's high/low bytes reconstruct exactly the original signed word. -/
theorem signed_roundtrip (input : BitVec 16) :
    signedWord (joined (high input) (low input))=BitVec.ofInt 32 input.toInt := by
  unfold joined
  rw [join_bytes,sign_extension]
  rfl

theorem adjusted_value (input : BitVec 16) :
    adjusted (high input) (low input)=BitVec.ofInt 32 (input.toInt+18433) := by
  unfold adjusted
  rw [signed_roundtrip,BitVec.ofInt_add]
  rfl

theorem negative_msb (n : Int) (lower : -2147483648≤n) (negative : n<0) :
    (BitVec.ofInt 32 n).msb=true := by
  rw [BitVec.msb_eq_toInt,KeygenCodecStaticCountdown.signed_exact n lower (by omega)]
  simp only [negative,decide_true]

/-- Both unsigned subtractions have their sign bit set on the centered
    NONE carrier. The actual bitwise test therefore accepts, including endpoints. -/
theorem carrier_guard (input : BitVec 16) (carrier : Carrier input) :
    guardWord (adjusted (high input) (low input))=1 := by
  rw [adjusted_value]
  have left : (9216 : BitVec 32)-BitVec.ofInt 32 (input.toInt+18433)=
      BitVec.ofInt 32 (9216-(input.toInt+18433)) := (C99ArithmeticBridge.ofInt_sub (w:=32) 9216 (input.toInt+18433)).symm
  have right : BitVec.ofInt 32 (input.toInt+18433)-27650=
      BitVec.ofInt 32 ((input.toInt+18433)-27650) := (C99ArithmeticBridge.ofInt_sub (w:=32) (input.toInt+18433) 27650).symm
  have first := negative_msb (9216-(input.toInt+18433)) (by rcases carrier with ⟨a,b⟩; omega)
    (by rcases carrier with ⟨a,b⟩; omega)
  have second := negative_msb ((input.toInt+18433)-27650) (by rcases carrier with ⟨a,b⟩; omega)
    (by rcases carrier with ⟨a,b⟩; omega)
  have top : (((9216 : BitVec 32)-BitVec.ofInt 32 (input.toInt+18433)) &&&
      (BitVec.ofInt 32 (input.toInt+18433)-27650)).msb=true := by
    rw [left,right,BitVec.msb_and,first,second]
    rfl
  apply BitVec.eq_of_toNat_eq
  unfold guardWord
  rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
  have enough := (BitVec.msb_eq_true_iff_two_mul_ge).mp top
  have bound := (((9216 : BitVec 32)-BitVec.ofInt 32 (input.toInt+18433)) &&&
      (BitVec.ofInt 32 (input.toInt+18433)-27650)).isLt
  change _=1
  omega

/-- After the passed source gate, unsigned w has no wrap and the real
    long subtraction and int16 cast recover the original signed coefficient. -/
theorem carrier_subtract (input : BitVec 16) (carrier : Carrier input) :
    ((adjusted (high input) (low input)).toNat : Int)-18433=input.toInt := by
  rw [adjusted_value,BitVec.toNat_ofInt]
  rcases carrier with ⟨lower,upper⟩
  omega

/-- Functional interpretation of the bound NONE scalar gate/subtraction.
    Whole-body execution and physical byte loads/stores remain separate. -/
def decodePair (hi lo : BitVec 8) : Option (BitVec 16) :=
  let word := adjusted hi lo
  if guardWord word=0 then none else some (BitVec.ofInt 16 ((word.toNat : Int)-18433))

theorem pair_roundtrip (input : BitVec 16) (carrier : Carrier input) :
    decodePair (high input) (low input)=some input := by
  dsimp only [decodePair]
  rw [carrier_guard input carrier,carrier_subtract input carrier]
  simp only [show (1 : BitVec 32)≠0 by decide +kernel,ite_false,BitVec.ofInt_toInt]

/-- The centered carrier restriction is necessary: the literal source
    scalar gate rejects the honest two-byte representation of9217. This
    is a counterexample to unrestricted scalar round-trip, not a codec bug. -/
theorem outside_carrier_rejected : decodePair (high 9217) (low 9217)=none := by decide +kernel

theorem unrestricted_pair_roundtrip_false :
    ¬(∀ input : BitVec 16, decodePair (high input) (low input)=some input) := by
  intro allInputs
  have impossible := allInputs 9217
  rw [outside_carrier_rejected] at impossible
  cases impossible

end FT1536.Source3.KeygenDecodeNoneScalar
