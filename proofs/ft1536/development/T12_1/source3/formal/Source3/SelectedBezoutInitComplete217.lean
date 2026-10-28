import Source3.BezoutPart5Compose217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Conditional selected original Bezout parts3/4/5 with exact a/b images. -/
namespace FT1536.Source3.SelectedBezoutInitComplete217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open BezoutPointerSetup217 (a b)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutABZero217 (after)
open BezoutABZeroCombine217 (padded)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → ∃ guardAfter part4After,
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G) ⟨guardAfter,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 4) guardAfter ⟨part4After,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 5) part4After ⟨after rebuilt F G,.normal⟩ ∧
      Data (after rebuilt F G) a (max (highest (X F G) 335) (highest (Y F G) 335)) (padded (X F G) (highest (X F G) 335)) ∧
      Data (after rebuilt F G) b (max (highest (X F G) 335) (highest (Y F G) 335)) (padded (Y F G) (highest (Y F G) 335))) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutABImages217.selected
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  obtain ⟨run,aImage,bImage⟩:=prior good
  obtain ⟨guardAfter,part4After,guard,part4,part5⟩:=BezoutPart5Compose217.source _ _ run
  exact ⟨guardAfter,part4After,guard,part4,part5,aImage,bImage⟩

end FT1536.Source3.SelectedBezoutInitComplete217
