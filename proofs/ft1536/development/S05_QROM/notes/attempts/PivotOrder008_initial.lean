import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp

/- Elementary kernel layer for S05/008. This file does not import the
   coefficient-ring/source modules and does not certify emitted KeyGen keys. -/
namespace FT1536.S05.PivotOrder008

def q2 (x y : ℝ) : ℝ := x^2+x*y+y^2

def polar (x y u v : ℝ) : ℝ := x*u+(x*v+y*u)/2+y*v

theorem rotation_norm (x y : ℝ) : q2 (-y) (x+y)=q2 x y := by
  unfold q2
  ring

theorem rotation_polar (x y : ℝ) : polar x y (-y) (x+y)=q2 x y/2 := by
  unfold polar q2
  ring

theorem a2_second_pivot (a : ℝ) (ha : a≠0) : a-(a/2)^2/a=3*a/4 := by
  field_simp
  <;> ring

/-- Actual A2 elimination order cannot equal the reversed summation order. -/
theorem positive_order_incompatible (a leaf : ℝ) (hpos : 0<leaf)
    (hfirst : a=3*leaf/4) (hsecond : 3*a/4=leaf) : False := by
  linarith

theorem affine_a2_atom (a x y u v : ℝ) :
    a*q2 (x+u) (y+v)=a*(x+u+(y+v)/2)^2+(3*a/4)*(y+v)^2 := by
  unfold q2
  ring

/-- s is the entire off-diagonal row paired with the remaining coordinates;
    the shift must keep this dependence, not just the coset translation. -/
theorem schur_complete_square (a s t x : ℝ) (ha : a≠0) :
    a*x^2+2*x*s+t=a*(x+s/a)^2+(t-s^2/a) := by
  field_simp
  <;> ring

#print axioms rotation_norm
#print axioms rotation_polar
#print axioms a2_second_pivot
#print axioms positive_order_incompatible
#print axioms affine_a2_atom
#print axioms schur_complete_square
end FT1536.S05.PivotOrder008
