import Source3.SelectedSmallCalls136
import Source3.GeneratedSamplerWords129
import Source3.C99BlockReads136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ConvertedWords136
open C99CompactState115 (reference)

def word (coefficient : Int) : BitVec 64 :=
  if coefficient = -1 then FprTernary136.negative
  else if coefficient = 0 then 0 else FprTernary136.positive

def fWord (i : Fin 1536) := word ((C99FiniteMap114.lookup GeneratedSamplerWords129.fWords i.val).getD 0)
def gWord (i : Fin 1536) := word ((C99FiniteMap114.lookup GeneratedSamplerWords129.gWords i.val).getD 0)
def fPointer (i : Fin 1536) : C99MemoryReference.ArrayPointer :=
  {GeneratedConversion136F23.pointer with index := GeneratedConversion136F23.pointer.index+i.val}
def gPointer (i : Fin 1536) : C99MemoryReference.ArrayPointer :=
  {GeneratedConversion136G23.pointer with index := GeneratedConversion136G23.pointer.index+i.val}

def imageHeap := C99BlockReads136.isolated 31 GeneratedConversion136G23.dataBlock

theorem actual_block : C99FiniteMap114.lookup SelectedSmallGComplete136.after.heap.blocks 31=
    some GeneratedConversion136G23.dataBlock := by
  change C99FiniteMap114.lookup (C99LazyBlock129.putBlock GeneratedConversion136G23.before.heap
    GeneratedConversion136G23.pointer.block GeneratedConversion136G23.dataBlock).blocks 31=_
  rw [C99LazyBlock129.lookup_put]
  rfl

theorem block_same (pointer : C99MemoryReference.ArrayPointer) (block : pointer.block=31) :
    C99FiniteMap114.lookup SelectedSmallGComplete136.after.heap.blocks pointer.block=
      C99FiniteMap114.lookup imageHeap.blocks pointer.block := by
  rw [block,actual_block]
  exact (C99BlockReads136.isolated_lookup 31 GeneratedConversion136G23.dataBlock).symm

def index (part : Fin 24) (offset : Fin 64) : Fin 1536 := ⟨64*part.val+offset.val,by omega⟩

end FT1536.Source3.ConvertedWords136
