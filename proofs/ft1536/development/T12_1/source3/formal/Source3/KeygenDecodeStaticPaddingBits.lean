import Source3.KeygenDecodeStaticCoefficient

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Derive the last unread-byte exhaustion and zero-padding mask from the
   actual source-derived final bit stream, not from decoder success. -/
namespace FT1536.Source3.KeygenDecodeStaticPaddingBits
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer KeygenDecodeStaticWire

theorem zeros_value (n : Nat) : value (List.replicate n false)=0 := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [List.replicate_succ,value,Bool.toNat_false,Nat.zero_mul,Nat.zero_add,ih]

theorem exhausted (p padding : Nat) (db : BitVec 32) (bytes : List (BitVec 8))
    (small : padding<8) (held : remaining p db bytes=List.replicate padding false) :
    bytes=[] ∧ p=padding ∧ KeygenCodecStaticSuffix.low db p=0 := by
  have lengths := congrArg List.length held
  simp only [remaining,List.length_append,buffer_length,bytes_length,List.length_replicate] at lengths
  have none : bytes.length=0 := by omega
  have empty := List.length_eq_zero_iff.mp none
  have size : p=padding := by omega
  subst bytes
  simp only [remaining,bytesBits,List.flatMap_nil,List.append_nil] at held
  have values := congrArg value held
  rw [buffer_value,zeros_value] at values
  exact ⟨rfl,size,values⟩

def mask (p : Nat) : BitVec 32 := ((1 : BitVec 32) <<< p)-1

theorem mask_word (p : Nat) : mask p=BitVec.ofNat 32 (2^p-1) := by
  have shifted : ((1 : BitVec 32) <<< p)=BitVec.ofNat 32 (2^p) := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_shiftLeft,BitVec.toNat_ofNat]
    change ((1 : Nat) <<< p)%2^32=2^p%2^32
    rw [Nat.shiftLeft_eq,Nat.one_mul]
  unfold mask
  rw [shifted,show (1 : BitVec 32)=BitVec.ofNat 32 1 by decide +kernel,
    BitVec.ofNat_sub_ofNat_of_le (2^p) 1 (by decide +kernel) (by have positive:=Nat.two_pow_pos p; omega)]

theorem masked_zero (p : Nat) (db : BitVec 32) (small : p<8)
    (zero : KeygenCodecStaticSuffix.low db p=0) : db &&& mask p=0 := by
  apply BitVec.eq_of_toNat_eq
  rw [mask_word,KeygenDecodeStaticBitSlice.mask db p (by omega),zero]
  rfl

end FT1536.Source3.KeygenDecodeStaticPaddingBits
