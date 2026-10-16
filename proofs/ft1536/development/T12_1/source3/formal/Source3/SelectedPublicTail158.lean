import Source3.SelectedPublicBounds158
import Source3.KeygenPublicInputCells

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPublicTail158
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99NarrowReads (Load16)
open SelectedPublicBinding157 (h)
open SelectedPublicStart157 (t ready)
open SelectedSamplerWords158 (old)
open SelectedPublicConvert158 (after frame)

theorem h_found : C99FiniteMap114.lookup old.heap.blocks h.block=some ⟨6144,true,none,.empty⟩ := by decide +kernel
theorem h_protected : KeygenAttemptNorm133.Protected KeygenFullData127.env.ctx (C99CompactState115.reference old) h.block :=
  NormProtected158.source _ old h.block (by decide) (by decide +kernel) (by decide +kernel)
theorem h_before_empty (offset : Nat) : ready.heap.bytes h.block offset=none := by
  rw [SelectedPublicInputs158.bytes_unchanged h.block offset (by decide) h_protected]
  change (C99FiniteMap114.lookup old.heap.blocks h.block).bind (fun data => data.read offset)=none
  rw [h_found]
  change (⟨6144,true,none,.empty⟩ : C99FiniteMemory114.Block).read offset=none
  simp [C99FiniteMemory114.Block.read,C99FiniteMap114.lookup,C99FiniteMap114.get]
theorem t_before_empty (offset : Nat) : ready.heap.bytes t.block offset=none := by rfl

theorem h_tail_byte (i : Nat) (beyond : 1536 ≤ i) : after.heap.bytes h.block (KeygenSmallOutput.element h i).offset=none := by
  have outside : PublicConvertFrame158.Outside h 1536 h.block (KeygenSmallOutput.element h i).offset := by
    right; right
    change 0+2*0+2*1536 ≤ 0+2*(0+i)
    omega
  exact (frame.bytes _ _ (Or.inl (by decide)) outside).trans (h_before_empty _)
theorem t_tail_byte (i : Nat) (beyond : 1536 ≤ i) : after.heap.bytes t.block (KeygenSmallOutput.element t i).offset=none := by
  have outside : PublicConvertFrame158.Outside t 1536 t.block (KeygenSmallOutput.element t i).offset := by
    right; right
    change 0+2*0+2*1536 ≤ 0+2*(0+i)
    omega
  exact (frame.bytes _ _ outside (Or.inl (by decide))).trans (t_before_empty _)

theorem no_tail (heap : Memory) (p : ArrayPointer)
    (absent : ∀ i, 1536 ≤ i → heap.bytes p.block (KeygenSmallOutput.element p i).offset=none) :
    KeygenPublicInputCells.TailEmpty heap p := by
  intro i word beyond read
  cases read with
  | load bytes allocated width initialized =>
    have first := initialized 0
    change heap.bytes p.block (KeygenSmallOutput.element p i).offset=some (bytes 0) at first
    rw [absent i beyond] at first
    cases first

theorem h_empty : KeygenPublicInputCells.TailEmpty after.heap h := no_tail after.heap h h_tail_byte
theorem t_empty : KeygenPublicInputCells.TailEmpty after.heap t := no_tail after.heap t t_tail_byte

theorem domain (heap : Memory) (p : ArrayPointer) (image : KeygenPublicRangeMemory.Image heap p 1536)
    (empty : KeygenPublicInputCells.TailEmpty heap p) : KeygenPublicRangeMemory.Domain heap p := by
  intro i word read
  by_cases inside : i<1536
  · obtain ⟨actual,loaded,bound⟩ := image i inside
    have same := C99NarrowReads.load16_deterministic heap (KeygenSmallOutput.element p i) word actual read loaded
    rw [same]
    exact bound
  · exact (empty i word (by omega) read).elim

theorem h_domain : KeygenPublicRangeMemory.Domain after.heap h := domain after.heap h SelectedPublicBounds158.h_image h_empty
theorem t_domain : KeygenPublicRangeMemory.Domain after.heap t := domain after.heap t SelectedPublicBounds158.t_image t_empty

end FT1536.Source3.SelectedPublicTail158
