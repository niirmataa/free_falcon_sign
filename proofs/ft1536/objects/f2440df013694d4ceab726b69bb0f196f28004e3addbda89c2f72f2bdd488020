import Source3.CertificateAliases
import Source3.C99SequenceInversion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateDeclarations
open C99ArrayReference (Name State)
open C99ProcedureReference (Stmt Exec Result Program)

def firstNames : List Name := ["tf","tg","tF","tG"].map String.toList
def secondNames : List Name := ["g00","g10","g11","gxx"].map String.toList
def thirdNames : List Name := ["tree","t3","leaves","scratch"].map String.toList
def pointerGroup (names : List Name) : Stmt :=
  C99ProcedureParser.chain (names.map (fun name => .base (.declarePtr name)))
def clear : List Name → State → State
  | [],s => s
  | name::rest,s => clear rest {s with arrays := fun n => if n=name then none else s.arrays n}
def clearAll (s : State) : State := clear thirdNames (clear secondNames (clear firstNames s))
def treeDecl : CLogic.Stmt := .declare .u64 ["treesize".toList]
def treeModel : B20.C.Scalar.State :=
  (CLogic.step CertificatePrologue.emptyCalls CertificatePrologue.completed treeDecl).getD B20.C.Scalar.emptyState
def declared (before : State) : State := {clearAll before with locals := C99Typing.environment treeModel}
def skip : Stmt := .base .skip
def code : Stmt :=
  .seq (pointerGroup firstNames) (.seq (pointerGroup secondNames) (.seq (pointerGroup thirdNames)
    (.seq (.base (.scalar treeDecl)) skip)))

theorem source_bound : CertificateAfterConversion.parseRegion 7705 4=some code := by decide

theorem group_result (program : Program) (names : List Name) (before : State) (result : Result)
    (source : Exec program (pointerGroup names) before result) : result=⟨clear names before,.normal⟩ := by
  induction names generalizing before with
  | nil => exact C99ProcedureScalars.skip_result program before result source
  | cons name rest ih =>
      obtain ⟨middle,head,tail⟩ := C99ProcedureSequence.base_before_tail program (.declarePtr name)
        (pointerGroup rest) before result source
      cases head
      exact ih _ tail

theorem group_exists (program : Program) (names : List Name) (before : State) :
    Exec program (pointerGroup names) before ⟨clear names before,.normal⟩ := by
  induction names generalizing before with
  | nil => exact .base .skip before before (.skip before)
  | cons name rest ih =>
      let middle : State := {before with arrays := fun n => if n=name then none else before.arrays n}
      exact .seqNormal (.base (.declarePtr name)) (pointerGroup rest) before middle _
        (.base _ _ _ (.declarePtr before name)) (ih middle)

theorem clear_locals (names : List Name) (before : State) : (clear names before).locals=before.locals := by
  induction names generalizing before with
  | nil => rfl
  | cons name rest ih => exact ih _
theorem clear_heap (names : List Name) (before : State) : (clear names before).heap=before.heap := by
  induction names generalizing before with
  | nil => rfl
  | cons name rest ih => exact ih _
theorem clearAll_locals (before : State) : (clearAll before).locals=before.locals := by
  simp only [clearAll,clear_locals]
theorem declared_heap (before : State) : (declared before).heap=before.heap := by
  simp only [declared,clearAll,clear_heap]
theorem declared_tmp (before : State) : (declared before).arrays "tmp".toList=before.arrays "tmp".toList := by
  simp [declared,clearAll,clear,firstNames,secondNames,thirdNames]

theorem tree_run : CLogic.step CertificatePrologue.emptyCalls CertificatePrologue.completed treeDecl=some treeModel := by rfl
theorem tree_checked : C99StateBridge.check CertificatePrologue.noSignatures CertificatePrologue.completed.types
    treeDecl=some treeModel.types := by rfl
theorem declared_n (before : State) : C99AliasSequence.HasN (declared before) := by
  change (C99Typing.environment treeModel) "n".toList=some (.uint64,some (.uint64 1536))
  decide

theorem source_result (program : Program) (before : State) (result : Result)
    (locals : before.locals=C99Typing.environment CertificatePrologue.completed)
    (source : Exec program code before result) : result=⟨declared before,.normal⟩ := by
  have h1 := C99SequenceInversion.continuation program (pointerGroup firstNames) _ before (clear firstNames before) result
    (fun out h => group_result program firstNames before out h) source
  have h2 := C99SequenceInversion.continuation program (pointerGroup secondNames) _ _ _ result
    (fun out h => group_result program secondNames _ out h) h1
  have h3 := C99SequenceInversion.continuation program (pointerGroup thirdNames) _ _ _ result
    (fun out h => group_result program thirdNames _ out h) h2
  obtain ⟨middle,hs,ht⟩ := C99ProcedureSequence.base_before_tail program (.scalar treeDecl) skip (clearAll before) result h3
  have hl : (clearAll before).locals=C99Typing.environment CertificatePrologue.completed := (clearAll_locals before).trans locals
  obtain ⟨out,hr,he,_,_⟩ := C99ProcedureScalars.step_complete CertificatePrologue.noSignatures
    CertificatePrologue.emptyCalls CertificatePrologue.pure_calls_complete treeDecl (clearAll before) middle
    CertificatePrologue.completed treeModel.types hl CertificatePrologue.completed_typed tree_checked
    (by intro e h; cases h) hs
  rw [tree_run] at hr
  have ho := Option.some.inj hr
  subst out
  rw [he] at ht
  exact C99ProcedureScalars.skip_result program (declared before) result ht

theorem source_exists (program : Program) (before : State)
    (locals : before.locals=C99Typing.environment CertificatePrologue.completed) :
    Exec program code before ⟨declared before,.normal⟩ := by
  have hl : (clearAll before).locals=C99Typing.environment CertificatePrologue.completed := (clearAll_locals before).trans locals
  have hs := (C99ProcedureScalars.step_sound CertificatePrologue.noSignatures CertificatePrologue.emptyCalls
    CertificatePrologue.pure_calls_sound treeDecl (clearAll before) CertificatePrologue.completed treeModel
    treeModel.types hl CertificatePrologue.completed_typed tree_checked tree_run).1
  have last : Exec program (.seq (.base (.scalar treeDecl)) skip) (clearAll before) ⟨declared before,.normal⟩ :=
    .seqNormal _ _ _ _ _ (.base _ _ _ hs) (.base .skip _ _ (.skip _))
  exact .seqNormal _ _ _ _ _ (group_exists program firstNames before)
    (.seqNormal _ _ _ _ _ (group_exists program secondNames (clear firstNames before))
      (.seqNormal _ _ _ _ _ (group_exists program thirdNames (clear secondNames (clear firstNames before))) last))

end FT1536.Source3.CertificateDeclarations
