import Source3.KeygenCodecValueAgreement107

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStateAgreement107
open KeygenCodecSyntax
open KeygenCodecValues
open KeygenCodecAgreement107 (Agree noComp)
open KeygenCodecAtoms106 (Clean)

def Related (a b : State) : Prop := a.heap = b.heap ∧ Agree a.locals b.locals ∧ a.buf = b.buf

theorem locals (a b : State) (x y : Locals) (same : Related a b) (values : Agree x y) :
    Related (withLocals a x) (withLocals b y) := ⟨same.1, values, same.2.2⟩

theorem assignment (a b : State) (x y : Locals) (name : Name) (ty : C99IntegerReference.Ty)
    (v : Option C99IntegerReference.Value) (same : Related a b) (values : Agree x y) :
    Related (withLocals a (localSet x name ty v)) (withLocals b (localSet y name ty v)) :=
  locals a b _ _ same (KeygenCodecAgreement107.set x y name ty v values)

theorem declarations (objects : List Object) (a b c d : Locals) (same : Agree a b)
    (first : declareLocals objects a = some c) (second : declareLocals objects b = some d) : Agree c d := by
  induction objects generalizing a b c d with
  | nil => cases first; cases second; exact same
  | cons obj rest ih =>
      simp only [declareLocals] at first second
      by_cases count : obj.count.isSome
      · simp only [count, ite_true] at first; cases first
      · simp only [count] at first second
        by_cases buf : obj.name = "buf".toList
        · simp only [buf, ite_true] at first second
          by_cases ty : obj.type = .pointer .byte
          · simp only [ty, ite_true] at first second
            exact ih _ _ _ _ same first second
          · simp only [ty, ite_false] at first; cases first
        · simp only [buf, ite_false] at first second
          cases ht : scalarTy obj.type with
          | none => simp only [ht] at first; cases first
          | some ty =>
              simp only [ht] at first second
              exact ih _ _ _ _ (KeygenCodecAgreement107.set a b obj.name ty none same) first second

theorem declared (objects : List Object) (a b : State) (x y : Locals)
    (same : Related a b) (values : Agree x y) : Related (KeygenCodecValues.declared a objects x) (KeygenCodecValues.declared b objects y) := by
  refine ⟨same.1, values, ?_⟩
  simp only [KeygenCodecValues.declared]
  split
  · rfl
  · exact same.2.2

theorem scope (code : Stmt) (a b c d : State) (outer : Related a b) (inner : Related c d) :
    Related (KeygenCodecExecution.scopeExit code a c) (KeygenCodecExecution.scopeExit code b d) := by
  refine ⟨inner.1, ⟨inner.2.1.1, ?_⟩, ?_⟩
  · intro name different
    simp only [KeygenCodecExecution.scopeExit]
    split
    · exact outer.2.1.2 name different
    · exact inner.2.1.2 name different
  · simp only [KeygenCodecExecution.scopeExit]
    split
    · exact outer.2.2
    · exact inner.2.2

theorem expression (argsA argsB : Args) (a b : State) (e : Expr) (x y : Value) (c d : Locals)
    (first : Eval argsA a.heap a.buf e a.locals x c) (second : Eval argsB b.heap b.buf e b.locals y d)
    (same : Related a b) (start : Clean a.locals) (outEqual : argsA.out = argsB.out) (checked : noComp e = true) :
    Agree c d ∧ x = y := by
  have second' : Eval argsB a.heap a.buf e b.locals y d := by rw [same.1, same.2.2]; exact second
  exact KeygenCodecValueAgreement107.expression argsA argsB a.heap a.buf e a.locals b.locals c d x y
    first second' start same.2.1 outEqual checked

def checkedCode : Stmt → Bool
  | .declare objects => objects.all fun o => decide (o.name ≠ "comp".toList)
  | .write lhs _ rhs => noComp lhs && noComp rhs
  | .increment e | .evaluate e | .ret e => noComp e
  | .seq a b => checkedCode a && checkedCode b
  | .scope body => checkedCode body
  | .branch e a b => noComp e && checkedCode a && checkedCode b
  | .whileLoop e body => noComp e && checkedCode body
  | .switch e a b c => noComp e && checkedCode a && checkedCode b && checkedCode c
  | .loop initial test increment body => checkedCode initial &&
      (noComp (KeygenCodecExecution.testExpr test) && (checkedCode body && checkedCode increment))
  | .skip | .breakLoop | .continueLoop => true

theorem none_checked : checkedCode KeygenCodecNoneBinding.code = true := by decide +kernel

theorem static_checked : checkedCode KeygenCodecStaticBinding.code = true := by decide +kernel

end FT1536.Source3.KeygenCodecStateAgreement107
