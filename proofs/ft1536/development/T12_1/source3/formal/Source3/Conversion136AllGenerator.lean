import Source3.Conversion136Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Conversion136AllGenerator

def generate : IO Unit := do
  let mut manifest : Array Lean.Json := #[]
  let mut scratch : C99FiniteMemory114.Block := ⟨286720,true,some 0,.empty⟩
  for (tag,input,entry) in [("F","f","SelectedSmallFStart136"),("G","g","SelectedSmallGStart136")] do
    let mut state ← Conversion136Generator.initial input scratch
    let some pointer := C99NameMap115.lookup state.arrays "x".toList |
      throw (IO.userError "Missing conversion destination")
    let mut previous := entry
    for i in List.range 24 do
      state := (← Conversion136Generator.segment 64 state)
      let name := "GeneratedConversion136" ++ tag ++ Process122Generator.two i
      Conversion136Generator.emit name previous (i==0) 64 pointer state
      manifest := manifest.push (Lean.Json.mkObj [("module",Lean.toJson name),("through",Lean.toJson (64*(i+1:Nat)))])
      previous := name
    let some block := C99FiniteMap114.lookup state.heap.blocks pointer.block |
      throw (IO.userError "Missing completed conversion block")
    scratch := block
  IO.FS.writeFile "../CONVERSION136_SEGMENTS.json" (Lean.Json.arr manifest |>.pretty)

end FT1536.Source3.Conversion136AllGenerator
#eval FT1536.Source3.Conversion136AllGenerator.generate
