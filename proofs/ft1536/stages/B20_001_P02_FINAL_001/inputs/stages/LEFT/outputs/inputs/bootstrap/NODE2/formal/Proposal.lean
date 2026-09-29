import Floor
set_option maxRecDepth 8192
set_option maxHeartbeats 3000000
namespace H3Range
def above (r : Nat) : List Nat → Nat
  | [] => 0
  | t::ts => (if r<t then 1 else 0)+above r ts
def nonzero : List Nat → Nat
  | [] => 0
  | t::ts => (if t=0 then 0 else 1)+nonzero ts
theorem scan_bound (r : Nat) (ts : List Nat) : above r ts≤nonzero ts := by
  induction ts with
  | nil => exact Nat.le_refl 0
  | cons t ts ih =>
    unfold above nonzero
    split <;> split <;> omega
theorem max_at_zero (ts : List Nat) : above 0 ts=nonzero ts := by
  induction ts with
  | nil => rfl
  | cons t ts ih => unfold above nonzero;rw [ih];split <;> split <;> omega
-- Sequential branchless selection: the first eligible bank only.
def select : List (Bool × Nat) → Bool → Nat → Nat
  | [],_,s => s
  | (ge,k)::ls,found,s => select ls (found||ge) (s+if (!found && ge) then k else 0)
theorem select_found (ls : List (Bool × Nat)) (s : Nat) : select ls true s=s := by
  induction ls with
  | nil => rfl
  | cons p ls ih => cases p; simpa [select] using ih
theorem select_bound (ls : List (Bool × Nat)) (cap : Nat) (h : ∀ p, p∈ls → p.2≤cap) : select ls false 0≤cap := by
  induction ls with
  | nil => simp [select]
  | cons p ls ih =>
    rcases p with ⟨ge,k⟩
    cases ge
    · exact ih (fun p hp => h p (List.mem_cons_of_mem _ hp))
    · simpa [select,select_found] using h (true,k) (by simp)
def proposalZ (k : Nat) (b : Bool) : Int := if b then 1+(k:Int) else -(k:Int)
theorem proposal_support (k : Nat) (hk : k≤365) (b : Bool) : -365≤proposalZ k b ∧ proposalZ k b≤366 := by
  unfold proposalZ;cases b <;> simp only [Bool.false_eq_true,↓reduceIte] <;> omega
theorem proposal_return_safe (s : Int) (hs : -2147483283≤s ∧ s≤2147483281) (k : Nat) (hk : k≤365) (b : Bool) :
    -2147483648≤s+proposalZ k b ∧ s+proposalZ k b≤2147483647 := (integer_safety s _ hs (proposal_support k hk b)).2.2
#check @scan_bound
#check @select_bound
#check @proposal_return_safe
#print axioms scan_bound
#print axioms max_at_zero
#print axioms select_found
#print axioms select_bound
#print axioms proposal_support
#print axioms proposal_return_safe
end H3Range
