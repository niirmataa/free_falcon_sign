import CostFlow020E4

namespace FT1536.S05.CostBounds020E4
open CostRun020E4 CostFlow020E4

theorem weaken {A : Type} {r : Run A} {t m u v : Nat} (h : Bounded r t m)
    (ht : t≤u) (hm : m≤v) : Bounded r u v := ⟨h.1.trans ht,h.2.trans hm⟩

theorem map_bound {A B : Type} (f : A → B) (r : Run A) (t m : Nat)
    (h : Bounded r t m) : Bounded (CostRun020E4.map f r) t m := h

theorem optBind_bound_on {A B : Type} (r : Run (Option A)) (f : A → Run (Option B))
    (t m u v : Nat) (hr : Bounded r t m)
    (hf : ∀ x,r.value=some x → Bounded (f x) u v) :
    Bounded (optBind r f) (t+1+u) (m+1+v) := by
  cases h : r.value with
  | none =>
    simp only [Bounded,optBind,CostRun020E4.bind,h,overhead,CostRun020E4.pure]
    rcases hr with ⟨hrt,hrm⟩
    constructor <;> omega
  | some x =>
    simp only [Bounded,optBind,CostRun020E4.bind,h,overhead]
    rcases hr with ⟨hrt,hrm⟩
    rcases hf x h with ⟨hxt,hxm⟩
    constructor <;> omega

end FT1536.S05.CostBounds020E4
