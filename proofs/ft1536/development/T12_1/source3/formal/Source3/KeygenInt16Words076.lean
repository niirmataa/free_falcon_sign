import Source3.KeygenInt16Reads076

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Indexed physical words and the actual sequential encoder input relation
   are equivalent, including the real one-past pointer update after the last. -/
namespace FT1536.Source3.KeygenInt16Words076
open C99MemoryReference KeygenInt16Reads076
abbrev element := KeygenDecodeNoneMemory.element
abbrev CodecWords := KeygenCodecStaticMaterial.Words

theorem element_zero (ptr : ArrayPointer) : element ptr 0=ptr := by cases ptr; rfl
theorem element_add (ptr : ArrayPointer) (m n : Nat) : element (element ptr m) n=element ptr (m+n) := by
  cases ptr
  simp only [element,KeygenDecodeNoneMemory.element,Nat.add_assoc]

theorem from_reads (heap : Memory) (ptr : ArrayPointer) (inputs : List (BitVec 16))
    (reads : ∀ i : Fin inputs.length, Read heap (element ptr i.val) inputs[i]) : CodecWords heap ptr inputs := by
  induction inputs generalizing ptr with
  | nil => exact .nil ptr
  | cons input rest ih =>
    have first := reads ⟨0,by simp only [List.length_cons]; omega⟩
    change Read heap (element ptr 0) input at first
    rw [element_zero] at first
    have allocated : Allocated heap ptr := by cases first; assumption
    let next := element ptr 1
    have advance : PointerAdd ptr 1 next := .within ptr 1 (by have inside:=allocated.2.2.1; omega)
    have following : ∀ i : Fin rest.length, Read heap (element next i.val) rest[i] := by
      intro i
      have original := reads i.succ
      change Read heap (element ptr (i.val+1)) rest[i] at original
      change Read heap (element (element ptr 1) i.val) rest[i]
      rw [element_add]
      simpa only [Nat.add_comm] using original
    exact .cons ptr next input rest first advance (ih next following)

theorem to_reads (heap : Memory) (ptr : ArrayPointer) (inputs : List (BitVec 16))
    (words : CodecWords heap ptr inputs) : ∀ i : Fin inputs.length, Read heap (element ptr i.val) inputs[i] := by
  intro i
  exact decoder_read heap _ _ (KeygenCodecNoneMemoryIdentity.words_readback heap ptr inputs words i)

theorem words_iff_reads (heap : Memory) (ptr : ArrayPointer) (inputs : List (BitVec 16)) :
    CodecWords heap ptr inputs ↔ ∀ i : Fin inputs.length, Read heap (element ptr i.val) inputs[i] :=
  ⟨to_reads heap ptr inputs,from_reads heap ptr inputs⟩

end FT1536.Source3.KeygenInt16Words076
