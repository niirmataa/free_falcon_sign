import Source3.KeygenSecretBits081

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretSegment081
open KeygenCodecStaticBitBuffer KeygenCodecStaticBitStream
open KeygenCodecStaticComplete (encoded)

def usedBits (data : List (BitVec 8)) (rest : List Bool) : Nat := (bytesBits data).length-rest.length
def usedBytes (data : List (BitVec 8)) (rest : List Bool) : Nat := (usedBits data rest+7)/8
def paddingBits (data : List (BitVec 8)) (rest : List Bool) : Nat := 8*usedBytes data rest-usedBits data rest

/-- Parse1536 source coefficients and this segment's own zero padding.
    The remaining bytes, including later segments, are returned untouched. -/
def segment (data : List (BitVec 8)) : Option (List (BitVec 16) × List (BitVec 8)) := do
  let (values,rest) ← KeygenSecretBits081.many 1536 (bytesBits data)
  let consumed := usedBytes data rest
  let padding := paddingBits data rest
  if consumed≤data.length ∧ padding<8 ∧ rest.take padding=List.replicate padding false then
    return (values,data.drop consumed)
  else none

def remaining (inputs : List (BitVec 16)) (tail : List (BitVec 8)) : List Bool :=
  List.replicate (KeygenDecodeStaticComplete.paddingCount inputs) false++bytesBits tail

theorem parsed (inputs : List (BitVec 16)) (tail : List (BitVec 8)) (count : inputs.length=1536) :
    KeygenSecretBits081.many 1536 (bytesBits (encoded inputs++tail))=some (inputs,remaining inputs tail) := by
  rw [bytes_append,encoded_bits,List.append_assoc,←count]
  exact KeygenSecretBits081.many_honest inputs (remaining inputs tail)

theorem used_bits (inputs : List (BitVec 16)) (tail : List (BitVec 8)) :
    usedBits (encoded inputs++tail) (remaining inputs tail)=KeygenCodecStaticLength.totalBits inputs := by
  unfold usedBits remaining KeygenDecodeStaticComplete.paddingCount
  rw [bytes_append,encoded_bits]
  simp only [List.length_append,List.length_replicate]
  rw [KeygenSecretBits081.stream_length]
  omega

theorem used_bytes (inputs : List (BitVec 16)) (tail : List (BitVec 8)) :
    usedBytes (encoded inputs++tail) (remaining inputs tail)=(encoded inputs).length := by
  rw [usedBytes,used_bits,KeygenCodecStaticLength.encoded_length]
  rfl

theorem bit_count (inputs : List (BitVec 16)) :
    8*(encoded inputs).length=KeygenCodecStaticLength.totalBits inputs+KeygenDecodeStaticComplete.paddingCount inputs := by
  have lengths := congrArg List.length (encoded_bits inputs)
  simpa only [KeygenDecodeStaticWire.bytes_length,List.length_append,List.length_replicate,
    KeygenSecretBits081.stream_length,KeygenDecodeStaticComplete.paddingCount] using lengths

theorem padding (inputs : List (BitVec 16)) (tail : List (BitVec 8)) :
    paddingBits (encoded inputs++tail) (remaining inputs tail)=KeygenDecodeStaticComplete.paddingCount inputs := by
  rw [paddingBits,used_bytes,used_bits,bit_count]
  omega

theorem segment_honest (inputs : List (BitVec 16)) (tail : List (BitVec 8)) (count : inputs.length=1536) :
    segment (encoded inputs++tail)=some (inputs,tail) := by
  unfold segment
  rw [parsed inputs tail count]
  dsimp only [Bind.bind,Option.bind]
  rw [used_bytes,padding]
  have enough : (encoded inputs).length≤(encoded inputs++tail).length := by simp only [List.length_append]; omega
  have small : KeygenDecodeStaticComplete.paddingCount inputs<8 := Nat.mod_lt _ (by decide +kernel)
  have zeros : (remaining inputs tail).take (KeygenDecodeStaticComplete.paddingCount inputs)=
      List.replicate (KeygenDecodeStaticComplete.paddingCount inputs) false := by
    unfold remaining
    rw [List.take_append_of_le_length (by simp only [List.length_replicate]; exact Nat.le_refl _)]
    simp only [List.take_replicate,Nat.min_self]
  rw [ite_eq_left ⟨enough,small,zeros⟩,List.drop_left]
  rfl

end FT1536.Source3.KeygenSecretSegment081
