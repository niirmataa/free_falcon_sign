import Source3.C99CompactCells115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99CompactScalar115
open B20.C (Ty Val)
open C99ArrayReference (Name)
open C99CompactCells115

/-- This generic bridge requires actual source-call soundness. Concrete
    KeyGen execution must instantiate it from the pinned callee bodies. -/
def evaluate (calls : B20.C.Scalar.Calls) (locals : Locals) (expr : CLogic.Expr) : Option Val :=
  ExpressionFuel.unbounded calls (model locals).values expr

theorem evaluate_sound (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionSound.CallsSound rc mc) (locals : Locals)
    (expr : CLogic.Expr) (value : Val) (computed : evaluate mc locals expr=some value) :
    C99ScalarReference.Eval rc (environment locals) (C99Frontend.expression expr) (C99ValueBridge.value value) := by
  rw [environment_model]
  exact C99ExpressionSound.expression_sound rc mc calls (model locals) (model_typed locals) expr value computed

def assign (calls : B20.C.Scalar.Calls) (locals : Locals) (name : Name) (expr : CLogic.Expr) : Option Locals := do
  let cell ← C99NameMap115.lookup locals name
  let value ← evaluate calls locals expr
  pure (C99NameMap115.put locals name (Cell.converted cell.ty value))

theorem assign_sound (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionSound.CallsSound rc mc) (before after : Locals)
    (name : Name) (expr : CLogic.Expr) (computed : assign mc before name expr=some after) :
    C99ScalarReference.Exec rc (environment before) (.assign name (C99Frontend.expression expr))
      (.normal (environment after)) := by
  obtain ⟨cell, found, rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value, evaluated, result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [environment_put, Cell.converted_reference]
  exact .assign (environment before) name (C99Frontend.expression expr) (C99ValueBridge.type cell.ty)
    (cell.value.map C99ValueBridge.value) (C99ValueBridge.value value)
    (by simp [environment, found, Cell.reference])
    (evaluate_sound rc mc calls before expr value evaluated)

def declareOne (locals : Locals) (ty : Ty) (name : Name) : Locals :=
  C99NameMap115.put locals name (Cell.uninitialized ty)

theorem declareOne_sound (calls : C99ScalarReference.CallRelation) (locals : Locals) (ty : Ty) (name : Name) :
    C99ScalarReference.Exec calls (environment locals) (.declare (C99ValueBridge.type ty) name)
      (.normal (environment (declareOne locals ty name))) := by
  rw [declareOne, environment_put, Cell.uninitialized_reference]
  exact .declare _ _ _

def declareMany (locals : Locals) (ty : Ty) : List Name → Locals
  | [] => locals
  | name::rest => declareMany (declareOne locals ty name) ty rest

theorem declareMany_sound (calls : C99ScalarReference.CallRelation) (locals : Locals) (ty : Ty) (names : List Name) :
    C99ScalarReference.Exec calls (environment locals) (C99Frontend.declarations (C99ValueBridge.type ty) names)
      (.normal (environment (declareMany locals ty names))) := by
  induction names generalizing locals with
  | nil => exact .skip _
  | cons name rest ih => exact .seqNormal _ _ _ _ _ (declareOne_sound calls locals ty name) (ih _)

def step (calls : B20.C.Scalar.Calls) (locals : Locals) : CLogic.Stmt → Option Locals
  | .declare ty names => some (declareMany locals ty names)
  | .assign name expr => assign calls locals name expr
  | .update name op expr => assign calls locals name (.bin op (.var name) expr)
  | .ret _ => none

theorem step_sound (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionSound.CallsSound rc mc) (before after : Locals) (code : CLogic.Stmt)
    (computed : step mc before code=some after) :
    C99ScalarReference.Exec rc (environment before) (C99Frontend.scalar code) (.normal (environment after)) := by
  cases code with
  | declare ty names =>
      have same := Option.some.inj computed
      subst after
      exact declareMany_sound rc before ty names
  | assign name expr => exact assign_sound rc mc calls before after name expr computed
  | update name op expr => exact assign_sound rc mc calls before after name (.bin op (.var name) expr) computed
  | ret expr => cases computed

def run (calls : B20.C.Scalar.Calls) (locals : Locals) : List CLogic.Stmt → Option Locals
  | [] => some locals
  | code::rest => do run calls (← step calls locals code) rest

theorem run_sound (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionSound.CallsSound rc mc) (before after : Locals) (code : List CLogic.Stmt)
    (computed : run mc before code=some after) :
    C99ScalarReference.Exec rc (environment before) (C99Frontend.scalars code) (.normal (environment after)) := by
  induction code generalizing before with
  | nil =>
      have same := Option.some.inj computed
      subst after
      exact .skip _
  | cons first rest ih =>
      obtain ⟨middle, head, tail⟩ := Option.bind_eq_some_iff.mp computed
      exact .seqNormal _ _ _ _ _ (step_sound rc mc calls before middle first head) (ih middle tail)

end FT1536.Source3.C99CompactScalar115
