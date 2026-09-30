import Source3.C99DeclarationsBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99StatementBridge
open B20.C C99Typing C99StateBridge C99ValueBridge C99ExpressionBridge

theorem assign_complete (sig : Types) (rc : C99ScalarReference.CallRelation)
    (mc : B20.C.Scalar.Calls) (hok : CallsOK sig rc mc)
    (s : B20.C.Scalar.State) (n : Name) (e : CLogic.Expr) (t : Ty)
    (r : C99ScalarReference.Result) (hg : WellTyped s)
    (ht : s.types n=some t) (hc : expressionCheck sig s.types e=true)
    (hs : C99ScalarReference.Exec rc (environment s) (.assign n (C99Frontend.expression e)) r) :
    ∃ out, CLogic.step mc s (.assign n e)=some out ∧ r=.normal (environment out) ∧
      out.types=s.types ∧ WellTyped out := by
  obtain ⟨rt,old,v,hdecl,heval,hresult⟩ := C99ControlInversion.assign_inv _ _ _ _ _ hs
  have hrt : rt=type t := by
    have hh : type t=rt ∧ (s.values n).map value=old := by simpa [environment,ht] using hdecl
    exact hh.1.symm
  subst rt
  obtain ⟨et,heType,hdepth⟩ := expression_check _ _ _ hc
  have he := (expression_complete sig rc mc hok s hg e et v heType heval).1
  have he32 : CLogic.eval mc s.values 32 e=some (encode v) := by
    rw [ExpressionFuel.fuel_adequate _ _ _ _ hdepth]
    exact he
  let out : B20.C.Scalar.State := {s with values := update s.values n (B20.C.cast t (encode v))}
  refine ⟨out,?_,?_,rfl,assigned_good s n (encode v) t hg ht⟩
  · simp [CLogic.step,B20.C.Scalar.assign,he32,ht,out]
  · exact hresult.trans (congrArg C99ScalarReference.Result.normal (assigned_environment s n v t ht).symm)

theorem step_complete (sig : Types) (rc : C99ScalarReference.CallRelation)
    (mc : B20.C.Scalar.Calls) (hok : CallsOK sig rc mc)
    (s : B20.C.Scalar.State) (stmt : CLogic.Stmt) (ctx : Types)
    (r : C99ScalarReference.Result) (hg : WellTyped s)
    (hc : check sig s.types stmt=some ctx)
    (hnotRet : ∀ e, stmt≠.ret e)
    (hs : C99ScalarReference.Exec rc (environment s) (C99Frontend.scalar stmt) r) :
    ∃ out, CLogic.step mc s stmt=some out ∧ r=.normal (environment out) ∧
      out.types=ctx ∧ WellTyped out := by
  cases stmt with
  | declare t ns =>
      exact C99DeclarationsBridge.declarations_complete rc s t ns ctx r hg hc hs
  | assign n e =>
      have cond : (s.types n).isSome=true ∧ expressionCheck sig s.types e=true := by
        by_cases hh : (s.types n).isSome && expressionCheck sig s.types e
        · exact (Bool.and_eq_true _ _).mp hh
        · simp [check,hh] at hc
      obtain ⟨t,ht⟩ := Option.isSome_iff_exists.mp cond.1
      have hctx : s.types=ctx := by simpa [check,cond.1,cond.2] using hc
      obtain ⟨out,ho,hr,htypes,hgo⟩ := assign_complete sig rc mc hok s n e t r hg ht cond.2 hs
      exact ⟨out,ho,hr,htypes.trans hctx,hgo⟩
  | update n op e =>
      have cond : (s.types n).isSome=true ∧ expressionCheck sig s.types (.bin op (.var n) e)=true := by
        by_cases hh : (s.types n).isSome && expressionCheck sig s.types (.bin op (.var n) e)
        · exact (Bool.and_eq_true _ _).mp hh
        · simp [check,hh] at hc
      obtain ⟨t,ht⟩ := Option.isSome_iff_exists.mp cond.1
      have hctx : s.types=ctx := by simpa [check,cond.1,cond.2] using hc
      obtain ⟨out,ho,hr,htypes,hgo⟩ := assign_complete sig rc mc hok s n (.bin op (.var n) e) t r hg ht cond.2 hs
      obtain ⟨_,_,hd⟩ := expression_check _ _ _ cond.2
      have h31 : ExpressionFuel.depth e≤31 := by simp only [ExpressionFuel.depth] at hd; omega
      have h32 : ExpressionFuel.depth e≤32 := by omega
      have he31 := ExpressionFuel.fuel_adequate mc s.values e 31 h31
      have he32 := ExpressionFuel.fuel_adequate mc s.values e 32 h32
      refine ⟨out,?_,hr,htypes.trans hctx,hgo⟩
      simpa [CLogic.step,CLogic.eval,he31,he32,Option.bind_assoc] using ho
  | ret e => exact False.elim (hnotRet e rfl)

end FT1536.Source3.C99StatementBridge

#print axioms FT1536.Source3.C99StatementBridge.step_complete
