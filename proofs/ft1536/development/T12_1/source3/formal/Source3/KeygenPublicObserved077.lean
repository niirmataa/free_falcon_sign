import Source3.KeygenPublicPacket077
import Source3.KeygenPublicCallerTrace077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicObserved077
open C99MemoryReference
open KeygenCodecExecution (byteOff StoreByte)
open KeygenCodecByteHistory (Trace)
open KeygenDecodeValues (LoadByte)

/-- Only physical output length and initialized public-buffer bytes.
    No mathematical vector or successful decoding occurs in this definition. -/
def ObservedPublic (pubkey lengthCell : ArrayPointer) (heap : Memory) (packet : List (BitVec 8)) : Prop :=
  packet.length<2^64 ∧ Load64 heap lengthCell (BitVec.ofNat 64 packet.length) ∧
    ∀ i : Fin packet.length, LoadByte heap (byteOff pubkey i.val) packet[i]

theorem byteOff_add (ptr : ArrayPointer) (m n : Nat) : byteOff (byteOff ptr m) n=byteOff ptr (m+n) := by
  cases ptr
  simp only [byteOff,ArrayPointer.offset,Nat.mul_one,Nat.one_mul,Nat.add_assoc,Nat.add_sub_cancel_left]

theorem positions_shift (ptr : ArrayPointer) (m n : Nat) (bytes : List (BitVec 8)) :
    KeygenCodecStaticHistory.positions (some (byteOff ptr m)) n bytes=KeygenCodecStaticHistory.positions (some ptr) (m+n) bytes := by
  induction bytes generalizing n with
  | nil => rfl
  | cons byte rest ih =>
    simp only [KeygenCodecStaticHistory.positions,KeygenCodecStaticHistory.single,Option.toList_some,
      List.map_cons,List.map_nil,List.cons_append,List.nil_append,byteOff_add,ih,Nat.add_assoc]

theorem byte_transport (a b : Memory) (ptr : ArrayPointer) (word : BitVec 8)
    (sizes : b.size=a.size) (same : b.bytes ptr.block ptr.offset=a.bytes ptr.block ptr.offset)
    (read : LoadByte a ptr word) : LoadByte b ptr word := by
  cases read with
  | load allocated width initialized =>
    exact .load b ptr word (by simpa only [Allocated,sizes] using allocated) width (same.trans initialized)

theorem byte_after_store (a b : Memory) (ptr : ArrayPointer) (word : BitVec 8) (store : StoreByte a ptr word b) : LoadByte b ptr word :=
  .load b ptr word (by simpa only [Allocated,store.2.2.2.1] using store.1) store.2.1 store.2.2.2.2.2.1

theorem byte_after_length (a b : Memory) (ptr lengthCell : ArrayPointer) (length : BitVec 64) (word : BitVec 8)
    (separate : ptr.block≠lengthCell.block) (store : Store64 a lengthCell length b) (read : LoadByte a ptr word) : LoadByte b ptr word :=
  byte_transport a b ptr word store.2.2.2.1 (store.2.2.2.2.2.2 ptr.block ptr.offset (Or.inl separate)) read

theorem material_after_header (a b : Memory) (pubkey original : ArrayPointer) (h : Relation.Rq)
    (separate : original.block≠pubkey.block) (represented : KeygenPublicNormalizePolynomial.Represents a original h)
    (store : StoreByte a (byteOff pubkey 0) 138 b) : KeygenPublicNormalizePolynomial.Represents b original h := by
  have cell (i : Nat) (z : KeygenPublicAlgebra.R) (source : KeygenPublicInputCells.Cell a original i z) :
      KeygenPublicInputCells.Cell b original i z := by
    obtain ⟨word,read,range,value⟩ := source
    refine ⟨word,C99NarrowReads.load16_transport a b (KeygenSmallOutput.element original i) word read store.2.2.2.1 ?_,range,value⟩
    intro byte
    exact store.2.2.2.2.2.2 _ _ (Or.inl separate)
  intro i
  exact ⟨cell i.val (h i).1 (represented i).1,cell (i.val+768) (h i).2 (represented i).2⟩

theorem packet_observed (before headerHeap encoded after : Memory) (pubkey lengthCell : ArrayPointer)
    (bytes : List (BitVec 8)) (small : bytes.length+1<2^64) (separate : pubkey.block≠lengthCell.block)
    (header : StoreByte before (byteOff pubkey 0) 138 headerHeap)
    (payload : Trace headerHeap encoded (KeygenCodecStaticHistory.positions (some (byteOff pubkey 1)) 0 bytes))
    (lengthStore : Store64 encoded lengthCell (BitVec.ofNat 64 (bytes.length+1)) after) :
    ObservedPublic pubkey lengthCell after (138::bytes) := by
  have shifted : Trace headerHeap encoded (KeygenCodecStaticHistory.positions (some pubkey) 1 bytes) := by
    simpa only [positions_shift,Nat.add_zero] using payload
  have headerPreserved := KeygenCodecByteHistory.outside _ _ _ shifted pubkey.block pubkey.offset
    (by simpa only [Nat.add_zero] using KeygenCodecNoneWire.later_away pubkey 0 bytes)
  have headerRead : LoadByte encoded (byteOff pubkey 0) 138 :=
    byte_transport headerHeap encoded (byteOff pubkey 0) 138 (KeygenCodecStaticMaterial.trace_sizes _ _ _ shifted)
      (by simpa only [KeygenCodecNoneWire.byte_offset,Nat.add_zero,show (byteOff pubkey 0).block=pubkey.block by rfl] using headerPreserved)
      (byte_after_store before headerHeap _ _ header)
  refine ⟨small,KeygenMakeInvocation.load64_of_store encoded after lengthCell _ lengthStore,?_⟩
  intro i
  refine Fin.cases ?_ (fun j => ?_) i
  · exact byte_after_length encoded after (byteOff pubkey 0) lengthCell _ 138 separate lengthStore headerRead
  · have read := KeygenCodecNoneWire.trace_readback pubkey 1 bytes headerHeap encoded shifted j
    have source := byte_after_length encoded after (byteOff pubkey (1+j.val)) lengthCell _ bytes[j] separate lengthStore read
    change LoadByte after (byteOff pubkey (j.val+1)) bytes[j]
    simpa only [Nat.add_comm 1 j.val] using source

theorem byte_unique (heap : Memory) (ptr : ArrayPointer) (a b : BitVec 8)
    (first : LoadByte heap ptr a) (second : LoadByte heap ptr b) : a=b := by
  cases first with
  | load allocated width initialized =>
    cases second with
    | load allocated' width' initialized' => exact Option.some.inj (initialized.symm.trans initialized')

theorem observed_unique (pubkey lengthCell : ArrayPointer) (heap : Memory) (a b : List (BitVec 8))
    (first : ObservedPublic pubkey lengthCell heap a) (second : ObservedPublic pubkey lengthCell heap b) : a=b := by
  have same := load64_deterministic heap lengthCell _ _ first.2.1 second.2.1
  have lengths := congrArg BitVec.toNat same
  rw [BitVec.toNat_ofNat,BitVec.toNat_ofNat,Nat.mod_eq_of_lt first.1,Nat.mod_eq_of_lt second.1] at lengths
  apply List.ext_getElem lengths
  intro i left right
  exact byte_unique heap (byteOff pubkey i) _ _ (first.2.2 ⟨i,left⟩) (second.2.2 ⟨i,right⟩)

end FT1536.Source3.KeygenPublicObserved077
