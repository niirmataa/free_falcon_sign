import Source3.KeygenPublicEvaluation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original-polynomial conclusion crosses both actual source Call/Bind
   layers and the selected ternary dispatch. -/
namespace FT1536.Source3.KeygenPublicEvaluationCalls
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary ternaryCall ternaryBody dispatch)
open KeygenPublicInputCells (Cells)
open KeygenPublicInputMaterial (reduced)
open KeygenPublicEvaluation (Evaluations)

theorem ternary_call (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] ternaryCall s out) : Evaluations out.state.heap a original := by
  cases source with
  | call _ _ f _ entry inner lookup bound executed returned =>
      have fe := Option.some.inj (lookup.symm.trans KeygenPublicForwardWrapper.forward_lookup)
      subst f
      obtain ⟨heap,input',profile'⟩ := KeygenPublicFirstCalls.binding s entry a profile input bound
      exact (KeygenPublicEvaluation.source_complete original entry inner a profile' input'
        (by rw [heap]; exact cells) executed).2

theorem ternary_body (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] ternaryBody s out) : Evaluations out.state.heap a original := by
  cases source with
  | scope _ _ _ _ inner executed =>
      rw [KeygenPublicForwardCall.restore_empty]
      obtain ⟨after,called,last⟩ := KeygenPublicForwardControl.seq_inv _ ternaryCall .skip s inner (by decide) executed
      cases last
      exact ternary_call original s ⟨after,.normal⟩ a profile input cells called

theorem source_dispatch (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays "a".toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forward) s out) : Evaluations out.state.heap a original := by
  rw [KeygenPublicForwardWrapper.source_complete] at source
  obtain ⟨middle,chosen,last⟩ := KeygenPublicForwardControl.seq_inv _ dispatch .skip s out (by decide) source
  cases last
  cases chosen with
  | branchTrue _ _ _ _ _ v guard nonzero inner =>
      exact ternary_body original s ⟨middle,.normal⟩ a profile input cells inner
  | branchFalse _ _ _ _ _ v guard zero inner =>
      rw [KeygenPublicForwardWrapper.ternary_value s v ternary guard] at zero
      contradiction

theorem source_call (original : Geometry.Vec) (s : State) (out : Result) (name : String) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays name.toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed (KeygenPublicFirstCalls.call name) s out) :
    Evaluations out.state.heap a original := by
  cases source with
  | call _ _ fn _ entry inner lookup bound executed returned =>
      have expected : KeygenPublicSource.program (KeygenPublicSource.name .forward)=some (KeygenPublicSource.function .forward) := by decide
      have equal := Option.some.inj (lookup.symm.trans expected)
      subst fn
      obtain ⟨heap,ptr,logn,ter,_⟩ := KeygenPublicInputCalls.call_binding s entry name a profile ternary input bound
      exact source_dispatch original entry inner a logn ter ptr (by rw [heap]; exact cells) executed

theorem both (s afterH afterT : State) (p : KeygenPublicInputLoop.Pointers) (f g : Geometry.Vec)
    (inv : KeygenPublicInputLoop.Invariant p (KeygenPublicInputMaterial.coefficient f) (KeygenPublicInputMaterial.coefficient g) 1536 s)
    (layout : KeygenPublicInputLoop.Layout p) (profile : Slot s "logn" 10) (ternary : Ternary s)
    (tables : KeygenPublicFrame.Tables s p.t.block)
    (hExec : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicInputProgram.hForward s ⟨afterH,.normal⟩)
    (tExec : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicInputProgram.tForward afterH ⟨afterT,.normal⟩) :
    Evaluations afterH.heap p.h g ∧ Evaluations afterT.heap p.t f := by
  have hResult := source_call g s ⟨afterH,.normal⟩ "h" p.h profile ternary inv.fixed.h inv.h hExec
  have live := KeygenPublicForwardMemory.initialized_live s.heap p.t
    (KeygenPublicFirstInvocation.initialized _ _ f inv.t)
  have same := KeygenPublicInputCalls.forward_other s ⟨afterH,.normal⟩ p.h p.t inv.fixed.h
    (Ne.symm layout.different) tables live hExec
  have tCells := KeygenPublicFirstTables.cells_block s.heap afterH.heap p.t 1536 (reduced f)
    ⟨congrFun same.1 p.t.block,same.2.2⟩ inv.t
  have locals : afterH.locals=s.locals := by cases hExec; rfl
  have arrays : afterH.arrays=s.arrays := by cases hExec; rfl
  exact ⟨hResult,source_call f afterH ⟨afterT,.normal⟩ "t" p.t
    (by unfold Slot; rw [locals]; exact profile) (by unfold Ternary; rw [locals]; exact ternary)
    (by rw [arrays]; exact inv.fixed.t) tCells tExec⟩

end FT1536.Source3.KeygenPublicEvaluationCalls
