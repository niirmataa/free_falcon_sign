import Source3.Packing130Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Packing130AllGenerator

def generate : IO Unit := do
  let mut manifest : Array Lean.Json := #[]
  for (tag,argument,entry) in [("F","f","SelectedPackingF130"),("G","g","SelectedPackingG130")] do
    let initial ← Packing130Generator.initial argument
    let mut state := initial
    let mut previous := entry
    for i in List.range 24 do
      state := (← Packing130Generator.segment 64 state)
      let name := "GeneratedPacking130" ++ tag ++ Process122Generator.two i
      Packing130Generator.emit name previous (i==0) 64 state
      manifest := manifest.push (Lean.Json.mkObj [("module",Lean.toJson name),("through",Lean.toJson (64*(i+1:Nat)))])
      previous := name
  IO.FS.writeFile "../PACKING130_SEGMENTS.json" (Lean.Json.arr manifest |>.pretty)

end FT1536.Source3.Packing130AllGenerator

#eval FT1536.Source3.Packing130AllGenerator.generate
