import Source3.FftShape138
import Source3.C99ProcedureSegments138
import Source3.FprFastCalls137
import Source3.FirstSegment128Generator
import Source3.GeneratedConversion136G23

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirst138Generator
open C99CompactState115 (State)
open Process122Generator (blockText tableText cellText pointerText)

/- Only candidate generation uses this small state. Every emitted prefix
   and image is checked on SelectedFftFStart138.initial or its proved successor. -/
def initial : IO State := do
  let heap := C99FiniteMemory114.putBlock ⟨.empty⟩ 31 GeneratedConversion136G23.dataBlock
  let caller : State := ⟨heap,[("logn".toList,.u32 (some 10))],[("rt1".toList,⟨31,0,35840,8,0⟩)],
    FirstSegment128Generator.globals,FirstSegment128Generator.tables⟩
  let some bound := C99CompactBinding115.bind C99CompactPointer115.noCalls caller GeneratedFft138Syntax.function.params (FftShape138.args "rt1") |
    throw (IO.userError "FFT candidate binding failed")
  let mut state := bound
  for code in [FftShape138.declaration,FftShape138.size,FftShape138.halfSize,FftShape138.firstInitial] do
    let some after := C99ProcedureRun138.run FprFastCalls137.calls 16 code state |
      throw (IO.userError "FFT candidate setup failed")
    state := after
  pure state

def segment (count : Nat) (before : State) : IO State :=
  match C99ProcedureSegments138.run FprFastCalls137.calls 64 FftShape138.firstCondition
      FftShape138.firstBody FftShape138.firstIncrement count before with
  | some after => pure after
  | none => throw (IO.userError "FFT first-pass candidate prefix failed")

def emit (name previous : String) (first : Bool) (count : Nat) (pointer : C99MemoryReference.ArrayPointer)
    (proposed : State) : IO Unit := do
  let some block := C99FiniteMap114.lookup proposed.heap.blocks pointer.block |
    throw (IO.userError "FFT destination block missing")
  let origin := previous++(if first then ".initial" else ".after")
  let binding := if first then "by decide +kernel" else previous++".after_binding"
  let text := "import Source3."++previous++"\nimport Source3.FftFirstChecks138\n\n"++
    "set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3."++name++"\nopen C99CompactState115 (State reference)\n\n"++
    "def before : State := "++origin++"\n"++
    "def pointer : C99MemoryReference.ArrayPointer := "++pointerText pointer++"\n"++
    "def result := C99ProcedureSegments138.run FprFastCalls137.calls 64 FftShape138.firstCondition FftShape138.firstBody FftShape138.firstIncrement "++toString count++" before\n"++
    "theorem defined : result.isSome=true := by decide +kernel\n"++
    "def output : State := result.get defined\n"++
    "theorem computed : C99ProcedureSegments138.run FprFastCalls137.calls 64 FftShape138.firstCondition FftShape138.firstBody FftShape138.firstIncrement "++toString count++" before=some output := SelectedInput124.option_get result defined\n\n"++
    "def dataBlock : C99FiniteMemory114.Block := "++blockText block++"\n\n"++
    "def localSnapshot : C99CompactCells115.Locals := "++tableText cellText proposed.locals++"\n\n"++
    "def after : State := C99ProcedureNormalize138.normalize before pointer.block dataBlock localSnapshot\n"++
    "theorem pointer_binding : (reference before).arrays \"a\".toList=some pointer := "++binding++"\n"++
    "theorem block_image : C99FiniteMap114.lookup output.heap.blocks pointer.block=some dataBlock := by decide +kernel\n"++
    "theorem locals_image : output.locals=localSnapshot := by decide +kernel\n\n"++
    "theorem source : C99ProcedureSegments136.Prefix KeygenSearchFft.program FftShape138.firstCondition FftShape138.firstBody FftShape138.firstIncrement "++toString count++" (reference before) (reference output) :=\n"++
    "  C99ProcedureSegments138.run_source KeygenSearchFft.program FprFastCalls137.calls FprFastCalls137.sound 64 FftShape138.firstCondition FftShape138.firstBody FftShape138.firstIncrement "++toString count++" before output computed\n\n"++
    "theorem closed : C99ProcedureSegments136.Prefix KeygenSearchFft.program FftShape138.firstCondition FftShape138.firstBody FftShape138.firstIncrement "++toString count++" (reference before) (reference after) :=\n"++
    "  C99ProcedureNormalize138.source_normalized KeygenSearchFft.program FftShape138.firstCondition FftShape138.firstBody FftShape138.firstIncrement "++toString count++" before output \"a\".toList pointer dataBlock localSnapshot source\n"++
    "    FftShape138.first_writes FftShape138.first_increment_writes FftShape138.first_arrays FftShape138.first_increment_arrays pointer_binding block_image locals_image\n\n"++
    "theorem after_binding : (reference after).arrays \"a\".toList=some pointer := FftFirstChecks138.pointer_after before \"a\".toList pointer dataBlock localSnapshot pointer_binding\n\n"++
    "end FT1536.Source3."++name++"\n"
  IO.FS.writeFile ("../"++name++".lean") text

def generate : IO Unit := do
  let before ← initial
  let some pointer := C99NameMap115.lookup before.arrays "a".toList |
    throw (IO.userError "Missing candidate FFT pointer")
  emit "GeneratedFft138FirstF00" "SelectedFftFStart138" true 16 pointer (← segment 16 before)

end FT1536.Source3.FftFirst138Generator
#eval FT1536.Source3.FftFirst138Generator.generate
