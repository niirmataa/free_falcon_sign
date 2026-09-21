import Std
set_option maxHeartbeats 10000000

namespace FT1536Linear
def dot2 (a b x y : Int) : Int := (a*x+b*y)%18433

theorem dot2_compose (a b c d e f x y : Int) :
    dot2 a b (dot2 c d x y) (dot2 e f x y) =
    dot2 (a*c+b*e) (a*d+b*f) x y := by
  unfold dot2
  calc
    (a*((c*x+d*y)%18433)+b*((e*x+f*y)%18433))%18433 =
        (a*(c*x+d*y)+b*(e*x+f*y))%18433 := by
          simp [Int.add_emod, Int.mul_emod]
    _ = ((a*c+b*e)*x+(a*d+b*f)*y)%18433 := by
      congr 1
      simp only [Int.mul_add, Int.add_mul, Int.mul_assoc]
      ac_rfl

theorem dot2_congr (a b c d x y : Int)
    (ha : a%18433=c%18433) (hb : b%18433=d%18433) :
    dot2 a b x y = dot2 c d x y := by
  unfold dot2
  simp [Int.add_emod, Int.mul_emod, ha, hb]

def dot3 (a b c x y z : Int) : Int := (a*x+b*y+c*z)%18433

theorem dot3_compose (a b c d e f g h i j k l x y z : Int) :
    dot3 a b c (dot3 d e f x y z) (dot3 g h i x y z) (dot3 j k l x y z) =
    dot3 (a*d+b*g+c*j) (a*e+b*h+c*k) (a*f+b*i+c*l) x y z := by
  unfold dot3
  calc
    (a*((d*x+e*y+f*z)%18433)+b*((g*x+h*y+i*z)%18433)+c*((j*x+k*y+l*z)%18433))%18433 =
        (a*(d*x+e*y+f*z)+b*(g*x+h*y+i*z)+c*(j*x+k*y+l*z))%18433 := by
          simp [Int.add_emod, Int.mul_emod]
    _ = ((a*d+b*g+c*j)*x+(a*e+b*h+c*k)*y+(a*f+b*i+c*l)*z)%18433 := by
      congr 1
      simp only [Int.mul_add, Int.add_mul, Int.mul_assoc]
      ac_rfl

theorem dot3_congr (a b c d e f x y z : Int)
    (ha : a%18433=d%18433) (hb : b%18433=e%18433) (hc : c%18433=f%18433) :
    dot3 a b c x y z = dot3 d e f x y z := by
  unfold dot3
  simp [Int.add_emod, Int.mul_emod, ha, hb, hc]

theorem three_row_action (a b c d e f g h i j k l t0 t1 t2 x y z : Int)
    (h0 : (a*d+b*g+c*j)%18433=t0%18433)
    (h1 : (a*e+b*h+c*k)%18433=t1%18433)
    (h2 : (a*f+b*i+c*l)%18433=t2%18433) :
    dot3 a b c (dot3 d e f x y z) (dot3 g h i x y z) (dot3 j k l x y z) =
    dot3 t0 t1 t2 x y z := by
  rw [dot3_compose]
  exact dot3_congr _ _ _ _ _ _ _ _ _ h0 h1 h2

-- A constant coefficient identity proves equality for all variable inputs.
theorem two_row_inverse (a b c d e f g h scale x y : Int)
    (h00 : (a*e+b*g)%18433=scale%18433)
    (h01 : (a*f+b*h)%18433=0)
    (h10 : (c*e+d*g)%18433=0)
    (h11 : (c*f+d*h)%18433=scale%18433) :
    dot2 a b (dot2 e f x y) (dot2 g h x y) = (scale*x)%18433 ∧
    dot2 c d (dot2 e f x y) (dot2 g h x y) = (scale*y)%18433 := by
  rw [dot2_compose, dot2_compose]
  constructor
  · have r := dot2_congr (a*e+b*g) (a*f+b*h) scale 0 x y h00 (by simpa using h01)
    simpa [dot2] using r
  · have r := dot2_congr (c*e+d*g) (c*f+d*h) 0 scale x y (by simpa using h10) h11
    simpa [dot2] using r

theorem final_scaling (x : Int) : ((1536*x)%18433 * 18421)%18433 = x%18433 := by omega

#print axioms dot2_compose
#print axioms dot2_congr
#print axioms dot3_compose
#print axioms dot3_congr
#print axioms three_row_action
#print axioms two_row_inverse
#print axioms final_scaling
end FT1536Linear
