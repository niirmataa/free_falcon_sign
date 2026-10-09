import Source3.KeygenPublicInputSetup

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The SAME conversion prefix supplies both actual mq_NTT caller domains.
   These source conclusions are ranges, not polynomial evaluations. -/
namespace FT1536.Source3.KeygenPublicInputCalls
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicInputProgram (signed append setup conversion hForward tForward hArgs tArgs)
open KeygenPublicInputLoop (Pointers Layout Invariant)
open KeygenPublicInputCells (Signed TailEmpty Cells)
open KeygenPublicRangeMemory (Domain Image)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary)

def inputPrefix : Stmt := append setup conversion
def forwards : Stmt := .seq hForward (.seq tForward .skip)
def convertedForward : Stmt := append setup (.seq conversion forwards)
def remaining : Stmt := .seq hForward (.seq tForward KeygenPublicInputProgram.suffix)
def Globals (s : State) : Prop := s.globals=fun _ => none

theorem complete_seam : KeygenPublicInputProgram.completeReady=append setup (.seq conversion remaining) := by decide
theorem prefix_supported : KeygenPublicTableControl.supported inputPrefix=true := by decide

theorem normal_seq_inv (a b : Stmt) (s : State) (out : Result)
    (ok : KeygenPublicTableRows.noReturn a=true)
    (source : Exec KeygenPublicSource.program signed (.seq a b) s out) :
    ∃ middle, Exec KeygenPublicSource.program signed a s ⟨middle,.normal⟩ ∧
      Exec KeygenPublicSource.program signed b middle out := by
  cases source with
  | seqNormal _ _ _ middle _ first second => exact ⟨middle,first,second⟩
  | seqExit _ _ _ _ first exit => exact (exit (KeygenPublicTableRows.normal _ _ _ _ _ first ok)).elim

theorem append_inv (a : Stmt) (s : State) (out : Result) (tail : Stmt)
    (ok : KeygenPublicTableControl.supported a=true)
    (source : Exec KeygenPublicSource.program signed (append a tail) s out) :
    ∃ middle, Exec KeygenPublicSource.program signed a s ⟨middle,.normal⟩ ∧
      Exec KeygenPublicSource.program signed tail middle out := by
  induction a generalizing s with
  | skip => exact ⟨s,.skip s,source⟩
  | seq a b ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp ok
      obtain ⟨afterA,first,rest⟩ := KeygenPublicInputAtoms.seq_inv signed a (append b tail) s out ha source
      obtain ⟨afterB,second,last⟩ := ih2 afterA hb rest
      exact ⟨afterB,.seqNormal _ _ _ _ _ first second,last⟩
  | scalar | assign | declarePointer | pointer | store | call | scope | arrayScope | branch | loop | ret =>
      exact KeygenPublicInputAtoms.seq_inv signed _ tail s out ok source

theorem globals_preserved (sgn : List Name) (code : Stmt) (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program sgn code s out) : out.state.globals=s.globals := by
  induction source with
  | skip | scalar | assign | declarePointer | pointer | store | call | loopFalse | ret | retVoid => rfl
  | seqNormal _ _ _ _ _ _ _ ih1 ih2 => exact ih2.trans ih1
  | seqExit _ _ _ _ _ _ ih => exact ih
  | scope _ _ _ _ _ _ ih => exact ih
  | arrayScope _ _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih
  | loopNormal _ _ _ _ _ _ _ _ _ _ _ _ _ ih1 ih2 ih3 => exact ih3.trans (ih2.trans ih1)
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih => exact ih

theorem global_range (s : State) (globals : Globals s) :
    KeygenPublicRangeExpr.Locals KeygenPublicForwardProgram.residueNames s.globals := by
  intro n member ty v binding
  rw [globals] at binding
  contradiction

