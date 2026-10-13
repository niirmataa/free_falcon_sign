import Source3.KeygenCodecStaticLength
import Source3.KeygenCodecStaticCall
import Source3.KeygenCodecNoneDispatch

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Length conclusions consume the actual complete codec bodies/dispatcher.
   Input-array size and legal separation are domains, never output hypotheses. -/
namespace FT1536.Source3.KeygenCodecExactLengths
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticMaterial KeygenCodecStaticLength KeygenCodecStaticComplete

/-- NONE's complete source branch derives its fixed3072-byte return or
    pre-write capacity rejection, including a NULL dry run. -/
theorem none_source_length (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after flow) :
    flow=.returned (if args.out=none then 3072 else if args.capacity.toNat<3072 then 0 else 3072) :=
  KeygenCodecNoneReturn.none_return args before after flow q logn source

theorem none_call_length (args : Args) (before after : Memory) (ret : BitVec 64)
    (comp : args.comp=0) (q : args.q=18433) (logn : args.logn=10)
    (source : Call args before after ret) :
    ret=(if args.out=none then 3072 else if args.capacity.toNat<3072 then 0 else 3072) :=
  KeygenCodecNoneDispatch.dispatch_result args before after ret comp q logn source

/-- Keep the whole expected trace and every capacity-return prefix, while
    replacing its structural list length by the proved bit-cost formula. -/
def LengthOutcome (args : Args) (before after : Memory) (inputs : List (BitVec 16)) (flow : Flow) : Prop :=
  ∃ k : Nat, k≤byteLength inputs ∧
    KeygenCodecByteHistory.Trace before after (KeygenCodecStaticHistory.positions args.out 0 ((encoded inputs).take k)) ∧
    ((flow=.returned (BitVec.ofNat 64 (byteLength inputs)) ∧ k=byteLength inputs) ∨
      (flow=.returned 0 ∧ args.out≠none ∧ k<byteLength inputs ∧ args.capacity.toNat≤k))

theorem outcome_length (args : Args) (before after : Memory) (inputs : List (BitVec 16)) (flow : Flow)
    (outcome : Outcome args before after (encoded inputs) flow) :
    LengthOutcome args before after inputs flow := by
  simpa only [Outcome,LengthOutcome,encoded_length] using outcome

theorem static_source_length (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10) (ptr : ArrayPointer) (held : args.x=some ptr)
    (inputs : List (BitVec 16)) (length : inputs.length=1536) (words : Words before ptr inputs)
    (separate : Separated args.out ptr.block)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    LengthOutcome args before after.heap inputs flow :=
  outcome_length args before after.heap inputs flow
    (source_outcome args before after flow q logn ptr held inputs length words separate source)

theorem static_call_length (args : Args) (before after : Memory) (ret : BitVec 64)
    (comp : args.comp=1) (q : args.q=18433) (logn : args.logn=10)
    (ptr : ArrayPointer) (held : args.x=some ptr) (inputs : List (BitVec 16))
    (length : inputs.length=1536) (words : Words before ptr inputs)
    (separate : Separated args.out ptr.block) (source : Call args before after ret) :
    LengthOutcome args before after inputs (.returned ret) :=
  outcome_length args before after inputs (.returned ret)
    (KeygenCodecStaticCall.call_outcome args before after ret comp q logn ptr held inputs length words separate source)

/-- Sufficient capacity is an input domain, not an assumed successful result.
    A NULL dry run is independent of the supplied capacity. -/
theorem adequate_return (args : Args) (before after : Memory) (inputs : List (BitVec 16)) (flow : Flow)
    (outcome : LengthOutcome args before after inputs flow)
    (domain : args.out=none ∨ byteLength inputs≤args.capacity.toNat) :
    flow=.returned (BitVec.ofNat 64 (byteLength inputs)) := by
  obtain ⟨k,_,_,ending⟩ := outcome
  rcases ending with ⟨returned,_⟩ | ⟨_,nonNull,short,capacity⟩
  · exact returned
  · rcases domain with isNull | enough
    · exact (nonNull isNull).elim
    · omega

/-- In a source-proved normally completed segment chain, the inherited
    nonzero return fact selects the exact length without assuming that length. -/
theorem nonzero_return (args : Args) (before after : Memory) (inputs : List (BitVec 16)) (ret : BitVec 64)
    (outcome : LengthOutcome args before after inputs (.returned ret)) (nonzero : ret≠0) :
    ret=BitVec.ofNat 64 (byteLength inputs) := by
  obtain ⟨k,_,_,ending⟩ := outcome
  rcases ending with ⟨returned,_⟩ | ⟨returned,_⟩
  · exact Flow.returned.inj returned
  · exact (nonzero (Flow.returned.inj returned)).elim

end FT1536.Source3.KeygenCodecExactLengths
