import Source3.DeepestDeclarations175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedRootStatics175
open C99CompactState115 (reference)
open KeygenFullData127 (env primes)
open SelectedRootContext175 (old)

def small3 := KeygenTableObjects127.pointer64 26 (KeygenStaticTables.sizes .small3)

theorem stable : KeygenMemoryStability.Stable (reference old).heap SelectedPublicSuccess174.after.heap :=
  KeygenMemoryStability.trans _ _ _ SelectedPublicMemory157.stable
    (KeygenPublicStability.call _ _ (.int32 1) SelectedPublicSuccess174.source)

theorem readonly : (reference old).heap.writable small3.block=false := by decide +kernel

theorem old_length : C99MemoryReference.Load64 (reference old).heap (KeygenSmallOutput.element small3 10) 335 :=
  C99FiniteRead114.read64_sound old.heap _ _ (by decide +kernel)

theorem length : C99MemoryReference.Load64 SelectedDeepestEntry175.entry.heap (KeygenSmallOutput.element small3 10) 335 :=
  KeygenCallerShape123.load64_block _ _ _ _
    ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset readonly⟩ old_length

theorem small_binding : SelectedDeepestEntry175.entry.arrays "MAX_BL_SMALL3".toList=some small3 := by
  change SelectedPublicBinding157.before.tables "MAX_BL_SMALL3".toList=some small3
  rw [SelectedRootWords175.table_frame]
  decide +kernel

theorem primes_binding : SelectedDeepestEntry175.entry.arrays "PRIMES3".toList=some primes :=
  SelectedRootEntry175.source.table

end FT1536.Source3.SelectedRootStatics175
