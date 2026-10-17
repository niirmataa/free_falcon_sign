import Source3.Word16Memory158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- DIAGNOSTIC syntax probe 2: isolate the exact broken token sequence. -/
namespace FT1536.Source3.PublicGenerateSyntaxProbe

theorem p1 (x y : Nat) (h : x<y) : True := trivial

theorem p2 (i j : Nat) (h : i<j) : True := trivial

theorem p3 (i j : Nat) (h : j<i) : True := trivial

theorem p4 (i j : Nat) (h : j < i) : True := trivial

theorem p5 (i j n : Nat) (h : j<n) : True := trivial

theorem p6 (i j : Nat) (h : LT.lt j i) : True := trivial

theorem p7 (i j : Nat) (h : Nat.lt j i) : True := trivial

theorem p8 (i j : Nat) (h : j≤i) : True := trivial

end FT1536.Source3.PublicGenerateSyntaxProbe
