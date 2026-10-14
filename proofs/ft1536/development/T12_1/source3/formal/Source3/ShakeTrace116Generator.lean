import Source3.ShakeBlockChunks116
import Lean

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- An untrusted certificate generator. The generated files contain explicit
   snapshots; EVERY transition is rechecked by decide +kernel. VM execution
   or successful generation is not a premise of any source theorem. -/
namespace FT1536.Source3.ShakeTrace116Generator
open C99CompactState115 (State reference)
open C99CompactCells115 (Cell)

def cellText : Cell → String
  | .u64 none => ".u64 none"
  | .i64 none => ".i64 none"
  | .u32 none => ".u32 none"
  | .i32 none => ".i32 none"
  | .u64 (some w) => s!".u64 (some {w.toNat})"
  | .i64 (some w) => s!".i64 (some {w.toNat})"
  | .u32 (some w) => s!".u32 (some {w.toNat})"
  | .i32 (some w) => s!".i32 (some {w.toNat})"

def stateText (state : State) : IO String := do
  let mut words : List String := []
  for i in List.range 25 do
    match C99FiniteRead114.read64 state.heap {ShakeBlockFixture116.pointer with index := i} with
    | none => throw (IO.userError s!"Missing A[{i}] in generated state")
    | some word => words := words ++ [toString word.toNat]
  let locals := state.locals.map fun (name,cell) =>
    "(" ++ reprStr (String.ofList name) ++ ".toList," ++ cellText cell ++ ")"
  return "ShakeBlockFixture116.state [" ++ String.intercalate "," words ++ "]\n  [" ++
    String.intercalate "," locals ++ "]"

def run (code : ShakeBlock.Stmt) (state : State) : IO State :=
  match ShakeBlockCompute116.run 1024 code state with
  | none => throw (IO.userError "Untrusted generator failed to evaluate the source code")
  | some after => pure after

def parts : List (List ShakeBlock.Stmt) := [ShakeBlockProgram.part00,
  ShakeBlockProgram.part01,
  ShakeBlockProgram.part02,
  ShakeBlockProgram.part03,
  ShakeBlockProgram.part04,
  ShakeBlockProgram.part05,
  ShakeBlockProgram.part06,
  ShakeBlockProgram.part07,
  ShakeBlockProgram.part08,
  ShakeBlockProgram.part09,
  ShakeBlockProgram.part10,
  ShakeBlockProgram.part11,
  ShakeBlockProgram.part12,
  ShakeBlockProgram.part13,
  ShakeBlockProgram.part14,
  ShakeBlockProgram.part15,
  ShakeBlockProgram.part16,
  ShakeBlockProgram.part17,
  ShakeBlockProgram.part18,
  ShakeBlockProgram.part19,
  ShakeBlockProgram.part20,
  ShakeBlockProgram.part21,
  ShakeBlockProgram.part22,
  ShakeBlockProgram.part23,
  ShakeBlockProgram.part24,
  ShakeBlockProgram.part25,
  ShakeBlockProgram.part26,
  ShakeBlockProgram.part27,
  ShakeBlockProgram.part28,
  ShakeBlockProgram.part29,
  ShakeBlockProgram.part30,
  ShakeBlockProgram.part31,
  ShakeBlockProgram.part32,
  ShakeBlockProgram.part33,
  ShakeBlockProgram.part34,
  ShakeBlockProgram.part35,
  ShakeBlockProgram.part36,
  ShakeBlockProgram.part37,
  ShakeBlockProgram.part38,
  ShakeBlockProgram.part39,
  ShakeBlockProgram.part40,
  ShakeBlockProgram.part41,
  ShakeBlockProgram.part42,
  ShakeBlockProgram.part43,
  ShakeBlockProgram.part44,
  ShakeBlockProgram.part45,
  ShakeBlockProgram.part46,
  ShakeBlockProgram.part47,
  ShakeBlockProgram.part48]

def two (n : Nat) : String := if n<10 then "0"++toString n else toString n

