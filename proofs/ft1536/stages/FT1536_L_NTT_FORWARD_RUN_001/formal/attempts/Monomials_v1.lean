import NodeArithmetic
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Forward

theorem phi_square (z : Int) (hz : PhiZero z) : z^1536%18433=(z^768-1)%18433 := by
  unfold PhiZero at hz
  omega
theorem phi_cube (z : Int) (hz : PhiZero z) : z^2304%18433=(-1:Int)%18433 := by
  have h2:=phi_square z hz
  have he : z^2304=z^768*z^1536 := Int.pow_add z 768 1536
  calc
    z^2304%18433=(z^768*(z^768-1))%18433 := by
      rw [he]
      simp only [Int.mul_emod,h2,Int.emod_emod]
    _ = (z^1536-z^768)%18433 := by
      rw [Int.mul_sub,Int.mul_one,←Int.pow_add]
    _ = (-1:Int)%18433 := by unfold PhiZero at hz; omega

theorem power_middle (z : Int) (hz : PhiZero z) (k : Nat) (hk : 1536≤k) :
    z^k%18433=(z^(k-768)-z^(k-1536))%18433 := by
  have h0 : k=(k-1536)+1536 := by omega
  have h1 : k-768=(k-1536)+768 := by omega
  have he : z^k=z^(k-1536)*z^1536 := by conv => lhs; rw [h0,Int.pow_add]
  calc
    z^k%18433=(z^(k-1536)*(z^768-1))%18433 := by
      rw [he]
      simp only [Int.mul_emod,phi_square z hz,Int.emod_emod]
    _ = (z^(k-768)-z^(k-1536))%18433 := by
      rw [Int.mul_sub,Int.mul_one,←Int.pow_add,←h1]

theorem power_high (z : Int) (hz : PhiZero z) (k : Nat) (hk : 2304≤k) :
    z^k%18433=((-1)*z^(k-2304))%18433 := by
  have h0 : k=(k-2304)+2304 := by omega
  have he : z^k=z^(k-2304)*z^2304 := by conv => lhs; rw [h0,Int.pow_add]
  rw [he]
  simp only [Int.mul_emod,phi_cube z hz,Int.mul_comm,Int.emod_emod]

-- The same remMonomial used by the predecessor's independent coefficient product.
theorem remMonomial_eval (z : Int) (hz : PhiZero z) (k : Nat) (hk : k<3071) :
    peval 1536 (FT1536Composition.remMonomial k) z=z^k%18433 := by
  by_cases h0 : k<1536
  · simp only [FT1536Composition.remMonomial,h0,↓reduceIte]
    rw [eval_delta,ite_eq_left h0]
  · by_cases h1 : k<2304
    · have ha : k-768<1536 := by omega
      have hb : k-1536<1536 := by omega
      simp only [FT1536Composition.remMonomial,h0,h1,↓reduceIte]
      rw [eval_sub,eval_delta,eval_delta,ite_eq_left ha,ite_eq_left hb]
      simpa only [Int.sub_emod,Int.emod_emod] using (power_middle z hz k (by omega)).symm
    · have hb : k-2304<1536 := by omega
      simp only [FT1536Composition.remMonomial,h0,h1,↓reduceIte]
      have he : (fun j : Nat => -(if j=k-2304 then (1:Int) else 0))=
          (fun j => (-1:Int)*(if j=k-2304 then 1 else 0)) := by funext j; rw [Int.neg_one_mul]
      rw [he,eval_scale,eval_delta,ite_eq_left hb]
      simpa only [Int.mul_emod,Int.emod_emod] using (power_high z hz k (by omega)).symm

#check @remMonomial_eval
#print axioms phi_square
#print axioms phi_cube
#print axioms power_middle
#print axioms power_high
#print axioms remMonomial_eval
end FT1536Forward
