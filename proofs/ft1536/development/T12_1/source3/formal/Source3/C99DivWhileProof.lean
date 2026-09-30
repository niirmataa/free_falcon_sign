import Source3.C99DivLoopBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99DivWhileProof
open B20.C C99Typing C99DivLoopBridge

theorem while_inv (rc : C99ScalarReference.CallRelation) (env : C99ScalarReference.Env)
    (cond : C99ScalarReference.Expr) (body : C99ScalarReference.Stmt) (r : C99ScalarReference.Result)
    (h : C99ScalarReference.Exec rc env (.while cond body) r) :
    (∃ v, C99ScalarReference.Eval rc env cond v ∧ v.integer=0 ∧ r=.normal env) ∨
    (∃ v mid, C99ScalarReference.Eval rc env cond v ∧ v.integer≠0 ∧
      C99ScalarReference.Exec rc env body (.normal mid) ∧
      C99ScalarReference.Exec rc mid (.while cond body) r) ∨
    (∃ v z, C99ScalarReference.Eval rc env cond v ∧ v.integer≠0 ∧
      C99ScalarReference.Exec rc env body (.returned z) ∧ r=.returned z) := by
  cases h
  · exact Or.inl ⟨_,by assumption,by assumption,rfl⟩
  · exact Or.inr (Or.inl ⟨_,_,by assumption,by assumption,by assumption,by assumption⟩)
  · exact Or.inr (Or.inr ⟨_,_,by assumption,by assumption,by assumption,rfl⟩)

def repeatStep : Nat → B20.C.Scalar.State → Option B20.C.Scalar.State
  | 0,s => some s
  | n+1,s => (FprDivLoopTotal.oneStep s).bind (repeatStep n)

theorem fold_length (xs : List Nat) (s : B20.C.Scalar.State) :
    xs.foldlM (fun acc _ => FprDivLoopTotal.oneStep acc) s=repeatStep xs.length s := by
  induction xs generalizing s with
  | nil => rfl
  | cons x tail ih => simp [List.foldlM_cons,repeatStep,ih]

theorem while_complete : ∀ (remaining i : Nat) (s : B20.C.Scalar.State) (r : C99ScalarReference.Result),
    i+remaining=55 → FprDivLoopTotal.Inv s i → WellTyped s →
    C99ScalarReference.Exec C99Frontend.headerCalls (environment s) (.while condition iteration) r →
    ∃ out, repeatStep remaining s=some out ∧ r=.normal (environment out) ∧
      WellTyped out ∧ FprDivLoopTotal.Inv out 55 := by
  intro remaining
  induction remaining with
  | zero =>
      intro i s r hi inv hg hs
      have hieq : i=55 := by omega
      subst i
      rcases while_inv _ _ _ _ _ hs with ⟨v,hv,hz,hr⟩ | ⟨v,mid,hv,hn,_,_⟩ | ⟨v,z,hv,hn,_,_⟩
      · exact ⟨s,rfl,hr,hg,inv⟩
      · have hlt := (condition_value s 55 (by omega) inv hg v hv).mp hn
        omega
      · have hlt := (condition_value s 55 (by omega) inv hg v hv).mp hn
        omega
  | succ remaining ih =>
      intro i s r hi inv hg hs
      have hil : i<55 := by omega
      rcases while_inv _ _ _ _ _ hs with ⟨v,hv,hz,hr⟩ | ⟨v,mid,hv,hn,hiter,hrest⟩ | ⟨v,z,hv,hn,hiter,hr⟩
      · have hne := (condition_value s i (by omega) inv hg v hv).mpr hil
        exact False.elim (hne hz)
      · obtain ⟨next,hnext,henv,hgn,invn⟩ := iteration_complete s i hil inv hg (.normal mid) hiter
        have heq : mid=environment next := C99ScalarReference.Result.normal.inj henv
        subst mid
        obtain ⟨out,ho,hr,hgo,invo⟩ := ih (i+1) next r (by omega) invn hgn hrest
        exact ⟨out,by simp [repeatStep,hnext,ho],hr,hgo,invo⟩
      · obtain ⟨_,_,hbad,_,_⟩ := iteration_complete s i hil inv hg (.returned z) hiter
        cases hbad

theorem all_55_reference_iterations (s : B20.C.Scalar.State) (r : C99ScalarReference.Result)
    (inv : FprDivLoopTotal.Inv s 0) (hg : WellTyped s)
    (hs : C99ScalarReference.Exec C99Frontend.headerCalls (environment s) (.while condition iteration) r) :
    ∃ out, (List.range 55).foldlM (fun acc _ => FprDivLoopTotal.oneStep acc) s=some out ∧
      r=.normal (environment out) ∧ WellTyped out ∧ FprDivLoopTotal.Inv out 55 := by
  obtain ⟨out,ho,hr,hgo,invo⟩ := while_complete 55 0 s r (by omega) inv hg hs
  exact ⟨out,by rw [fold_length,List.length_range]; exact ho,hr,hgo,invo⟩

end FT1536.Source3.C99DivWhileProof

#check @FT1536.Source3.C99DivWhileProof.all_55_reference_iterations
#print axioms FT1536.Source3.C99DivWhileProof.all_55_reference_iterations
