import Source3.KeygenCodecStaticBitBuffer

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact15-bit public packing calculus matching the source shift, drain
   and explicit accumulator mask. Source execution refinement is next. -/
namespace FT1536.Source3.KeygenPublicBits077
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer

def Canonical (inputs : List (BitVec 16)) : Prop := ∀ input, input∈inputs → input.toNat<18433

def appended (acc : BitVec 32) (input : BitVec 16) : BitVec 32 := (acc <<< 15) ||| input.setWidth 32
def masked (p : Nat) (acc : BitVec 32) : BitVec 32 := acc &&& BitVec.ofNat 32 (2^p-1)
def nextPending (p : Nat) : Nat := (p+15)%8
def drainBytes : Nat → Nat → BitVec 32 → List (BitVec 8)
  | 0,_,_ => []
  | count+1,p,acc => KeygenCodecStaticByte.byte (acc >>> (p-8))::drainBytes count (p-8) (masked (p-8) acc)
def drainWord : Nat → Nat → BitVec 32 → BitVec 32
  | 0,_,acc => acc
  | count+1,p,acc => drainWord count (p-8) (masked (p-8) acc)
def nextWord (p : Nat) (acc : BitVec 32) (input : BitVec 16) : BitVec 32 :=
  drainWord ((p+15)/8) (p+15) (appended acc input)
def coefficientBytes (p : Nat) (acc : BitVec 32) (input : BitVec 16) : List (BitVec 8) :=
  drainBytes ((p+15)/8) (p+15) (appended acc input)
def bytes : List (BitVec 16) → Nat → BitVec 32 → List (BitVec 8)
  | [],_,_ => []
  | input::rest,p,acc => coefficientBytes p acc input++bytes rest (nextPending p) (nextWord p acc input)
def fold : List (BitVec 16) → Nat → BitVec 32 → Nat × BitVec 32
  | [],p,acc => (p,acc)
  | input::rest,p,acc => fold rest (nextPending p) (nextWord p acc input)
def bits (inputs : List (BitVec 16)) : List Bool := inputs.flatMap (fun input => digits 15 input.toNat)
def encoded (inputs : List (BitVec 16)) : List (BitVec 8) := bytes inputs 0 0

theorem masked_buffer (p : Nat) (acc : BitVec 32) (small : p<32) : buffer p (masked p acc)=buffer p acc := by
  apply value_injective
  · simp only [buffer_length]
  · rw [buffer_value,buffer_value]
    unfold masked KeygenCodecStaticSuffix.low
    have power : (2 : Nat)^p≤2^31 := Nat.le_of_dvd (Nat.two_pow_pos _) (Nat.pow_dvd_pow 2 (by omega))
    have maskSmall : 2^p-1<2^32 := by omega
    rw [BitVec.toNat_and,BitVec.toNat_ofNat,Nat.mod_eq_of_lt maskSmall,Nat.and_two_pow_sub_one_eq_mod,Nat.mod_mod]

theorem drain_size (count p : Nat) (acc : BitVec 32) : (drainBytes count p acc).length=count := by
  induction count generalizing p acc with
  | zero => rfl
  | succ count ih => simp only [drainBytes,List.length_cons,ih]

theorem drain_buffer (count p : Nat) (acc : BitVec 32) (bound : 8*count≤p) (small : p<32) :
    bytesBits (drainBytes count p acc)++buffer (p-8*count) (drainWord count p acc)=buffer p acc := by
  induction count generalizing p acc with
  | zero => simp only [drainBytes,drainWord,bytesBits,List.flatMap_nil,List.nil_append,Nat.mul_zero,Nat.sub_zero]
  | succ count ih =>
    have positive : 8≤p := by omega
    have tail := ih (p-8) (masked (p-8) acc) (by omega) (by omega)
    simp only [drainBytes,drainWord,bytesBits,List.flatMap_cons,List.append_assoc]
    rw [show p-8*(count+1)=p-8-8*count by omega]
    change digits 8 (KeygenCodecStaticByte.byte (acc >>> (p-8))).toNat++
      (bytesBits (drainBytes count (p-8) (masked (p-8) acc))++buffer (p-8-8*count) (drainWord count (p-8) (masked (p-8) acc)))=_
    rw [tail,masked_buffer _ _ (by omega),KeygenCodecStaticBitBuffer.drain_byte,show p-8+8=p by omega]

theorem coefficient_bits (p : Nat) (acc : BitVec 32) (input : BitVec 16) (small : p<8) (canonical : input.toNat<18433) :
    bytesBits (coefficientBytes p acc input)++buffer (nextPending p) (nextWord p acc input)=
      buffer p acc++digits 15 input.toNat := by
  have drained := drain_buffer ((p+15)/8) (p+15) (appended acc input) (by omega) (by omega)
  have pending : p+15-8*((p+15)/8)=(p+15)%8 := by omega
  rw [pending] at drained
  change bytesBits (drainBytes ((p+15)/8) (p+15) (appended acc input))++
    buffer ((p+15)%8) (drainWord ((p+15)/8) (p+15) (appended acc input))=_
  rw [drained]
  have wide : (input.setWidth 32).toNat=input.toNat := by
    rw [BitVec.toNat_setWidth,Nat.mod_eq_of_lt (show input.toNat<2^32 by omega)]
  have append := append_word p 15 acc (input.setWidth 32) (by omega) (by rw [wide]; omega)
  rw [show buffer (p+15) (appended acc input)=buffer p acc++buffer 15 (input.setWidth 32) from append]
  unfold buffer
  rw [wide]

theorem fold_pending (inputs : List (BitVec 16)) (p : Nat) (acc : BitVec 32) (small : p<8) :
    (fold inputs p acc).1=(p+15*inputs.length)%8 := by
  induction inputs generalizing p acc with
  | nil => simp only [fold,List.length_nil,Nat.mul_zero,Nat.add_zero,Nat.mod_eq_of_lt small]
  | cons input rest ih =>
    have tail := ih (nextPending p) (nextWord p acc input) (by unfold nextPending; exact Nat.mod_lt _ (by decide +kernel))
    rw [fold,tail]
    simp only [nextPending,List.length_cons]
    omega

theorem conservation (inputs : List (BitVec 16)) (p : Nat) (acc : BitVec 32) (small : p<8) :
    8*(bytes inputs p acc).length+(fold inputs p acc).1=p+15*inputs.length := by
  induction inputs generalizing p acc with
  | nil => simp only [bytes,List.length_nil,fold,Nat.mul_zero,Nat.zero_add,Nat.add_zero]
  | cons input rest ih =>
    have tail := ih (nextPending p) (nextWord p acc input) (by unfold nextPending; exact Nat.mod_lt _ (by decide +kernel))
    simp only [bytes,List.length_append,coefficientBytes,drain_size,fold,List.length_cons]
    unfold nextPending at tail ⊢
    omega

theorem source_profile_lengths (inputs : List (BitVec 16)) (count : inputs.length=1536) :
    (encoded inputs).length=2880 ∧ (fold inputs 0 0).1=0 := by
  have pending := fold_pending inputs 0 0 (by decide +kernel)
  have total := conservation inputs 0 0 (by decide +kernel)
  rw [count] at pending total
  change (bytes inputs 0 0).length=2880 ∧ (fold inputs 0 0).1=0
  constructor <;> omega

end FT1536.Source3.KeygenPublicBits077
