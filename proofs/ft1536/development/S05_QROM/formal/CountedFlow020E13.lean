import CoreCountBounds020E13

namespace FT1536.S05.CountedFlow020E13
open CoreCountTypes020E13

def optionBind {α β : Type} (x : Option α) (f : α → Report (Option β)) : Report (Option β) :=
  match x with
  | none => ⟨none,zero⟩
  | some a => f a

theorem optionBind_value {α β : Type} (x : Option α) (f : α → Report (Option β)) :
    (optionBind x f).value=x.bind (fun a => (f a).value) := by cases x <;> rfl

theorem optionBind_refines {α β : Type} (x : Option α) (f : α → Report (Option β))
    (g : α → Option β) (h : ∀ a,(f a).value=g a) : (optionBind x f).value=x.bind g := by
  cases x with
  | none => rfl
  | some a => exact h a

theorem optionBind_valid {α β : Type} (x : Option α) (f : α → Report (Option β))
    (fuel : Nat) (h : ∀ a,Valid (f a).counts fuel) : Valid (optionBind x f).counts fuel := by
  cases x with
  | none => exact zero_valid fuel
  | some a => exact h a

theorem select_value {α : Type} (b : Bool) (a c : Report α) :
    (if b then a else c).value=if b then a.value else c.value := by cases b <;> rfl

theorem select_valid {α : Type} (b : Bool) (a c : Report α) (fuel : Nat)
    (ha : Valid a.counts fuel) (hc : Valid c.counts fuel) :
    Valid (if b then a else c).counts fuel := by cases b <;> assumption

theorem map_refines {α β : Type} (f : α → β) (r : Report α) (v : α) (h : r.value=v) :
    (CoreCountTypes020E13.map f r).value=f v := congrArg f h

end FT1536.S05.CountedFlow020E13
