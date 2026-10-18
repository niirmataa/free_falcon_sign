import Source3.PublicReverseRoundLoop173

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicReverseStart173
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenNttLoopSupport (USlot u64)
open PublicReverseRoundContext173 (Arrays)
open PublicMiddleWrites161 (MemoryFrame)

theorem m_eval (s : State) (profile : KeygenPublicTableAtoms.Slot s "logn" 10) :
    KeygenPublicWord.Eval [] s
      (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1))
        (.bin .sub (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 2))) (u64 256) :=
  .bin .shl _ _ (u64 1) (.uint32 8) (u64 256)
    (PublicGenerateIndex159.word_cast_u64_one s)
    (.bin .sub _ _ (.uint32 10) (.int32 2) (.uint32 8)
      (PublicGenerateHead159.eval_var s "logn" 10 profile) (PublicGenerateHead159.eval_lit s 2)
      (.step .minus (.uint32 10) (.int32 2) .uint32 rfl (.uint32 10) (.uint32 2) rfl rfl
        (by intro impossible; cases impossible)))
    (PublicGenerateIndex159.shl_pow 8 (.uint32 8)
      (PublicGenerateIndex159.u32_integer 8 (by decide)) (by decide))

theorem source (s : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (profile : KeygenPublicTableAtoms.Slot s "logn" 10)
    (nCell : USlot s "n" 1536)
    (tCell : ∃ old, s.locals "t".toList=some (.uint64,old))
    (mCell : ∃ old, s.locals "m".toList=some (.uint64,old))
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec KeygenPublicSource.program []
      (.seq KeygenPublicReverseProgram.start KeygenPublicReverseProgram.stages) s ⟨after,.normal⟩ ∧
      Arrays after a gm ∧ USlot after "t" 1536 ∧ USlot after "m" 1 ∧
      (∃ old, after.locals "v".toList=some (.uint64,old)) ∧ MemoryFrame s after a := by
  obtain ⟨oldT,declaredT⟩ := tCell
  obtain ⟨oldM,declaredM⟩ := mCell
  let withT := bindValue s "t".toList .uint64 (u64 6)
  let initial := bindValue withT "m".toList .uint64 (u64 256)
  have tRun : Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.start s ⟨withT,.normal⟩ :=
    .assign _ _ _ .uint64 oldT (.int32 6) declaredT (.scalar _ _ (.literal .int32 6))
  have declaredM1 : withT.locals "m".toList=some (.uint64,oldM) := declaredM
  have mRun : Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.initM withT ⟨initial,.normal⟩ :=
    .assign _ _ _ .uint64 oldM (u64 256) declaredM1 (m_eval withT profile)
  have initialT := PublicGenerateRow159.keep_u64 withT "t" "m" .uint64 (u64 256) 6 (by decide)
    (PublicGenerateRow159.u64_slot_after s "t" 6 (by decide))
  have initialM := PublicGenerateRow159.u64_slot_after withT "m" 256 (by decide)
  have initialV : ∃ old, initial.locals "v".toList=some (.uint64,old) := vCell
  have initialMemory := PublicGroupBody162.same_heap_frame s initial a rfl
  have initialArrays := PublicReverseRoundContext173.transfer s initial a gm ctx rfl initialMemory
  obtain ⟨after,loopRun,lastArrays,lastT,lastM,lastV,loopMemory⟩ :=
    PublicReverseRoundLoop173.eight_rounds initial a gm initialArrays initialT initialM initialV nCell
  exact ⟨after,.seqNormal _ _ s withT ⟨after,.normal⟩ tRun
    (.seqNormal _ _ withT initial ⟨after,.normal⟩ mRun loopRun),
    lastArrays,lastT,lastM,lastV,PublicMiddleLoop161.frame_trans s initial after a initialMemory loopMemory⟩

theorem continue_section (s after : State) (out : C99ProcedureReference.Result)
    (middle : Exec KeygenPublicSource.program []
      (.seq KeygenPublicReverseProgram.start KeygenPublicReverseProgram.stages) s ⟨after,.normal⟩)
    (tripling : Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.remaining after out) :
    Exec KeygenPublicSource.program [] KeygenPublicInverseProgram.remaining s out := by
  rw [KeygenPublicReverseProgram.source_remaining]
  cases middle with
  | seqNormal _ _ _ next _ first second =>
      exact .seqNormal _ _ s next out first (.seqNormal _ _ next after out second tripling)
  | seqExit _ _ _ _ _ exit => exact (exit rfl).elim

end FT1536.Source3.PublicReverseStart173
