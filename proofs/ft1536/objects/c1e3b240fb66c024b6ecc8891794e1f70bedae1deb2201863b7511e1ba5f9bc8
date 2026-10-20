import Source3.C99ProcedureReference

/- An observation of the existing natural loop execution, not a new success
   oracle. Attempt lists are chronological; certificate event traces retain
   their existing newest-first convention. Instantiation with the complete
   KeyGen body, its gates and actual cap remains an enclosing obligation. -/
namespace FT1536.Source3.C99LoopTrace
open C99ArrayReference (State scalar)
open C99ProcedureReference

structure Attempt where
  entry : State
  exit : Result

def Accepted (attempt : Attempt) : Prop := attempt.exit.flow=.breakLoop
def Rejected (attempt : Attempt) : Prop := attempt.exit.flow=.continueLoop
def Resumes (attempt : Attempt) : Prop := attempt.exit.flow=.normal ∨ Rejected attempt
def Succeeded (result : Result) : Prop := result.flow=.normal

inductive Trace (program : Program) (condition : CLogic.Expr) (body increment : Stmt) :
    State → Result → List Attempt → Prop where
  | done (s : State) (v : Value) (guard : scalar s condition v) (zero : v.integer=0) :
      Trace program condition body increment s ⟨s,.normal⟩ []
  | normal (before middle next : State) (result : Result) (v : Value) (rest : List Attempt)
      (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program body before ⟨middle,.normal⟩)
      (update : Exec program increment middle ⟨next,.normal⟩)
      (tail : Trace program condition body increment next result rest) :
      Trace program condition body increment before result (⟨before,⟨middle,.normal⟩⟩::rest)
  | continued (before middle next : State) (result : Result) (v : Value) (rest : List Attempt)
      (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program body before ⟨middle,.continueLoop⟩)
      (update : Exec program increment middle ⟨next,.normal⟩)
      (tail : Trace program condition body increment next result rest) :
      Trace program condition body increment before result (⟨before,⟨middle,.continueLoop⟩⟩::rest)
  | accepted (before after : State) (v : Value)
      (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program body before ⟨after,.breakLoop⟩) :
      Trace program condition body increment before ⟨after,.normal⟩ [⟨before,⟨after,.breakLoop⟩⟩]
  | returned (before after : State) (v : Value) (value : Option Value)
      (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : Exec program body before ⟨after,.returned value⟩) :
      Trace program condition body increment before ⟨after,.returned value⟩ [⟨before,⟨after,.returned value⟩⟩]

theorem trace_execution (program : Program) (condition : CLogic.Expr) (body increment : Stmt)
    (before : State) (result : Result) (attempts : List Attempt)
    (trace : Trace program condition body increment before result attempts) :
    Exec program (.loop condition body increment) before result := by
  induction trace with
  | done s v guard zero => exact .loopFalse condition body increment s v guard zero
  | normal before middle next result v rest guard nonzero iteration update tail ih =>
      exact .loopNormal condition body increment before middle next result v guard nonzero iteration update ih
  | continued before middle next result v rest guard nonzero iteration update tail ih =>
      exact .loopContinue condition body increment before middle next result v guard nonzero iteration update ih
  | accepted before after v guard nonzero iteration =>
      exact .loopBreak condition body increment before after v guard nonzero iteration
  | returned before after v value guard nonzero iteration =>
      exact .loopReturn condition body increment before after v value guard nonzero iteration

theorem execution_trace (program : Program) (condition : CLogic.Expr) (body increment : Stmt)
    (code : Stmt) (before : State) (result : Result) (source : Exec program code before result)
    (shape : code=.loop condition body increment) :
    ∃ attempts, Trace program condition body increment before result attempts := by
  induction source with
  | base | seqNormal | seqExit | scope | branchTrue | branchFalse | returnVoid | returnValue |
    breakLoop | continueLoop | call => cases shape
  | loopFalse c b update before v guard zero =>
      cases shape
      exact ⟨[],.done before v guard zero⟩
  | loopNormal c b update before middle next result v guard nonzero iteration inc rest ih1 ih2 ih3 =>
      cases shape
      obtain ⟨attempts,h⟩ := ih3 rfl
      exact ⟨_,.normal before middle next result v attempts guard nonzero iteration inc h⟩
  | loopContinue c b update before middle next result v guard nonzero iteration inc rest ih1 ih2 ih3 =>
      cases shape
      obtain ⟨attempts,h⟩ := ih3 rfl
      exact ⟨_,.continued before middle next result v attempts guard nonzero iteration inc h⟩
  | loopBreak c b update before after v guard nonzero iteration ih =>
      cases shape
      exact ⟨_,.accepted before after v guard nonzero iteration⟩
  | loopReturn c b update before after v value guard nonzero iteration ih =>
      cases shape
      exact ⟨_,.returned before after v value guard nonzero iteration⟩

theorem trace_iff (program : Program) (condition : CLogic.Expr) (body increment : Stmt)
    (before : State) (result : Result) :
    Exec program (.loop condition body increment) before result ↔
      ∃ attempts, Trace program condition body increment before result attempts :=
  ⟨fun h => execution_trace program condition body increment _ before result h rfl,
   fun ⟨attempts,h⟩ => trace_execution program condition body increment before result attempts h⟩

theorem true_guard (before : State) (v : Value) (h : scalar before (.literal .i32 1) v) :
    v.integer=1 := by
  change C99ScalarReference.Eval _ _ (.literal .int32 1) v at h
  cases h
  rfl

theorem final_accepted_attempt (program : Program) (body increment : Stmt)
    (before : State) (result : Result) (attempts : List Attempt)
    (trace : Trace program (.literal .i32 1) body increment before result attempts)
    (success : Succeeded result) :
    ∃ previous final, attempts=previous++[final] ∧ Accepted final ∧
      (∀ attempt∈previous, Resumes attempt) := by
  induction trace with
  | done s v guard zero => have hv := true_guard s v guard; omega
  | normal before middle next result v rest guard nonzero iteration update tail ih =>
      obtain ⟨previous,final,he,hf,hp⟩ := ih success
      refine ⟨⟨before,⟨middle,.normal⟩⟩::previous,final,?_,hf,?_⟩
      · simp only [he,List.cons_append]
      · intro attempt ha
        rcases List.mem_cons.mp ha with rfl | ha
        · exact Or.inl rfl
        · exact hp attempt ha
  | continued before middle next result v rest guard nonzero iteration update tail ih =>
      obtain ⟨previous,final,he,hf,hp⟩ := ih success
      refine ⟨⟨before,⟨middle,.continueLoop⟩⟩::previous,final,?_,hf,?_⟩
      · simp only [he,List.cons_append]
      · intro attempt ha
        rcases List.mem_cons.mp ha with rfl | ha
        · exact Or.inr rfl
        · exact hp attempt ha
  | accepted => exact ⟨[],_,rfl,rfl,by simp⟩
  | returned => cases success

theorem resumed_not_accepted (attempt : Attempt) (h : Resumes attempt) : ¬Accepted attempt := by
  rcases h with h | h
  all_goals
    intro ha
    have he := h.symm.trans ha
    cases he

end FT1536.Source3.C99LoopTrace
