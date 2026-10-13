import Source3.KeygenCodecStaticEntry
import Source3.KeygenCodecStaticOuterMaterial
import Source3.KeygenCodecStaticReturnHistory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Full STATIC byte/cursor/return semantics on the original physical
   int16 input array. No codec result, encoded length or frame is assumed. -/
namespace FT1536.Source3.KeygenCodecStaticComplete
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticHistory
open KeygenCodecStaticMaterial
open KeygenCodecStaticOuterHistory (bytes NormalState)
open KeygenCodecStaticOuterState (fold)
open KeygenCodecStaticReturnHistory (padding Result)

def encoded (inputs : List (BitVec 16)) : List (BitVec 8) :=
  bytes inputs 0 0++padding (fold inputs 0 0).2 (fold inputs 0 0).1

def Outcome (args : Args) (before after : Memory) (expected : List (BitVec 8)) (flow : Flow) : Prop :=
  ∃ k : Nat, k≤expected.length ∧
    KeygenCodecByteHistory.Trace before after (positions args.out 0 (expected.take k)) ∧
    ((flow=.returned (BitVec.ofNat 64 expected.length) ∧ k=expected.length) ∨
      (flow=.returned 0 ∧ args.out≠none ∧ k<expected.length ∧ args.capacity.toNat≤k))

theorem stream_bound (inputs : List (BitVec 16)) (p : Nat) (word : BitVec 32) (small : p<8) :
    (bytes inputs p word).length≤131*inputs.length := by
  induction inputs generalizing p word with
  | nil => exact Nat.le_refl 0
  | cons input rest ih =>
    have first := KeygenCodecStaticBudget.coefficient_size p word input small
    have tail := ih (KeygenCodecStaticIteration.nextPending p input.toInt)
      (KeygenCodecStaticIteration.nextWord p word input.toInt) (Nat.mod_lt _ (by decide +kernel))
    simp only [bytes,List.length_append,List.length_cons]
    omega

/-- Consume the actual source residual after the common complete prologue.
    Every early return is a strict prefix of the same complete expected stream. -/
theorem residual (args : Args) (s t : State) (flow : Flow)
    (init : KeygenCodecStaticInit.Initialized args s) (ready : KeygenCodecStaticEmit.Ready args s)
    (ptr : ArrayPointer) (held : s.locals.x=some ptr) (inputs : List (BitVec 16))
    (length : inputs.length=1536) (words : Words s.heap ptr inputs)
    (separate : Separated args.out ptr.block)
    (source : Exec args KeygenCodecStaticBinding.node124 s t flow) :
    Result args s t 0 (encoded inputs) flow := by
  cases source with
  | seq args a b s middle t flow loop tail =>
    have outer := KeygenCodecStaticOuterMaterial.outer_material args s middle .normal loop
      1536 (by decide +kernel) init.2.1 inputs length ptr held words separate
      0 0 0 (by decide +kernel) (by decide +kernel) ready init.2.2.2.1 init.2.2.2.2.2.1 init.2.2.2.2.1 init.1 init.2.2.1
    have finalState := outer.2 rfl
    have selected := outer.1
    obtain ⟨k,_,lastReady,lastCursor,_,ending⟩ := selected
    have complete : k=(bytes inputs 0 0).length := by
      rcases ending with ⟨_,complete⟩ | ⟨bad,_⟩
      · exact complete
      · cases bad
    subst k
    have size := stream_bound inputs 0 0 (by decide +kernel)
    rw [length] at size
    have paddingResult := KeygenCodecStaticReturnHistory.tail_history args middle t flow
      (0+(bytes inputs 0 0).length) (fold inputs 0 0).2 (fold inputs 0 0).1 (by omega)
      (KeygenCodecStaticOuterState.fold_pending inputs 0 0 (by decide +kernel)) lastReady lastCursor
      finalState.2.2 finalState.2.1 tail
    exact KeygenCodecStaticReturnHistory.append_result args s middle t 0 _ _ flow outer.1 paddingResult
  | seqReturn args a b s t value loop =>
    have outer := KeygenCodecStaticOuterMaterial.outer_material args s t (.returned value) loop
      1536 (by decide +kernel) init.2.1 inputs length ptr held words separate
      0 0 0 (by decide +kernel) (by decide +kernel) ready init.2.2.2.1 init.2.2.2.2.2.1 init.2.2.2.2.1 init.1 init.2.2.1
    exact KeygenCodecStaticReturnHistory.rejected_result args s t 0 _ _ value outer.1

/-- Complete bound source execution, unrestricted observed flow. Physical
    entry words and non-aliasing are the only material hypotheses. -/
theorem complete_source (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10) (ptr : ArrayPointer) (held : args.x=some ptr)
    (inputs : List (BitVec 16)) (length : inputs.length=1536) (words : Words before ptr inputs)
    (separate : Separated args.out ptr.block)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    ∃ start final, start.heap=before ∧ after.heap=final.heap ∧
      Result args start final 0 (encoded inputs) flow := by
  obtain ⟨start,final,init,ready,pointer,heap,rest,last⟩ := KeygenCodecStaticEntry.entry args before after flow q logn source
  exact ⟨start,final,heap,last,residual args start final flow init ready ptr (pointer.trans held) inputs length
    (by rw [heap]; exact words) separate rest⟩

theorem source_outcome (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10) (ptr : ArrayPointer) (held : args.x=some ptr)
    (inputs : List (BitVec 16)) (length : inputs.length=1536) (words : Words before ptr inputs)
    (separate : Separated args.out ptr.block)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    Outcome args before after.heap (encoded inputs) flow := by
  obtain ⟨start,final,firstHeap,lastHeap,k,bound,_,_,trace,ending⟩ :=
    complete_source args before after flow q logn ptr held inputs length words separate source
  refine ⟨k,bound,?_,?_⟩
  · rw [←firstHeap,lastHeap]; exact trace
  · simpa only [Nat.zero_add] using ending

end FT1536.Source3.KeygenCodecStaticComplete