theorem prefix_result (s : State) (out : Result) (p : Pointers) (f g : Nat → Int)
    (layout : Layout p) (profile : Slot s "logn" 10) (ternary : Ternary s)
    (arrays : s.arrays "f".toList=some p.f ∧ s.arrays "g".toList=some p.g ∧
      s.arrays "t".toList=some p.t ∧ s.arrays "h".toList=some p.h)
    (inputF : Signed s.heap p.f f) (inputG : Signed s.heap p.g g) (tail : TailEmpty s.heap p.t)
    (oldN oldU : Option C99IntegerReference.Value)
    (n : s.locals "n".toList=some (.uint64,oldN)) (u : s.locals "u".toList=some (.uint64,oldU))
    (source : Exec KeygenPublicSource.program signed inputPrefix s out) :
    out.flow=.normal ∧ Invariant p f g 1536 out.state ∧ Slot out.state "logn" 10 ∧ Ternary out.state := by
  obtain ⟨ready,setupExec,convertExec⟩ := append_inv setup s out conversion
    (by rw [KeygenPublicInputSetup.source_complete]; exact KeygenPublicInputSetup.supported) source
  obtain ⟨_,heap,fixed⟩ := KeygenPublicInputSetup.source_setup s ⟨ready,.normal⟩ p profile ternary arrays oldN n setupExec
  have counter : ready.locals "u".toList=some (.uint64,oldU) :=
    (KeygenPublicTableControl.frame _ _ setup s ⟨ready,.normal⟩ (by decide) setupExec).2.2 _ (by decide) |>.trans u
  obtain ⟨flow,inv⟩ := KeygenPublicInputMaterial.source_conversion ready out p f g layout fixed
    (by rw [heap]; exact inputF) (by rw [heap]; exact inputG) (by rw [heap]; exact tail) oldU counter convertExec
  have frame := KeygenPublicTableControl.frame _ _ inputPrefix s out prefix_supported source
  exact ⟨flow,inv,(frame.2.2 _ (by decide)).trans profile,(frame.2.2 _ (by decide)).trans ternary⟩

theorem call_binding (s entry : State) (name : String) (p : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays name.toList=some p)
    (binding : KeygenPublicWord.Bind s (KeygenPublicSource.params .forward)
      [.pointer name.toList C99ProcedureParser.zero,.scalar (.var "logn".toList),.scalar (.var "ternary".toList)] entry) :
    entry.heap=s.heap ∧ entry.arrays "a".toList=some p ∧ Slot entry "logn" 10 ∧ Ternary entry ∧ entry.globals=s.globals := by
  cases binding with
  | pointer _ _ _ actual _ _ _ address rest =>
      cases rest with
      | scalar _ _ _ _ _ _ lv lognEval rest =>
          cases rest with
          | scalar _ _ _ _ _ _ tv ternaryEval rest =>
              cases rest
              have pe := KeygenPublicTableIndex.address s name C99ProcedureParser.zero p actual 0 input
                (KeygenPublicForwardCall.zero_value s) address
              have zero : KeygenSmallOutput.element p 0=p := by simp only [KeygenSmallOutput.element,Nat.add_zero]
              rw [zero] at pe
              have le := KeygenPublicTableAtoms.variable_value signed s "logn" 10 lv profile (.scalar _ _ lognEval)
              have te := KeygenPublicInputSetup.ternary_value s tv ternary (.scalar _ _ ternaryEval)
              subst actual; subst lv; subst tv
              exact ⟨rfl,rfl,rfl,rfl,rfl⟩

theorem source_call_canonical (s : State) (out : Result) (name : String) (p : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays name.toList=some p)
    (globals : Globals s) (range : Domain s.heap p) (cells : Image s.heap p 1536)
    (source : Exec KeygenPublicSource.program signed (.call (KeygenPublicSource.name .forward)
      [.pointer name.toList C99ProcedureParser.zero,.scalar (.var "logn".toList),.scalar (.var "ternary".toList)]) s out) :
    out.flow=.normal ∧ Domain out.state.heap p ∧ Image out.state.heap p 1536 := by
  cases source with
  | call _ _ fn _ entry inner lookup binding executed returned =>
      have expected : KeygenPublicSource.program (KeygenPublicSource.name .forward)=some (KeygenPublicSource.function .forward) := by decide
      have equal := Option.some.inj (lookup.symm.trans expected)
      subst fn
      obtain ⟨heap,ptr,logn,ter,global⟩ := call_binding s entry name p profile ternary input binding
      obtain ⟨flow,outputDomain,outputCells⟩ := KeygenPublicForwardWrapper.source_forward_canonical entry inner p logn ter ptr
        (global_range entry (global.trans globals)) (by rw [heap]; exact range)
        (by intro i hi; obtain ⟨w,read,_⟩ := cells i hi; exact ⟨w,by rw [heap]; exact read⟩) executed
      exact ⟨rfl,outputDomain,outputCells⟩

theorem forward_other (s : State) (out : Result) (target saved : ArrayPointer)
    (binding : s.arrays "h".toList=some target) (different : target.block≠saved.block)
    (tables : KeygenPublicFrame.Tables s saved.block) (live : 0<s.heap.size saved.block)
    (source : Exec KeygenPublicSource.program signed hForward s out) :
    ShakeExtractFrame.SameBlock s.heap out.state.heap saved.block := by
  apply (KeygenPublicFrame.body KeygenPublicSource.program KeygenPublicSource.signatures KeygenPublicSource.permissions
    KeygenPublicSource.aligned KeygenPublicSource.closed signed hForward s out source ["h".toList] (by decide)
    saved.block ?_ tables live).2.2
  intro n member p bound
  have equal := List.mem_singleton.mp member
  subst n
  have pe := Option.some.inj (bound.symm.trans binding)
  subst p
  exact different

