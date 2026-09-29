import ReachFrame
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace LeftRoot
-- Failed previous test is strict. These scaled inequalities do not assume ideal dss.
theorem failed_bank_lower (d a variance lower : Int) (hv : 0<variance)
    (hf : d<a) (he : lower≤d*variance) : lower<a*variance := by
  have h:=Int.mul_lt_mul_of_pos_right hf hv
  omega
theorem passed_bank_upper (a d variance upper : Int) (hv : 0≤variance)
    (hp : a≤d) (he : d*variance≤upper) : a*variance≤upper := by
  have h:=Int.mul_le_mul_of_nonneg_right hp hv
  omega
theorem paired_three_quarters (stored paired scale : Int)
    (h : 3*paired≤4*stored*scale) : 3*paired+4*stored*scale≤8*stored*scale := by omega
theorem A2_four (r0 r1 : Int) :
    4*(r0*r0+r0*r1+r1*r1)=(2*r0+r1)*(2*r0+r1)+3*r1*r1 := by grind
theorem terminal_defect_identity (r0 r1 u defect : Int) (h : 2*r0+r1=2*u+defect) :
    4*(r0*r0+r0*r1+r1*r1)=(2*u+defect)*(2*u+defect)+3*r1*r1 := by
  rw [A2_four,h]
theorem terminal_cross_expansion (u defect : Int) :
    (u+defect)*(u+defect)=u*u+2*u*defect+defect*defect := by grind
theorem half_last_defect (r0 r1 rx u eh es : Int)
    (hh : 2*rx=r1+eh) (hs : r0=u-rx+es) : 2*r0+r1=2*u-eh+2*es := by omega
theorem right_terminal_count : (3*2^8:Nat)=768 ∧ (2*3*2^8:Nat)=1536 := by decide
theorem reverse_leaf_index (i : Nat) (hi : i<768) :
    768≤1535-i ∧ 1535-i<1536 := by omega
theorem reverse_leaf_injective (i j : Nat) (hi : i<768) (hj : j<768)
    (h : 1535-i=1535-j) : i=j := by omega
theorem square_roundoff_identity (a p e1 e2 result : Int)
    (h : result=(a+p+e1)-p+e2) : result=a+e1+e2 := by omega
end LeftRoot
