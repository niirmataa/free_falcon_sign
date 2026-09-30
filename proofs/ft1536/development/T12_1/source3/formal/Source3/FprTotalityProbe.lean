import Source3.StableBinarySourceProof

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprTotalityProbe
open FT1536.Source3

def publicWords : List (BitVec 64) := [
  0x0000000000000000#64, 0x8000000000000000#64,
  0x0000000000000001#64, 0x8000000000000001#64,
  0x3ff0000000000000#64, 0xbff0000000000000#64,
  0x7fefffffffffffff#64, 0xffefffffffffffff#64,
  0x7ff0000000000000#64, 0xfff0000000000000#64,
  0x7ff8000000000000#64, 0xffffffffffffffff#64]

def failures (f : BitVec 64 → BitVec 64 → Option (BitVec 64)) :
    List (BitVec 64 × BitVec 64) :=
  publicWords.flatMap fun x => publicWords.filterMap fun y =>
    if (f x y).isNone then some (x,y) else none

#eval (failures FprPrimitives.add).length
#eval (failures FprPrimitives.mul).length
#eval (failures FprPrimitives.div).length
#eval publicWords.filter (fun w => (StableBinary.half w).isNone || (StableBinary.double w).isNone)

end FT1536.Source3.FprTotalityProbe
