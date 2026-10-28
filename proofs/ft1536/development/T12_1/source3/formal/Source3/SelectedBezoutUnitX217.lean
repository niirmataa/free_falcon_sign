import Source3.BezoutUnitCells217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual first unit return on the same selected execution witness. -/
namespace FT1536.Source3.SelectedBezoutUnitX217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutABZero217 (after)
open BezoutUnitGuard217 (unit)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → unit (highest (X F G) 335) (X F G 0)=true →
      ∃ guardAfter part4After,
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G) ⟨guardAfter,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 4) guardAfter ⟨part4After,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 5) part4After ⟨after rebuilt F G,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 6) (after rebuilt F G) ⟨after rebuilt F G,.returned (some (.int32 1))⟩) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutABZero217.selected
  let nx := highest (X F G) 335
  let ny := highest (Y F G) 335
  let fin := SelectedBezoutInitCopies217.finish rebuilt F G
  have bound : nx<2^64 := lt_of_le_of_lt (ExactLengthProgram217.highest_le _ _) (by decide)
  have cellFin : Cell fin "xlen".toList nx := by
    change Cell (state rebuilt F G) "xlen".toList nx
    exact BezoutLengthCells217.xcell _ _ _
  have cellAfter : Cell (after rebuilt F G) "xlen".toList nx :=
    BezoutUnitCells217.xlen fin nx ny (X F G) cellFin
  have binding : (after rebuilt F G).arrays "x".toList=some fd := BezoutPointerSetup217.x_binding rebuilt
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good unitX
  obtain ⟨input,run,one,lowU,lowV,xf,yf,af,bf,uf,vf⟩:=prior good
  obtain ⟨guardAfter,part4After,guard,part4,part5⟩:=BezoutPart5Compose217.source _ _ run
  have part6 := BezoutUnitX217.source (after rebuilt F G) fd nx (X F G 0) bound cellAfter binding (by decide) (xf 0 (by decide)) unitX
  exact ⟨guardAfter,part4After,guard,part4,part5,part6⟩

end FT1536.Source3.SelectedBezoutUnitX217
