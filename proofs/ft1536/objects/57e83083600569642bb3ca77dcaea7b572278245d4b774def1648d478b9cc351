import Source3.C99ProcedureReference

namespace FT1536.Source3.C99TableFrame
open C99ArrayReference (State)

theorem array_execution (program : C99ArrayReference.Program) (code : C99ArrayReference.Stmt) (before after : State)
    (source : C99ArrayReference.Exec program code before after) : after.tables=before.tables := by
  induction source with
  | skip | scalar | assign | declarePtr | bindPtr | store64 | store32 | copy | whileFalse | call => rfl
  | seq a b before middle after first second ih1 ih2 => exact ih2.trans ih1
  | scope locals pointers body before after inner ih => exact ih
  | branchTrue condition yes no before after v guard nonzero body ih => exact ih
  | branchFalse condition yes no before after v guard zero body ih => exact ih
  | whileTrue condition body before middle after v guard nonzero step rest ih1 ih2 => exact ih2.trans ih1

theorem procedure_execution (program : C99ProcedureReference.Program) (code : C99ProcedureReference.Stmt)
    (before : State) (result : C99ProcedureReference.Result)
    (source : C99ProcedureReference.Exec program code before result) : result.state.tables=before.tables := by
  induction source with
  | base code before after execution => exact array_execution _ _ _ _ execution
  | seqNormal a b before middle result first second ih1 ih2 => exact ih2.trans ih1
  | seqExit a b before result first exit ih => exact ih
  | scope locals pointers body before result inner ih => exact ih
  | branchTrue condition yes no before result v guard nonzero body ih => exact ih
  | branchFalse condition yes no before result v guard zero body ih => exact ih
  | loopFalse | returnVoid | returnValue | breakLoop | continueLoop => rfl
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact ih3.trans (ih2.trans ih1)
  | loopContinue condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact ih3.trans (ih2.trans ih1)
  | loopBreak condition body increment before after v guard nonzero iteration ih => exact ih
  | loopReturn condition body increment before after v returned guard nonzero iteration ih => exact ih
  | call name args destination f before entry after result returned source parameters body conversion receive ih =>
      cases receive <;> rfl

end FT1536.Source3.C99TableFrame
