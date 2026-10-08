import Source3.KeygenAttemptNorm
import Source3.KeygenSamplerContext

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenAttemptSlots
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
def Slots (before after : State) : Prop := after.arrays=before.arrays ∧ after.tables=before.tables
theorem trans (a b c : State) (first : Slots a b) (second : Slots b c) : Slots a c :=
  ⟨second.1.trans first.1,second.2.trans first.2⟩
theorem restore (before after : State) (locals pointers : List Name) (same : Slots before after) :
    Slots before (C99ArrayReference.restoreScope before after locals pointers) := by
  refine ⟨?_,same.2⟩
  funext name
  simp only [C99ArrayReference.restoreScope,same.1,ite_self]
def arrayOnly : C99ArrayReference.Stmt → Bool
  | .declarePtr _ | .bindPtr _ _ _ => false
  | .seq a b | .branch _ a b => arrayOnly a && arrayOnly b
  | .scope _ _ b | .while _ b => arrayOnly b
  | _ => true
theorem array (program : C99ArrayReference.Program) (code : C99ArrayReference.Stmt) (before after : State)
    (source : C99ArrayReference.Exec program code before after) (checked : arrayOnly code=true) : Slots before after := by
  induction source with
  | declarePtr | bindPtr => cases checked
  | seq a b before middle after first second ih1 ih2 =>
    exact trans _ _ _ (ih1 (Bool.and_eq_true_iff.mp checked).1) (ih2 (Bool.and_eq_true_iff.mp checked).2)
  | scope locals pointers body before after inner ih => exact restore _ _ _ _ (ih checked)
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | whileTrue condition body before middle after v guard nonzero step rest ih1 ih2 => exact trans _ _ _ (ih1 checked) (ih2 checked)
  | skip | scalar | assign | store64 | store32 | copy | whileFalse | call => exact ⟨rfl,rfl⟩
def procedureOnly : C99ProcedureReference.Stmt → Bool
  | .base code => arrayOnly code
  | .seq a b | .branch _ a b | .loop _ a b => procedureOnly a && procedureOnly b
  | .scope _ _ b => procedureOnly b
  | _ => true
theorem procedure (program : C99ProcedureReference.Program) (code : C99ProcedureReference.Stmt) (before : State) (out : Result)
    (source : C99ProcedureReference.Exec program code before out) (checked : procedureOnly code=true) : Slots before out.state := by
  induction source with
  | base code before after body => exact array _ _ _ _ body checked
  | seqNormal a b before middle out first second ih1 ih2 =>
    exact trans _ _ _ (ih1 (Bool.and_eq_true_iff.mp checked).1) (ih2 (Bool.and_eq_true_iff.mp checked).2)
  | seqExit a b before out first exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals pointers body before out inner ih => exact restore _ _ _ _ (ih checked)
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3
  | loopContinue condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact trans _ _ _ (ih1 (Bool.and_eq_true_iff.mp checked).1)
      (trans _ _ _ (ih2 (Bool.and_eq_true_iff.mp checked).2) (ih3 checked))
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih | loopBreak _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | call name args dst f before entry after out returned lookup binding body conversion receive ih =>
    exact C99ProcedureFootprint.receive_arrays dst {before with heap := out.state.heap} after returned receive
  | returnVoid | returnValue | breakLoop | continueLoop | loopFalse => exact ⟨rfl,rfl⟩
def searchOnly : KeygenSearchExec.Stmt → Bool
  | .procedure code => procedureOnly code
  | .pointer _ _ => false
  | .seq a b | .branch _ a b | .loop _ a b => searchOnly a && searchOnly b
  | .scope _ _ b => searchOnly b
  | _ => true
theorem search (ctx : KeygenSearchContext.Context) (code : KeygenSearchExec.Stmt) (before : State) (out : Result)
    (source : KeygenSearchExec.Exec ctx code before out) (checked : searchOnly code=true) : Slots before out.state := by
  induction source with
  | procedure code before out source => exact procedure _ _ _ _ source checked
  | pointer => cases checked
  | small args before after source => cases source; exact ⟨rfl,rfl⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
    exact trans _ _ _ (ih1 (Bool.and_eq_true_iff.mp checked).1) (ih2 (Bool.and_eq_true_iff.mp checked).2)
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals pointers body before out inner ih => exact restore _ _ _ _ (ih checked)
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact trans _ _ _ (ih1 (Bool.and_eq_true_iff.mp checked).1)
      (trans _ _ _ (ih2 (Bool.and_eq_true_iff.mp checked).2) (ih3 checked))
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | logn | assign | store32 | store64 | move | loopFalse => exact ⟨rfl,rfl⟩
theorem bound_checked : searchOnly KeygenAttemptNorm.boundCode=true := by decide
theorem raw_checked : searchOnly KeygenNormFrame.code=true := by decide
theorem head_checked : searchOnly KeygenAttemptNorm.headCode=true := by decide
theorem tail_checked : searchOnly KeygenAttemptNorm.tailCode=true := by decide
theorem raw (ctx : KeygenSearchContext.Context) (before : State) (out : Result) (source : KeygenNormFrame.Exec ctx before out) : Slots before out.state := by
  cases source with
  | run ready out computation gate =>
    have keep := search _ _ _ _ computation raw_checked
    cases gate <;> exact keep
theorem gs (ctx : KeygenSearchContext.Context) (before : State) (out : Result) (source : KeygenAttemptNorm.GS ctx before out) : Slots before out.state := by
  cases source with
  | run head first second ready out initial scale1 scale2 tail gate =>
    have a := search _ _ _ _ initial head_checked
    have b := (KeygenAttemptFft.slots _ _ _ scale1).2
    have c := (KeygenAttemptFft.slots _ _ _ scale2).2
    have d := search _ _ _ _ tail tail_checked
    have keep := trans _ _ _ a (trans _ _ _ b (trans _ _ _ c d))
    cases gate <;> exact keep
theorem norm (ctx : KeygenSearchContext.Context) (before : State) (out : Result) (source : KeygenAttemptNorm.Exec ctx before out) : Slots before out.state := by
  cases source with
  | rawRejected bounded out initial source rejected => exact trans _ _ _ (search _ _ _ _ initial bound_checked) (raw _ _ _ source)
  | gs bounded middle out initial source gram => exact trans _ _ _ (search _ _ _ _ initial bound_checked) (trans _ _ _ (raw _ _ _ source) (gs _ _ _ gram))

end FT1536.Source3.KeygenAttemptSlots
