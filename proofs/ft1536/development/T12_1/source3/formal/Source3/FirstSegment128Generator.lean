import Source3.GeneratedProcessTransitions128
import Source3.KeygenOuterSegment128
import Source3.Process122Generator
import Source3.FftGlobalScalars

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted local proposal computation only. Emitted checks compare all
   changed data with the ACTUAL full-input segment, not this shadow heap. -/
namespace FT1536.Source3.FirstSegment128Generator
open C99CompactState115 (State)
open C99MemoryReference (ArrayPointer)
open Process122Generator (blockText tableText cellText)

def globals : C99CompactCells115.Locals :=
  FftGlobalScalars.expected.map (fun pair => (pair.1,C99CompactCells115.Cell.u64 (some pair.2)))

def tables : C99CompactState115.Pointers := [
  ("RC".toList,⟨20,0,24,8,0⟩),("PRIMES3".toList,⟨21,0,1101,12,0⟩),("REV10".toList,⟨22,0,1024,2,0⟩),
  ("PRIMES2".toList,⟨23,0,522,12,0⟩),("MAX_BL_SMALL2".toList,⟨24,0,11,8,0⟩),
  ("MAX_BL_LARGE2".toList,⟨25,0,10,8,0⟩),("MAX_BL_SMALL3".toList,⟨26,0,12,8,0⟩),
  ("MAX_BL_LARGE3".toList,⟨27,0,11,8,0⟩),("bitlength.vv".toList,⟨28,0,32,4,0⟩),
  ("fpr_gm3_square".toList,⟨1,0,2048,8,0⟩),("fpr_gm3_cubic".toList,⟨2,0,4096,8,0⟩)]

def initial : IO State := do
  let context ← match C99FiniteMap114.lookup GeneratedSeed119Fixture.flipped.heap.blocks 1 with
    | some block => pure block | none => throw (IO.userError "Missing pinned context image")
  let rc ← match C99FiniteMap114.lookup GeneratedSeed119Fixture.flipped.heap.blocks 20 with
    | some block => pure block | none => throw (IO.userError "Missing pinned RC image")
  let h0 := C99FiniteMemory114.putBlock (C99FiniteMemory114.putBlock ⟨.empty⟩ 30 context) 20 rc
  let h1 := C99FiniteMemory114.putBlock h0 10 ⟨6144,true,none,.empty⟩
  let h2 := C99FiniteMemory114.putBlock h1 11 ⟨6144,true,none,.empty⟩
  let h3 := C99FiniteWrite114.write32 h2 ⟨30,0,1,4,0⟩ 10
  let h4 := C99FiniteWrite114.write32 h3 ⟨30,4,1,4,0⟩ 1
  let h5 := C99FiniteWrite114.write32 h4 ⟨30,424,1,4,0⟩ 1
  let h6 := C99FiniteWrite114.write32 h5 ⟨30,428,1,4,0⟩ 1
  let h7 := C99FiniteWrite114.write64 h6 ⟨30,432,1,8,0⟩ 55834574848
  let h8 := C99FiniteWrite114.write64 h7 ⟨30,440,1,8,0⟩ 286720
  let caller : State := ⟨h8,[("n".toList,.u64 (some 1536))],[("f".toList,⟨10,0,3072,2,0⟩)],globals,tables⟩
  let bound ← match C99CompactBinding115.bind C99CompactPointer115.noCalls caller KeygenSamplerCalls.params (KeygenSamplerCalls.arguments "f") with
    | some state => pure state | none => throw (IO.userError "Proposal binding failed")
  let declared ← match KeygenScalarCompute121.run 16 KeygenSamplerSource.prologue bound with
    | some state => pure state | none => throw (IO.userError "Proposal prologue failed")
  match KeygenScalarCompute121.run 16 KeygenSamplerSource.initial declared with
  | some state => pure state | none => throw (IO.userError "Proposal initialization failed")

def generate : IO Unit := do
  let before ← initial
  let proposed ← match KeygenOuterSegment128.run ⟨30,8⟩
      (ShakeProcessProposal128.propose GeneratedProcessTransitions128.candidates) 256 7 64 1 before with
    | some output => pure output | none => throw (IO.userError "Proposal segment failed")
  let context ← match C99FiniteMap114.lookup proposed.1.heap.blocks 30 with
    | some block => pure block | none => throw (IO.userError "Missing proposed context")
  let coefficients ← match C99FiniteMap114.lookup proposed.1.heap.blocks 10 with
    | some block => pure block | none => throw (IO.userError "Missing proposed coefficients")
  let text := "import Source3.SelectedFirst128\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
    "namespace FT1536.Source3.GeneratedFirstSegment128\nopen C99CompactState115 (State reference)\n\n" ++
    "def contextBlock : C99FiniteMemory114.Block := " ++ blockText context ++ "\n\n" ++
    "def coefficientBlock : C99FiniteMemory114.Block := " ++ blockText coefficients ++ "\n\n" ++
    "def localSnapshot : C99CompactCells115.Locals := " ++ tableText cellText proposed.1.locals ++ "\n\n" ++
    "def after : State := KeygenSamplerNormalize128.normalize SelectedFullSampler128.ctx SelectedFullSampler128.destination SelectedFullSampler128.initial contextBlock coefficientBlock localSnapshot\n\n" ++
    "theorem context_image : C99FiniteMap114.lookup SelectedFirst128.output.1.heap.blocks SelectedFullSampler128.ctx.block=some contextBlock := by decide +kernel\n\n" ++
    "theorem coefficient_image : C99FiniteMap114.lookup SelectedFirst128.output.1.heap.blocks SelectedFullSampler128.destination.block=some coefficientBlock := by decide +kernel\n\n" ++
    "theorem locals_image : SelectedFirst128.output.1.locals=localSnapshot := by decide +kernel\n\n" ++
    "theorem normalized (checked : SelectedFirst128.Obligations) : KeygenSamplerPrefix128.Prefix SelectedFullSampler128.ctx 1 (reference SelectedFullSampler128.initial) (reference after) :=\n" ++
    "  KeygenSamplerNormalize128.source_normalized _ _ 1 _ _ _ _ _ (SelectedFirst128.source checked) SelectedFullSampler128.pointer_binding context_image coefficient_image locals_image\n\n" ++
    "end FT1536.Source3.GeneratedFirstSegment128\n"
  IO.FS.writeFile "../GeneratedFirstSegment128.lean" text

end FT1536.Source3.FirstSegment128Generator

#eval FT1536.Source3.FirstSegment128Generator.generate
