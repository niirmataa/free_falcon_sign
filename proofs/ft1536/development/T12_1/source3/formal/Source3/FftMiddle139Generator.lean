import Source3.FftMiddleLoad139
import Source3.FftFirstCached138Generator
import Source3.KeygenFftObjects127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted candidate computation only. Emitted kernel checks use the actual
   source state, with the full original heap and both readonly tables. -/
namespace FT1536.Source3.FftMiddle139Generator
open C99CompactState115 (State)
open Process122Generator (blockText tableText cellText pointerText)

def initial : IO State := do
  let heap := C99FiniteMemory114.putBlock (KeygenFftObjects127.heap ⟨.empty⟩) 31
    GeneratedFft138FirstF24.dataBlock
  let mut state : State := ⟨heap,GeneratedFft138FirstF24.localSnapshot,
    (("a".toList,⟨31,0,35840,8,0⟩)::FirstSegment128Generator.tables),FirstSegment128Generator.globals,FirstSegment128Generator.tables⟩
  for (code,phase) in ([FftMiddleShape139.setT,FftMiddleShape139.setMinimum,
      FftMiddleShape139.outerInitial,FftMiddleShape139.outerPrologue,
      FftMiddleShape139.groupInitial,FftMiddleShape139.groupPrologue,
      FftMiddleShape139.butterflyInitial]).zipIdx do
    let some after := C99ProcedureRun138.run FprFastCalls137.calls 64 code state |
      throw (IO.userError ("Middle FFT candidate setup failed at phase "++toString phase))
    state := after
  pure state

def segment (count : Nat) (before : State) : IO State :=
  match C99ProcedureSegments138.run FprFastCalls137.calls 96 FftMiddleShape139.butterflyCondition
      FftMiddleShape139.butterflyBody FftMiddleShape139.butterflyIncrement count before with
  | some after => pure after
  | none => throw (IO.userError "Middle FFT butterfly candidate prefix failed")

def emit (name origin : String) (count : Nat) (pointer : C99MemoryReference.ArrayPointer)
    (proposed : State) : IO Unit := do
  let some block := C99FiniteMap114.lookup proposed.heap.blocks pointer.block |
    throw (IO.userError "Middle FFT destination block missing")
  let text := "import Source3.FftMiddleLoad139\nimport Source3.C99ProcedureCapture138\n\n"++
    "set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3."++name++"\nopen C99CompactState115 (State reference)\n\n"++
    "def before : State := "++origin++"\n"++
    "def pointer : C99MemoryReference.ArrayPointer := "++pointerText pointer++"\n"++
    "def result := C99ProcedureSegments138.run FprFastCalls137.calls 96 FftMiddleShape139.butterflyCondition FftMiddleShape139.butterflyBody FftMiddleShape139.butterflyIncrement "++toString count++" before\n\n"++
    "def dataBlock : C99FiniteMemory114.Block := "++blockText block++"\n\n"++
    "def localSnapshot : C99CompactCells115.Locals := "++tableText cellText proposed.locals++"\n\n"++
    "def after : State := C99ProcedureNormalize138.normalize before pointer.block dataBlock localSnapshot\n"++
    "theorem pointer_binding : (reference before).arrays \"a\".toList=some pointer := by decide +kernel\n"++
    "theorem checked : C99ProcedureCapture138.capture result pointer.block=some (dataBlock,localSnapshot) := by decide +kernel\n\n"++
    "theorem closed : C99ProcedureSegments136.Prefix KeygenSearchFft.program FftMiddleShape139.butterflyCondition FftMiddleShape139.butterflyBody FftMiddleShape139.butterflyIncrement "++toString count++" (reference before) (reference after) :=\n"++
    "  C99ProcedureCapture138.source KeygenSearchFft.program FprFastCalls137.calls FprFastCalls137.sound 96 FftMiddleShape139.butterflyCondition FftMiddleShape139.butterflyBody FftMiddleShape139.butterflyIncrement "++toString count++" before \"a\".toList pointer dataBlock localSnapshot\n"++
    "    FftMiddleShape139.butterfly_writes FftMiddleShape139.butterfly_increment_writes FftMiddleShape139.butterfly_arrays FftMiddleShape139.butterfly_increment_arrays pointer_binding checked\n\n"++
    "end FT1536.Source3."++name++"\n"
  IO.FS.writeFile ("../"++name++".lean") text

def generate : IO Unit := do
  let before ← initial
  emit "GeneratedFft139MiddlePilot" "FftMiddleLoad139.initial" 4 ⟨31,0,35840,8,0⟩ (← segment 4 before)

end FT1536.Source3.FftMiddle139Generator
#eval FT1536.Source3.FftMiddle139Generator.generate
