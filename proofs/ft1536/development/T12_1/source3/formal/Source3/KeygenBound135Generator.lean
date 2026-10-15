import Source3.FprBoundEvents135
import Source3.KeygenAttemptNorm

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted finite proposals. The small local map is ONLY for generation;
   accepted witnesses must check the complete actual selected caller state. -/
namespace FT1536.Source3.KeygenBound135Generator
open B20.C (Val)
open C99CompactCells115 (Locals Cell)
open FprBoundEvents135 (Event)

def expression (locals : Locals) : KeygenSearchExec.Expr → Option (Val × List Event)
  | .base (.scalar expr) => (C99ScalarCompute130.evaluate locals expr).map (·,[])
  | .unary name expr => do
      let (arg,events) ← expression locals expr
      let out ← KeygenBoundModel135.calls name [arg]
      pure (out,events++[⟨name,[arg],out⟩])
  | .binary name left right => do
      let (x,first) ← expression locals left
      let (y,second) ← expression locals right
      let out ← KeygenBoundModel135.calls name [x,y]
      pure (out,first++second++[⟨name,[x,y],out⟩])
  | .cast ty expr => do
      let (arg,events) ← expression locals expr
      pure (C99ValueBridge.encode (C99IntegerReference.convert ty (C99ValueBridge.value arg).integer),events)
  | _ => none

def execute : Nat → KeygenSearchExec.Stmt → Locals → Option (Locals × List Event)
  | 0, _, _ => none
  | _+1, .procedure (.base .skip), before => some (before,[])
  | _+1, .assign name expr, before => do
      let cell ← C99NameMap115.lookup before name
      let (out,events) ← expression before expr
      pure (C99NameMap115.put before name (Cell.converted cell.ty out),events)
  | fuel+1, .seq first second, before => do
      let (middle,head) ← execute fuel first before
      let (after,tail) ← execute fuel second middle
      pure (after,head++tail)
  | _, _, _ => none

def inputs : Locals := [(['n'],.u64 (some 1536)),("bound".toList,.u64 none)]

def generate : IO Unit := do
  let some (after,events) := execute 16 KeygenAttemptNorm.boundCode inputs |
    throw (IO.userError "bound candidate execution failed")
  let some (.u64 (some finalWord)) := C99NameMap115.lookup after "bound".toList |
    throw (IO.userError "bound candidate not initialized")
  let mut text := "import Source3.FprBoundEvents135\nimport Source3.KeygenAttemptNorm\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.GeneratedBound135\n\n"
  text := text ++ "def code : KeygenSearchExec.Stmt :=\n  " ++ (reprStr KeygenAttemptNorm.boundCode).replace "\n" "\n  " ++ "\n\n"
  text := text ++ "theorem source : KeygenAttemptNorm.boundCode=code := by decide +kernel\n\n"
  for event in events, i in [:events.length] do
    let name := s!"event{i}"
    text := text ++ "def " ++ name ++ " : FprBoundEvents135.Event :=\n  " ++ (reprStr event).replace "\n" "\n  " ++ "\n\n"
    text := text ++ "theorem checked" ++ toString i ++ " : KeygenBoundModel135.calls " ++ name ++ ".name " ++ name ++ ".args=some " ++ name ++ ".out := by decide +kernel\n\n"
    text := text ++ "theorem valid" ++ toString i ++ " : FprBoundEvents135.Valid " ++ name ++ " := FprBoundEvents135.checked " ++ name ++ " checked" ++ toString i ++ "\n\n"
  text := text ++ "def events : List FprBoundEvents135.Event := [" ++
    String.intercalate "," ((List.range events.length).map (fun i => "event"++toString i)) ++ "]\n\n"
  text := text ++ "def finalWord : BitVec 64 := " ++ toString finalWord.toNat ++ "\n\n"
  text := text ++ "end FT1536.Source3.GeneratedBound135\n"
  IO.FS.writeFile "../GeneratedBound135.lean" text
  let jsonEvents := events.map (fun event => Lean.Json.mkObj [
    ("name",Lean.toJson (String.ofList event.name)),
    ("args",Lean.toJson (event.args.map (fun v => (reprStr v.ty,toString v.integer)))),
    ("out",Lean.toJson (reprStr event.out.ty,toString event.out.integer))])
  IO.FS.writeFile "../BOUND135_CANDIDATES.json" (Lean.Json.pretty (Lean.Json.mkObj [
    ("status",Lean.toJson "UNTRUSTED_PROPOSALS_ONLY"),("n",Lean.toJson (1536:Nat)),
    ("scale",Lean.toJson ([1250,100]:List Nat)),("events",Lean.toJson jsonEvents),
    ("final_word",Lean.toJson (toString finalWord.toNat))]))

end FT1536.Source3.KeygenBound135Generator
#eval FT1536.Source3.KeygenBound135Generator.generate
