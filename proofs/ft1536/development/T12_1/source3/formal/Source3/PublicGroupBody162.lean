import Source3.PublicGroupHead162
import Source3.PublicScopedFrame162

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicGroupBody162
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (var)
open KeygenNttLoopSupport (USlot u64)
open PublicMiddleWrites161 (MemoryFrame)
open PublicGroupHead162 (head suffix Entry)

theorem same_heap_frame (before after : State) (a : ArrayPointer) (heap : after.heap=before.heap) :
    MemoryFrame before after a := by
  refine ⟨congrArg C99MemoryReference.Memory.size heap,
    congrArg C99MemoryReference.Memory.writable heap,?_,?_⟩
  · intro block _ offset
    exact congrArg (fun h : C99MemoryReference.Memory => h.bytes block offset) heap
  · intro j written
    rw [heap]
    exact written

theorem initial_fixed (s : State) (a : ArrayPointer) (ht stop start : Nat)
    (fixed : PublicMiddleLoop161.Fixed s a ht stop) :
    PublicMiddleLoop161.Fixed (bindValue s "v".toList .uint64 (u64 start)) a ht stop := by
  refine ⟨fixed.limit,fixed.capacity,fixed.binding,?_,?_,?_,fixed.width,
    fixed.writable,fixed.allocated,fixed.written⟩
  · exact PublicGenerateRow159.keep_u64 s "ht" "v" .uint64 _ ht (by decide) fixed.half
  · exact PublicGenerateRow159.keep_u64 s "v2" "v" .uint64 _ stop (by decide) fixed.stopSlot
  · obtain ⟨w,slot⟩ := fixed.factor
    exact ⟨w,PublicGenerateRow159.keep_slot s "s" "v" .uint64 _ w (by decide) slot⟩

theorem visible_writes : PublicScopedFrame162.writes PublicTailShape159.midGroupBody = ["v".toList,"v".toList] := rfl

structure Result (before after : State) (a : ArrayPointer) (stop : Nat) : Prop
    extends MemoryFrame before after a where
  arrays : after.arrays=before.arrays
  locals : ∀ name, name≠"v".toList → after.locals name=before.locals name
  counter : USlot after "v" stop

theorem source (s : State) (a gm : ArrayPointer) (ht m u start : Nat)
    (entry : Entry s a gm ht m u start) :
    ∃ after, Exec KeygenPublicSource.program [] PublicTailShape159.midGroupBody s ⟨after,.normal⟩ ∧
      Result s after a (start+ht) := by
  obtain ⟨middle,headRun,fixed,startSlot,⟨old,vCell⟩,heap⟩ :=
    PublicGroupHead162.source s a gm ht m u start entry
  have limit := entry.limit
  let initial := bindValue middle "v".toList .uint64 (u64 start)
  have initRun : Exec KeygenPublicSource.program [] (.assign "v".toList (var "v1")) middle ⟨initial,.normal⟩ :=
    .assign _ _ _ .uint64 old (u64 start) vCell
      (.scalar _ _ (PublicGenerateIndex159.var_u64 middle "v1" start startSlot))
  have initialFixed := initial_fixed middle a ht (start+ht) start fixed
  have initialCounter := PublicGenerateRow159.u64_slot_after middle "v" start (by omega)
  obtain ⟨inner,loopRun,_,lastCounter,loopFrame⟩ :=
    PublicMiddleLoop161.source initial a ht (start+ht) start initialFixed initialCounter (by omega)
  have suffixRun : Exec KeygenPublicSource.program [] suffix middle ⟨inner,.normal⟩ :=
    .seqNormal _ _ middle inner ⟨inner,.normal⟩
      (.seqNormal _ _ middle initial ⟨inner,.normal⟩ initRun loopRun) (.skip inner)
  have innerRun := PublicAppendSource157.source KeygenPublicSource.program [] head suffix
    s middle ⟨inner,.normal⟩ headRun suffixRun
  let after := C99ArrayReference.restoreScope s inner ["v2".toList,"s".toList] []
  have run : Exec KeygenPublicSource.program [] PublicTailShape159.midGroupBody s ⟨after,.normal⟩ := by
    rw [PublicGroupHead162.shape]
    exact .scope _ [] _ s ⟨inner,.normal⟩ innerRun
  have frame := PublicScopedFrame162.frame _ _ _ _ _ (by decide) run
  have memory := PublicMiddleLoop161.frame_trans s initial inner a
    (same_heap_frame s initial a heap) loopFrame
  have finalMemory := PublicMiddleLoop161.frame_trans s inner after a memory
    (same_heap_frame inner after a rfl)
  refine ⟨after,run,finalMemory,frame.2.1,?_,lastCounter⟩
  intro name outside
  apply frame.2.2 name
  simpa [visible_writes] using outside

end FT1536.Source3.PublicGroupBody162
