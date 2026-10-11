import ReadSemantics020A

/-! A table-independent first-success loop proof for the existing machine. -/
namespace FT1536.S05.CapCore020B
open WordRAM020 ReadSemantics020A

def firstFrom {A : Type} (trial : Nat → Option A) : Nat → Nat → Option A
  | 0,_ => none
  | count+1,k => match trial k with
    | some z => some z
    | none => firstFrom trial count (k+1)

theorem loop_zero (f : State → State) (g : Expr) (s : State) :
    loopState f g 0 s=s := rfl

theorem loop_succ (f : State → State) (g : Expr) (n : Nat) (s : State) :
    loopState f g (n+1) s=if eval s g=0 then s else loopState f g n (f s) := rfl

attribute [local irreducible] loopState

theorem stopped {A : Type} (f : State → State) (g : Expr)
    (answer : State → Option A) (guard : ∀ s, eval s g=0 ↔ answer s≠none)
    (count : Nat) (s : State) (hs : answer s≠none) : loopState f g count s=s := by
  cases count with
  | zero => exact loop_zero _ _ _
  | succ count => rw [loop_succ,ite_eq_left ((guard s).mpr hs)]

/-- `Inv` tracks the retry index. `Rel` preserves any desired frame; it is
    required only for executed steps. All failures and cap-zero are included. -/
theorem first_success {A : Type} (f : State → State) (g : Expr)
    (answer : State → Option A) (source : Nat → Option A)
    (Inv : Nat → State → Prop) (Rel : State → State → Prop) (cap : Nat)
    (reflR : ∀ s, Rel s s)
    (transR : ∀ {s t u}, Rel s t → Rel t u → Rel s u)
    (guard : ∀ s, eval s g=0 ↔ answer s≠none)
    (step : ∀ k s, k<cap → Inv k s → answer s=none →
      answer (f s)=source k ∧ Inv (k+1) (f s) ∧ Rel s (f s))
    (count k : Nat) (s : State) (budget : k+count≤cap)
    (inv : Inv k s) (empty : answer s=none) :
    answer (loopState f g count s)=firstFrom source count k ∧
      Rel s (loopState f g count s) := by
  induction count generalizing k s with
  | zero => rw [loop_zero]; exact ⟨empty,reflR s⟩
  | succ count ih =>
    have on : eval s g≠0 := fun he => ((guard s).mp he) empty
    rw [loop_succ,ite_eq_right on]
    have hs := step k s (by omega) inv empty
    cases ht : source k with
    | none =>
      have post := ih (k+1) (f s) (by omega) hs.2.1 (hs.1.trans ht)
      simp only [firstFrom,ht]
      exact ⟨post.1,transR hs.2.2 post.2⟩
    | some z =>
      have nonempty : answer (f s)≠none := by rw [hs.1,ht]; exact Option.some_ne_none z
      rw [stopped f g answer guard count (f s) nonempty]
      simp only [firstFrom,ht]
      exact ⟨hs.1.trans ht,hs.2.2⟩

theorem firstFrom_map {A B : Type} (source : Nat → Option A) (encode : A → B)
    (count k : Nat) :
    firstFrom (fun j => (source j).map encode) count k =
      (firstFrom source count k).map encode := by
  induction count generalizing k with
  | zero => rfl
  | succ count ih =>
    simp only [firstFrom]
    cases source k with
    | none => exact ih (k+1)
    | some z => rfl

end FT1536.S05.CapCore020B
