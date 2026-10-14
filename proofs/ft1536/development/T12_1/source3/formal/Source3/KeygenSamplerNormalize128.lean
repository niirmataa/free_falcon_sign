import Source3.KeygenPrefixFrame128
import Source3.KeygenInputBytes124

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerNormalize128
open C99MemoryReference
open C99FiniteMemory114 (Block memory putBlock)
open C99CompactState115 (State reference)
open KeygenSamplerPrefix128 (Prefix)

def normalize (ctx : ShakeExtractSource.Layout) (dst : ArrayPointer) (before : State)
    (context coefficients : Block) (locals : C99CompactCells115.Locals) : State :=
  {before with heap := putBlock (putBlock before.heap ctx.block context) dst.block coefficients,locals := locals}

/-- Changed blocks are checked completely; source frames preserve every
    other live object, while finite-memory bounds cover dead objects too. -/
theorem heap_equal (ctx : ShakeExtractSource.Layout) (dst : ArrayPointer) (count : Nat)
    (before after : State) (context coefficients : Block)
    (source : Prefix ctx count (reference before) (reference after))
    (binding : (reference before).arrays "v".toList=some dst)
    (contextFound : C99FiniteMap114.lookup after.heap.blocks ctx.block=some context)
    (coefficientsFound : C99FiniteMap114.lookup after.heap.blocks dst.block=some coefficients) :
    memory after.heap=memory (putBlock (putBlock before.heap ctx.block context) dst.block coefficients) := by
  have stable := KeygenPrefixFrame128.stable ctx count (reference before) (reference after) source
  have sizes : (memory after.heap).size=(memory before.heap).size := stable.sizes
  apply C99FiniteAllocation115.memory_ext
  · intro block offset
    rw [C99FiniteMemory114.bytes_putBlock,C99FiniteMemory114.bytes_putBlock]
    by_cases dest : block=dst.block
    · subst block
      simp [memory,coefficientsFound]
    · rw [ite_eq_right dest]
      by_cases rng : block=ctx.block
      · subst block
        simp [memory,contextFound]
      · rw [ite_eq_right rng]
        by_cases live : 0<(memory before.heap).size block
        · exact (KeygenPrefixFrame128.outside ctx count (reference before) (reference after) dst block
            (Ne.symm rng) (Ne.symm dest) source live binding).2.2 offset
        · have dead : (memory before.heap).size block=0 := by omega
          have stillDead : (memory after.heap).size block=0 := by rw [sizes]; exact dead
          rw [KeygenInputBytes124.beyond_object after.heap block offset (by rw [stillDead]; omega),
            KeygenInputBytes124.beyond_object before.heap block offset (by rw [dead]; omega)]
  · intro block
    rw [C99FiniteMemory114.size_putBlock,C99FiniteMemory114.size_putBlock]
    by_cases dest : block=dst.block
    · subst block
      simp [memory,coefficientsFound]
    · rw [ite_eq_right dest]
      by_cases rng : block=ctx.block
      · subst block
        simp [memory,contextFound]
      · rw [ite_eq_right rng]
        exact congrFun stable.sizes block
  · intro block
    rw [C99FiniteMemory114.writable_putBlock,C99FiniteMemory114.writable_putBlock]
    by_cases dest : block=dst.block
    · subst block
      simp [memory,coefficientsFound]
    · rw [ite_eq_right dest]
      by_cases rng : block=ctx.block
      · subst block
        simp [memory,contextFound]
      · rw [ite_eq_right rng]
        exact congrFun stable.writable block

theorem reference_equal (ctx : ShakeExtractSource.Layout) (dst : ArrayPointer) (count : Nat)
    (before after : State) (context coefficients : Block) (locals : C99CompactCells115.Locals)
    (source : Prefix ctx count (reference before) (reference after))
    (binding : (reference before).arrays "v".toList=some dst)
    (contextFound : C99FiniteMap114.lookup after.heap.blocks ctx.block=some context)
    (coefficientsFound : C99FiniteMap114.lookup after.heap.blocks dst.block=some coefficients)
    (localValues : after.locals=locals) :
    reference after=reference (normalize ctx dst before context coefficients locals) := by
  have heap := heap_equal ctx dst count before after context coefficients source binding contextFound coefficientsFound
  have stable := KeygenPrefixFrame128.stable ctx count (reference before) (reference after) source
  have arrays := KeygenPrefixFrame128.arrays ctx count (reference before) (reference after) source
  change C99NameMap115.lookup after.arrays=C99NameMap115.lookup before.arrays at arrays
  have globals : C99CompactCells115.environment after.globals=C99CompactCells115.environment before.globals := stable.globals
  have tables : C99NameMap115.lookup after.tables=C99NameMap115.lookup before.tables := stable.tables
  unfold reference normalize
  rw [heap,localValues,arrays,globals,tables]

theorem source_normalized (ctx : ShakeExtractSource.Layout) (dst : ArrayPointer) (count : Nat)
    (before after : State) (context coefficients : Block) (locals : C99CompactCells115.Locals)
    (source : Prefix ctx count (reference before) (reference after))
    (binding : (reference before).arrays "v".toList=some dst)
    (contextFound : C99FiniteMap114.lookup after.heap.blocks ctx.block=some context)
    (coefficientsFound : C99FiniteMap114.lookup after.heap.blocks dst.block=some coefficients)
    (localValues : after.locals=locals) :
    Prefix ctx count (reference before) (reference (normalize ctx dst before context coefficients locals)) := by
  rw [← reference_equal ctx dst count before after context coefficients locals source binding contextFound coefficientsFound localValues]
  exact source

end FT1536.Source3.KeygenSamplerNormalize128
