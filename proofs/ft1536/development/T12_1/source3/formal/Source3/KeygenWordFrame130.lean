import Source3.KeygenWordSegments130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordFrame130
open C99ArrayReference (State Name)
open KeygenWordExec (Stmt Exec)
open KeygenWordSegments130 (Prefix)

def keepsArrays : Stmt → Bool
  | .modular code => C99ModularFrame.readOnly code
  | .assign _ _ | .store _ _ _ | .ret _ => true
  | .seq a b | .branch _ a b | .loop _ a b => keepsArrays a && keepsArrays b
  | .scope _ body => keepsArrays body

theorem arrays (code : Stmt) (before : State) (out : C99ProcedureReference.Result)
    (source : Exec code before out) (checked : keepsArrays code=true) : out.state.arrays=before.arrays := by
  induction source with
  | modular code before out source => exact (C99ModularFrame.source_frame code before out source checked).2
  | assign | store | ret | loopFalse => rfl
  | seqNormal a b before middle out head tail ihFirst ihLast =>
      obtain ⟨aChecked,bChecked⟩ := Bool.and_eq_true_iff.mp checked
      exact (ihLast bChecked).trans (ihFirst aChecked)
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals body before out inner ih => exact ih checked
  | branchTrue condition yes no before out value guard nonzero source ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse condition yes no before out value guard zero source ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out value guard nonzero iteration update rest ihBody ihIncrement ihRest =>
      obtain ⟨bodyChecked,incrementChecked⟩ := Bool.and_eq_true_iff.mp checked
      exact (ihRest checked).trans ((ihIncrement incrementChecked).trans (ihBody bodyChecked))
  | loopReturn condition body increment before after value returned guard nonzero iteration ih =>
      exact ih (Bool.and_eq_true_iff.mp checked).1

theorem prefix_arrays (condition : KeygenWordExpr.Expr) (body increment : Stmt) (count : Nat)
    (before after : State) (source : Prefix condition body increment count before after)
    (bodyChecked : keepsArrays body=true) (incrementChecked : keepsArrays increment=true) :
    after.arrays=before.arrays := by
  induction source with
  | done => rfl
  | next count before middle updated after value guard nonzero iteration update rest ih =>
      exact ih.trans ((arrays increment middle _ update incrementChecked).trans (arrays body before _ iteration bodyChecked))

theorem prefix_outside (condition : KeygenWordExpr.Expr) (body increment : Stmt) (count : Nat)
    (before after : State) (source : Prefix condition body increment count before after)
    (names : List Name) (bodyChecked : KeygenWordExec.only names body=true)
    (incrementChecked : KeygenWordExec.only names increment=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before names block offset) :
    C99ArrayFrame.Outside after names block offset ∧ after.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | done => exact ⟨outside,rfl⟩
  | next count before middle updated after value guard nonzero iteration update rest ih =>
      obtain ⟨first,_,one⟩ := KeygenWordExec.body_frame body before _ iteration names bodyChecked block offset outside
      obtain ⟨second,_,two⟩ := KeygenWordExec.body_frame increment middle _ update names incrementChecked block offset first
      obtain ⟨last,three⟩ := ih second
      exact ⟨last,three.trans (two.trans one)⟩

end FT1536.Source3.KeygenWordFrame130
