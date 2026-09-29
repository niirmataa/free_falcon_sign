import PackOf
set_option maxHeartbeats 2000000
namespace RootLDL
def step (v : Nat) (s : Nat × Nat) : Nat × Nat :=
  if v≤s.1 then (2*(s.1-v),2*(s.2+1)) else (2*s.1,2*s.2)
def loop (v : Nat) : Nat → Nat × Nat → Nat × Nat
  | 0,s => s
  | k+1,s => loop v k (step v s)
theorem step_range (v r q : Nat) (hr : r<2*v) : (step v (r,q)).1<2*v := by
  unfold step
  split <;> omega
theorem step_invariant (v r q : Nat) :
    (step v (r,q)).1+(step v (r,q)).2*v=2*(r+q*v) := by
  unfold step
  split
  · rename_i h
    simp only [Nat.mul_add,Nat.add_mul,Nat.mul_assoc,Nat.one_mul]
    omega
  · simp only [Nat.mul_add,Nat.mul_assoc]
theorem loop_range (v k r q : Nat) (hr : r<2*v) : (loop v k (r,q)).1<2*v := by
  induction k generalizing r q with
  | zero => exact hr
  | succ k ih =>
    exact ih (step v (r,q)).1 (step v (r,q)).2 (step_range v r q hr)
theorem loop_invariant (v k r q : Nat) :
    (loop v k (r,q)).1+(loop v k (r,q)).2*v=2^k*(r+q*v) := by
  induction k generalizing r q with
  | zero => simp [loop]
  | succ k ih =>
    rw [loop,ih,step_invariant,Nat.pow_succ]
    simp only [Nat.mul_assoc]
theorem loop55 (u v : Nat) (hu : 4503599627370496≤u ∧ u<9007199254740992)
    (hv : 4503599627370496≤v ∧ v<9007199254740992) :
    (loop v 55 (u,0)).1<2*v ∧
    (loop v 55 (u,0)).1+(loop v 55 (u,0)).2*v=36028797018963968*u := by
  constructor
  · exact loop_range v 55 u 0 (by omega)
  · simpa using loop_invariant v 55 u 0
end RootLDL
