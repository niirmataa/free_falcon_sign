import Source3.KeygenPublicEncodeComplete077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicStream077
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer KeygenPublicBits077

theorem stream (inputs : List (BitVec 16)) (p : Nat) (acc : BitVec 32) (small : p<8)
    (canonical : Canonical inputs) :
    bytesBits (bytes inputs p acc)++buffer (fold inputs p acc).1 (fold inputs p acc).2=buffer p acc++bits inputs := by
  induction inputs generalizing p acc with
  | nil => simp only [bytes,bytesBits,List.flatMap_nil,List.nil_append,fold,bits,List.append_nil]
  | cons input rest ih =>
    have tailCanonical : Canonical rest := fun word member => canonical word (List.mem_cons_of_mem input member)
    have tail := ih (nextPending p) (nextWord p acc input)
      (by unfold nextPending; exact Nat.mod_lt _ (by decide +kernel)) tailCanonical
    have head := coefficient_bits p acc input small (canonical input List.mem_cons_self)
    simp only [bytes,bytesBits,List.flatMap_append,List.append_assoc,fold,bits,List.flatMap_cons]
    change bytesBits (coefficientBytes p acc input)++
      (bytesBits (bytes rest (nextPending p) (nextWord p acc input))++
        buffer (fold rest (nextPending p) (nextWord p acc input)).1 (fold rest (nextPending p) (nextWord p acc input)).2)=_
    rw [tail,←List.append_assoc,head,List.append_assoc]
    rfl

theorem encoded_bits (inputs : List (BitVec 16)) (count : inputs.length=1536) (canonical : Canonical inputs) :
    bytesBits (encoded inputs)=bits inputs := by
  have total := stream inputs 0 0 (by decide +kernel) canonical
  have finalPending := (source_profile_lengths inputs count).2
  rw [finalPending] at total
  simpa only [encoded,buffer,digits,List.append_nil,List.nil_append] using total

theorem canonical_word (input : BitVec 16) (canonical : input.toNat<18433) :
    value (digits 15 input.toNat)=input.toNat := by
  rw [digits_value,Nat.mod_eq_of_lt (show input.toNat<2^15 by omega)]

end FT1536.Source3.KeygenPublicStream077
