import Source3.C99FiniteCopy114

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99FiniteControls114
open C99MemoryReference
open C99FiniteMemory114
open C99FiniteRead114
open C99FiniteWrite114
open C99FiniteCopy114

/-- Hand-checkable physical-memory controls, including rejected accesses.
    These do not replace the preceding universal source soundness proofs. -/
def initial : Heap := putBlock ⟨.empty⟩ 7 ⟨32,true,none,.empty⟩
def wordPointer : ArrayPointer := ⟨7,8,1,8,0⟩
def word : BitVec 64 := 0x0807060504030201
def written : Heap := write64 initial wordPointer word

theorem uninitialized_rejected : read64 initial wordPointer = none := by decide +kernel

theorem word_roundtrip : read64 written wordPointer = some word := by decide +kernel

theorem low_half : read32 written ⟨7,8,1,4,0⟩ = some 0x04030201 := by decide +kernel

theorem high_half : read32 written ⟨7,12,1,4,0⟩ = some 0x08070605 := by decide +kernel

theorem unaligned_rejected : read64 written ⟨7,9,1,8,0⟩ = none := by decide +kernel

theorem extent_rejected : read64 written ⟨7,32,1,8,0⟩ = none := by decide +kernel

theorem unwritten_frame : (memory written).bytes 7 7 = none ∧ (memory written).bytes 7 16 = none := by decide +kernel

theorem overlap_rejected : copy written ⟨7,12,8,1,0⟩ ⟨7,8,8,1,0⟩ 8 = none := by decide +kernel

theorem nonoverlap_copy :
    (copy written ⟨7,16,8,1,0⟩ ⟨7,8,8,1,0⟩ 8).bind (fun heap => read64 heap ⟨7,16,1,8,0⟩) = some word := by decide +kernel

theorem read_only_fill_rejected :
    fill (putBlock initial 8 ⟨8,false,some 0,.empty⟩) ⟨8,0,8,1,0⟩ 8 1 = none := by decide +kernel

theorem explicit_uninitialized_override :
    (memory (putBlock initial 9 ⟨8,true,some 0,C99FiniteMap114.insert .empty 3 none⟩)).bytes 9 3 = none ∧
    (memory (putBlock initial 9 ⟨8,true,some 0,C99FiniteMap114.insert .empty 3 none⟩)).bytes 9 2 = some 0 := by decide +kernel

end FT1536.Source3.C99FiniteControls114
