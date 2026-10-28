import Source3.BezoutLoopGuardLine217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Selected continuation and source-line parsed guard on one witness. -/
namespace FT1536.Source3.SelectedBezoutLoopLine217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutABZero217 (after)
open SelectedBezoutLoopGuard217 (normal declared)
open BezoutUnitGuard217 (unit)

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
      KeygenWordExpr.Eval (declared rebuilt F G) (BezoutLoopGuardLine217.parsed.getD (.scalar (.literal .i32 0)))
        (C99ScalarReference.boolean (BezoutLoopGuard217.accelerated (highest (X F G) 335) (highest (Y F G) 335)))) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutLoopGuard217.selected
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good xno yno
  obtain ⟨guardAfter,part4After,guard,part4,part5,part6,decl,evaluated⟩:=prior good xno yno
  rw [BezoutLoopGuardLine217.source_line]
  exact ⟨guardAfter,part4After,guard,part4,part5,part6,decl,evaluated⟩

end FT1536.Source3.SelectedBezoutLoopLine217
