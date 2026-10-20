import Source3.C99MemoryReference
import Source3.StableBinaryByteView

namespace FT1536.Source3.C99MemoryBridge

def encode (h : C99MemoryReference.Memory) : B20.C.Byte.Memory :=
  ⟨fun p => h.bytes p.block p.offset,h.size,h.writable⟩
def decode (h : B20.C.Byte.Memory) : C99MemoryReference.Memory :=
  ⟨fun block offset => h.contents ⟨block,offset⟩,h.length,h.writable⟩

/- This adapter is a bijection of ALL bytes and permissions, not merely a
   relation on values/scratch/bad that could discard a caller-memory change. -/
theorem encode_decode (h : B20.C.Byte.Memory) : encode (decode h)=h := by
  cases h
  rfl
theorem decode_encode (h : C99MemoryReference.Memory) : decode (encode h)=h := by
  cases h
  rfl

def Related (a : C99MemoryReference.Memory) (b : B20.C.Byte.Memory) : Prop :=
  (∀ block offset, a.bytes block offset=b.contents ⟨block,offset⟩) ∧
  a.size=b.length ∧ a.writable=b.writable

theorem related_iff (a : C99MemoryReference.Memory) (b : B20.C.Byte.Memory) :
    Related a b ↔ encode a=b := by
  constructor
  · rintro ⟨hb,hs,hw⟩
    have hbytes : (encode a).contents=b.contents := by
      funext p
      exact hb p.block p.offset
    cases a; cases b
    simp_all [encode]
  · intro h
    subst b
    exact ⟨fun _ _ => rfl,rfl,rfl⟩

theorem load64_source_to_interpreter (heap : C99MemoryReference.Memory)
    (p : C99MemoryReference.ArrayPointer) (w : BitVec 64)
    (hp : p.block=0)
    (hs : C99MemoryReference.Load64 heap p w) :
    StableBinaryByteView.wordRead (encode heap) p.offset=some w := by
  cases hs with
  | load bytes alloc size initialized =>
      have hbound : p.offset+8≤heap.size p.block := by
        obtain ⟨_,_,hi,hsize,_⟩ := alloc
        simp only [C99MemoryReference.ArrayPointer.offset,size] at *
        omega
      have read : B20.C.Byte.ReadRegion (encode heap) (StableBinaryByteView.ptr p.offset) := by
        refine ⟨?_,?_,?_⟩
        · simpa [encode,StableBinaryByteView.ptr,hp] using hbound
        · simpa [encode,StableBinaryByteView.ptr,hp] using alloc.2.2.2.2
        · intro i
          have hbyte := initialized i
          simpa [encode,StableBinaryByteView.ptr,B20.C.Byte.Pointer.add,hp,hbyte]
            using congrArg Option.isSome hbyte
      have hbytes : B20.Word.LE.bufferBytes (encode heap) (StableBinaryByteView.ptr p.offset)=bytes := by
        funext i
        have hbyte := initialized i
        change ((encode heap).contents ((StableBinaryByteView.ptr p.offset).add i.val)).getD 0=bytes i
        simp [encode,StableBinaryByteView.ptr,B20.C.Byte.Pointer.add,← hp,hbyte]
      change (if B20.C.Byte.ReadRegion (encode heap) (StableBinaryByteView.ptr p.offset) then
        some (B20.Word.LE.join (B20.Word.LE.bufferBytes (encode heap) (StableBinaryByteView.ptr p.offset)))
          else none)=some _
      rw [ite_eq_left read,hbytes]
      rfl

end FT1536.Source3.C99MemoryBridge

#print axioms FT1536.Source3.C99MemoryBridge.related_iff
#print axioms FT1536.Source3.C99MemoryBridge.load64_source_to_interpreter
