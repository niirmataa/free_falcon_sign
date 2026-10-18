import Source3.PublicReverseGroupHead173
import Source3.PublicGroupBody162
import Source3.PublicScopedFrame162

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicReverseGroupBody173
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (var)
open KeygenNttLoopSupport (USlot u64)
open PublicMiddleWrites161 (MemoryFrame)
open PublicReverseGroupHead173 (head suffix Entry)
open PublicGroupBody162 (same_heap_frame initial_fixed Result)

theorem visible_writes : PublicScopedFrame162.writes KeygenPublicReverseProgram.rowBody = ["v".toList,"v".toList] := by decide

theorem source (s : State) (a gm : ArrayPointer) (ht m u start : Nat)
    (entry : Entry s a gm ht m u start) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.rowBody s ⟨after,.normal⟩ ∧
      Result s after a (start+ht) := by
  obtain ⟨middle,headRun,fixed,startSlot,⟨old,vCell⟩,heap⟩ :=
    PublicReverseGroupHead173.source s a gm ht m u start entry
  have limit := entry.limit
  let initial := bindValue middle "v".toList .uint64 (u64 start)
  have initRun : Exec KeygenPublicSource.program [] (.assign "v".toList (var "v1")) middle ⟨initial,.normal⟩ :=
    .assign _ _ _ .uint64 old (u64 start) vCell
      (.scalar _ _ (PublicGenerateIndex159.var_u64 middle "v1" start startSlot))
  have initialFixed := initial_fixed middle a ht (start+ht) start fixed
  have initialCounter := PublicGenerateRow159.u64_slot_after middle "v" start (by omega)
  obtain ⟨inner,loopRun,_,lastCounter,loopFrame⟩ :=
    PublicReverseLoop173.source initial a ht (start+ht) start initialFixed initialCounter (by omega)
  have suffixRun : Exec KeygenPublicSource.program [] suffix middle ⟨inner,.normal⟩ :=
    .seqNormal _ _ middle inner ⟨inner,.normal⟩
      (.seqNormal _ _ middle initial ⟨inner,.normal⟩ initRun loopRun) (.skip inner)
  have innerRun := PublicAppendSource157.source KeygenPublicSource.program [] head suffix
    s middle ⟨inner,.normal⟩ headRun suffixRun
  let after := C99ArrayReference.restoreScope s inner ["v2".toList,"s".toList] []
  have run : Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.rowBody s ⟨after,.normal⟩ := by
    rw [PublicReverseGroupHead173.shape]
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

end FT1536.Source3.PublicReverseGroupBody173
