import Std
namespace RootLDL
def store {α : Type} (mem : Nat → α) (w : Nat × α) : Nat → α :=
  fun i => if i=w.1 then w.2 else mem i
def runStores {α : Type} (mem : Nat → α) : List (Nat × α) → Nat → α
  | [] => mem
  | w::ws => runStores (store mem w) ws
theorem store_frame {α : Type} (mem : Nat → α) (w : Nat × α)
    (i : Nat) (hi : i<4608) (hw : 4608≤w.1) : store mem w i=mem i := by
  simp [store,show i≠w.1 by omega]
theorem root_frame {α : Type} (mem : Nat → α) (ws : List (Nat × α))
    (hw : ∀w∈ws,4608≤w.1) : ∀i<4608,runStores mem ws i=mem i := by
  induction ws generalizing mem with
  | nil => intro i _;rfl
  | cons w ws ih =>
    intro i hi
    have ht : ∀v∈ws,4608≤v.1 := by intro v hv;exact hw v (by simp [hv])
    rw [runStores,ih (store mem w) ht i hi]
    exact store_frame mem w i hi (hw w (by simp))
theorem root_layout : (3*1536=4608) ∧ (1536/2=768) ∧
    (3*1536+3*512=6144) ∧ (4*1536+18432=24576) := by decide
theorem fft_partition (i : Nat) (hi : i<768) :
    i<1536 ∧ i+768<1536 ∧ i≠i+768 := by omega
end RootLDL
