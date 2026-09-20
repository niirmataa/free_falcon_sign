import BinaryConstants
set_option maxRecDepth 16384
set_option maxHeartbeats 2000000
namespace Tower
-- d represents source logn d+1; there is no source inner0.
def words : Nat → Nat
  | 0 => 4
  | d+1 => 2^(d+2)+2*words d
def internal : Nat → Nat
  | 0 => 2
  | d+1 => 2^(d+2)+2*internal d
def leaves : Nat → Nat
  | 0 => 2
  | d+1 => 2*leaves d
theorem words_formula (d : Nat) : words d=(d+2)*2^(d+1) := by
  induction d with
  | zero => decide
  | succ d ih => simp only [words,ih,Nat.pow_succ];grind
theorem internal_formula (d : Nat) : internal d=(d+1)*2^(d+1) := by
  induction d with
  | zero => decide
  | succ d ih => simp only [internal,ih,Nat.pow_succ];grind
theorem leaves_formula (d : Nat) : leaves d=2^(d+1) := by
  induction d with
  | zero => decide
  | succ d ih => simp only [leaves,ih,Nat.pow_succ];omega
def scratch : Nat → Nat
  | 0 => 2
  | d+1 => max (2^(d+2)+scratch d) (2*2^(d+2))
theorem scratch_bound (d : Nat) : scratch d≤2*2^(d+1) := by
  induction d with
  | zero => decide
  | succ d ih =>
    simp only [scratch,Nat.pow_succ] at *
    omega
theorem twelve_subtrees : 12*words 6=12288 ∧ 12*internal 6=10752 ∧ 12*leaves 6=1536 ∧ scratch 6≤256 := by decide
theorem assembly_count : (10752+1536+3072+1536:Nat)=16896 ∧ (16896+1536:Nat)=18432 := by decide
theorem coverage (l : Nat) (hl : 1≤l ∧ l≤7) :
    6*2^(8-l)*2^(l-1)=768 := by
  have hp : (8-l)+(l-1)=7 := by omega
  rw [Nat.mul_assoc,←Nat.pow_add,hp]
end Tower
