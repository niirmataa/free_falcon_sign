import Source3.StableTopCore
import Source3.StableTopControl

namespace FT1536.Source3.StableTop001Outcome
open StableTopMemory StableBinaryByteView

theorem reference_exists (l : Layout) (before : C99MemoryReference.Memory)
    (hl : WellFormed l) (legal : Legal l (C99MemoryBridge.encode before)) :
    ∃ after checks, StableTopReference.PinnedExec l before after checks := StableTopCore.source_exists l before hl legal

theorem source_outcome (l : Layout) (before after : C99MemoryReference.Memory) (checks : List (BitVec 64))
    (hl : WellFormed l) (legal : Legal l (C99MemoryBridge.encode before))
    (source : StableTopReference.PinnedExec l before after checks) :
    (∃ final, StableTopExec.run l (C99MemoryBridge.encode before)=some final ∧
      C99MemoryBridge.Related after final.heap ∧ checks=final.checks) ∧
    after.size=before.size ∧ after.writable=before.writable ∧
    (∀ i<768, ∀ b : Fin 8, after.bytes 0 (l.roots+8*i+b.val)=before.bytes 0 (l.roots+8*i+b.val)) ∧
    (∀ block offset, ¬Allowed l ⟨block,offset⟩ → after.bytes block offset=before.bytes block offset) ∧
    (∀ bad : BitVec 32, flagRead (C99MemoryBridge.encode before) l.bad=some bad → bad≠0 →
      flagRead (C99MemoryBridge.encode after) l.bad≠some 0) ∧
    (flagRead (C99MemoryBridge.encode after) l.bad=some 0 →
      flagRead (C99MemoryBridge.encode before) l.bad=some 0 ∧
      ∀ w∈checks, Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w) := by
  obtain ⟨hr,safe⟩ := StableTopCore.complete l before after checks hl legal source
  refine ⟨⟨_,hr,(C99MemoryBridge.related_iff _ _).mpr rfl,rfl⟩,safe.size,safe.writable,?_,?_,safe.sticky,safe.clear⟩
  · intro i hi b
    exact safe.frame ((ptr (StableBinary.addr l.roots i)).add b.val) (StableTopBranchLayout.root_outside l hl i hi b)
  · intro block offset hout
    exact safe.frame ⟨block,offset⟩ hout

end FT1536.Source3.StableTop001Outcome

#check @FT1536.Source3.StableTop001Outcome.reference_exists
#check @FT1536.Source3.StableTop001Outcome.source_outcome
#print FT1536.Source3.StableTop001Outcome.source_outcome
#print axioms FT1536.Source3.StableTop001Outcome.reference_exists
#print axioms FT1536.Source3.StableTop001Outcome.source_outcome
