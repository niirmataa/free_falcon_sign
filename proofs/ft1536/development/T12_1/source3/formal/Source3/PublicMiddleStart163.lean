import Source3.PublicRoundLoop163

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicMiddleStart163
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenNttLoopSupport (USlot u64)
open PublicRoundContext163 (Arrays)
open PublicMiddleWrites161 (MemoryFrame)

theorem source (s : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (hnSlot : USlot s "hn" 768)
    (tCell : ∃ old, s.locals "t".toList=some (.uint64,old))
    (mCell : ∃ old, s.locals "m".toList=some (.uint64,old))
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec KeygenPublicSource.program []
      (.seq PublicTailShape159.tSet PublicTailShape159.midPasses) s ⟨after,.normal⟩ ∧
      Arrays after a gm ∧ USlot after "t" 3 ∧ USlot after "m" 512 ∧
      (∃ old, after.locals "v".toList=some (.uint64,old)) ∧ MemoryFrame s after a := by
  obtain ⟨oldT,declaredT⟩ := tCell
  obtain ⟨oldM,declaredM⟩ := mCell
  let withT := bindValue s "t".toList .uint64 (u64 768)
  let initial := bindValue withT "m".toList .uint64 (u64 2)
  have tRun : Exec KeygenPublicSource.program [] PublicTailShape159.tSet s ⟨withT,.normal⟩ :=
    .assign _ _ _ .uint64 oldT (u64 768) declaredT
      (.scalar _ _ (PublicGenerateIndex159.var_u64 s "hn" 768 hnSlot))
  have declaredM1 : withT.locals "m".toList=some (.uint64,oldM) := declaredM
  have mRun : Exec KeygenPublicSource.program [] PublicTailShape159.mInit withT ⟨initial,.normal⟩ :=
    .assign _ _ _ .uint64 oldM (.int32 2) declaredM1 (.scalar _ _ (.literal .int32 2))
  have initialT := PublicGenerateRow159.keep_u64 withT "t" "m" .uint64 (u64 2) 768 (by decide)
    (PublicGenerateRow159.u64_slot_after s "t" 768 (by decide))
  have initialM := PublicGenerateRow159.u64_slot_after withT "m" 2 (by decide)
  have initialV : ∃ old, initial.locals "v".toList=some (.uint64,old) := vCell
  have initialMemory := PublicGroupBody162.same_heap_frame s initial a rfl
  have initialArrays := PublicRoundContext163.transfer s initial a gm ctx rfl initialMemory
  obtain ⟨after,loopRun,lastArrays,lastT,lastM,lastV,loopMemory⟩ :=
    PublicRoundLoop163.eight_rounds initial a gm initialArrays initialT initialM initialV
  exact ⟨after,.seqNormal _ _ s withT ⟨after,.normal⟩ tRun
    (.seqNormal _ _ withT initial ⟨after,.normal⟩ mRun loopRun),
    lastArrays,lastT,lastM,lastV,PublicMiddleLoop161.frame_trans s initial after a initialMemory loopMemory⟩

theorem continue_section (s after : State) (out : C99ProcedureReference.Result)
    (middle : Exec KeygenPublicSource.program []
      (.seq PublicTailShape159.tSet PublicTailShape159.midPasses) s ⟨after,.normal⟩)
    (tripling : Exec KeygenPublicSource.program [] PublicTailShape159.tripling after out) :
    Exec KeygenPublicSource.program [] PublicTailShape159.midSection s out := by
  cases middle with
  | seqNormal _ _ _ next _ first second =>
      exact .seqNormal _ _ s next out first (.seqNormal _ _ next after out second tripling)
  | seqExit _ _ _ _ _ exit => exact (exit rfl).elim

end FT1536.Source3.PublicMiddleStart163
