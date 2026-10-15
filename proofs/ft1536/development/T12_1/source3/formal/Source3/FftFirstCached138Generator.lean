import Source3.FftFirst138Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstCached138Generator
open C99CompactState115 (State)
open Process122Generator (blockText tableText cellText pointerText)

def emit (name previous : String) (count : Nat) (pointer : C99MemoryReference.ArrayPointer)
    (proposed : State) : IO Unit := do
  let some block := C99FiniteMap114.lookup proposed.heap.blocks pointer.block |
    throw (IO.userError "FFT destination image missing")
  let text := "import Source3."++previous++"\nimport Source3.FftFirstCache138\nimport Source3.C99ProcedureCapture138\n\n"++
    "set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3."++name++"\nopen C99CompactState115 (State reference)\n\n"++
    "def before : State := "++previous++".after\n"++
    "def pointer : C99MemoryReference.ArrayPointer := "++pointerText pointer++"\n"++
    "def result := C99ProcedureSegments138.run FftFirstCache138.calls 64 FftShape138.firstCondition FftShape138.firstBody FftShape138.firstIncrement "++toString count++" before\n\n"++
    "def dataBlock : C99FiniteMemory114.Block := "++blockText block++"\n\n"++
    "def localSnapshot : C99CompactCells115.Locals := "++tableText cellText proposed.locals++"\n\n"++
    "def after : State := C99ProcedureNormalize138.normalize before pointer.block dataBlock localSnapshot\n"++
    "theorem pointer_binding : (reference before).arrays \"a\".toList=some pointer := "++previous++".after_binding\n"++
    "theorem checked : C99ProcedureCapture138.capture result pointer.block=some (dataBlock,localSnapshot) := by decide +kernel\n\n"++
    "theorem closed : C99ProcedureSegments136.Prefix KeygenSearchFft.program FftShape138.firstCondition FftShape138.firstBody FftShape138.firstIncrement "++toString count++" (reference before) (reference after) :=\n"++
    "  C99ProcedureCapture138.source KeygenSearchFft.program FftFirstCache138.calls FftFirstCache138.sound 64 FftShape138.firstCondition FftShape138.firstBody FftShape138.firstIncrement "++toString count++" before \"a\".toList pointer dataBlock localSnapshot\n"++
    "    FftShape138.first_writes FftShape138.first_increment_writes FftShape138.first_arrays FftShape138.first_increment_arrays pointer_binding checked\n\n"++
    "theorem after_binding : (reference after).arrays \"a\".toList=some pointer := FftFirstChecks138.pointer_after before \"a\".toList pointer dataBlock localSnapshot pointer_binding\n\n"++
    "end FT1536.Source3."++name++"\n"
  IO.FS.writeFile ("../"++name++".lean") text

def generate : IO Unit := do
  let initial ← FftFirst138Generator.initial
  let some pointer := C99NameMap115.lookup initial.arrays "a".toList |
    throw (IO.userError "Missing FFT destination")
  let before ← FftFirst138Generator.segment 16 initial
  emit "GeneratedFft138FirstF01" "GeneratedFft138FirstF00" 32 pointer (← FftFirst138Generator.segment 32 before)

end FT1536.Source3.FftFirstCached138Generator
#eval FT1536.Source3.FftFirstCached138Generator.generate
