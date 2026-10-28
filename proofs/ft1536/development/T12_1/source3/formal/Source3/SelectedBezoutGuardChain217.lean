import Source3.SelectedBezoutGuard217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedBezoutGuardChain217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open ZintNormWalkFlat208 (Data)
open SelectedBezoutGuard217 (state bad X Y)

def code : KeygenZintCall.Stmt := .seq SelectedBezoutPrefix217.prefixCode
  (.seq (KeygenZintCall.bezoutPart 2) (KeygenZintCall.bezoutPart 3))

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    Data made fd 335 F ∧ Data made gd 335 G ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    C99ArrayReference.Bind rebuilt (KeygenZintCall.params .bezout) DeepestBezoutEntry217.args (DeepestBezoutEntry217.entry rebuilt) ∧
    KeygenZintCall.Exec code (DeepestBezoutEntry217.entry rebuilt)
      ⟨state rebuilt F G,if bad F G then .returned (some (.int32 0)) else .normal⟩ ∧
    Data (state rebuilt F G) fd 335 (X F G) ∧ Data (state rebuilt F G) gd 335 (Y F G) := by
  obtain ⟨made,rebuilt,F,G,part2,fdata,gdata,crt,binding,pre,lengths,guard,xf,yf⟩:=SelectedBezoutGuard217.selected
  have chain : KeygenZintCall.Exec code (DeepestBezoutEntry217.entry rebuilt)
      ⟨state rebuilt F G,if bad F G then .returned (some (.int32 0)) else .normal⟩ :=
    .seqNormal _ _ _ _ _ pre (.seqNormal _ _ _ _ _ lengths guard)
  exact ⟨made,rebuilt,F,G,part2,fdata,gdata,crt,binding,chain,xf,yf⟩

end FT1536.Source3.SelectedBezoutGuardChain217
