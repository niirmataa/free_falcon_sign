import Source3.FprUnsignedPrefixes

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprAddSwap137

def mask (x y : BitVec 64) : BitVec 64 :=
  let absolute := (1#64 <<< 63)-1
  let za := (x &&& absolute)-(y &&& absolute)
  let cs := (za >>> 63).setWidth 32 |||
    ((1#32-((-za) >>> 63).setWidth 32) &&& (x >>> 63).setWidth 32)
  (x ^^^ y) &&& (-cs.setWidth 64)

def first (x y : BitVec 64) : BitVec 64 := x ^^^ mask x y
def second (x y : BitVec 64) : BitVec 64 := y ^^^ mask x y

def execution (x y : BitVec 64) :=
  UnsignedState.exec FprPrimitives.headerCalls (FprUnsignedPrefixes.initial x y) FprUnsignedPrefixes.addPrefix

theorem source_first (x y : BitVec 64) :
    (execution x y).bind (fun state => state.values ['x'])=some (.u64 (first x y)) := by rfl

theorem source_second (x y : BitVec 64) :
    (execution x y).bind (fun state => state.values ['y'])=some (.u64 (second x y)) := by rfl

end FT1536.Source3.FprAddSwap137
