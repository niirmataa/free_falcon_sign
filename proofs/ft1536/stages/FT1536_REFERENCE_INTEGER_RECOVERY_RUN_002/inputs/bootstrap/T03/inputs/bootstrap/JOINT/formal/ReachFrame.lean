import ReachOutcomes
namespace OrderedReach
-- T allocation0..10751; immutable K is placed at32768 in this tagged flat model.
theorem key_and_root_target_frame {W : Type} (mem : Nat → W) (ws : List (Nat×W))
    (hw : ∀w∈ws,3072≤w.1 ∧ w.1<8702) :
    ∀i,(i<3072 ∨ 8702≤i) → RootLDL.runStores mem ws i=mem i := by
  induction ws generalizing mem with
  | nil => intro i _;rfl
  | cons w ws ih =>
    intro i hi
    have ht : ∀v∈ws,3072≤v.1 ∧ v.1<8702 := by intro v hv;exact hw v (by simp [hv])
    rw [RootLDL.runStores,ih (RootLDL.store mem w) ht i hi]
    have hn : i≠w.1 := by have h:=hw w (by simp);omega
    simp [RootLDL.store,hn]
def scratch : Nat → Nat
  | 0 => 0
  | k+1 => 2^(k+1)+scratch k
theorem scratch_formula (k : Nat) : scratch k+2=2^(k+1) := by
  induction k with
  | zero => decide
  | succ k ih => simp only [scratch,Nat.pow_succ] at *;omega
theorem root_peak : (6144+1536+512+scratch 8:Nat)=8702 ∧ (8702:Nat)<10752 := by decide
def visits : Nat → Nat
  | 0 => 2
  | k+1 => 2*visits k
theorem structural_calls (k : Nat) : visits k=2^(k+1) := by
  induction k with
  | zero => decide
  | succ k ih => simp [visits,ih,Nat.pow_succ,Nat.mul_comm]
theorem right_and_whole_counts : (3*visits 8:Nat)=1536 ∧ (2*3*visits 8:Nat)=3072 := by decide
theorem terminal_inverse_identity (a b c : Int) : (2*a-c*b)+c*b=2*a := by omega
theorem repeated_product_same_inputs {V : Type} (multiply : V → V → V) (a b oldA oldB : V)
    (ha : a=oldA) (hb : b=oldB) : multiply a b=multiply oldA oldB := by rw [ha,hb]
theorem rounded_cancellation_requires_error (a p u v e1 e2 : Int)
    (h1 : u=a+p+e1) (h2 : v=u-p+e2) : v=a+e1+e2 := by omega
end OrderedReach
