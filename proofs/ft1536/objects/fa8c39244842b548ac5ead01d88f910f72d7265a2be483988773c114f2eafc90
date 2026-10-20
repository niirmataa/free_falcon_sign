import Source3.KeygenPublicSplitPolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Universal physical triple order in the public field. This identifies
   the three source formulas with evaluations at KeygenPublicRoots.point;
   execution of the triple body and the outer radix invariants are separate. -/
namespace FT1536.Source3.KeygenPublicTripleOrder
open KeygenPublicAlgebra (R)
open KeygenPublicRoots (root firstRoot unity point pointExponent)
open KeygenMkgm3Indices (tableExponent)

theorem unity_cube : unity^3=1 := by
  rw [unity,← pow_mul]
  change firstRoot^6=1
  rw [← KeygenPublicRoots.first_root_order]
  exact pow_orderOf_eq_one firstRoot
theorem unity_power : unity=root^1536 := by
  rw [unity,firstRoot,← pow_mul]

theorem triple_order (j k : Nat) (hj : j<512) (hk : k<3) :
    point ⟨3*j+k,by omega⟩=root^tableExponent (512+j)*unity^k := by
  have div : (3*j+k)/3=j := by omega
  have rem : (3*j+k)%3=k := by omega
  rw [point,pointExponent,div,rem,pow_add,unity_power,← pow_mul]

def quadratic (a b c x : R) : R := a+b*x+c*x^2
def output (a b c x w : R) (k : Nat) : R :=
  if k=0 then a+(b*x+c*x^2)
  else if k=1 then a+(b*x*w+c*x^2*w^2)
  else a+(b*x*w^2+c*x^2*w)

theorem output_eval (a b c x : R) (k : Nat) (hk : k<3) :
    output a b c x unity k=quadratic a b c (x*unity^k) := by
  have fourth : unity^4=unity := by
    rw [show (4 : Nat)=3+1 from rfl,pow_add,unity_cube,pow_one,one_mul]
  interval_cases k
  · simp only [output,ite_true,pow_zero,mul_one,quadratic]
    ring
  · simp only [output,show ¬(1 : Nat)=0 from by decide,ite_false,ite_true,pow_one,quadratic]
    ring
  · simp only [output,show ¬(2 : Nat)=0 from by decide,show ¬(2 : Nat)=1 from by decide,ite_false,quadratic]
    rw [mul_pow,← pow_mul,show (2*2 : Nat)=4 from rfl,fourth]
    ring

theorem physical_evaluation (a b c : R) (j k : Nat) (hj : j<512) (hk : k<3) :
    output a b c (root^tableExponent (512+j)) unity k=
      quadratic a b c (point ⟨3*j+k,by omega⟩) := by
  rw [triple_order j k hj hk]
  exact output_eval a b c _ k hk

theorem all_physical_evaluations (a : Nat → R) (i : Fin 1536) :
    output (a (3*(i.val/3))) (a (3*(i.val/3)+1)) (a (3*(i.val/3)+2))
      (root^tableExponent (512+i.val/3)) unity (i.val%3)=
    (KeygenPublicSplitPolynomial.polynomial a (3*(i.val/3)) 3).eval (point i) := by
  have bound := i.isLt
  have equal : (⟨3*(i.val/3)+i.val%3,by omega⟩ : Fin 1536)=i := by apply Fin.ext; dsimp; omega
  have law := physical_evaluation (a (3*(i.val/3))) (a (3*(i.val/3)+1)) (a (3*(i.val/3)+2))
    (i.val/3) (i.val%3) (by omega) (by omega)
  rw [equal] at law
  rw [law]
  simp [KeygenPublicSplitPolynomial.polynomial,Finset.sum_range_succ,quadratic]

end FT1536.Source3.KeygenPublicTripleOrder
