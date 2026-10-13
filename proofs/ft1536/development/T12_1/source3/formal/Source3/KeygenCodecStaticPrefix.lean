import Source3.KeygenCodecStaticUnaryHistory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Derive the common loop-entry cells and actual material read from every
   finite coefficient execution, before either byte loop can reject. -/
namespace FT1536.Source3.KeygenCodecStaticPrefix
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticProfile KeygenCodecStaticCoefficient KeygenCodecStaticIteration
open KeygenCodecStaticWriteStep (Cursor)
open KeygenCodecStaticEmit (Ready)
open KeygenCodecStaticDrainHistory (ready_frame)

def packedWord (word : BitVec 32) (input : BitVec 16) : BitVec 32 :=
  (word <<< 9) ||| KeygenCodecStaticLow9.packed input.toInt

structure Prepared (args : Args) (s start : State) (u p : Nat) (word : BitVec 32) (input : BitVec 16) : Prop where
  heap : start.heap=s.heap
  ready : Ready args start
  cursor : Cursor (BitVec.ofNat 64 u) start
  pending : KeygenCodecStaticPending.Cell (p+9) start.locals
  accumulator : KeygenCodecStaticUnaryInvariant.Acc (packedWord word input) start.locals
  counter : KeygenCodecStaticCountdown.Cell (magnitude input.toInt/256) start.locals
  lower : 0≤magnitude input.toInt/256
  upper : magnitude input.toInt/256≤128

/-- The input word is the actual read witness, rather than an unrelated
    existential for the arithmetic fold. Cross-iteration original-array
    identity still requires pointer progression and the caller separation. -/
