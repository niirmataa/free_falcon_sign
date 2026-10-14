import Source3.C99LoadLayout123
import Source3.KeygenRev10Cert

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRevObject123
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open C99FiniteInit123 (install metadata)

def words (i : Fin 1024) : BitVec 16 := BitVec.ofNat 16 (KeygenRev10.bitrev10 i.val)
def heap (before : Heap) (block : Nat) : Heap :=
  install before block (2*1024) false (C99FiniteWords123.words16 words)
def pointer (block : Nat) : ArrayPointer := ⟨block,0,1024,2,0⟩

theorem object (before : Heap) (block : Nat) :
    KeygenMkgm3RevMemory.SourceTable (memory (heap before block)) (pointer block) := by
  have size : (memory (heap before block)).size block=2048 := by
    unfold heap
    rw [(metadata before block _ false (C99FiniteWords123.words16 words)).1]
    simp
  have readonly : (memory (heap before block)).writable block=false := by
    unfold heap
    rw [(metadata before block _ false (C99FiniteWords123.words16 words)).2]
    simp
  refine ⟨readonly,(List.range 1024).map KeygenRev10.bitrev10,KeygenRev10Cert.rawTable_exact,?_⟩
  intro i value member
  have bound : i<1024 := by
    by_contra outside
    have absent : ((List.range 1024).map KeygenRev10.bitrev10)[i]?=none :=
      List.getElem?_eq_none_iff.mpr (by simpa using (show 1024 ≤ i by omega))
    rw [absent] at member
    cases member
  have valueEq : KeygenRev10.bitrev10 i=value := by
    simpa [List.getElem?_map,List.getElem?_range,bound] using member
  rw [← valueEq]
  have loaded := C99FiniteWords123.load16 before block 1024 false words (by decide) ⟨i,bound⟩
  refine C99LoadLayout123.load16 _ _ _ _ loaded ?_ rfl rfl ?_
  · change 0<2 ∧ 0%2=0 ∧ 0+i<1024 ∧ 0+2*1024≤(memory (heap before block)).size block ∧
      (memory (heap before block)).size block<2^64
    rw [size]
    exact ⟨by decide,by decide,by omega,by decide,by decide⟩
  · simp [KeygenSmallOutput.element,pointer,ArrayPointer.offset]

end FT1536.Source3.KeygenRevObject123
