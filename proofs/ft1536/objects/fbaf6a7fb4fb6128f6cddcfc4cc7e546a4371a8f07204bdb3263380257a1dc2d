import Source3.C99ProcedureReference

namespace FT1536.Source3.C99ProcedureSequence
open C99ArrayReference (Name Arg State)
open C99ProcedureReference

def callsThen : List (Name×List Arg) → Stmt → Stmt
  | [],tail => tail
  | (name,args)::calls,tail => .seq (.call name args .discard) (callsThen calls tail)

theorem discard_call_bindings (program : Program) (name : Name) (args : List Arg)
    (before : State) (result : Result) (h : Exec program (.call name args .discard) before result) :
    result.flow=.normal ∧ result.state.locals=before.locals ∧ result.state.arrays=before.arrays := by
  cases h with
  | call name args destination f before entry after result returned source parameters body conversion receive =>
      cases receive
      exact ⟨rfl,rfl,rfl⟩

theorem calls_before_tail (program : Program) (calls : List (Name×List Arg))
    (tail : Stmt) (before : State) (result : Result)
    (h : Exec program (callsThen calls tail) before result) :
    ∃ middle, middle.locals=before.locals ∧ middle.arrays=before.arrays ∧
      C99InitializationTrace.Steps before.heap middle.heap ∧ Exec program tail middle result := by
  induction calls generalizing before with
  | nil => exact ⟨before,rfl,rfl,.done _,h⟩
  | cons call calls ih =>
      obtain ⟨name,args⟩ := call
      cases h with
      | seqNormal a b before middle result first second =>
          have hb := discard_call_bindings program name args before ⟨middle,.normal⟩ first
          obtain ⟨next,hl,ha,hs,ht⟩ := ih middle second
          exact ⟨next,hl.trans hb.2.1,ha.trans hb.2.2,
            C99InitializationTrace.steps_trans _ _ _ (memory_steps _ _ _ _ first) hs,ht⟩
      | seqExit a b before result first exit =>
          exact False.elim (exit (discard_call_bindings program name args before result first).1)

theorem base_before_tail (program : Program) (base : C99ArrayReference.Stmt)
    (tail : Stmt) (before : State) (result : Result)
    (h : Exec program (.seq (.base base) tail) before result) :
    ∃ middle, C99ArrayReference.Exec FftLeafPrograms.program base before middle ∧
      Exec program tail middle result := by
  cases h with
  | seqNormal a b before middle result first second =>
      cases first with
      | base _ _ _ execution => exact ⟨middle,execution,second⟩
  | seqExit a b before result first exit =>
      cases first
      exact False.elim (exit rfl)

end FT1536.Source3.C99ProcedureSequence
