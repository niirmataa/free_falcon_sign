import Source3.C99ScalarAgreement096

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ModularAgreement096
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99ModularReference
open C99ExpressionEnvironment (Agree)

def checkedExpr (names : List Name) : Expr → Bool
  | .scalar e => C99ScalarAgreement096.checkedExpr names (C99Frontend.expression e)
  | .load32 _ _ | .load16 _ _ => false
  | .call1 _ a => checkedExpr names a
  | .call2 _ a b => checkedExpr names a && checkedExpr names b
  | .call3 _ a b c => checkedExpr names a && checkedExpr names b && checkedExpr names c
  | .call4 _ a b c d => checkedExpr names a && checkedExpr names b && checkedExpr names c && checkedExpr names d
  | .call5 _ a b c d e => checkedExpr names a && checkedExpr names b && checkedExpr names c && checkedExpr names d && checkedExpr names e

def checkedBase (names : List Name) : C99ArrayReference.Stmt → Bool
  | .skip => true
  | .scalar code => C99ScalarAgreement096.checkedCode names (C99Frontend.scalar code)
  | _ => false

def checkedCode (names : List Name) : Stmt → Bool
  | .base code => checkedBase names code
  | .assign name e => names.contains name && checkedExpr names e
  | .ret e => checkedExpr names e
  | .retVoid => true
  | .seq a b => checkedCode names a && checkedCode names b
  | .scope _ body => checkedCode names body
  | .branch e a b | .loop e a b =>
      C99ScalarAgreement096.checkedExpr names (C99Frontend.expression e) && checkedCode names a && checkedCode names b
  | .store32 _ _ _ | .storeRev _ _ _ _ _ => false

def Same (names : List Name) (a b : Result) : Prop := a.flow = b.flow ∧ Agree a.state.locals b.state.locals names

theorem expression (calls : CallRelation) (deterministic : C99ScalarDeterminism089.Deterministic calls)
    (names : List Name) (s t : State) (e : Expr) (a b : Value)
    (checked : checkedExpr names e = true) (same : Agree s.locals t.locals names)
    (first : GenEval calls s e a) (second : GenEval calls t e b) : a = b := by
  unfold C99ScalarDeterminism089.Deterministic at deterministic
  have scalarUnique := C99ScalarAgreement096.expression FprPrefixCalls.calls C99ScalarCallsDeterminism089.prefix_calls
  revert checked same
  induction first generalizing t b <;> intro checked same <;> cases second
  all_goals simp only [checkedExpr, Bool.and_eq_true, Bool.false_eq_true] at *
  all_goals grind only [C99ArrayReference.scalar]

theorem base (names : List Name) (code : C99ArrayReference.Stmt) (s t a b : State)
    (checked : checkedBase names code = true) (same : Agree s.locals t.locals names)
    (first : C99ArrayReference.Exec FftLeafPrograms.program code s a)
    (second : C99ArrayReference.Exec FftLeafPrograms.program code t b) : Agree a.locals b.locals names := by
  cases code <;> simp only [checkedBase, Bool.false_eq_true] at checked
  case skip => cases first; cases second; exact same
  case scalar code =>
    cases first
    cases second
    exact C99ScalarAgreement096.execution FprPrefixCalls.calls C99ScalarCallsDeterminism089.prefix_calls
      names s.locals t.locals (C99Frontend.scalar code) _ _ checked same (by assumption) (by assumption)

theorem execution (calls : CallRelation) (deterministic : C99ScalarDeterminism089.Deterministic calls)
    (names : List Name) (code : Stmt) (s t : State) (a b : Result)
    (checked : checkedCode names code = true) (same : Agree s.locals t.locals names)
    (first : GenExec calls code s a) (second : GenExec calls code t b) : Same names a b := by
  have scalarUnique := C99ScalarAgreement096.expression FprPrefixCalls.calls C99ScalarCallsDeterminism089.prefix_calls
  revert checked same
  induction first generalizing t b <;> intro checked same <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true, Bool.false_eq_true, Same,
    C99ArrayReference.bindValue, C99ArrayReference.restoreScope] at *
  all_goals grind only [base, expression, C99ArrayReference.scalar,
    C99ScalarAgreement096.set_agree, C99ScalarAgreement096.restore_agree, → C99ScalarAgreement096.lookup]

end FT1536.Source3.C99ModularAgreement096
