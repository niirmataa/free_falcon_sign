import Source3.CompiledButterfly140
import Source3.NormalizedFftMiddle139
import Source3.FftMiddle139Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftButterfly140PrefixGenerator
open Process122Generator (blockText tableText cellText)

def initial : C99CompactState115.State :=
  ⟨C99FiniteMemory114.putBlock ⟨.empty⟩ 31 GeneratedFft139MiddleNext.dataBlock,
    GeneratedFft139MiddleNext.localSnapshot,
    ("a".toList,⟨31,0,35840,8,0⟩)::FirstSegment128Generator.tables,
    FirstSegment128Generator.globals,FirstSegment128Generator.tables⟩

def emit (name previous origin : String) (count : Nat) (state : C99CompactState115.State) : IO Unit := do
  let some block := C99FiniteMap114.lookup state.heap.blocks 31 | throw (IO.userError "Missing butterfly output block")
  let text := "import Source3."++previous++"\nimport Source3.CompiledButterfly140\nimport Source3.C99CompiledCapture140\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3."++name++"\nopen C99CompactState115 (State reference)\nopen FftMiddleShape139\n\n"++
    "def before : State := "++origin++"\ndef pointer : C99MemoryReference.ArrayPointer := ⟨31,0,35840,8,0⟩\n"++
    "def result := CompiledButterfly140.run FprFastCalls137.calls "++toString count++" before\n\n"++
    "def dataBlock : C99FiniteMemory114.Block := "++blockText block++"\n\n"++
    "def localSnapshot : C99CompactCells115.Locals := "++tableText cellText state.locals++"\n\n"++
    "def after : State := C99ProcedureNormalize138.normalize before 31 dataBlock localSnapshot\n\n"++
    "theorem pointer_binding : (reference before).arrays \"a\".toList=some pointer := by decide +kernel\n"++
    "theorem checked : C99ProcedureCapture138.capture result 31=some (dataBlock,localSnapshot) := by decide +kernel\n\n"++
    "theorem closed : C99ProcedureSegments136.Prefix KeygenSearchFft.program butterflyCondition butterflyBody butterflyIncrement "++toString count++" (reference before) (reference after) :=\n"++
    "  C99CompiledCapture140.source KeygenSearchFft.program butterflyCondition butterflyBody butterflyIncrement "++toString count++" before result\n"++
    "    (fun after computed => CompiledButterfly140.source FprFastCalls137.calls FprFastCalls137.sound "++toString count++" before after computed)\n"++
    "    \"a\".toList pointer dataBlock localSnapshot butterfly_writes butterfly_increment_writes butterfly_arrays butterfly_increment_arrays pointer_binding checked\n\n"++
    "end FT1536.Source3."++name++"\n"
  IO.FS.writeFile ("../"++name++".lean") text

def generate : IO Unit := do
  let after ← FftMiddle139Generator.segment 16 initial
  emit "GeneratedFft140Middle16" "NormalizedFftMiddle139" "NormalizedFftMiddle139.after" 16 after

end FT1536.Source3.FftButterfly140PrefixGenerator
#eval FT1536.Source3.FftButterfly140PrefixGenerator.generate
