import Source3.C99ScalarCompute130
import Source3.C99CompactState115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ScalarSteps130
open C99CompactCells115 (Locals Cell environment)
open C99CompactState115 (State reference)

def assignLocals (before : Locals) (name : C99ArrayReference.Name) (expr : CLogic.Expr) : Option Locals := do
  let cell ← C99NameMap115.lookup before name
  let value ← C99ScalarCompute130.evaluate before expr
  pure (C99NameMap115.put before name (Cell.converted cell.ty value))

theorem assign_locals_sound (calls : C99ScalarReference.CallRelation) (before after : Locals)
    (name : C99ArrayReference.Name) (expr : CLogic.Expr) (computed : assignLocals before name expr=some after) :
    C99ScalarReference.Exec calls (environment before) (.assign name (C99Frontend.expression expr))
      (.normal (environment after)) := by
  obtain ⟨cell,found,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactCells115.environment_put,Cell.converted_reference]
  exact .assign (environment before) name (C99Frontend.expression expr) (C99ValueBridge.type cell.ty)
    (cell.value.map C99ValueBridge.value) (C99ValueBridge.value value)
    (by simp [environment,found,Cell.reference]) (C99ScalarCompute130.evaluate_sound calls before expr value evaluated)

def step (before : Locals) : CLogic.Stmt → Option Locals
  | .declare ty names => some (C99CompactScalar115.declareMany before ty names)
  | .assign name expr => assignLocals before name expr
  | .update name op expr => assignLocals before name (.bin op (.var name) expr)
  | .ret _ => none

theorem step_sound (calls : C99ScalarReference.CallRelation) (before after : Locals) (code : CLogic.Stmt)
    (computed : step before code=some after) :
    C99ScalarReference.Exec calls (environment before) (C99Frontend.scalar code) (.normal (environment after)) := by
  cases code with
  | declare ty names =>
      have same := Option.some.inj computed
      subst after
      exact C99CompactScalar115.declareMany_sound calls before ty names
  | assign name expr => exact assign_locals_sound calls before after name expr computed
  | update name op expr => exact assign_locals_sound calls before after name (.bin op (.var name) expr) computed
  | ret expr => cases computed

def scalar (before : State) (code : CLogic.Stmt) : Option State :=
  (step before.locals code).map (fun locals => {before with locals := locals})

theorem scalar_sound (before after : State) (code : CLogic.Stmt) (computed : scalar before code=some after) :
    C99ModularReference.Exec (.base (.scalar code)) (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨locals,stepped,result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_locals]
  exact .base _ _ _ (.scalar _ _ _ (step_sound FprPrefixCalls.calls before.locals locals code stepped))

def assign (before : State) (name : C99ArrayReference.Name) (expr : CLogic.Expr) : Option State := do
  let cell ← C99NameMap115.lookup before.locals name
  let value ← C99ScalarCompute130.evaluate before.locals expr
  pure (C99CompactState115.bindValue before name cell.ty value)

theorem assign_sound (before after : State) (name : C99ArrayReference.Name) (expr : CLogic.Expr)
    (computed : assign before name expr=some after) :
    C99ModularReference.Exec (.assign name (.scalar expr)) (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindValue]
  refine .assign name (.scalar expr) (reference before) (C99ValueBridge.type cell.ty)
    (cell.value.map C99ValueBridge.value) (C99ValueBridge.value value) ?_ ?_
  · change (C99NameMap115.lookup before.locals name).map Cell.reference = _
    rw [declared]
    rfl
  · exact .scalar _ _ (C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls before.locals expr value evaluated)

def run : Nat → C99ModularReference.Stmt → State → Option State
  | 0, _, _ => none
  | _+1, .base (.scalar code), before => scalar before code
  | _+1, .base .skip, before => some before
  | _+1, .assign name (.scalar expr), before => assign before name expr
  | fuel+1, .seq first second, before => do run fuel second (← run fuel first before)
  | _, _, _ => none

theorem run_sound (fuel : Nat) (code : C99ModularReference.Stmt) (before after : State)
    (computed : run fuel code before=some after) :
    C99ModularReference.Exec code (reference before) ⟨reference after,.normal⟩ := by
  induction fuel generalizing code before after with
  | zero => cases computed
  | succ fuel ih =>
      cases code with
      | base code =>
          cases code <;> try cases computed
          · exact .base _ _ _ (.skip _)
          · exact scalar_sound before after _ computed
      | assign name expr =>
          cases expr <;> try cases computed
          exact assign_sound before after name _ computed
      | seq first second =>
          obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
          exact .seqNormal first second (reference before) (reference middle) ⟨reference after,.normal⟩
            (ih first before middle head) (ih second middle after tail)
      | store32 | storeRev | scope | branch | loop | ret | retVoid => cases computed

end FT1536.Source3.C99ScalarSteps130
