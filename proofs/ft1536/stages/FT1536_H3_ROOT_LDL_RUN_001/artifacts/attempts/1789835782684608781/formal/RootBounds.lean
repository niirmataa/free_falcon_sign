import RootDiv
import RootFrame
set_option exponentiation.threshold 4096
namespace RootLDL
theorem ternary_store (x : Nat) (h : x<3) : -1≤(x:Int)-1 ∧ (x:Int)-1≤1 := by omega
theorem coefficient_test (z : Int) (h : ¬(z< -2047 ∨ 2047<z)) : -2047≤z ∧ z≤2047 := by omega
theorem positive_margin (a d e k : Int) (ha : 0<a)
    (hprod : k≤d*a+e*a) (hgap : 32*a+e*a<k) : 32<d := by
  have hp : 32*a<d*a := by omega
  exact (Int.mul_lt_mul_right ha).mp hp
theorem machine_schur_consumer (D T E : Int) (hl : 32+E≤T)
    (he : -E≤D-T ∧ D-T≤E) : 32≤D := by omega
theorem imaginary_consumer (im E : Int) (he : -E≤im ∧ im≤E) (hE : E≤32) : -32≤im ∧ im≤32 := by omega
theorem no_overflow_primitive_scale : (2:Nat)^202 < 2^1023 := by decide
theorem zero_domain_not_root_domain : 1054<1067 ∧ (1:Nat)*1048576>1024 := by decide
theorem coefficient_reduction_bound : (4*1536*2047+18433:Nat)<2147473409 := by decide
end RootLDL
