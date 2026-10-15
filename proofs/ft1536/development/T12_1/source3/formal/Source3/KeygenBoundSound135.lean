import Source3.KeygenBoundModel135

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBoundSound135
open B20.C (Val)
open C99ValueBridge (value)
open C99CompactState115 (State reference)
open KeygenBoundModel135

theorem word_only (result : Option Val) (out : Val) (computed : wordOnly result=some out) :
    ∃ word : BitVec 64, out=.u64 word ∧ result=some (.u64 word) := by
  obtain ⟨raw,produced,last⟩ := Option.bind_eq_some_iff.mp computed
  cases raw with
  | u64 word => exact ⟨word,(Option.some.inj last).symm,produced⟩
  | i64 | u32 | i32 => cases last

theorem calls_sound : C99ExpressionSound.CallsSound FprScalarClosure132.calls calls := by
  intro name args out computed
  unfold calls at computed
  split_ifs at computed with ofName sqrtName mulName divName
  · subst name
    cases args with
    | nil => cases computed
    | cons arg rest =>
      cases rest with
      | cons _ _ => cases computed
      | nil =>
        obtain ⟨word,same,produced⟩ := word_only _ out computed
        subst out
        exact FprBoundCalls135.of_source arg word produced
  · subst name
    cases args with
    | nil => cases computed
    | cons arg rest =>
      cases rest with
      | cons _ _ => cases computed
      | nil => exact FprSqrtCompute132.execute_sound GeneratedSqrt132.code 55 arg out computed
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest =>
      cases rest with
      | nil => cases computed
      | cons y tail =>
        cases tail with
        | cons _ _ => cases computed
        | nil =>
          cases x <;> cases y <;> try (solve | cases computed)
          case u64.u64 x y =>
            obtain ⟨word,same,produced⟩ := word_only _ out computed
            subst out
            exact FprBoundCalls135.mul_source x y word produced
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest =>
      cases rest with
      | nil => cases computed
      | cons y tail =>
        cases tail with
        | cons _ _ => cases computed
        | nil =>
          cases x <;> cases y <;> try (solve | cases computed)
          case u64.u64 x y =>
            obtain ⟨word,same,produced⟩ := word_only _ out computed
            subst out
            exact FprBoundCalls135.div_source x y word produced

theorem eval_sound (mc : B20.C.Scalar.Calls)
    (sound : C99ExpressionSound.CallsSound FprScalarClosure132.calls mc) (ctx : KeygenSearchContext.Context) (before : State) (expr : KeygenSearchExec.Expr)
    (out : Val) (computed : eval mc before.locals expr=some out) :
    KeygenSearchExtended133.Eval ctx (reference before) expr (value out) := by
  induction expr generalizing out with
  | base expr =>
      cases expr <;> try (solve | cases computed)
      case scalar code =>
        exact .base _ _ (.scalar _ _ (C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls before.locals code out computed))
  | plain => cases computed
  | unary name expr ih =>
      obtain ⟨arg,evaluated,called⟩ := Option.bind_eq_some_iff.mp computed
      exact .unary _ _ _ _ (ih arg evaluated) (sound name [arg] out called)
  | binary name left right ihLeft ihRight =>
      obtain ⟨x,first,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨y,second,called⟩ := Option.bind_eq_some_iff.mp rest
      exact .binary _ _ _ _ _ _ (ihLeft x first) (ihRight y second) (sound name [x,y] out called)
  | cast ty expr ih =>
      obtain ⟨arg,evaluated,result⟩ := Option.bind_eq_some_iff.mp computed
      have same := Option.some.inj result
      subst out
      rw [C99ValueBridge.value_encode]
      exact .cast ty expr (value arg) (ih arg evaluated)

theorem assign_sound (mc : B20.C.Scalar.Calls)
    (sound : C99ExpressionSound.CallsSound FprScalarClosure132.calls mc) (ctx : KeygenSearchContext.Context) (before after : State)
    (name : B20.C.Name) (expr : KeygenSearchExec.Expr) (computed : assign mc before name expr=some after) :
    KeygenSearchExtended133.Exec ctx (.assign name expr) (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨out,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindValue]
  refine .assign name expr (reference before) (C99ValueBridge.type cell.ty)
    (cell.value.map value) (value out) ?_ (eval_sound mc sound ctx before expr out evaluated)
  change (C99NameMap115.lookup before.locals name).map C99CompactCells115.Cell.reference=_
  rw [declared]
  rfl

theorem run_sound (mc : B20.C.Scalar.Calls)
    (sound : C99ExpressionSound.CallsSound FprScalarClosure132.calls mc) (ctx : KeygenSearchContext.Context) (fuel : Nat) (code : KeygenSearchExec.Stmt)
    (before after : State) (computed : run mc fuel code before=some after) :
    KeygenSearchExtended133.Exec ctx code (reference before) ⟨reference after,.normal⟩ := by
  induction fuel generalizing code before after with
  | zero => cases computed
  | succ fuel ih =>
    cases code with
    | procedure code =>
      cases code <;> try (solve | cases computed)
      case base base =>
        cases base <;> try (solve | cases computed)
        case skip =>
          have same := Option.some.inj computed
          subst after
          exact .procedure _ _ _ (.base _ _ _ (.skip _))
    | assign name expr => exact assign_sound mc sound ctx before after name expr computed
    | seq first second =>
      obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
      exact .seqNormal _ _ _ _ _ (ih first before middle head) (ih second middle after tail)
    | logn | pointer | store | move | small | scope | branch | loop => cases computed

end FT1536.Source3.KeygenBoundSound135
