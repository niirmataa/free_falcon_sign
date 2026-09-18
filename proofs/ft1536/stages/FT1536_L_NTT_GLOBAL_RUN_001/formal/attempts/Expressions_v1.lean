import SourceModel
import Deps.Linear
set_option maxRecDepth 16384
set_option maxHeartbeats 30000000
namespace FT1536Global
open FT1536Linear

inductive LExpr where
  | var : Fin 3 → LExpr
  | add : LExpr → LExpr → LExpr
  | sub : LExpr → LExpr → LExpr
  | ml : Int → LExpr → LExpr
  | mr : LExpr → Int → LExpr

def LExpr.eval : LExpr → (Fin 3 → Int) → Int
  | .var i,v => v i
  | .add a b,v => addQ (a.eval v) (b.eval v)
  | .sub a b,v => subQ (a.eval v) (b.eval v)
  | .ml c a,v => mmQ c (a.eval v)
  | .mr a c,v => mmQ (a.eval v) c
def LExpr.subst : LExpr → (Fin 3 → LExpr) → LExpr
  | .var i,f => f i
  | .add a b,f => .add (a.subst f) (b.subst f)
  | .sub a b,f => .sub (a.subst f) (b.subst f)
  | .ml c a,f => .ml c (a.subst f)
  | .mr a c,f => .mr (a.subst f) c
def basis (i j : Fin 3) : Int := if i=j then 1 else 0

theorem eval_subst (e : LExpr) (f : Fin 3 → LExpr) (v : Fin 3 → Int) :
    (e.subst f).eval v=e.eval (fun i => (f i).eval v) := by
  induction e <;> simp_all [LExpr.subst,LExpr.eval]

theorem dot_add (a b c d e f x y z : Int) :
    addQ (dot3 a b c x y z) (dot3 d e f x y z)=
    dot3 (addQ a d) (addQ b e) (addQ c f) x y z := by
  have h : (a*x+b*y+c*z)+(d*x+e*y+f*z)=(a+d)*x+(b+e)*y+(c+f)*z := by
    simp only [Int.add_mul]
    ac_rfl
  simpa [dot3,addQ,Int.add_emod,Int.mul_emod] using congrArg (fun t : Int => t%18433) h

theorem dot_sub (a b c d e f x y z : Int) :
    subQ (dot3 a b c x y z) (dot3 d e f x y z)=
    dot3 (subQ a d) (subQ b e) (subQ c f) x y z := by
  have h : (a*x+b*y+c*z)-(d*x+e*y+f*z)=(a-d)*x+(b-e)*y+(c-f)*z := by
    simp only [Int.sub_mul]
    omega
  simpa [dot3,subQ,Int.add_emod,Int.sub_emod,Int.mul_emod] using congrArg (fun t : Int => t%18433) h

theorem dot_mm_left (r a b c x y z : Int) :
    mmQ r (dot3 a b c x y z)=dot3 (mmQ r a) (mmQ r b) (mmQ r c) x y z := by
  have h : r*(a*x+b*y+c*z)*5184=(r*a*5184)*x+(r*b*5184)*y+(r*c*5184)*z := by
    simp only [Int.mul_add,Int.add_mul]
    ac_rfl
  simpa [dot3,mmQ,Int.add_emod,Int.mul_emod] using congrArg (fun t : Int => t%18433) h
theorem dot_mm_right (r a b c x y z : Int) :
    mmQ (dot3 a b c x y z) r=dot3 (mmQ a r) (mmQ b r) (mmQ c r) x y z := by
  simpa only [mmQ,Int.mul_comm] using dot_mm_left r a b c x y z

theorem eval_linear (e : LExpr) (v : Fin 3 → Int) (hv : ∀ i, CanonVal (v i)) :
    e.eval v=dot3 (e.eval (basis 0)) (e.eval (basis 1)) (e.eval (basis 2)) (v 0) (v 1) (v 2) := by
  induction e with
  | var i =>
    rcases fin3_cases i with rfl|rfl|rfl
    all_goals
      simp only [LExpr.eval,basis,dot3]
      have h := hv i
      unfold CanonVal at h
      simp_all
      omega
  | add a b ia ib => simpa only [LExpr.eval,ia,ib] using dot_add (a.eval (basis 0)) (a.eval (basis 1)) (a.eval (basis 2)) (b.eval (basis 0)) (b.eval (basis 1)) (b.eval (basis 2)) (v 0) (v 1) (v 2)
  | sub a b ia ib => simpa only [LExpr.eval,ia,ib] using dot_sub (a.eval (basis 0)) (a.eval (basis 1)) (a.eval (basis 2)) (b.eval (basis 0)) (b.eval (basis 1)) (b.eval (basis 2)) (v 0) (v 1) (v 2)
  | ml r a ia => simpa only [LExpr.eval,ia] using dot_mm_left r (a.eval (basis 0)) (a.eval (basis 1)) (a.eval (basis 2)) (v 0) (v 1) (v 2)
  | mr a r ia => simpa only [LExpr.eval,ia] using dot_mm_right r (a.eval (basis 0)) (a.eval (basis 1)) (a.eval (basis 2)) (v 0) (v 1) (v 2)

theorem eval_diagonal (e : LExpr) (k : Fin 3) (scale : Int)
    (h : ∀ j, e.eval (basis j)=if j=k then scale%18433 else 0)
    (v : Fin 3 → Int) (hv : ∀ i, CanonVal (v i)) : e.eval v=(scale*v k)%18433 := by
  rw [eval_linear e v hv,h 0,h 1,h 2]
  rcases fin3_cases k with rfl|rfl|rfl <;> simp [dot3,Int.mul_emod]

def scaled3 (c : Int) (v : Fin 3 → Int) : Fin 3 → Int := fun i => (c*v i)%18433
theorem eval_scaled (e : LExpr) (c : Int) (v : Fin 3 → Int) (hv : ∀ i, CanonVal (v i)) :
    e.eval (scaled3 c v)=(c*e.eval v)%18433 := by
  rw [eval_linear e (scaled3 c v) (by intro i; unfold CanonVal scaled3; omega),eval_linear e v hv]
  have h (a b d x y z : Int) : a*(c*x)+b*(c*y)+d*(c*z)=c*(a*x+b*y+d*z) := by
    simp only [Int.mul_add]
    ac_rfl
  simpa [dot3,scaled3,Int.add_emod,Int.mul_emod] using congrArg (fun t : Int => t%18433) (h (e.eval (basis 0)) (e.eval (basis 1)) (e.eval (basis 2)) (v 0) (v 1) (v 2))

#check @eval_linear
#check @eval_diagonal
#check @eval_scaled
#print axioms eval_subst
#print axioms dot_add
#print axioms dot_sub
#print axioms dot_mm_left
#print axioms dot_mm_right
#print axioms eval_linear
#print axioms eval_diagonal
#print axioms eval_scaled
end FT1536Global