theorem source_both_forward (s : State) (out : Result) (p : Pointers) (f g : Nat → Int)
    (inv : Invariant p f g 1536 s) (layout : Layout p) (profile : Slot s "logn" 10) (ternary : Ternary s)
    (globals : Globals s) (hExtent : p.h.count≤p.h.index+1536) (tables : KeygenPublicFrame.Tables s p.t.block)
    (hTables : KeygenPublicFrame.Tables s p.h.block)
    (source : Exec KeygenPublicSource.program signed forwards s out) :
    out.flow=.normal ∧ Image out.state.heap p.t 1536 ∧ Image out.state.heap p.h 1536 := by
  obtain ⟨middle,hExec,rest⟩ := normal_seq_inv hForward _ s out (by decide) source
  obtain ⟨last,tExec,done⟩ := normal_seq_inv tForward .skip middle out (by decide) rest
  cases done
  have hCells := KeygenPublicInputCells.image _ _ _ inv.h
  have tCells := KeygenPublicInputCells.image _ _ _ inv.t
  obtain ⟨_,_,hImage⟩ := source_call_canonical s ⟨middle,.normal⟩ "h" p.h profile ternary inv.fixed.h globals
    (KeygenPublicForwardWrapper.domain_of_image _ _ hExtent hCells) hCells hExec
  have live := KeygenPublicForwardMemory.initialized_live s.heap p.t
    (by intro i hi; obtain ⟨w,read,_⟩ := tCells i hi; exact ⟨w,read⟩)
  have same := forward_other s ⟨middle,.normal⟩ p.h p.t inv.fixed.h (Ne.symm layout.different) tables live hExec
  have tDomain := KeygenPublicRangeMemory.domain_same_block _ _ p.t same (KeygenPublicInputCells.domain _ _ _ inv.t inv.tail)
  have tInitialized := KeygenPublicRangeMemory.initialized_same_block _ _ p.t 1536 same
    (by intro i hi; obtain ⟨w,read,_⟩ := tCells i hi; exact ⟨w,read⟩)
  have locals : middle.locals=s.locals := by cases hExec; rfl
  have arrays : middle.arrays=s.arrays := by cases hExec; rfl
  obtain ⟨_,_,tImage⟩ := source_call_canonical middle ⟨last,.normal⟩ "t" p.t
    (by unfold Slot; rw [locals]; exact profile)
    (by unfold Ternary; rw [locals]; exact ternary) (by rw [arrays]; exact inv.fixed.t)
    (by rw [Globals,globals_preserved signed hForward s ⟨middle,.normal⟩ hExec]; exact globals)
    tDomain (KeygenPublicRangeMemory.image _ _ _ tDomain tInitialized) tExec
  have hKeep : ShakeExtractFrame.SameBlock middle.heap last.heap p.h.block := by
    apply (KeygenPublicFrame.body KeygenPublicSource.program KeygenPublicSource.signatures KeygenPublicSource.permissions
      KeygenPublicSource.aligned KeygenPublicSource.closed signed tForward middle ⟨last,.normal⟩ tExec ["t".toList] (by decide)
      p.h.block ?_ ?_ ?_).2.2
    · intro n member a bound
      have eq := List.mem_singleton.mp member
      subst n
      have pe := Option.some.inj (bound.symm.trans (by rw [arrays]; exact inv.fixed.t))
      subst a; exact layout.different
    · intro n a binding
      have prior := binding
      have tableEq : middle.tables=s.tables := by cases hExec; rfl
      rw [tableEq] at prior
      exact hTables n a prior
    · exact KeygenPublicForwardMemory.initialized_live middle.heap p.h
        (by intro i hi; obtain ⟨w,read,_⟩ := hImage i hi; exact ⟨w,read⟩)
  have hDomain := KeygenPublicRangeMemory.domain_same_block _ _ p.h hKeep
    (KeygenPublicForwardWrapper.domain_of_image _ _ hExtent hImage)
  have hInitialized := KeygenPublicRangeMemory.initialized_same_block _ _ p.h 1536 hKeep
    (by intro i hi; obtain ⟨w,read,_⟩ := hImage i hi; exact ⟨w,read⟩)
  exact ⟨rfl,tImage,KeygenPublicRangeMemory.image _ _ _ hDomain hInitialized⟩

end FT1536.Source3.KeygenPublicInputCalls
