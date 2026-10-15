import Source3.SamplerProcess129Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted G proposals follow the same F heap, with source binding and
   local bit reset. Actual full-input checks remain separate obligations. -/
namespace FT1536.Source3.SamplerG129Generator
open C99CompactState115 (State)
open Process122Generator (blockText tableText cellText two)
open SamplerSegments128Generator (segment)

def emitG (name previous : String) (count : Nat) (proposed : ShakeProcessEvents128.Result) : IO Unit := do
  let context ← match C99FiniteMap114.lookup proposed.1.heap.blocks 30 with
    | some block => pure block | none => throw (IO.userError "Missing context image")
  let coefficients ← match C99FiniteMap114.lookup proposed.1.heap.blocks 11 with
    | some block => pure block | none => throw (IO.userError "Missing coefficient image")
  let text := "import Source3." ++ previous ++ "\nimport Source3.GeneratedProcessTransitions128\nimport Source3.KeygenLazySampler129\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
    "namespace FT1536.Source3." ++ name ++ "\nopen C99CompactState115 (State reference)\nopen SelectedGStart129 (ctx destination)\n\n" ++
    "def before : State := " ++ previous ++ ".after\n" ++
    "def propose := ShakeProcessProposal128.propose GeneratedProcessTransitions128.candidates\n" ++
    "def result := KeygenOuterSegment128.run ctx propose 256 7 64 " ++ toString count ++ " before\n" ++
    "theorem defined : result.isSome=true := by decide +kernel\n" ++
    "def output : ShakeProcessEvents128.Result := result.get defined\n" ++
    "theorem computed : KeygenOuterSegment128.run ctx propose 256 7 64 " ++ toString count ++ " before=some output := SelectedInput124.option_get result defined\n\n" ++
    "def contextBlock : C99FiniteMemory114.Block := " ++ blockText context ++ "\n\n" ++
    "def coefficientBlock : C99FiniteMemory114.Block := " ++ blockText coefficients ++ "\n\n" ++
    "def localSnapshot : C99CompactCells115.Locals := " ++ tableText cellText proposed.1.locals ++ "\n\n" ++
    "def after : State := KeygenLazySampler129.normalize ctx destination before contextBlock coefficientBlock localSnapshot\n\n" ++
    "theorem pointer_binding : (reference before).arrays \"v\".toList=some destination := " ++ previous ++ ".pointer_binding\n" ++
    "theorem context_image : C99FiniteMap114.lookup output.1.heap.blocks ctx.block=some contextBlock := by decide +kernel\n" ++
    "theorem coefficient_image : C99FiniteMap114.lookup output.1.heap.blocks destination.block=some coefficientBlock := by decide +kernel\n" ++
    "theorem locals_image : output.1.locals=localSnapshot := by decide +kernel\n" ++
    "theorem event_count : output.2.length=" ++ toString proposed.2.length ++ " := by decide +kernel\n\n" ++
    "def Obligations : Prop := ShakeProcessEvents128.All ctx output.2\n" ++
    "theorem source (checked : Obligations) : KeygenSamplerPrefix128.Prefix ctx " ++ toString count ++ " (reference before) (reference output.1) :=\n" ++
    "  KeygenSamplerPrefix128.run_prefix ctx propose 256 7 64 " ++ toString count ++ " before output.1 output.2 computed checked\n\n" ++
    "theorem normalized (checked : Obligations) : KeygenSamplerPrefix128.Prefix ctx " ++ toString count ++ " (reference before) (reference after) :=\n" ++
    "  KeygenLazySampler129.source_normalized _ _ " ++ toString count ++ " _ _ _ _ _ (source checked) pointer_binding context_image coefficient_image locals_image\n\n" ++
    (if proposed.2.isEmpty then
      "theorem obligations : Obligations := by\n  intro event member\n  have empty : output.2=[] := List.length_eq_zero_iff.mp event_count\n  rw [empty] at member\n  simp at member\n\ntheorem closed : KeygenSamplerPrefix128.Prefix ctx " ++ toString count ++ " (reference before) (reference after) := normalized obligations\n\n"
     else "") ++
    "end FT1536.Source3." ++ name ++ "\n"
  IO.FS.writeFile ("../" ++ name ++ ".lean") text

def generate : IO Unit := do
  let initial ← FirstSegment128Generator.initial
  let first ← segment 1 initial
  let next ← segment 63 first.1
  let mut state := next.1
  for _ in List.range 23 do
    state := (← segment 64 state).1
  let caller : State := {state with
    locals := [("n".toList,.u64 (some 1536))]
    arrays := [("g".toList,⟨11,0,3072,2,0⟩)]}
  let bound ← match C99CompactBinding115.bind C99CompactPointer115.noCalls caller
      KeygenSamplerCalls.params (KeygenSamplerCalls.arguments "g") with
    | some value => pure value | none => throw (IO.userError "G candidate binding failed")
  let declared ← match KeygenScalarCompute121.run 16 KeygenSamplerSource.prologue bound with
    | some value => pure value | none => throw (IO.userError "G candidate prologue failed")
  let ready ← match KeygenScalarCompute121.run 16 KeygenSamplerSource.initial declared with
    | some value => pure value | none => throw (IO.userError "G candidate initialization failed")
  state := ready
  let mut previous := "SelectedGStart129"
  let mut manifest : Array Lean.Json := #[]
  for i in List.range 24 do
    let suffix := "G" ++ two (i+1)
    let name := "GeneratedSampler129" ++ suffix
    let proposed ← segment 64 state
    emitG name previous 64 proposed
    if i+1>=20 then
      let path := "../" ++ name ++ ".lean"
      let content ← IO.FS.readFile path
      let support := if i+1=20 then "G19Pointer129" else "KeygenLazyBinding129"
      let content := content.replace "import Source3.GeneratedProcessTransitions128\n"
        ("import Source3.GeneratedProcessTransitions128\nimport Source3." ++ support ++ "\n")
      let bindingName := if i+1=20 then "G19Pointer129.after_binding" else previous ++ ".after_binding"
      let content := content.replace (previous ++ ".pointer_binding") bindingName
      let ending := "end FT1536.Source3." ++ name
      let transfer := "theorem after_binding : (reference after).arrays \"v\".toList=some destination :=\n" ++
        "  KeygenLazyBinding129.pointer_after ctx destination before contextBlock coefficientBlock localSnapshot pointer_binding\n\n"
      IO.FS.writeFile path (content.replace ending (transfer ++ ending))
    if proposed.2.length=1 then
      match proposed.2 with
      | event::_ => SamplerProcess129Generator.generateEvent suffix event.before
      | [] => throw (IO.userError "Missing G event")
    else if !proposed.2.isEmpty then
      throw (IO.userError "Unexpected multiple G process events")
    manifest := manifest.push (Lean.Json.mkObj [("module",Lean.toJson name),
      ("count",Lean.toJson (64:Nat)),("through",Lean.toJson (64*(i+1:Nat))),
      ("events",Lean.toJson proposed.2.length)])
    state := proposed.1
    previous := name
  IO.FS.writeFile "../G_SEGMENTS129.json" (Lean.Json.arr manifest |>.pretty)

end FT1536.Source3.SamplerG129Generator

#eval FT1536.Source3.SamplerG129Generator.generate
