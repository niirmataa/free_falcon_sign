import Source3.KeygenCodecStaticCoefficientHistory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual read witness supplies both the byte history and the normal
   accumulator/pending state. No independently existential list is joined. -/
namespace FT1536.Source3.KeygenCodecStaticJoint
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticPrefix KeygenCodecStaticIteration
open KeygenCodecStaticWriteStep (Cursor)
open KeygenCodecStaticEmit (Ready)
open KeygenCodecStaticHistory (Progress)

def NormalState (p : Nat) (word : BitVec 32) (input : BitVec 16) (t : State) : Prop :=
  KeygenCodecStaticPending.Cell (nextPending p input.toInt) t.locals ∧
  KeygenCodecStaticUnaryInvariant.Acc (nextWord p word input.toInt) t.locals

theorem remainder_state (args : Args) (origin s t : State) (u p : Nat)
    (word : BitVec 32) (input : BitVec 16) (small : p<8)
    (prepared : Prepared args origin s u p word input)
    (source : Exec args KeygenCodecStaticBinding.node090 s t .normal) :
    NormalState p word input t := by
  obtain ⟨middle,first,rest⟩ := KeygenCodecStaticPending.normal_seq args
    KeygenCodecStaticBinding.node060 KeygenCodecStaticBinding.node089 s t source
  have pending := KeygenCodecStaticDrain.drain_pending args s middle .normal first rfl
    (p+9) (by omega) prepared.pending
  have accumulator := (KeygenCodecCellFrame.exec_frame "acc".toList args _ s middle .normal
    first (by decide +kernel)).trans prepared.accumulator
  have counter := (KeygenCodecCellFrame.exec_frame "ne".toList args _ s middle .normal
    first (by decide +kernel)).trans prepared.counter
  have unary := KeygenCodecStaticUnaryHistory.before_skip args _ middle t .normal rest
  obtain ⟨_,lastPending,lastWord⟩ := KeygenCodecStaticUnaryInvariant.unary_invariant args middle t unary
    (KeygenCodecStaticCoefficient.magnitude input.toInt/256) (by have lower := prepared.lower; omega) prepared.upper
    ((p+9)%8) (Nat.mod_lt _ (by decide +kernel)) (packedWord word input) counter pending accumulator
  exact ⟨lastPending,lastWord⟩

theorem scope_state (s t : State) (p : Nat) (word : BitVec 32) (input : BitVec 16)
    (state : NormalState p word input t) :
    NormalState p word input (scopeExit KeygenCodecStaticBinding.node100 s t) := by
  simpa [NormalState,KeygenCodecStaticPending.Cell,KeygenCodecStaticUnaryInvariant.Acc,scopeExit,
    show scopeObjects KeygenCodecStaticBinding.node100=
      [⟨"w".toList,.i32,none⟩,⟨"lo".toList,.u32,none⟩,⟨"ne".toList,.i32,none⟩] from rfl] using state

/-- A single actual read, its complete history on all flows, and its normal
    state. Local incoming cells and the conservative cursor budget are explicit. -/
theorem coefficient (args : Args) (s t : State) (flow : Flow) (u p : Nat) (word : BitVec 32)
    (bound : u+131<2^64) (small : p<8) (ready : Ready args s)
    (cursor : Cursor (BitVec.ofNat 64 u) s) (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (j : KeygenCodecStaticProfile.Cell "j".toList .int32 (.int32 8) s.locals)
    (mask : KeygenCodecStaticProfile.Cell "mask".toList .uint32 (.uint32 255) s.locals)
    (source : Exec args KeygenCodecStaticBinding.node101 s t flow) :
    ∃ input : BitVec 16, ∃ ptr next : ArrayPointer,
      Load16 s.heap ptr input ∧ PointerAdd ptr 1 next ∧
      Progress args s t u (KeygenCodecStaticCoefficientHistory.bytes p word input) flow ∧
      (flow=.normal → NormalState p word input t) := by
  obtain ⟨input,ptr,next,readBefore,loaded,start,final,_,_,_,load,advance,_,prepared,rest,exit⟩ :=
    preparation args s t flow u p word small ready cursor count acc j mask source
  have history := KeygenCodecStaticCoefficientHistory.remainder_history args s start final flow
    u p word input bound small prepared rest
  unfold Progress at history
  rw [prepared.heap] at history
  rw [exit]
  refine ⟨input,ptr,next,load,advance,
    KeygenCodecStaticCoefficientHistory.scope_progress args s final u _ flow history,?_⟩
  intro normal
  subst flow
  exact scope_state s final p word input (remainder_state args s start final u p word input small prepared rest)

end FT1536.Source3.KeygenCodecStaticJoint
