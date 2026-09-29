import JointMetrics
import RintRefinement
namespace H6P
theorem terminal_innovation_identity (xi0 xi1 e0 e1 eh es r0 r1 twiceHalf : Int)
    (hr : r1=xi1+e1) (hh : twiceHalf=r1+2*eh)
    (h0 : 2*r0=2*xi0+2*e0-twiceHalf+2*es) :
    2*r0=2*xi0-xi1+2*(e0-eh+es)-e1 := by omega
theorem terminal_A2 (r0 r1 x0 : Int) (h : 2*r0+r1=2*x0) :
    4*(r0*r0+r0*r1+r1*r1)=4*x0*x0+3*r1*r1 := by grind
theorem binary_map (u y l : Int) : (u-y*l)+y*l=u := by grind
theorem cubic_map (u0 u1 u2 l10 l20 l21 : Int) :
    u0-(u1-u2*l21)*l10-u2*l20=u0-u1*l10+u2*(l21*l10-l20) := by grind
theorem root_basis_map (u y l b0 b1 : Int) :
    (u-y*l)*b0+y*b1=u*b0+y*(b1-l*b0) := by grind
theorem no_affine_offset (l b0 b1 : Int) : ((0:Int)-0*l)*b0+0*b1=0 := by simp
theorem output_counts : (2*1536:Nat)=3072 ∧ (2*3072:Nat)=6144 := by decide
end H6P
