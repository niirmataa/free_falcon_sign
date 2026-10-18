import Source3.PublicReverseRoundSetup173

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicReverseRoundBody173
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec chain)
open KeygenPublicTableAtoms (var)
open KeygenNttLoopSupport (USlot u64)
open PublicReverseRoundContext173 (Arrays Valid)
open PublicReverseRoundSetup173 (names declaration half initialization declared halved initial)
open PublicMiddleWrites161 (MemoryFrame)

def last := KeygenPublicReverseProgram.tSet

theorem shape : KeygenPublicReverseProgram.stageBody =
    .scope names [] (chain [declaration,half,
      .seq initialization KeygenPublicReverseProgram.rowLoop,last]) := by decide

theorem source (s : State) (a gm : ArrayPointer) (t m : Nat)
    (ctx : Arrays s a gm) (valid : Valid t m) (active : t<1536)
    (tSlot : USlot s "t" t) (mSlot : USlot s "m" m)
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.stageBody s ⟨after,.normal⟩ ∧
      Arrays after a gm ∧ USlot after "t" (t*2) ∧ USlot after "m" m ∧
      (∃ old, after.locals "v".toList=some (.uint64,old)) ∧ MemoryFrame s after a := by
  have fixed := PublicReverseRoundSetup173.initial_fixed s a gm t m ctx valid tSlot mSlot vCell
  obtain ⟨grouped,groupRun,groupFixed,_,_,groupMemory⟩ := PublicReverseGroupLoop173.source (initial s t)
    a gm (t/2) m 0 fixed (PublicReverseRoundSetup173.initial_u s t)
    (PublicReverseRoundSetup173.initial_v s t) (by omega)
  let final := bindValue grouped "t".toList .uint64 (u64 (t*2))
  have groupedT : USlot grouped "t" t := by
    rw [valid.even]
    exact groupFixed.stride
  have lastRun : Exec KeygenPublicSource.program [] last grouped ⟨final,.normal⟩ :=
    .scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 t)) (u64 (t*2)) groupedT
      (.shift .left _ _ _ _ _ (.variable _ _ _ groupedT) (.literal .int32 1)
        (C99ControlShift142.double_word t valid.wordBound)))
  have innerRun : Exec KeygenPublicSource.program []
      (chain [declaration,half,.seq initialization KeygenPublicReverseProgram.rowLoop,last]) s ⟨final,.normal⟩ :=
    PublicGenerateRow159.chain_step _ _ s (declared s) ⟨final,.normal⟩
      (PublicReverseRoundSetup173.declaration_source s)
      (PublicGenerateRow159.chain_step _ _ (declared s) (halved s t) ⟨final,.normal⟩
        (PublicReverseRoundSetup173.half_source s t valid.wordBound tSlot)
        (PublicGenerateRow159.chain_step _ _ (halved s t) grouped ⟨final,.normal⟩
          (.seqNormal _ _ (halved s t) (initial s t) ⟨grouped,.normal⟩
            (PublicReverseRoundSetup173.initialization_source s t) groupRun)
          (PublicGenerateRow159.chain_step _ _ grouped final ⟨final,.normal⟩ lastRun (.skip final))))
  let after := C99ArrayReference.restoreScope s final names []
  have run : Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.stageBody s ⟨after,.normal⟩ := by
    rw [shape]
    exact .scope names [] _ s ⟨final,.normal⟩ innerRun
  have frame := PublicScopedFrame162.frame _ _ _ _ _ (by decide) run
  have memory := PublicMiddleLoop161.frame_trans s (initial s t) after a
    (PublicGroupBody162.same_heap_frame s (initial s t) a rfl)
    (PublicMiddleLoop161.frame_trans (initial s t) grouped after a groupMemory
      (PublicGroupBody162.same_heap_frame grouped after a rfl))
  have finalT : USlot after "t" (t*2) :=
    PublicGenerateRow159.u64_slot_after grouped "t" (t*2) (by omega)
  have finalM : USlot after "m" m := (frame.2.2 _ (by decide)).trans mSlot
  refine ⟨after,run,PublicReverseRoundContext173.transfer s after a gm ctx frame.2.1 memory,finalT,finalM,?_,memory⟩
  obtain ⟨old,cell⟩ := groupFixed.vCell
  exact ⟨old,cell⟩

end FT1536.Source3.PublicReverseRoundBody173
