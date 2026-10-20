import Source3.C99ExpressionSound
import Source3.C99StatementBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99StateSound
open B20.C C99Typing C99StateBridge C99ValueBridge C99ExpressionSound

theorem declare_one_sound (rc : C99ScalarReference.CallRelation) (s out : B20.C.Scalar.State)
    (name : Name) (t : Ty) (hg : WellTyped s)
    (h : B20.C.Scalar.declareOne s t name=some out) :
    C99ScalarReference.Exec rc (environment s) (.declare (type t) name) (.normal (environment out)) ∧
      WellTyped out := by
  have hn : s.types name=none := by
    cases hs : s.types name with
    | none => rfl
    | some ty => simp [B20.C.Scalar.declareOne,hs] at h
  have heq : out={s with types := fun n => if n=name then some t else s.types n} := by
    exact (Option.some.inj (by simpa [B20.C.Scalar.declareOne,hn] using h)).symm
  subst out
  refine ⟨?_,declared_good s name t hg hn⟩
  rw [declared_environment s name t hg hn]
  exact C99ScalarReference.Exec.declare _ _ _

theorem declarations_sound (rc : C99ScalarReference.CallRelation) (s out : B20.C.Scalar.State)
    (names : List Name) (t : Ty) (hg : WellTyped s)
    (h : B20.C.Scalar.declareMany s t names=some out) :
    C99ScalarReference.Exec rc (environment s) (C99Frontend.declarations (type t) names)
      (.normal (environment out)) ∧ WellTyped out := by
  induction names generalizing s with
  | nil =>
      have he : s=out := Option.some.inj h
      subst out
      exact ⟨C99ScalarReference.Exec.skip _,hg⟩
  | cons name tail ih =>
      obtain ⟨mid,hm,ho⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨hr,hgm⟩ := declare_one_sound rc s mid name t hg hm
      obtain ⟨ht,hgo⟩ := ih mid hgm ho
      exact ⟨C99ScalarReference.Exec.seqNormal _ _ _ _ _ hr ht,hgo⟩

theorem assign_sound (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (hcall : CallsSound rc mc) (s out : B20.C.Scalar.State) (name : Name) (e : CLogic.Expr)
    (hg : WellTyped s) (hd : ExpressionFuel.depth e≤32)
    (h : CLogic.step mc s (.assign name e)=some out) :
    C99ScalarReference.Exec rc (environment s) (C99Frontend.scalar (.assign name e))
      (.normal (environment out)) ∧ WellTyped out := by
  obtain ⟨v,hv,ha⟩ := Option.bind_eq_some_iff.mp h
  obtain ⟨t,ht,heq⟩ := Option.bind_eq_some_iff.mp ha
  have ho : out={s with values := B20.C.update s.values name (B20.C.cast t v)} := (Option.some.inj heq).symm
  subst out
  have hu : ExpressionFuel.unbounded mc s.values e=some v := by
    rw [← ExpressionFuel.fuel_adequate _ _ _ _ hd]
    exact hv
  have hr := expression_sound rc mc hcall s hg e v hu
  have hev : environment {s with values := B20.C.update s.values name (B20.C.cast t v)}=
      C99ScalarReference.set (environment s) name
        (type t,some (C99IntegerReference.convert (type t) (value v).integer)) := by
    simpa only [encode_value] using assigned_environment s name (value v) t ht
  refine ⟨?_,assigned_good s name v t hg ht⟩
  rw [hev]
  exact C99ScalarReference.Exec.assign (environment s) name (C99Frontend.expression e) (type t)
    ((s.values name).map value) (value v) (by simp [environment,ht]) hr

theorem step_sound (sig : Types) (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (hcall : CallsSound rc mc) (s out : B20.C.Scalar.State) (stmt : CLogic.Stmt) (ctx : Types)
    (hg : WellTyped s) (hc : check sig s.types stmt=some ctx)
    (h : CLogic.step mc s stmt=some out) :
    C99ScalarReference.Exec rc (environment s) (C99Frontend.scalar stmt) (.normal (environment out)) ∧
      WellTyped out ∧ out.types=ctx := by
  cases stmt with
  | declare t ns =>
      obtain ⟨hr,hgo⟩ := declarations_sound rc s out ns t hg h
      obtain ⟨other,ho,_,ht,_⟩ := C99DeclarationsBridge.declarations_complete rc s t ns ctx
        (.normal (environment out)) hg hc hr
      have heq : other=out := Option.some.inj (ho.symm.trans h)
      subst other
      exact ⟨hr,hgo,ht⟩
  | assign name e =>
      have cond : (s.types name).isSome=true ∧ expressionCheck sig s.types e=true := by
        by_cases hh : (s.types name).isSome && expressionCheck sig s.types e
        · exact (Bool.and_eq_true _ _).mp hh
        · simp [check,hh] at hc
      obtain ⟨_,_,hd⟩ := expression_check _ _ _ cond.2
      obtain ⟨hr,hgo⟩ := assign_sound rc mc hcall s out name e hg hd h
      have htypes : out.types=s.types := by
        obtain ⟨v,_,ha⟩ := Option.bind_eq_some_iff.mp h
        obtain ⟨t,_,heq⟩ := Option.bind_eq_some_iff.mp ha
        exact (congrArg B20.C.Scalar.State.types (Option.some.inj heq)).symm
      exact ⟨hr,hgo,htypes.trans (by simpa [check,cond.1,cond.2] using hc)⟩
  | update name op e =>
      have cond : (s.types name).isSome=true ∧ expressionCheck sig s.types (.bin op (.var name) e)=true := by
        by_cases hh : (s.types name).isSome && expressionCheck sig s.types (.bin op (.var name) e)
        · exact (Bool.and_eq_true _ _).mp hh
        · simp [check,hh] at hc
      obtain ⟨_,_,hd⟩ := expression_check _ _ _ cond.2
      have h31 : ExpressionFuel.depth e≤31 := by simp only [ExpressionFuel.depth] at hd; omega
      have he31 := ExpressionFuel.fuel_adequate mc s.values e 31 h31
      have he32 := ExpressionFuel.fuel_adequate mc s.values e 32 (by omega)
      have hassign : CLogic.step mc s (.assign name (.bin op (.var name) e))=some out := by
        simpa [CLogic.step,CLogic.eval,he31,he32,Option.bind_assoc] using h
      obtain ⟨hr,hgo⟩ := assign_sound rc mc hcall s out name (.bin op (.var name) e) hg hd hassign
      have htypes : out.types=s.types := by
        obtain ⟨v,_,ha⟩ := Option.bind_eq_some_iff.mp hassign
        obtain ⟨t,_,heq⟩ := Option.bind_eq_some_iff.mp ha
        exact (congrArg B20.C.Scalar.State.types (Option.some.inj heq)).symm
      exact ⟨hr,hgo,htypes.trans (by simpa [check,cond.1,cond.2] using hc)⟩
  | ret _ => simp [CLogic.step] at h

end FT1536.Source3.C99StateSound

#print axioms FT1536.Source3.C99StateSound.step_sound
