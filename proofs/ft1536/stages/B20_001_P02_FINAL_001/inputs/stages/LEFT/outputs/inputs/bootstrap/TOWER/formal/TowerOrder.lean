import TowerShape
namespace Tower
inductive Event where
  | split (k : Nat)
  | localLDL (k off : Nat)
  | leaf (off : Nat)
  deriving DecidableEq,Repr
def trace : Nat → Nat → List Event
  | 0,off => [.localLDL 1 off,.leaf (off+2),.leaf (off+3)]
  | d+1,off =>
    [.split (d+2)]++trace d (off+2^(d+2))++[.localLDL (d+2) off,.split (d+2)]++
      trace d (off+2^(d+2)+words d)
theorem actual_order (d off : Nat) :
    trace (d+1) off=[.split (d+2)]++trace d (off+2^(d+2))++
    [.localLDL (d+2) off,.split (d+2)]++trace d (off+2^(d+2)+words d) := by rfl
theorem actual_base (off : Nat) : trace 0 off=[.localLDL 1 off,.leaf (off+2),.leaf (off+3)] := by rfl
def store {α : Type} (mem : Nat → α) (a : Nat) (v : α) : Nat → α := fun i=>if i=a then v else mem i
def stores {α : Type} (mem : Nat → α) : List (Nat × α) → Nat → α
  | [] => mem
  | (a,v)::ws => stores (store mem a v) ws
theorem frame {α : Type} (mem : Nat → α) (ws : List (Nat × α)) (keep : Nat → Prop)
    (hd : ∀w∈ws,¬keep w.1) : ∀i,keep i → stores mem ws i=mem i := by
  induction ws generalizing mem with
  | nil => intro i _;rfl
  | cons w ws ih =>
    intro i hi
    have ht : ∀v∈ws,¬keep v.1 := by intro v hv;exact hd v (by simp [hv])
    rw [stores,ih (store mem w.1 w.2) ht i hi]
    have he : i≠w.1 := by intro h;subst i;exact hd w (by simp) hi
    simp only [store,ite_eq_right he]
theorem partition (d base i : Nat) (hi : base≤i ∧ i<base+words (d+1)) :
    (base≤i ∧ i<base+2^(d+2)) ∨
    (base+2^(d+2)≤i ∧ i<base+2^(d+2)+words d) ∨
    (base+2^(d+2)+words d≤i ∧ i<base+2^(d+2)+2*words d) := by
  simp only [words] at hi
  omega
end Tower
