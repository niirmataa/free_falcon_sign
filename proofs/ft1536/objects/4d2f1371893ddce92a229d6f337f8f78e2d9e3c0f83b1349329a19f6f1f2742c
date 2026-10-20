import Source3.KeygenPublicFirstInvocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Consume the same ordinary input cells across the two actual parameter
   bindings: mq_NTT and its selected mq_NTT_ternary call. -/
namespace FT1536.Source3.KeygenPublicFirstCalls
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary arguments ternaryCall ternaryBody dispatch)
open KeygenPublicInputCells (Cells)
open KeygenPublicInputMaterial (reduced)
open KeygenPublicFirstInvocation (Outcome)

theorem normal (original : Geometry.Vec) (a : ArrayPointer) (out : Result)
    (result : Outcome original a out) : out.flow=.normal := by
  obtain ⟨inner,⟨_,after,_,_,_,suffix⟩,flow,_⟩ := result
  exact flow.trans (KeygenPublicTableControl.frame _ [] KeygenPublicFirstValues.remaining after inner (by decide) suffix).1

theorem transport (original : Geometry.Vec) (a : ArrayPointer) (before after : Result)
    (result : Outcome original a before) (flow : after.flow=before.flow)
    (heap : after.state.heap=before.state.heap) : Outcome original a after := by
  obtain ⟨inner,run,oldFlow,block⟩ := result
  exact ⟨inner,run,flow.trans oldFlow,by rw [heap]; exact block⟩

theorem binding (before entry : State) (a : ArrayPointer)
    (profile : Slot before "logn" 10) (input : before.arrays "a".toList=some a)
    (source : KeygenPublicWord.Bind before (KeygenPublicSource.params .forwardT) arguments entry) :
    entry.heap=before.heap ∧ entry.arrays "a".toList=some a ∧ Slot entry "logn" 10 := by
  cases source with
  | pointer _ _ _ actual _ _ _ address rest =>
      cases rest with
      | scalar _ _ _ _ _ _ value evaluated rest =>
          cases rest
          have pe := KeygenPublicTableIndex.address before "a" C99ProcedureParser.zero a actual 0 input
            (KeygenPublicForwardCall.zero_value before) address
          have zero : KeygenSmallOutput.element a 0=a := by simp only [KeygenSmallOutput.element,Nat.add_zero]
          rw [zero] at pe
          have ve := KeygenPublicTableAtoms.variable_value [] before "logn" 10 value profile (.scalar _ _ evaluated)
          subst actual; subst value
          exact ⟨rfl,rfl,rfl⟩

theorem ternary_call (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] ternaryCall s out) : Outcome original a out := by
  cases source with
  | call _ _ f _ entry inner lookup bound executed returned =>
      have fe := Option.some.inj (lookup.symm.trans KeygenPublicForwardWrapper.forward_lookup)
      subst f
      obtain ⟨heap,input',profile'⟩ := binding s entry a profile input bound
      have result := KeygenPublicFirstInvocation.source_first original entry inner a profile' input'
        (by rw [heap]; exact cells) executed
      exact transport original a inner _ result (normal original a inner result).symm rfl

theorem ternary_body (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] ternaryBody s out) : Outcome original a out := by
  cases source with
  | scope _ _ _ _ inner executed =>
      rw [KeygenPublicForwardCall.restore_empty]
      obtain ⟨after,called,last⟩ := KeygenPublicForwardControl.seq_inv _ ternaryCall .skip s inner (by decide) executed
      cases last
      exact ternary_call original s ⟨after,.normal⟩ a profile input cells called

theorem source_dispatch (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays "a".toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forward) s out) : Outcome original a out := by
  rw [KeygenPublicForwardWrapper.source_complete] at source
  obtain ⟨middle,chosen,last⟩ := KeygenPublicForwardControl.seq_inv _ dispatch .skip s out (by decide) source
  cases last
  cases chosen with
  | branchTrue _ _ _ _ _ v guard nonzero inner =>
      exact ternary_body original s ⟨middle,.normal⟩ a profile input cells inner
  | branchFalse _ _ _ _ _ v guard zero inner =>
      rw [KeygenPublicForwardWrapper.ternary_value s v ternary guard] at zero
      contradiction

def call (name : String) : KeygenPublicExec.Stmt := .call (KeygenPublicSource.name .forward)
  [.pointer name.toList C99ProcedureParser.zero,.scalar (.var "logn".toList),.scalar (.var "ternary".toList)]

theorem source_call (original : Geometry.Vec) (s : State) (out : Result) (name : String) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays name.toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed (call name) s out) :
    Outcome original a out := by
  cases source with
  | call _ _ fn _ entry inner lookup bound executed returned =>
      have expected : KeygenPublicSource.program (KeygenPublicSource.name .forward)=some (KeygenPublicSource.function .forward) := by decide
      have equal := Option.some.inj (lookup.symm.trans expected)
      subst fn
      obtain ⟨heap,ptr,logn,ter,_⟩ := KeygenPublicInputCalls.call_binding s entry name a profile ternary input bound
      have result := source_dispatch original entry inner a logn ter ptr (by rw [heap]; exact cells) executed
      exact transport original a inner _ result (normal original a inner result).symm rfl

theorem both (s afterH afterT : State) (p : KeygenPublicInputLoop.Pointers) (f g : Geometry.Vec)
    (inv : KeygenPublicInputLoop.Invariant p (KeygenPublicInputMaterial.coefficient f) (KeygenPublicInputMaterial.coefficient g) 1536 s)
    (layout : KeygenPublicInputLoop.Layout p) (profile : Slot s "logn" 10) (ternary : Ternary s)
    (tables : KeygenPublicFrame.Tables s p.t.block)
    (hExec : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicInputProgram.hForward s ⟨afterH,.normal⟩)
    (tExec : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicInputProgram.tForward afterH ⟨afterT,.normal⟩) :
    Outcome g p.h ⟨afterH,.normal⟩ ∧ Outcome f p.t ⟨afterT,.normal⟩ := by
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

end FT1536.Source3.KeygenPublicFirstCalls
