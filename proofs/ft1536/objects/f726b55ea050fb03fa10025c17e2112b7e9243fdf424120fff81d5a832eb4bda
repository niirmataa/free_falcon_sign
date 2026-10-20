import Source3.KeygenPublicReverseInvocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Both actual inverse parameter layers and ternary dispatch consume the
   SAME source-selected input; no table/seed/completed image is a premise. -/
namespace FT1536.Source3.KeygenPublicReverseCalls
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary)
open KeygenPublicInputCells (Cells)
open KeygenPublicReverseInvocation (Outcome)
open KeygenPublicInverseCalls (ternaryCall ternaryBody dispatch source_complete inverse_lookup)

theorem normal (a : Nat → KeygenPublicAlgebra.R) (p : ArrayPointer) (out : Result)
    (result : Outcome a p out) : out.flow=.normal := by
  obtain ⟨inner,⟨_,after,_,_,_,_,_,_,suffix⟩,flow,_⟩ := result
  exact flow.trans (KeygenPublicTableRows.normal _ [] KeygenPublicReverseProgram.remaining after inner
    suffix KeygenPublicReverseProgram.remaining_normal)
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
      have result := KeygenPublicReverseInvocation.source_reverse a entry inner p profile' input'
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

end FT1536.Source3.KeygenPublicReverseCalls
