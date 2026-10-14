import Source3.C99LoadLayout123
import Source3.KeygenPrimeTableBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPrimeObjects123
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open C99FiniteInit123 (install words32 metadata)
open KeygenStaticTables

def fieldIndex : KeygenLevelCalls.Field → Fin 3
  | .p => 0 | .g => 1 | .s => 2

def words (table : PrimeTable) (j : Fin (3*rowCount table)) : BitVec 32 :=
  let value := ((values table)[j.val/3]?).getD (0,0,0)
  BitVec.ofNat 32 (if j.val%3=0 then value.1 else if j.val%3=1 then value.2.1 else value.2.2)

def heap (before : Heap) (block : Nat) (table : PrimeTable) : Heap :=
  install before block (4*(3*rowCount table)) false (words32 (words table))

def pointer (block : Nat) (table : PrimeTable) : ArrayPointer := ⟨block,0,rowCount table,12,0⟩

theorem word_at (table : PrimeTable) (i : Nat) (value : Nat×Nat×Nat)
    (member : (values table)[i]?=some value) (field : KeygenLevelCalls.Field) (bound : i<rowCount table) :
    words table ⟨3*i+(fieldIndex field).val,by have := (fieldIndex field).isLt; omega⟩=
      BitVec.ofNat 32 (fieldValue value field) := by
  have small := (fieldIndex field).isLt
  have div : (3*i+(fieldIndex field).val)/3=i := by omega
  have mod : (3*i+(fieldIndex field).val)%3=(fieldIndex field).val := by omega
  simp only [words,div,mod,member,Option.getD_some]
  cases field <;> rfl

theorem object (before : Heap) (block : Nat) (table : PrimeTable) :
    PrimeObject (memory (heap before block table)) (pointer block table) table := by
  have size : (memory (heap before block table)).size block=4*(3*rowCount table) := by
    unfold heap
    rw [(metadata before block _ false (words32 (words table))).1]
    simp
  have readonly : (memory (heap before block table)).writable block=false := by
    unfold heap
    rw [(metadata before block _ false (words32 (words table))).2]
    simp
  refine ⟨rfl,rfl,rfl,readonly,?_,?_,?_⟩
  · change 0+12*rowCount table≤(memory (heap before block table)).size block
    rw [size]
    omega
  · change (memory (heap before block table)).size block<2^64
    rw [size]
    cases table <;> decide
  · intro i value member field
    have bound : i<rowCount table := by
      have length := KeygenPrimeTableBinding.source_length table
      by_contra outside
      have absent : (values table)[i]?=none := List.getElem?_eq_none_iff.mpr (by omega)
      rw [absent] at member
      cases member
    have slotBound : 3*i+(fieldIndex field).val<3*rowCount table := by
      have := (fieldIndex field).isLt
      omega
    have loaded := C99FiniteWords123.load32 before block (3*rowCount table) false (words table)
      (by cases table <;> decide) ⟨3*i+(fieldIndex field).val,slotBound⟩
    rw [word_at table i value member field bound] at loaded
    have address : (⟨block,4*(3*i+(fieldIndex field).val),1,4,0⟩ : ArrayPointer)=
        primeField (pointer block table) i field := by
      cases field <;> simp [primeField,pointer,ArrayPointer.offset,fieldIndex,KeygenLevelCalls.Field.offset,
        Nat.mul_add] <;> omega
    rw [address] at loaded
    exact loaded

end FT1536.Source3.KeygenPrimeObjects123
