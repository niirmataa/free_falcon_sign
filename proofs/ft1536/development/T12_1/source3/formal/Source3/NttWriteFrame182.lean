import Source3.NttFirstBody182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttWriteFrame182
open C99MemoryReference (Memory ArrayPointer)
open KeygenSmallOutput (element)

abbrev Outside := MakeFgConversionFrame176.Outside
structure Frame (base : ArrayPointer) (n : Nat) (before after : Memory) : Prop where
  size : after.size=before.size
  writable : after.writable=before.writable
  bytes : ∀ block offset, Outside base n block offset → after.bytes block offset=before.bytes block offset

theorem refl (base : ArrayPointer) (n : Nat) (heap : Memory) : Frame base n heap heap := ⟨rfl,rfl,fun _ _ _ => rfl⟩
theorem trans (base : ArrayPointer) (n : Nat) (a b c : Memory) (first : Frame base n a b) (second : Frame base n b c) :
    Frame base n a c := ⟨second.size.trans first.size,second.writable.trans first.writable,
      fun block offset outside => (second.bytes block offset outside).trans (first.bytes block offset outside)⟩

theorem write (heap : Memory) (base : ArrayPointer) (n : Nat) (i : Fin n) (word : BitVec 32)
    (width : base.elementBytes=4) : Frame base n heap (Word32Memory176.write heap (element base i.val) word) := by
  refine ⟨rfl,rfl,?_⟩
  intro block offset outside
  have absent := MakeFgConversionFrame176.element_outside base width i block offset outside
  change ¬(block=(element base i.val).block ∧ (element base i.val).offset≤offset ∧ offset<(element base i.val).offset+4) at absent
  simp only [Word32Memory176.write,dite_eq_right absent]

theorem first_body (s : C99ArrayReference.State) (base : ArrayPointer) (n : Nat) (i j : Fin n)
    (a0 a1 w p p0i : BitVec 32) (width : base.elementBytes=4) :
    Frame base n s.heap (NttFirstBody182.after s (element base i.val) (element base j.val) a0 a1 w p p0i).heap :=
  trans base n _ _ _ (write s.heap base n i (NttFirstBody182.leftWord a0 a1 w p p0i) width)
    (write _ base n j (NttFirstBody182.rightWord a0 a1 w p p0i) width)

end FT1536.Source3.NttWriteFrame182
