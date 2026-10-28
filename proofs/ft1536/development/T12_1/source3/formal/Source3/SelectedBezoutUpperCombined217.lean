import Source3.BezoutUpperImagesFrame217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedBezoutUpperCombined217
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open KeygenFullData127 (env)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)
open SelectedBezoutGuard217 (state bad)
open SelectedBezoutUpper217 (after code)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → KeygenZintCall.Exec code (state rebuilt F G) ⟨after rebuilt F G,.normal⟩ ∧
      Load32 (after rebuilt F G).heap Gp 1 ∧
      Data (after rebuilt F G) BezoutInitZero217.firstPtr 334 (fun _ => 0) ∧
      Data (after rebuilt F G) Fp 335 (fun _ => 0)) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutUpper217.selected
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  obtain ⟨input,run,_,one,lowU,lowV,_,_,_,_,_,_⟩:=prior good
  obtain ⟨u,v⟩:=BezoutUpperImagesFrame217.source _ _ _ input lowU lowV
  exact ⟨run,one,u,v⟩

end FT1536.Source3.SelectedBezoutUpperCombined217
