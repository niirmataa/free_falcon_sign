import Source3.C99MemoryAccess

/- Initialization is monotone under defined stores and memcpy. This is a
   property of primitive memory transitions, not a contract assigned to an
   unverified callee. A source execution must supply the concrete transitions
   before this invariant can be used at a function boundary. -/
namespace FT1536.Source3.C99InitializationTrace
open C99MemoryReference

def Initialized (h : Memory) (block offset count : Nat) : Prop :=
  ∀ i<count, (h.bytes block (offset+i)).isSome

structure Preserves (before after : Memory) : Prop where
  size : after.size=before.size
  writable : after.writable=before.writable
  initialized : ∀ block offset, (before.bytes block offset).isSome → (after.bytes block offset).isSome

theorem preserves_refl (h : Memory) : Preserves h h := ⟨rfl,rfl,fun _ _ h => h⟩
theorem preserves_trans (a b c : Memory) (hab : Preserves a b) (hbc : Preserves b c) : Preserves a c :=
  ⟨hbc.size.trans hab.size,hbc.writable.trans hab.writable,
    fun block offset h => hbc.initialized block offset (hab.initialized block offset h)⟩

theorem region_preserved (before after : Memory) (h : Preserves before after)
    (block offset count : Nat) (hi : Initialized before block offset count) :
    Initialized after block offset count := by
  intro i hin
  exact h.initialized block (offset+i) (hi i hin)

theorem store64_preserves (before after : Memory) (p : ArrayPointer) (w : BitVec 64)
    (h : Store64 before p w after) : Preserves before after := by
  refine ⟨h.2.2.2.1,h.2.2.2.2.1,?_⟩
  intro block offset hi
  by_cases inside : block=p.block ∧ p.offset≤offset ∧ offset<p.offset+8
  · obtain ⟨rfl,hlo,hhi⟩ := inside
    let j : Fin 8 := ⟨offset-p.offset,by omega⟩
    have he : p.offset+j.val=offset := by dsimp [j]; omega
    have hw := h.2.2.2.2.2.1 j
    rw [he] at hw
    rw [hw]
    rfl
  · have hf := h.2.2.2.2.2.2 block offset (by omega)
    rw [hf]
    exact hi

theorem store32_preserves (before after : Memory) (p : ArrayPointer) (w : BitVec 32)
    (h : Store32 before p w after) : Preserves before after := by
  refine ⟨h.2.2.2.1,h.2.2.2.2.1,?_⟩
  intro block offset hi
  by_cases inside : block=p.block ∧ p.offset≤offset ∧ offset<p.offset+4
  · obtain ⟨rfl,hlo,hhi⟩ := inside
    let j : Fin 4 := ⟨offset-p.offset,by omega⟩
    have he : p.offset+j.val=offset := by dsimp [j]; omega
    have hw := h.2.2.2.2.2.1 j
    rw [he] at hw
    rw [hw]
    rfl
  · rw [h.2.2.2.2.2.2 block offset (by omega)]
    exact hi

theorem memcpy_preserves (before after : Memory) (dst src : ArrayPointer) (count : Nat)
    (h : Memcpy before dst src count after) : Preserves before after := by
  obtain ⟨_,_,_,_,_,_,hread,hs,hw,hcopy,hframe⟩ := h
  refine ⟨hs,hw,?_⟩
  intro block offset hi
  by_cases inside : block=dst.block ∧ dst.offset≤offset ∧ offset<dst.offset+count
  · obtain ⟨rfl,hlo,hhi⟩ := inside
    have hj : offset-dst.offset<count := by omega
    have he : dst.offset+(offset-dst.offset)=offset := by omega
    have hc := hcopy (offset-dst.offset) hj
    rw [he] at hc
    rw [hc]
    exact hread _ hj
  · rw [hframe block offset (by omega)]
    exact hi

theorem memcpy_initializes (before after : Memory) (dst src : ArrayPointer) (count : Nat)
    (h : Memcpy before dst src count after) : Initialized after dst.block dst.offset count := by
  obtain ⟨_,_,_,_,_,_,hread,_,_,hcopy,_⟩ := h
  intro i hi
  rw [hcopy i hi]
  exact hread i hi

inductive Steps : Memory → Memory → Prop where
  | done (h : Memory) : Steps h h
  | write64 (before middle after : Memory) (p : ArrayPointer) (w : BitVec 64)
      (write : Store64 before p w middle) (rest : Steps middle after) : Steps before after
  | write32 (before middle after : Memory) (p : ArrayPointer) (w : BitVec 32)
      (write : Store32 before p w middle) (rest : Steps middle after) : Steps before after
  | copy (before middle after : Memory) (dst src : ArrayPointer) (count : Nat)
      (copy : Memcpy before dst src count middle) (rest : Steps middle after) : Steps before after

theorem steps_preserve (before after : Memory) (h : Steps before after) : Preserves before after := by
  induction h with
  | done h => exact preserves_refl h
  | write64 before middle after p w hw rest ih =>
      exact preserves_trans before middle after (store64_preserves before middle p w hw) ih
  | write32 before middle after p w hw rest ih =>
      exact preserves_trans before middle after (store32_preserves before middle p w hw) ih
  | copy before middle after dst src count hc rest ih =>
      exact preserves_trans before middle after (memcpy_preserves before middle dst src count hc) ih

theorem steps_trans (a b c : Memory) (hab : Steps a b) (hbc : Steps b c) : Steps a c := by
  induction hab with
  | done => exact hbc
  | write64 before middle after p w hw rest ih => exact Steps.write64 before middle c p w hw (ih hbc)
  | write32 before middle after p w hw rest ih => exact Steps.write32 before middle c p w hw (ih hbc)
  | copy before middle after dst src count hc rest ih => exact Steps.copy before middle c dst src count hc (ih hbc)

end FT1536.Source3.C99InitializationTrace
