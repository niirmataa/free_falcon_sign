import ArrayBank020E4

namespace FT1536.S05.CostRun020E4

/-- Instrumented computation. Units are defined at primitive sites, not
    inferred from the compiler's wall clock. allocated counts cumulative
    charged words, providing a no-reclamation upper envelope. -/
structure Run (A : Type) where
  value : A
  ticks : Nat
  allocated : Nat

def pure {A : Type} (a : A) : Run A := ⟨a,0,0⟩
def bind {A B : Type} (a : Run A) (f : A → Run B) : Run B :=
  let b := f a.value
  ⟨b.value,a.ticks+b.ticks,a.allocated+b.allocated⟩

def charge {A : Type} (ticks allocated : Nat) (a : A) : Run A := ⟨a,ticks,allocated⟩

def map {A B : Type} (f : A → B) (a : Run A) : Run B := ⟨f a.value,a.ticks,a.allocated⟩

theorem bind_value {A B : Type} (a : Run A) (f : A → Run B) : (bind a f).value=(f a.value).value := rfl

theorem bind_ticks {A B : Type} (a : Run A) (f : A → Run B) :
    (bind a f).ticks=a.ticks+(f a.value).ticks := rfl

theorem bind_allocated {A B : Type} (a : Run A) (f : A → Run B) :
    (bind a f).allocated=a.allocated+(f a.value).allocated := rfl

def Bounded {A : Type} (r : Run A) (t m : Nat) : Prop := r.ticks≤t ∧ r.allocated≤m

theorem bind_bound {A B : Type} (a : Run A) (f : A → Run B) (t m u v : Nat)
    (ha : Bounded a t m) (hb : ∀ x,Bounded (f x) u v) : Bounded (bind a f) (t+u) (m+v) :=
  ⟨Nat.add_le_add ha.1 (hb _).1,Nat.add_le_add ha.2 (hb _).2⟩

/-- Every prefix of a nonnegative allocation ledger is bounded by its total.
    A sharper live-space result requires explicit reclamation/lifetime evidence. -/
theorem prefix_allocation_bound (xs ys : List Nat) : xs.sum≤(xs++ys).sum := by
  rw [List.sum_append]
  omega

end FT1536.S05.CostRun020E4
