import Source3.GeneratedSamplerWords129
import Source3.FirstSegment128Generator
import Source3.FprTernary136
import Source3.C99ProcedureRun136
import Source3.KeygenSmallChecks136
import Source3.Process122Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Minimal-state untrusted image proposals; emitted checks always evaluate the actual
   selected input and use source frames to identify the entire next state. -/
namespace FT1536.Source3.Conversion136Generator
open C99CompactState115 (State)
open Process122Generator (blockText tableText cellText pointerText)

def initial (input : String := "f") (scratch : C99FiniteMemory114.Block := ⟨286720,true,some 0,.empty⟩) : IO State := do
  let sourceBlock := if input="f" then 10 else 11
  let destination := if input="f" then "rt1" else "rt2"
  let start := if input="f" then 0 else 1536
  let mut heap : C99FiniteMemory114.Heap := C99FiniteMemory114.putBlock
    (C99FiniteMemory114.putBlock ⟨.empty⟩ 31 scratch) sourceBlock ⟨6144,true,none,.empty⟩
  for i in List.range 1536 do
    let word := BitVec.ofInt 16 ((C99FiniteMap114.lookup (if input="f" then GeneratedSamplerWords129.fWords else GeneratedSamplerWords129.gWords) i).getD 0)
    heap := C99FiniteWrite114.writeVec heap sourceBlock (2*i) 2 (KeygenSmallOutput.byte16 word)
  let caller : State := ⟨heap,[("logn".toList,.u32 (some 10))],
    [(destination.toList,⟨31,0,35840,8,start⟩),(input.toList,⟨sourceBlock,0,3072,2,0⟩)],
    FirstSegment128Generator.globals,FirstSegment128Generator.tables⟩
  let some bound := C99CompactBinding115.bind C99CompactPointer115.noCalls caller
      KeygenSearchLeaves.smallParams (KeygenSmallShape136.args destination input) |
    throw (IO.userError "Candidate small binding failed")
  let some declared := C99ProcedureRun136.run FprTernary136.calls 4 KeygenSmallShape136.declaration bound |
    throw (IO.userError "Candidate small declaration failed")
  let some sized := C99ProcedureRun136.run FprTernary136.calls 4 KeygenSmallShape136.size declared |
    throw (IO.userError "Candidate small size failed")
  let some ready := C99ProcedureRun136.run FprTernary136.calls 4 KeygenSmallShape136.initial sized |
    throw (IO.userError "Candidate small counter failed")
  pure ready

def segment (count : Nat) (before : State) : IO State :=
  match C99ProcedureSegments136.run FprTernary136.calls 32 SmallintsProgram.condition
      KeygenSmallShape136.iteration SmallintsProgram.increment count before with
  | some after => pure after
  | none => throw (IO.userError "Conversion source candidate prefix failed")

def emit (name previous : String) (first : Bool) (count : Nat) (pointer : C99MemoryReference.ArrayPointer)
    (proposed : State) : IO Unit := do
  let some block := C99FiniteMap114.lookup proposed.heap.blocks pointer.block |
    throw (IO.userError "Conversion destination block missing")
  let origin := previous ++ (if first then ".initial" else ".after")
  let binding := if first then "by decide +kernel" else previous++".after_binding"
  let text := "import Source3." ++ previous ++ "\nimport Source3.KeygenSmallChecks136\n\n" ++
    "set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
    "namespace FT1536.Source3." ++ name ++ "\nopen C99CompactState115 (State reference)\n\n" ++
    "def before : State := " ++ origin ++ "\n" ++
    "def pointer : C99MemoryReference.ArrayPointer := " ++ pointerText pointer ++ "\n" ++
    "def result := C99ProcedureSegments136.run FprTernary136.calls 32 SmallintsProgram.condition KeygenSmallShape136.iteration SmallintsProgram.increment " ++ toString count ++ " before\n" ++
    "theorem defined : result.isSome=true := by decide +kernel\n" ++
    "def output : State := result.get defined\n" ++
    "theorem computed : C99ProcedureSegments136.run FprTernary136.calls 32 SmallintsProgram.condition KeygenSmallShape136.iteration SmallintsProgram.increment " ++ toString count ++ " before=some output := SelectedInput124.option_get result defined\n\n" ++
    "def dataBlock : C99FiniteMemory114.Block := " ++ blockText block ++ "\n\n" ++
    "def localSnapshot : C99CompactCells115.Locals := " ++ tableText cellText proposed.locals ++ "\n\n" ++
    "def after : State := C99ProcedureNormalize136.normalize before pointer.block dataBlock localSnapshot\n" ++
    "theorem pointer_binding : (reference before).arrays \"x\".toList=some pointer := " ++ binding ++ "\n" ++
    "theorem block_image : C99FiniteMap114.lookup output.heap.blocks pointer.block=some dataBlock := by decide +kernel\n" ++
    "theorem locals_image : output.locals=localSnapshot := by decide +kernel\n\n" ++
    "theorem source : C99ProcedureSegments136.Prefix KeygenSearchFft.program SmallintsProgram.condition KeygenSmallShape136.iteration SmallintsProgram.increment " ++ toString count ++ " (reference before) (reference output) :=\n" ++
    "  C99ProcedureSegments136.run_source KeygenSearchFft.program FprTernary136.calls FprTernary136.sound 32 SmallintsProgram.condition KeygenSmallShape136.iteration SmallintsProgram.increment " ++ toString count ++ " before output computed\n\n" ++
    "theorem closed : C99ProcedureSegments136.Prefix KeygenSearchFft.program SmallintsProgram.condition KeygenSmallShape136.iteration SmallintsProgram.increment " ++ toString count ++ " (reference before) (reference after) :=\n" ++
    "  C99ProcedureNormalize136.source_normalized KeygenSearchFft.program SmallintsProgram.condition KeygenSmallShape136.iteration SmallintsProgram.increment " ++ toString count ++ " before output \"x\".toList pointer dataBlock localSnapshot source\n" ++
    "    KeygenSmallChecks136.body_writes KeygenSmallChecks136.increment_writes KeygenSmallChecks136.body_arrays KeygenSmallChecks136.increment_arrays pointer_binding block_image locals_image\n\n" ++
    "theorem after_binding : (reference after).arrays \"x\".toList=some pointer := KeygenSmallChecks136.pointer_after before \"x\".toList pointer dataBlock localSnapshot pointer_binding\n\n" ++
    "end FT1536.Source3." ++ name ++ "\n"
  IO.FS.writeFile ("../"++name++".lean") text

def generate : IO Unit := do
  let before ← initial "f"
  let some pointer := C99NameMap115.lookup before.arrays "x".toList |
    throw (IO.userError "Candidate x binding missing")
  emit "GeneratedConversion136F00" "SelectedSmallFStart136" true 64 pointer (← segment 64 before)

end FT1536.Source3.Conversion136Generator
#eval FT1536.Source3.Conversion136Generator.generate
