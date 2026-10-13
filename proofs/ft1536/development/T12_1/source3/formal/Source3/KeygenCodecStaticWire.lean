import Source3.KeygenDecodeStaticComplete
import Source3.KeygenCodecNoneWire
import Source3.KeygenCodecStaticLength

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- SAME actual source STATIC encoder execution yields return, byte trace,
   readable decoder input and preserved original material. The capacity
   domain is the source-proved mathematical bit budget, not a codec oracle. -/
namespace FT1536.Source3.KeygenCodecStaticWire
open C99MemoryReference KeygenCodecValues KeygenCodecExecution KeygenCodecByteHistory
open KeygenCodecStaticMaterial KeygenCodecStaticHistory

/-- Numeric legal-capacity domain from the pinned source bit accounting. -/
def Capacity (args : Args) (inputs : List (BitVec 16)) : Prop :=
  KeygenCodecStaticLength.byteLength inputs≤args.capacity.toNat

theorem uniform_capacity (args : Args) (inputs : List (BitVec 16)) (count : inputs.length=1536)
    (capacity : 26496≤args.capacity.toNat) : Capacity args inputs := by
  have bound := KeygenCodecStaticLength.profile_bounds inputs count
  unfold Capacity
  omega

theorem source_bytes (args : Args) (before : Memory) (after : State) (flow : Flow)
    (out original : ArrayPointer) (q : args.q=18433) (logn : args.logn=10)
    (output : args.out=some out) (inputs : List (BitVec 16)) (capacity : Capacity args inputs)
    (input : args.x=some original) (separate : original.block≠out.block)
    (count : inputs.length=1536)
    (words : Words before original inputs)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    flow=.returned (BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded inputs).length) ∧
      Trace before after.heap (positions (some out) 0 (KeygenCodecStaticComplete.encoded inputs)) := by
  have separation : Separated args.out original.block := by
    rw [output]
    intro destination same
    cases same
    exact separate
  obtain ⟨k,bound,trace,ending⟩ := KeygenCodecStaticComplete.source_outcome args before after flow q logn original input inputs count words separation source
  have enough : (KeygenCodecStaticComplete.encoded inputs).length≤args.capacity.toNat := by
    rw [KeygenCodecStaticLength.encoded_length]
    exact capacity
  rcases ending with ⟨returned,complete⟩ | ⟨returned,nonnull,short,exhausted⟩
  · subst k
    rw [List.take_length,output] at trace
    exact ⟨returned,trace⟩
  · omega

theorem trace_writable (a b : Memory) (writes : List Write) (trace : Trace a b writes) : b.writable=a.writable := by
  induction trace with
  | nil => rfl
  | step a b c ptr word rest store tail ih => exact ih.trans store.2.2.2.2.1

theorem physical_reads (out : ArrayPointer) (bytes : List (BitVec 8)) (before after : Memory)
    (trace : Trace before after (positions (some out) 0 bytes)) :
    KeygenDecodeStaticWire.Reads after (byteOff out 0) 0 bytes := by
  intro i
  have read := KeygenCodecNoneWire.trace_readback out 0 bytes before after trace i
  simp only [Nat.zero_add] at read
  have advance := KeygenDecodeNoneImages.byte_advance after out i.val
    (KeygenDecodeNoneImages.load_allocated _ _ _ read)
  exact ⟨byteOff out i.val,by simpa only [Nat.zero_add] using advance,read⟩

theorem original_preserved (args : Args) (before : Memory) (after : State) (flow : Flow)
    (out original : ArrayPointer) (q : args.q=18433) (logn : args.logn=10)
    (output : args.out=some out) (inputs : List (BitVec 16)) (capacity : Capacity args inputs)
    (input : args.x=some original) (separate : original.block≠out.block)
    (count : inputs.length=1536) (words : Words before original inputs)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    Words after.heap original inputs := by
  have trace := (source_bytes args before after flow out original q logn output inputs capacity input separate count words source).2
  have preserved : Preserved original.block before after.heap :=
    ⟨trace_sizes _ _ _ trace,fun offset => outside _ _ _ trace original.block offset
      (fun write member => Or.inl (positions_away (some out) original.block 0 _
        (by intro destination same; cases same; exact separate) write member))⟩
  exact words_preserved original.block before after.heap preserved original rfl inputs words

end FT1536.Source3.KeygenCodecStaticWire
