import Source3.C99ArrayRun138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99StraightArray140
open C99CompactState115 (State reference)
open C99ArrayReference (Stmt Exec Program)

/-- A fixed straight-line source fragment and its executable checked action. -/
structure Certificate where
  code : Stmt
  run : B20.C.Scalar.Calls → State → Option State
  source : ∀ (program : Program) (calls : B20.C.Scalar.Calls),
    C99ExpressionSound.CallsSound FprPrefixCalls.calls calls →
    ∀ before after, run calls before=some after → Exec program code (reference before) (reference after)

def atom (code : Stmt) : Certificate where
  code := code
  run := fun calls before => C99ArraySteps136.step calls before code
  source := fun program calls valid before after checked =>
    C99ArraySteps136.step_sound program calls valid before after code checked

def seq (first second : Certificate) : Certificate where
  code := .seq first.code second.code
  run := fun calls before => (first.run calls before).bind (second.run calls)
  source := by
    intro program calls valid before after checked
    obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp checked
    exact .seq _ _ _ _ _ (first.source program calls valid before middle head)
      (second.source program calls valid middle after tail)

def scopedBlock (locals pointers : List C99ArrayReference.Name) (inner : Certificate) : Certificate where
  code := .scope locals pointers inner.code
  run := fun calls before => (inner.run calls before).map
    (fun after => C99CompactState115.restoreScope before after locals pointers)
  source := by
    intro program calls valid before after checked
    obtain ⟨middle,body,same⟩ := Option.map_eq_some_iff.mp checked
    subst after
    rw [C99CompactState115.reference_restoreScope]
    exact .scope _ _ _ _ _ (inner.source program calls valid before middle body)

end FT1536.Source3.C99StraightArray140
