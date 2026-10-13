import Source3.KeygenPublicMaterial077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicPacket077
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer
open KeygenPublicAlgebra (R)

def group (bits : List Bool) (i : Fin 1536) : Nat := value ((bits.drop (15*i.val)).take 15)
def vector (words : Fin 1536 → Nat) : Relation.Rq := fun i =>
  ((words (KeygenInt16Vector076.lowIndex i) : R),(words (KeygenInt16Vector076.highIndex i) : R))
/-- M0 public bytes: one profile header and1536 canonical15-bit values.
    The actual payload decoder ignores trailing bytes, so this does too. -/
def DecodePublic : List (BitVec 8) → Option Relation.Rq
  | [] => none
  | header::payload =>
    if header=138 then
      let bits := bytesBits payload
      if 23040≤bits.length then
        let words := group bits
        if ∀ i, words i<18433 then some (vector words) else none
      else none
    else none

theorem group_bits (inputs : List (BitVec 16)) (i : Nat) (inside : i < inputs.length) :
    ((KeygenPublicBits077.bits inputs).drop (15*i)).take 15=digits 15 inputs[i].toNat := by
  induction inputs generalizing i with
  | nil => simp only [List.length_nil] at inside; omega
  | cons input rest ih =>
    cases i with
    | zero =>
      change ((digits 15 input.toNat++KeygenPublicBits077.bits rest).drop 0).take 15=digits 15 input.toNat
      rw [List.drop_zero,List.take_append_of_le_length (by rw [digits_length])]
      simpa only [digits_length] using (List.take_length (l := digits 15 input.toNat))
    | succ i =>
      have bound : i<rest.length := by simp only [List.length_cons] at inside; omega
      change ((digits 15 input.toNat++KeygenPublicBits077.bits rest).drop (15*(i+1))).take 15=digits 15 (rest[i]'bound).toNat
      rw [List.drop_append,List.drop_eq_nil_of_le (by rw [digits_length]; omega),List.nil_append,digits_length,
        show 15*(i+1)-15=15*i by omega]
      exact ih i (by simp only [List.length_cons] at inside; omega)

theorem group_append (a b : List Bool) (i : Fin 1536) (inside : 15*(i.val+1)≤a.length) :
    group (a++b) i=group a i := by
  unfold group
  rw [List.drop_append_of_le_length (by omega),List.take_append_of_le_length (by rw [List.length_drop]; omega)]

theorem recovered (inputs : List (BitVec 16)) (tail : List (BitVec 8)) (count : inputs.length=1536)
    (canonical : KeygenPublicBits077.Canonical inputs) (i : Fin 1536) :
    group (bytesBits (KeygenPublicBits077.encoded inputs++tail)) i=(inputs[i.val]'(by rw [count]; exact i.isLt)).toNat := by
  rw [bytesBits,List.flatMap_append]
  change group (bytesBits (KeygenPublicBits077.encoded inputs)++bytesBits tail) i=_
  rw [KeygenPublicStream077.encoded_bits inputs count canonical,
    group_append _ _ i (by rw [KeygenPublicDecodeBits077.bits_length,count]; have bound:=i.isLt; omega)]
  unfold group
  rw [group_bits inputs i.val (by rw [count]; exact i.isLt),
    KeygenPublicStream077.canonical_word _ (canonical _ (List.getElem_mem _))]

theorem decode_honest (inputs : List (BitVec 16)) (h : Relation.Rq) (tail : List (BitVec 8))
    (count : inputs.length=1536) (canonical : KeygenPublicBits077.Canonical inputs)
    (realizes : KeygenPublicMaterial077.Realizes inputs h) :
    DecodePublic (138::(KeygenPublicBits077.encoded inputs++tail))=some h := by
  have enough : 23040≤(bytesBits (KeygenPublicBits077.encoded inputs++tail)).length := by
    rw [KeygenDecodeStaticWire.bytes_length,List.length_append,(KeygenPublicBits077.source_profile_lengths inputs count).1]
    omega
  have valid : ∀ i : Fin 1536, group (bytesBits (KeygenPublicBits077.encoded inputs++tail)) i<18433 := by
    intro i
    rw [recovered inputs tail count canonical i]
    exact canonical _ (List.getElem_mem _)
  have material : vector (group (bytesBits (KeygenPublicBits077.encoded inputs++tail)))=h := by
    obtain ⟨words,rfl,values⟩ := realizes
    funext i
    apply Prod.ext
    · change (group (bytesBits (KeygenPublicBits077.encoded (List.ofFn words)++tail)) (KeygenInt16Vector076.lowIndex i) : R)=(h i).1
      rw [recovered _ tail count canonical, List.getElem_ofFn]
      exact (values (KeygenInt16Vector076.lowIndex i)).trans (KeygenPublicMaterial077.coefficient_low h i)
    · change (group (bytesBits (KeygenPublicBits077.encoded (List.ofFn words)++tail)) (KeygenInt16Vector076.highIndex i) : R)=(h i).2
      rw [recovered _ tail count canonical, List.getElem_ofFn]
      exact (values (KeygenInt16Vector076.highIndex i)).trans (KeygenPublicMaterial077.coefficient_high h i)
  simp only [DecodePublic,ite_true,enough,valid,material,forall_const]

end FT1536.Source3.KeygenPublicPacket077
