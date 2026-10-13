import Source3.KeygenCodecStaticOuterSuffix
import Source3.KeygenCodecStaticStores

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Connect the derived source prologue, outer-loop state and ordered raw
   byte history to the complete unrestricted source execution. Expected
   emitted-byte/cursor histories remain a distinct open obligation. -/
namespace FT1536.Source3.KeygenCodecStaticFullState
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticOuterState KeygenCodecStaticOuterSuffix

def Completed (args : Args) (start final : State) (flow : Flow) : Prop :=
  ∃ middle : State, ∃ inputs : List (BitVec 16),
    Exec args KeygenCodecStaticBinding.node102 start middle .normal ∧ inputs.length=1536 ∧
    KeygenCodecStaticOuterControl.Remaining 0 middle.locals ∧
    KeygenCodecStaticPending.Cell (fold inputs 0 0).1 middle.locals ∧
    KeygenCodecStaticUnaryInvariant.Acc (fold inputs 0 0).2 middle.locals ∧
    (fold inputs 0 0).1<8 ∧
    KeygenCodecStaticSuffix.low (fold inputs 0 0).2 (fold inputs 0 0).1=suffixFold inputs 0 0 ∧
    Exec args KeygenCodecStaticBinding.node123 middle final flow

def EarlyReturn (args : Args) (start final : State) (flow : Flow) : Prop :=
  ∃ value : BitVec 64, flow=.returned value ∧
    Exec args KeygenCodecStaticBinding.node102 start final (.returned value)

/-- Both source possibilities are derived, with an unrestricted observed
    flow. No successful codec return, encoded length or frame is a premise. -/
theorem complete_source (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    (∃ start final, KeygenCodecStaticInit.Initialized args start ∧ start.heap=before ∧
      after.heap=final.heap ∧ (Completed args start final flow ∨ EarlyReturn args start final flow)) ∧
    ∃ writes, KeygenCodecByteHistory.Trace before after.heap writes := by
  constructor
  · obtain ⟨start,final,init,heap,rest,last⟩ := KeygenCodecStaticInit.initialization args before after flow q logn source
    refine ⟨start,final,init,heap,last,?_⟩
    cases rest with
    | seq args a b start middle final flow loop tail =>
      obtain ⟨inputs,length,terminal,pending,word,small,suffix⟩ := source_low_suffix args start middle init loop
      exact Or.inl ⟨middle,inputs,loop,length,terminal,pending,word,small,suffix,tail⟩
    | seqReturn args a b start final value loop => exact Or.inr ⟨value,rfl,loop⟩
  · exact KeygenCodecByteHistory.execution args _ _ after flow source

end FT1536.Source3.KeygenCodecStaticFullState
