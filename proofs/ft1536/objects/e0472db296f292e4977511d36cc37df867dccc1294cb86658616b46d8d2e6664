import Source3.C99MemoryBridge
import Source3.StableBinaryMemcpySpec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99MemoryAccess
open C99MemoryReference C99MemoryBridge StableBinaryByteView

theorem memory_ext (a b : C99MemoryReference.Memory)
    (hb : a.bytes=b.bytes) (hs : a.size=b.size) (hw : a.writable=b.writable) : a=b := by
  cases a; cases b; simp_all

theorem store64_unique (h a b : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 64)
    (ha : Store64 h p w a) (hb : Store64 h p w b) : a=b := by
  apply memory_ext a b ?_ (ha.2.2.2.1.trans hb.2.2.2.1.symm) (ha.2.2.2.2.1.trans hb.2.2.2.2.1.symm)
  funext block offset
  by_cases hin : block=p.block ∧ p.offset≤offset ∧ offset<p.offset+8
  · obtain ⟨rfl,hlo,hhi⟩ := hin
    let i : Fin 8 := ⟨offset-p.offset,by omega⟩
    have heq : p.offset+i.val=offset := by dsimp [i]; omega
    rw [← heq,ha.2.2.2.2.2.1 i,hb.2.2.2.2.2.1 i]
  · have hout : block≠p.block ∨ offset<p.offset ∨ p.offset+8≤offset := by omega
    exact (ha.2.2.2.2.2.2 block offset hout).trans (hb.2.2.2.2.2.2 block offset hout).symm

theorem store32_unique (h a b : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 32)
    (ha : Store32 h p w a) (hb : Store32 h p w b) : a=b := by
  apply memory_ext a b ?_ (ha.2.2.2.1.trans hb.2.2.2.1.symm) (ha.2.2.2.2.1.trans hb.2.2.2.2.1.symm)
  funext block offset
  by_cases hin : block=p.block ∧ p.offset≤offset ∧ offset<p.offset+4
  · obtain ⟨rfl,hlo,hhi⟩ := hin
    let i : Fin 4 := ⟨offset-p.offset,by omega⟩
    have heq : p.offset+i.val=offset := by dsimp [i]; omega
    rw [← heq,ha.2.2.2.2.2.1 i,hb.2.2.2.2.2.1 i]
  · have hout : block≠p.block ∨ offset<p.offset ∨ p.offset+4≤offset := by omega
    exact (ha.2.2.2.2.2.2 block offset hout).trans (hb.2.2.2.2.2.2 block offset hout).symm

theorem allocated_bound (h : C99MemoryReference.Memory) (p : ArrayPointer) (ha : Allocated h p) :
    p.offset+p.elementBytes≤h.size p.block := by
  obtain ⟨_,_,hi,hsize,_⟩ := ha
  have hm := Nat.mul_le_mul_left p.elementBytes (show p.index+1≤p.count by omega)
  dsimp [ArrayPointer.offset]
  rw [Nat.mul_add] at hm
  omega

theorem load64_iff (h : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 64)
    (hp : p.block=0) (ha : Allocated h p) (ht : p.elementBytes=8) :
    Load64 h p w ↔ wordRead (encode h) p.offset=some w := by
  refine ⟨fun hr => C99MemoryBridge.load64_source_to_interpreter h p w hp hr,?_⟩
  intro hr
  have hb := StableBinaryMemcpySpec.loaded_word_reencodes_bytes (encode h) p.offset w
  have hw : le64 (byte64 w)=w := B20.Word.LE.join_byteOf w
  rw [← hw]
  apply Load64.load h p (byte64 w) ha ht
  intro i
  simpa [encode,ptr,B20.C.Byte.Pointer.add,hp,byte64,B20.Word.LE.byteOf] using hb i hr

