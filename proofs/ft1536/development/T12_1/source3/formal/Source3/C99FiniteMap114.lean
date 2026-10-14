import Source3.C99MemoryReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Computable sparse maps for proof-producing concrete source execution.
   This is representation infrastructure; no execution or acceptance is
   assumed or established by constructing a map. -/
namespace FT1536.Source3.C99FiniteMap114

inductive Tree (α : Type) where
  | empty
  | node (value : Option α) (zero one : Tree α)
  deriving Repr, DecidableEq

def get (tree : Tree α) (key : List Bool) : Option α :=
  match tree, key with
  | .empty, _ => none
  | .node value _ _, [] => value
  | .node _ zero one, bit::rest => get (if bit then one else zero) rest

def set (tree : Tree α) (key : List Bool) (value : α) : Tree α :=
  match key, tree with
  | [], .empty => .node (some value) .empty .empty
  | [], .node _ zero one => .node (some value) zero one
  | bit::rest, .empty =>
      if bit then .node none .empty (set .empty rest value)
      else .node none (set .empty rest value) .empty
  | bit::rest, .node old zero one =>
      if bit then .node old zero (set one rest value)
      else .node old (set zero rest value) one

theorem get_set (tree : Tree α) (key other : List Bool) (value : α) :
    get (set tree key value) other = if other=key then some value else get tree other := by
  induction key generalizing tree other with
  | nil => cases tree <;> cases other <;> simp [set, get]
  | cons bit rest ih =>
      cases tree <;> cases other with
      | nil => cases bit <;> simp [set, get]
      | cons next tail => cases bit <;> cases next <;> simp [set, get, ih]

def digits (n : Nat) : List Bool :=
  if n=0 then [] else decide (n%2=1) :: digits (n/2)
termination_by n

def decode : List Bool → Nat
  | [] => 0
  | bit::rest => (if bit then 1 else 0) + 2*decode rest

theorem decode_digits (n : Nat) : decode (digits n) = n := by
  induction n using Nat.strongRecOn with
  | ind n ih =>
      rw [digits]
      by_cases zero : n=0
      · simp [zero, decode]
      · have smaller : n/2<n := Nat.div_lt_self (by omega) (by decide)
        have tail := ih (n/2) smaller
        have remainder := Nat.mod_lt n (by decide : 0<2)
        simp only [zero, ite_false, decode, tail]
        split <;> simp_all only [decide_eq_true_eq]
        all_goals omega

theorem digits_injective : Function.Injective digits := by
  intro a b equal
  have decoded := congrArg decode equal
  simpa only [decode_digits] using decoded

def lookup (tree : Tree α) (key : Nat) : Option α := get tree (digits key)
def insert (tree : Tree α) (key : Nat) (value : α) : Tree α := set tree (digits key) value

theorem lookup_insert (tree : Tree α) (key other : Nat) (value : α) :
    lookup (insert tree key value) other = if other=key then some value else lookup tree other := by
  rw [lookup, insert, get_set]
  simp only [digits_injective.eq_iff]
  rfl

end FT1536.Source3.C99FiniteMap114
