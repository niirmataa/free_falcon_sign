import Source3.KeygenDecodeMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Constructive physical stores from legal allocated writable destinations.
   No pre-initialized output value or desired decoder frame is required. -/
namespace FT1536.Source3.KeygenDecodeWrite16
open KeygenDecodeValues KeygenDecodeExecution C99MemoryReference

def overwrite (heap : Memory) (ptr : ArrayPointer) (word : BitVec 16) : Memory :=
  ⟨fun block offset => if block=ptr.block then
      if offset=ptr.offset then some (word.setWidth 8)
      else if offset=ptr.offset+1 then some ((word >>> 8).setWidth 8)
      else heap.bytes block offset
    else heap.bytes block offset,heap.size,heap.writable⟩

theorem exists_store (heap : Memory) (ptr : ArrayPointer) (word : BitVec 16)
    (allocated : Allocated heap ptr) (width : ptr.elementBytes=2) (writable : heap.writable ptr.block=true) :
    Store16 heap ptr word (overwrite heap ptr word) := by
  refine ⟨allocated,width,writable,rfl,rfl,?_,?_,?_⟩
  · simp only [overwrite,ite_true]
  · simp only [overwrite,ite_true,show ptr.offset+1≠ptr.offset by omega,ite_false]
  · intro block offset outside
    by_cases same : block=ptr.block
    · subst block
      have notLow : offset≠ptr.offset := by omega
      have notHigh : offset≠ptr.offset+1 := by omega
      simp only [overwrite,ite_true,notLow,notHigh,ite_false]
    · simp only [overwrite,same,ite_false]

theorem readback (heap : Memory) (ptr : ArrayPointer) (word : BitVec 16)
    (allocated : Allocated heap ptr) (width : ptr.elementBytes=2) (writable : heap.writable ptr.block=true) :
    Load16 (overwrite heap ptr word) ptr word :=
  KeygenDecodeMemory.store_readback ptr word heap _ (exists_store heap ptr word allocated width writable)

theorem byte_preserved (a b : Memory) (ptr bytePtr : ArrayPointer) (word : BitVec 16) (byte : BitVec 8)
    (store : Store16 a ptr word b) (away : bytePtr.block≠ptr.block) (load : LoadByte a bytePtr byte) :
    LoadByte b bytePtr byte := by
  cases load with
  | load allocated width initialized =>
    obtain ⟨_,_,_,sizes,_,_,_,frame⟩ := store
    exact .load b bytePtr byte (by simpa only [Allocated,sizes] using allocated) width
      ((frame bytePtr.block bytePtr.offset (Or.inl away)).trans initialized)

end FT1536.Source3.KeygenDecodeWrite16
