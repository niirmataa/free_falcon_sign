import Source3.C99HelperOrders
import Source3.StableBinary003Outcome

namespace FT1536.Source3.StableBinary004Outcome

/- The source relation is the author's C99/GCC-LP64 fragment semantics,
   not an ISO-standard or compiler-correctness theorem. There is no missing
   completeness/totality parameter in either exported theorem. -/
theorem source_execution_exists (l : StableBinary.Layout) (k : Nat)
    (before : C99MemoryReference.Memory) (hl : l.wellFormed k)
    (legal : StableBinaryByteView.Legal l (C99MemoryBridge.encode before)) :
    ∃ after checks, C99HelperReference.PinnedExec l (2^k) before after checks :=
  C99HelperExists.pinned_inhabited l k before hl legal

theorem source_outcome (l : StableBinary.Layout) (k : Nat)
    (before after : C99MemoryReference.Memory) (checks : List (BitVec 64))
    (hl : l.wellFormed k) (legal : StableBinaryByteView.Legal l (C99MemoryBridge.encode before))
    (source : C99HelperReference.PinnedExec l (2^k) before after checks) :
    (∃ final, StableBinaryCExec.run l k (C99MemoryBridge.encode before)=some final ∧
      C99MemoryBridge.Related after final.heap ∧ checks=final.checks) ∧
    (∀ block offset, ¬StableBinaryRefinementGoal.allowedByte l ⟨block,offset⟩ →
      after.bytes block offset=before.bytes block offset) ∧
    (∀ bad : BitVec 32, StableBinaryByteView.flagRead (C99MemoryBridge.encode before) l.bad=some bad →
      bad≠0#32 → StableBinaryByteView.flagRead (C99MemoryBridge.encode after) l.bad≠some 0#32) ∧
    (StableBinaryByteView.flagRead (C99MemoryBridge.encode after) l.bad=some 0#32 →
      StableBinaryByteView.flagRead (C99MemoryBridge.encode before) l.bad=some 0#32 ∧
      ∀ w∈checks, Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w) := by
  obtain ⟨final,hrun,hmem,hchecks⟩ := C99HelperComplete.pinned_complete l k before after checks hl legal source
  obtain ⟨other,ho,hframe,hbad,hclear⟩ := StableBinary003Outcome.memory_only_outcome l k
    (C99MemoryBridge.encode before) hl legal
  have heq : other=final := Option.some.inj (ho.symm.trans hrun)
  subst other
  have hem := (C99MemoryBridge.related_iff after final.heap).mp hmem
  refine ⟨⟨final,hrun,hmem,hchecks⟩,?_,?_,?_⟩
  · intro block offset houtside
    have hf := hframe ⟨block,offset⟩ houtside
    rw [← hem] at hf
    exact hf
  · rw [hem]
    exact hbad
  · rw [hem,hchecks]
    exact hclear

end FT1536.Source3.StableBinary004Outcome

#check @FT1536.Source3.StableBinary004Outcome.source_execution_exists
#check @FT1536.Source3.StableBinary004Outcome.source_outcome
#print FT1536.Source3.StableBinary004Outcome.source_outcome
#print axioms FT1536.Source3.StableBinary004Outcome.source_outcome
#print axioms FT1536.Source3.StableBinary004Outcome.source_execution_exists
