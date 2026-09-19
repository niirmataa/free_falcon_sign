import NodeFrame
namespace Node2
theorem input_frame {α : Type} (mem : Nat → α) (ws : List (Nat × α))
    (hw : ∀w∈ws,512≤w.1) : ∀i<512,RootLDL.runStores mem ws i=mem i := by
  induction ws generalizing mem with
  | nil => intro i _;rfl
  | cons w ws ih =>
    intro i hi
    have ht : ∀v∈ws,512≤v.1 := by intro v hv;exact hw v (by simp [hv])
    rw [RootLDL.runStores,ih (RootLDL.store mem w) ht i hi]
    exact Node3.store_prefix mem w 512 i hi (hw w (by simp))
theorem level_sizes : (2*256=512) ∧ (256+2*(8*128)=2304) ∧ (512+3*256=1280) := by decide
end Node2
