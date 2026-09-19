import SourceFloor
import GuardPrefix
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace ZeroScalar
open H3Range (p2)
def rhoNum (x : Word) : Int := valueNum x-D*floorC x
theorem value_negative_zero (x : Word) (hz : x.val=9223372036854775808) : valueNum x=0 := by
  obtain ⟨hs,he,hf⟩:=(negzero_fields x).mp hz
  simp only [valueNum,magNum,he,hf,hs,↓reduceIte,H3Range.signed,Int.natCast_zero,Int.neg_zero]

theorem RHO_CLOSED (x : Word) (hx : NumericCenter x) : 0≤rhoNum x ∧ rhoNum x≤D := by
  unfold rhoNum
  rw [FLOOR_ZERO x hx]
  by_cases hz : x.val=9223372036854775808
  · rw [value_negative_zero x hz]
    have hf : floorVal x=0 := by unfold floorVal;rw [value_negative_zero x hz,Int.zero_ediv]
    rw [hf]
    simp only [eps0,ite_eq_left hz]
    have hD:=D_pos
    omega
  · rw [eps0,ite_eq_right hz,Int.sub_zero]
    unfold floorVal
    have hmod:=Int.emod_add_ediv_mul (valueNum x) D
    have hp:=Int.emod_nonneg (valueNum x) (ne_of_gt D_pos)
    have hlt:=Int.emod_lt_of_pos (valueNum x) D_pos
    rw [Int.mul_comm D]
    omega

theorem EXACT_RESIDUAL_366 (x : Word) (hx : NumericCenter x) (z : Int) (hz : -365≤z ∧ z≤366) :
    -366*D≤valueNum x-D*(floorC x+z) ∧ valueNum x-D*(floorC x+z)≤366*D := by
  have h:=RHO_CLOSED x hx
  have hlo:=Int.mul_le_mul_of_nonneg_left hz.1 (show 0≤D from Int.le_of_lt D_pos)
  have hhi:=Int.mul_le_mul_of_nonneg_left hz.2 (show 0≤D from Int.le_of_lt D_pos)
  unfold rhoNum at h
  rw [Int.mul_add]
  omega

theorem old_new_relation (x : Word) (hx : NumericCenter x) :
    H3Range.CenterClass x.val ↔ x.val≠9223372036854775808 := by
  have he:=exponent_from_value x hx
  have hm:=floorVal_range x hx
  have hv:=floorVal_old x he
  constructor
  · intro hc hz
    obtain ⟨hs,he0,hf⟩:=(negzero_fields x).mp hz
    exact hc.2.2.1 ⟨hs,he0,hf⟩
  · intro hn
    refine ⟨x.isLt,he,?_,?_⟩
    · intro h
      exact hn ((negzero_fields x).mpr h)
    · exact hv ▸ hm

theorem old_floor_equality (x : Word) (hx : NumericCenter x) : floorC x=floorVal x ↔ x.val≠9223372036854775808 := by
  rw [FLOOR_ZERO x hx]
  unfold eps0
  split <;> omega

#check @RHO_CLOSED
#check @EXACT_RESIDUAL_366
#check @old_new_relation
#print axioms value_negative_zero
#print axioms RHO_CLOSED
#print axioms EXACT_RESIDUAL_366
#print axioms old_new_relation
#print axioms old_floor_equality
end ZeroScalar
