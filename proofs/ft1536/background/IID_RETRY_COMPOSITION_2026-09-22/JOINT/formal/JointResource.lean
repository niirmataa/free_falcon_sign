import JointMetrics
namespace OrderedJoint
theorem proposal_conservation_compose (p q r a b da db ra rb : Nat)
    (ha : p+33*a+da=4096*ra+q) (hb : q+33*b+db=4096*rb+r) :
    p+33*(a+b)+(da+db)=4096*(ra+rb)+r := by omega
theorem repeated_getter_bound (p q T R D : Nat) (hp : p≤4095) (hq : 8≤q)
    (hd : D≤9*R) (hc : p+33*T+D=4096*R+q) : R≤1+(33*T)/4087 := by omega
theorem geometric_mgf_monotone_cleared (a p z d : Int) :
    p*z*(d-(d-a)*z)-a*z*(d-(d-p)*z)=(a-p)*z*d*(z-1) := by grind
theorem expectation_root : (8*3072:Nat)=24576 ∧ (33*24576:Nat)=811008 := by decide
theorem budget_root : (16*3072:Nat)=49152 ∧ (33*49152:Nat)=1622016 := by decide
theorem chernoff_factor : (4*17*16^16:Nat)<3*9*17^16 := by decide
theorem chernoff_block : (3^3*2:Nat)<4^3 := by decide
theorem block_count : (3*1024:Nat)=3072 := by decide
theorem ghost_frame : (1+1622016/4087:Nat)=397 ∧ 9*397=3573 ∧ 4096*397=1626112 := by decide
end OrderedJoint
