import ReadSemantics020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PairArithmetic020B
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020

def q2 (x y : Int) : Int := x*x+x*y+y*y
def qExpr : Expr := add (add (mul (r 13) (r 13)) (mul (r 13) (r 14))) (mul (r 14) (r 14))

theorem bounded_fits (x : Int) (lo : -(2^100)≤x) (hi : x≤2^100) : Fits x := by
  constructor <;> norm_num <;> omega

theorem q2_bounds (x y : Int) (hx : -65535≤x ∧ x≤65535) (hy : -65535≤y ∧ y≤65535) :
    0≤q2 x y ∧ q2 x y≤3*65535^2 := by
  have xx : x*x≤65535^2 := by nlinarith
  have yy : y*y≤65535^2 := by nlinarith
  unfold q2
  constructor <;> nlinarith [sq_nonneg (x+y),sq_nonneg (x-y),sq_nonneg x,sq_nonneg y]

/-- All intermediate signed products/sums fit; no wrapping is assumed away. -/
theorem qExpr_correct (s : State) (x y : Int)
    (hx : -65535≤x ∧ x≤65535) (hy : -65535≤y ∧ y≤65535)
    (h13 : s.reg 13=word x) (h14 : s.reg 14=word y) :
    eval s qExpr=word (q2 x y) := by
  have fx : Fits x := bounded_fits x (by omega) (by omega)
  have fy : Fits y := bounded_fits y (by omega) (by omega)
  have xx : 0≤x*x ∧ x*x≤65535^2 := ⟨mul_self_nonneg x,by nlinarith⟩
  have yy : 0≤y*y ∧ y*y≤65535^2 := ⟨mul_self_nonneg y,by nlinarith⟩
  have xy : -(65535^2)≤x*y ∧ x*y≤65535^2 := by
    constructor <;> nlinarith [sq_nonneg (x+y),sq_nonneg (x-y)]
  have fxx : Fits (x*x) := bounded_fits _ (by omega) (by omega)
  have fyy : Fits (y*y) := bounded_fits _ (by omega) (by omega)
  have fxy : Fits (x*y) := bounded_fits _ (by omega) (by omega)
  have fsum : Fits (x*x+x*y) := bounded_fits _ (by omega) (by omega)
  change op .add (op .add (op .mul (s.reg 13) (s.reg 13))
    (op .mul (s.reg 13) (s.reg 14))) (op .mul (s.reg 14) (s.reg 14)) = _
  rw [h13,h14,mul_word x x fx fx,mul_word x y fx fy,mul_word y y fy fy,
    add_word _ _ fxx fxy,add_word _ _ fsum fyy]
  rfl

theorem accumulated_bound (p : Nat) (a x y : Int) (hp : p<1536)
    (ha : 0≤a ∧ a≤(p:Int)*(3*65535^2))
    (hx : -65535≤x ∧ x≤65535) (hy : -65535≤y ∧ y≤65535) :
    0≤a+q2 x y ∧ a+q2 x y≤((p+1:Nat):Int)*(3*65535^2) ∧ Fits (a+q2 x y) := by
  have hq := q2_bounds x y hx hy
  have pp : (p:Int)<1536 := by exact_mod_cast hp
  have nn : 0≤a+q2 x y := by omega
  have ub : a+q2 x y≤((p+1:Nat):Int)*(3*65535^2) := by push_cast; nlinarith
  exact ⟨nn,ub,bounded_fits _ (by omega) (by nlinarith)⟩

end FT1536.S05.PairArithmetic020B
