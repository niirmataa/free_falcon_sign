import Source3.KeygenPublicInverseInvocation
import Source3.KeygenPublicSuccessfulSuffix

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Bind the retained public inverse Call through both actual parameter
   layers and ternary dispatch. No intermediate table/image/seed premise. -/
namespace FT1536.Source3.KeygenPublicInverseCalls
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt chain)
open KeygenPublicTableAtoms (Slot var)
open KeygenPublicForwardWrapper (Ternary arguments)
open KeygenPublicInputCells (Cells)
open KeygenPublicInverseInvocation (Outcome)

def ternaryCall : Stmt := .call (KeygenPublicSource.name .inverseT) arguments
def ternaryBody : Stmt := .scope [] [] (chain [ternaryCall])
def binaryBody : Stmt := .scope [] [] (chain [.call (KeygenPublicSource.name .inverseB) arguments])
def dispatch : Stmt := .branch (var "ternary") ternaryBody binaryBody
def complete : Stmt := chain [dispatch]
theorem source_complete : KeygenPublicSource.code .inverse=complete := by decide
theorem inverse_lookup : KeygenPublicSource.program (KeygenPublicSource.name .inverseT)=
    some (KeygenPublicSource.function .inverseT) := by decide

theorem normal (a : Nat → KeygenPublicAlgebra.R) (p : ArrayPointer) (out : Result)
    (result : Outcome a p out) : out.flow=.normal := by
  obtain ⟨inner,⟨_,_,after,_,_,_,_,_,_,_,_,_,suffix⟩,flow,_⟩ := result
  exact flow.trans (KeygenPublicTableRows.normal _ [] KeygenPublicInverseProgram.remaining after inner
    suffix KeygenPublicInverseProgram.remaining_normal)
theorem transport (a : Nat → KeygenPublicAlgebra.R) (p : ArrayPointer) (before after : Result)
    (result : Outcome a p before) (flow : after.flow=before.flow)
    (heap : after.state.heap=before.state.heap) : Outcome a p after := by
  obtain ⟨inner,run,oldFlow,block⟩ := result
  exact ⟨inner,run,flow.trans oldFlow,by rw [heap]; exact block⟩

theorem ternary_call (a : Nat → KeygenPublicAlgebra.R) (s : State) (out : Result) (p : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some p)
    (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] ternaryCall s out) : Outcome a p out := by
  cases source with
  | call _ _ f _ entry inner lookup bound executed returned =>
      have fe := Option.some.inj (lookup.symm.trans inverse_lookup)
      subst f
      obtain ⟨heap,input',profile'⟩ := KeygenPublicFirstCalls.binding s entry p profile input bound
      have result := KeygenPublicInverseInvocation.source_triples a entry inner p profile' input'
        (by rw [heap]; exact cells) executed
      exact transport a p inner _ result (normal a p inner result).symm rfl

theorem ternary_body (a : Nat → KeygenPublicAlgebra.R) (s : State) (out : Result) (p : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some p)
    (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] ternaryBody s out) : Outcome a p out := by
  cases source with
  | scope _ _ _ _ inner executed =>
      rw [KeygenPublicForwardCall.restore_empty]
      obtain ⟨after,called,last⟩ := KeygenPublicForwardControl.seq_inv _ ternaryCall .skip s inner (by decide) executed
      cases last
      exact ternary_call a s ⟨after,.normal⟩ p profile input cells called

theorem source_dispatch (a : Nat → KeygenPublicAlgebra.R) (s : State) (out : Result) (p : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays "a".toList=some p)
    (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverse) s out) : Outcome a p out := by
  rw [source_complete] at source
  obtain ⟨middle,chosen,last⟩ := KeygenPublicForwardControl.seq_inv _ dispatch .skip s out (by decide) source
  cases last
  cases chosen with
  | branchTrue _ _ _ _ _ v guard nonzero inner =>
      exact ternary_body a s ⟨middle,.normal⟩ p profile input cells inner
  | branchFalse _ _ _ _ _ v guard zero inner =>
      rw [KeygenPublicForwardWrapper.ternary_value s v ternary guard] at zero
      contradiction

theorem source_public_call (a : Nat → KeygenPublicAlgebra.R) (s : State) (out : Result) (p : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays "h".toList=some p)
    (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicSuffixProgram.inverse s out) :
    Outcome a p out := by
  cases source with
  | call _ _ fn _ entry inner lookup bound executed returned =>
      have expected : KeygenPublicSource.program (KeygenPublicSource.name .inverse)=some (KeygenPublicSource.function .inverse) := by decide
      have equal := Option.some.inj (lookup.symm.trans expected)
      subst fn
      obtain ⟨heap,ptr,logn,ter,_⟩ := KeygenPublicInputCalls.call_binding s entry "h" p profile ternary input bound
      have result := source_dispatch a entry inner p logn ter ptr (by rw [heap]; exact cells) executed
      exact transport a p inner _ result (normal a p inner result).symm rfl

end FT1536.Source3.KeygenPublicInverseCalls