theorem load32_to_model (h : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 32)
    (hp : p.block=0) (hr : Load32 h p w) : flagRead (encode h) p.offset=some w := by
  cases hr with
  | load bytes ha ht initialized =>
      have hb := allocated_bound h p ha
      have reads (i : Fin 4) : B20.C.Byte.readByte (encode h) ((ptr p.offset).add i.val)=some (bytes i) := by
        have hin : B20.C.Byte.inBounds (encode h) ((ptr p.offset).add i.val) := by
          dsimp [B20.C.Byte.inBounds,encode,ptr,B20.C.Byte.Pointer.add]
          rw [hp,ht] at hb
          have hi := i.isLt
          exact ⟨by omega,by simpa [hp] using ha.2.2.2.2⟩
        rw [B20.C.Byte.readByte,ite_eq_left hin]
        simpa [encode,ptr,B20.C.Byte.Pointer.add,hp] using initialized i
      have h0 : B20.C.Byte.readByte (encode h) (ptr p.offset)=some (bytes 0) := by
        simpa [ptr,B20.C.Byte.Pointer.add] using reads 0
      have h1 : B20.C.Byte.readByte (encode h) ((ptr p.offset).add 1)=some (bytes 1) := reads 1
      have h2 : B20.C.Byte.readByte (encode h) ((ptr p.offset).add 2)=some (bytes 2) := reads 2
      have h3 : B20.C.Byte.readByte (encode h) ((ptr p.offset).add 3)=some (bytes 3) := reads 3
      simp [flagRead,h0,h1,h2,h3,le32]

theorem load32_iff (h : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 32)
    (hp : p.block=0) (ha : Allocated h p) (ht : p.elementBytes=4) :
    Load32 h p w ↔ flagRead (encode h) p.offset=some w := by
  refine ⟨fun hr => load32_to_model h p w hp hr,?_⟩
  intro hr
  obtain ⟨b0,h0,hr⟩ := Option.bind_eq_some_iff.mp hr
  obtain ⟨b1,h1,hr⟩ := Option.bind_eq_some_iff.mp hr
  obtain ⟨b2,h2,hr⟩ := Option.bind_eq_some_iff.mp hr
  obtain ⟨b3,h3,hr⟩ := Option.bind_eq_some_iff.mp hr
  have hw : b3 ++ (b2 ++ (b1 ++ b0))=w := Option.some.inj hr
  let bytes : Fin 4 → Byte := ![b0,b1,b2,b3]
  have initialized : ∀ i : Fin 4, h.bytes p.block (p.offset+i.val)=some (bytes i) := by
    intro i
    have read_contents (q : B20.C.Byte.Pointer) (b : Byte)
        (hr : B20.C.Byte.readByte (encode h) q=some b) : (encode h).contents q=some b := by
      by_cases hin : B20.C.Byte.inBounds (encode h) q
      · simpa [B20.C.Byte.readByte,hin] using hr
      · simp [B20.C.Byte.readByte,hin] at hr
    fin_cases i
    · simpa [bytes,encode,ptr,hp] using read_contents _ _ h0
    · simpa [bytes,encode,ptr,B20.C.Byte.Pointer.add,hp] using read_contents _ _ h1
    · simpa [bytes,encode,ptr,B20.C.Byte.Pointer.add,hp] using read_contents _ _ h2
    · simpa [bytes,encode,ptr,B20.C.Byte.Pointer.add,hp] using read_contents _ _ h3
  have he : le32 bytes=w := hw
  rw [← he]
  exact Load32.load h p bytes ha ht initialized

theorem store64_model (h : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 64)
    (hp : p.block=0) (ha : Allocated h p) (ht : p.elementBytes=8) (hw : h.writable p.block=true) :
    Store64 h p w (decode (B20.Word.LE.stored (encode h) (ptr p.offset) w)) := by
  refine ⟨ha,ht,hw,rfl,rfl,?_,?_⟩
  · intro i
    simpa [decode,hp,ptr,B20.C.Byte.Pointer.add,byte64,B20.Word.LE.byteOf] using B20.Word.LE.stored_bytes (encode h) (ptr p.offset) w i
  · intro block offset hout
    apply word_write_byte_frame
    intro i heq
    have hblock := congrArg B20.C.Byte.Pointer.block heq
    have hoffset := congrArg B20.C.Byte.Pointer.offset heq
    dsimp [ptr,B20.C.Byte.Pointer.add] at hblock hoffset
    have hi := i.isLt
    rw [hp] at hout
    omega

