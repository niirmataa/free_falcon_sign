import Source3.C99FiniteWrite114
import Source3.ShakeSeedMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99FiniteCopy114
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open C99FiniteRead114 (readVec readVec_sound)
open C99FiniteWrite114 (writeVec writeVec_metadata writeVec_at writeVec_frame)

def CopyGuard (heap : Heap) (dst src : ArrayPointer) (n : Nat) : Prop :=
  dst.offset+n≤(memory heap).size dst.block ∧ src.offset+n≤(memory heap).size src.block ∧
  (memory heap).size dst.block<2^64 ∧ (memory heap).size src.block<2^64 ∧
  (memory heap).writable dst.block=true ∧
  (dst.block≠src.block ∨ dst.offset+n≤src.offset ∨ src.offset+n≤dst.offset)

instance copyGuardDecidable (heap : Heap) (dst src : ArrayPointer) (n : Nat) :
    Decidable (CopyGuard heap dst src n) := by
  unfold CopyGuard
  infer_instance

def copy (heap : Heap) (dst src : ArrayPointer) (n : Nat) : Option Heap :=
  if CopyGuard heap dst src n then
    (readVec heap src.block src.offset n).map (writeVec heap dst.block dst.offset n)
  else none

theorem copy_sound (heap after : Heap) (dst src : ArrayPointer) (n : Nat)
    (copied : copy heap dst src n = some after) :
    Memcpy (memory heap) dst src n (memory after) := by
  unfold copy at copied
  split at copied
  next guard =>
    obtain ⟨bytes, read, result⟩ := Option.map_eq_some_iff.mp copied
    subst after
    obtain ⟨dstBound,srcBound,dstSize,srcSize,writable,separate⟩ := guard
    have metadata := writeVec_metadata heap dst.block dst.offset n bytes
    refine ⟨dstBound,srcBound,dstSize,srcSize,writable,separate,?_,metadata.1,metadata.2,?_,?_⟩
    · intro i bound
      rw [readVec_sound heap src.block src.offset n bytes read ⟨i,bound⟩]
      rfl
    · intro i bound
      exact (writeVec_at heap dst.block dst.offset n bytes dstBound ⟨i,bound⟩).trans
        (readVec_sound heap src.block src.offset n bytes read ⟨i,bound⟩).symm
    · exact writeVec_frame heap dst.block dst.offset n bytes
  next rejected => cases copied

def FillGuard (heap : Heap) (p : ArrayPointer) (n : Nat) : Prop :=
  p.offset+n≤p.base+p.elementBytes*p.count ∧ p.offset+n≤(memory heap).size p.block ∧
  (memory heap).size p.block<2^64 ∧ (memory heap).writable p.block=true

instance fillGuardDecidable (heap : Heap) (p : ArrayPointer) (n : Nat) :
    Decidable (FillGuard heap p n) := by
  unfold FillGuard
  infer_instance

def fill (heap : Heap) (p : ArrayPointer) (n : Nat) (value : Byte) : Option Heap :=
  if FillGuard heap p n then some (writeVec heap p.block p.offset n (fun _ => value)) else none

theorem fill_sound (heap after : Heap) (p : ArrayPointer) (n : Nat) (value : Byte)
    (filled : fill heap p n value = some after) :
    ShakeSeedMemory.Fill (memory heap) p n value (memory after) := by
  unfold fill at filled
  split at filled
  next guard =>
    have same := Option.some.inj filled
    subst after
    obtain ⟨object,extent,finite,writable⟩ := guard
    have metadata := writeVec_metadata heap p.block p.offset n (fun _ => value)
    exact ⟨object,extent,finite,writable,metadata.1,metadata.2,
      fun i bound => writeVec_at heap p.block p.offset n (fun _ => value) extent ⟨i,bound⟩,
      writeVec_frame heap p.block p.offset n (fun _ => value)⟩
  next rejected => cases filled

end FT1536.Source3.C99FiniteCopy114
