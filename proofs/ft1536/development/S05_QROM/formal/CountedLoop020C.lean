import CapCore020B

namespace FT1536.S05.CountedLoop020C
open WordRAM020 ReadSemantics020A CapCore020B
attribute [local irreducible] loopState

/-- Counted-loop induction on the existing machine, with an arbitrary
    indexed invariant and transitive frame. No table or probability input. -/
theorem counted (f : State → State) (g : Expr)
    (Inv : Nat → State → Prop) (Rel : State → State → Prop) (cap : Nat)
    (reflR : ∀ s, Rel s s)
    (transR : ∀ {s t u}, Rel s t → Rel t u → Rel s u)
    (step : ∀ k s, k<cap → Inv k s →
      eval s g≠0 ∧ Inv (k+1) (f s) ∧ Rel s (f s))
    (count k : Nat) (s : State) (budget : k+count≤cap) (inv : Inv k s) :
    Inv (k+count) (loopState f g count s) ∧ Rel s (loopState f g count s) := by
  induction count generalizing k s with
  | zero => simpa only [loop_zero,Nat.add_zero] using And.intro inv (reflR s)
  | succ count ih =>
    have hstep := step k s (by omega) inv
    rw [loop_succ,ite_eq_right hstep.1]
    have post := ih (k+1) (f s) (by omega) hstep.2.1
    have hi : k+(count+1)=(k+1)+count := by omega
    rw [hi]
    exact ⟨post.1,transR hstep.2.2 post.2⟩

end FT1536.S05.CountedLoop020C
