import Source3.C99BodyBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99ParametersBridge
open B20.C C99Typing C99StateBridge C99ValueBridge

def paramTypes : List (Ty × Name) → Option Types
  | [] => some (fun _ => none)
  | (ty,name)::rest => do
      let ctx ← paramTypes rest
      if (ctx name).isSome then none else
        pure (fun other => if other=name then some ty else ctx other)

theorem bind_length (ps : List (C99IntegerReference.Ty × Name))
    (args : List C99IntegerReference.Value) (env : C99ScalarReference.Env)
    (h : C99ScalarReference.BindArgs ps args env) : args.length=ps.length := by
  induction h <;> simp_all

theorem bind_cons_inv (ty : C99IntegerReference.Ty) (name : Name)
    (ps : List (C99IntegerReference.Ty × Name)) (a : C99IntegerReference.Value)
    (args : List C99IntegerReference.Value) (env : C99ScalarReference.Env)
    (h : C99ScalarReference.BindArgs ((ty,name)::ps) (a::args) env) :
    ∃ tail, C99ScalarReference.BindArgs ps args tail ∧
      env=C99ScalarReference.set tail name (ty,some (C99IntegerReference.convert ty a.integer)) := by
  cases h
  exact ⟨_,by assumption,rfl⟩

theorem bind_complete (ps : List (Ty × Name)) (args : List Val)
    (env : C99ScalarReference.Env) (ctx : Types)
    (hc : paramTypes ps=some ctx)
    (hr : C99ScalarReference.BindArgs (ps.map (fun (t,n) => (type t,n))) (args.map value) env) :
    ∃ out, B20.C.Scalar.bindArgs ps args=some out ∧ environment out=env ∧
      out.types=ctx ∧ WellTyped out := by
  have hlen : args.length=ps.length := by simpa using bind_length _ _ _ hr
  induction ps generalizing args env ctx with
  | nil =>
      have hargs : args=[] := List.eq_nil_of_length_eq_zero (by simpa using hlen)
      subst args
      cases hr
      have hctx : (fun _ => none)=ctx := Option.some.inj hc
      refine ⟨B20.C.Scalar.emptyState,rfl,rfl,hctx,?_⟩
      intro name v hv
      simp [B20.C.Scalar.emptyState] at hv
  | cons p rest ih =>
      rcases p with ⟨t,name⟩
      cases args with
      | nil => simp at hlen
      | cons a tail =>
          obtain ⟨rTail,hrTail,hEnv⟩ := bind_cons_inv (type t) name _ (value a) _ env hr
          obtain ⟨ctxTail,hCtxTail,hNext⟩ := Option.bind_eq_some_iff.mp hc
          have fresh : ctxTail name=none := by
            cases hn : ctxTail name with
            | none => rfl
            | some ty => simp [hn] at hNext
          have hCtx : ctx=(fun other => if other=name then some t else ctxTail other) := by
            exact (Option.some.inj (by simpa [fresh] using hNext)).symm
          obtain ⟨s,hs,hRel,ht,hGood⟩ := ih tail rTail ctxTail hCtxTail hrTail (by simpa using hlen)
          let declared : B20.C.Scalar.State :=
            {s with types := fun other => if other=name then some t else s.types other}
          let out : B20.C.Scalar.State := {declared with values := update s.values name (B20.C.cast t a)}
          have hFresh : s.types name=none := by rw [ht]; exact fresh
          have hDecl : B20.C.Scalar.declareOne s t name=some declared := by
            simp [B20.C.Scalar.declareOne,hFresh,declared]
          have hAssign : B20.C.Scalar.assign declared name a=some out := by
            simp [B20.C.Scalar.assign,declared,out]
          have hGoodD := declared_good s name t hGood hFresh
          have hTypeD : declared.types name=some t := by simp [declared]
          refine ⟨out,?_,?_,?_,assigned_good declared name a t hGoodD hTypeD⟩
          · simp [B20.C.Scalar.bindArgs,hs,hDecl,hAssign]
          · have hae := assigned_environment declared name (value a) t hTypeD
            have hde := declared_environment s name t hGood hFresh
            rw [encode_value] at hae
            rw [hae,hde,hRel,hEnv]
            funext n
            by_cases heq : n=name <;> simp [C99ScalarReference.set,heq]
          · simp only [out,declared,ht,hCtx]

end FT1536.Source3.C99ParametersBridge

#print axioms FT1536.Source3.C99ParametersBridge.bind_complete
