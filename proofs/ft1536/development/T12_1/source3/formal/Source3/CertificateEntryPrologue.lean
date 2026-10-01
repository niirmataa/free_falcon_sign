import Source3.MknReference
import Source3.C99DeclarationStatements
import Source3.C99KnownAssignment
import Source3.C99CountedWords
import Source3.C99SequenceInversion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The same pinned prologue, now for arbitrary additional caller/global
   scalar bindings. Only the actual M0 parameter values are required. -/
namespace FT1536.Source3.CertificateEntryPrologue
open C99ArrayReference (State bindValue)
open C99ProcedureReference (Exec Result)
open C99DeclarationStatements (effect)

def first (before : State) : State := effect .u64 ["n".toList,"hn".toList,"u".toList] before
def second (before : State) : State := effect .u32 ["bad".toList] (first before)
def declared (before : State) : State := effect .u64 ["q_squared".toList] (second before)
def sized (before : State) : State := bindValue (declared before) "n".toList .uint64 (.uint64 1536)
def ready (before : State) : State := bindValue (sized before) "hn".toList .uint64 (.uint64 768)
def halfExpression : CLogic.Expr := .bin .shr (.var "n".toList) (.literal .i32 1)

theorem declared_profile (before : State) (profile : MknReference.Profile before) : MknReference.Profile (declared before) := by
  simpa [MknReference.Profile,declared,second,first,effect,C99DeclarationCells.declareCells,
    C99ValueBridge.type,C99ScalarReference.set] using profile
theorem declared_n (before : State) : (declared before).locals "n".toList=some (.uint64,none) := by
  simp [declared,second,first,effect,C99DeclarationCells.declareCells,C99ValueBridge.type,C99ScalarReference.set]
theorem sized_n (before : State) : (sized before).locals "n".toList=some (.uint64,some (.uint64 1536)) := by
  simp [sized,bindValue,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]
theorem sized_hn (before : State) : (sized before).locals "hn".toList=some (.uint64,none) := by
  simp [sized,bindValue,declared,second,first,effect,C99DeclarationCells.declareCells,C99ValueBridge.type,C99ScalarReference.set]
theorem ready_n (before : State) : (ready before).locals "n".toList=some (.uint64,some (.uint64 1536)) := by
  simpa [ready,bindValue,C99ScalarReference.set] using sized_n before
theorem ready_hn (before : State) : (ready before).locals "hn".toList=some (.uint64,some (.uint64 768)) := by
  simp [ready,bindValue,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]
theorem ready_profile (before : State) (profile : MknReference.Profile before) : MknReference.Profile (ready before) := by
  simpa [MknReference.Profile,ready,sized,bindValue,C99ScalarReference.set] using declared_profile before profile
theorem ready_heap (before : State) : (ready before).heap=before.heap := rfl
theorem ready_arrays (before : State) : (ready before).arrays=before.arrays := rfl

theorem half_value (before : State) (value : C99IntegerReference.Value)
    (source : C99ArrayReference.scalar (sized before) halfExpression value) : value=.uint64 768 := by
  change C99ScalarReference.Eval _ _ (.shift .right (.variable "n".toList) (.literal .int32 1)) value at source
  cases source with
  | shift op a b x y z hx hy operation =>
      have hn := C99CountedWords.variable_exact (sized before) "n".toList .uint64 (.uint64 1536) x (sized_n before) hx
      subst x
      cases hy
      obtain ⟨k,hk,_,he⟩ := (C99IntegerReference.shift_right_iff _ _ _).mp operation
      have hcount : k=1 := by change (1 : Int)=(k : Int) at hk; omega
      subst k
      exact he

