import Source3.KeygenCodecStaticPrefix

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One common expected history for both byte loops of the same actual
   coefficient, including a return from either loop. -/
namespace FT1536.Source3.KeygenCodecStaticCoefficientHistory
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticWriteStep (Cursor)
open KeygenCodecStaticEmit (Ready)
open KeygenCodecStaticHistory KeygenCodecStaticPrefix

def firstBytes (p : Nat) (word : BitVec 32) (input : BitVec 16) : List (BitVec 8) :=
  KeygenCodecStaticDrainHistory.bytes ((p+9)/8) (p+9) (packedWord word input)
def lastBytes (p : Nat) (word : BitVec 32) (input : BitVec 16) : List (BitVec 8) :=
  KeygenCodecStaticUnaryHistory.bytes (KeygenCodecStaticCoefficient.magnitude input.toInt/256+1).toNat
    ((p+9)%8) (packedWord word input)
def bytes (p : Nat) (word : BitVec 32) (input : BitVec 16) : List (BitVec 8) :=
  firstBytes p word input++lastBytes p word input

theorem drain_size (count p : Nat) (word : BitVec 32) :
    (KeygenCodecStaticDrainHistory.bytes count p word).length=count := by
  induction count generalizing p with
  | zero => rfl
  | succ count ih => simp only [KeygenCodecStaticDrainHistory.bytes,List.length_cons,ih]

theorem remainder_history (args : Args) (origin s t : State) (flow : Flow) (u p : Nat)
    (word : BitVec 32) (input : BitVec 16) (bound : u+131<2^64) (small : p<8)
    (prepared : Prepared args origin s u p word input)
    (source : Exec args KeygenCodecStaticBinding.node090 s t flow) :
    Progress args s t u (bytes p word input) flow := by
  cases source with
  | seq args a b s middle t flow first second =>
    have firstHistory := KeygenCodecStaticDrainHistory.drain_history args s middle .normal first u (p+9)
      (by omega) (by omega) prepared.ready prepared.cursor prepared.pending _ prepared.accumulator
    have selected := firstHistory
    obtain ⟨k,_,nextReady,nextCursor,trace,ending⟩ := selected
    have complete : k=(firstBytes p word input).length := by
      rcases ending with ⟨_,complete⟩ | ⟨bad,_⟩
      · exact complete
      · cases bad
    subst k
    have firstSize : (firstBytes p word input).length≤2 := by unfold firstBytes; rw [drain_size]; omega
    have countNext := KeygenCodecStaticDrain.drain_pending args s middle .normal first rfl (p+9) (by omega) prepared.pending
    have accNext := (KeygenCodecCellFrame.exec_frame "acc".toList args _ s middle .normal first (by decide +kernel)).trans prepared.accumulator
    have neNext := (KeygenCodecCellFrame.exec_frame "ne".toList args _ s middle .normal first (by decide +kernel)).trans prepared.counter
    have unary := KeygenCodecStaticUnaryHistory.before_skip args _ middle t flow second
    have lower := prepared.lower
    have upper := prepared.upper
    have tailHistory := KeygenCodecStaticUnaryHistory.loop_history args middle t flow unary
      (u+(firstBytes p word input).length) ((p+9)%8) (KeygenCodecStaticCoefficient.magnitude input.toInt/256)
      (by omega) (Nat.mod_lt _ (by decide +kernel)) (by omega) upper
      nextReady nextCursor countNext _ accNext neNext
    exact append_progress args s middle t u _ _ flow firstHistory tailHistory
  | seqReturn args a b s t value first =>
    exact extend_rejection args s t u _ (lastBytes p word input) value
      (KeygenCodecStaticDrainHistory.drain_history args s t (.returned value) first u (p+9)
        (by omega) (by omega) prepared.ready prepared.cursor prepared.pending _ prepared.accumulator)

theorem scope_progress (args : Args) (s final : State) (u : Nat) (expected : List (BitVec 8)) (flow : Flow)
    (history : Progress args s final u expected flow) :
    Progress args s (scopeExit KeygenCodecStaticBinding.node100 s final) u expected flow := by
  obtain ⟨k,bound,ready,cursor,trace,ending⟩ := history
  refine ⟨k,bound,?_,cursor,trace,ending⟩
  exact ⟨ready.buffer,ready.bufCell,ready.nullCell,ready.capacity⟩

/-- Same source read, prepared state and expected history. No codec
    return, byte length, complete input array or heap frame is assumed. -/
theorem coefficient_history (args : Args) (s after : State) (flow : Flow) (u p : Nat) (word : BitVec 32)
    (bound : u+131<2^64) (small : p<8) (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 u) s)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (j : KeygenCodecStaticProfile.Cell "j".toList .int32 (.int32 8) s.locals)
    (mask : KeygenCodecStaticProfile.Cell "mask".toList .uint32 (.uint32 255) s.locals)
    (source : Exec args KeygenCodecStaticBinding.node101 s after flow) :
    ∃ input : BitVec 16, ∃ ptr next : ArrayPointer, ∃ readBefore loaded start final : State,
      Exec args KeygenCodecStaticBinding.node025 readBefore loaded .normal ∧
      readBefore.locals.x=some ptr ∧ readBefore.heap=s.heap ∧
      Load16 s.heap ptr input ∧ PointerAdd ptr 1 next ∧ loaded.locals.x=some next ∧
      Prepared args s start u p word input ∧
      Exec args KeygenCodecStaticBinding.node090 start final flow ∧
      Progress args s after u (bytes p word input) flow := by
  obtain ⟨input,ptr,next,readBefore,loaded,start,final,readSource,held,readHeap,load,advance,lastPointer,prepared,rest,exit⟩ :=
    preparation args s after flow u p word small ready cursor count acc j mask source
  have history := remainder_history args s start final flow u p word input bound small prepared rest
  unfold Progress at history
  rw [prepared.heap] at history
  rw [exit]
  exact ⟨input,ptr,next,readBefore,loaded,start,final,readSource,held,readHeap,load,advance,lastPointer,prepared,rest,
    scope_progress args s final u _ flow history⟩

end FT1536.Source3.KeygenCodecStaticCoefficientHistory
