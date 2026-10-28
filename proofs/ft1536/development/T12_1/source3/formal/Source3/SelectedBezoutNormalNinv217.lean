import Source3.BezoutNormalCells217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Selected original part6 nonunit continuation through both ninv31 calls. -/
namespace FT1536.Source3.SelectedBezoutNormalNinv217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutABZero217 (after)
open BezoutUnitGuard217 (unit)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → unit (highest (X F G) 335) (X F G 0)=false → unit (highest (Y F G) 335) (Y F G 0)=false →
      ∃ guardAfter part4After,
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G) ⟨guardAfter,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 4) guardAfter ⟨part4After,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 5) part4After ⟨after rebuilt F G,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 6) (after rebuilt F G)
        ⟨BezoutNormalNinv217.after (after rebuilt F G) (X F G 0) (Y F G 0),.normal⟩) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutABZero217.selected
  let base := BezoutPointerSetup217.after rebuilt
  let nx := highest (X F G) 335
  let ny := highest (Y F G) 335
  let fin := SelectedBezoutInitCopies217.finish rebuilt F G
  have xbound : nx≤335 := ExactLengthProgram217.highest_le _ _
  have ybound : ny≤335 := ExactLengthProgram217.highest_le _ _
  have cellXfin : Cell fin "xlen".toList nx := by
    change Cell (state rebuilt F G) "xlen".toList nx
    exact BezoutLengthCells217.xcell _ _ _
  have cellYfin : Cell fin "ylen".toList ny := by
    change Cell (state rebuilt F G) "ylen".toList ny
    exact BezoutLengthCells217.ycell _ _ _
  have cellX : Cell (after rebuilt F G) "xlen".toList nx := BezoutUnitCells217.xlen fin nx ny (X F G) cellXfin
  have cellY : Cell (after rebuilt F G) "ylen".toList ny := BezoutUnitCells217.ylen fin nx ny (X F G) cellYfin
  have xp : (after rebuilt F G).arrays "x".toList=some fd := BezoutPointerSetup217.x_binding rebuilt
  have yp : (after rebuilt F G).arrays "y".toList=some gd := BezoutPointerSetup217.y_binding rebuilt
  have declXfin : fin.locals "x0i".toList=some (.uint32,none) := by
    change (ExactLengthCalls217.after base (X F G) (Y F G)).locals "x0i".toList=some (.uint32,none)
    exact (BezoutUpperCells217.length_frame base _ _ "x0i".toList (by decide) (by decide)).trans (BezoutNormalCells217.base rebuilt).1
  have declYfin : fin.locals "y0i".toList=some (.uint32,none) := by
    change (ExactLengthCalls217.after base (X F G) (Y F G)).locals "y0i".toList=some (.uint32,none)
    exact (BezoutUpperCells217.length_frame base _ _ "y0i".toList (by decide) (by decide)).trans (BezoutNormalCells217.base rebuilt).2
  have declX : (after rebuilt F G).locals "x0i".toList=some (.uint32,none) := BezoutNormalCells217.x_decl fin nx ny (X F G) declXfin
  have declY : (after rebuilt F G).locals "y0i".toList=some (.uint32,none) := BezoutNormalCells217.y_decl fin nx ny (X F G) declYfin
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good xno yno
  obtain ⟨input,run,one,lowU,lowV,xf,yf,af,bf,uf,vf⟩:=prior good
  obtain ⟨guardAfter,part4After,guard,part4,part5⟩:=BezoutPart5Compose217.source _ _ run
  have part6 := BezoutNormalNinv217.source _ fd gd nx ny (X F G 0) (Y F G 0) (by omega) (by omega)
    cellX cellY xp yp (by decide) (by decide) (xf 0 (by decide)) (yf 0 (by decide)) declX declY xno yno
  exact ⟨guardAfter,part4After,guard,part4,part5,part6⟩

end FT1536.Source3.SelectedBezoutNormalNinv217
