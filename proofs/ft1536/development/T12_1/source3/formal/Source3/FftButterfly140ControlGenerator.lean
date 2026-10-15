import Source3.FftButterflyStates140
import Lean

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Finite control proposals only; the parametric theorem has no such input
   family or numerical enumeration as a premise. -/
namespace FT1536.Source3.FftButterfly140ControlGenerator

def rows : List (List (BitVec 64)) := Id.run do
  let boundary : List (BitVec 64) := [0,1,0x3ff0000000000000,0xbff0000000000000,
    0x0010000000000000,0x7fefffffffffffff,0x7ff0000000000000,0xffffffffffffffff]
  let mut result := boundary.map (fun word => List.replicate 6 word)
  let mut seed : BitVec 64 := 0x9e3779b97f4a7c15
  for _ in List.range 32 do
    let mut row := []
    for _ in List.range 6 do
      seed := seed*6364136223846793005+1442695040888963407
      row := row++[seed]
    result := result++[row]
  return result

def generate : IO Unit := do
  let mut result := []
  for row in rows do
    let [ar,ai,br,bi,sr,si] := row | throw (IO.userError "Control row length")
    let x : FftMulStates140.Words := ⟨ar,ai,br,bi⟩
    let out := FftButterflyStates140.resultWords x sr si
    result := result++[Lean.Json.mkObj [
      ("input",Lean.toJson (row.map (fun word => toString word.toNat))),
      ("output",Lean.toJson ([out 0,out 1,out 2,out 3].map (fun word => toString word.toNat)))]]
  IO.FS.writeFile "../BUTTERFLY140_CONTROL_CANDIDATE.json" (Lean.Json.pretty (Lean.Json.mkObj [
    ("status",Lean.toJson "FINITE_CONTROLS_ONLY; NOT_A_PROOF_OR_PROBABILITY_PREMISE"),
    ("cases",Lean.toJson result)]))

end FT1536.Source3.FftButterfly140ControlGenerator
#eval FT1536.Source3.FftButterfly140ControlGenerator.generate
