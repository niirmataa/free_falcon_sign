import Source3.C99ShiftCompute130
import Source3.C99CompactScalar115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ScalarCompute130
open B20.C (Val Env)
open C99ValueBridge (value)

def eval (env : Env) : CLogic.Expr → Option Val
  | .literal ty n => some (B20.C.literalValue ty n)
  | .var name => env name
  | .cast ty expr => (eval env expr).map (B20.C.cast ty)
  | .neg expr => (eval env expr).bind B20.C.neg
  | .bitNot expr => (eval env expr).map B20.C.notBits
  | .bin op left right => do C99ShiftCompute130.bin op (← eval env left) (← eval env right)
  | .cmp op left right => do pure (CLogic.compare op (← eval env left) (← eval env right))
  | .lnot expr => (eval env expr).map (fun x => CLogic.boolean (!CLogic.truth x))
  | .land left right => do
      let x ← eval env left
      if CLogic.truth x then (eval env right).map (CLogic.boolean ∘ CLogic.truth) else pure (CLogic.boolean false)
  | .lor left right => do
      let x ← eval env left
      if CLogic.truth x then pure (CLogic.boolean true) else (eval env right).map (CLogic.boolean ∘ CLogic.truth)
  | .call1 _ _ | .call2 _ _ _ | .call3 _ _ _ _ => none

theorem eval_sound (calls : C99ScalarReference.CallRelation) (s : B20.C.Scalar.State)
    (typed : C99Typing.WellTyped s) (expr : CLogic.Expr) (out : Val)
    (computed : eval s.values expr=some out) :
    C99ScalarReference.Eval calls (C99Typing.environment s) (C99Frontend.expression expr) (value out) := by
  induction expr generalizing out with
  | literal ty n =>
      have same := Option.some.inj computed
      subst out
      rw [C99ExpressionSound.literal_value]
      exact .literal _ _
  | var name =>
      have read : s.values name=some out := computed
      exact .variable name (C99ValueBridge.type out.ty) (value out)
        (by simp [C99Typing.environment,typed name out read,read])
  | cast ty expr ih =>
      obtain ⟨x,read,same⟩ := Option.map_eq_some_iff.mp computed
      subst out
      rw [C99ValueBridge.cast_matches]
      exact .cast _ _ _ (ih x read)
  | neg expr ih =>
      obtain ⟨x,read,operation⟩ := Option.bind_eq_some_iff.mp computed
      exact .neg _ _ _ (ih x read) (C99UnarySound.neg_sound x out operation)
  | bitNot expr ih =>
      obtain ⟨x,read,same⟩ := Option.map_eq_some_iff.mp computed
      subst out
      exact .complement _ _ _ (ih x read) (C99UnarySound.complement_sound x)
  | bin op left right ihLeft ihRight =>
      obtain ⟨x,readLeft,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨y,readRight,operation⟩ := Option.bind_eq_some_iff.mp rest
      exact C99ExpressionSound.binary_reference calls (C99Typing.environment s) op _ _ _ _ _
        (ihLeft x readLeft) (ihRight y readRight) (C99ShiftCompute130.bin_sound op x y out operation)
  | cmp op left right ihLeft ihRight =>
      obtain ⟨x,readLeft,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨y,readRight,result⟩ := Option.bind_eq_some_iff.mp rest
      have same := Option.some.inj result
      subst out
      exact .compare _ _ _ _ _ _ (ihLeft x readLeft) (ihRight y readRight) (C99IntegerSound.compare_sound op x y)
  | lnot expr ih =>
      obtain ⟨x,read,same⟩ := Option.map_eq_some_iff.mp computed
      subst out
      have source := C99ScalarReference.Eval.logicalNot _ _ (ih x read)
      simpa [C99ExpressionSound.boolean_value,C99ExpressionSound.truth_value,C99Frontend.expression] using source
  | land left right ihLeft ihRight =>
      obtain ⟨x,readLeft,rest⟩ := Option.bind_eq_some_iff.mp computed
      by_cases truth : CLogic.truth x=true
      · have nonzero : (value x).integer≠0 := by simpa [C99ExpressionSound.truth_value] using truth
        have mapped : (eval s.values right).map (CLogic.boolean ∘ CLogic.truth)=some out := by simpa [truth] using rest
        obtain ⟨y,readRight,same⟩ := Option.map_eq_some_iff.mp mapped
        subst out
        have source := C99ScalarReference.Eval.andTrue _ _ _ _ (ihLeft x readLeft) nonzero (ihRight y readRight)
        simpa [Function.comp_def,C99ExpressionSound.boolean_value,C99ExpressionSound.truth_value,C99Frontend.expression] using source
      · have zero : (value x).integer=0 := by simpa [C99ExpressionSound.truth_value] using truth
        have same : CLogic.boolean false=out := Option.some.inj (by simpa [truth] using rest)
        subst out
        exact .andFalse _ _ _ (ihLeft x readLeft) zero
  | lor left right ihLeft ihRight =>
      obtain ⟨x,readLeft,rest⟩ := Option.bind_eq_some_iff.mp computed
      by_cases truth : CLogic.truth x=true
      · have nonzero : (value x).integer≠0 := by simpa [C99ExpressionSound.truth_value] using truth
        have same : CLogic.boolean true=out := Option.some.inj (by simpa [truth] using rest)
        subst out
        exact .orTrue _ _ _ (ihLeft x readLeft) nonzero
      · have zero : (value x).integer=0 := by simpa [C99ExpressionSound.truth_value] using truth
        have mapped : (eval s.values right).map (CLogic.boolean ∘ CLogic.truth)=some out := by simpa [truth] using rest
        obtain ⟨y,readRight,same⟩ := Option.map_eq_some_iff.mp mapped
        subst out
        have source := C99ScalarReference.Eval.orFalse _ _ _ _ (ihLeft x readLeft) zero (ihRight y readRight)
        simpa [Function.comp_def,C99ExpressionSound.boolean_value,C99ExpressionSound.truth_value,C99Frontend.expression] using source
  | call1 | call2 | call3 => cases computed

def evaluate (locals : C99CompactCells115.Locals) (expr : CLogic.Expr) : Option Val :=
  eval (C99CompactCells115.model locals).values expr

theorem evaluate_sound (calls : C99ScalarReference.CallRelation) (locals : C99CompactCells115.Locals)
    (expr : CLogic.Expr) (out : Val) (computed : evaluate locals expr=some out) :
    C99ScalarReference.Eval calls (C99CompactCells115.environment locals) (C99Frontend.expression expr) (value out) := by
  rw [C99CompactCells115.environment_model]
  exact eval_sound calls (C99CompactCells115.model locals) (C99CompactCells115.model_typed locals) expr out computed

end FT1536.Source3.C99ScalarCompute130
