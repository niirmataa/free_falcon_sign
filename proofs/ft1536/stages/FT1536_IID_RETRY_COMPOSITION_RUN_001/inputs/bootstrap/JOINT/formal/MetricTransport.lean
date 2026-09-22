import BankEnergy
namespace LeftRoot
def FormLE {V : Type} (f g : V → Int) := ∀v,f v≤g v
theorem form_congruence {V W : Type} (f g : V → Int) (T : W → V)
    (h : FormLE f g) : FormLE (fun w=>f (T w)) (fun w=>g (T w)) := by
  intro w;exact h (T w)
theorem form_scale {V : Type} (f g : V → Int) (s : Int) (hs : 0≤s)
    (h : FormLE f g) : FormLE (fun v=>s*f v) (fun v=>s*g v) := by
  intro v;exact Int.mul_le_mul_of_nonneg_left (h v) hs
theorem form_transitive {V : Type} (f g h : V → Int) (a : FormLE f g)
    (b : FormLE g h) : FormLE f h := by intro v;exact Int.le_trans (a v) (b v)
-- Minimizer witnesses explain the Schur/pivot monotonicity used analytically over real matrices.
theorem minimum_comparison {V : Type} (f g : V → Int) (mf mg scale : Int) (v : V)
    (minf : ∀w,mf≤f w) (atg : g v=mg) (bound : ∀w,f w≤scale*g w) :
    mf≤scale*mg := by
  have h:=Int.le_trans (minf v) (bound v)
  simpa only [atg] using h
theorem metric_weight_composition (actual raw stable c k : Int)
    (hc : 0≤c) (h1 : actual≤c*raw) (h2 : raw≤k*stable) : actual≤(c*k)*stable := by
  have h:=Int.mul_le_mul_of_nonneg_left h2 hc
  rw [Int.mul_assoc] at *
  exact Int.le_trans h1 h
theorem binary_reconstruction_identity (x y l h d : Int) :
    h*(x+y*l)*(x+y*l)+d*y*y=
      h*x*x+2*h*l*x*y+(h*l*l+d)*y*y := by grind
theorem cubic_reconstruction_identity (x y z a b c h d e : Int) :
    h*(x+y*a+z*b)*(x+y*a+z*b)+d*(y+z*c)*(y+z*c)+e*z*z=
    h*x*x+2*h*a*x*y+2*h*b*x*z+(h*a*a+d)*y*y+
      2*(h*a*b+d*c)*y*z+(h*b*b+d*c*c+e)*z*z := by grind
theorem imaginary_defect_not_zero : (2:Nat)*(1+0)>0 := by decide
theorem positive_budget : (849346588:Nat)>0 ∧ (768*849346588:Nat)=652298179584 := by decide
end LeftRoot
