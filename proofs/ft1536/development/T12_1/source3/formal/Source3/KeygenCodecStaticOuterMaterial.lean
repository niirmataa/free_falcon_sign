import Source3.KeygenCodecStaticOuterHistory
import Source3.KeygenCodecStaticMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete original physical input list supplies all expected bytes,
   including the mathematical suffix after a real capacity return. -/
namespace FT1536.Source3.KeygenCodecStaticOuterMaterial
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticWriteStep (Cursor)
open KeygenCodecStaticEmit (Ready)
open KeygenCodecStaticHistory KeygenCodecStaticOuterControl KeygenCodecStaticIteration
open KeygenCodecStaticOuterHistory (bytes NormalState)
open KeygenCodecStaticMaterial

theorem outer_material (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node102 s t flow)
    (n : Nat) (upper : n≤1536) (remaining : Remaining n s.locals)
    (inputs : List (BitVec 16)) (length : inputs.length=n) (ptr : ArrayPointer)
    (held : s.locals.x=some ptr) (words : Words s.heap ptr inputs) (separate : Separated args.out ptr.block)
    (u p : Nat) (word : BitVec 32) (budget : u+131*n+1<2^64) (small : p<8)
    (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 u) s)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (j : KeygenCodecStaticProfile.Cell "j".toList .int32 (.int32 8) s.locals)
    (mask : KeygenCodecStaticProfile.Cell "mask".toList .uint32 (.uint32 255) s.locals) :
    Progress args s t u (bytes inputs p word) flow ∧
      (flow=.normal → NormalState inputs p word t) := by
  generalize codeEq : KeygenCodecStaticBinding.node102=code at source
  induction source generalizing n inputs ptr u p word with
  | whileDone args test a s value locals evaluated no =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value n upper remaining evaluated
    rw [test] at no
    have zero : n=0 := by simpa using no
    subst n
    have empty : inputs=[] := by cases inputs <;> simp_all
    subst inputs
    subst locals
    exact ⟨nil_progress args s u ready cursor,fun _ => ⟨remaining,count,acc⟩⟩
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value n upper remaining evaluated
    rw [test] at yes
    have positive : 0<n := by simpa using yes
    subst locals
    cases inputs with
    | nil => simp only [List.length_nil] at length; omega
    | cons input inputs =>
      cases words with
      | cons ptr next input inputs load advance tail =>
        obtain ⟨actual,read,first,state⟩ := KeygenCodecStaticReadJoint.coefficient args s middle .normal
          u p word (by omega) small ready cursor count acc j mask iteration
        cases read with
        | intro actualPtr actualNext before actualLoad actualAdvance after =>
          have samePtr : actualPtr=ptr := Option.some.inj (before.symm.trans held)
          subst actualPtr
          have sameInput : actual=input := load_unique s.heap ptr actual input actualLoad load
          subst actual
          have sameNext : actualNext=next := add_unique ptr actualNext next actualAdvance advance
          subst actualNext
          have nextBlock : next.block=ptr.block := by cases advance; rfl
          have nextWords := words_preserved ptr.block s.heap middle.heap
            (progress_preserved args s middle u _ .normal first ptr.block separate) next nextBlock inputs tail
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
          have tailResult := ih2 (n-1) (by omega) nextRemaining inputs
            (by simp only [List.length_cons] at length; omega) next after nextWords
            (by rw [nextBlock]; exact separate)
            (u+(KeygenCodecStaticCoefficientHistory.bytes p word input).length)
            (nextPending p input.toInt) (nextWord p word input.toInt) (by omega)
            (Nat.mod_lt _ (by decide +kernel)) nextReady nextCursor nextState.1 nextState.2 nextJ nextMask rfl
          exact ⟨append_progress args s middle t u _ _ flow first tailResult.1,tailResult.2⟩
  | whileReturn args test a s t ret value locals evaluated yes iteration ih =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value n upper remaining evaluated
    rw [test] at yes
    have positive : 0<n := by simpa using yes
    subst locals
    cases inputs with
    | nil => simp only [List.length_nil] at length; omega
    | cons input inputs =>
      cases words with
      | cons ptr next input inputs load advance tail =>
        obtain ⟨actual,read,history,_⟩ := KeygenCodecStaticReadJoint.coefficient args s t (.returned ret)
          u p word (by omega) small ready cursor count acc j mask iteration
        cases read with
        | intro actualPtr actualNext before actualLoad actualAdvance after =>
          have samePtr : actualPtr=ptr := Option.some.inj (before.symm.trans held)
          subst actualPtr
          have sameInput : actual=input := load_unique s.heap ptr actual input actualLoad load
          subst actual
          exact ⟨extend_rejection args s t u _ _ ret history,fun impossible => by cases impossible⟩
  | _ => cases codeEq

end FT1536.Source3.KeygenCodecStaticOuterMaterial
