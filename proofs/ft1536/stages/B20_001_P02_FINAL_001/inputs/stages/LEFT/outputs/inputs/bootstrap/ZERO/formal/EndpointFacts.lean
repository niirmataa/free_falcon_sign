import ErrorArithmetic
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
set_option exponentiation.threshold 4096
namespace ZeroScalar
open H3Range (p2)
def plusZero : Word := ⟨0,by decide⟩
def minusZero : Word := ⟨9223372036854775808,by decide⟩
theorem both_zeros_numeric : NumericCenter plusZero ∧ NumericCenter minusZero := by
  have hd:=D_pos
  dsimp [NumericCenter,valueNum,magNum,ex,frac,sg,plusZero,minusZero,H3Range.signed]
  omega
theorem zeros_floor : floorC plusZero=0 ∧ floorC minusZero= -1 := by decide
theorem zero_rho_endpoints : rhoNum plusZero=0 ∧ rhoNum minusZero=D := by
  have hv0 : valueNum plusZero=0 := by rfl
  have hv1 : valueNum minusZero=0 := by rfl
  simp only [rhoNum,hv0,hv1,zeros_floor.1,zeros_floor.2]
  omega
theorem zero_shifted_support (z : Int) (hz : -365≤z ∧ z≤366) :
    -365≤floorC plusZero+z ∧ floorC plusZero+z≤366 ∧
    -366≤floorC minusZero+z ∧ floorC minusZero+z≤365 := by
  rw [zeros_floor.1,zeros_floor.2]
  omega
theorem positive_pack_half_one (m : Nat) (hm : 18014398509481984≤m ∧ m<36028797018963968) :
    D/2≤valueNum (packNormal false 1021 (roundMant m)) ∧
    valueNum (packNormal false 1021 (roundMant m))≤D := by
  have hr:=round_normal_range m hm
  rw [pack_normal_value false 1021 _ (by decide) hr]
  simp only [H3Range.signed,Bool.false_eq_true,↓reduceIte]
  unfold D p2
  omega

#check @both_zeros_numeric
#check @zero_rho_endpoints
#check @zero_shifted_support
#print axioms both_zeros_numeric
#print axioms zeros_floor
#print axioms zero_rho_endpoints
#print axioms zero_shifted_support
#print axioms positive_pack_half_one
end ZeroScalar
