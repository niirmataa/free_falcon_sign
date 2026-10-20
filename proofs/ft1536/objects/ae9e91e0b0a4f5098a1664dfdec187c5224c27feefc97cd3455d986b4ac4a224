import Source3.CertificateGramPrefix
import Source3.C99AliasSequence
import Source3.C99KnownAssignment
import Source3.C99VariablePointer
import Source3.C99SequenceInversion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateTailMetadata
open C99ArrayReference (State bindPointer bindValue)
open C99ProcedureReference (Stmt Exec Result)
open CertificateAfterConversion (workspacePointer)

def treeAlias : C99AliasSequence.Alias := ⟨"tree".toList,"gxx".toList,true⟩
def sizeExpression : CLogic.Expr := .bin .mul (.cast .u64 (.literal .i32 12)) (.var "n".toList)
def sizeAssignment : C99ArrayReference.Stmt := .assign "treesize".toList (.scalar sizeExpression)
def scratchAssignment : C99ArrayReference.Stmt := .bindPtr "t3".toList "tree".toList (.var "treesize".toList)
def zero : CLogic.Expr := .literal .u64 0
def ldlCall : Stmt := .call "ffLDL_fft3_keygen".toList
  [.pointer "tree".toList zero,.pointer "g00".toList zero,.pointer "g10".toList zero,
   .pointer "g11".toList zero,.scalar (.var "logn".toList),.pointer "t3".toList zero] .discard
def finish : Stmt := .seq ldlCall (.base .skip)
def code : Stmt := .seq (C99AliasSequence.statement treeAlias)
  (.seq (.base sizeAssignment) (.seq (.base scratchAssignment) finish))
def afterTree (base : Nat) (before : State) : State := bindPointer before "tree".toList (workspacePointer base 8)
def afterSize (base : Nat) (before : State) : State := bindValue (afterTree base before) "treesize".toList .uint64 (.uint64 18432)
def ready (base : Nat) (before : State) : State := bindPointer (afterSize base before) "t3".toList (workspacePointer base 20)

theorem source_bound : CertificateGramPrefix.tailCode=code := by decide
theorem finish_checked : C99HeapOnly.only finish=true := by decide

theorem tree_result (base : Nat) (before : State) (result : Result)
    (hn : C99AliasSequence.HasN before)
    (gxx : before.arrays "gxx".toList=some (workspacePointer base 7))
    (source : Exec FftProcedurePrograms.program (C99AliasSequence.statement treeAlias) before result) :
    result=⟨afterTree base before,.normal⟩ := by
  obtain ⟨he,hf,_⟩ := C99AliasSequence.step_complete FftProcedurePrograms.program treeAlias before result hn source
  have hm : C99AliasSequence.evaluate treeAlias before=some (afterTree base before) := by
    change before.arrays ['g','x','x']=some (workspacePointer base 7) at gxx
    simp [C99AliasSequence.evaluate,treeAlias,C99AliasSequence.amount,C99AliasSequence.advance,
      workspacePointer,afterTree,gxx]
  rw [hm] at he
  have hs : result.state=afterTree base before := (Option.some.inj he).symm
  cases result
  cases hs
  cases hf
  rfl

theorem size_value (before : State) (value : C99IntegerReference.Value)
    (hn : C99AliasSequence.HasN before)
    (source : C99ArrayReference.scalar before sizeExpression value) : value=.uint64 18432 := by
  change C99ScalarReference.Eval _ _
    (.arithmetic .times (.cast .uint64 (.literal .int32 12)) (.variable "n".toList)) value at source
  cases source with
  | arithmetic op a b x y z hx hy operation =>
      cases hx with
      | cast _ _ v h =>
          cases h
          have hnValue := C99CountedWords.variable_exact before "n".toList .uint64 (.uint64 1536) y hn hy
          subst y
          have he := ((C99IntegerReference.arithmetic_iff _ _ _ _).mp operation).2
          exact he

theorem size_result (base : Nat) (before after : State)
    (hn : C99AliasSequence.HasN before)
    (slot : before.locals "treesize".toList=some (.uint64,none))
    (source : C99ArrayReference.Exec FftLeafPrograms.program sizeAssignment (afterTree base before) after) :
    after=afterSize base before :=
  C99KnownAssignment.source_result FftLeafPrograms.program "treesize".toList (.scalar sizeExpression)
    (afterTree base before) after .uint64 none (.uint64 18432) slot
    (by intro v h; cases h with | scalar _ _ h => exact size_value (afterTree base before) v hn h) source

theorem scratch_result (base : Nat) (before after : State)
    (source : C99ArrayReference.Exec FftLeafPrograms.program scratchAssignment (afterSize base before) after) :
    after=ready base before := by
  cases source with
  | bindPtr entry name src index p address =>
      have ht : (afterSize base before).arrays "tree".toList=some (workspacePointer base 8) := by
        simp [afterSize,afterTree,bindValue,bindPointer]
      have hn : (afterSize base before).locals "treesize".toList=some (.uint64,some (.uint64 (BitVec.ofNat 64 18432))) := by
        simp [afterSize,bindValue,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]
      have hp := (C99VariablePointer.source_value (afterSize base before) "tree".toList "treesize".toList
        (workspacePointer base 8) p 18432 (by decide) ht hn address).1
      rw [hp]
      rfl

theorem source_result (base : Nat) (before : State) (result : Result)
    (hn : C99AliasSequence.HasN before)
    (gxx : before.arrays "gxx".toList=some (workspacePointer base 7))
    (slot : before.locals "treesize".toList=some (.uint64,none))
    (source : Exec FftProcedurePrograms.program CertificateGramPrefix.tailCode before result) :
    result=⟨{ready base before with heap := result.state.heap},.normal⟩ := by
  rw [source_bound] at source
  have rest := C99SequenceInversion.continuation FftProcedurePrograms.program
    (C99AliasSequence.statement treeAlias) _ before (afterTree base before) result
    (fun out h => tree_result base before out hn gxx h) source
  obtain ⟨sized,hs,rest⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program sizeAssignment _
    (afterTree base before) result rest
  have he := size_result base before sized hn slot hs
  subst sized
  obtain ⟨scratch,hs,rest⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program scratchAssignment finish
    (afterSize base before) result rest
  have he := scratch_result base before scratch hs
  subst scratch
  exact C99HeapOnly.result_frame FftProcedurePrograms.program finish (ready base before) result rest finish_checked

end FT1536.Source3.CertificateTailMetadata
