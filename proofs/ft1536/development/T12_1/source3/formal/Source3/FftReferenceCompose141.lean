import Source3.FftMiddleShape139
import Source3.C99Chain139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftReferenceCompose141
open C99ArrayReference (State restoreScope)
open C99ProcedureReference (Exec)
open FftMiddleShape139

theorem group (before declared initialized after : State)
    (prologue : Exec KeygenSearchFft.program groupPrologue before ⟨declared,.normal⟩)
    (initialization : Exec KeygenSearchFft.program butterflyInitial declared ⟨initialized,.normal⟩)
    (loop : Exec KeygenSearchFft.program butterflyLoop initialized ⟨after,.normal⟩) :
    Exec KeygenSearchFft.program groupBody before
      ⟨restoreScope before after (scopeLocals groupBody) (scopePointers groupBody),.normal⟩ := by
  rw [group_body_shape]
  refine .scope _ _ _ before ⟨after,.normal⟩ ?_
  apply C99Chain139.append _ _ _ before declared _ prologue
  exact .seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ initialization loop) (.base _ _ _ (.skip _))

theorem outer (before declared initialized groups after : State)
    (prologue : Exec KeygenSearchFft.program outerPrologue before ⟨declared,.normal⟩)
    (initialization : Exec KeygenSearchFft.program groupInitial declared ⟨initialized,.normal⟩)
    (loop : Exec KeygenSearchFft.program groupLoop initialized ⟨groups,.normal⟩)
    (update : Exec KeygenSearchFft.program setTNext groups ⟨after,.normal⟩) :
    Exec KeygenSearchFft.program outerBody before
      ⟨restoreScope before after (scopeLocals outerBody) (scopePointers outerBody),.normal⟩ := by
  rw [outer_body_shape]
  refine .scope _ _ _ before ⟨after,.normal⟩ ?_
  apply C99Chain139.append _ _ _ before declared _ prologue
  exact .seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ initialization loop)
    (.seqNormal _ _ _ _ _ update (.base _ _ _ (.skip _)))

end FT1536.Source3.FftReferenceCompose141
