import Source3.C99ModularArity096

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordArity096
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenWordExpr
open C99ModularArity096 (arity)

def checkedExpr : Expr → Bool
  | .scalar _ | .load32 _ _ | .load16 _ _ => true
  | .cast _ e | .neg e | .bitNot e | .lnot e => checkedExpr e
  | .bin _ a b | .cmp _ a b | .land a b | .lor a b => checkedExpr a && checkedExpr b
  | .call1 name a => arity name 1 && checkedExpr a
  | .call2 name a b => arity name 2 && checkedExpr a && checkedExpr b
  | .call3 name a b c => arity name 3 && checkedExpr a && checkedExpr b && checkedExpr c
  | .call4 name a b c d => arity name 4 && checkedExpr a && checkedExpr b && checkedExpr c && checkedExpr d
  | .call5 name a b c d e => arity name 5 && checkedExpr a && checkedExpr b && checkedExpr c && checkedExpr d && checkedExpr e

def checkedCode : KeygenWordExec.Stmt → Bool
  | .modular code => C99ModularArity096.checkedCode code
  | .assign _ e | .store _ _ e | .ret e => checkedExpr e
  | .seq a b => checkedCode a && checkedCode b
  | .branch e a b | .loop e a b => checkedExpr e && checkedCode a && checkedCode b
  | .scope _ body => checkedCode body

theorem call_unique (name : C99ArrayReference.Name) (args : List Value) (a b : Value)
    (checked : arity name args.length = true)
    (first : C99ModularReference.ModCall name args a) (second : C99ModularReference.ModCall name args b) : a = b :=
  KeygenProperModular096.calls name args a b
    (C99ModularArity096.call name args a checked first) (C99ModularArity096.call name args b checked second)

theorem call1_unique (name : C99ArrayReference.Name) (x a b : Value) (checked : arity name 1 = true)
    (first : C99ModularReference.ModCall name [x] a) (second : C99ModularReference.ModCall name [x] b) : a = b :=
  call_unique name [x] a b checked first second
theorem call2_unique (name : C99ArrayReference.Name) (x y a b : Value) (checked : arity name 2 = true)
    (first : C99ModularReference.ModCall name [x, y] a) (second : C99ModularReference.ModCall name [x, y] b) : a = b :=
  call_unique name [x, y] a b checked first second
theorem call3_unique (name : C99ArrayReference.Name) (x y z a b : Value) (checked : arity name 3 = true)
    (first : C99ModularReference.ModCall name [x, y, z] a) (second : C99ModularReference.ModCall name [x, y, z] b) : a = b :=
  call_unique name [x, y, z] a b checked first second
theorem call4_unique (name : C99ArrayReference.Name) (x y z t a b : Value) (checked : arity name 4 = true)
    (first : C99ModularReference.ModCall name [x, y, z, t] a) (second : C99ModularReference.ModCall name [x, y, z, t] b) : a = b :=
  call_unique name [x, y, z, t] a b checked first second
theorem call5_unique (name : C99ArrayReference.Name) (x y z t u a b : Value) (checked : arity name 5 = true)
    (first : C99ModularReference.ModCall name [x, y, z, t, u] a) (second : C99ModularReference.ModCall name [x, y, z, t, u] b) : a = b :=
  call_unique name [x, y, z, t, u] a b checked first second

theorem expression (s : State) (e : Expr) (a b : Value) (checked : checkedExpr e = true)
    (first : Eval s e a) (second : Eval s e b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedExpr, Bool.and_eq_true] at *
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar,
    C99ScalarCallsDeterminism089.array_pointer, Gate00Memory.load32_deterministic,
    C99NarrowReads.load16_deterministic, C99IntegerReference.neg_deterministic,
    C99ScalarDeterminism089.complement_unique, C99ScalarDeterminism089.compare_unique,
    KeygenWordDeterminism093.binary, call1_unique, call2_unique, call3_unique, call4_unique, call5_unique]

theorem execution (code : KeygenWordExec.Stmt) (before : State) (a b : Result)
    (checked : checkedCode code = true) (first : KeygenWordExec.Exec code before a)
    (second : KeygenWordExec.Exec code before b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [expression, C99ModularArity096.execution_unique,
    C99ScalarCallsDeterminism089.array_pointer, C99HeapDeterminism089.store32]

end FT1536.Source3.KeygenWordArity096
