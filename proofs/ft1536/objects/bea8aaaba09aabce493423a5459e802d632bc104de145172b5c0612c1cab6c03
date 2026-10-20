import Source3.C99HelperExists

namespace FT1536.Source3.C99HelperShape
open C99HelperReference
def Shape (a b : State) : Prop := b.heap.size=a.heap.size ∧ b.heap.writable=a.heap.writable
theorem trans {a b c : State} (h1 : Shape a b) (h2 : Shape b c) : Shape a c :=
  ⟨h2.1.trans h1.1,h2.2.trans h1.2⟩
theorem positive_shape (l : StableBinary.Layout) (s out : State) (w z : Word)
    (h : Positive l s w z out) : Shape s out := by
  obtain ⟨_,_,_,hw⟩ := (C99CheckBridge.check_iff _ _ _ _ _).mp h.1
  exact ⟨hw.2.2.2.1,hw.2.2.2.2.1⟩
theorem store_shape (p : C99MemoryReference.ArrayPointer) (s out : State) (w : Word)
    (h : Store p s w out) : Shape s out := ⟨h.1.2.2.2.1,h.1.2.2.2.2.1⟩
theorem pair_shape (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (start u : Nat)
    (s out : State) (a b : Word) (h : Pair l code start u s a b out) : Shape s out := by
  cases h with
  | step mid _ x _ y _ _ hx _ hy => exact trans (positive_shape _ _ _ _ _ hx) (positive_shape _ _ _ _ _ hy)
theorem gram_shape (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (s out : State)
    (a b sum product : Word) (h : Gram l code a b s sum product out) : Shape s out := by
  cases h with
  | step mid _ rawSum _ rawProduct _ _ hx _ hy => exact trans (positive_shape _ _ _ _ _ hx) (positive_shape _ _ _ _ _ hy)
theorem half_shape (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (u : Nat)
    (s out : State) (sum : Word) (h : HalfStore l code u sum s out) : Shape s out := by
  cases h with
  | step mid _ raw w _ hc hw => exact trans (positive_shape _ _ _ _ _ hc) (store_shape _ _ _ _ hw)
theorem suffix_shape (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (u hn : Nat)
    (s out : State) (product sum : Word) (h : Suffix l code u hn product sum s out) : Shape s out := by
  cases h with
  | step mid _ twice raw w _ _ hc hw => exact trans (positive_shape _ _ _ _ _ hc) (store_shape _ _ _ _ hw)
theorem step_shape (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (start u hn : Nat)
    (s out : State) (h : Step l code start u hn s out) : Shape s out := by
  cases h with
  | step sp sg sh _ a b sum product hp hg hh hs =>
      exact trans (trans (trans (pair_shape _ _ _ _ _ _ _ _ hp) (gram_shape _ _ _ _ _ _ _ _ hg))
        (half_shape _ _ _ _ _ _ hh)) (suffix_shape _ _ _ _ _ _ _ _ hs)
theorem loop_shape (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (start hn u : Nat)
    (s out : State) (h : Loop l code start hn u s out) : Shape s out := by
  induction h with
  | zero _ => exact ⟨rfl,rfl⟩
  | next u s mid out _ _ hb ih => exact trans ih (step_shape _ _ _ _ _ _ _ hb)
theorem copy_shape (l : StableBinary.Layout) (start n : Nat) (s out : State) (h : Copy l start n s out) : Shape s out := by
  obtain ⟨_,_,_,_,_,_,_,hs,hw,_,_⟩ := h.1
  exact ⟨hs,hw⟩
theorem execute_shape (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (n start : Nat)
    (s out : State) (h : Exec l code n start s out) : Shape s out := by
  induction h with
  | base n start s mid out w z _ _ hc hw => exact trans (positive_shape _ _ _ _ _ hc) (store_shape _ _ _ _ hw)
  | branch n start s sl sc left out _ _ _ hl _ hc _ _ ihl ihr =>
      exact trans (trans (trans (loop_shape _ _ _ _ _ _ _ hl) (copy_shape _ _ _ _ _ hc)) ihl) ihr
theorem pinned_shape (l : StableBinary.Layout) (n : Nat) (before after : C99MemoryReference.Memory)
    (checks : List Word) (h : PinnedExec l n before after checks) : after.size=before.size ∧ after.writable=before.writable := by
  obtain ⟨code,_,hr⟩ := h
  exact execute_shape _ _ _ _ _ _ hr

end FT1536.Source3.C99HelperShape

#print axioms FT1536.Source3.C99HelperShape.pinned_shape