theorem guard_zero (before : State) (value : C99IntegerReference.Value)
    (profile : MknReference.Profile before)
    (source : C99ArrayReference.scalar (ready before) CertificatePrologue.guard value) : value.integer=0 := by
  have hn := ready_n before
  have hh := ready_hn before
  have hp := ready_profile before profile
  have agree : C99ExpressionEnvironment.Agree (ready before).locals
      (C99Typing.environment CertificatePrologue.completed)
      (C99ExpressionEnvironment.readNames (C99Frontend.expression CertificatePrologue.guard)) := by
    intro name member
    change name∈["logn".toList,"n".toList,"hn".toList,"ter".toList] at member
    simp only [List.mem_cons,List.not_mem_nil,or_false] at member
    rcases member with rfl | rfl | rfl | rfl
    · exact hp.1.trans CertificatePrologue.completed_logn.symm
    · exact hn.trans CertificatePrologue.completed_n.symm
    · exact hh.trans CertificatePrologue.completed_hn.symm
    · exact hp.2.trans CertificatePrologue.completed_ter.symm
  have hsource := C99ExpressionEnvironment.transport FprPrefixCalls.calls (ready before).locals
    (C99Typing.environment CertificatePrologue.completed) _ value source agree
  exact CertificatePrologue.guard_zero
    {ready before with locals := C99Typing.environment CertificatePrologue.completed} value rfl hsource

theorem tail_result (before : State) (result : Result) (profile : MknReference.Profile before)
    (source : Exec FftProcedurePrograms.program CertificatePrologue.tail (ready before) result) :
    result=⟨ready before,.normal⟩ := by
  have branch : ∀ out, Exec FftProcedurePrograms.program
      (.branch CertificatePrologue.guard CertificatePrologue.rejected CertificatePrologue.skip) (ready before) out →
      out=⟨ready before,.normal⟩ := by
    intro out h
    cases h with
    | branchTrue condition yes no entry out v checked nonzero body =>
        exact False.elim (nonzero (guard_zero before v profile checked))
    | branchFalse condition yes no entry out v checked zero body =>
        exact C99ProcedureScalars.skip_result FftProcedurePrograms.program (ready before) out body
  have ht := C99SequenceInversion.continuation FftProcedurePrograms.program _ CertificatePrologue.skip
    (ready before) (ready before) result branch source
  exact C99ProcedureScalars.skip_result FftProcedurePrograms.program (ready before) result ht

theorem source_result (before : State) (result : Result) (profile : MknReference.Profile before)
    (source : Exec FftProcedurePrograms.program CertificatePrologue.code before result) :
    result=⟨ready before,.normal⟩ := by
  obtain ⟨s1,h1,tail⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program
    (.scalar (.declare .u64 ["n".toList,"hn".toList,"u".toList])) _ before result source
  have e1 := C99DeclarationStatements.source_result .u64 _ before s1 h1
  subst s1
  obtain ⟨s2,h2,tail⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program
    (.scalar (.declare .u32 ["bad".toList])) _ (first before) result tail
  have e2 := C99DeclarationStatements.source_result .u32 _ (first before) s2 h2
  subst s2
  obtain ⟨s3,h3,tail⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program
    (.scalar (.declare .u64 ["q_squared".toList])) _ (second before) result tail
  have e3 := C99DeclarationStatements.source_result .u64 _ (second before) s3 h3
  subst s3
  obtain ⟨s4,h4,tail⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program
    (.assign "n".toList (.scalar MknReference.expression)) _ (declared before) result tail
  have e4 := C99KnownAssignment.source_result FftLeafPrograms.program "n".toList (.scalar MknReference.expression)
    (declared before) s4 .uint64 none (.uint64 1536) (declared_n before)
    (by intro v h; cases h with | scalar _ _ hs => exact MknReference.source_value (declared before) v (declared_profile before profile) hs) h4
  subst s4
  obtain ⟨s5,h5,tail⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program
    (.assign "hn".toList (.scalar halfExpression)) _ (sized before) result tail
  have e5 := C99KnownAssignment.source_result FftLeafPrograms.program "hn".toList (.scalar halfExpression)
    (sized before) s5 .uint64 none (.uint64 768) (sized_hn before)
    (by intro v h; cases h with | scalar _ _ hs => exact half_value before v hs) h5
  subst s5
  exact tail_result before result profile tail

end FT1536.Source3.CertificateEntryPrologue
