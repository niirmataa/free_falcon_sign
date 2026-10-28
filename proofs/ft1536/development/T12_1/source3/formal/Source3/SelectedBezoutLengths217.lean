import Source3.BezoutLengthFrame217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual selected bezout inputs reach both source exact-length results. -/
namespace FT1536.Source3.SelectedBezoutLengths217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open DeepestSelectedCrt217 (pair)
open DeepestUnsignedCrtBody217 (words335)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open ExactLengthCalls217 (after withX)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    Data made fd 335 F ∧ Data made gd 335 G ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    C99ArrayReference.Bind rebuilt (KeygenZintCall.params .bezout) DeepestBezoutEntry217.args (DeepestBezoutEntry217.entry rebuilt) ∧
    KeygenZintCall.Exec SelectedBezoutPrefix217.prefixCode (DeepestBezoutEntry217.entry rebuilt) ⟨BezoutPointerSetup217.after rebuilt,.normal⟩ ∧
    KeygenZintCall.Exec (KeygenZintCall.bezoutPart 2) (BezoutPointerSetup217.after rebuilt)
      ⟨after (BezoutPointerSetup217.after rebuilt) (words335 (pair F G)) (fun i => words335 (pair F G) (335+i)),.normal⟩ ∧
    Cell (after (BezoutPointerSetup217.after rebuilt) (words335 (pair F G)) (fun i => words335 (pair F G) (335+i))) "xlen".toList (highest (words335 (pair F G)) 335) ∧
    Cell (after (BezoutPointerSetup217.after rebuilt) (words335 (pair F G)) (fun i => words335 (pair F G) (335+i))) "ylen".toList (highest (fun i => words335 (pair F G) (335+i)) 335) ∧
    Data (after (BezoutPointerSetup217.after rebuilt) (words335 (pair F G)) (fun i => words335 (pair F G) (335+i))) fd 335 (words335 (pair F G)) ∧
    Data (after (BezoutPointerSetup217.after rebuilt) (words335 (pair F G)) (fun i => words335 (pair F G) (335+i))) gd 335 (fun i => words335 (pair F G) (335+i)) := by
  obtain ⟨made,rebuilt,F,G,part2,fdata,gdata,crt,binding,pre,xf,yf,xb,yb⟩:=SelectedBezoutPrefix217.selected
  obtain ⟨run,xcell,ycell,xafter,yafter⟩ := BezoutLengthFrame217.source rebuilt _ _ xf yf
  exact ⟨made,rebuilt,F,G,part2,fdata,gdata,crt,binding,pre,run,xcell,ycell,xafter,yafter⟩

end FT1536.Source3.SelectedBezoutLengths217
