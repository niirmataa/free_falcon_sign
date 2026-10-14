import Source3.KeygenModularLeaf096
import Source3.C99ExpressionEnvironment

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ScalarAgreement096
open C99ScalarReference
open C99IntegerReference (Value)
open C99ExpressionEnvironment (Agree readNames)

def checkedExpr (names : List Name) (e : Expr) : Bool := (readNames e).all names.contains

def checkedCode (names : List Name) : Stmt → Bool
  | .skip | .declare _ _ => true
  | .assign name e => names.contains name && checkedExpr names e
  | .seq a b => checkedCode names a && checkedCode names b
  | .block _ body => checkedCode names body
  | .while e body => checkedExpr names e && checkedCode names body
  | .ret e => checkedExpr names e

def Same (names : List Name) : Result → Result → Prop
  | .normal a, .normal b => Agree a b names
  | .returned a, .returned b => a = b
  | _, _ => False

theorem lookup (names : List Name) (a b : Env) (name : Name) (member : names.contains name = true)
    (same : Agree a b names) : a name = b name := same name (List.contains_iff_mem.mp member)

theorem expression (calls : CallRelation) (deterministic : C99ScalarDeterminism089.Deterministic calls)
    (names : List Name) (a b : Env) (e : Expr) (x y : Value)
    (checked : checkedExpr names e = true) (same : Agree a b names)
    (first : Eval calls a e x) (second : Eval calls b e y) : x = y := by
  have reads : Agree a b (readNames e) := by
    intro name member
    exact same name (List.contains_iff_mem.mp ((List.all_eq_true.mp checked) name member))
  exact C99ScalarDeterminism089.expression_unique calls deterministic b e x y
    (C99ExpressionEnvironment.transport calls a b e x first reads) second

theorem set_agree (names : List Name) (a b : Env) (name : Name) (cell : C99IntegerReference.Ty × Option Value)
    (same : Agree a b names) : Agree (set a name cell) (set b name cell) names := by
  intro key member
  by_cases equal : key = name
  · simp only [C99ScalarReference.set, equal, ite_true]
  · simp only [C99ScalarReference.set, equal, ite_false]
    exact same key member

theorem restore_agree (names locals : List Name) (a b x y : Env)
    (outer : Agree a b names) (inner : Agree x y names) : Agree (restore a x locals) (restore b y locals) names := by
  intro key member
  unfold restore
  by_cases inScope : locals.contains key = true
  · simp only [inScope, ite_true]
    exact outer key member
  · simp only [inScope]
    exact inner key member

/-- Read-set noninterference for finite scalar executions. The caller must
    prove the checked source syntax, and instantiate the fixed call table. -/
theorem execution (calls : CallRelation) (deterministic : C99ScalarDeterminism089.Deterministic calls)
    (names : List Name) (before1 before2 : Env) (code : Stmt) (a b : Result)
    (checked : checkedCode names code = true) (same : Agree before1 before2 names)
    (first : Exec calls before1 code a) (second : Exec calls before2 code b) : Same names a b := by
  revert checked same
  induction first generalizing before2 b <;> intro checked same <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true, Same] at *
  all_goals grind only [expression, set_agree, restore_agree, → lookup]

end FT1536.Source3.C99ScalarAgreement096
