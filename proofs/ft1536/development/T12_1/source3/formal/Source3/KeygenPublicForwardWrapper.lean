import Source3.KeygenPublicForwardRange

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual mq_NTT dispatch and its parameter-bound ternary call. Callee
   residue locals come from the caller's globals, not from arbitrary saved
   caller locals. Canonical input cells remain an explicit conversion seam;
   no evaluation, nonzero or public equation is assumed or concluded. -/
namespace FT1536.Source3.KeygenPublicForwardWrapper
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt chain)
open KeygenPublicTableAtoms (Slot var)
open KeygenPublicRangeMemory (Domain Initialized Image)
open KeygenPublicRangeExpr (Locals)
open KeygenPublicForwardProgram (residueNames)

def arguments : List C99ArrayReference.Arg := [.pointer "a".toList C99ProcedureParser.zero,
  .scalar (.var "logn".toList)]
def ternaryCall : Stmt := .call (KeygenPublicSource.name .forwardT) arguments
def ternaryBody : Stmt := .scope [] [] (chain [ternaryCall])
def binaryBody : Stmt := .scope [] [] (chain [.call (KeygenPublicSource.name .forwardB) arguments])
def dispatch : Stmt := .branch (var "ternary") ternaryBody binaryBody
def complete : Stmt := chain [dispatch]
def Ternary (s : State) : Prop := s.locals "ternary".toList=some (.int32,some (.int32 1))

theorem source_complete : KeygenPublicSource.code .forward=complete := by decide
theorem forward_lookup : KeygenPublicSource.program (KeygenPublicSource.name .forwardT)=
    some (KeygenPublicSource.function .forwardT) := by decide

theorem binding_entry (before entry : State) (a : ArrayPointer)
    (profile : Slot before "logn" 10) (input : before.arrays "a".toList=some a)
    (globals : Locals residueNames before.globals)
    (binding : KeygenPublicWord.Bind before (KeygenPublicSource.params .forwardT) arguments entry) :
    entry.heap=before.heap ∧ entry.arrays "a".toList=some a ∧ Slot entry "logn" 10 ∧
      Locals residueNames entry.locals := by
  cases binding with
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
          refine ⟨rfl,rfl,rfl,?_⟩
          exact KeygenPublicRangeExec.locals_bound residueNames
            ⟨before.heap,before.globals,before.tables,before.globals,before.tables⟩ "logn".toList .uint32 (.uint32 10)
            globals (fun member => (show "logn".toList∉residueNames from by decide) member |>.elim)

theorem call_canonical (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (globals : Locals residueNames s.globals) (range : Domain s.heap a)
    (initialized : Initialized s.heap a 1536)
    (source : Exec KeygenPublicSource.program [] ternaryCall s out) :
    out.flow=.normal ∧ Domain out.state.heap a ∧ Image out.state.heap a 1536 := by
  cases source with
  | call _ _ f _ entry inner lookup binding executed returned =>
      have fe := Option.some.inj (lookup.symm.trans forward_lookup)
      subst f
      obtain ⟨heap,input',profile',locals⟩ := binding_entry s entry a profile input globals binding
      obtain ⟨_,outputRange,outputImage⟩ := KeygenPublicForwardRange.source_canonical entry inner a profile' input' locals
        (by rw [heap]; exact range) (by rw [heap]; exact initialized) executed
      exact ⟨rfl,outputRange,outputImage⟩

theorem ternary_value (s : State) (v : C99IntegerReference.Value) (profile : Ternary s)
    (source : KeygenPublicWord.Eval [] s (var "ternary") v) : v=.int32 1 := by
  cases source
  cases ‹KeygenPublicWord.scalar _ _ _› with
  | «variable» _ _ _ binding =>
      exact Option.some.inj (congrArg Prod.snd (Option.some.inj (binding.symm.trans profile)))

theorem ternary_body_canonical (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (globals : Locals residueNames s.globals) (range : Domain s.heap a)
    (initialized : Initialized s.heap a 1536)
    (source : Exec KeygenPublicSource.program [] ternaryBody s out) :
    out.flow=.normal ∧ Domain out.state.heap a ∧ Image out.state.heap a 1536 := by
  cases source with
  | scope _ _ _ _ inner executed =>
      rw [KeygenPublicForwardCall.restore_empty]
      obtain ⟨after,called,last⟩ := KeygenPublicForwardControl.seq_inv _ ternaryCall .skip s inner (by decide) executed
      cases last
      exact call_canonical s ⟨after,.normal⟩ a profile input globals range initialized called

theorem source_forward_canonical (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays "a".toList=some a)
    (globals : Locals residueNames s.globals) (range : Domain s.heap a)
    (initialized : Initialized s.heap a 1536)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forward) s out) :
    out.flow=.normal ∧ Domain out.state.heap a ∧ Image out.state.heap a 1536 := by
  rw [source_complete] at source
  obtain ⟨middle,chosen,last⟩ := KeygenPublicForwardControl.seq_inv _ dispatch .skip s out (by decide) source
  cases last
  cases chosen with
  | branchTrue _ _ _ _ _ v guard nonzero inner =>
      exact ternary_body_canonical s ⟨middle,.normal⟩ a profile input globals range initialized inner
  | branchFalse _ _ _ _ _ v guard zero inner =>
      rw [ternary_value s v ternary guard] at zero
      contradiction

theorem domain_of_image (heap : C99MemoryReference.Memory) (a : ArrayPointer)
    (extent : a.count≤a.index+1536) (input : Image heap a 1536) : Domain heap a := by
  intro i w read
  have allocated := (KeygenPublicRangeMemory.load_allocated _ _ _ read).1
  have bound : i<1536 := by
    have within := allocated.2.2.1
    change a.index+i<a.count at within
    omega
  obtain ⟨old,loaded,range⟩ := input i bound
  rw [C99NarrowReads.load16_deterministic _ _ _ _ read loaded]
  exact range

theorem source_forward_image (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays "a".toList=some a)
    (globals : Locals residueNames s.globals) (extent : a.count≤a.index+1536)
    (cells : Image s.heap a 1536)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forward) s out) :
    out.flow=.normal ∧ Image out.state.heap a 1536 := by
  have initialized : Initialized s.heap a 1536 := by
    intro i hi
    obtain ⟨w,read,_⟩ := cells i hi
    exact ⟨w,read⟩
  have result := source_forward_canonical s out a profile ternary input globals
    (domain_of_image s.heap a extent cells) initialized source
  exact ⟨result.1,result.2.2⟩

end FT1536.Source3.KeygenPublicForwardWrapper
