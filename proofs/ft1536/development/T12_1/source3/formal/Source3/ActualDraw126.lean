import Source3.ActualExtractBody126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ActualDraw126
open C99CompactState115 (State reference)
open ActualExtractPrep126 (ctx caller)
open ActualExtractBody126 (extracted)

def readResult := C99FiniteRead114.read64 extracted.heap (KeygenRngSource.object 7)
theorem read_defined : readResult.isSome=true := by decide +kernel
def word : BitVec 64 := readResult.get read_defined
theorem read_computed : C99FiniteRead114.read64 extracted.heap (KeygenRngSource.object 7)=some word :=
  SelectedInput124.option_get readResult read_defined

def after : State := {caller with heap := C99FiniteAllocation115.restore caller.heap extracted.heap 7}

/-- Closed first actual get_rng_u64: source SHAKE extraction writes the
    temporary object, that SAME object is read, then its lifetime ends. -/
theorem source : KeygenRngSource.Call ctx (reference caller) (reference after) word := by
  unfold after
  rw [C99CompactState115.reference_heap caller (C99FiniteAllocation115.restore caller.heap extracted.heap 7),
    C99FiniteAllocation115.restore_source]
  have extraction := ActualExtractBody126.call
  change ShakeExtractFrame.Call ctx
    (reference {caller with heap := C99FiniteAllocation115.allocate caller.heap 7 8})
    (KeygenRngSource.bytes 7) (.uint64 8) (reference extracted) at extraction
  rw [C99CompactState115.reference_heap caller (C99FiniteAllocation115.allocate caller.heap 7 8),
    KeygenRngCompute121.allocate_bound] at extraction
  exact .run 7 (reference extracted) word ActualExtractPrep126.fresh extraction
    (C99FiniteRead114.read64_sound extracted.heap (KeygenRngSource.object 7) word read_computed)

theorem cursor : C99FiniteRead114.read64 after.heap (ShakeExtractSource.field ctx .dptr)=some 8 := by decide +kernel
theorem disposed : KeygenRngSource.Fresh (reference after).heap 7 :=
  (C99FiniteAllocation115.fresh_iff after.heap 7).mp (by decide +kernel)

end FT1536.Source3.ActualDraw126
