import Source3.KeygenCodecStaticBudget
import Source3.KeygenCodecStaticOuterState

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One all-flow outer fold, with the same read list supplying bytes and
   normal state. A rejected execution records only coefficients it read. -/
namespace FT1536.Source3.KeygenCodecStaticOuterHistory
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticWriteStep (Cursor)
open KeygenCodecStaticEmit (Ready)
open KeygenCodecStaticHistory
open KeygenCodecStaticOuterControl
open KeygenCodecStaticIteration

def bytes : List (BitVec 16) → Nat → BitVec 32 → List (BitVec 8)
  | [],_,_ => []
  | input::rest,p,word => KeygenCodecStaticCoefficientHistory.bytes p word input++
      bytes rest (nextPending p input.toInt) (nextWord p word input.toInt)

def NormalState (inputs : List (BitVec 16)) (p : Nat) (word : BitVec 32) (t : State) : Prop :=
  Remaining 0 t.locals ∧
  KeygenCodecStaticPending.Cell (KeygenCodecStaticOuterState.fold inputs p word).1 t.locals ∧
  KeygenCodecStaticUnaryInvariant.Acc (KeygenCodecStaticOuterState.fold inputs p word).2 t.locals

/-- No observed success or requested encoded length is an input. The
    natural budget decreases using a proved worst-case per-coefficient bound. -/
theorem outer_history (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node102 s t flow)
    (n : Nat) (upper : n≤1536) (remaining : Remaining n s.locals)
    (u p : Nat) (word : BitVec 32) (budget : u+131*n+1<2^64) (small : p<8)
    (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 u) s)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (j : KeygenCodecStaticProfile.Cell "j".toList .int32 (.int32 8) s.locals)
    (mask : KeygenCodecStaticProfile.Cell "mask".toList .uint32 (.uint32 255) s.locals) :
    ∃ inputs : List (BitVec 16), inputs.length≤n ∧
      Progress args s t u (bytes inputs p word) flow ∧
      (flow=.normal → inputs.length=n ∧ NormalState inputs p word t) := by
  generalize codeEq : KeygenCodecStaticBinding.node102=code at source
  induction source generalizing n u p word with
  | whileDone args test a s value locals evaluated no =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value n upper remaining evaluated
    rw [test] at no
    have zero : n=0 := by simpa using no
    subst n
    subst locals
    exact ⟨[],Nat.le_refl 0,nil_progress args s u ready cursor,
      fun _ => ⟨rfl,remaining,count,acc⟩⟩
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value n upper remaining evaluated
    rw [test] at yes
    have positive : 0<n := by simpa using yes
    subst locals
    obtain ⟨input,ptr,next,_,_,first,state⟩ := KeygenCodecStaticJoint.coefficient args s middle .normal
      u p word (by omega) small ready cursor count acc j mask iteration
    have nextState := state rfl
    have firstSize := KeygenCodecStaticBudget.coefficient_size p word input small
    have nextRemaining := body_remaining args s middle n positive upper remaining iteration
    have nextJ := (KeygenCodecCellFrame.exec_frame "j".toList args _ s middle .normal iteration (by decide +kernel)).trans j
    have nextMask := (KeygenCodecCellFrame.exec_frame "mask".toList args _ s middle .normal iteration (by decide +kernel)).trans mask
    have selected := first
    obtain ⟨k,_,nextReady,nextCursor,_,ending⟩ := selected
    have complete : k=(KeygenCodecStaticCoefficientHistory.bytes p word input).length := by
      rcases ending with ⟨_,complete⟩ | ⟨bad,_⟩
      · exact complete
      · cases bad
    subst k
    obtain ⟨inputs,length,history,normal⟩ := ih2 (n-1) (by omega) nextRemaining
      (u+(KeygenCodecStaticCoefficientHistory.bytes p word input).length)
      (nextPending p input.toInt) (nextWord p word input.toInt) (by omega)
      (Nat.mod_lt _ (by decide +kernel)) nextReady nextCursor nextState.1 nextState.2 nextJ nextMask rfl
    exact ⟨input::inputs,by simp only [List.length_cons]; omega,
      append_progress args s middle t u _ _ flow first history,
      fun h => ⟨by have size := (normal h).1; simp only [List.length_cons]; omega,(normal h).2⟩⟩
  | whileReturn args test a s t ret value locals evaluated yes iteration ih =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value n upper remaining evaluated
    rw [test] at yes
    have positive : 0<n := by simpa using yes
    subst locals
    obtain ⟨input,ptr,next,_,_,history,_⟩ := KeygenCodecStaticJoint.coefficient args s t (.returned ret)
      u p word (by omega) small ready cursor count acc j mask iteration
    refine ⟨[input],by simp only [List.length_cons,List.length_nil]; omega,?_,?_⟩
    · simpa only [bytes,List.append_nil] using history
    · intro impossible; cases impossible
  | _ => cases codeEq

end FT1536.Source3.KeygenCodecStaticOuterHistory
