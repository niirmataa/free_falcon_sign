import Source3.GeneratedSeed119Fixture
import Source3.ShakeBlockCompute116
import Lean

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted certificate generation only. Literal states are independently
   checked by the kernel; generator execution is not a theorem premise. -/
namespace FT1536.Source3.Process122Generator
open C99CompactState115 (State)
open C99FiniteMemory114 (Block)
open C99CompactCells115 (Cell)
open C99MemoryReference (ArrayPointer Byte)

def optionText (render : α → String) : Option α → String
  | none => "none"
  | some value => "(some " ++ render value ++ ")"

def treeText (render : α → String) : C99FiniteMap114.Tree α → String
  | .empty => ".empty"
  | .node value zero one =>
      "(.node " ++ optionText render value ++ " " ++ treeText render zero ++ " " ++ treeText render one ++ ")"

def byteText (value : Byte) : String := toString value.toNat
def blockText (block : Block) : String :=
  "⟨" ++ toString block.size ++ "," ++ toString block.writable ++ "," ++ optionText byteText block.initial ++ "," ++
    treeText (optionText byteText) block.cells ++ "⟩"

def cellText : Cell → String
  | .u64 value => ".u64 " ++ optionText (fun w => toString w.toNat) value
  | .i64 value => ".i64 " ++ optionText (fun w => toString w.toNat) value
  | .u32 value => ".u32 " ++ optionText (fun w => toString w.toNat) value
  | .i32 value => ".i32 " ++ optionText (fun w => toString w.toNat) value

def pointerText (pointer : ArrayPointer) : String :=
  s!"⟨{pointer.block},{pointer.base},{pointer.count},{pointer.elementBytes},{pointer.index}⟩"

def tableText (render : α → String) (table : C99NameMap115.Table α) : String :=
  "[" ++ String.intercalate "," (table.map (fun (name,value) =>
    "(" ++ reprStr (String.ofList name) ++ ".toList," ++ render value ++ ")")) ++ "]"

def stateText (state : State) : String :=
  "⟨⟨" ++ treeText blockText state.heap.blocks ++ "⟩," ++ tableText cellText state.locals ++ "," ++
    tableText pointerText state.arrays ++ "," ++ tableText cellText state.globals ++ "," ++
    tableText pointerText state.tables ++ "⟩"

def run (fuel : Nat) (code : ShakeBlock.Stmt) (state : State) : IO State :=
  match ShakeBlockCompute116.run fuel code state with
  | none => throw (IO.userError "Untrusted generator could not compute the source fragment")
  | some after => pure after

def two (n : Nat) : String := if n<10 then "0"++toString n else toString n

def generate : IO Unit := do
  let caller := GeneratedSeed119Fixture.flipped
  let pointer := ShakeExtractSource.field GeneratedSeed119Fixture.ctx .a
  let entry := ShakeProcessCompute116.entry caller pointer GeneratedSeed119Fixture.rcPointer
  let declared ← run 64 (ShakeBlock.chain ShakeBlock.prologue) entry
  let mut ready ← run 64 ShakeBlock.initial declared
  IO.FS.createDirAll "../generated"
  for round in List.range 12 do
    let finished ← run 1024 (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ready
    let next ← run 64 ShakeBlock.increment finished
    let moduleName := "GeneratedProcess122Round" ++ two round
    let header := "import Source3.GeneratedSeed119Fixture\nimport Source3.ShakeBlockCompute116\n\n" ++
      "set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
      "namespace FT1536.Source3." ++ moduleName ++ "\nopen C99CompactState115 (State reference)\n\n"
    let definitions := (if round=0 then "def declared : State := " ++ stateText declared ++ "\n\n" else "") ++
      "def ready : State := " ++ stateText ready ++ "\n\n" ++
      "def finished : State := " ++ stateText finished ++ "\n\n" ++
      "def next : State := " ++ stateText next ++ "\n\n"
    let prologue := if round=0 then
      "theorem prologue_computed : ShakeBlockCompute116.run 64 (ShakeBlock.chain ShakeBlock.prologue)\n" ++
      "    (ShakeProcessCompute116.entry GeneratedSeed119Fixture.flipped (ShakeExtractSource.field GeneratedSeed119Fixture.ctx .a) GeneratedSeed119Fixture.rcPointer)=some declared := by decide +kernel\n\n" ++
      "theorem initial_computed : ShakeBlockCompute116.run 64 ShakeBlock.initial declared=some ready := by decide +kernel\n\n"
      else ""
    let proofs :=
      "theorem guard_computed : ShakeBlockComputeRead116.evaluate ready ShakeBlock.condition=some (.i32 1) := by decide +kernel\n\n" ++
      "theorem computed : ShakeBlockCompute116.run 1024 (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ready=some finished := by decide +kernel\n\n" ++
      "theorem increment_computed : ShakeBlockCompute116.run 64 ShakeBlock.increment finished=some next := by decide +kernel\n\n" ++
      "theorem source : ShakeBlock.Exec (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) (reference ready) (reference finished) :=\n" ++
      "  ShakeBlockCompute116.run_sound 1024 _ ready finished computed\n\n" ++
      "end FT1536.Source3." ++ moduleName ++ "\n"
    IO.FS.writeFile ("../generated/" ++ moduleName ++ ".lean") (header ++ definitions ++ prologue ++ proofs)
    ready := next

end FT1536.Source3.Process122Generator

#eval FT1536.Source3.Process122Generator.generate
