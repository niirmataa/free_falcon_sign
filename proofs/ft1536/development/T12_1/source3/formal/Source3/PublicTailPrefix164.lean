import Source3.PublicInitializedFrame164
import Source3.PublicMiddleStart163
import Source3.PublicTailLoop160

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTailPrefix164
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableAtoms (Slot)
open PublicTailShape159 (rSet firstPass tSet midPasses tripling)
open PublicRoundContext163 (Arrays)

def prefixCode : Stmt := .seq rSet (.seq firstPass (.seq tSet midPasses))

theorem initialized_arrays (s after : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (arrays : after.arrays=s.arrays) (memory : PublicInitializedFrame164.Frame s.heap after.heap) :
    Arrays after a gm := by
  refine ⟨ctx.capacity,ctx.tableCapacity,?_,?_,?_,ctx.separate,ctx.width,?_,?_,?_⟩
  · rw [arrays]; exact ctx.binding
  · rw [arrays]; exact ctx.tableBinding
  · intro j hj
    exact memory.written _ (ctx.tableWritten j hj)
  · rw [memory.writable]; exact ctx.writable
  · intro j hj
    simpa only [Allocated,memory.size] using ctx.allocated j hj
  · intro j hj
    exact memory.written _ (ctx.written j hj)

theorem compose (s first after : State)
    (initial : Exec KeygenPublicSource.program [] (.seq rSet firstPass) s ⟨first,.normal⟩)
    (middle : Exec KeygenPublicSource.program [] (.seq tSet midPasses) first ⟨after,.normal⟩) :
    Exec KeygenPublicSource.program [] prefixCode s ⟨after,.normal⟩ := by
  cases initial with
  | seqNormal _ _ _ next _ seed pass =>
      exact .seqNormal _ _ s next ⟨after,.normal⟩ seed
        (.seqNormal _ _ next first ⟨after,.normal⟩ pass middle)
  | seqExit _ _ _ _ _ exit => exact (exit rfl).elim

theorem source (s : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (firstEntry : PublicTailFirst159.TailEntry s a gm)
    (tCell : ∃ old, s.locals "t".toList=some (.uint64,old))
    (mCell : ∃ old, s.locals "m".toList=some (.uint64,old))
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec KeygenPublicSource.program [] prefixCode s ⟨after,.normal⟩ ∧
      Arrays after a gm ∧ USlot after "n" 1536 ∧ Slot after "logn" 10 ∧
      USlot after "u" 768 ∧ (∃ old, after.locals "v".toList=some (.uint64,old)) ∧
      (∃ old, after.locals "w".toList=some (.uint32,old)) ∧ after.arrays=s.arrays := by
  obtain ⟨first,firstRun,firstInv⟩ := PublicTailLoop160.seed_firstPass_source s a gm firstEntry
  have firstFrame := PublicScopedFrame162.frame _ _ _ _ _ (by decide) firstRun
  have firstMemory := PublicInitializedFrame164.source _ _ _ _ _ (by decide) firstRun
  have firstArrays := initialized_arrays s first a gm ctx firstFrame.2.1 firstMemory
  have firstT : ∃ old, first.locals "t".toList=some (.uint64,old) := by
    obtain ⟨old,slot⟩ := tCell
    exact ⟨old,(firstFrame.2.2 _ (by decide)).trans slot⟩
  have firstM : ∃ old, first.locals "m".toList=some (.uint64,old) := by
    obtain ⟨old,slot⟩ := mCell
    exact ⟨old,(firstFrame.2.2 _ (by decide)).trans slot⟩
  have firstV : ∃ old, first.locals "v".toList=some (.uint64,old) := by
    obtain ⟨old,slot⟩ := vCell
    exact ⟨old,(firstFrame.2.2 _ (by decide)).trans slot⟩
  obtain ⟨after,middleRun,lastArrays,_,_,lastV,_⟩ :=
    PublicMiddleStart163.source first a gm firstArrays firstInv.hnSlot firstT firstM firstV
  have run := compose s first after firstRun middleRun
  have frame := PublicScopedFrame162.frame _ _ _ _ _ (by decide) run
  have middleFrame := PublicScopedFrame162.frame _ _ _ _ _ (by decide) middleRun
  refine ⟨after,run,lastArrays,(frame.2.2 _ (by decide)).trans firstEntry.nSlot,
    (frame.2.2 _ (by decide)).trans firstEntry.lognSlot,
    (middleFrame.2.2 _ (by decide)).trans firstInv.uSlot,lastV,?_,frame.2.1⟩
  obtain ⟨old,slot⟩ := firstEntry.wCell
  exact ⟨old,(frame.2.2 _ (by decide)).trans slot⟩

theorem continue_tail (s after : State) (out : Result)
    (initial : Exec KeygenPublicSource.program [] prefixCode s ⟨after,.normal⟩)
    (last : Exec KeygenPublicSource.program [] tripling after out) :
    Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.tail s out := by
  rw [PublicTailShape159.tail_shape]
  cases initial with
  | seqNormal _ _ _ first _ seed rest =>
      cases rest with
      | seqNormal _ _ _ middle _ firstPassRun middleRun =>
          exact .seqNormal _ _ s first out seed (.seqNormal _ _ first middle out firstPassRun
            (PublicMiddleStart163.continue_section middle after out middleRun last))
      | seqExit _ _ _ _ _ exit => exact (exit rfl).elim
  | seqExit _ _ _ _ _ exit => exact (exit rfl).elim

end FT1536.Source3.PublicTailPrefix164
