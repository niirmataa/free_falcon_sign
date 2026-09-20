import TowerOrder
namespace Tower
theorem harmonic_identity (a b m : Int) :
    2*a*b-m*(a+b)=m*((a-m)+(b-m))+2*(a-m)*(b-m) := by grind
theorem harmonic_lower (a b m : Int) (hm : 0≤m) (ha : m≤a) (hb : m≤b) :
    m*(a+b)≤2*a*b := by
  have h0 : 0≤(a-m)+(b-m) := by omega
  have h1 := Int.mul_nonneg hm h0
  have h2 := Int.mul_nonneg (show 0≤a-m by omega) (show 0≤b-m by omega)
  have h := harmonic_identity a b m
  simp only [Int.mul_assoc] at *
  omega
theorem output_transfer (actual ideal err lower : Int)
    (he : -err≤actual-ideal ∧ actual-ideal≤err) (hi : lower+err≤ideal) : lower≤actual := by omega
theorem clean_invariant_constants : (49:Nat)>0 ∧ (27:Nat)>0 ∧ (8388610:Nat)<34359738368 ∧ (2147483650:Nat)<34359738368 := by decide
end Tower
