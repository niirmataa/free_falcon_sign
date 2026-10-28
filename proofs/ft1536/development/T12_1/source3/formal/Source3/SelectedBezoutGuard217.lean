import Source3.BezoutGuard217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Instantiate the original initial guard on the selected reconstructed words. -/
namespace FT1536.Source3.SelectedBezoutGuard217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open DeepestSelectedCrt217 (pair)
open DeepestUnsignedCrtBody217 (words335)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)

noncomputable def X (F G : Nat → BitVec 32) := words335 (pair F G)
noncomputable def Y (F G : Nat → BitVec 32) := fun i => words335 (pair F G) (335+i)
noncomputable def state (rebuilt : State) (F G : Nat → BitVec 32) := ExactLengthCalls217.after (BezoutPointerSetup217.after rebuilt) (X F G) (Y F G)
noncomputable def bad (F G : Nat → BitVec 32) := BezoutGuard217.bad (highest (X F G) 335) (highest (Y F G) 335) (X F G 0) (Y F G 0)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    Data made fd 335 F ∧ Data made gd 335 G ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    C99ArrayReference.Bind rebuilt (KeygenZintCall.params .bezout) DeepestBezoutEntry217.args (DeepestBezoutEntry217.entry rebuilt) ∧
    KeygenZintCall.Exec SelectedBezoutPrefix217.prefixCode (DeepestBezoutEntry217.entry rebuilt) ⟨BezoutPointerSetup217.after rebuilt,.normal⟩ ∧
    KeygenZintCall.Exec (KeygenZintCall.bezoutPart 2) (BezoutPointerSetup217.after rebuilt) ⟨state rebuilt F G,.normal⟩ ∧
    KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G)
      ⟨state rebuilt F G,if bad F G then .returned (some (.int32 0)) else .normal⟩ ∧
    Data (state rebuilt F G) fd 335 (X F G) ∧ Data (state rebuilt F G) gd 335 (Y F G) := by
  obtain ⟨made,rebuilt,F,G,part2,fdata,gdata,crt,binding,pre,lengths,xc,yc,xf,yf⟩:=SelectedBezoutLengths217.selected
  have xb : (state rebuilt F G).arrays "x".toList=some fd := BezoutPointerSetup217.x_binding rebuilt
  have yb : (state rebuilt F G).arrays "y".toList=some gd := BezoutPointerSetup217.y_binding rebuilt
  have xbound : highest (X F G) 335<2^64 := lt_of_le_of_lt (ExactLengthProgram217.highest_le _ 335) (by decide)
  have ybound : highest (Y F G) 335<2^64 := lt_of_le_of_lt (ExactLengthProgram217.highest_le _ 335) (by decide)
  have run := BezoutGuard217.source (state rebuilt F G) fd gd (highest (X F G) 335) (highest (Y F G) 335)
    (X F G 0) (Y F G 0) xbound ybound xc yc xb yb (by decide) (by decide) (xf 0 (by decide)) (yf 0 (by decide))
  exact ⟨made,rebuilt,F,G,part2,fdata,gdata,crt,binding,pre,lengths,run,xf,yf⟩

end FT1536.Source3.SelectedBezoutGuard217
