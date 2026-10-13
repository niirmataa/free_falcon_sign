import Source3.KeygenCodecStaticBitBuffer

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Decoder db refill and extraction interpreted ONLY through the pending
   suffix. Neither a whole-word bound nor an aligned coefficient is assumed. -/
namespace FT1536.Source3.KeygenDecodeStaticBitRead
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer KeygenCodecStaticSuffix

theorem low_refill (p : Nat) (db : BitVec 32) (byte : BitVec 8) (width : p+8≤32) :
    low ((db <<< 8)+byte.setWidth 32) (p+8)=low db p*256+byte.toNat := by
  have shifted := low_shl db p 8 width
  have lowBound := low_bound db p
  have byteBound := byte.isLt
  have total : low db p*256+byte.toNat<2^(p+8) := by
    rw [Nat.pow_add]
    change low db p*256+byte.toNat<2^p*256
    omega
  have byteWidth : byte.toNat<2^(p+8) := by
    rw [Nat.pow_add]
    have positive:=Nat.two_pow_pos p
    change byte.toNat<2^p*256
    omega
  unfold low
  rw [BitVec.toNat_add,Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 width),Nat.add_mod]
  change (low (db <<< 8) (p+8)+(byte.setWidth 32).toNat%2^(p+8))%2^(p+8)=_
  rw [BitVec.toNat_setWidth,Nat.mod_eq_of_lt (show byte.toNat<2^32 by omega),shifted,
    Nat.mod_eq_of_lt byteWidth]
  change (low db p*256+byte.toNat)%2^(p+8)=_
  exact Nat.mod_eq_of_lt total

theorem refill_bits (p : Nat) (db : BitVec 32) (byte : BitVec 8) (width : p+8≤32) :
    buffer (p+8) ((db <<< 8)+byte.setWidth 32)=buffer p db++digits 8 byte.toNat := by
  apply value_injective
  · simp only [buffer_length,List.length_append,digits_length]
  · rw [buffer_value,value_append,digits_length,digits_value,buffer_value,
      Nat.mod_eq_of_lt byte.isLt,low_refill p db byte width]
    rfl

/-- An extracted bit is the high bit of the current suffix. -/
theorem high_bit (tail : List Bool) (bit : Bool) (db : BitVec 32)
    (held : buffer (tail.length+1) db=bit::tail) :
    (db >>> tail.length).toNat%2=bit.toNat := by
  have values := congrArg value held
  rw [buffer_value,value] at values
  rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
  have split := Nat.mod_mul_right_div_self db.toNat (2^tail.length) 2
  have encoded : low db (tail.length+1)/2^tail.length=bit.toNat := by
    rw [values,Nat.add_comm,Nat.add_mul_div_right _ _ (Nat.two_pow_pos _),
      Nat.div_eq_of_lt (value_bound tail),Nat.zero_add]
  rw [low,show (2 : Nat)^(tail.length+1)=2^tail.length*2 by rw [pow_succ]] at encoded
  rw [split] at encoded
  exact encoded

/-- Consuming a bit merely shortens the interpretation; old high bits
    remain in db and the low suffix is exactly the unconsumed tail. -/
theorem consume_bit (tail : List Bool) (bit : Bool) (db : BitVec 32)
    (held : buffer (tail.length+1) db=bit::tail) : buffer tail.length db=tail := by
  apply value_injective
  · exact buffer_length _ _
  · rw [buffer_value]
    have values := congrArg value held
    rw [buffer_value,value] at values
    have lower : low db (tail.length+1)%2^tail.length=low db tail.length := by
      unfold low
      exact Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 (by omega : tail.length≤tail.length+1))
    rw [←lower,values,Nat.add_mod,Nat.mul_mod_left,Nat.zero_add,Nat.mod_mod]
    exact Nat.mod_eq_of_lt (value_bound tail)

end FT1536.Source3.KeygenDecodeStaticBitRead
