import Source3.KeygenCallerConflict127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenTableObjects127
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open C99FiniteInit123 (install metadata words32 words64)

def table32 (before : Heap) (block : Nat) (values : List (BitVec 32)) : Heap :=
  install before block (4*values.length) false (words32 (fun i => values[i.val]))
def pointer32 (block : Nat) (values : List (BitVec 32)) : ArrayPointer := ⟨block,0,values.length,4,0⟩

theorem read32 (before : Heap) (block : Nat) (values : List (BitVec 32))
    (fits : 4*values.length<2^64) (i : Fin values.length) :
    Load32 (memory (table32 before block values)) {(pointer32 block values) with index := i.val} values[i.val] := by
  have size : (memory (table32 before block values)).size block=4*values.length := by
    unfold table32
    rw [(metadata _ _ _ _ _).1]
    simp
  have loaded := C99FiniteWords123.load32 before block values.length false (fun j => values[j.val]) fits i
  refine C99LoadLayout123.load32 _ _ _ _ loaded ?_ rfl rfl ?_
  · change 0<4 ∧ 0%4=0 ∧ i.val<values.length ∧ 0+4*values.length≤(memory (table32 before block values)).size block ∧
      (memory (table32 before block values)).size block<2^64
    rw [size]
    exact ⟨by decide,by decide,i.isLt,by omega,fits⟩
  · simp [pointer32,ArrayPointer.offset]

theorem static32 (before : Heap) (block : Nat) (values : List (BitVec 32)) (fits : 4*values.length<2^64) :
    KeygenZintCall.Static32 (memory (table32 before block values)) (pointer32 block values) values := by
  refine ⟨?_,rfl,rfl,rfl,rfl,?_,read32 before block values fits⟩
  · change (memory (table32 before block values)).writable block=false
    unfold table32
    rw [(metadata _ _ _ _ _).2]
    simp
  · change (memory (table32 before block values)).size block=4*values.length
    unfold table32
    rw [(metadata _ _ _ _ _).1]
    simp

def table64 (before : Heap) (block : Nat) (values : List (BitVec 64)) : Heap :=
  install before block (8*values.length) false (words64 (fun i => values[i.val]))
def pointer64 (block : Nat) (values : List (BitVec 64)) : ArrayPointer := ⟨block,0,values.length,8,0⟩

theorem read64 (before : Heap) (block : Nat) (values : List (BitVec 64))
    (fits : 8*values.length<2^64) (i : Fin values.length) :
    Load64 (memory (table64 before block values)) {(pointer64 block values) with index := i.val} values[i.val] := by
  have size : (memory (table64 before block values)).size block=8*values.length := by
    unfold table64
    rw [(metadata _ _ _ _ _).1]
    simp
  have loaded := C99FiniteWords123.load64 before block values.length false (fun j => values[j.val]) fits i
  refine C99LoadLayout123.load64 _ _ _ _ loaded ?_ rfl rfl ?_
  · change 0<8 ∧ 0%8=0 ∧ i.val<values.length ∧ 0+8*values.length≤(memory (table64 before block values)).size block ∧
      (memory (table64 before block values)).size block<2^64
    rw [size]
    exact ⟨by decide,by decide,i.isLt,by omega,fits⟩
  · simp [pointer64,ArrayPointer.offset]

theorem readonly64 (before : Heap) (block : Nat) (values : List (BitVec 64)) :
    (memory (table64 before block values)).writable block=false := by
  unfold table64
  rw [(metadata _ _ _ _ _).2]
  simp

end FT1536.Source3.KeygenTableObjects127
