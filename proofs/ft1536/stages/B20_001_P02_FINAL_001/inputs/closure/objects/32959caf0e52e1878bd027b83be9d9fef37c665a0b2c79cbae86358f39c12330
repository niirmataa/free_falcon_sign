import LeftClosure
import IidRejection
namespace OrderedJoint
def innerCalls : Nat → Nat | 0=>2 | k+1=>2*innerCalls k
def depthCalls (k : Nat) := 3*innerCalls (k-1)
def rootCalls (k : Nat) := 2*depthCalls (k-1)
theorem inner_count (k : Nat) : innerCalls k=2^(k+1) := by
  induction k with
  | zero => rfl
  | succ k ih => simp only [innerCalls,ih,Nat.pow_succ];omega
theorem root_count : rootCalls 10=3072 := by decide
theorem branch_count : depthCalls 9=1536 := by decide
def scratch : Nat → Nat | 0=>0 | k+1=>2^(k+1)+scratch k
theorem scratch_size (k : Nat) : scratch k+2=2^(k+1) := by
  induction k with
  | zero => rfl
  | succ k ih => simp only [scratch,Nat.pow_succ] at *;omega
theorem root_frame : 6144+1536+512+scratch 8=8702 ∧ 8702≤10752 := by decide
theorem call_pair_counts : (3072/2:Nat)=1536 ∧ (1536/2:Nat)=768 := by decide
theorem correlated_branch_budget : (768*849346588:Nat)=652298179584 := by decide
end OrderedJoint
