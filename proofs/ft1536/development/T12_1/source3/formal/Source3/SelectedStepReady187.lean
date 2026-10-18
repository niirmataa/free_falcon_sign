import Source3.SelectedStepPrefix187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedStepReady187
open C99MemoryReference (Load64)
open KeygenSmallOutput (element)
open SelectedRootStatics175 (small3)
open KeygenFullData127 (primes rev)
open SelectedStepMove187 (after)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)

theorem block (b : Nat) (separate : b≠31) : KeygenMakeObjects.Block FirstStepEntry187.entry.heap after.heap b := by
  refine ⟨congrFun (congrArg C99MemoryReference.Memory.size SelectedStepLayout187.heap) b,
    congrFun (congrArg C99MemoryReference.Memory.writable SelectedStepLayout187.heap) b,?_⟩
  intro offset
  rw [SelectedStepMove187.outside b offset (Or.inl separate),SelectedStepLayout187.heap]

theorem first_length : Load64 after.heap (element small3 1) 1 :=
  KeygenCallerShape123.load64_block _ _ _ _ (block small3.block (by decide)) StepStaticInputs187.first

theorem second_length : Load64 after.heap (element small3 2) 2 :=
  KeygenCallerShape123.load64_block _ _ _ _ (block small3.block (by decide)) StepStaticInputs187.second

theorem prime_object : KeygenStaticTables.PrimeObject after.heap primes .ternary :=
  KeygenMakeEntry.prime_block _ _ primes (block primes.block (by decide)) StepStaticInputs187.prime_object

theorem rev_source : KeygenMkgm3RevMemory.SourceTable after.heap rev :=
  KeygenMakeEntry.rev_block _ _ rev (block rev.block (by decide)) StepStaticInputs187.rev_source

theorem prime_binding : after.arrays "primes".toList=some primes := rfl
theorem global_prime_binding : after.arrays "PRIMES3".toList=some primes := StepStaticInputs187.prime_binding
theorem rev_binding : after.arrays "REV10".toList=some rev := StepStaticInputs187.rev_binding
theorem small_binding : after.arrays "MAX_BL_SMALL3".toList=some small3 := StepStaticInputs187.small_binding
theorem logn_cell : Slot after "logn" 9 := rfl
theorem depth_cell : Slot after "depth" 1 := rfl
theorem ternary_cell : Slot after "ter" 1 := rfl
theorem in_ntt_cell : after.locals "in_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem out_ntt_cell : after.locals "out_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem n_cell : USlot after "n" 512 := rfl
theorem hn_cell : USlot after "hn" 256 := rfl
theorem slen_cell : USlot after "slen" 1 := rfl
theorem tlen_cell : USlot after "tlen" 2 := rfl
theorem u_declared : after.locals "u".toList=some (.uint64,none) := rfl
theorem scratch_writable : after.heap.writable 31=true := SelectedStepMove187.writable

end FT1536.Source3.SelectedStepReady187