def header (name : String) : String :=
  "import Source3.ShakeBlockChunks116\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
  "/- Generated UNTRUSTED snapshots from the public local SHAKE fixture.\n   Each source transition below is independently checked by the kernel. -/\n" ++
  "namespace FT1536.Source3." ++ name ++ "\nopen C99CompactState115 (State reference)\n\n"

def generate : IO Unit := do
  IO.FS.createDirAll "../generated"
  let entry := ShakeProcessCompute116.entry ShakeBlockFixture116.before ShakeBlockFixture116.pointer ShakeBlockFixture116.table
  let declared ← run (ShakeBlock.chain ShakeBlock.prologue) entry
  let mut current ← run ShakeBlock.initial declared
  let prologue := header "ShakeTrace116Start" ++
    "def declared : State := " ++ (←stateText declared) ++ "\n\ndef ready : State := " ++ (←stateText current) ++ "\n\n" ++
    "theorem declarations : ShakeBlock.Exec (ShakeBlock.chain ShakeBlock.prologue)\n" ++
    "    (reference (ShakeProcessCompute116.entry ShakeBlockFixture116.before ShakeBlockFixture116.pointer ShakeBlockFixture116.table)) (reference declared) :=\n" ++
    "  ShakeBlockCompute116.run_sound 1024 _ _ _ (by decide +kernel)\n\n" ++
    "theorem initial : ShakeBlock.Exec ShakeBlock.initial (reference declared) (reference ready) :=\n" ++
    "  ShakeBlockCompute116.run_sound 1024 _ _ _ (by decide +kernel)\n\nend FT1536.Source3.ShakeTrace116Start\n"
  IO.FS.writeFile "../generated/ShakeTrace116Start.lean" prologue
  for round in List.range 12 do
    let moduleName := "ShakeTrace116Round" ++ two round
    let mut text := header moduleName ++ "def state00 : State := " ++ (←stateText current) ++ "\n\n"
    for i in List.range parts.length do
      let code := ShakeBlock.chain parts[i]!
      current ← run code current
      text := text ++ "def state" ++ two (i+1) ++ " : State := " ++ (←stateText current) ++ "\n\n"
      text := text ++ "theorem part" ++ two i ++ " : ShakeBlock.Exec (ShakeBlock.chain ShakeBlockProgram.part" ++ two i ++ ")\n" ++
        "    (reference state" ++ two i ++ ") (reference state" ++ two (i+1) ++ ") :=\n" ++
        "  ShakeBlockCompute116.run_sound 1024 _ _ _ (by decide +kernel)\n\n"
    current ← run ShakeBlock.increment current
    text := text ++ "def state50 : State := " ++ (←stateText current) ++ "\n\n"
    text := text ++ "theorem increment : ShakeBlock.Exec ShakeBlock.increment (reference state49) (reference state50) :=\n" ++
      "  ShakeBlockCompute116.run_sound 1024 _ _ _ (by decide +kernel)\n\n"
    text := text ++ "theorem guard : ShakeBlock.Eval (reference state00) ShakeBlock.condition (.int32 1) :=\n" ++
      "  ShakeBlockComputeRead116.evaluate_sound state00 ShakeBlock.condition (.i32 1) (by decide +kernel)\n\n"
    text := text ++ "theorem body : ShakeBlock.Exec (ShakeBlock.chain ShakeBlockProgram.steps) (reference state00) (reference state49) := by\n" ++
      "  unfold ShakeBlockProgram.steps\n"
    for i in List.range 49 do
      text := text ++ "  apply ShakeBlockChunks116.append _ _ _ _ _ part" ++ two i ++ "\n"
    text := text ++ "  exact .skip _\n\nend FT1536.Source3." ++ moduleName ++ "\n"
    IO.FS.writeFile ("../generated/" ++ moduleName ++ ".lean") text
  let words ← stateText current
  IO.FS.writeFile "../generated/FINAL_STATE.txt" words
  if current.heap != ShakeBlockFixture116.after.heap then
    throw (IO.userError "Generated final heap does not match the native local fixture; no proof emitted as accepted")

end FT1536.Source3.ShakeTrace116Generator

#eval FT1536.Source3.ShakeTrace116Generator.generate
