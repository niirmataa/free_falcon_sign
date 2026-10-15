import Source3.FirstSegment128Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted proposal generation. Every emitted image and every transition
   is checked against the actual full-input execution by separate proofs. -/
namespace FT1536.Source3.SamplerSegments128Generator
open C99CompactState115 (State)
open Process122Generator (blockText tableText cellText)

def segment (count : Nat) (before : State) : IO ShakeProcessEvents128.Result :=
  match KeygenOuterSegment128.run ⟨30,8⟩
      (ShakeProcessProposal128.propose GeneratedProcessTransitions128.candidates) 256 7 64 count before with
  | some output => pure output
  | none => throw (IO.userError "Candidate sampler segment undefined")

def emit (name previous : String) (count : Nat) (proposed : ShakeProcessEvents128.Result) : IO Unit := do
  let context ← match C99FiniteMap114.lookup proposed.1.heap.blocks 30 with
    | some block => pure block | none => throw (IO.userError "Missing context image")
  let coefficients ← match C99FiniteMap114.lookup proposed.1.heap.blocks 10 with
    | some block => pure block | none => throw (IO.userError "Missing coefficient image")
  let text := "import Source3." ++ previous ++ "\nimport Source3.GeneratedProcessTransitions128\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
    "namespace FT1536.Source3." ++ name ++ "\nopen C99CompactState115 (State reference)\nopen SelectedFullSampler128 (ctx destination)\n\n" ++
    "def before : State := " ++ previous ++ ".after\n" ++
    "def propose := ShakeProcessProposal128.propose GeneratedProcessTransitions128.candidates\n" ++
    "def result := KeygenOuterSegment128.run ctx propose 256 7 64 " ++ toString count ++ " before\n" ++
    "theorem defined : result.isSome=true := by decide +kernel\n" ++
    "def output : ShakeProcessEvents128.Result := result.get defined\n" ++
    "theorem computed : KeygenOuterSegment128.run ctx propose 256 7 64 " ++ toString count ++ " before=some output := SelectedInput124.option_get result defined\n\n" ++
    "def contextBlock : C99FiniteMemory114.Block := " ++ blockText context ++ "\n\n" ++
    "def coefficientBlock : C99FiniteMemory114.Block := " ++ blockText coefficients ++ "\n\n" ++
    "def localSnapshot : C99CompactCells115.Locals := " ++ tableText cellText proposed.1.locals ++ "\n\n" ++
    "def after : State := KeygenSamplerNormalize128.normalize ctx destination before contextBlock coefficientBlock localSnapshot\n\n" ++
    "theorem pointer_binding : (reference before).arrays \"v\".toList=some destination := by decide +kernel\n" ++
    "theorem context_image : C99FiniteMap114.lookup output.1.heap.blocks ctx.block=some contextBlock := by decide +kernel\n" ++
    "theorem coefficient_image : C99FiniteMap114.lookup output.1.heap.blocks destination.block=some coefficientBlock := by decide +kernel\n" ++
    "theorem locals_image : output.1.locals=localSnapshot := by decide +kernel\n" ++
    "theorem event_count : output.2.length=" ++ toString proposed.2.length ++ " := by decide +kernel\n\n" ++
    "def Obligations : Prop := ShakeProcessEvents128.All ctx output.2\n" ++
    "theorem source (checked : Obligations) : KeygenSamplerPrefix128.Prefix ctx " ++ toString count ++ " (reference before) (reference output.1) :=\n" ++
    "  KeygenSamplerPrefix128.run_prefix ctx propose 256 7 64 " ++ toString count ++ " before output.1 output.2 computed checked\n\n" ++
    "theorem normalized (checked : Obligations) : KeygenSamplerPrefix128.Prefix ctx " ++ toString count ++ " (reference before) (reference after) :=\n" ++
    "  KeygenSamplerNormalize128.source_normalized _ _ " ++ toString count ++ " _ _ _ _ _ (source checked) pointer_binding context_image coefficient_image locals_image\n\n" ++
    (if proposed.2.isEmpty then
      "theorem obligations : Obligations := by\n  intro event member\n  have empty : output.2=[] := List.length_eq_zero_iff.mp event_count\n  rw [empty] at member\n  simp at member\n\ntheorem closed : KeygenSamplerPrefix128.Prefix ctx " ++ toString count ++ " (reference before) (reference after) := normalized obligations\n\n"
     else "") ++
    "end FT1536.Source3." ++ name ++ "\n"
  IO.FS.writeFile ("../" ++ name ++ ".lean") text

def generate : IO Unit := do
  let before ← FirstSegment128Generator.initial
  let first ← segment 1 before
  let proposed ← segment 63 first.1
  emit "GeneratedSampler128F01" "GeneratedFirstSegment128" 63 proposed

end FT1536.Source3.SamplerSegments128Generator

#eval FT1536.Source3.SamplerSegments128Generator.generate
