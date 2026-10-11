import PairArithmetic020B

namespace FT1536.S05.PairCoordinate020B
theorem coordinate_bound (z : Fin 131071) :
    -65535≤(z.val:Int)-65535 ∧ (z.val:Int)-65535≤65535 := by
  have := z.isLt
  omega

end FT1536.S05.PairCoordinate020B
