import Source3.FprFastCalls137
import Lean

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Finite control data only; generic source equalities are independent. -/
namespace FT1536.Source3.Fpr137ControlsGenerator

def boundaries : List (BitVec 64) := [0,1,0x8000000000000000,0x3ff0000000000000,
  0xbff0000000000000,0x0010000000000000,0x000fffffffffffff,0x7fefffffffffffff,
  0xffefffffffffffff,0x7ff0000000000000,0x7ff8000000000000,0xffffffffffffffff]

def pairs : List (BitVec 64 × BitVec 64) := Id.run do
  let mut values := boundaries.flatMap (fun x => boundaries.map (fun y => (x,y)))
  let mut seed : BitVec 64 := 0x9e3779b97f4a7c15
  for _ in List.range 64 do
    seed := seed*6364136223846793005+1442695040888963407
    let x := seed
    seed := seed*6364136223846793005+1442695040888963407
    values := values++[(x,seed)]
  return values

def generate : IO Unit := do
  let rows := pairs.map (fun (x,y) => Lean.Json.mkObj [
    ("x",Lean.toJson (toString x.toNat)),("y",Lean.toJson (toString y.toNat)),
    ("add",Lean.toJson (toString (FprAddFast137.word x y).toNat)),
    ("mul",Lean.toJson (toString (FprMulFast137.word x y).toNat)),
    ("sub",Lean.toJson (toString (FprHeadersFast137.sub x y).toNat)),
    ("neg",Lean.toJson (toString (FprHeadersFast137.neg x).toNat)),
    ("sqr",Lean.toJson (toString (FprHeadersFast137.sqr x).toNat)),
    ("half",Lean.toJson (toString (FprHeadersFast137.half x).toNat)),
    ("double",Lean.toJson (toString (FprHeadersFast137.double x).toNat))])
  IO.FS.writeFile "../FPR137_CONTROLS.json" (Lean.Json.pretty (Lean.Json.mkObj [
    ("status",Lean.toJson "FINITE_CONTROLS_ONLY; NOT_A_UNIVERSAL_PROOF"),
    ("cases",Lean.toJson rows)]))

end FT1536.Source3.Fpr137ControlsGenerator
#eval FT1536.Source3.Fpr137ControlsGenerator.generate
