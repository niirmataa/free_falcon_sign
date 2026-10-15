import Source3.Process122Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted candidate generation. Changed context bytes and locals are
   normalized; unchanged objects retain the SAME shared input expression.
   Each emitted computation still requires kernel conversion checking. -/
namespace FT1536.Source3.FirstProcess128Generator
open C99CompactState115 (State)
open Process122Generator (tableText cellText pointerText blockText two)

def stateText (state : State) (changed : Bool) : IO String := do
  let context ← match C99FiniteMap114.lookup state.heap.blocks 1 with
    | some data => pure data
    | none => throw (IO.userError "Missing source context block")
  let heapText := if changed then
    "C99FiniteMemory114.putBlock FirstProcessSite128.caller.heap FirstProcessSite128.ctx.block (" ++ blockText context ++ ")"
    else "FirstProcessSite128.caller.heap"
  pure ("{heap := " ++ heapText ++ ", locals := " ++ tableText cellText state.locals ++
    ", arrays := [(\"A\".toList,FirstProcessSite128.pointer),(\"RC\".toList,FirstProcessSite128.table)]" ++
    ", globals := FirstProcessSite128.caller.globals, tables := FirstProcessSite128.caller.tables}")

def run (fuel : Nat) (code : ShakeBlock.Stmt) (state : State) : IO State :=
  match ShakeBlockCompute116.run fuel code state with
  | none => throw (IO.userError "Source fragment proposal exhausted fuel or rejected an access")
  | some after => pure after

/-- Proposal only: the sealed119 RNG image plus candidate outside-RNG
    context bytes. No theorem assumes this is the actual complete input.
    Every emitted statement names FirstProcessSite128.blockEntry and the
    full original heap; kernel conversion must verify the candidate there. -/
def proposalBefore : State :=
  let h0 := GeneratedSeed119Fixture.flipped.heap
  let h1 := C99FiniteWrite114.write32 h0 ⟨1,0,1,4,0⟩ 10
  let h2 := C99FiniteWrite114.write32 h1 ⟨1,4,1,4,0⟩ 1
  let h3 := C99FiniteWrite114.write32 h2 ⟨1,424,1,4,0⟩ 1
  let h4 := C99FiniteWrite114.write32 h3 ⟨1,428,1,4,0⟩ 1
  let h5 := C99FiniteWrite114.write64 h4 ⟨1,432,1,8,0⟩ 55834574848
  let h6 := C99FiniteWrite114.write64 h5 ⟨1,440,1,8,0⟩ 286720
  {GeneratedSeed119Fixture.flipped with heap := h6}

def generate : IO Unit := do
  let entered := ShakeProcessCompute116.entry proposalBefore ⟨1,224,25,8,0⟩ GeneratedSeed119Fixture.rcPointer
  let declared ← run 64 (ShakeBlock.chain ShakeBlock.prologue) entered
  let mut ready ← run 64 ShakeBlock.initial declared
  IO.FS.createDirAll "../generated"
  -- The exact-event pilot passed; generate all12 double rounds for checking.
  for round in List.range 12 do
    let finished ← run 1024 (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ready
    let next ← run 64 ShakeBlock.increment finished
    let moduleName := "GeneratedEventProcess128Round" ++ two round
    let previous := "GeneratedEventProcess128Round" ++ two (round-1)
    let header := "import Source3.FirstProcessSite128\nimport Source3.ShakeBlockNormalize126\n" ++
      (if round=0 then "" else "import Source3." ++ previous ++ "\n") ++ "\n" ++
      "set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
      "namespace FT1536.Source3." ++ moduleName ++ "\nopen C99CompactState115 (State reference)\n\n"
    let declaredText ← stateText declared false
    let readyText ← stateText ready false
    let context ← match C99FiniteMap114.lookup finished.heap.blocks 1 with
      | some block => pure block
      | none => throw (IO.userError "Missing output context candidate")
    let declarations := if round=0 then "def declared : State := " ++ declaredText ++ "\n\n" else ""
    let definitions := declarations ++
      "def ready : State := " ++ (if round=0 then readyText else previous ++ ".next") ++ "\n\n" ++
      "def contextBlock : C99FiniteMemory114.Block := " ++ blockText context ++ "\n\n" ++
      "def localSnapshot : C99CompactCells115.Locals := " ++ tableText cellText finished.locals ++ "\n\n" ++
      "def finished : State := ShakeBlockNormalize126.normalize ready FirstProcessSite128.pointer contextBlock localSnapshot\n\n" ++
      "def next : State := {finished with locals := " ++ tableText cellText next.locals ++ "}\n\n"
    let scaffold := if round=0 then
      "theorem prologue_computed : ShakeBlockCompute116.run 64 (ShakeBlock.chain ShakeBlock.prologue)\n" ++
      "    FirstProcessSite128.blockEntry=some declared := by rfl\n\n" ++
      "theorem initial_computed : ShakeBlockCompute116.run 64 ShakeBlock.initial declared=some ready := by rfl\n\n"
      else ""
    let proofs :=
      "theorem guard_computed : ShakeBlockComputeRead116.evaluate ready ShakeBlock.condition=some (.i32 1) := by rfl\n\n" ++
      "theorem locals_computed : (ShakeBlockCompute116.run 1024 (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ready).map State.locals=some localSnapshot := by decide +kernel\n\n" ++
      "theorem context_computed : (ShakeBlockCompute116.run 1024 (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ready).map (fun state => C99FiniteMap114.lookup state.heap.blocks FirstProcessSite128.ctx.block)=some (some contextBlock) := by decide +kernel\n\n" ++
      "theorem increment_computed : ShakeBlockCompute116.run 64 ShakeBlock.increment finished=some next := by rfl\n\n" ++
      "theorem source : ShakeBlock.Exec (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) (reference ready) (reference finished) :=\n" ++
      "  ShakeBlockNormalize126.certified 1024 _ ready FirstProcessSite128.pointer contextBlock localSnapshot\n" ++
      "    (by rfl) (by decide +kernel) locals_computed context_computed\n\n" ++
      "end FT1536.Source3." ++ moduleName ++ "\n"
    IO.FS.writeFile ("../generated/" ++ moduleName ++ ".lean") (header ++ definitions ++ scaffold ++ proofs)
    ready := next

end FT1536.Source3.FirstProcess128Generator

#eval FT1536.Source3.FirstProcess128Generator.generate
