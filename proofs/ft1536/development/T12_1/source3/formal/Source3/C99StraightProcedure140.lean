import Source3.C99StraightArray140
import Source3.C99ProcedureRun138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99StraightProcedure140
open C99CompactState115 (State reference)
open C99ProcedureReference (Stmt Exec Program)

/-- Source-certified composition stages fixed AST dispatch out of execution.
    Atomic arithmetic, memory guards and all scope restoration are retained. -/
structure Certificate where
  code : Stmt
  run : B20.C.Scalar.Calls → State → Option State
  source : ∀ (program : Program) (calls : B20.C.Scalar.Calls),
    C99ExpressionSound.CallsSound FprPrefixCalls.calls calls →
    ∀ before after, run calls before=some after →
      Exec program code (reference before) ⟨reference after,.normal⟩

def base (inner : C99StraightArray140.Certificate) : Certificate where
  code := .base inner.code
  run := inner.run
  source := by
    intro program calls valid before after checked
    exact .base _ _ _ (inner.source FftLeafPrograms.program calls valid before after checked)

def seq (first second : Certificate) : Certificate where
  code := .seq first.code second.code
  run := fun calls before => (first.run calls before).bind (second.run calls)
  source := by
    intro program calls valid before after checked
    obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp checked
    exact .seqNormal _ _ _ _ _ (first.source program calls valid before middle head)
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
    exact .scope _ _ _ _ ⟨reference middle,.normal⟩ (inner.source program calls valid before middle body)

end FT1536.Source3.C99StraightProcedure140
