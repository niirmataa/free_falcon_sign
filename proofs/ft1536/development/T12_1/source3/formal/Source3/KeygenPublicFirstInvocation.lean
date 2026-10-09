import Source3.KeygenPublicFirstEntry

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete forward invocation supplies all first-loop entry domains.
   Its actual continuation result is linked to the observed output through
   the two automatic-array disposals. No initial local residue range,
   generated table, first-pass scalar value or transform result is assumed. -/
namespace FT1536.Source3.KeygenPublicFirstInvocation
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec localPointer localEntry localExit)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardProgram
open KeygenPublicForwardControl (seq_inv)
open KeygenPublicFirstEntry (Types FirstRun ready_first)
open KeygenPublicFirstTables (cells_block)
open KeygenPublicInputCells (Cells)
open KeygenPublicInputMaterial (reduced)
open KeygenPublicForwardMemory (Block)

def Outcome (original : Geometry.Vec) (a : ArrayPointer) (out : Result) : Prop :=
  ∃ inner, FirstRun original a inner ∧ out.flow=inner.flow ∧ Block inner.state.heap out.state.heap a.block

theorem initialized (heap : C99MemoryReference.Memory) (a : ArrayPointer) (original : Geometry.Vec)
    (cells : Cells heap a 1536 (reduced original)) : KeygenPublicRangeMemory.Initialized heap a 1536 := by
  intro i hi
  obtain ⟨w,read,_,_⟩ := cells i hi
  exact ⟨w,read⟩

theorem source_first (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT) s out) :
    Outcome original a out := by
  rw [source_complete] at source
  obtain ⟨s1,d1,rest1⟩ := seq_inv _ declareDimensions _ s out (by decide) source
  obtain ⟨s2,d2,arraysExec⟩ := seq_inv _ declareResidues arraysBody s1 out (by decide) rest1
  have state1 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s .u64 dimensionNames ⟨s1,.normal⟩ d1)
  have state2 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s1 .u32 ["r".toList,"w".toList] ⟨s2,.normal⟩ d2)
  dsimp only at state1 state2
  have beforeHeap : s2.heap=s.heap := by rw [state2,state1]
  have beforeInput : s2.arrays "a".toList=some a := by rw [state2,state1]; exact input
  have beforeProfile : Slot s2 "logn" 10 := by rw [state2,state1]; exact profile
  have types : Types s2 := by
    rw [state2,state1]
    exact ⟨⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩⟩
  have beforeCells : Cells s2.heap a 1536 (reduced original) := by rw [beforeHeap]; exact cells
  have live := KeygenPublicForwardMemory.initialized_live s2.heap a (initialized _ _ original beforeCells)
  obtain ⟨w,read,_,_⟩ := beforeCells 0 (by decide)
  have width : a.elementBytes=2 := (KeygenPublicRangeMemory.load_allocated _ _ _ read).2
  cases arraysExec with
  | arrayScope _ _ _ _ innerG gBlock positiveG sizeG freshG executedG =>
      have gOutside : a.block≠gBlock := by intro equal; rw [equal,freshG.1] at live; omega
      have blockG := KeygenPublicForwardMemory.allocated_other s2.heap gBlock 2048 a.block gOutside
      cases executedG with
      | arrayScope _ _ _ _ innerI iBlock positiveI sizeI freshI executedI =>
          have different : gBlock≠iBlock := by
            intro equal
            have zero := freshI.1
            rw [← equal] at zero
            change (if gBlock=gBlock then 4096 else s2.heap.size gBlock)=0 at zero
            simp only [ite_true] at zero
            omega
          have iOutside : a.block≠iBlock := by
            intro equal
            have zero := freshI.1
            rw [← equal] at zero
            have currentLive : 0<(localEntry s2 "gm".toList gBlock 2048).heap.size a.block := by
              change 0<(KeygenPublicExec.allocated s2.heap gBlock 2048).size a.block
              rw [blockG.1]; exact live
            rw [zero] at currentLive
            omega
          have blockI := KeygenPublicForwardMemory.allocated_other
            (localEntry s2 "gm".toList gBlock 2048).heap iBlock 2048 a.block iOutside
          have blockBoth := KeygenPublicForwardMemory.block_trans _ _ _ a.block blockG blockI
          have inputReady : (localEntry (localEntry s2 "gm".toList gBlock 2048) "igm".toList iBlock 2048).arrays "a".toList=some a := by
            simpa only [localEntry,C99ArrayReference.bindPointer,show "a".toList≠"igm".toList from by decide,
              show "a".toList≠"gm".toList from by decide,ite_false] using beforeInput
          have run := ready_first original
            (localEntry (localEntry s2 "gm".toList gBlock 2048) "igm".toList iBlock 2048) innerI a gBlock iBlock
            width beforeProfile inputReady ⟨types.n,types.hn,types.u,types.r⟩ ⟨rfl,rfl⟩ different gOutside iOutside
            (cells_block _ _ a 1536 (reduced original) blockBoth beforeCells) executedI
          have leaveI := KeygenPublicForwardMemory.disposed_other
            (localEntry s2 "gm".toList gBlock 2048).heap innerI.state.heap iBlock a.block iOutside
          have leaveG := KeygenPublicForwardMemory.disposed_other s2.heap
            (localExit (localEntry s2 "gm".toList gBlock 2048) innerI.state "igm".toList iBlock).heap gBlock a.block gOutside
          exact ⟨innerI,run,rfl,KeygenPublicForwardMemory.block_trans _ _ _ a.block leaveI leaveG⟩

theorem folded (original : Geometry.Vec) (a : ArrayPointer) (out : Result)
    (result : Outcome original a out) :
    ∃ entry after inner,
      KeygenPublicFirstFold.Inv original a 0 entry ∧
      Exec KeygenPublicSource.program [] KeygenPublicFirstValues.firstLoop entry ⟨after,.normal⟩ ∧
      (∀ i<768, KeygenPublicInputCells.Cell after.heap a i ((KeygenPublicFirstFold.lowP original).coeff i) ∧
        KeygenPublicInputCells.Cell after.heap a (i+768) ((KeygenPublicFirstFold.highP original).coeff i)) ∧
      Exec KeygenPublicSource.program [] KeygenPublicFirstValues.remaining after inner ∧
      out.flow=inner.flow ∧ Block inner.state.heap out.state.heap a.block := by
  obtain ⟨inner,⟨entry,after,inv,loop,final,suffix⟩,flow,block⟩ := result
  exact ⟨entry,after,inner,inv,loop,
    fun i hi => KeygenPublicFirstFold.folded original a 768 (by decide) after final i hi,suffix,flow,block⟩

end FT1536.Source3.KeygenPublicFirstInvocation
