import Source3.C99Metadata091

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The MODE1 sampler's modular-language statements use scalar expressions,
   not the general modular-call interface. This checked syntactic domain
   avoids asserting determinism for unrelated ill-arity call relations. -/
namespace FT1536.Source3.C99SimpleModular091
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99ModularReference

def scalarExpr : Expr → Bool
  | .scalar _ => true
  | _ => false

def checkedCode : Stmt → Bool
  | .base _ => true
  | .assign _ e | .store32 _ _ e | .storeRev _ _ _ _ e | .ret e => scalarExpr e
  | .seq a b | .branch _ a b | .loop _ a b => checkedCode a && checkedCode b
  | .scope _ body => checkedCode body
  | .retVoid => true

theorem value (calls : CallRelation) (s : State) (e : Expr) (a b : Value)
    (checked : scalarExpr e = true) (first : GenEval calls s e a) (second : GenEval calls s e b) : a = b := by
  cases e <;> simp only [scalarExpr, Bool.false_eq_true] at checked
  all_goals (cases first; cases second)
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar]

theorem execution (calls : CallRelation) (code : Stmt) (before : State) (a b : Result)
    (checked : checkedCode code = true)
    (first : GenExec calls code before a) (second : GenExec calls code before b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [value, C99ArrayDeterminism089.execution,
    C99ScalarCallsDeterminism089.array_scalar, C99ScalarCallsDeterminism089.array_pointer,
    C99NarrowReads.load16_deterministic, C99HeapDeterminism089.store32]

end FT1536.Source3.C99SimpleModular091
