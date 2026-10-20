import Source3.HelperAllTotal
import Source3.FprBlockFuel
import Source3.StableBinarySourceProof

namespace FT1536.Source3.StableBinary003Outcome

/- Closed result for obligation A. No successful execution, callee-domain
   predicate or missing completeness theorem is assumed. This is deliberately
   NOT labeled as the final independent-C99 result required by obligation B. -/
theorem memory_only_outcome (l : StableBinary.Layout) (k : Nat) (heap : B20.C.Byte.Memory)
    (hl : l.wellFormed k) (legal : StableBinaryByteView.Legal l heap) :
    ∃ final, StableBinaryCExec.run l k heap=some final ∧
      (∀ p, ¬StableBinaryRefinementGoal.allowedByte l p →
        final.heap.contents p=heap.contents p) ∧
      (∀ bad : BitVec 32, StableBinaryByteView.flagRead heap l.bad=some bad → bad≠0#32 →
        StableBinaryByteView.flagRead final.heap l.bad≠some 0#32) ∧
      (StableBinaryByteView.flagRead final.heap l.bad=some 0#32 →
        StableBinaryByteView.flagRead heap l.bad=some 0#32 ∧
        ∀ w∈final.checks, Run2.KeygenLeafGate.positive w=true ∧
          Run2.KeygenLeafGate.stableWord w=w) := by
  obtain ⟨final,hrun⟩ := Option.isSome_iff_exists.mp
    (HelperAllTotal.all_legal_helpers_defined l k heap hl legal)
  obtain ⟨_,_,_,_,hframe⟩ := StableBinarySourceProof.byte_interpreter_refinement l k heap final hl legal hrun
  refine ⟨final,hrun,hframe,?_,?_⟩
  · intro bad hb hn
    exact StableBinarySourceProof.pinned_byte_source_prior_nonzero l k heap final hl legal hrun bad hb hn
  · intro hc
    have h := StableBinarySourceProof.pinned_byte_source_outcome l k heap final hl legal hrun hc
    exact ⟨h.1,h.2.1⟩

end FT1536.Source3.StableBinary003Outcome

#check @FT1536.Source3.StableBinary003Outcome.memory_only_outcome
#print FT1536.Source3.StableBinary003Outcome.memory_only_outcome
#print axioms FT1536.Source3.StableBinary003Outcome.memory_only_outcome
