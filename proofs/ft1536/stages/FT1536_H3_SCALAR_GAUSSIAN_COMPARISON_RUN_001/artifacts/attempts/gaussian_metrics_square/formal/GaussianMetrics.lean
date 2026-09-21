import GaussianIntervals
namespace GaussianComparison
theorem normalization_variance_identity (C A E W2 : Int) (h : E=W2-2*A+C) :
    C*W2-A^2=C*E-(A-C)^2 := by grind
theorem squared_sum_bound (a b : Int) : (a+b)^2≤2*a^2+2*b^2 := by
  have h:=Int.mul_self_nonneg (a-b)
  grind
theorem normalization_point_bound (C A w r d t : Int)
    (hc : 0≤C) (hr : 0≤r) (hd : -d≤w-r ∧ w-r≤d)
    (ht : -t≤C-A ∧ C-A≤t) :
    -(C*d+r*t)≤C*w-A*r ∧ C*w-A*r≤C*d+r*t := by
  have h1:=Int.mul_le_mul_of_nonneg_left hd.1 hc
  have h2:=Int.mul_le_mul_of_nonneg_left hd.2 hc
  have h3:=Int.mul_le_mul_of_nonneg_left ht.1 hr
  have h4:=Int.mul_le_mul_of_nonneg_left ht.2 hr
  grind
theorem accepted_mass_lower (A C err : Int) (h : -err≤A-C) : C-err≤A := by omega
def AbsolutelyContinuous (p q : Int→Prop) := ∀y,p y→q y
theorem finite_support_reverse_failure (p q : Int→Prop) (s : Int)
    (hp : ∀y,s+366<y→¬p y) (hq : ∀y,q y) : ¬AbsolutelyContinuous q p := by
  intro h;exact hp (s+367) (by omega) (h (s+367) (hq (s+367)))
theorem conditioned_support (p : Int→Prop) : AbsolutelyContinuous p (fun _=>True) := by intro _ _;trivial
theorem tail_is_nonnegative (t : Int) (h : 0≤t) : 1-t≤1 := by omega
end GaussianComparison
