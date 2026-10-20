import Source3.C99ProcedureSequence

namespace FT1536.Source3.C99HeapOnly
open C99ArrayReference (State)
open C99ProcedureReference (Stmt Exec Result Program)

def baseOnly : C99ArrayReference.Stmt → Bool
  | .skip | .copy _ _ _ _ _ | .store64 _ _ _ | .store32 _ _ _ => true
  | _ => false
def only : Stmt → Bool
  | .base code => baseOnly code
  | .seq a b => only a && only b
  | .call _ _ .discard => true
  | _ => false

theorem result_frame (program : Program) (code : Stmt) (before : State) (result : Result)
    (source : Exec program code before result) (checked : only code=true) :
    result=⟨{before with heap := result.state.heap},.normal⟩ := by
  induction source with
  | base code before after execution =>
      cases execution
      all_goals first | rfl | simp [only,baseOnly] at checked
  | seqNormal a b before middle result first second ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
      have hm := congrArg Result.state (ih1 ha)
      change middle={before with heap := middle.heap} at hm
      have hr := ih2 hb
      rw [hm] at hr
      exact hr
  | seqExit a b before result first exit ih =>
      exact False.elim (exit (congrArg Result.flow (ih (Bool.and_eq_true_iff.mp checked).1)))
  | call name args destination f before entry after result returned source parameters body conversion receive ih =>
      cases destination with
      | discard => cases receive; rfl
      | assign | update => simp [only] at checked
  | scope | branchTrue | branchFalse | loopFalse | loopNormal | loopContinue | loopBreak | loopReturn |
    returnVoid | returnValue | breakLoop | continueLoop => simp [only] at checked

def fold : List Stmt → Stmt → Stmt
  | [],tail => tail
  | a::rest,tail => .seq a (fold rest tail)

theorem before_tail (program : Program) (atoms : List Stmt) (tail : Stmt)
    (before : State) (result : Result) (checked : atoms.all only=true)
    (source : Exec program (fold atoms tail) before result) :
    ∃ middle, Exec program (fold atoms (.base .skip)) before ⟨middle,.normal⟩ ∧ Exec program tail middle result := by
  induction atoms generalizing before with
  | nil => exact ⟨before,.base .skip before before (.skip before),source⟩
  | cons a rest ih =>
      obtain ⟨ha,hr⟩ := Bool.and_eq_true_iff.mp checked
      cases source with
      | seqNormal first second before entry result head tailSource =>
          obtain ⟨middle,hs,ht⟩ := ih entry hr tailSource
          exact ⟨middle,.seqNormal a (fold rest (.base .skip)) before entry ⟨middle,.normal⟩ head hs,ht⟩
      | seqExit first second before result head exit =>
          exact False.elim (exit (congrArg Result.flow (result_frame program a before result head ha)))

theorem fold_checked (atoms : List Stmt) (checked : atoms.all only=true) : only (fold atoms (.base .skip))=true := by
  induction atoms with
  | nil => rfl
  | cons a rest ih =>
      obtain ⟨ha,hr⟩ := Bool.and_eq_true_iff.mp checked
      exact Bool.and_eq_true_iff.mpr ⟨ha,ih hr⟩

end FT1536.Source3.C99HeapOnly
