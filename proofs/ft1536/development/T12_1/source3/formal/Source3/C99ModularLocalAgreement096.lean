import Source3.C99DeclarationAgreement096

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ModularLocalAgreement096
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open C99ExpressionEnvironment (Agree)
open C99ModularReference
open C99DeclarationAgreement096 (declaredNames)
open C99ModularAgreement096 (checkedExpr checkedBase Same)

/-- Declarations extend the known local environment for the source tail.
    The comparison at the end keeps the original tracked names and the
    actual return flow; unknown old local contents are never assumed equal. -/
def checkedCode (names : List Name) : Stmt → Bool
  | .base code => checkedBase names code
  | .assign name e => names.contains name && checkedExpr names e
  | .ret e => checkedExpr names e
  | .retVoid => true
  | .seq a b => match declaredNames a with
      | some locals => checkedCode (locals ++ names) b
      | none => checkedCode names a && checkedCode names b
  | .scope _ body => checkedCode names body
  | .branch e a b | .loop e a b =>
      C99ScalarAgreement096.checkedExpr names (C99Frontend.expression e) && checkedCode names a && checkedCode names b
  | .store32 _ _ _ | .storeRev _ _ _ _ _ => false

theorem execution (calls : CallRelation) (deterministic : C99ScalarDeterminism089.Deterministic calls)
    (names : List Name) (code : Stmt) (s t : State) (a b : Result)
    (checked : checkedCode names code = true) (same : Agree s.locals t.locals names)
    (first : GenExec calls code s a) (second : GenExec calls code t b) : Same names a b := by
  have scalarUnique := C99ScalarAgreement096.expression FprPrefixCalls.calls C99ScalarCallsDeterminism089.prefix_calls
  revert checked same
  induction first generalizing names t b
  case seqNormal headCode tailCode before middle out headExec tailExec ih1 ih2 =>
    intro checked same
    cases second with
    | seqNormal _ _ _ otherMiddle _ head2 tail2 =>
        cases declarations : declaredNames headCode with
        | none =>
            simp only [checkedCode, declarations, Bool.and_eq_true] at checked
            have headSame := ih1 names t _ head2 checked.1 same
            exact ih2 names otherMiddle _ tail2 checked.2 headSame.2
        | some locals =>
            simp only [checkedCode, declarations] at checked
            have headSame := C99DeclarationAgreement096.source_pair calls names locals headCode before t
              ⟨middle, .normal⟩ ⟨otherMiddle, .normal⟩ declarations same headExec head2
            have tailSame := ih2 (locals ++ names) otherMiddle _ tail2 checked headSame.2.2
            exact ⟨tailSame.1, C99DeclarationAgreement096.restrict names locals _ _ tailSame.2⟩
    | seqExit _ _ _ _ head2 exit =>
        cases declarations : declaredNames headCode with
        | none =>
            simp only [checkedCode, declarations, Bool.and_eq_true] at checked
            have headSame := ih1 names t _ head2 checked.1 same
            exact (exit headSame.1.symm).elim
        | some locals =>
            exact (exit (C99DeclarationAgreement096.normal calls headCode locals t _ declarations head2)).elim
  case seqExit headCode tailCode before out headExec exit ih =>
    intro checked same
    cases declarations : declaredNames headCode with
    | some locals => exact (exit (C99DeclarationAgreement096.normal calls headCode locals before out declarations headExec)).elim
    | none =>
        simp only [checkedCode, declarations, Bool.and_eq_true] at checked
        cases second with
        | seqNormal _ _ _ otherMiddle _ head2 tail2 =>
            have headSame := ih names t ⟨otherMiddle, .normal⟩ head2 checked.1 same
            exact (exit headSame.1).elim
        | seqExit _ _ _ _ head2 exit2 => exact ih names t _ head2 checked.1 same
  all_goals intro checked same; cases second
  all_goals simp only [checkedCode, Bool.and_eq_true, Bool.false_eq_true, Same,
    C99ArrayReference.bindValue, C99ArrayReference.restoreScope] at *
  all_goals grind only [C99ModularAgreement096.base, C99ModularAgreement096.expression, C99ArrayReference.scalar,
    C99ScalarAgreement096.set_agree, C99ScalarAgreement096.restore_agree, → C99ScalarAgreement096.lookup]

end FT1536.Source3.C99ModularLocalAgreement096
