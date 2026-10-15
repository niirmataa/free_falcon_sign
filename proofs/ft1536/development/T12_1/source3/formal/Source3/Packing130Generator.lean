import Source3.GeneratedSamplerWords129
import Source3.FirstSegment128Generator
import Source3.PackingShape130
import Source3.C99ScalarSteps130
import Source3.KeygenResultantInit130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted proposal only. All emitted computations and complete state
   images refer to the actual source input and require kernel checking. -/
namespace FT1536.Source3.Packing130Generator
open C99CompactState115 (State)
open C99FiniteMemory114 (Heap)
open Process122Generator (blockText tableText cellText)

def initial (name : String) : IO State := do
  let mut heap : Heap := C99FiniteMemory114.putBlock
    (C99FiniteMemory114.putBlock ⟨.empty⟩ 10 ⟨6144,true,none,.empty⟩) 11 ⟨6144,true,none,.empty⟩
  for i in List.range 1536 do
    let f := (C99FiniteMap114.lookup GeneratedSamplerWords129.fWords i).getD 0
    let g := (C99FiniteMap114.lookup GeneratedSamplerWords129.gWords i).getD 0
    heap := C99FiniteWrite114.writeVec heap 10 (2*i) 2 (KeygenSmallOutput.byte16 (BitVec.ofInt 16 f))
    heap := C99FiniteWrite114.writeVec heap 11 (2*i) 2 (KeygenSmallOutput.byte16 (BitVec.ofInt 16 g))
  let caller : State := ⟨heap,[("logn".toList,.u32 (some 10))],
    [("f".toList,⟨10,0,3072,2,0⟩),("g".toList,⟨11,0,3072,2,0⟩)],
    FirstSegment128Generator.globals,FirstSegment128Generator.tables⟩
  let bound ← match C99CompactBinding115.bind C99CompactPointer115.noCalls caller
      KeygenResultantSource.params (KeygenResultantGate.arguments name) with
    | some value => pure value | none => throw (IO.userError "Candidate binding failed")
  let ready ← match C99ScalarSteps130.run 16 GeneratedResultantSyntax130.setup (KeygenResultantInit130.entry bound 7) with
    | some value => pure value | none => throw (IO.userError "Candidate setup failed")
  match KeygenWordEndpoints130.normal 32 PackingShape130.initial (KeygenResultantInit130.zeroed ready 7) with
  | some value => pure value | none => throw (IO.userError "Candidate packing initialization failed")

def segment (count : Nat) (before : State) : IO State :=
  match KeygenWordSegments130.run 32 PackingShape130.condition PackingShape130.body PackingShape130.increment count before with
  | some value => pure value | none => throw (IO.userError "Candidate packing segment failed")

def emit (name previous : String) (first : Bool) (count : Nat) (proposed : State) : IO Unit := do
  let data ← match C99FiniteMap114.lookup proposed.heap.blocks 7 with
    | some value => pure value | none => throw (IO.userError "Missing packed b block")
  let origin := previous ++ (if first then ".initial" else ".after")
  let pointerProof := previous ++ (if first then ".pointer_binding" else ".after_binding")
  let text := "import Source3." ++ previous ++ "\nimport Source3.KeygenWordBinding130\n\n" ++
    "set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
    "namespace FT1536.Source3." ++ name ++ "\nopen C99CompactState115 (State reference)\nopen PackingShape130 (condition body increment)\n\n" ++
    "def before : State := " ++ origin ++ "\n" ++
    "def pointer := KeygenResultantSource.object 7\n" ++
    "def result := KeygenWordSegments130.run 32 condition body increment " ++ toString count ++ " before\n" ++
    "theorem defined : result.isSome=true := by decide +kernel\n" ++
    "def output : State := result.get defined\n" ++
    "theorem computed : KeygenWordSegments130.run 32 condition body increment " ++ toString count ++ " before=some output := SelectedInput124.option_get result defined\n\n" ++
    "def dataBlock : C99FiniteMemory114.Block := " ++ blockText data ++ "\n\n" ++
    "def localSnapshot : C99CompactCells115.Locals := " ++ tableText cellText proposed.locals ++ "\n\n" ++
    "def after : State := KeygenWordNormalize130.normalize before 7 dataBlock localSnapshot\n" ++
    "theorem pointer_binding : (reference before).arrays \"b\".toList=some pointer := " ++ pointerProof ++ "\n" ++
    "theorem block_image : C99FiniteMap114.lookup output.heap.blocks 7=some dataBlock := by decide +kernel\n" ++
    "theorem locals_image : output.locals=localSnapshot := by decide +kernel\n\n" ++
    "theorem source : KeygenWordSegments130.Prefix condition body increment " ++ toString count ++ " (reference before) (reference output) := KeygenWordSegments130.run_source 32 condition body increment " ++ toString count ++ " before output computed\n\n" ++
    "theorem closed : KeygenWordSegments130.Prefix condition body increment " ++ toString count ++ " (reference before) (reference after) :=\n" ++
    "  KeygenWordNormalize130.source_normalized condition body increment " ++ toString count ++ " before output \"b\".toList pointer dataBlock localSnapshot source\n" ++
    "    PackingShape130.body_writes PackingShape130.increment_writes PackingShape130.body_arrays PackingShape130.increment_arrays pointer_binding block_image locals_image\n\n" ++
    "theorem after_binding : (reference after).arrays \"b\".toList=some pointer := KeygenWordBinding130.pointer_after before \"b\".toList pointer dataBlock localSnapshot pointer_binding\n\n" ++
    "end FT1536.Source3." ++ name ++ "\n"
  IO.FS.writeFile ("../" ++ name ++ ".lean") text

def generate : IO Unit := do
  let before ← initial "f"
  emit "GeneratedPacking130F00" "SelectedPackingF130" true 64 (← segment 64 before)

end FT1536.Source3.Packing130Generator

#eval FT1536.Source3.Packing130Generator.generate
