import Source3.C99BodySound
import Source3.C99HeaderSignature

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99HeaderSound
open B20.C C99Typing C99StateBridge C99ValueBridge C99ExpressionSound

theorem bind_sound (ps : List (Ty × Name)) (args : List Val) (s : B20.C.Scalar.State)
    (h : B20.C.Scalar.bindArgs ps args=some s) :
    C99ScalarReference.BindArgs (ps.map (fun (t,n) => (type t,n))) (args.map value) (environment s) ∧
      WellTyped s := by
  induction ps generalizing args s with
  | nil =>
      cases args with
      | nil =>
          have he : s=B20.C.Scalar.emptyState := (Option.some.inj h).symm
          subst s
          refine ⟨C99ScalarReference.BindArgs.nil,?_⟩
          intro n v hv
          simp [B20.C.Scalar.emptyState] at hv
      | cons _ _ => simp [B20.C.Scalar.bindArgs] at h
  | cons p rest ih =>
      rcases p with ⟨t,n⟩
      cases args with
      | nil => simp [B20.C.Scalar.bindArgs] at h
      | cons a tail =>
          obtain ⟨st,ht,hd⟩ := Option.bind_eq_some_iff.mp h
          obtain ⟨decl,hdecl,ha⟩ := Option.bind_eq_some_iff.mp hd
          obtain ⟨hr,hg⟩ := ih tail st ht
          have hfresh : st.types n=none := by
            cases hh : st.types n with
            | none => rfl
            | some _ => simp [B20.C.Scalar.declareOne,hh] at hdecl
          have heq : decl={st with types := fun m => if m=n then some t else st.types m} :=
            (Option.some.inj (by simpa [B20.C.Scalar.declareOne,hfresh] using hdecl)).symm
          subst decl
          have hout : s=⟨(fun m => if m=n then some t else st.types m), update st.values n (B20.C.cast t a)⟩ :=
            (Option.some.inj (by simpa [B20.C.Scalar.assign] using ha)).symm
          subst s
          have he := assigned_environment
            {st with types := fun m => if m=n then some t else st.types m} n (value a) t (by simp)
          rw [encode_value,declared_environment st n t hg hfresh] at he
          have hs : C99ScalarReference.set (C99ScalarReference.set (environment st) n (type t,none)) n
              (type t,some (C99IntegerReference.convert (type t) (value a).integer))=
              C99ScalarReference.set (environment st) n
                (type t,some (C99IntegerReference.convert (type t) (value a).integer)) := by
            funext m
            by_cases hm : m=n <;> simp [C99ScalarReference.set,hm]
          refine ⟨?_,assigned_good _ n a t (declared_good st n t hg hfresh) (by simp)⟩
          rw [he,hs]
          exact C99ScalarReference.BindArgs.cons _ _ _ _ _ _ hr

theorem function_sound (sig : Types) (rc : C99ScalarReference.CallRelation)
    (mc : B20.C.Scalar.Calls) (hcall : CallsSound rc mc)
    (f : CLogic.Function) (args : List Val) (word : Val)
    (hc : C99HeaderProof.checked sig f=true) (h : CLogic.execute mc f args=some word) :
    C99ScalarReference.FunctionExec rc (C99Frontend.headerFunction f) (args.map value) (value word) := by
  obtain ⟨s,hbind,hbody⟩ := Option.bind_eq_some_iff.mp h
  obtain ⟨hp,hg⟩ := bind_sound f.params args s hbind
  obtain ⟨outTypes,hchecks⟩ := Option.isSome_iff_exists.mp hc
  obtain ⟨ctx,hctx,hbodyCheck⟩ := Option.bind_eq_some_iff.mp hchecks
  obtain ⟨other,ho,_,ht,_⟩ := C99ParametersBridge.bind_complete f.params args (environment s) ctx hctx hp
  have heq : other=s := Option.some.inj (ho.symm.trans hbind)
  subst other
  obtain ⟨v,hv,hword⟩ := C99BodySound.return_sound sig rc mc hcall f.body f.result s outTypes word hg
    (by rw [ht]; exact hbodyCheck) hbody
  rw [hword,cast_matches,value_encode]
  exact C99ScalarReference.FunctionExec.call _ _ _ hp hv

theorem no_calls_sound : CallsSound C99Frontend.noCalls (fun _ _ => none) := by
  intro n args v h
  contradiction

theorem header_sound : CallsSound C99Frontend.headerCalls FprPrimitives.headerCalls := by
  intro name args v h
  by_cases hu : name=['f','p','r','_','u','r','s','h']
  · subst name
    have he : CLogic.execute (fun _ _ => none) FprAST.urshCode args=some v := by
      simpa [FprPrimitives.headerCalls,FprAST.ursh_binding] using h
    exact ⟨_,by simp [C99Frontend.lookup],function_sound _ _ _ no_calls_sound _ _ _ C99HeaderProof.ursh_checked he⟩
  · by_cases hl : name=['f','p','r','_','u','l','s','h']
    · subst name
      have he : CLogic.execute (fun _ _ => none) FprAST.ulshCode args=some v := by
        simpa [FprPrimitives.headerCalls,FprAST.ulsh_binding] using h
      exact ⟨_,by simp [C99Frontend.lookup],function_sound _ _ _ no_calls_sound _ _ _ C99HeaderProof.ulsh_checked he⟩
    · by_cases hp : name=['F','P','R']
      · subst name
        have he : CLogic.execute (fun _ _ => none) FprAST.packCode args=some v := by
          simpa [FprPrimitives.headerCalls,FprAST.pack_binding] using h
        exact ⟨_,by simp [C99Frontend.lookup],function_sound _ _ _ no_calls_sound _ _ _ C99HeaderProof.pack_checked he⟩
      · simp [FprPrimitives.headerCalls,hu,hl,hp] at h

end FT1536.Source3.C99HeaderSound

#print axioms FT1536.Source3.C99HeaderSound.header_sound
