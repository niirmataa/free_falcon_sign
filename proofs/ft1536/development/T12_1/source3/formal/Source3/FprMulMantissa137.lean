import Source3.FprUnsignedPrefixes

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The same25-bit limb arithmetic as the pinned unsigned C prefix. No
   mathematical floating-point or host-arithmetic oracle is used. -/
namespace FT1536.Source3.FprMulMantissa137

def mantissa (x : BitVec 64) : BitVec 64 := (x &&& ((1#64 <<< 52)-1)) ||| (1#64 <<< 52)

def raw (x y : BitVec 64) : BitVec 64 :=
  let xu := mantissa x
  let yu := mantissa y
  let x0 := xu.setWidth 32 &&& 0x01ffffff#32
  let x1 := (xu >>> 25).setWidth 32
  let y0 := yu.setWidth 32 &&& 0x01ffffff#32
  let y1 := (yu >>> 25).setWidth 32
  let w00 := x0.setWidth 64 * y0.setWidth 64
  let z0 := w00.setWidth 32 &&& 0x01ffffff#32
  let z1a := (w00 >>> 25).setWidth 32
  let w01 := x0.setWidth 64 * y1.setWidth 64
  let z1b := z1a + (w01.setWidth 32 &&& 0x01ffffff#32)
  let z2a := (w01 >>> 25).setWidth 32
  let w10 := x1.setWidth 64 * y0.setWidth 64
  let z1c := z1b + (w10.setWidth 32 &&& 0x01ffffff#32)
  let z2b := z2a + (w10 >>> 25).setWidth 32
  let zu0 := x1.setWidth 64 * y1.setWidth 64
  let z2c := z2b + (z1c >>> 25)
  let z1d := z1c &&& 0x01ffffff#32
  let zu1 := zu0 + z2c.setWidth 64
  zu1 ||| (((z0 ||| z1d)+0x01ffffff#32) >>> 25).setWidth 64

def execution (x y : BitVec 64) :=
  UnsignedState.exec FprPrimitives.headerCalls (FprUnsignedPrefixes.initial x y) FprUnsignedPrefixes.mulPrefix

theorem source_result (x y : BitVec 64) :
    (execution x y).bind (fun state => state.values ['z','u'])=some (.u64 (raw x y)) := by rfl

theorem source_x (x y : BitVec 64) :
    (execution x y).bind (fun state => state.values ['x'])=some (.u64 x) := by rfl

theorem source_y (x y : BitVec 64) :
    (execution x y).bind (fun state => state.values ['y'])=some (.u64 y) := by rfl

end FT1536.Source3.FprMulMantissa137
