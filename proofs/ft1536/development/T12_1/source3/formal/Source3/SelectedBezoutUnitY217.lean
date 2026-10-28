import Source3.BezoutUnitCopies217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual second unit return and output images on one selected witness. -/
namespace FT1536.Source3.SelectedBezoutUnitY217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open DeepestBezoutEntry217 (Fp Gp)
open DeepestSelectedCrt217 (tmp)
open BezoutPointerSetup217 (v1)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutABZero217 (after)
open BezoutUnitGuard217 (unit)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → unit (highest (X F G) 335) (X F G 0)=false → unit (highest (Y F G) 335) (Y F G 0)=true →
      ∃ guardAfter part4After,
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G) ⟨guardAfter,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 4) guardAfter ⟨part4After,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 5) part4After ⟨after rebuilt F G,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 6) (after rebuilt F G)
        ⟨BezoutUnitCopies217.after (after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335),.returned (some (.int32 1))⟩ ∧
      Data (BezoutUnitCopies217.after (after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335)) Gp (highest (Y F G) 335) (Y F G) ∧
      Data (BezoutUnitCopies217.after (after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335)) Fp (highest (X F G) 335) (BezoutInitLowBit217.image (X F G))) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutABZero217.selected
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
  have ub : (after rebuilt F G).arrays "u".toList=some Gp := rfl
  have vb : (after rebuilt F G).arrays "v".toList=some Fp := rfl
  have u1b : (after rebuilt F G).arrays "u1".toList=some tmp := rfl
  have v1b : (after rebuilt F G).arrays "v1".toList=some v1 := rfl
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good xno yyes
  obtain ⟨input,run,one,lowU,lowV,xf,yf,af,bf,uf,vf⟩:=prior good
  obtain ⟨guardAfter,part4After,guard,part4,part5⟩:=BezoutPart5Compose217.source _ _ run
  have copies : BezoutUnitCopies217.Input (after rebuilt F G) nx ny (Y F G) (BezoutInitLowBit217.image (X F G)) :=
    ⟨xbound,ybound,cellX,cellY,ub,vb,u1b,v1b,uf,vf,input.extent,input.size,input.writable⟩
  obtain ⟨copyU,copyV,uImage,vImage⟩:=BezoutUnitCopies217.source _ _ _ _ _ copies
  have part6 := BezoutUnitY217.source _ _ _ fd gd nx ny (X F G 0) (Y F G 0) (by omega) (by omega)
    cellX cellY xp yp (by decide) (by decide) (xf 0 (by decide)) (yf 0 (by decide)) xno yyes copyU copyV
  exact ⟨guardAfter,part4After,guard,part4,part5,part6,uImage,vImage⟩

end FT1536.Source3.SelectedBezoutUnitY217
