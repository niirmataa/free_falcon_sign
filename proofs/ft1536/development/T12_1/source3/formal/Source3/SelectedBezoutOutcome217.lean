import Source3.SelectedBezoutReject217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Both source outcomes remain conditional on the same selected symbolic guard. -/
namespace FT1536.Source3.SelectedBezoutOutcome217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open ZintNormWalkFlat208 (Data)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutReject217 (rootAfter)

theorem good_constraints (F G : Nat → BitVec 32) (good : bad F G=false) :
    ExactLengthProgram217.highest (X F G) 335≠0 ∧
    ExactLengthProgram217.highest (Y F G) 335≠0 ∧
    (C99IntegerReference.Value.uint32 (BezoutGuardOps217.andWord (BezoutGuardOps217.andWord (X F G 0) (Y F G 0)) 1)).integer≠0 := by
  simpa [SelectedBezoutGuard217.bad,BezoutGuard217.bad,and_assoc] using good

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    Data made fd 335 F ∧ Data made gd 335 G ∧
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=true →
      KeygenDeepestSource.Call env.ctx SelectedDeepestEntry175.caller (rootAfter rebuilt) (.int32 0) ∧
      KeygenRootSearch.Exec env.ctx SelectedRootStart175.entry ⟨rootAfter rebuilt,.returned (some (.int32 0))⟩) ∧
    (bad F G=false → KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G) ⟨state rebuilt F G,.normal⟩) ∧
    Data (state rebuilt F G) fd 335 (X F G) ∧ Data (state rebuilt F G) gd 335 (Y F G) := by
  obtain ⟨made,rebuilt,F,G,part2,fdata,gdata,crt,binding,pre,lengths,guard,xf,yf⟩:=SelectedBezoutGuard217.selected
  refine ⟨made,rebuilt,F,G,fdata,gdata,part2,crt,?_,?_,xf,yf⟩
  · exact SelectedBezoutReject217.consequence made rebuilt F G part2 crt binding pre lengths guard
  · intro good
    simpa only [good,Bool.false_eq_true,ite_false] using guard

end FT1536.Source3.SelectedBezoutOutcome217
