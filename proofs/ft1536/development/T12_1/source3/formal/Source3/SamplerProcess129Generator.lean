import Source3.SamplerSegments128Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted candidate generation. Changed context bytes and locals are
   normalized; unchanged objects retain the SAME shared input expression.
   Each emitted computation still requires kernel conversion checking. -/
namespace FT1536.Source3.SamplerProcess129Generator
open C99CompactState115 (State)
open Process122Generator (tableText cellText pointerText blockText two)

def stateText (site : String) (state : State) (changed : Bool) : IO String := do
  let context ← match C99FiniteMap114.lookup state.heap.blocks 30 with
    | some data => pure data
    | none => throw (IO.userError "Missing source context block")
  let heapText := if changed then
    "C99FiniteMemory114.putBlock " ++ site ++ ".caller.heap " ++ site ++ ".ctx.block (" ++ blockText context ++ ")"
    else "" ++ site ++ ".caller.heap"
  pure ("{heap := " ++ heapText ++ ", locals := " ++ tableText cellText state.locals ++
    ", arrays := [(\"A\".toList," ++ site ++ ".pointer),(\"RC\".toList," ++ site ++ ".table)]" ++
    ", globals := " ++ site ++ ".caller.globals, tables := " ++ site ++ ".caller.tables}")

def run (fuel : Nat) (code : ShakeBlock.Stmt) (state : State) : IO State :=
  match ShakeBlockCompute116.run fuel code state with
  | none => throw (IO.userError "Source fragment proposal exhausted fuel or rejected an access")
  | some after => pure after

def generateEvent (suffix : String) (before : State) : IO Unit := do
  let site := "ProcessSite129" ++ suffix
  let entered := ShakeProcessCompute116.entry before ⟨30,224,25,8,0⟩ GeneratedSeed119Fixture.rcPointer
  let declared ← run 64 (ShakeBlock.chain ShakeBlock.prologue) entered
  let mut ready ← run 64 ShakeBlock.initial declared
  IO.FS.createDirAll "../generated"
  for round in List.range 12 do
    let finished ← run 1024 (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ready
    let next ← run 64 ShakeBlock.increment finished
    let moduleName := "GeneratedProcess129" ++ suffix ++ "Round" ++ two round
    let previous := "GeneratedProcess129" ++ suffix ++ "Round" ++ two (round-1)
    let header := "import Source3." ++ site ++ "\nimport Source3.ShakeBlockNormalize126\n" ++
      (if round=0 then "" else "import Source3." ++ previous ++ "\n") ++ "\n" ++
      "set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
      "namespace FT1536.Source3." ++ moduleName ++ "\nopen C99CompactState115 (State reference)\n\n"
    let declaredText ← stateText site declared false
    let readyText ← stateText site ready false
    let context ← match C99FiniteMap114.lookup finished.heap.blocks 30 with
      | some block => pure block
      | none => throw (IO.userError "Missing output context candidate")
    let declarations := if round=0 then "def declared : State := " ++ declaredText ++ "\n\n" else ""
    let definitions := declarations ++
      "def ready : State := " ++ (if round=0 then readyText else previous ++ ".next") ++ "\n\n" ++
      "def contextBlock : C99FiniteMemory114.Block := " ++ blockText context ++ "\n\n" ++
      "def localSnapshot : C99CompactCells115.Locals := " ++ tableText cellText finished.locals ++ "\n\n" ++
      "def finished : State := ShakeBlockNormalize126.normalize ready " ++ site ++ ".pointer contextBlock localSnapshot\n\n" ++
      "def next : State := {finished with locals := " ++ tableText cellText next.locals ++ "}\n\n"
    let scaffold := if round=0 then
      "theorem prologue_computed : ShakeBlockCompute116.run 64 (ShakeBlock.chain ShakeBlock.prologue)\n" ++
      "    " ++ site ++ ".blockEntry=some declared := by rfl\n\n" ++
      "theorem initial_computed : ShakeBlockCompute116.run 64 ShakeBlock.initial declared=some ready := by rfl\n\n"
      else ""
    let proofs :=
      "theorem guard_computed : ShakeBlockComputeRead116.evaluate ready ShakeBlock.condition=some (.i32 1) := by rfl\n\n" ++
      "theorem locals_computed : (ShakeBlockCompute116.run 1024 (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ready).map State.locals=some localSnapshot := by decide +kernel\n\n" ++
      "theorem context_computed : (ShakeBlockCompute116.run 1024 (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ready).map (fun state => C99FiniteMap114.lookup state.heap.blocks " ++ site ++ ".ctx.block)=some (some contextBlock) := by decide +kernel\n\n" ++
      "theorem increment_computed : ShakeBlockCompute116.run 64 ShakeBlock.increment finished=some next := by rfl\n\n" ++
      "theorem source : ShakeBlock.Exec (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) (reference ready) (reference finished) :=\n" ++
      "  ShakeBlockNormalize126.certified 1024 _ ready " ++ site ++ ".pointer contextBlock localSnapshot\n" ++
      "    (by rfl) (by decide +kernel) locals_computed context_computed\n\n" ++
      "end FT1536.Source3." ++ moduleName ++ "\n"
    IO.FS.writeFile ("../generated/" ++ moduleName ++ ".lean") (header ++ definitions ++ scaffold ++ proofs)
    ready := next

def generate : IO Unit := do
  let initial ← FirstSegment128Generator.initial
  let first ← SamplerSegments128Generator.segment 1 initial
  let next ← SamplerSegments128Generator.segment 63 first.1
  let mut state := next.1
  for i in List.range 23 do
    let proposed ← SamplerSegments128Generator.segment 64 state
    if proposed.2.length=1 then
      match proposed.2 with
      | event::_ => generateEvent ("F" ++ two (i+2)) event.before
      | [] => throw (IO.userError "Missing event")
    else if !proposed.2.isEmpty then
      throw (IO.userError "Unexpected multiple process events in one fragment")
    state := proposed.1

end FT1536.Source3.SamplerProcess129Generator

#eval FT1536.Source3.SamplerProcess129Generator.generate
