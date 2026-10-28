import Source3.BezoutParserActualBranch217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original parsed loop shape and selected symbolic first-guard readiness. -/
namespace FT1536.Source3.SelectedBezoutActualGuard217
open C99ArrayReference (State)
open KeygenFullData127 (env)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutABZero217 (after)
open SelectedBezoutLoopGuard217 (normal declared)
open BezoutUnitGuard217 (unit)

theorem selected : ∃ (vars ptrVars : List C99ArrayReference.Name) (yes no rest tail : KeygenZintCall.Stmt)
    (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenZintCall.bezoutPart 7=.seq
      (.loop (.scalar (.literal .i32 1))
        (.scope vars ptrVars (.seq BezoutParserDecl217.declaration
          (.seq (.branch BezoutLoopGuard217.condition yes no) rest))) KeygenZintCall.skip) tail ∧
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → unit (highest (X F G) 335) (X F G 0)=false → unit (highest (Y F G) 335) (Y F G 0)=false →
      ∃ guardAfter part4After,
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 3) (state rebuilt F G) ⟨guardAfter,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 4) guardAfter ⟨part4After,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 5) part4After ⟨after rebuilt F G,.normal⟩ ∧
      KeygenZintCall.Exec (KeygenZintCall.bezoutPart 6) (after rebuilt F G) ⟨normal rebuilt F G,.normal⟩ ∧
      KeygenZintCall.Exec BezoutParserDecl217.declaration (normal rebuilt F G) ⟨declared rebuilt F G,.normal⟩ ∧
      KeygenWordExpr.Eval (declared rebuilt F G) BezoutLoopGuard217.condition
        (C99ScalarReference.boolean (BezoutLoopGuard217.accelerated (highest (X F G) 335) (highest (Y F G) 335)))) := by
  obtain ⟨vars,ptrVars,yes,no,rest,tail,shape⟩:=BezoutParserActualBranch217.actual
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutLoopGuard217.selected
  exact ⟨vars,ptrVars,yes,no,rest,tail,made,rebuilt,F,G,shape,part2,crt,prior⟩

end FT1536.Source3.SelectedBezoutActualGuard217
