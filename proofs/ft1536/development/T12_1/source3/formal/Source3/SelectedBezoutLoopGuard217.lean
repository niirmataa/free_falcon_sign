import Source3.BezoutLoopCells217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Guard expression evaluated on a selected continuation; source binding is separate. -/
namespace FT1536.Source3.SelectedBezoutLoopGuard217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutABZero217 (after)
open BezoutUnitGuard217 (unit)

noncomputable def normal (rebuilt : State) (F G : Nat → BitVec 32) :=
  BezoutNormalNinv217.after (after rebuilt F G) (X F G 0) (Y F G 0)
noncomputable def declared (rebuilt : State) (F G : Nat → BitVec 32) := BezoutLoopCells217.declareR (normal rebuilt F G)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → unit (highest (X F G) 335) (X F G 0)=false → unit (highest (Y F G) 335) (Y F G 0)=false →
      ∃ guardAfter part4After,
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G) ⟨guardAfter,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 4) guardAfter ⟨part4After,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 5) part4After ⟨after rebuilt F G,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 6) (after rebuilt F G) ⟨normal rebuilt F G,.normal⟩ ∧
      KeygenZintCall.Exec (ZintNormWord194.wordScalar (.declare .i32 ["r".toList])) (normal rebuilt F G) ⟨declared rebuilt F G,.normal⟩ ∧
      KeygenWordExpr.Eval (declared rebuilt F G) BezoutLoopGuard217.condition
        (C99ScalarReference.boolean (BezoutLoopGuard217.accelerated (highest (X F G) 335) (highest (Y F G) 335)))) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutNormalNinv217.selected
  let nx := highest (X F G) 335
  let ny := highest (Y F G) 335
  let fin := SelectedBezoutInitCopies217.finish rebuilt F G
  have xb : nx<2^64 := lt_of_le_of_lt (ExactLengthProgram217.highest_le _ _) (by decide)
  have yb : ny<2^64 := lt_of_le_of_lt (ExactLengthProgram217.highest_le _ _) (by decide)
  have ac := BezoutLoopCells217.alen fin nx ny (X F G) (X F G 0) (Y F G 0) xb
  have bc := BezoutLoopCells217.blen fin nx ny (X F G) (X F G 0) (Y F G 0) yb
  have evaluated : KeygenWordExpr.Eval (declared rebuilt F G) BezoutLoopGuard217.condition
      (C99ScalarReference.boolean (BezoutLoopGuard217.accelerated nx ny)) := BezoutLoopGuard217.guard _ nx ny xb yb ac bc
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good xno yno
  obtain ⟨guardAfter,part4After,guard,part4,part5,part6⟩:=prior good xno yno
  exact ⟨guardAfter,part4After,guard,part4,part5,part6,BezoutLoopCells217.declaration _,evaluated⟩

end FT1536.Source3.SelectedBezoutLoopGuard217
