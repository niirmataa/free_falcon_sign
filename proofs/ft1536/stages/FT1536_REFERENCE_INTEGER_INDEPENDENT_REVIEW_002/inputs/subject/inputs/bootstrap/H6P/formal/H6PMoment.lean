import H6PVariance
namespace H6P
theorem completing_square (y mu v t : Int) :
    -(y-mu)^2+2*v*t*(mu-y)= -(y-mu+v*t)^2+(v*t)^2 := by grind
theorem local_conditioning_count (part full mass : Int)
    (h : 0≤part ∧ part≤full) (hm : 0≤mass) : part*mass≤full*mass :=
  Int.mul_le_mul_of_nonneg_right h.2 hm
theorem conditional_product_bound (v : Nat→Nat) (C : Nat) (h0 : v 0≤1)
    (h : ∀n,v (n+1)≤v n*C) : ∀n,v n≤C^n :=
  OrderedJoint.second_moment_chain v C h0 h
theorem signed_union_count : (2*2*1536:Nat)=6144 := by decide
theorem event_factor_monotone (q b scale : Int)
    (h : 0≤q ∧ q≤b ∧ 2*b≤scale) : q*(scale-q)≤b*(scale-b) := by
  have hp:=Int.mul_nonneg (show 0≤b-q by omega) (show 0≤scale-b-q by omega)
  grind
theorem exit_subprobability_event (q mass : Int) (hq : 0≤q) (hm : 0≤mass ∧ mass≤1) : q*mass≤q := by
  have h:=Int.mul_le_mul_of_nonneg_left hm.2 hq
  simpa using h
end H6P
