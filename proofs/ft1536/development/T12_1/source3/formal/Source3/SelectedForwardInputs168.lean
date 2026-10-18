import Source3.PublicForwardConstruct167
import Source3.SelectedPublicBounds158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedForwardInputs168
open C99MemoryReference (Memory)
open KeygenRngSource (Fresh)
open KeygenPublicExec (allocated)
open SelectedPublicConvert158 (after)
open SelectedPublicBinding157 (h)
open SelectedPublicStart157 (t)

theorem allocated_fresh_other (heap : Memory) (localBlock count block : Nat)
    (different : block≠localBlock) (fresh : Fresh heap block) :
    Fresh (allocated heap localBlock count) block := by
  simpa only [Fresh,allocated,different,ite_false] using fresh

theorem before_fresh (block : Nat)
    (absent : C99FiniteMap114.lookup SelectedBound135.before.heap.blocks block=none) :
    Fresh SelectedPublicBinding157.before.heap block := by
  have old : Fresh SelectedPublicMemory157.old.heap block := by
    simp [Fresh,SelectedPublicMemory157.old,C99CompactState115.reference,C99FiniteMemory114.memory,absent]
  exact ⟨(congrFun SelectedPublicMemory157.stable.size block).trans old.1,
    (congrFun SelectedPublicMemory157.stable.writable block).trans old.2.1,
    fun offset => (SelectedPublicMemory157.stable.readonly block offset old.2.1).trans (old.2.2 offset)⟩

theorem ready_fresh (block : Nat) (different : block≠32)
    (absent : C99FiniteMap114.lookup SelectedBound135.before.heap.blocks block=none) :
    Fresh SelectedPublicStart157.ready.heap block := by
  change Fresh (allocated SelectedPublicBinding157.before.heap 32 3072) block
  exact allocated_fresh_other _ 32 3072 block different (before_fresh block absent)

theorem converted_fresh (block : Nat) (differentT : block≠t.block) (differentH : block≠h.block)
    (fresh : Fresh SelectedPublicStart157.ready.heap block) : Fresh after.heap block :=
  ⟨(congrFun SelectedPublicConvert158.frame.sizes block).trans fresh.1,
    (congrFun SelectedPublicConvert158.frame.writable block).trans fresh.2.1,
    fun offset => (SelectedPublicConvert158.frame.bytes block offset
      (Or.inl differentT) (Or.inl differentH)).trans (fresh.2.2 offset)⟩

theorem g_fresh : Fresh after.heap 33 :=
  converted_fresh 33 (by decide) (by decide) (ready_fresh 33 (by decide) (by decide +kernel))

theorem i_fresh : Fresh after.heap 34 :=
  converted_fresh 34 (by decide) (by decide) (ready_fresh 34 (by decide) (by decide +kernel))

theorem second_fresh : Fresh (allocated after.heap 33 2048) 34 :=
  allocated_fresh_other after.heap 33 2048 34 (by decide) i_fresh

theorem h_data : PublicForwardMemory167.Data after.heap h := by
  refine ⟨SelectedPublicConvert158.output_fixed.hWritable,?_⟩
  intro j hj
  obtain ⟨w,read,_⟩ := SelectedPublicBounds158.h_image j hj
  exact ⟨w,read⟩

theorem t_data : PublicForwardMemory167.Data after.heap t := by
  refine ⟨SelectedPublicConvert158.output_fixed.tWritable,?_⟩
  intro j hj
  obtain ⟨w,read,_⟩ := SelectedPublicBounds158.t_image j hj
  exact ⟨w,read⟩

end FT1536.Source3.SelectedForwardInputs168
