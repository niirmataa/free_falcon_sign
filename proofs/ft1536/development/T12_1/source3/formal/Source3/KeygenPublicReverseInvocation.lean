import Source3.KeygenPublicReverseEntry

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The SAME full inverse invocation derives all reverse domains/images.
   Both automatic table disposals still connect to its observed output. -/
namespace FT1536.Source3.KeygenPublicReverseInvocation
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec localPointer localEntry localExit)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicInverseProgram
open KeygenPublicForwardControl (seq_inv)
open KeygenPublicReverseEntry (Types ThroughReverse ready_stages)
open KeygenPublicFirstTables (cells_block)
open KeygenPublicInputCells (Cells)
open KeygenPublicForwardMemory (Block)

def Outcome (a : Nat → KeygenPublicAlgebra.R) (p : ArrayPointer) (out : Result) : Prop :=
  ∃ inner, ThroughReverse a p inner ∧ out.flow=inner.flow ∧ Block inner.state.heap out.state.heap p.block

theorem source_reverse (a : Nat → KeygenPublicAlgebra.R) (s : State) (out : Result) (p : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some p)
    (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverseT) s out) : Outcome a p out := by
  rw [source_complete] at source
  obtain ⟨s1,d1,rest1⟩ := seq_inv _ declareDimensions _ s out (by decide) source
  obtain ⟨s2,d2,arraysExec⟩ := seq_inv _ declareResidues arraysBody s1 out (by decide) rest1
  have state1 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s .u64 dimensionNames ⟨s1,.normal⟩ d1)
  have state2 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s1 .u32 residueNames ⟨s2,.normal⟩ d2)
  dsimp only at state1 state2
  have beforeHeap : s2.heap=s.heap := by rw [state2,state1]
  have beforeInput : s2.arrays "a".toList=some p := by rw [state2,state1]; exact input
  have beforeProfile : Slot s2 "logn" 10 := by rw [state2,state1]; exact profile
  have types : Types s2 := by
    rw [state2,state1]
    exact ⟨⟨⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩⟩,
      ⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩⟩
  have beforeCells : Cells s2.heap p 1536 a := by rw [beforeHeap]; exact cells
  have initialized : KeygenPublicRangeMemory.Initialized s2.heap p 1536 := by
    intro i hi; obtain ⟨w,read,_,_⟩ := beforeCells i hi; exact ⟨w,read⟩
  have live := KeygenPublicForwardMemory.initialized_live s2.heap p initialized
  obtain ⟨w,read,_,_⟩ := beforeCells 0 (by decide)
  have width : p.elementBytes=2 := (KeygenPublicRangeMemory.load_allocated _ _ _ read).2
  cases arraysExec with
  | arrayScope _ _ _ _ innerG gBlock positiveG sizeG freshG executedG =>
      have gOutside : p.block≠gBlock := by intro equal; rw [equal,freshG.1] at live; omega
      have blockG := KeygenPublicForwardMemory.allocated_other s2.heap gBlock 2048 p.block gOutside
      cases executedG with
      | arrayScope _ _ _ _ innerI iBlock positiveI sizeI freshI executedI =>
          have different : gBlock≠iBlock := by
            intro equal
            have zero := freshI.1
            rw [← equal] at zero
            change (if gBlock=gBlock then 4096 else s2.heap.size gBlock)=0 at zero
            simp only [ite_true] at zero
            omega
          have iOutside : p.block≠iBlock := by
            intro equal
            have zero := freshI.1
            rw [← equal] at zero
            have currentLive : 0 < (localEntry s2 "gm".toList gBlock 2048).heap.size p.block := by
              change 0 < (KeygenPublicExec.allocated s2.heap gBlock 2048).size p.block
              rw [blockG.1]; exact live
            rw [zero] at currentLive
            omega
          have blockI := KeygenPublicForwardMemory.allocated_other
            (localEntry s2 "gm".toList gBlock 2048).heap iBlock 2048 p.block iOutside
          have blockBoth := KeygenPublicForwardMemory.block_trans _ _ _ p.block blockG blockI
          have inputReady : (localEntry (localEntry s2 "gm".toList gBlock 2048) "igm".toList iBlock 2048).arrays "a".toList=some p := by
            simpa only [localEntry,C99ArrayReference.bindPointer,show "a".toList≠"igm".toList from by decide,
              show "a".toList≠"gm".toList from by decide,ite_false] using beforeInput
          have run := ready_stages a
            (localEntry (localEntry s2 "gm".toList gBlock 2048) "igm".toList iBlock 2048) innerI p gBlock iBlock
            width beforeProfile inputReady
            ⟨⟨types.triple.n,types.triple.hn,types.triple.u,types.triple.v,types.triple.w⟩,types.t,types.m,types.r,types.ni⟩
            ⟨rfl,rfl⟩ different gOutside iOutside (cells_block _ _ p 1536 a blockBoth beforeCells) executedI
          have leaveI := KeygenPublicForwardMemory.disposed_other
            (localEntry s2 "gm".toList gBlock 2048).heap innerI.state.heap iBlock p.block iOutside
          have leaveG := KeygenPublicForwardMemory.disposed_other s2.heap
            (localExit (localEntry s2 "gm".toList gBlock 2048) innerI.state "igm".toList iBlock).heap gBlock p.block gOutside
          exact ⟨innerI,run,rfl,KeygenPublicForwardMemory.block_trans _ _ _ p.block leaveI leaveG⟩

end FT1536.Source3.KeygenPublicReverseInvocation
