import Source3.KeygenInt16Representation076

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Construct physical int16 storage from legal writable memory, with no
   initially initialized destination values. Each step is the real Store16
   reference operation; exact source codec executions are linked separately. -/
namespace FT1536.Source3.KeygenInt16Construct076
open C99MemoryReference KeygenDecodeNoneMemory
open KeygenInt16Representation076 (wordList)

theorem trace_exists (inputs : List (BitVec 16)) (heap : Memory) (ptr : ArrayPointer) (n : Nat)
    (bound : n+inputs.length≤1536) (legal : WritableArray heap ptr 1536) :
    ∃ after, Trace ptr heap after n inputs := by
  induction inputs generalizing heap n with
  | nil => exact ⟨heap,.nil heap n⟩
  | cons input rest ih =>
    have inside : n<1536 := by simp only [List.length_cons] at bound; omega
    let middle := KeygenDecodeWrite16.overwrite heap (element ptr n) input
    have store : KeygenDecodeExecution.Store16 heap (element ptr n) input middle :=
      KeygenDecodeWrite16.exists_store heap (element ptr n) input (legal.2.2 n inside) legal.1 legal.2.1
    have nextLegal := legal_preserved heap middle ptr (element ptr n) 1536 input legal store
    obtain ⟨after,tail⟩ := ih middle (n+1) (by simp only [List.length_cons] at bound; omega) nextLegal
    exact ⟨after,.cons heap middle after n input rest store tail⟩

theorem raw_array_exists (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (legal : WritableArray heap ptr 1536) :
    ∃ after, Trace ptr heap after 0 (wordList v) ∧
      KeygenMaterial.Represents after ptr v ∧
      KeygenDecodeNoneExactFrame.Window ptr 0 1536 heap after := by
  obtain ⟨after,trace⟩ := trace_exists (wordList v) heap ptr 0
    (by rw [KeygenInt16Representation076.wordList_length]) legal
  have reads := trace_readback ptr heap after 0 (wordList v) legal.1 trace
  have words : KeygenCodecStaticMaterial.Words after ptr (wordList v) := by
    apply KeygenInt16Words076.from_reads
    intro i
    exact KeygenInt16Reads076.decoder_read after _ _ (by simpa only [Nat.zero_add] using reads i)
  have represented := KeygenInt16Representation076.words_represents after ptr v words
  have frame := KeygenDecodeNoneExactFrame.trace_frame ptr heap after 0 (wordList v) legal.1 trace
  rw [KeygenInt16Representation076.wordList_length] at frame
  exact ⟨after,trace,represented,frame⟩

theorem actual_signed_read (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (legal : KeygenPublicInputMaterial.Legal heap ptr) (represented : KeygenMaterial.Represents heap ptr v)
    (signed : KeygenInt16Vector076.Signed16 v) (i : Fin 1536) (word : BitVec 16)
    (source : KeygenCodecValues.Load16 heap (element ptr i.val) word) :
    word.toInt=KeygenInt16Vector076.coefficient v i := by
  have original := KeygenInt16Representation076.represents_indexed heap ptr v legal represented i
  have same := KeygenCodecStaticMaterial.load_unique heap _ word _ source original
  rw [same]
  exact KeygenInt16Vector076.word_integer v signed i

/-- Exact integer-valued reverse transport on the signed16 domain, rather
    than merely an aliased low-bit representation of arbitrary integers. -/
theorem mathematical_array_exists (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (signed : KeygenInt16Vector076.Signed16 v) (legal : WritableArray heap ptr 1536) :
    ∃ after, Trace ptr heap after 0 (wordList v) ∧ KeygenMaterial.Represents after ptr v ∧
      (∀ (i : Fin 1536) (word : BitVec 16), KeygenCodecValues.Load16 after (element ptr i.val) word →
        word.toInt=KeygenInt16Vector076.coefficient v i) ∧
      KeygenDecodeNoneExactFrame.Window ptr 0 1536 heap after := by
  obtain ⟨after,trace,represented,frame⟩ := raw_array_exists heap ptr v legal
  have sizes := trace_sizes ptr heap after 0 (wordList v) trace
  have legalAfter : KeygenPublicInputMaterial.Legal after ptr :=
    ⟨legal.1,fun i bound => by
      change Allocated after (element ptr i)
      simpa only [Allocated,sizes] using legal.2.2 i bound⟩
  exact ⟨after,trace,represented,fun i word source => actual_signed_read after ptr v legalAfter represented signed i word source,frame⟩

end FT1536.Source3.KeygenInt16Construct076