theorem preparation (args : Args) (s after : State) (flow : Flow) (u p : Nat) (word : BitVec 32)
    (small : p<8) (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 u) s)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (j : Cell "j".toList .int32 (.int32 8) s.locals)
    (mask : Cell "mask".toList .uint32 (.uint32 255) s.locals)
    (source : Exec args KeygenCodecStaticBinding.node101 s after flow) :
    ∃ input : BitVec 16, ∃ ptr next : ArrayPointer, ∃ readBefore loaded start final : State,
      Exec args KeygenCodecStaticBinding.node025 readBefore loaded .normal ∧
      readBefore.locals.x=some ptr ∧ readBefore.heap=s.heap ∧
      Load16 s.heap ptr input ∧ PointerAdd ptr 1 next ∧ loaded.locals.x=some next ∧
      Prepared args s start u p word input ∧
      Exec args KeygenCodecStaticBinding.node090 start final flow ∧
      after=scopeExit KeygenCodecStaticBinding.node100 s final := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨s1,e0,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node022 KeygenCodecStaticBinding.node099 s t flow inside (by decide +kernel)
    obtain ⟨s2,e1,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node023 KeygenCodecStaticBinding.node098 s1 t flow rest (by decide +kernel)
    obtain ⟨s3,e2,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node024 KeygenCodecStaticBinding.node097 s2 t flow rest (by decide +kernel)
    obtain ⟨s4,e3,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node025 KeygenCodecStaticBinding.node096 s3 t flow rest (by decide +kernel)
    obtain ⟨s5,e4,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node026 KeygenCodecStaticBinding.node095 s4 t flow rest (by decide +kernel)
    obtain ⟨s6,e5,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node037 KeygenCodecStaticBinding.node094 s5 t flow rest (by decide +kernel)
    obtain ⟨s7,e6,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node038 KeygenCodecStaticBinding.node093 s6 t flow rest (by decide +kernel)
    obtain ⟨s8,e7,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node039 KeygenCodecStaticBinding.node092 s7 t flow rest (by decide +kernel)
    obtain ⟨s9,e8,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node040 KeygenCodecStaticBinding.node091 s8 t flow rest (by decide +kernel)
    obtain ⟨s10,e9,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node041 KeygenCodecStaticBinding.node090 s9 t flow rest (by decide +kernel)
    have w3 := (KeygenCodecCellFrame.exec_frame "w".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "w".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((single_declaration args s s1 "w".toList .i32 .int32 (by decide +kernel) rfl e0)))
    obtain ⟨ptr,next,input,held,advance,load,lastPointer,inputW,lower,upper⟩ := input_read args s3 s4 .normal w3 e3
    have w5 := (KeygenCodecCellFrame.exec_frame "w".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans (inputW)
    have lo5 := (KeygenCodecCellFrame.exec_frame "lo".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "lo".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "lo".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((single_declaration args s1 s2 "lo".toList .u32 .uint32 (by decide +kernel) rfl e1))))
    have j5 := (KeygenCodecCellFrame.exec_frame "j".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s s1 .normal e0 (by decide +kernel)).trans (j)))))
    have mask6 := (KeygenCodecCellFrame.exec_frame "mask".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s s1 .normal e0 (by decide +kernel)).trans (mask))))))
    have ne7 := (KeygenCodecCellFrame.exec_frame "ne".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "ne".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "ne".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "ne".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((single_declaration args s2 s3 "ne".toList .i32 .int32 (by decide +kernel) rfl e2)))))
    have acc8 := (KeygenCodecCellFrame.exec_frame "acc".toList args _ s7 s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s s1 .normal e0 (by decide +kernel)).trans (acc))))))))
    have acc_len9 := (KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s8 s9 .normal e8 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s7 s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s s1 .normal e0 (by decide +kernel)).trans (count)))))))))
    obtain ⟨mag6,sign6⟩ := sign_magnitude args s5 s6 .normal input.toInt lower upper w5 lo5 j5 e5
    have packed7 := KeygenCodecStaticLow9.low9_step args s6 s7 .normal input.toInt lower upper mag6 sign6 mask6 e6
    have mag7 := (KeygenCodecCellFrame.exec_frame "w".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans (mag6)
    have j7 := (KeygenCodecCellFrame.exec_frame "j".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans (j5))
    have bounds := magnitude_bounds input.toInt lower upper
    obtain ⟨ne8,neLower,neUpper⟩ := quotient args s7 s8 .normal (magnitude input.toInt) bounds.1 bounds.2 mag7 j7 ne7 e7
    have packed8 := (KeygenCodecCellFrame.exec_frame "lo".toList args _ s7 s8 .normal e7 (by decide +kernel)).trans (packed7)
    have j8 := (KeygenCodecCellFrame.exec_frame "j".toList args _ s7 s8 .normal e7 (by decide +kernel)).trans (j7)
    have word9 := KeygenCodecStaticAppend.append_step args s8 s9 .normal word (KeygenCodecStaticLow9.packed input.toInt) acc8 j8 packed8 e8
    have j9 := (KeygenCodecCellFrame.exec_frame "j".toList args _ s8 s9 .normal e8 (by decide +kernel)).trans (j8)
    have pending10 := KeygenCodecStaticDrain.append_count args s9 s10 .normal p small acc_len9 j9 e9
    have word10 := (KeygenCodecCellFrame.exec_frame "acc".toList args _ s9 s10 .normal e9 (by decide +kernel)).trans word9
    have ne10 := (KeygenCodecCellFrame.exec_frame "ne".toList args _ s9 s10 .normal e9 (by decide +kernel)).trans
      ((KeygenCodecCellFrame.exec_frame "ne".toList args _ s8 s9 .normal e8 (by decide +kernel)).trans ne8)
    have preparedRun := Exec.seq args KeygenCodecStaticBinding.node022 _ s s1 s10 .normal e0 (.seq args KeygenCodecStaticBinding.node023 _ s1 s2 s10 .normal e1 (.seq args KeygenCodecStaticBinding.node024 _ s2 s3 s10 .normal e2 (.seq args KeygenCodecStaticBinding.node025 _ s3 s4 s10 .normal e3 (.seq args KeygenCodecStaticBinding.node026 _ s4 s5 s10 .normal e4 (.seq args KeygenCodecStaticBinding.node037 _ s5 s6 s10 .normal e5 (.seq args KeygenCodecStaticBinding.node038 _ s6 s7 s10 .normal e6 (.seq args KeygenCodecStaticBinding.node039 _ s7 s8 s10 .normal e7 (.seq args KeygenCodecStaticBinding.node040 _ s8 s9 s10 .normal e8 (.seq args KeygenCodecStaticBinding.node041 .skip s9 s10 s10 .normal e9 (.skip args s10))))))))))
    have startReady := ready_frame args _ s s10 .normal ready preparedRun (by decide +kernel)
      (by decide +kernel) (by decide +kernel) (by decide +kernel)
    have startCursor := (KeygenCodecCellFrame.exec_frame "u".toList args _ s s10 .normal preparedRun (by decide +kernel)).trans cursor
    have heap := KeygenCodecStateFrame.heap_frame args _ s s10 .normal preparedRun (by decide +kernel)
    have loadHeap := (KeygenCodecStateFrame.heap_frame args _ s2 s3 .normal e2 (by decide +kernel)).trans
      ((KeygenCodecStateFrame.heap_frame args _ s1 s2 .normal e1 (by decide +kernel)).trans
        (KeygenCodecStateFrame.heap_frame args _ s s1 .normal e0 (by decide +kernel)))
    refine ⟨input,ptr,next,s3,s4,s10,t,e3,held,loadHeap,?_,advance,lastPointer,?_,rest,rfl⟩
    · rw [←loadHeap]; exact load
    · exact ⟨heap,startReady,startCursor,pending10,word10,ne10,neLower,neUpper⟩

end FT1536.Source3.KeygenCodecStaticPrefix
