import Source3.KeygenWordCompute130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordComputeSound130
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open C99ValueBridge (value)
open KeygenWordExpr (Expr Eval)
open KeygenWordCompute130 (evaluate)

theorem sound (before : State) (expr : Expr) (out : B20.C.Val)
    (computed : evaluate before expr=some out) : Eval (reference before) expr (value out) := by
  induction expr generalizing out with
  | scalar expr =>
      exact .scalar expr (value out) (C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls before.locals expr out computed)
  | load32 name index =>
      obtain ⟨pointer,address,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨word,read,same⟩ := Option.map_eq_some_iff.mp rest
      subst out
      exact .load32 name index pointer word
        (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before name index pointer address)
        (C99FiniteRead114.read32_sound before.heap pointer word read)
  | load16 name index =>
      obtain ⟨pointer,address,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨word,read,same⟩ := Option.map_eq_some_iff.mp rest
      subst out
      exact .load16 name index pointer word
        (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before name index pointer address)
        (C99Read16Compute130.read_sound before.heap pointer word read)
  | cast ty expr ih =>
      obtain ⟨x,read,same⟩ := Option.map_eq_some_iff.mp computed
      subst out
      rw [C99ValueBridge.cast_matches,C99CompactBinding115.modelType_reference]
      exact .cast ty expr (value x) (ih x read)
  | neg expr ih =>
      obtain ⟨x,read,operation⟩ := Option.bind_eq_some_iff.mp computed
      exact .neg expr (value x) (value out) (ih x read) (C99UnarySound.neg_sound x out operation)
  | bitNot expr ih =>
      obtain ⟨x,read,same⟩ := Option.map_eq_some_iff.mp computed
      subst out
      exact .bitNot expr (value x) (value (B20.C.notBits x)) (ih x read) (C99UnarySound.complement_sound x)
  | lnot expr ih =>
      obtain ⟨x,read,same⟩ := Option.map_eq_some_iff.mp computed
      subst out
      simpa only [C99ExpressionSound.boolean_value,C99ValueBridge.integer_matches] using
        (Eval.lnot expr (value x) (ih x read))
  | bin op left right ihLeft ihRight =>
      obtain ⟨x,readLeft,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨y,readRight,operation⟩ := Option.bind_eq_some_iff.mp rest
      exact .bin op left right (value x) (value y) (value out) (ihLeft x readLeft) (ihRight y readRight)
        (C99ShiftCompute130.bin_sound op x y out operation)
  | cmp op left right ihLeft ihRight =>
      obtain ⟨x,readLeft,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨y,readRight,result⟩ := Option.bind_eq_some_iff.mp rest
      have same := Option.some.inj result
      subst out
      exact .cmp op left right (value x) (value y) (value (CLogic.compare op x y))
        (ihLeft x readLeft) (ihRight y readRight) (C99IntegerSound.compare_sound op x y)
  | land left right ihLeft ihRight =>
      obtain ⟨x,readLeft,rest⟩ := Option.bind_eq_some_iff.mp computed
      by_cases zero : x.integer=0
      · have same : CLogic.boolean false=out := Option.some.inj (by simpa [zero] using rest)
        subst out
        exact .andFalse left right (value x) (ihLeft x readLeft)
          (by simpa only [C99ValueBridge.integer_matches] using zero)
      · have mapped : (evaluate before right).map (fun y => CLogic.boolean (decide (y.integer≠0)))=some out := by
          simpa [zero] using rest
        obtain ⟨y,readRight,same⟩ := Option.map_eq_some_iff.mp mapped
        subst out
        simpa only [C99ExpressionSound.boolean_value,C99ValueBridge.integer_matches] using
          (Eval.andTrue left right (value x) (value y) (ihLeft x readLeft)
            (by simpa only [C99ValueBridge.integer_matches] using zero) (ihRight y readRight))
  | lor left right ihLeft ihRight =>
      obtain ⟨x,readLeft,rest⟩ := Option.bind_eq_some_iff.mp computed
      by_cases zero : x.integer=0
      · have mapped : (evaluate before right).map (fun y => CLogic.boolean (decide (y.integer≠0)))=some out := by
          simpa [zero] using rest
        obtain ⟨y,readRight,same⟩ := Option.map_eq_some_iff.mp mapped
        subst out
        simpa only [C99ExpressionSound.boolean_value,C99ValueBridge.integer_matches] using
          (Eval.orFalse left right (value x) (value y) (ihLeft x readLeft)
            (by simpa only [C99ValueBridge.integer_matches] using zero) (ihRight y readRight))
      · have same : CLogic.boolean true=out := Option.some.inj (by simpa [zero] using rest)
        subst out
        exact .orTrue left right (value x) (ihLeft x readLeft)
          (by simpa only [C99ValueBridge.integer_matches] using zero)
  | call1 | call2 | call3 | call4 | call5 => cases computed

end FT1536.Source3.KeygenWordComputeSound130
