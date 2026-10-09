import Source3.KeygenPublicLinear

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A proved projection of the scalar-only control fragment, including real
   loops and scope restoration. Array operations and calls are not lowered. -/
namespace FT1536.Source3.KeygenPublicScalarControl
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Stmt GenExec)
open KeygenPublicLinear (ScalarFlow observation)

def lower : Stmt → Option C99ScalarReference.Stmt
  | .base .skip => some .skip
  | .base (.scalar s) => some (C99Frontend.scalar s)
  | .assign n (.scalar e) => some (.assign n (C99Frontend.expression e))
  | .ret (.scalar e) => some (.ret (C99Frontend.expression e))
  | .seq a b => do pure (.seq (← lower a) (← lower b))
  | .scope ns b => do pure (.block ns (← lower b))
  | .loop e b i => do pure (.while (C99Frontend.expression e) (.seq (← lower b) (← lower i)))
  | _ => none

theorem projection (calls : C99ModularReference.CallRelation)
    (code : Stmt) (before : State) (out : Result) (target : C99ScalarReference.Stmt)
    (source : GenExec calls code before out) (shape : lower code=some target) :
    ScalarFlow out ∧ C99ScalarReference.Exec FprPrefixCalls.calls before.locals target (observation out) := by
  induction source generalizing target with
  | base code before after execution =>
      cases code <;> simp only [lower] at shape
      case skip =>
        cases shape
        cases execution
        exact ⟨Or.inl rfl,.skip _⟩
      case scalar s =>
        cases shape
        cases execution
        exact ⟨Or.inl rfl,‹_›⟩
      all_goals cases shape
  | assign n e before ty old v slot evaluated =>
      cases e <;> simp only [lower] at shape
      case scalar e =>
        cases shape
        cases evaluated
        exact ⟨Or.inl rfl,.assign _ _ _ _ _ _ slot ‹_›⟩
      all_goals cases shape
  | ret e before v evaluated =>
      cases e <;> simp only [lower] at shape
      case scalar e =>
        cases shape
        cases evaluated
        exact ⟨Or.inr ⟨v,rfl⟩,.ret _ _ _ ‹_›⟩
      all_goals cases shape
  | seqNormal a b before middle result first rest ih1 ih2 =>
      obtain ⟨ta,ha,hr⟩ := Option.bind_eq_some_iff.mp shape
      obtain ⟨tb,hb,ht⟩ := Option.bind_eq_some_iff.mp hr
      cases ht
      exact ⟨(ih2 _ hb).1,.seqNormal _ _ _ _ _ (ih1 _ ha).2 (ih2 _ hb).2⟩
  | seqExit a b before result first exit ih =>
      obtain ⟨ta,ha,hr⟩ := Option.bind_eq_some_iff.mp shape
      obtain ⟨tb,_,ht⟩ := Option.bind_eq_some_iff.mp hr
      cases ht
      obtain ⟨flow,execution⟩ := ih _ ha
      rcases flow with normal | ⟨v,returned⟩
      · exact (exit normal).elim
      · refine ⟨Or.inr ⟨v,returned⟩,?_⟩
        rw [observation,returned] at execution ⊢
        exact .seqReturn _ _ _ _ execution
  | scope names body before result inner ih =>
      obtain ⟨tb,hb,ht⟩ := Option.bind_eq_some_iff.mp shape
      cases ht
      obtain ⟨flow,execution⟩ := ih _ hb
      rcases flow with normal | ⟨v,returned⟩
      · refine ⟨Or.inl normal,?_⟩
        simp only [observation,normal] at execution
        simpa only [observation,normal,C99ArrayReference.restoreScope] using
          C99ScalarReference.Exec.blockNormal _ _ names _ execution
      · refine ⟨Or.inr ⟨v,returned⟩,?_⟩
        rw [observation,returned] at execution ⊢
        exact .blockReturn _ names _ _ execution
  | loopFalse condition body increment before v guard zero =>
      obtain ⟨tb,_,hr⟩ := Option.bind_eq_some_iff.mp shape
      obtain ⟨ti,_,ht⟩ := Option.bind_eq_some_iff.mp hr
      cases ht
      exact ⟨Or.inl rfl,.whileFalse _ _ _ _ guard zero⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      obtain ⟨tb,hb,hr⟩ := Option.bind_eq_some_iff.mp shape
      obtain ⟨ti,hi,ht⟩ := Option.bind_eq_some_iff.mp hr
      cases ht
      exact ⟨(ih3 _ shape).1,.whileTrue _ _ _ _ _ _ guard nonzero
        (.seqNormal _ _ _ _ _ (ih1 _ hb).2 (ih2 _ hi).2) (ih3 _ shape).2⟩
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      obtain ⟨tb,hb,hr⟩ := Option.bind_eq_some_iff.mp shape
      obtain ⟨ti,_,ht⟩ := Option.bind_eq_some_iff.mp hr
      cases ht
      exact ⟨Or.inr ⟨value,rfl⟩,.whileReturn _ _ _ _ _ guard nonzero
        (.seqReturn _ _ _ _ (ih _ hb).2)⟩
  | store32 | storeRev | branchTrue | branchFalse | retVoid => cases shape

end FT1536.Source3.KeygenPublicScalarControl
