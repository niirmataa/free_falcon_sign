import Source3.BezoutABImagesFrame217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedBezoutABImages217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open BezoutPointerSetup217 (a b)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutABZero217 (after code)
open BezoutABZeroCombine217 (padded)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → KeygenZintCall.Exec code (state rebuilt F G) ⟨after rebuilt F G,.normal⟩ ∧
      Data (after rebuilt F G) a (max (highest (X F G) 335) (highest (Y F G) 335)) (padded (X F G) (highest (X F G) 335)) ∧
      Data (after rebuilt F G) b (max (highest (X F G) 335) (highest (Y F G) 335)) (padded (Y F G) (highest (Y F G) 335))) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutABZero217.selected
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  obtain ⟨input,run,_,_,_,_,_,af,bf,_,_⟩:=prior good
  obtain ⟨aImage,bImage⟩:=BezoutABImagesFrame217.source _ _ _ _ _ input af bf
  exact ⟨run,aImage,bImage⟩

end FT1536.Source3.SelectedBezoutABImages217
