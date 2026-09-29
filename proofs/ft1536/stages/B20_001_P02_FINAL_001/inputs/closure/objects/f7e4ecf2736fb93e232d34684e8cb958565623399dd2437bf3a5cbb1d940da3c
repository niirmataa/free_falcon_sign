import JointPrefix
import GaussianMetrics
namespace OrderedJoint
theorem conditioning_second_moment (q t c : Int) :
    (q-t)*(q+c)-q^2=q*c-t*(q+c) := by grind
theorem conditioning_decreases (q t c : Int) (ht : 0≤t) (hc : 0≤q+c) :
    (q-t)*(q+c)-q^2≤q*c := by
  have h:=Int.mul_nonneg ht hc
  rw [conditioning_second_moment];omega
theorem weighted_step_bound (xs : List (Int×Int)) (B : Int)
    (h : ∀p∈xs,0≤p.1 ∧ 0≤p.2 ∧ p.2≤B) :
    (xs.map fun p=>p.1*p.2).sum≤B*(xs.map Prod.fst).sum := by
  exact (GaussianComparison.weighted_bounds xs 0 B h).2
theorem second_moment_chain (v : Nat→Nat) (B : Nat) (h0 : v 0≤1)
    (step : ∀i,v (i+1)≤v i*B) : ∀i,v i≤B^i := by
  intro i;induction i with
  | zero => simpa using h0
  | succ i ih => exact Nat.le_trans (step i) (by simpa [Nat.pow_succ] using Nat.mul_le_mul_right B ih)
theorem survival_tilt_cleared (p s q D Z : Int) (hq : q=s*D) (hp : p*Z=q) : p*Z=s*D := by omega
theorem reverse_support_same {A : Type} (p q : A→Prop) (h : ∀a,p a↔q a) :
    (∀a,p a→q a) ∧ (∀a,q a→p a) := by
  exact ⟨fun a=> (h a).mp,fun a=> (h a).mpr⟩
theorem numerical_chi_bound : (3*2^48:Nat)<2^50-3 := by decide
theorem tv_square_bound : (1:Nat)*2^50=4*2^48 := by decide
theorem union_epsilon : (3072:Nat)*2^26=3*2^36 := by decide
theorem reverse_exponent : (264*3072:Nat)=811008 := by decide
end OrderedJoint
