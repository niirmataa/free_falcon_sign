import Source3.KeygenDecodeStaticBitRead

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticBitSlice
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer KeygenCodecStaticSuffix

theorem shifted_low (n p : Nat) (db : BitVec 32) : low (db >>> p) n=low db (n+p)/2^p := by
  unfold low
  rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,
    show (2 : Nat)^(n+p)=2^p*2^n by rw [Nat.add_comm n p,Nat.pow_add]]
  exact (Nat.mod_mul_right_div_self db.toNat (2^p) (2^n)).symm

theorem head_bits (head tail : List Bool) (db : BitVec 32)
    (held : buffer (head.length+tail.length) db=head++tail) :
    buffer head.length (db >>> tail.length)=head := by
  apply value_injective
  · exact buffer_length _ _
  · rw [buffer_value,shifted_low]
    have values := congrArg value held
    rw [buffer_value] at values
    rw [values,head_value]

theorem tail_bits (head tail : List Bool) (db : BitVec 32)
    (held : buffer (head.length+tail.length) db=head++tail) : buffer tail.length db=tail := by
  apply value_injective
  · exact buffer_length _ _
  · rw [buffer_value]
    have values := congrArg value held
    rw [buffer_value] at values
    have residue : low db (head.length+tail.length)%2^tail.length=low db tail.length := by
      unfold low
      exact Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 (by omega : tail.length≤head.length+tail.length))
    rw [←residue,values,suffix]

/-- Masking the low k bits uses the exact source bitwise operation. -/
theorem mask (db : BitVec 32) (k : Nat) (bound : k<32) :
    (db &&& BitVec.ofNat 32 (2^k-1)).toNat=low db k := by
  rw [BitVec.toNat_and,BitVec.toNat_ofNat]
  have small : 2^k-1<2^32 := by
    have order : (2 : Nat)^k≤2^32 := Nat.le_of_dvd (Nat.two_pow_pos _) (Nat.pow_dvd_pow 2 (by omega))
    have positive:=Nat.two_pow_pos k
    omega
  rw [Nat.mod_eq_of_lt small]
  exact Nat.and_two_pow_sub_one_eq_mod _ _

end FT1536.Source3.KeygenDecodeStaticBitSlice
