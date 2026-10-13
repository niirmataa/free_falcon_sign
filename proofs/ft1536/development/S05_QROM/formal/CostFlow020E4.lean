import CostRun020E4

namespace FT1536.S05.CostFlow020E4
open CostRun020E4

instance : Monad Run where
  pure := CostRun020E4.pure
  bind := CostRun020E4.bind

def overhead {A : Type} (n : Nat) (r : Run A) : Run A := ⟨r.value,n+r.ticks,n+r.allocated⟩

def optBind {A B : Type} (r : Run (Option A)) (f : A → Run (Option B)) : Run (Option B) :=
  CostRun020E4.bind r (fun v => overhead 1 (match v with | none => CostRun020E4.pure none | some x => f x))

theorem overhead_value {A : Type} (n : Nat) (r : Run A) : (overhead n r).value=r.value := rfl

theorem overhead_bound {A : Type} (n t m : Nat) (r : Run A) (h : Bounded r t m) :
    Bounded (overhead n r) (n+t) (n+m) := ⟨Nat.add_le_add_left h.1 n,Nat.add_le_add_left h.2 n⟩

theorem optBind_value {A B : Type} (r : Run (Option A)) (f : A → Run (Option B)) :
    (optBind r f).value=r.value.bind (fun x => (f x).value) := by
  cases h : r.value <;> simp only [optBind,CostRun020E4.bind,h,overhead,CostRun020E4.pure,Option.bind_none,Option.bind_some]

theorem optBind_bound {A B : Type} (r : Run (Option A)) (f : A → Run (Option B))
    (t m u v : Nat) (hr : Bounded r t m) (hf : ∀ x,Bounded (f x) u v) :
    Bounded (optBind r f) (t+1+u) (m+1+v) := by
  cases h : r.value with
  | none =>
    simp only [Bounded,optBind,CostRun020E4.bind,h,overhead,CostRun020E4.pure]
    rcases hr with ⟨hrt,hrm⟩
    constructor <;> omega
  | some x =>
    simp only [Bounded,optBind,CostRun020E4.bind,h,overhead]
    rcases hr with ⟨hrt,hrm⟩
    rcases hf x with ⟨hxt,hxm⟩
    constructor <;> omega

end FT1536.S05.CostFlow020E4
