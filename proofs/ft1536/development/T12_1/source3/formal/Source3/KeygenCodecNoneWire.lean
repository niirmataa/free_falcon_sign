import Source3.KeygenCodecNoneOriginal
import Source3.KeygenDecodePure

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Readable final physical bytes derived from the actual ordered stores.
   The encoded-byte agreement is a conclusion, not a codec assumption. -/
namespace FT1536.Source3.KeygenCodecNoneWire
open C99MemoryReference KeygenCodecValues KeygenCodecExecution KeygenCodecByteHistory
open KeygenCodecStaticHistory (positions)

theorem byte_offset (ptr : ArrayPointer) (n : Nat) : (byteOff ptr n).offset=ptr.offset+n := by
  simp only [byteOff,ArrayPointer.offset]
  omega

theorem later_away (ptr : ArrayPointer) (n : Nat) (bytes : List (BitVec 8)) :
    ∀ write ∈ positions (some ptr) (n+1) bytes,
      ptr.block≠write.1.block ∨ ptr.offset+n≠write.1.offset := by
  have after (k : Nat) (bound : n<k) :
      ∀ write ∈ positions (some ptr) k bytes, ptr.offset+n<write.1.offset := by
    induction bytes generalizing k with
    | nil => intro write member; cases member
    | cons byte rest ih =>
      intro write member
      have choice : write=(byteOff ptr k,byte) ∨ write∈positions (some ptr) (k+1) rest := by
        simpa only [positions,KeygenCodecStaticHistory.single,Option.toList_some,List.map_cons,
          List.map_nil,List.cons_append,List.nil_append,List.mem_cons] using member
      rcases choice with rfl | member
      · rw [byte_offset]; omega
      · exact ih (k+1) (by omega) write member
  intro write member
  exact Or.inr (Ne.symm (Nat.ne_of_gt (after (n+1) (by omega) write member)))

/-- Every emitted position is readable with the exact source-derived byte
    in the final heap; later writes cannot erase an earlier byte. -/
theorem trace_readback (ptr : ArrayPointer) (n : Nat) (bytes : List (BitVec 8))
    (before after : Memory) (trace : Trace before after (positions (some ptr) n bytes)) :
    ∀ i : Fin bytes.length,
      KeygenDecodeValues.LoadByte after (byteOff ptr (n+i.val)) bytes[i] := by
  induction bytes generalizing n before with
  | nil => intro i; exact Fin.elim0 i
  | cons byte rest ih =>
    have source : Trace before after ((byteOff ptr n,byte)::positions (some ptr) (n+1) rest) := by
      simpa only [positions,KeygenCodecStaticHistory.single,Option.toList_some,List.map_cons,
        List.map_nil,List.cons_append,List.nil_append] using trace
    cases source with
    | step a middle after actual word tail store following =>
      intro i
      refine Fin.cases ?_ (fun j => ?_) i
      · change KeygenDecodeValues.LoadByte after (byteOff ptr n) byte
        have sameSize := KeygenCodecStaticMaterial.trace_sizes _ _ _ following
        have stored : middle.bytes ptr.block (ptr.offset+n)=some byte := by
          have value := store.2.2.2.2.2.1
          change middle.bytes ptr.block (byteOff ptr n).offset=some byte at value
          rw [byte_offset] at value
          exact value
        have value := (outside _ _ _ following ptr.block (ptr.offset+n) (later_away ptr n rest)).trans stored
        exact .load after (byteOff ptr n) byte
          (by simpa only [Allocated,sameSize,store.2.2.2.1] using store.1) rfl
          (by change after.bytes ptr.block (byteOff ptr n).offset=some byte; rw [byte_offset]; exact value)
      · have word := ih (n+1) middle following j
        change KeygenDecodeValues.LoadByte after (byteOff ptr (n+(j.val+1))) rest[j]
        simpa only [show n+1+j.val=n+(j.val+1) by omega] using word

/-- Complete encoder execution derives the final physical readable stream.
    The length and bytes are conclusions of that same execution. -/
theorem source_readable (args : Args) (before : Memory) (after : KeygenCodecValues.State)
    (flow : Flow) (dst ptr : ArrayPointer) (q : args.q=18433) (logn : args.logn=10)
    (out : args.out=some dst) (capacity : 3072≤args.capacity.toNat) (input : args.x=some ptr)
    (separate : ptr.block≠dst.block) (inputs : List (BitVec 16)) (count : inputs.length=1536)
    (words : KeygenCodecStaticMaterial.Words before ptr inputs)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after flow) :
    flow=.returned 3072 ∧ ∀ i : Fin (KeygenDecodeNonePairs.wire inputs).length,
      KeygenDecodeValues.LoadByte after.heap (byteOff dst i.val) (KeygenDecodeNonePairs.wire inputs)[i] := by
  obtain ⟨returned,trace⟩ := KeygenCodecNoneOriginal.source_bytes args before after flow dst ptr q logn
    out capacity input separate inputs count words source
  exact ⟨returned,by simpa only [Nat.zero_add] using trace_readback dst 0 _ before after.heap trace⟩

/-- The same original input representation survives the real encoder stores. -/
theorem source_original_preserved (args : Args) (before : Memory) (after : KeygenCodecValues.State)
    (flow : Flow) (dst ptr : ArrayPointer) (q : args.q=18433) (logn : args.logn=10)
    (out : args.out=some dst) (capacity : 3072≤args.capacity.toNat) (input : args.x=some ptr)
    (separate : ptr.block≠dst.block) (inputs : List (BitVec 16)) (count : inputs.length=1536)
    (words : KeygenCodecStaticMaterial.Words before ptr inputs)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after flow) :
    KeygenCodecStaticMaterial.Words after.heap ptr inputs := by
  obtain ⟨_,trace⟩ := KeygenCodecNoneOriginal.source_bytes args before after flow dst ptr q logn
    out capacity input separate inputs count words source
  have preserved : KeygenCodecStaticMaterial.Preserved ptr.block before after.heap :=
    ⟨KeygenCodecStaticMaterial.trace_sizes _ _ _ trace,fun offset => outside _ _ _ trace ptr.block offset
      (fun write member => Or.inl (KeygenCodecStaticMaterial.positions_away (some dst) ptr.block 0 _
        (by intro destination same; cases same; exact separate) write member))⟩
  exact KeygenCodecStaticMaterial.words_preserved ptr.block before after.heap preserved ptr rfl inputs words

end FT1536.Source3.KeygenCodecNoneWire
