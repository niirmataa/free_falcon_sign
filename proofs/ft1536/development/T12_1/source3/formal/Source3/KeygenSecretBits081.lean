import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenInt16FourMaterial076

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretBits081
open KeygenCodecStaticBits KeygenCodecStaticBitStream KeygenCodecStaticBitBuffer
open KeygenCodecStaticBitInverse (fixed zeros sign magnitude)

/-- Source sign/low8/unary parsing, including the uint32 unary counter and
    its actual ne>255 rejection. No desired encoded length is consulted. -/
def word : List Bool → Option (BitVec 16 × List Bool)
  | [] => none
  | s::rest => do
      let (lo,afterLow) ← fixed 8 rest
      let (count,tail) ← zeros afterLow
      let ne := count % 2^32
      if ne≤255 then
        let mag := lo+ne*256
        return (BitVec.ofInt 16 (if s then -(mag : Int) else (mag : Int)),tail)
      else none

def many : Nat → List Bool → Option (List (BitVec 16) × List Bool)
  | 0,bits => some ([],bits)
  | count+1,bits => do
      let (value,tail) ← word bits
      let (rest,last) ← many count tail
      return (value::rest,last)

theorem word_honest (input : BitVec 16) (tail : List Bool) :
    word (coefficient input++tail)=some (input,tail) := by
  rw [KeygenCodecStaticBitInverse.coefficient_shape,List.cons_append]
  simp only [word]
  have low := KeygenCodecStaticBitInverse.fixed_append (digits 8 (magnitude input))
    (List.replicate (magnitude input/256) false++[true]++tail)
  rw [digits_length,digits_value] at low
  rw [show fixed 8 ((digits 8 (magnitude input)++List.replicate (magnitude input/256) false++[true])++tail)=
      some (magnitude input%256,List.replicate (magnitude input/256) false++[true]++tail) by
        simpa only [List.append_assoc,show (2 : Nat)^8=256 from rfl] using low]
  dsimp only [Bind.bind,Option.bind]
  simp only [List.append_assoc,List.cons_append,List.nil_append]
  rw [KeygenCodecStaticBitInverse.zeros_append]
  dsimp only [Bind.bind,Option.bind]
  have bound := KeygenCodecStaticBitInverse.magnitude_bound input
  have small : magnitude input/256<2^32 := by omega
  have accepted : magnitude input/256≤255 := by omega
  rw [Nat.mod_eq_of_lt small,ite_eq_left accepted]
  have mag : magnitude input%256+magnitude input/256*256=magnitude input := by
    have same := Nat.mod_add_div (magnitude input) 256
    simpa only [Nat.mul_comm] using same
  rw [mag,KeygenCodecStaticBitInverse.signed_magnitude,BitVec.ofInt_toInt]
  rfl

theorem many_honest (inputs : List (BitVec 16)) (tail : List Bool) :
    many inputs.length (stream inputs++tail)=some (inputs,tail) := by
  induction inputs with
  | nil => rfl
  | cons input rest ih =>
    simp only [stream] at ih
    simp only [List.length_cons,stream,List.flatMap_cons,List.append_assoc,many]
    rw [word_honest]
    dsimp only [Bind.bind,Option.bind]
    rw [ih]
    rfl

theorem stream_length (inputs : List (BitVec 16)) :
    (stream inputs).length=KeygenCodecStaticLength.totalBits inputs := by
  induction inputs with
  | nil => rfl
  | cons input rest ih =>
    simp only [stream,List.flatMap_cons,List.length_append] at *
    rw [KeygenCodecStaticBitStream.coefficient_length,ih]
    rfl

end FT1536.Source3.KeygenSecretBits081
