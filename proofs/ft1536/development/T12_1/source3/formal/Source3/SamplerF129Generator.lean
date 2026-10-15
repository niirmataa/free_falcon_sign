import Source3.SamplerSegments128Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Candidate data only; every emitted segment requires kernel checks and
   original source proofs of every logged process event. -/
namespace FT1536.Source3.SamplerF129Generator
open SamplerSegments128Generator (segment emit)

def generate : IO Unit := do
  let initial ← FirstSegment128Generator.initial
  let first ← segment 1 initial
  let next ← segment 63 first.1
  let mut state := next.1
  let mut previous := "GeneratedSampler128F01"
  let mut manifest : Array Lean.Json := #[]
  for i in List.range 23 do
    let index := i+2
    let name := "GeneratedSampler129F" ++ Process122Generator.two index
    let proposed ← segment 64 state
    emit name previous 64 proposed
    let path := "../" ++ name ++ ".lean"
    let content ← IO.FS.readFile path
    let old := "theorem pointer_binding : (reference before).arrays \"v\".toList=some destination := by decide +kernel"
    let replacement := "theorem pointer_binding : (reference before).arrays \"v\".toList=some destination := " ++ previous ++ ".pointer_binding"
    if !(content.splitOn old).length == 2 then
      throw (IO.userError "Pointer lemma template mismatch")
    IO.FS.writeFile path (content.replace old replacement)
    manifest := manifest.push (Lean.Json.mkObj [("module",Lean.toJson name),
      ("count",Lean.toJson (64:Nat)),("through",Lean.toJson (64*(index:Nat))),
      ("events",Lean.toJson proposed.2.length)])
    state := proposed.1
    previous := name
  IO.FS.writeFile "../SEGMENTS129.json" (Lean.Json.arr manifest |>.pretty)

end FT1536.Source3.SamplerF129Generator

#eval FT1536.Source3.SamplerF129Generator.generate
