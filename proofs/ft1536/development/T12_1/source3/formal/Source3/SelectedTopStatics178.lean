import Source3.SelectedTopPrefix177

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopStatics178
open C99MemoryReference
open KeygenFullData127 (primes rev)
open SelectedTopMove177 (after)

noncomputable def old := SelectedMakeFgSetup176.after

theorem before_heap : SelectedTopMove177.before.heap=SelectedMakeFgConvert176.after.heap :=
  SelectedTopLayout177.heap

theorem sizes : after.heap.size=old.heap.size :=
  (congrArg Memory.size before_heap).trans SelectedMakeFgConvert176.frame.sizes

theorem permissions : after.heap.writable=old.heap.writable :=
  (congrArg Memory.writable before_heap).trans SelectedMakeFgConvert176.frame.writable

theorem block (b : Nat) (separate : b≠31) : KeygenMakeObjects.Block old.heap after.heap b := by
  refine ⟨congrFun sizes b,congrFun permissions b,?_⟩
  intro offset
  rw [SelectedTopMove177.outside b offset (Or.inl separate),before_heap]
  exact SelectedMakeFgConvert176.frame.bytes b offset (Or.inl separate) (Or.inl separate)

theorem prime_binding : after.arrays "PRIMES3".toList=some primes := by
  change SelectedMakeFgConvert176.after.tables "PRIMES3".toList=some primes
  rw [SelectedMakeFgConvert176.frame.tables]
  exact SelectedRootEntry175.source.table

theorem rev_binding : after.arrays "REV10".toList=some rev := by
  change SelectedMakeFgConvert176.after.tables "REV10".toList=some rev
  rw [SelectedMakeFgConvert176.frame.tables]
  exact SelectedRootEntry175.source.revBinding

theorem prime_object : KeygenStaticTables.PrimeObject after.heap primes .ternary :=
  KeygenMakeEntry.prime_block old.heap after.heap primes (block primes.block (by decide))
    SelectedRootEntry175.source.primeObject

theorem rev_source : KeygenMkgm3RevMemory.SourceTable after.heap rev :=
  KeygenMakeEntry.rev_block old.heap after.heap rev (block rev.block (by decide))
    SelectedRootEntry175.source.revSource

theorem p_bytes : Load32 after.heap (KeygenLevelCalls.fieldPointer primes .p) KeygenNinv31.prime :=
  prime_object.2.2.2.2.2.2 0 (KeygenStaticReads.first .ternary) (KeygenStaticReads.first_value .ternary) .p

theorem g_bytes : Load32 after.heap (KeygenLevelCalls.fieldPointer primes .g) KeygenFirstPrime.generator :=
  prime_object.2.2.2.2.2.2 0 (KeygenStaticReads.first .ternary) (KeygenStaticReads.first_value .ternary) .g

end FT1536.Source3.SelectedTopStatics178
