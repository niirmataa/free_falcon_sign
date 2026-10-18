import Source3.StepDeclarations187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepStaticInputs187
open C99MemoryReference (Load64)
open C99CompactState115 (reference)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3 stable readonly)
open SelectedRootContext175 (old)
open KeygenFullData127 (primes rev)

noncomputable abbrev previous := SelectedMakeFgSetup176.after

theorem old_first : Load64 (reference old).heap (element small3 1) 1 :=
  C99FiniteRead114.read64_sound old.heap _ _ (by decide +kernel)

theorem old_second : Load64 (reference old).heap (element small3 2) 2 :=
  C99FiniteRead114.read64_sound old.heap _ _ (by decide +kernel)

theorem deepest_first : Load64 SelectedDeepestEntry175.entry.heap (element small3 1) 1 :=
  KeygenCallerShape123.load64_block _ _ _ _
    ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset readonly⟩ old_first

theorem deepest_second : Load64 SelectedDeepestEntry175.entry.heap (element small3 2) 2 :=
  KeygenCallerShape123.load64_block _ _ _ _
    ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset readonly⟩ old_second

theorem block (b : Nat) (separate : b≠31) : KeygenMakeObjects.Block previous.heap FirstStepEntry187.entry.heap b := by
  rw [FirstStepEntry187.entry_heap]
  refine ⟨congrFun (SelectedTopOutput186.sizes.trans SelectedMakeFgConvert176.frame.sizes) b,
    congrFun (SelectedTopOutput186.writable.trans SelectedMakeFgConvert176.frame.writable) b,?_⟩
  intro offset
  exact (SelectedTopOutput186.bytes b offset (Or.inl separate)).trans
    (SelectedMakeFgConvert176.frame.bytes b offset (Or.inl separate) (Or.inl separate))

theorem first : Load64 FirstStepEntry187.entry.heap (element small3 1) 1 :=
  KeygenCallerShape123.load64_block _ _ _ _ (block small3.block (by decide)) deepest_first

theorem second : Load64 FirstStepEntry187.entry.heap (element small3 2) 2 :=
  KeygenCallerShape123.load64_block _ _ _ _ (block small3.block (by decide)) deepest_second

theorem small_binding : FirstStepEntry187.entry.arrays "MAX_BL_SMALL3".toList=some small3 := by
  change SelectedMakeFgConvert176.after.tables "MAX_BL_SMALL3".toList=some small3
  rw [SelectedMakeFgConvert176.frame.tables]
  exact SelectedRootStatics175.small_binding

theorem prime_binding : FirstStepEntry187.entry.arrays "PRIMES3".toList=some primes := by
  change SelectedMakeFgConvert176.after.tables "PRIMES3".toList=some primes
  rw [SelectedMakeFgConvert176.frame.tables]
  exact SelectedRootEntry175.source.table

theorem rev_binding : FirstStepEntry187.entry.arrays "REV10".toList=some rev := by
  change SelectedMakeFgConvert176.after.tables "REV10".toList=some rev
  rw [SelectedMakeFgConvert176.frame.tables]
  exact SelectedRootEntry175.source.revBinding

theorem prime_object : KeygenStaticTables.PrimeObject FirstStepEntry187.entry.heap primes .ternary :=
  KeygenMakeEntry.prime_block previous.heap FirstStepEntry187.entry.heap primes (block primes.block (by decide))
    SelectedRootEntry175.source.primeObject

theorem rev_source : KeygenMkgm3RevMemory.SourceTable FirstStepEntry187.entry.heap rev :=
  KeygenMakeEntry.rev_block previous.heap FirstStepEntry187.entry.heap rev (block rev.block (by decide))
    SelectedRootEntry175.source.revSource

end FT1536.Source3.StepStaticInputs187
