import Source3.KeygenRngCompute121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenScalarCompute121
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def assign (before : State) (name : C99ArrayReference.Name) (expression : CLogic.Expr) : Option State := do
  let cell ← C99NameMap115.lookup before.locals name
  let value ← C99CompactScalar115.evaluate noCalls before.locals expression
  pure (C99CompactState115.bindValue before name cell.ty value)

theorem assign_sound (before after : State) (name : C99ArrayReference.Name) (expression : CLogic.Expr)
    (computed : assign before name expression=some after) :
    C99ModularReference.Exec (.assign name (.scalar expression)) (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindValue]
  refine .assign name (.scalar expression) (reference before) (C99ValueBridge.type cell.ty)
    (cell.value.map C99ValueBridge.value) (C99ValueBridge.value value) ?_ ?_
  · change (C99NameMap115.lookup before.locals name).map C99CompactCells115.Cell.reference = _
    rw [declared]
    rfl
  · exact .scalar _ _ (C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls
      (C99CompactPointer115.noCalls_sound _) before.locals expression value evaluated)

/-- Normal scalar fragment used by the exact MODE1 prologue and tail.
    Unsupported syntax produces no witness, never an invented return. -/
def run : Nat → C99ModularReference.Stmt → State → Option State
  | 0, _, _ => none
  | _+1, .base (.scalar code), state => ShakeXorCompute117.scalar state code
  | _+1, .base .skip, state => some state
  | _+1, .assign name (.scalar expression), state => assign state name expression
  | fuel+1, .seq first second, state => do run fuel second (←run fuel first state)
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
          · exact ShakeXorCompute117.scalar_sound before after _ computed
      | assign name expression =>
          cases expression <;> try cases computed
          exact assign_sound before after name _ computed
      | seq first second =>
          obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
          exact .seqNormal first second (reference before) (reference middle) ⟨reference after,.normal⟩
            (ih first before middle head) (ih second middle after tail)
      | store32 | storeRev | scope | branch | loop | ret | retVoid => cases computed

end FT1536.Source3.KeygenScalarCompute121
