import Source3.C99HeaderSound
import Source3.C99PrimitiveProof

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99FprInversion
open B20.C

theorem execute_inv (f : FprPrimitives.Function) (args : List Val) (w : Val)
    (h : FprPrimitives.execute f args=some w) :
    ∃ s out, B20.C.Scalar.bindArgs f.params args=some s ∧
      FprPrimitives.execBlock 256 f.result f.body s=some (out,some w) := by
  obtain ⟨s,hbind,hr⟩ := Option.bind_eq_some_iff.mp h
  obtain ⟨⟨out,ret⟩,hbody,hret⟩ := Option.bind_eq_some_iff.mp hr
  have he : ret=some w := hret
  exact ⟨s,out,hbind,by rw [he] at hbody; exact hbody⟩

theorem scalar_return (body : List CLogic.Stmt) (s out : B20.C.Scalar.State)
    (word : Val) (result : Ty) (fuel : Nat)
    (h : FprPrimitives.execBlock fuel result (body.map FprPrimitives.Instr.scalar) s=some (out,some word)) :
    CLogic.evalBody FprPrimitives.headerCalls result body s=some word := by
  induction body generalizing s fuel with
  | nil => cases fuel <;> simp [FprPrimitives.execBlock] at h
  | cons stmt rest ih =>
      cases fuel with
      | zero => simp [FprPrimitives.execBlock] at h
      | succ fuel =>
          cases stmt with
          | ret e =>
              obtain ⟨v,hv,hr⟩ := Option.bind_eq_some_iff.mp h
              have he : B20.C.cast result v=word := (Prod.mk.inj (Option.some.inj hr)).2 |> Option.some.inj
              simp [CLogic.evalBody,hv,he]
          | declare t ns | assign n e | update n op e =>
              obtain ⟨mid,hm,hr⟩ := Option.bind_eq_some_iff.mp h
              have hi := ih mid fuel hr
              dsimp only [FprPrimitives.execScalar] at hm
              simp [CLogic.evalBody,hm,hi]

theorem scalar_normal (body : List CLogic.Stmt) (s out : B20.C.Scalar.State)
    (result : Ty) (fuel : Nat)
    (h : FprPrimitives.execBlock fuel result (body.map FprPrimitives.Instr.scalar) s=some (out,none)) :
    UnsignedState.exec FprPrimitives.headerCalls s body=some out := by
  induction body generalizing s fuel with
  | nil =>
      cases fuel with
      | zero => simp [FprPrimitives.execBlock] at h
      | succ _ => exact congrArg (Option.map Prod.fst) h
  | cons stmt rest ih =>
      cases fuel with
      | zero => simp [FprPrimitives.execBlock] at h
      | succ fuel =>
          cases stmt with
          | ret e =>
              obtain ⟨v,_,hr⟩ := Option.bind_eq_some_iff.mp h
              have no := (Prod.mk.inj (Option.some.inj hr)).2
              cases no
          | declare t ns | assign n e | update n op e =>
              obtain ⟨mid,hm,hr⟩ := Option.bind_eq_some_iff.mp h
              have hi := ih mid fuel hr
              dsimp only [FprPrimitives.execScalar] at hm
              simp [UnsignedState.exec,hm,hi]

theorem scalar_execute (f : FprPrimitives.Function) (body : List CLogic.Stmt)
    (hs : f.body=body.map FprPrimitives.Instr.scalar) (args : List Val) (w : Val)
    (h : FprPrimitives.execute f args=some w) :
    CLogic.execute FprPrimitives.headerCalls ⟨f.name,f.result,f.params,body⟩ args=some w := by
  obtain ⟨s,out,hbind,hbody⟩ := execute_inv _ _ _ h
  rw [hs] at hbody
  have hscalar := scalar_return _ _ _ _ _ _ hbody
  simp [CLogic.execute,hbind,hscalar]

theorem prefix_inv (body : List CLogic.Stmt) (rest : List FprPrimitives.Instr)
    (s out : B20.C.Scalar.State) (ret : Option Val) (result : Ty) (fuel : Nat)
    (hn : ∀ e, CLogic.Stmt.ret e∉body)
    (h : FprPrimitives.execBlock (fuel+body.length) result
      (body.map FprPrimitives.Instr.scalar ++ rest) s=some (out,ret)) :
    ∃ mid, UnsignedState.exec FprPrimitives.headerCalls s body=some mid ∧
      FprPrimitives.execBlock fuel result rest mid=some (out,ret) := by
  induction body generalizing s with
  | nil => exact ⟨s,rfl,h⟩
  | cons stmt tail ih =>
      have hnTail : ∀ e, CLogic.Stmt.ret e∉tail := fun e he => hn e (List.mem_cons_of_mem stmt he)
      cases stmt with
      | ret e => exact False.elim (hn e (by simp))
      | declare t ns | assign n e | update n op e =>
          have hh := h
          simp only [List.length_cons,Nat.add_succ,List.map_cons,List.cons_append,FprPrimitives.execBlock] at hh
          obtain ⟨mid,hm,ht⟩ := Option.bind_eq_some_iff.mp hh
          obtain ⟨last,hl,hr⟩ := ih mid hnTail ht
          dsimp only [FprPrimitives.execScalar] at hm
          exact ⟨last,by simp [UnsignedState.exec,hm,hl],hr⟩

theorem prefix_sound (rc : C99ScalarReference.CallRelation) (env mid : C99ScalarReference.Env)
    (body : List CLogic.Stmt) (tail : C99ScalarReference.Stmt) (r : C99ScalarReference.Result)
    (hbody : C99ScalarReference.Exec rc env (C99Frontend.scalars body) (.normal mid))
    (htail : C99ScalarReference.Exec rc mid tail r) :
    C99ScalarReference.Exec rc env (C99PrefixBridge.withTail body tail) r := by
  induction body generalizing env with
  | nil =>
      have hm : mid=env := C99ScalarReference.Result.normal.inj (C99ControlInversion.skip_inv _ _ _ hbody)
      subst mid
      exact htail
  | cons stmt rest ih =>
      rcases C99ControlInversion.seq_inv _ _ _ _ _ hbody with ⟨inner,ha,hb⟩ | ⟨v,_,no⟩
      · exact C99ScalarReference.Exec.seqNormal _ _ _ _ _ ha (ih inner hb)
      · cases no

end FT1536.Source3.C99FprInversion

#print axioms FT1536.Source3.C99FprInversion.prefix_inv
