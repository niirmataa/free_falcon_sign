import Source3.C99CompactState115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99CompactPointer115
open C99MemoryReference
open C99ArrayReference (Name)
open C99CompactState115 (State reference)
open B20.C (Val)

def advance (pointer : ArrayPointer) (index : Val) : Option ArrayPointer :=
  if 0 ≤ index.integer ∧ pointer.index + index.integer.toNat ≤ pointer.count then
    some {pointer with index := pointer.index+index.integer.toNat}
  else none

theorem advance_sound (pointer out : ArrayPointer) (index : Val) (computed : advance pointer index=some out) :
    0≤(C99ValueBridge.value index).integer ∧
      PointerAdd pointer (C99ValueBridge.value index).integer.toNat out := by
  unfold advance at computed
  split at computed
  next guard =>
    have same := Option.some.inj computed
    subst out
    rw [C99ValueBridge.integer_matches]
    exact ⟨guard.1,.within pointer index.integer.toNat guard.2⟩
  next rejected => cases computed

def pointer (calls : B20.C.Scalar.Calls) (state : State) (name : Name) (index : CLogic.Expr) : Option ArrayPointer := do
  let base ← C99NameMap115.lookup state.arrays name
  let value ← C99CompactScalar115.evaluate calls state.locals index
  advance base value

theorem pointer_sound (calls : B20.C.Scalar.Calls)
    (sound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls)
    (state : State) (name : Name) (index : CLogic.Expr) (out : ArrayPointer)
    (computed : pointer calls state name index=some out) :
    C99ArrayReference.Pointer (reference state) name index out := by
  obtain ⟨base, found, rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value, evaluated, added⟩ := Option.bind_eq_some_iff.mp rest
  have advanced := advance_sound base out value added
  exact .add name index base out (C99ValueBridge.value value) found
    (C99CompactScalar115.evaluate_sound FprPrefixCalls.calls calls sound state.locals index value evaluated)
    advanced.1 advanced.2

def noCalls : B20.C.Scalar.Calls := fun _ _ => none

theorem noCalls_sound (relation : C99ScalarReference.CallRelation) :
    C99ExpressionSound.CallsSound relation noCalls := by
  intro name args value computed
  cases computed

def declarePointer (state : State) (name : Name) : State :=
  {state with arrays := C99NameMap115.erase state.arrays name}

theorem declarePointer_reference (state : State) (name : Name) :
    reference (declarePointer state name) =
      {reference state with arrays := fun other => if other=name then none else (reference state).arrays other} := by
  have arrays : C99NameMap115.lookup (C99NameMap115.erase state.arrays name) =
      fun other => if other=name then none else C99NameMap115.lookup state.arrays other := by
    funext other
    exact C99NameMap115.lookup_erase state.arrays name other
  simp only [reference,declarePointer,arrays]

end FT1536.Source3.C99CompactPointer115
