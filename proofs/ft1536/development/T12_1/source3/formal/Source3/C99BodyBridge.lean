import Source3.C99StatementBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99BodyBridge
open B20.C C99Typing C99StateBridge C99ValueBridge C99ExpressionBridge

theorem body_complete (sig : Types) (rc : C99ScalarReference.CallRelation)
    (mc : B20.C.Scalar.Calls) (hok : CallsOK sig rc mc)
    (body : List CLogic.Stmt) (result : Ty) (s : B20.C.Scalar.State)
    (ctx : Types) (v : C99IntegerReference.Value) (hg : WellTyped s)
    (hc : checkBody sig s.types body=some ctx)
    (hs : C99ScalarReference.Exec rc (environment s) (C99Frontend.scalars body) (.returned v)) :
    CLogic.evalBody mc result body s=some (B20.C.cast result (encode v)) := by
  induction body generalizing s ctx v with
  | nil =>
      have no := C99ControlInversion.skip_inv _ _ _ hs
      cases no
  | cons stmt rest ih =>
      obtain ⟨midTypes,hstmt,hrest⟩ := Option.bind_eq_some_iff.mp hc
      have hseq := C99ControlInversion.seq_inv _ _ _ _ _ hs
      cases stmt with
      | ret e =>
          have hec : expressionCheck sig s.types e=true := by
            by_contra hn
            simp [check,hn] at hstmt
          obtain ⟨te,heType,heDepth⟩ := expression_check _ _ _ hec
          rcases hseq with ⟨middle,hret,_⟩ | ⟨w,hret,hvalue⟩
          · obtain ⟨_,_,hx⟩ := C99ControlInversion.return_inv _ _ _ _ hret
            cases hx
          · have hw : v=w := C99ScalarReference.Result.returned.inj hvalue
            subst w
            obtain ⟨z,hEval,hEq⟩ := C99ControlInversion.return_inv _ _ _ _ hret
            have hv : v=z := C99ScalarReference.Result.returned.inj hEq
            subst z
            have he := (expression_complete sig rc mc hok s hg e te v heType hEval).1
            have hf : CLogic.eval mc s.values 32 e=some (encode v) := by
              rw [ExpressionFuel.fuel_adequate _ _ _ _ heDepth]
              exact he
            simp [CLogic.evalBody,hf]
      | declare t ns =>
          rcases hseq with ⟨middle,hfirst,htail⟩ | ⟨w,hreturn,_⟩
          · obtain ⟨sm,hm,hr,hmt,hgm⟩ := C99StatementBridge.step_complete sig rc mc hok s
              (.declare t ns) midTypes (.normal middle) hg hstmt (by intro e h; cases h) hfirst
            have heq : middle=environment sm := C99ScalarReference.Result.normal.inj hr
            subst middle
            have htcheck : checkBody sig sm.types rest=some ctx := by rw [hmt]; exact hrest
            have hrec := ih sm ctx v hgm htcheck htail
            simp [CLogic.evalBody,hm,hrec]
          · obtain ⟨_,_,hr,_,_⟩ := C99StatementBridge.step_complete sig rc mc hok s
              (.declare t ns) midTypes (.returned w) hg hstmt (by intro e h; cases h) hreturn
            cases hr
      | assign n e =>
          rcases hseq with ⟨middle,hfirst,htail⟩ | ⟨w,hreturn,_⟩
          · obtain ⟨sm,hm,hr,hmt,hgm⟩ := C99StatementBridge.step_complete sig rc mc hok s
              (.assign n e) midTypes (.normal middle) hg hstmt (by intro e h; cases h) hfirst
            have heq : middle=environment sm := C99ScalarReference.Result.normal.inj hr
            subst middle
            have htcheck : checkBody sig sm.types rest=some ctx := by rw [hmt]; exact hrest
            have hrec := ih sm ctx v hgm htcheck htail
            simp [CLogic.evalBody,hm,hrec]
          · obtain ⟨_,_,hr,_,_⟩ := C99StatementBridge.step_complete sig rc mc hok s
              (.assign n e) midTypes (.returned w) hg hstmt (by intro e h; cases h) hreturn
            cases hr
      | update n op e =>
          rcases hseq with ⟨middle,hfirst,htail⟩ | ⟨w,hreturn,_⟩
          · obtain ⟨sm,hm,hr,hmt,hgm⟩ := C99StatementBridge.step_complete sig rc mc hok s
              (.update n op e) midTypes (.normal middle) hg hstmt (by intro e h; cases h) hfirst
            have heq : middle=environment sm := C99ScalarReference.Result.normal.inj hr
            subst middle
            have htcheck : checkBody sig sm.types rest=some ctx := by rw [hmt]; exact hrest
            have hrec := ih sm ctx v hgm htcheck htail
            simp [CLogic.evalBody,hm,hrec]
          · obtain ⟨_,_,hr,_,_⟩ := C99StatementBridge.step_complete sig rc mc hok s
              (.update n op e) midTypes (.returned w) hg hstmt (by intro e h; cases h) hreturn
            cases hr

end FT1536.Source3.C99BodyBridge

#print axioms FT1536.Source3.C99BodyBridge.body_complete
