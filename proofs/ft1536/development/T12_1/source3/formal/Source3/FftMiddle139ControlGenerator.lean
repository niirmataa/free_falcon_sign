import Source3.FftMiddleNext139Generator
import Source3.FftFirst138ControlGenerator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMiddle139ControlGenerator

def state (block : C99FiniteMemory114.Block) : C99CompactState115.State :=
  {FftMiddleNext139Generator.initial with heap := C99FiniteMemory114.putBlock ⟨.empty⟩ 31 block}

def generate : IO Unit := do
  let before := state GeneratedFft138FirstF24.dataBlock
  let pilot := state GeneratedFft139MiddlePilot.dataBlock
  let next ← FftMiddle139Generator.segment 4 FftMiddleNext139Generator.initial
  let initialWords ← FftFirst138ControlGenerator.words before 0
  let pilotWords ← FftFirst138ControlGenerator.words pilot 0
  let nextWords ← FftFirst138ControlGenerator.words next 0
  let gBefore ← FftFirst138ControlGenerator.words before 1536
  let gPilot ← FftFirst138ControlGenerator.words pilot 1536
  let gNext ← FftFirst138ControlGenerator.words next 1536
  if gBefore != gPilot || gBefore != gNext then throw (IO.userError "Middle FFT candidate changed g")
  let some nextBlock := C99FiniteMap114.lookup next.heap.blocks 31 | throw (IO.userError "Missing next block")
  for (name,block) in [("BEFORE",GeneratedFft138FirstF24.dataBlock),
      ("PILOT",GeneratedFft139MiddlePilot.dataBlock),("NEXT",nextBlock)] do
    IO.FS.writeFile ("../FFT139_CONTROL_"++name++".txt") (Process122Generator.blockText block)
  IO.FS.writeFile "../FFT139_CONTROL_CANDIDATE.json" (Lean.Json.pretty (Lean.Json.mkObj [
    ("status",Lean.toJson "FINITE_CONTROL_CANDIDATES_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE"),
    ("initial",Lean.toJson initialWords),("pilot4",Lean.toJson pilotWords),("next8",Lean.toJson nextWords),
    ("g_preserved",Lean.toJson true)]))

end FT1536.Source3.FftMiddle139ControlGenerator
#eval FT1536.Source3.FftMiddle139ControlGenerator.generate
