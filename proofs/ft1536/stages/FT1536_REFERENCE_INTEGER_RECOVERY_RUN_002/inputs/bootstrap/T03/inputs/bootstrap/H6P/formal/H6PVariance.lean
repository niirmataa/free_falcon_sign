import H6PMap
namespace H6P
theorem A2_coordinate0 (x y : Int) : 3*x^2≤4*(x*x+x*y+y*y) := by
  have h:=Int.sq_nonneg (x+2*y);grind
theorem A2_coordinate1 (x y : Int) : 3*y^2≤4*(x*x+x*y+y*y) := by
  have h:=Int.sq_nonneg (2*x+y);grind
theorem gram_determinant (a b c d e f g h : Int) :
    (a*a+b*b+c*c+d*d)*(e*e+f*f+g*g+h*h)-
      (a*e+b*f+c*g+d*h)^2-(a*f-b*e+c*h-d*g)^2=
    (a*g-b*h-c*e+d*f)^2+(a*h+b*g-c*f-d*e)^2 := by grind
theorem energy_max_composition (s0 s1 u v k0 k1 c0 c1 K out : Int)
    (hs : 0≤s0 ∧ 0≤s1) (hc : 0≤c0 ∧ 0≤c1)
    (hu : u≤k0*s0) (hv : v≤k1*s1) (hout : out≤c0*u+c1*v)
    (hk : c0*k0≤K ∧ c1*k1≤K) : out≤K*(s0+s1) := by
  have h0:=Int.mul_le_mul_of_nonneg_left hu hc.1
  have h1:=Int.mul_le_mul_of_nonneg_left hv hc.2
  have h2:=Int.mul_le_mul_of_nonneg_right hk.1 hs.1
  have h3:=Int.mul_le_mul_of_nonneg_right hk.2 hs.2
  grind
theorem row_norm_consumer (v cap : Int) (hv : 0≤v) (h : v*v≤cap*v) : v≤cap ∨ v=0 := by
  by_cases hzero : v=0
  · exact Or.inr hzero
  · left
    have hp : 0<v := by omega
    exact (Int.mul_le_mul_right hp).mp h
theorem cauchy_two (a b x y : Int) : (a*x+b*y)^2≤(a*a+b*b)*(x*x+y*y) := by
  have h:=Int.sq_nonneg (a*y-b*x);grind
end H6P
