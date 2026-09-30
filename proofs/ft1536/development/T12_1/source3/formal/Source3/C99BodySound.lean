import Source3.C99StateSound
import Source3.C99NormalBodyBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99BodySound
open B20.C C99Typing C99StateBridge C99ValueBridge C99ExpressionSound

theorem normal_sound (sig : Types) (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (hcall : CallsSound rc mc) (body : List CLogic.Stmt) (s out : B20.C.Scalar.State) (ctx : Types)
    (hg : WellTyped s) (hc : checkBody sig s.types body=some ctx)
    (hs : UnsignedState.exec mc s body=some out) :
    C99ScalarReference.Exec rc (environment s) (C99Frontend.scalars body) (.normal (environment out)) ∧
      WellTyped out ∧ out.types=ctx := by
  induction body generalizing s with
  | nil =>
      have he : s=out := Option.some.inj hs
      subst out
      exact ⟨C99ScalarReference.Exec.skip _,hg,Option.some.inj hc⟩
  | cons stmt rest ih =>
      obtain ⟨midTypes,hcheck,hrestCheck⟩ := Option.bind_eq_some_iff.mp hc
      obtain ⟨mid,hstep,hrest⟩ := Option.bind_eq_some_iff.mp hs
      obtain ⟨hr,hgm,htm⟩ := C99StateSound.step_sound sig rc mc hcall s mid stmt midTypes hg hcheck hstep
      have hct : checkBody sig mid.types rest=some ctx := by rw [htm]; exact hrestCheck
      obtain ⟨hrt,hgo,hto⟩ := ih mid hgm hct hrest
      exact ⟨C99ScalarReference.Exec.seqNormal _ _ _ _ _ hr hrt,hgo,hto⟩

theorem return_sound (sig : Types) (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (hcall : CallsSound rc mc) (body : List CLogic.Stmt) (result : Ty)
    (s : B20.C.Scalar.State) (ctx : Types) (word : Val)
    (hg : WellTyped s) (hc : checkBody sig s.types body=some ctx)
    (hs : CLogic.evalBody mc result body s=some word) :
    ∃ v, C99ScalarReference.Exec rc (environment s) (C99Frontend.scalars body) (.returned v) ∧
      word=B20.C.cast result (encode v) := by
  induction body generalizing s with
  | nil => simp [CLogic.evalBody] at hs
  | cons stmt rest ih =>
      obtain ⟨midTypes,hcheck,hrestCheck⟩ := Option.bind_eq_some_iff.mp hc
      cases stmt with
      | ret e =>
          obtain ⟨v,hv,hword⟩ := Option.map_eq_some_iff.mp hs
          have hec : expressionCheck sig s.types e=true := by
            by_contra hn
            simp [check,hn] at hcheck
          obtain ⟨_,_,hdepth⟩ := expression_check _ _ _ hec
          have hu : ExpressionFuel.unbounded mc s.values e=some v := by
            rw [← ExpressionFuel.fuel_adequate _ _ _ _ hdepth]; exact hv
          have he := C99ScalarReference.Exec.ret (environment s) (C99Frontend.expression e) (value v)
            (expression_sound rc mc hcall s hg e v hu)
          exact ⟨value v,C99ScalarReference.Exec.seqReturn _ _ _ _ he,by simpa [encode_value] using hword.symm⟩
      | declare t ns =>
          obtain ⟨mid,hstep,hrest⟩ := Option.bind_eq_some_iff.mp hs
          obtain ⟨hr,hgm,htm⟩ := C99StateSound.step_sound sig rc mc hcall s mid (.declare t ns) midTypes hg hcheck hstep
          have hct : checkBody sig mid.types rest=some ctx := by rw [htm]; exact hrestCheck
          obtain ⟨v,htail,hv⟩ := ih mid hgm hct hrest
          exact ⟨v,C99ScalarReference.Exec.seqNormal _ _ _ _ _ hr htail,hv⟩
      | assign name e =>
          obtain ⟨mid,hstep,hrest⟩ := Option.bind_eq_some_iff.mp hs
          obtain ⟨hr,hgm,htm⟩ := C99StateSound.step_sound sig rc mc hcall s mid (.assign name e) midTypes hg hcheck hstep
          have hct : checkBody sig mid.types rest=some ctx := by rw [htm]; exact hrestCheck
          obtain ⟨v,htail,hv⟩ := ih mid hgm hct hrest
          exact ⟨v,C99ScalarReference.Exec.seqNormal _ _ _ _ _ hr htail,hv⟩
      | update name op e =>
          obtain ⟨mid,hstep,hrest⟩ := Option.bind_eq_some_iff.mp hs
          obtain ⟨hr,hgm,htm⟩ := C99StateSound.step_sound sig rc mc hcall s mid (.update name op e) midTypes hg hcheck hstep
          have hct : checkBody sig mid.types rest=some ctx := by rw [htm]; exact hrestCheck
          obtain ⟨v,htail,hv⟩ := ih mid hgm hct hrest
          exact ⟨v,C99ScalarReference.Exec.seqNormal _ _ _ _ _ hr htail,hv⟩

end FT1536.Source3.C99BodySound

#print axioms FT1536.Source3.C99BodySound.return_sound
