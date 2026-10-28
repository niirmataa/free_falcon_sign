import Source3.BezoutInitZeroImages217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedBezoutInitZeroImage217
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open BezoutPointerSetup217 (a b)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutInitZero217 (after code)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → KeygenZintCall.Exec code (state rebuilt F G) ⟨after rebuilt F G,.normal⟩ ∧
      Load32 (after rebuilt F G).heap Gp 1 ∧
      Data (after rebuilt F G) BezoutInitZero217.firstPtr (highest (Y F G) 335-1) (fun _ => 0) ∧
      Data (after rebuilt F G) Fp (highest (X F G) 335) (fun _ => 0) ∧
      Data (after rebuilt F G) fd 335 (X F G) ∧ Data (after rebuilt F G) gd 335 (Y F G) ∧
      Data (after rebuilt F G) a (highest (X F G) 335) (X F G) ∧ Data (after rebuilt F G) b (highest (Y F G) 335) (Y F G)) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutInitZero217.selected
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  obtain ⟨input,run,_,_,one,xf,yf,af,bf⟩:=prior good
  exact ⟨run,one,BezoutInitZeroImages217.first_zero _ _ _ input,BezoutInitZeroImages217.second_zero _ _ _ input,xf,yf,af,bf⟩

end FT1536.Source3.SelectedBezoutInitZeroImage217
