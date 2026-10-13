import Source3.KeygenCodecStaticBitStream

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A value-level inverse of the source-derived bit history. Operational
   refills, stores and whole decoder existence remain separate obligations. -/
namespace FT1536.Source3.KeygenCodecStaticBitInverse
open KeygenCodecStaticBits KeygenCodecStaticBitUnary KeygenCodecStaticBitStream

def magnitude (input : BitVec 16) : Nat := (KeygenCodecStaticCoefficient.magnitude input.toInt).toNat
def sign (input : BitVec 16) : Bool := decide (input.toInt<0)

theorem magnitude_bound (input : BitVec 16) : magnitude input≤32768 := by
  have bounds := KeygenCodecStaticCoefficient.magnitude_bounds input.toInt input.le_toInt (by have h:=input.toInt_lt; omega)
  unfold magnitude
  omega

theorem magnitude_integer (input : BitVec 16) :
    (magnitude input : Int)=KeygenCodecStaticCoefficient.magnitude input.toInt := by
  have bounds := KeygenCodecStaticCoefficient.magnitude_bounds input.toInt input.le_toInt (by have h:=input.toInt_lt; omega)
  exact Int.toNat_of_nonneg bounds.1

theorem packed_shape (input : BitVec 16) :
    digits 9 (KeygenCodecStaticLow9.packed input.toInt).toNat=sign input::digits 8 (magnitude input) := by
  apply value_injective
  · simp only [digits_length,List.length_cons]
  · rw [digits_value,Nat.mod_eq_of_lt (show (KeygenCodecStaticLow9.packed input.toInt).toNat<2^9 from KeygenCodecStaticLow9.packed_bound input.toInt),value,digits_length,digits_value,
      KeygenCodecStaticLow9.packed_value]
    have exactMag : (BitVec.ofInt 32 (KeygenCodecStaticCoefficient.magnitude input.toInt)).toNat=magnitude input := by
      rw [←magnitude_integer input,BitVec.ofInt_natCast,BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show magnitude input<2^32 by have h:=magnitude_bound input; omega)]
    rw [exactMag]
    unfold sign
    by_cases negative : input.toInt<0 <;> simp only [negative,ite_true,ite_false,decide_true,decide_false,
      Bool.toNat_true,Bool.toNat_false,Nat.one_mul,Nat.zero_mul,Nat.zero_add]
    all_goals rfl

theorem unary_count (input : BitVec 16) :
    KeygenCodecStaticLength.unaryCount input=magnitude input/256+1 := by
  unfold KeygenCodecStaticLength.unaryCount
  rw [←magnitude_integer input]
  omega

theorem coefficient_shape (input : BitVec 16) :
    coefficient input=sign input::(digits 8 (magnitude input)++
      List.replicate (magnitude input/256) false++[true]) := by
  rw [coefficient,packed_shape,unary_count,unary_positive,List.cons_append,List.append_assoc]

def fixed : Nat → List Bool → Option (Nat × List Bool)
  | 0,bits => some (0,bits)
  | _+1,[] => none
  | count+1,b::rest => do
      let (value,tail) ← fixed count rest
      return (b.toNat*2^count+value,tail)

def zeros : List Bool → Option (Nat × List Bool)
  | [] => none
  | true::rest => some (0,rest)
  | false::rest => do
      let (count,tail) ← zeros rest
      return (count+1,tail)

def decode : List Bool → Option (BitVec 16 × List Bool)
  | [] => none
  | s::rest => do
      let (lo,afterLow) ← fixed 8 rest
      let (ne,tail) ← zeros afterLow
      let mag := lo+ne*256
      return (BitVec.ofInt 16 (if s then -(mag : Int) else (mag : Int)),tail)

theorem fixed_append (head tail : List Bool) :
    fixed head.length (head++tail)=some (value head,tail) := by
  induction head with
  | nil => rfl
  | cons b rest ih =>
    simp only [List.length_cons,List.cons_append,fixed,ih,value]
    rfl

theorem zeros_append (n : Nat) (tail : List Bool) :
    zeros (List.replicate n false++true::tail)=some (n,tail) := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [List.replicate_succ,List.cons_append,zeros,ih]; rfl

theorem signed_magnitude (input : BitVec 16) :
    (if sign input then -(magnitude input : Int) else (magnitude input : Int))=input.toInt := by
  rw [magnitude_integer]
  unfold sign KeygenCodecStaticCoefficient.magnitude
  by_cases negative : input.toInt<0 <;> simp [negative]

/-- Every int16 value, including -32768, is recovered from its actual
    source-derived sign/low/unary bit code, with arbitrary following bits. -/
theorem decode_coefficient (input : BitVec 16) (tail : List Bool) :
    decode (coefficient input++tail)=some (input,tail) := by
  rw [coefficient_shape,List.cons_append]
  simp only [decode]
  have low := fixed_append (digits 8 (magnitude input)) (List.replicate (magnitude input/256) false++[true]++tail)
  rw [digits_length,digits_value] at low
  rw [show fixed 8 ((digits 8 (magnitude input)++List.replicate (magnitude input/256) false++[true])++tail)=
      some (magnitude input%256,List.replicate (magnitude input/256) false++[true]++tail) by
        simpa only [List.append_assoc,show (2 : Nat)^8=256 from rfl] using low]
  dsimp only [Bind.bind,Option.bind]
  simp only [List.append_assoc,List.cons_append,List.nil_append]
  rw [zeros_append]
  dsimp only [Bind.bind,Option.bind]
  have mag : magnitude input%256+magnitude input/256*256=magnitude input := by
    have same := Nat.mod_add_div (magnitude input) 256
    simpa only [Nat.mul_comm] using same
  rw [mag,signed_magnitude,BitVec.ofInt_toInt]
  rfl

def many : Nat → List Bool → Option (List (BitVec 16) × List Bool)
  | 0,bits => some ([],bits)
  | count+1,bits => do
      let (word,tail) ← decode bits
      let (rest,last) ← many count tail
      return (word::rest,last)

theorem many_stream (inputs : List (BitVec 16)) (tail : List Bool) :
    many inputs.length (stream inputs++tail)=some (inputs,tail) := by
  induction inputs with
  | nil => rfl
  | cons input rest ih =>
    simp only [stream] at ih
    simp only [List.length_cons,stream,List.flatMap_cons,List.append_assoc,many]
    rw [decode_coefficient]
    dsimp only [Bind.bind,Option.bind]
    rw [ih]
    rfl

theorem encoded_inverse (inputs : List (BitVec 16)) :
    many inputs.length (KeygenCodecStaticBitBuffer.bytesBits (KeygenCodecStaticComplete.encoded inputs))=
      some (inputs,List.replicate ((8-(KeygenCodecStaticOuterState.fold inputs 0 0).1)%8) false) := by
  rw [encoded_bits]
  exact many_stream _ _

end FT1536.Source3.KeygenCodecStaticBitInverse
