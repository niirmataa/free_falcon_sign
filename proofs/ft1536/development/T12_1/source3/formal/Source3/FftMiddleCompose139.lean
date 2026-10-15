import Source3.FftMiddleShape139
import Source3.C99Chain139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMiddleCompose139
open C99CompactState115 (State reference restoreScope)
open C99ProcedureReference (Exec)
open FftMiddleShape139

/-- Close exactly one original group scope after its entire inner loop. -/
theorem group (before declared initialized after : State)
    (prologue : Exec KeygenSearchFft.program groupPrologue (reference before) ⟨reference declared,.normal⟩)
    (initialization : Exec KeygenSearchFft.program butterflyInitial (reference declared) ⟨reference initialized,.normal⟩)
    (loop : Exec KeygenSearchFft.program butterflyLoop (reference initialized) ⟨reference after,.normal⟩) :
    Exec KeygenSearchFft.program groupBody (reference before)
      ⟨reference (restoreScope before after (scopeLocals groupBody) (scopePointers groupBody)),.normal⟩ := by
  rw [group_body_shape,C99CompactState115.reference_restoreScope]
  refine Exec.scope _ _ _ (reference before) ⟨reference after,.normal⟩ ?_
  apply C99Chain139.append _ _ _ _ (reference declared) _ prologue
  exact .seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ initialization loop) (.base _ _ _ (.skip _))

/-- Close exactly one original outer scope after every group and t=ht. -/
theorem outer (before declared initialized groups after : State)
    (prologue : Exec KeygenSearchFft.program outerPrologue (reference before) ⟨reference declared,.normal⟩)
    (initialization : Exec KeygenSearchFft.program groupInitial (reference declared) ⟨reference initialized,.normal⟩)
    (loop : Exec KeygenSearchFft.program groupLoop (reference initialized) ⟨reference groups,.normal⟩)
    (update : Exec KeygenSearchFft.program setTNext (reference groups) ⟨reference after,.normal⟩) :
    Exec KeygenSearchFft.program outerBody (reference before)
      ⟨reference (restoreScope before after (scopeLocals outerBody) (scopePointers outerBody)),.normal⟩ := by
  rw [outer_body_shape,C99CompactState115.reference_restoreScope]
  refine Exec.scope _ _ _ (reference before) ⟨reference after,.normal⟩ ?_
  apply C99Chain139.append _ _ _ _ (reference declared) _ prologue
  exact .seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ initialization loop)
    (.seqNormal _ _ _ _ _ update (.base _ _ _ (.skip _)))

end FT1536.Source3.FftMiddleCompose139
