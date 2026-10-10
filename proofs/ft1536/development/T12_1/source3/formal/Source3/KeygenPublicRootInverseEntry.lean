import Source3.KeygenPublicRootInversePolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The SAME retained suffix supplies exceptional r and all768 first-root
   bodies. Table disposal links remain attached to that SAME invocation. -/
namespace FT1536.Source3.KeygenPublicRootInverseEntry
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenPublicInputCells (Cells)
open KeygenPublicAlgebra (R radix)
open KeygenPublicValueExpr (Local)
open KeygenPublicReverseEntry (Header ThroughReverse reverseImage header_after)
open KeygenPublicRootInversePolynomial (inverseRoot rootImage)
open KeygenPublicRootInverseProgram (seed initU pass loop remaining)
open KeygenPublicTableControl (frame)
open KeygenPublicForwardControl (seq_inv)
open KeygenPublicForwardMemory (Block)

def ThroughRoot (a : Nat → R) (p : ArrayPointer) (out : Result) : Prop :=
  ∃ igm after,
    Header p igm after ∧ USlot after "u" 768 ∧ Local after "r" (radix*inverseRoot) ∧
    Cells after.heap p 1536 (rootImage a) ∧
    Exec KeygenPublicSource.program [] remaining after out
def Outcome (a : Nat → R) (p : ArrayPointer) (out : Result) : Prop :=
  ∃ inner, ThroughRoot a p inner ∧ out.flow=inner.flow ∧ Block inner.state.heap out.state.heap p.block

theorem source_remaining (a : Nat → R) (p igm : ArrayPointer) (s : State) (out : Result)
    (header : Header p igm s) (oldU : USlot s "u" 1536) (cells : Cells s.heap p 1536 (reverseImage a))
    (source : Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.remaining s out) : ThroughRoot a p out := by
  rw [KeygenPublicRootInverseProgram.source_remaining] at source
  obtain ⟨s1,seedExec,rest⟩ := seq_inv _ seed _ s out (by decide) source
  obtain ⟨after,passExec,suffix⟩ := seq_inv _ pass remaining s1 out (by decide) rest
  obtain ⟨entry,initExec,loopExec⟩ := seq_inv _ initU loop s1 ⟨after,.normal⟩ (by decide) passExec
  have load : KeygenPublicValueExpr.Evaluates s (.load16 "igm_square".toList (.literal .i32 0)) (radix*inverseRoot) :=
    KeygenPublicValueFrames.load_value s "igm_square" igm (.literal .i32 0) 0 _ header.fixed.square
      (fun v ev => by rw [KeygenPublicTableIndex.literal s 0 v ev]; rfl) header.fixed.table.1
  have seeded := KeygenPublicValueExpr.assign_value s ⟨s1,.normal⟩ "r" _ _ header.rType load seedExec
  have f1 := frame _ [] seed s ⟨s1,.normal⟩ (by decide) seedExec
  have seedHeader : Header p igm s1 := by
    refine ⟨KeygenPublicReverseStages.fixed_after seed s ⟨s1,.normal⟩ p igm
      (by decide) (by decide) (by decide) header.fixed seedExec,?_,?_,?_,?_,?_⟩
    · rw [f1.2.1]; exact header.cubic
    · exact (f1.2.2 _ (by decide)).trans header.profile
    · exact (f1.2.2 _ (by decide)).trans header.hn
    · obtain ⟨w,slot,_,_⟩ := seeded; exact ⟨some (.uint32 w),slot⟩
    · rw [f1.2.2 _ (by decide)]; exact header.niType
  have uType : ∃ old, s1.locals "u".toList=some (.uint64,old) :=
    ⟨some (KeygenNttLoopSupport.u64 1536),(f1.2.2 _ (by decide)).trans oldU⟩
  have state := congrArg Result.state (KeygenPublicLastEntry.assign64_result s1 ⟨entry,.normal⟩ "u" _
    (C99IntegerReference.convert .int32 0) uType (fun v ev => KeygenPublicTableAtoms.literal_value [] s1 0 v ev) initExec)
  dsimp only at state
  have entryHeader := header_after initU s1 ⟨entry,.normal⟩ p igm
    (by decide) (by decide) (by decide) (by decide) seedHeader initExec
  have root := KeygenPublicValueExpr.local_after initU s1 ⟨entry,.normal⟩ "r" _ (by decide) (by decide) seeded initExec
  have input : Cells entry.heap p 1536 (reverseImage a) := by
    rw [KeygenPublicTableControl.assign_heap _ _ _ _ initExec,KeygenPublicTableControl.assign_heap _ _ _ _ seedExec]
    exact cells
  have initial : USlot entry "u" 0 := by rw [state]; rfl
  have folded := (KeygenPublicRootInverseFold.source_loop (reverseImage a) p inverseRoot entry ⟨after,.normal⟩
    entryHeader.fixed.width entryHeader.fixed.pointer entryHeader.hn root initial input loopExec).2
  have afterHeader := header_after pass s1 ⟨after,.normal⟩ p igm
    (by decide) (by decide) (by decide) (by decide) seedHeader passExec
  exact ⟨igm,after,afterHeader,folded.counter,folded.r,folded.cells,suffix⟩

theorem refine_through (a : Nat → R) (p : ArrayPointer) (out : Result) (run : ThroughReverse a p out) : ThroughRoot a p out := by
  obtain ⟨igm,s,header,_,_,u,_,cells,source⟩ := run
  exact source_remaining a p igm s out header u cells source
theorem refine_outcome (a : Nat → R) (p : ArrayPointer) (out : Result)
    (run : KeygenPublicReverseInvocation.Outcome a p out) : Outcome a p out := by
  obtain ⟨inner,through,flow,block⟩ := run
  exact ⟨inner,refine_through a p inner through,flow,block⟩

end FT1536.Source3.KeygenPublicRootInverseEntry
