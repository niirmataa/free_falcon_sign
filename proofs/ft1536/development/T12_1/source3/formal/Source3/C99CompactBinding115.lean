import Source3.C99CompactPointer115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99CompactBinding115
open C99ArrayReference (Param Arg)
open C99CompactState115 (State reference base bindValue bindPointer)

def modelType : C99IntegerReference.Ty → B20.C.Ty
  | .uint64 => .u64 | .int64 => .i64 | .uint32 => .u32 | .int32 => .i32

theorem modelType_reference (ty : C99IntegerReference.Ty) : C99ValueBridge.type (modelType ty)=ty := by
  cases ty <;> rfl

def bind (calls : B20.C.Scalar.Calls) (caller : State) : List Param → List Arg → Option State
  | [], [] => some (base caller)
  | .scalar ty name::params, .scalar expr::args => do
      let value ← C99CompactScalar115.evaluate calls caller.locals expr
      let rest ← bind calls caller params args
      pure (bindValue rest name (modelType ty) value)
  | .pointer name::params, .pointer origin index::args => do
      let value ← C99CompactPointer115.pointer calls caller origin index
      let rest ← bind calls caller params args
      pure (bindPointer rest name value)
  | _, _ => none

theorem bind_sound (calls : B20.C.Scalar.Calls)
    (sound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls)
    (caller out : State) (params : List Param) (args : List Arg)
    (computed : bind calls caller params args=some out) :
    C99ArrayReference.Bind (reference caller) params args (reference out) := by
  induction params generalizing args out with
  | nil =>
      cases args with
      | nil =>
          have same := Option.some.inj computed
          subst out
          exact .nil
      | cons arg args => cases computed
  | cons param params ih =>
      cases args with
      | nil => cases param <;> cases computed
      | cons arg args =>
          cases param <;> cases arg
          case scalar.scalar ty name expr =>
            obtain ⟨value, evaluated, rest⟩ := Option.bind_eq_some_iff.mp computed
            obtain ⟨middle, bound, result⟩ := Option.bind_eq_some_iff.mp rest
            have same := Option.some.inj result
            subst out
            rw [C99CompactState115.reference_bindValue,modelType_reference]
            exact .scalar ty name expr params args (reference middle) (C99ValueBridge.value value)
              (C99CompactScalar115.evaluate_sound FprPrefixCalls.calls calls sound caller.locals expr value evaluated)
              (ih middle args bound)
          case pointer.pointer name origin index =>
            obtain ⟨value, evaluated, rest⟩ := Option.bind_eq_some_iff.mp computed
            obtain ⟨middle, bound, result⟩ := Option.bind_eq_some_iff.mp rest
            have same := Option.some.inj result
            subst out
            rw [C99CompactState115.reference_bindPointer]
            exact .pointer name origin index value params args (reference middle)
              (C99CompactPointer115.pointer_sound calls sound caller origin index value evaluated)
              (ih middle args bound)
          all_goals cases computed

/-- The public API already supplies evaluated typed arguments. -/
def external (caller : State) : List Param → List KeygenMakeArguments.Argument → Option State
  | [], [] => some (base caller)
  | .scalar ty name::params, .scalar value::args => do
      let rest ← external caller params args
      pure (bindValue rest name (modelType ty) (C99ValueBridge.encode value))
  | .pointer name::params, .pointer value::args => do
      let rest ← external caller params args
      pure (bindPointer rest name value)
  | _, _ => none

theorem external_sound (caller out : State) (params : List Param) (args : List KeygenMakeArguments.Argument)
    (computed : external caller params args=some out) :
    KeygenMakeArguments.Bind (reference caller) params args (reference out) := by
  induction params generalizing args out with
  | nil =>
      cases args with
      | nil =>
          have same := Option.some.inj computed
          subst out
          exact .nil
      | cons arg args => cases computed
  | cons param params ih =>
      cases args with
      | nil => cases param <;> cases computed
      | cons arg args =>
          cases param <;> cases arg
          case scalar.scalar ty name value =>
            obtain ⟨middle, bound, result⟩ := Option.bind_eq_some_iff.mp computed
            have same := Option.some.inj result
            subst out
            rw [C99CompactState115.reference_bindValue,modelType_reference,C99ValueBridge.value_encode]
            exact .scalar ty name params value args (reference middle) (ih middle args bound)
          case pointer.pointer name value =>
            obtain ⟨middle, bound, result⟩ := Option.bind_eq_some_iff.mp computed
            have same := Option.some.inj result
            subst out
            rw [C99CompactState115.reference_bindPointer]
            exact .pointer name params value args (reference middle) (ih middle args bound)
          all_goals cases computed

end FT1536.Source3.C99CompactBinding115
