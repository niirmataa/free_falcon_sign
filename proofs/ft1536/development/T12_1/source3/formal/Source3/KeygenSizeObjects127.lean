import Source3.KeygenTableObjects127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSizeObjects127
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open KeygenTableObjects127 (table64 pointer64)

theorem object (before : Heap) (block : Nat) (table : KeygenStaticTables.SizeTable) :
    KeygenStaticTables.SizeObject (memory (table64 before block (KeygenStaticTables.sizes table)))
      (pointer64 block (KeygenStaticTables.sizes table)) table := by
  have size : (memory (table64 before block (KeygenStaticTables.sizes table))).size block=
      8*(KeygenStaticTables.sizes table).length := by
    unfold table64
    rw [(C99FiniteInit123.metadata _ _ _ _ _).1]
    simp
  have fits : 8*(KeygenStaticTables.sizes table).length<2^64 := by cases table <;> decide
  refine ⟨rfl,rfl,rfl,KeygenTableObjects127.readonly64 _ _ _,?_,?_,?_⟩
  · change 0+8*(KeygenStaticTables.sizes table).length≤(memory (table64 before block (KeygenStaticTables.sizes table))).size block
    rw [size]
    omega
  · change (memory (table64 before block (KeygenStaticTables.sizes table))).size block<2^64
    rw [size]
    exact fits
  · intro i value member
    have bound : i<(KeygenStaticTables.sizes table).length := by
      by_contra outside
      have absent : (KeygenStaticTables.sizes table)[i]?=none := List.getElem?_eq_none_iff.mpr (by omega)
      rw [absent] at member
      cases member
    have equal : (KeygenStaticTables.sizes table)[i]=value := by
      rw [List.getElem?_eq_getElem bound] at member
      exact Option.some.inj member
    rw [←equal]
    simpa only [KeygenSmallOutput.element,pointer64,Nat.zero_add] using
      KeygenTableObjects127.read64 before block (KeygenStaticTables.sizes table) fits ⟨i,bound⟩

end FT1536.Source3.KeygenSizeObjects127
