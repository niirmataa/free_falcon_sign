import RootFrame
namespace Node3
theorem store_prefix {α : Type} (mem : Nat → α) (w : Nat × α) (cut i : Nat)
    (hi : i<cut) (hw : cut≤w.1) : RootLDL.store mem w i=mem i := by
  simp [RootLDL.store,show i≠w.1 by omega]
theorem node_frame {α : Type} (mem : Nat → α) (ws : List (Nat × α))
    (hw : ∀w∈ws,1536≤w.1) : ∀i<1536,RootLDL.runStores mem ws i=mem i := by
  induction ws generalizing mem with
  | nil => intro i _;rfl
  | cons w ws ih =>
    intro i hi
    have ht : ∀v∈ws,1536≤v.1 := by intro v hv;exact hw v (by simp [hv])
    rw [RootLDL.runStores,ih (RootLDL.store mem w) ht i hi]
    exact store_prefix mem w 1536 i hi (hw w (by simp))
theorem layout : (3*512=1536) ∧ (1536+3*512+512=3584) ∧ (3*512+3*(9*256)=8448) := by decide
end Node3