theorem store64_iff (h after : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 64)
    (hp : p.block=0) (ha : Allocated h p) (ht : p.elementBytes=8) :
    Store64 h p w after ↔ wordWrite (encode h) p.offset w=some (encode after) := by
  have owned (hw : h.writable p.block=true) : OwnedWriteRegion (encode h) (ptr p.offset) :=
    ⟨by simpa [encode,ptr,ht,hp] using allocated_bound h p ha,
     by simpa [encode,ptr,hp] using ha.2.2.2.2,by simpa [encode,ptr,hp] using hw⟩
  constructor
  · intro hs
    have hm := store64_model h p w hp ha ht hs.2.2.1
    have heq := store64_unique h after _ p w hs hm
    rw [heq,encode_decode]
    simp [wordWrite,owned hs.2.2.1]
  · intro hm
    have hw : h.writable p.block=true := by
      by_contra hn
      simp [wordWrite,OwnedWriteRegion,encode,ptr,← hp,hn] at hm
    have he : encode after=B20.Word.LE.stored (encode h) (ptr p.offset) w :=
      (Option.some.inj (by simpa [wordWrite,owned hw] using hm)).symm
    have heq : after=decode (B20.Word.LE.stored (encode h) (ptr p.offset) w) := by
      rw [← he,decode_encode]
    rw [heq]
    exact store64_model h p w hp ha ht hw

theorem store32_model (h : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 32)
    (hp : p.block=0) (ha : Allocated h p) (ht : p.elementBytes=4) (hw : h.writable p.block=true) :
    Store32 h p w (decode (flagStored (encode h) p.offset w)) := by
  refine ⟨ha,ht,hw,rfl,rfl,?_,?_⟩
  · intro i
    fin_cases i <;> simp [decode,flagStored,B20.C.Byte.putByte,ptr,B20.C.Byte.Pointer.add,hp,byte32,flagBytes]
  · intro block offset hout
    have hb := allocated_bound h p ha
    have writable : FlagWritable (encode h) p.offset := by
      rw [ht,hp] at hb
      simp only [FlagWritable,B20.C.Byte.inBounds,encode,ptr,B20.C.Byte.Pointer.add]
      exact ⟨⟨by omega,by simpa [hp] using ha.2.2.2.2⟩,
        ⟨by omega,by simpa [hp] using ha.2.2.2.2⟩,by simpa [hp] using hw⟩
    exact flag_write_byte_frame (encode h) (flagStored (encode h) p.offset w) p.offset w ⟨block,offset⟩ (by simp [flagWrite,writable])
      (by simpa [hp] using hout)

theorem store32_iff (h after : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 32)
    (hp : p.block=0) (ha : Allocated h p) (ht : p.elementBytes=4) :
    Store32 h p w after ↔ flagWrite (encode h) p.offset w=some (encode after) := by
  have writable (hw : h.writable p.block=true) : FlagWritable (encode h) p.offset := by
    have hb := allocated_bound h p ha
    rw [ht,hp] at hb
    simp only [FlagWritable,B20.C.Byte.inBounds,encode,ptr,B20.C.Byte.Pointer.add]
    exact ⟨⟨by omega,by simpa [hp] using ha.2.2.2.2⟩,
      ⟨by omega,by simpa [hp] using ha.2.2.2.2⟩,by simpa [hp] using hw⟩
  constructor
  · intro hs
    have heq := store32_unique h after _ p w hs (store32_model h p w hp ha ht hs.2.2.1)
    rw [heq,encode_decode]
    simp [flagWrite,writable hs.2.2.1]
  · intro hm
    have hw : h.writable p.block=true := by
      by_contra hn
      simp [flagWrite,FlagWritable,encode,← hp,hn] at hm
    have he : encode after=flagStored (encode h) p.offset w :=
      (Option.some.inj (by simpa [flagWrite,writable hw] using hm)).symm
    have heq : after=decode (flagStored (encode h) p.offset w) := by rw [← he,decode_encode]
    rw [heq]
    exact store32_model h p w hp ha ht hw

end FT1536.Source3.C99MemoryAccess

#print axioms FT1536.Source3.C99MemoryAccess.load32_iff
#print axioms FT1536.Source3.C99MemoryAccess.store64_iff
#print axioms FT1536.Source3.C99MemoryAccess.store32_iff
