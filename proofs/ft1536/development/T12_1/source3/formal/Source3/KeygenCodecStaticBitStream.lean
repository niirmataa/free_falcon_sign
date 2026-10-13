import Source3.KeygenCodecStaticBitUnary
import Source3.KeygenCodecStaticLength

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- SAME actual encoder history interpreted as bits, retaining old high
   accumulator bits and one independently padded final segment. -/
namespace FT1536.Source3.KeygenCodecStaticBitStream
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer KeygenCodecStaticBitUnary
open KeygenCodecStaticIteration KeygenCodecStaticOuterState

def coefficient (input : BitVec 16) : List Bool :=
  digits 9 (KeygenCodecStaticLow9.packed input.toInt).toNat++unary (KeygenCodecStaticLength.unaryCount input)
def stream (inputs : List (BitVec 16)) : List Bool := inputs.flatMap coefficient

theorem bytes_append (a b : List (BitVec 8)) : bytesBits (a++b)=bytesBits a++bytesBits b := List.flatMap_append

theorem coefficient_length (input : BitVec 16) :
    (coefficient input).length=KeygenCodecStaticLength.bitCost input := by
  simp only [coefficient,List.length_append,digits_length,unary_length,KeygenCodecStaticLength.bitCost]

theorem coefficient_history (p : Nat) (word : BitVec 32) (input : BitVec 16) (small : p<8) :
    bytesBits (KeygenCodecStaticCoefficientHistory.bytes p word input)++
      buffer (nextPending p input.toInt) (nextWord p word input.toInt)=buffer p word++coefficient input := by
  let packed := KeygenCodecStaticPrefix.packedWord word input
  let count := KeygenCodecStaticLength.unaryCount input
  have finish := KeygenCodecStaticUnaryInvariant.finish_pending count ((p+9)%8) packed (Nat.mod_lt _ (by decide +kernel))
  have unaryHistory := unary_history count ((p+9)%8) packed (Nat.mod_lt _ (by decide +kernel))
  rw [finish] at unaryHistory
  change bytesBits (KeygenCodecStaticCoefficientHistory.firstBytes p word input++
    KeygenCodecStaticCoefficientHistory.lastBytes p word input)++_= _
  change bytesBits (KeygenCodecStaticCoefficientHistory.firstBytes p word input++
    KeygenCodecStaticUnaryHistory.bytes count ((p+9)%8) packed)++
      buffer (((p+9)%8+count)%8) (KeygenCodecStaticUnaryInvariant.finish count ((p+9)%8) packed).2= _
  rw [bytes_append,List.append_assoc,unaryHistory,←List.append_assoc]
  have drained := drain ((p+9)/8) (p+9) packed (by omega)
  have pending : p+9-8*((p+9)/8)=(p+9)%8 := by omega
  rw [pending] at drained
  change (bytesBits (KeygenCodecStaticDrainHistory.bytes ((p+9)/8) (p+9) packed)++buffer ((p+9)%8) packed)++unary count=_
  rw [drained]
  have appended := append_word p 9 word (KeygenCodecStaticLow9.packed input.toInt) (by omega)
    (KeygenCodecStaticLow9.packed_bound input.toInt)
  rw [show buffer (p+9) packed=buffer p word++digits 9 (KeygenCodecStaticLow9.packed input.toInt).toNat from appended]
  rw [List.append_assoc]
  rfl

theorem stream_history (inputs : List (BitVec 16)) (p : Nat) (word : BitVec 32) (small : p<8) :
    bytesBits (KeygenCodecStaticOuterHistory.bytes inputs p word)++
      buffer (fold inputs p word).1 (fold inputs p word).2=buffer p word++stream inputs := by
  induction inputs generalizing p word with
  | nil => simp only [KeygenCodecStaticOuterHistory.bytes,bytesBits,List.flatMap_nil,List.nil_append,fold,stream,List.append_nil]
  | cons input rest ih =>
    have nextSmall : nextPending p input.toInt<8 := Nat.mod_lt _ (by decide +kernel)
    have tail := ih (nextPending p input.toInt) (nextWord p word input.toInt) nextSmall
    simp only [KeygenCodecStaticOuterHistory.bytes,fold,stream,List.flatMap_cons]
    rw [bytes_append,List.append_assoc,tail,←List.append_assoc,coefficient_history p word input small,List.append_assoc]
    rfl

/-- Padding is precisely the zeros of this segment, even for arbitrary
    already emitted high bits in the stored accumulator word. -/
theorem padding_bits (p : Nat) (word : BitVec 32) (small : p<8) :
    bytesBits (KeygenCodecStaticReturnHistory.padding word p)=
      buffer p word++List.replicate ((8-p)%8) false := by
  by_cases zero : p=0
  · subst p
    simp only [KeygenCodecStaticReturnHistory.padding,ite_true,bytesBits,List.flatMap_nil,
      buffer,digits,show (8-0)%8=0 from rfl,List.replicate_zero,List.nil_append]
  · have mod : (8-p)%8=8-p := Nat.mod_eq_of_lt (by omega)
    simp only [KeygenCodecStaticReturnHistory.padding,zero,ite_false,bytesBits,List.flatMap_cons,List.flatMap_nil,List.append_nil,mod]
    apply value_injective
    · simp only [digits_length,List.length_append,buffer_length,List.length_replicate]; omega
    · rw [digits_value,Nat.mod_eq_of_lt (BitVec.isLt _),value_append,buffer_value,List.length_replicate,
        KeygenCodecStaticByte.padded_byte word p (by omega)]
      have zeros (n : Nat) : value (List.replicate n false)=0 := by
        induction n with
        | zero => rfl
        | succ n ih => simp only [List.replicate_succ,value,Bool.toNat_false,Nat.zero_mul,Nat.zero_add,ih]
      rw [zeros,Nat.add_zero]

theorem encoded_bits (inputs : List (BitVec 16)) :
    bytesBits (KeygenCodecStaticComplete.encoded inputs)=
      stream inputs++List.replicate ((8-(fold inputs 0 0).1)%8) false := by
  have full := stream_history inputs 0 0 (by decide +kernel)
  have small := fold_pending inputs 0 0 (by decide +kernel)
  unfold KeygenCodecStaticComplete.encoded
  rw [bytes_append,padding_bits _ _ small,←List.append_assoc,full]
  rfl

end FT1536.Source3.KeygenCodecStaticBitStream
