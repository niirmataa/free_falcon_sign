import Source3.KeygenPublicStream077
import Source3.KeygenDecodeStaticPrefixBits

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeBits077
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer KeygenPublicBits077 KeygenDecodeStaticWire

def appended (acc : BitVec 32) (byte : BitVec 8) : BitVec 32 := (acc <<< 8) ||| byte.setWidth 32

theorem bits_length (inputs : List (BitVec 16)) : (bits inputs).length=15*inputs.length := by
  induction inputs with
  | nil => rfl
  | cons input rest ih =>
    simp only [bits,List.flatMap_cons,List.length_append,digits_length,List.length_cons]
    change 15+(bits rest).length=_
    rw [ih]
    omega

theorem append_bound (p : Nat) (acc : BitVec 32) (byte : BitVec 8)
    (small : p<15) (bound : acc.toNat<2^p) : (appended acc byte).toNat<2^(p+8) := by
  have byteBound := byte.isLt
  have total : acc.toNat*2^8+byte.toNat<2^(p+8) := by
    rw [Nat.pow_add]
    norm_num only [Nat.reducePow] at byteBound ⊢
    omega
  have order : (2 : Nat)^(p+8)≤2^32 := Nat.le_of_dvd (Nat.two_pow_pos _) (Nat.pow_dvd_pow 2 (by omega))
  have shifted : acc.toNat*2^8<2^32 := by omega
  have wide : (byte.setWidth 32).toNat=byte.toNat := by
    rw [BitVec.toNat_setWidth,Nat.mod_eq_of_lt (show byte.toNat<2^32 by omega)]
  unfold appended
  rw [BitVec.toNat_or,BitVec.toNat_shiftLeft,wide,Nat.shiftLeft_eq,Nat.mod_eq_of_lt shifted,
    ←Nat.shiftLeft_eq,←Nat.shiftLeft_add_eq_or_of_lt byteBound,Nat.shiftLeft_eq]
  exact total

theorem refill (p : Nat) (acc : BitVec 32) (byte : BitVec 8) (bytes : List (BitVec 8)) (small : p<15) :
    remaining (p+8) (appended acc byte) bytes=remaining p acc (byte::bytes) := by
  have wide : (byte.setWidth 32).toNat=byte.toNat := by
    rw [BitVec.toNat_setWidth,Nat.mod_eq_of_lt (show byte.toNat<2^32 by have bound:=byte.isLt; omega)]
  have joined := append_word p 8 acc (byte.setWidth 32) (by omega) (by rw [wide]; exact byte.isLt)
  unfold remaining
  rw [show buffer (p+8) (appended acc byte)=buffer p acc++buffer 8 (byte.setWidth 32) from joined]
  simp only [buffer,wide,bytesBits,List.flatMap_cons,List.append_assoc]

theorem extract (p : Nat) (acc : BitVec 32) (bytes : List (BitVec 8)) (input : BitVec 16) (rest : List (BitVec 16))
    (fits : 15≤p) (small : p<23) (bound : acc.toNat<2^p) (canonical : input.toNat<18433)
    (held : remaining p acc bytes=bits (input::rest)) :
    acc >>> (p-15)=input.setWidth 32 ∧
      remaining (p-15) (masked (p-15) acc) bytes=bits rest ∧
      (masked (p-15) acc).toNat<2^(p-15) := by
  have shaped : remaining p acc bytes=digits 15 input.toNat++bits rest := held
  obtain ⟨tail,bufferEq,tailLength,last⟩ := KeygenDecodeStaticPrefixBits.split p acc bytes
    (digits 15 input.toNat) (bits rest) (by rw [digits_length]; exact fits) shaped
  rw [digits_length] at tailLength
  have valueEq := congrArg value bufferEq
  rw [buffer_value,KeygenCodecStaticSuffix.low,Nat.mod_eq_of_lt bound] at valueEq
  have high : acc.toNat/2^(p-15)=input.toNat := by
    rw [←tailLength,valueEq,head_value,KeygenPublicStream077.canonical_word input canonical]
  have prefixEq : acc >>> (p-15)=input.setWidth 32 := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,high,BitVec.toNat_setWidth,
      Nat.mod_eq_of_lt (show input.toNat<2^32 by omega)]
  have restBits := KeygenDecodeStaticBitSlice.tail_bits (digits 15 input.toNat) tail acc
    (by simpa only [digits_length,tailLength,show 15+(p-15)=p by omega] using bufferEq)
  rw [tailLength] at restBits
  have maskedBits := KeygenPublicBits077.masked_buffer (p-15) acc (by omega)
  have maskedBound : (masked (p-15) acc).toNat<2^(p-15) := by
    rw [masked,KeygenDecodeStaticBitSlice.mask acc (p-15) (by omega)]
    exact KeygenCodecStaticSuffix.low_bound acc (p-15)
  refine ⟨prefixEq,?_,maskedBound⟩
  unfold remaining
  rw [maskedBits,restBits]
  exact last

end FT1536.Source3.KeygenPublicDecodeBits077
