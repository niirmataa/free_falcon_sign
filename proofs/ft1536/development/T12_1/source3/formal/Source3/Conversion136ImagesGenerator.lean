import Source3.Conversion136Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Finite control proposals; final block text is compared with the already
   kernel-checked generated source blocks before using these controls. -/
namespace FT1536.Source3.Conversion136ImagesGenerator

def words (state : C99CompactState115.State) (pointer : C99MemoryReference.ArrayPointer) : IO (Array String) := do
  let mut result := #[]
  for i in List.range 1536 do
    let some word := C99FiniteRead114.read64 state.heap {pointer with index := pointer.index+i} |
      throw (IO.userError "Missing conversion output word")
    result := result.push (toString word.toNat)
  pure result

def generate : IO Unit := do
  let mut rows : Array Lean.Json := #[]
  let mut scratch : C99FiniteMemory114.Block := ⟨286720,true,some 0,.empty⟩
  let mut firstWords : Array String := #[]
  for (tag,input) in [("F","f"),("G","g")] do
    let mut state ← Conversion136Generator.initial input scratch
    let some pointer := C99NameMap115.lookup state.arrays "x".toList |
      throw (IO.userError "Missing output pointer")
    for _ in List.range 24 do
      state := (← Conversion136Generator.segment 64 state)
    let some block := C99FiniteMap114.lookup state.heap.blocks pointer.block |
      throw (IO.userError "Missing completed block")
    let out ← words state pointer
    if input="f" then firstWords := out else
      if (← words state {pointer with index := 0}) != firstWords then
        throw (IO.userError "Candidate second call changed first output")
    scratch := block
    IO.FS.writeFile ("../CONVERSION136_"++tag++"_BLOCK.txt") (Process122Generator.blockText block)
    rows := rows.push (Lean.Json.mkObj [("array",Lean.toJson input),("words",Lean.toJson out),
      ("pointer",Lean.toJson (Process122Generator.pointerText pointer))])
  IO.FS.writeFile "../CONVERSION136_IMAGES.json" (Lean.Json.pretty (Lean.Json.mkObj [
    ("status",Lean.toJson "FINITE_CONTROL_PROPOSALS_ONLY"),("outputs",Lean.Json.arr rows),
    ("first_output_preserved_after_second",Lean.toJson true)]))

end FT1536.Source3.Conversion136ImagesGenerator
#eval FT1536.Source3.Conversion136ImagesGenerator.generate
