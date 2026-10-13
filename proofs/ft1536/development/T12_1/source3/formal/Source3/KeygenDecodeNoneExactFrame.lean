import Source3.KeygenDecodeNoneComplete

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact physical write extent from the actual ordered int16-store trace.
   Bytes after the decoded1536-word region, including an arbitrary tail,
   are preserved as a conclusion rather than a whole-codec frame premise. -/
namespace FT1536.Source3.KeygenDecodeNoneExactFrame
open KeygenDecodeValues KeygenDecodeExecution C99MemoryReference KeygenDecodeNoneMemory

def Window (dst : ArrayPointer) (n count : Nat) (a b : Memory) : Prop :=
  b.size=a.size ∧ b.writable=a.writable ∧
  ∀ block offset, block≠dst.block ∨ offset<dst.offset+2*n ∨ dst.offset+2*(n+count)≤offset →
    b.bytes block offset=a.bytes block offset

theorem element_offset (dst : ArrayPointer) (n : Nat) (width : dst.elementBytes=2) :
    (element dst n).offset=dst.offset+2*n := by
  simp only [element,ArrayPointer.offset,width,Nat.mul_add,Nat.add_assoc]

theorem trace_frame (dst : ArrayPointer) (a b : Memory) (n : Nat) (inputs : List (BitVec 16))
    (width : dst.elementBytes=2) (trace : Trace dst a b n inputs) : Window dst n inputs.length a b := by
  induction trace with
  | nil heap n => exact ⟨rfl,rfl,fun _ _ _ => rfl⟩
  | cons a middle b n input rest store tail ih =>
    refine ⟨ih.1.trans store.2.2.2.1,ih.2.1.trans store.2.2.2.2.1,?_⟩
    intro block offset outside
    have first : block≠(element dst n).block ∨ offset<(element dst n).offset ∨ (element dst n).offset+2≤offset := by
      rw [element_offset dst n width]
      change block≠dst.block ∨ offset<dst.offset+2*n ∨ dst.offset+2*n+2≤offset
      simp only [List.length_cons] at outside
      omega
    have later : block≠dst.block ∨ offset<dst.offset+2*(n+1) ∨ dst.offset+2*((n+1)+rest.length)≤offset := by
      simp only [List.length_cons] at outside
      omega
    exact (ih.2.2 block offset later).trans (store.2.2.2.2.2.2.2 block offset first)

end FT1536.Source3.KeygenDecodeNoneExactFrame
