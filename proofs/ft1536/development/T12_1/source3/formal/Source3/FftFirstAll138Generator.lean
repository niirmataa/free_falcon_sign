import Source3.FftFirstCached138Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstAll138Generator

def counts : List Nat := [16]++List.replicate 23 32++[16]

def generate : IO Unit := do
  let initial ← FftFirst138Generator.initial
  let some pointer := C99NameMap115.lookup initial.arrays "a".toList |
    throw (IO.userError "Missing FFT candidate pointer")
  let mut state := initial
  let mut previous := "SelectedFftFStart138"
  let mut through := 0
  let mut manifest : Array Lean.Json := #[]
  for count in counts, index in [:counts.length] do
    state := (← FftFirst138Generator.segment count state)
    let name := "GeneratedFft138FirstF"++Process122Generator.two index
    if index=0 then FftFirst138Generator.emit name previous true count pointer state
    else FftFirstCached138Generator.emit name previous count pointer state
    through := through+count
    manifest := manifest.push (Lean.Json.mkObj [("module",Lean.toJson name),("count",Lean.toJson count),("through",Lean.toJson through)])
    previous := name
  if through != 768 then throw (IO.userError "FFT first-pass candidate count mismatch")
  IO.FS.writeFile "../FFT138_FIRST_SEGMENTS.json" (Lean.Json.arr manifest |>.pretty)
  let some block := C99FiniteMap114.lookup state.heap.blocks pointer.block |
    throw (IO.userError "Missing FFT first-pass block")
  IO.FS.writeFile "../FFT138_FIRST_BLOCK.txt" (Process122Generator.blockText block)

end FT1536.Source3.FftFirstAll138Generator
#eval FT1536.Source3.FftFirstAll138Generator.generate
