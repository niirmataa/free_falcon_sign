import Source3.KeygenCodecStaticBits

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The bit interpretation is only the pending suffix of a uint32 word.
   Already emitted high bits are unrestricted, for both source codecs. -/
namespace FT1536.Source3.KeygenCodecStaticBitBuffer
open KeygenCodecStaticBits

def buffer (pending : Nat) (word : BitVec 32) : List Bool := digits pending word.toNat
def bytesBits (bytes : List (BitVec 8)) : List Bool := bytes.flatMap (fun byte => digits 8 byte.toNat)

theorem buffer_length (p : Nat) (word : BitVec 32) : (buffer p word).length=p := digits_length _ _
theorem buffer_value (p : Nat) (word : BitVec 32) : value (buffer p word)=KeygenCodecStaticSuffix.low word p := digits_value _ _

theorem append_word (p count : Nat) (word payload : BitVec 32)
    (width : p+count≤32) (small : payload.toNat<2^count) :
    buffer (p+count) ((word <<< count) ||| payload)=buffer p word++buffer count payload := by
  apply value_injective
  · simp only [List.length_append,buffer_length]
  · rw [buffer_value,value_append,buffer_length,buffer_value,buffer_value]
    rw [KeygenCodecStaticSuffix.low_append word payload p count width small]
    unfold KeygenCodecStaticSuffix.low
    rw [Nat.mod_eq_of_lt small]

/-- Split a whole emitted byte off the high end of the pending suffix. -/
theorem drain_byte (p : Nat) (word : BitVec 32) :
    digits 8 (KeygenCodecStaticByte.byte (word >>> p)).toNat++buffer p word=buffer (p+8) word := by
  apply value_injective
  · simp only [List.length_append,digits_length,buffer_length]; omega
  · rw [value_append,buffer_length,digits_value,buffer_value,buffer_value]
    have byteBound := (KeygenCodecStaticByte.byte (word >>> p)).isLt
    rw [Nat.mod_eq_of_lt byteBound,KeygenCodecStaticStreamByte.drain_low]
    have decomposition := Nat.div_add_mod (KeygenCodecStaticSuffix.low word (p+8)) (2^p)
    have residue : KeygenCodecStaticSuffix.low word (p+8)%2^p=KeygenCodecStaticSuffix.low word p := by
      unfold KeygenCodecStaticSuffix.low
      exact Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 (by omega : p≤p+8))
    rw [residue] at decomposition
    calc
      _ = 2^p*(KeygenCodecStaticSuffix.low word (p+8)/2^p)+KeygenCodecStaticSuffix.low word p := by ac_rfl
      _ = KeygenCodecStaticSuffix.low word (p+8) := decomposition

theorem drain (count p : Nat) (word : BitVec 32) (length : 8*count≤p) :
    bytesBits (KeygenCodecStaticDrainHistory.bytes count p word)++buffer (p-8*count) word=buffer p word := by
  induction count generalizing p with
  | zero => simp only [KeygenCodecStaticDrainHistory.bytes,bytesBits,List.flatMap_nil,List.nil_append,Nat.mul_zero,Nat.sub_zero]
  | succ count ih =>
    have lower : 8≤p := by omega
    have length' : 8*count≤p-8 := by omega
    have equal : p-8*(count+1)=(p-8)-8*count := by omega
    simp only [KeygenCodecStaticDrainHistory.bytes,bytesBits,List.flatMap_cons,List.append_assoc,equal]
    rw [show (List.flatMap (fun byte : BitVec 8 => digits 8 byte.toNat)
      (KeygenCodecStaticDrainHistory.bytes count (p-8) word)++buffer (p-8-8*count) word)=buffer (p-8) word from ih (p-8) length']
    rw [drain_byte,show p-8+8=p by omega]

end FT1536.Source3.KeygenCodecStaticBitBuffer
