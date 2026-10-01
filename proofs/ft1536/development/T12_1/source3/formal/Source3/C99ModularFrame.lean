import Source3.C99ModularReference

namespace FT1536.Source3.C99ModularFrame
open C99ModularReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)

def baseReadOnly : C99ArrayReference.Stmt → Bool
  | .skip | .scalar _ => true
  | _ => false
def readOnly : Stmt → Bool
  | .base code => baseReadOnly code
  | .assign _ _ | .ret _ => true
  | .seq a b | .branch _ a b => readOnly a && readOnly b
  | .scope _ body => readOnly body
  | .loop _ body increment => readOnly body && readOnly increment

theorem source_frame (code : Stmt) (before : State) (result : Result)
    (source : Exec code before result) (checked : readOnly code=true) :
    result.state.heap=before.heap ∧ result.state.arrays=before.arrays := by
  induction source with
  | base code before after execution =>
      cases execution
      all_goals first | exact ⟨rfl,rfl⟩ | simp [readOnly,baseReadOnly] at checked
  | assign | loopFalse | ret => exact ⟨rfl,rfl⟩
  | seqNormal first second before middle result head tail ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
      exact ⟨(ih2 hb).1.trans (ih1 ha).1,(ih2 hb).2.trans (ih1 ha).2⟩
  | seqExit first second before result head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals body before result inner ih => exact ih checked
  | branchTrue condition yes no before result v guard nonzero body ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse condition yes no before result v guard zero body ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
      exact ⟨(ih3 checked).1.trans ((ih2 hb).1.trans (ih1 ha).1),
        (ih3 checked).2.trans ((ih2 hb).2.trans (ih1 ha).2)⟩
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      exact ih (Bool.and_eq_true_iff.mp checked).1

end FT1536.Source3.C99ModularFrame
