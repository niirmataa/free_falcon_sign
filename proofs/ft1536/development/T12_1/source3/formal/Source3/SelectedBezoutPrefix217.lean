import Source3.BezoutPointerSetup217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual selected CRT output reaches bezout declarations and pointer setup. -/
namespace FT1536.Source3.SelectedBezoutPrefix217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open DeepestSelectedCrt217 (pair)
open DeepestUnsignedCrtBody217 (words335)
open ZintNormWalkFlat208 (Data)

def prefixCode : KeygenZintCall.Stmt := .seq (KeygenZintCall.bezoutPart 0) (KeygenZintCall.bezoutPart 1)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    Data made fd 335 F ∧ Data made gd 335 G ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    C99ArrayReference.Bind rebuilt (KeygenZintCall.params .bezout) DeepestBezoutEntry217.args (DeepestBezoutEntry217.entry rebuilt) ∧
    KeygenZintCall.Exec prefixCode (DeepestBezoutEntry217.entry rebuilt) ⟨BezoutPointerSetup217.after rebuilt,.normal⟩ ∧
    Data (BezoutPointerSetup217.after rebuilt) fd 335 (words335 (pair F G)) ∧
    Data (BezoutPointerSetup217.after rebuilt) gd 335 (fun i => words335 (pair F G) (335+i)) ∧
    (BezoutPointerSetup217.after rebuilt).arrays "x".toList=some fd ∧
    (BezoutPointerSetup217.after rebuilt).arrays "y".toList=some gd := by
  obtain ⟨made,rebuilt,F,G,part2,fdata,gdata,crt,binding,xf,yf⟩ := DeepestBezoutEntry217.selected
  have prefixRun : KeygenZintCall.Exec prefixCode (DeepestBezoutEntry217.entry rebuilt) ⟨BezoutPointerSetup217.after rebuilt,.normal⟩ :=
    .seqNormal _ _ _ _ _ (BezoutDeclarations217.source _) (BezoutPointerSetup217.source rebuilt)
  have xafter : Data (BezoutPointerSetup217.after rebuilt) fd 335 (words335 (pair F G)) := by
    intro i bound
    rw [BezoutPointerSetup217.heap]
    exact xf i bound
  have yafter : Data (BezoutPointerSetup217.after rebuilt) gd 335 (fun i => words335 (pair F G) (335+i)) := by
    intro i bound
    rw [BezoutPointerSetup217.heap]
    exact yf i bound
  exact ⟨made,rebuilt,F,G,part2,fdata,gdata,crt,binding,prefixRun,xafter,yafter,
    BezoutPointerSetup217.x_binding rebuilt,BezoutPointerSetup217.y_binding rebuilt⟩

end FT1536.Source3.SelectedBezoutPrefix217
