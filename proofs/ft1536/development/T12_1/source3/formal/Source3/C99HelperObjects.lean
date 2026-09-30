import Source3.C99CheckBridge
import Source3.HelperAllTotal

namespace FT1536.Source3.C99HelperObjects
open C99MemoryReference C99MemoryBridge StableBinaryByteView

def values (l : StableBinary.Layout) (i : Nat) : ArrayPointer := ⟨0,l.values,l.length,8,i⟩
def scratch (l : StableBinary.Layout) (i : Nat) : ArrayPointer := ⟨0,l.scratch,l.length,8,i⟩
def bad (l : StableBinary.Layout) : ArrayPointer := ⟨0,l.bad,1,4,0⟩

theorem values_offset (l : StableBinary.Layout) (i : Nat) : (values l i).offset=StableBinary.addr l.values i := rfl
theorem scratch_offset (l : StableBinary.Layout) (i : Nat) : (scratch l i).offset=StableBinary.addr l.scratch i := rfl
theorem bad_offset (l : StableBinary.Layout) : (bad l).offset=l.bad := by simp [bad,ArrayPointer.offset]

theorem values_allocated (l : StableBinary.Layout) (k i : Nat) (h : C99MemoryReference.Memory)
    (hl : l.wellFormed k) (legal : Legal l (encode h)) (hi : i<l.length) : Allocated h (values l i) := by
  have hp : 0<l.length := by rw [hl.1]; exact pow_pos (by decide) k
  have hb := legal.valuesWritable (l.length-1) (by omega)
  dsimp [OwnedWriteRegion,ptr,encode,StableBinary.addr] at hb
  refine ⟨by change 0<8; decide,hl.2.2.1,hi,?_,hb.2.1⟩
  dsimp [values]
  omega

theorem scratch_allocated (l : StableBinary.Layout) (k i : Nat) (h : C99MemoryReference.Memory)
    (hl : l.wellFormed k) (legal : Legal l (encode h)) (hi : i<l.length) : Allocated h (scratch l i) := by
  have hp : 0<l.length := by rw [hl.1]; exact pow_pos (by decide) k
  have hb := legal.scratchWritable (l.length-1) (by omega)
  dsimp [OwnedWriteRegion,ptr,encode,StableBinary.addr] at hb
  refine ⟨by change 0<8; decide,hl.2.2.2.1,hi,?_,hb.2.1⟩
  dsimp [scratch]
  omega

theorem bad_allocated (l : StableBinary.Layout) (k : Nat) (h : C99MemoryReference.Memory)
    (hl : l.wellFormed k) (legal : Legal l (encode h)) : Allocated h (bad l) := by
  have hb := legal.badWritable.2.1
  dsimp [B20.C.Byte.inBounds,ptr,B20.C.Byte.Pointer.add,encode] at hb
  refine ⟨by change 0<4; decide,hl.2.2.2.2.1,by change 0<1; decide,?_,hb.2⟩
  dsimp [bad]
  omega

theorem values_add (l : StableBinary.Layout) (start i : Nat) (hb : start+i≤l.length) :
    PointerAdd (values l start) i (values l (start+i)) := PointerAdd.within _ _ hb
theorem scratch_add (l : StableBinary.Layout) (i : Nat) (hb : i≤l.length) :
    PointerAdd (scratch l 0) i (scratch l i) := by
  simpa [scratch] using PointerAdd.within (scratch l 0) i (by simpa [scratch] using hb)

end FT1536.Source3.C99HelperObjects

#print axioms FT1536.Source3.C99HelperObjects.values_allocated
#print axioms FT1536.Source3.C99HelperObjects.bad_allocated
