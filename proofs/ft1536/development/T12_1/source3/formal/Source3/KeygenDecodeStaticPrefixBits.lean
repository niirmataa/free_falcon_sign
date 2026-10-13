import Source3.KeygenDecodeStaticPrefixValues
import Source3.KeygenCodecStaticBitInverse

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticPrefixBits
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer KeygenDecodeStaticWire

theorem split (p : Nat) (db : BitVec 32) (bytes : List (BitVec 8)) (head tail : List Bool)
    (fits : head.length≤p) (held : remaining p db bytes=head++tail) :
    ∃ rest, buffer p db=head++rest ∧ rest.length=p-head.length ∧ rest++bytesBits bytes=tail := by
  let rest := (buffer p db).drop head.length
  have headTake : (buffer p db).take head.length=head := by
    have take := congrArg (List.take head.length) held
    unfold remaining at take
    rw [List.take_append_of_le_length (by rw [buffer_length]; exact fits),List.take_left] at take
    exact take
  have together : head++rest=buffer p db := by
    rw [←headTake]
    exact List.take_append_drop _ _
  refine ⟨rest,together.symm,?_,?_⟩
  · simp only [rest,List.length_drop,buffer_length]
  · unfold remaining at held
    rw [←together,List.append_assoc] at held
    exact (List.append_right_inj _).mp held

theorem coefficient (p : Nat) (db : BitVec 32) (bytes : List (BitVec 8)) (input : BitVec 16)
    (tail : List Bool) (fits : 9≤p)
    (held : remaining p db bytes=KeygenCodecStaticBitStream.coefficient input++tail) :
    ∃ rest, buffer p db=KeygenCodecStaticBitInverse.sign input::
        (digits 8 (KeygenCodecStaticBitInverse.magnitude input)++rest) ∧
      rest.length=p-9 ∧ rest++bytesBits bytes=
        List.replicate (KeygenCodecStaticBitInverse.magnitude input/256) false++[true]++tail := by
  rw [KeygenCodecStaticBitInverse.coefficient_shape,List.cons_append,List.append_assoc] at held
  have headLength : (KeygenCodecStaticBitInverse.sign input::digits 8 (KeygenCodecStaticBitInverse.magnitude input)).length=9 := by
    rw [List.length_cons,digits_length]
  have shaped : remaining p db bytes=
      (KeygenCodecStaticBitInverse.sign input::digits 8 (KeygenCodecStaticBitInverse.magnitude input))++
        (List.replicate (KeygenCodecStaticBitInverse.magnitude input/256) false++[true]++tail) := by
    simpa only [List.cons_append,List.append_assoc] using held
  obtain ⟨rest,buffer,length,last⟩ := split p db bytes _ _ (by rw [headLength]; exact fits) shaped
  exact ⟨rest,by simpa only [List.cons_append] using buffer,by simpa only [headLength] using length,last⟩

end FT1536.Source3.KeygenDecodeStaticPrefixBits
