import Source3.KeygenCodecStaticOuterControl

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Whole normal outer-loop word/pending state, obtained by folding its
   actual coefficient bodies. Byte-stream/material transport is separate. -/
namespace FT1536.Source3.KeygenCodecStaticOuterState
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticProfile KeygenCodecStaticOuterControl

def fold : List (BitVec 16) → Nat → BitVec 32 → Nat × BitVec 32
  | [],pending,word => (pending,word)
  | input::rest,pending,word => fold rest
      (KeygenCodecStaticIteration.nextPending pending input.toInt)
      (KeygenCodecStaticIteration.nextWord pending word input.toInt)

theorem fold_pending (inputs : List (BitVec 16)) (p : Nat) (word : BitVec 32) (small : p<8) :
    (fold inputs p word).1<8 := by
  induction inputs generalizing p word with
  | nil => exact small
  | cons input rest ih =>
    exact ih _ _ (Nat.mod_lt _ (by decide +kernel))

/-- Complete finite normal outer-loop execution. Input-list length is
    derived from the actual remaining counter, not an encoded-length premise. -/
theorem outer_state (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node102 s t flow) (normal : flow=.normal)
    (n : Nat) (upper : n≤1536) (remaining : Remaining n s.locals)
    (p : Nat) (word : BitVec 32) (small : p<8)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (j : Cell "j".toList .int32 (.int32 8) s.locals)
    (mask : Cell "mask".toList .uint32 (.uint32 255) s.locals) :
    ∃ inputs : List (BitVec 16), inputs.length=n ∧ Remaining 0 t.locals ∧
      KeygenCodecStaticPending.Cell (fold inputs p word).1 t.locals ∧
      KeygenCodecStaticUnaryInvariant.Acc (fold inputs p word).2 t.locals := by
  generalize codeEq : KeygenCodecStaticBinding.node102=code at source
  induction source generalizing n p word with
  | whileDone args test a s value locals evaluated no =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value n upper remaining evaluated
    rw [test] at no
    have zero : n=0 := by simpa using no
    subst n
    subst locals
    exact ⟨[],rfl,remaining,count,acc⟩
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value n upper remaining evaluated
    rw [test] at yes
    have positive : 0<n := by simpa using yes
    subst locals
    have nextRemaining := body_remaining args s middle n positive upper remaining iteration
    obtain ⟨input,nextCount,nextAcc⟩ := KeygenCodecStaticIteration.body_state args s middle p word small count acc j mask iteration
    have nextJ := (KeygenCodecCellFrame.exec_frame "j".toList args _ s middle .normal iteration (by decide +kernel)).trans j
    have nextMask := (KeygenCodecCellFrame.exec_frame "mask".toList args _ s middle .normal iteration (by decide +kernel)).trans mask
    obtain ⟨inputs,length,terminal,lastCount,lastAcc⟩ := ih2 normal (n-1) (by omega) nextRemaining
      (KeygenCodecStaticIteration.nextPending p input.toInt) (KeygenCodecStaticIteration.nextWord p word input.toInt)
      (Nat.mod_lt _ (by decide +kernel)) nextCount nextAcc nextJ nextMask rfl
    exact ⟨input::inputs,by simp only [List.length_cons]; omega,terminal,lastCount,lastAcc⟩
  | whileReturn => cases normal
  | _ => cases codeEq

/-- Consume only cells that the complete source prologue has derived. -/
theorem initialized_state (args : Args) (s t : State)
    (init : KeygenCodecStaticInit.Initialized args s)
    (source : Exec args KeygenCodecStaticBinding.node102 s t .normal) :
    ∃ inputs : List (BitVec 16), inputs.length=1536 ∧ Remaining 0 t.locals ∧
      KeygenCodecStaticPending.Cell (fold inputs 0 0).1 t.locals ∧
      KeygenCodecStaticUnaryInvariant.Acc (fold inputs 0 0).2 t.locals :=
  outer_state args s t .normal source rfl 1536 (by decide +kernel) init.2.1
    0 0 (by decide +kernel) init.2.2.2.2.2.1 init.2.2.2.2.1 init.1 init.2.2.1

end FT1536.Source3.KeygenCodecStaticOuterState
