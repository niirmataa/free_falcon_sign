import Source3.GeneratedFft139MiddlePilot
import Source3.Fft139TraceGenerator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Candidate-only continuation from the already serialized pilot endpoint.
   The emitted theorem checks the actual source endpoint, not this small heap. -/
namespace FT1536.Source3.FftMiddleNext139Generator

def initial : C99CompactState115.State :=
  ⟨C99FiniteMemory114.putBlock ⟨.empty⟩ 31 GeneratedFft139MiddlePilot.dataBlock,
    GeneratedFft139MiddlePilot.localSnapshot,
    ("a".toList,⟨31,0,35840,8,0⟩)::FirstSegment128Generator.tables,
    FirstSegment128Generator.globals,FirstSegment128Generator.tables⟩

def generate : IO Unit := do
  let name := "GeneratedFft139MiddleNext"
  let some trace := Fft139TraceGenerator.collect 4 initial | throw (IO.userError "Trace proposal failed")
  Fft139TraceGenerator.emit "GeneratedFft139NextCalls" trace.eraseDups
  let proposed ← FftMiddle139Generator.segment 4 initial
  FftMiddle139Generator.emit name "GeneratedFft139MiddlePilot.after" 4 ⟨31,0,35840,8,0⟩ proposed
  let path := "../"++name++".lean"
  let text ← IO.FS.readFile path
  IO.FS.writeFile path ("import Source3.GeneratedFft139MiddlePilot\nimport Source3.GeneratedFft139NextCalls\n"++
    ((text.replace "FprFastCalls137.calls" "GeneratedFft139NextCalls.calls").replace "FprFastCalls137.sound" "GeneratedFft139NextCalls.sound"))

end FT1536.Source3.FftMiddleNext139Generator
#eval FT1536.Source3.FftMiddleNext139Generator.generate
