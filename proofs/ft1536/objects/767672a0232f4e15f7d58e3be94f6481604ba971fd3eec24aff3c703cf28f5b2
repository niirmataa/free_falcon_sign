import Source3.C99StatementBridge
import Source3.UnsignedState

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99NormalBodyBridge
open B20.C C99Typing C99StateBridge C99ValueBridge C99ExpressionBridge

theorem normal_complete (sig : Types) (rc : C99ScalarReference.CallRelation)
    (mc : B20.C.Scalar.Calls) (hok : CallsOK sig rc mc)
    (body : List CLogic.Stmt) (s : B20.C.Scalar.State) (ctx : Types)
    (env : C99ScalarReference.Env) (hg : WellTyped s)
    (hc : checkBody sig s.types body=some ctx)
    (hs : C99ScalarReference.Exec rc (environment s) (C99Frontend.scalars body) (.normal env)) :
    ∃ out, UnsignedState.exec mc s body=some out ∧ environment out=env ∧
      out.types=ctx ∧ WellTyped out := by
  induction body generalizing s ctx env with
  | nil =>
      have heq : env=environment s := C99ScalarReference.Result.normal.inj (C99ControlInversion.skip_inv _ _ _ hs)
      have hctx : s.types=ctx := Option.some.inj hc
      exact ⟨s,rfl,heq.symm,hctx,hg⟩
  | cons stmt rest ih =>
      obtain ⟨midTypes,hstmt,hrest⟩ := Option.bind_eq_some_iff.mp hc
      rcases C99ControlInversion.seq_inv _ _ _ _ _ hs with ⟨middle,hfirst,htail⟩ | ⟨v,_,hbad⟩
      · by_cases hret : ∃ e, stmt=.ret e
        · obtain ⟨e,rfl⟩ := hret
          obtain ⟨_,_,hr⟩ := C99ControlInversion.return_inv _ _ _ _ hfirst
          cases hr
        · have hnot : ∀ e, stmt≠.ret e := fun e h => hret ⟨e,h⟩
          obtain ⟨sm,hm,hr,hmt,hgm⟩ := C99StatementBridge.step_complete sig rc mc hok s
            stmt midTypes (.normal middle) hg hstmt hnot hfirst
          have heq : middle=environment sm := C99ScalarReference.Result.normal.inj hr
          subst middle
          have htcheck : checkBody sig sm.types rest=some ctx := by rw [hmt]; exact hrest
          obtain ⟨out,ho,henv,ht,hgo⟩ := ih sm ctx env hgm htcheck htail
          exact ⟨out,by simp [UnsignedState.exec,hm,ho],henv,ht,hgo⟩
      · cases hbad

theorem normal_no_return (body : List CLogic.Stmt)
    (hn : ∀ e, CLogic.Stmt.ret e∉body)
    (rc : C99ScalarReference.CallRelation) (env : C99ScalarReference.Env) (v : C99IntegerReference.Value) :
    ¬C99ScalarReference.Exec rc env (C99Frontend.scalars body) (.returned v) := by
  intro h
  induction body generalizing env with
  | nil => have no := C99ControlInversion.skip_inv _ _ _ h; cases no
  | cons stmt rest ih =>
      have hnRest : ∀ e, CLogic.Stmt.ret e∉rest := fun e he => hn e (List.mem_cons_of_mem stmt he)
      rcases C99ControlInversion.seq_inv _ _ _ _ _ h with ⟨mid,_,hr⟩ | ⟨z,hfirst,hret⟩
      · exact ih hnRest mid hr
      · cases stmt with
        | ret e => exact hn e (by simp)
        | declare t ns =>
            have hfirst' : C99ScalarReference.Exec rc env (C99Frontend.declarations (type t) ns) (.returned z) := hfirst
            clear hfirst hret hn h
            induction ns generalizing env with
            | nil => have no := C99ControlInversion.skip_inv _ _ _ hfirst'; cases no
            | cons n ns ihNames =>
                rcases C99ControlInversion.seq_inv _ _ _ _ _ hfirst' with ⟨mid,_,htail⟩ | ⟨w,hdecl,_⟩
                · exact ihNames mid htail
                · have no := C99ControlInversion.declare_inv _ _ _ _ _ hdecl; cases no
        | assign n e =>
            obtain ⟨_,_,_,_,_,no⟩ := C99ControlInversion.assign_inv _ _ _ _ _ hfirst
            cases no
        | update n op e =>
            obtain ⟨_,_,_,_,_,no⟩ := C99ControlInversion.assign_inv _ _ _ _ _ hfirst
            cases no

end FT1536.Source3.C99NormalBodyBridge

#print axioms FT1536.Source3.C99NormalBodyBridge.normal_complete
