import Source3.C99StateBridge
import Source3.C99ControlInversion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99DeclarationsBridge
open B20.C C99Typing C99StateBridge C99ValueBridge

theorem declarations_complete (calls : C99ScalarReference.CallRelation)
    (s : B20.C.Scalar.State) (t : Ty) (names : List Name) (ctx : Types)
    (r : C99ScalarReference.Result) (hgood : WellTyped s)
    (hcheck : declareTypes s.types t names=some ctx)
    (hsrc : C99ScalarReference.Exec calls (environment s)
      (C99Frontend.declarations (type t) names) r) :
    ∃ out, B20.C.Scalar.declareMany s t names=some out ∧
      r=.normal (environment out) ∧ out.types=ctx ∧ WellTyped out := by
  induction names generalizing s r with
  | nil =>
      have hctx : s.types=ctx := Option.some.inj hcheck
      exact ⟨s,rfl,C99ControlInversion.skip_inv _ _ _ hsrc,hctx,hgood⟩
  | cons name rest ih =>
      have hnone : s.types name=none := by
        cases hn : s.types name with
        | none => rfl
        | some ty => simp [declareTypes,hn] at hcheck
      let next : B20.C.Scalar.State := {s with types := fun n => if n=name then some t else s.types n}
      have hd : B20.C.Scalar.declareOne s t name=some next := by
        simp [B20.C.Scalar.declareOne,hnone,next]
      have hg := declared_good s name t hgood hnone
      have he := declared_environment s name t hgood hnone
      have hc : declareTypes next.types t rest=some ctx := by
        simpa [declareTypes,hnone,next] using hcheck
      rcases C99ControlInversion.seq_inv _ _ _ _ _ hsrc with ⟨mid,hdecl,htail⟩ | ⟨v,hreturn,_⟩
      · have hr := C99ControlInversion.declare_inv _ _ _ _ _ hdecl
        have hm : mid=environment next := (C99ScalarReference.Result.normal.inj hr).trans he.symm
        subst mid
        obtain ⟨out,ho,hresult,htypes,hgo⟩ := ih next r hg hc htail
        exact ⟨out,by simp [B20.C.Scalar.declareMany,hd,ho],hresult,htypes,hgo⟩
      · have no := C99ControlInversion.declare_inv _ _ _ _ _ hreturn
        cases no

end FT1536.Source3.C99DeclarationsBridge

#print axioms FT1536.Source3.C99DeclarationsBridge.declarations_complete
