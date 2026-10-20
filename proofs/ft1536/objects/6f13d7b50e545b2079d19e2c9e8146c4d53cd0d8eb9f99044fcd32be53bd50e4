import Source3.KeygenM0Preprocess
import Source3.C99ProcedureParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenAttemptCap
open C99ProcedureReference (Stmt)

def limit : Nat := 3000000
def expandMacros (tokens : List B20.C.Token) : List B20.C.Token := tokens.map (fun token =>
  match KeygenM0Preprocess.lookup token with
  | some value => (toString value).toList
  | none => token)
def increment : Stmt := .base (.scalar (.update "local_attempts".toList .add (.literal .i32 1)))
def condition : CLogic.Expr := .cmp .gt (.var "local_attempts".toList) (.literal .i32 3000000)
def skip : Stmt := .base .skip
def rejected : Stmt := .scope [] [] (.seq (.ret (some (.scalar (.literal .i32 0)))) skip)
def code : Stmt := .seq increment (.branch condition rejected skip)

def source : Option Stmt := do
  let lines ← KeygenM0Preprocess.preprocess ((Pinned.keygenLines.drop 7866).take 9)
  let chars := lines.flatMap String.toList
  let tokens ← LeafScan.tokenize (chars.length+1) chars
  let (inc,rest) ← C99ProcedureParser.clauses [';'] 16 (expandMacros tokens)
  let (branch,_,tail) ← C99ProcedureParser.statement (fun _ => none) [] 128 rest
  if tail.isEmpty then pure (.seq inc branch) else none

theorem source_bound : source=some code := by decide
theorem actual_limit : limit=3000000 := rfl
theorem nonzero_limit : limit≠0 := by decide
theorem source_default : Pinned.keygenLines[92]?=some "#define TERNARY_KEYGEN_MAX_ATTEMPTS   3000000\n" := by decide
theorem source_counter : Pinned.keygenLines[7812]?=some "\tuint64_t local_attempts;\n" := by decide
theorem source_initialization : Pinned.keygenLines[7817]?=some "\tlocal_attempts = 0;\n" := by decide

end FT1536.Source3.KeygenAttemptCap
