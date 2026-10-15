import Source3.C99LazyBlock129
import Source3.KeygenSamplerNormalize128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLazySampler129
open C99FiniteMemory114 (Block Heap memory putBlock)
open C99CompactState115 (State reference)
open C99MemoryReference (ArrayPointer)

theorem put_congr (first second : Heap) (same : memory first=memory second)
    (block : Nat) (data : Block) : memory (putBlock first block data)=memory (putBlock second block data) := by
  apply C99FiniteAllocation115.memory_ext
  · intro other offset
    rw [C99FiniteMemory114.bytes_putBlock,C99FiniteMemory114.bytes_putBlock,same]
  · intro other
    rw [C99FiniteMemory114.size_putBlock,C99FiniteMemory114.size_putBlock,same]
  · intro other
    rw [C99FiniteMemory114.writable_putBlock,C99FiniteMemory114.writable_putBlock,same]

theorem double_equal (heap : Heap) (first second : Nat) (a b : Block) :
    memory (C99LazyBlock129.putBlock (C99LazyBlock129.putBlock heap first a) second b)=
      memory (putBlock (putBlock heap first a) second b) :=
  (C99LazyBlock129.memory_equal _ second b).trans
    (put_congr _ _ (C99LazyBlock129.memory_equal heap first a) second b)

def normalize (ctx : ShakeExtractSource.Layout) (dst : ArrayPointer) (before : State)
    (context coefficients : Block) (locals : C99CompactCells115.Locals) : State :=
  {before with
    heap := C99LazyBlock129.putBlock (C99LazyBlock129.putBlock before.heap ctx.block context) dst.block coefficients
    locals := locals}

theorem reference_equal (ctx : ShakeExtractSource.Layout) (dst : ArrayPointer) (before : State)
    (context coefficients : Block) (locals : C99CompactCells115.Locals) :
    reference (normalize ctx dst before context coefficients locals)=
      reference (KeygenSamplerNormalize128.normalize ctx dst before context coefficients locals) := by
  unfold normalize KeygenSamplerNormalize128.normalize reference
  rw [double_equal]

/-- Same complete source frames and checked images as128, with an
    extensionally equal finite representation that avoids replaying old heaps. -/
theorem source_normalized (ctx : ShakeExtractSource.Layout) (dst : ArrayPointer) (count : Nat)
    (before after : State) (context coefficients : Block) (locals : C99CompactCells115.Locals)
    (source : KeygenSamplerPrefix128.Prefix ctx count (reference before) (reference after))
    (binding : (reference before).arrays "v".toList=some dst)
    (contextFound : C99FiniteMap114.lookup after.heap.blocks ctx.block=some context)
    (coefficientsFound : C99FiniteMap114.lookup after.heap.blocks dst.block=some coefficients)
    (localValues : after.locals=locals) :
    KeygenSamplerPrefix128.Prefix ctx count (reference before) (reference (normalize ctx dst before context coefficients locals)) := by
  rw [reference_equal]
  exact KeygenSamplerNormalize128.source_normalized ctx dst count before after context coefficients locals
    source binding contextFound coefficientsFound localValues

end FT1536.Source3.KeygenLazySampler129
