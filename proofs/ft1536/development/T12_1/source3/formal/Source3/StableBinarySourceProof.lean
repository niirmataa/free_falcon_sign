import Source3.StableBinaryFinalBridge
import Source3.StableBinaryByteFrameRecursion
import Source3.StableBinaryRefinementGoal
import Source3.StableBinaryMemcpySpec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinarySourceProof
open FT1536.Source3

/- The exact, formerly open byte-heap simulation type. No premise about
   accepted keys, Gram, positivity, leaf values or expected callee outputs. -/
theorem byte_interpreter_refinement :
    StableBinaryRefinementGoal.byteInterpreterRefinement := by
  intro l k before after hl legal hs
  obtain ⟨typed,hmodel,hmem,hchecks⟩ :=
    StableBinaryFinalBridge.byte_interpreter_to_model l k before after hl legal hs
  have hsource : StableBinaryCExec.execute l StableBinarySourceSyntax.expected k
      (StableBinary.addr l.values 0) {heap := before}=some after := by
    simpa [StableBinaryCExec.run,hl,StableBinarySourceSyntax.pinned_source,
      StableBinary.addr] using hs
  refine ⟨typed,?_,hmem,hchecks,?_⟩
  · rw [StableBinarySourceTyped.source_run_model]
    exact hmodel
  · intro q hq
    have hf := StableBinaryByteFrameRecursion.execute_frame l q hq k 0
      {heap := before} after (by simp [hl.1]) hsource
    exact hf

theorem pinned_byte_source_outcome (l : StableBinary.Layout) (k : Nat)
    (before : B20.C.Byte.Memory) (final : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : StableBinaryByteView.Legal l before)
    (hs : StableBinaryCExec.run l k before=some final)
    (hclear : StableBinaryByteView.flagRead final.heap l.bad=some 0#32) :
    StableBinaryByteView.flagRead before l.bad=some 0#32 ∧
    (∀ w∈final.checks,
      Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w) ∧
    (∀ q, ¬StableBinaryRefinementGoal.allowedByte l q →
      final.heap.contents q=before.contents q) := by
  obtain ⟨hprior,hchecks⟩ :=
    StableBinaryFinalBridge.byte_source_final_clear l k before final hl legal hs hclear
  obtain ⟨_,_,_,_,hframe⟩ := byte_interpreter_refinement l k before final hl legal hs
  exact ⟨hprior,hchecks,hframe⟩

theorem pinned_byte_source_prior_nonzero (l : StableBinary.Layout) (k : Nat)
    (before : B20.C.Byte.Memory) (final : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : StableBinaryByteView.Legal l before)
    (hs : StableBinaryCExec.run l k before=some final)
    (bad : BitVec 32) (hb : StableBinaryByteView.flagRead before l.bad=some bad)
    (hn : bad≠0#32) : StableBinaryByteView.flagRead final.heap l.bad≠some 0#32 :=
  StableBinaryFinalBridge.byte_source_preserves_any_bad l k before final hl legal hs bad hb hn

theorem each_source_copy_matches_byte_memcpy (l : StableBinary.Layout)
    (k start n : Nat) (before after : StableBinaryCExec.State)
    (hl : l.wellFormed k) (hbound : start+n≤l.length)
    (hcopy : StableBinaryCExec.copy before (StableBinary.addr l.values start)
      l.scratch n=some after) :
    StableBinaryMemcpySpec.RawMemcpyContract before.heap after.heap
      (StableBinary.addr l.values start) l.scratch n :=
  StableBinaryMemcpySpec.source_copy_is_byte_memcpy l k start n before after hl hbound hcopy

end FT1536.Source3.StableBinarySourceProof

#check @FT1536.Source3.StableBinarySourceProof.byte_interpreter_refinement
#check @FT1536.Source3.StableBinarySourceProof.pinned_byte_source_outcome
#check @FT1536.Source3.StableBinarySourceProof.pinned_byte_source_prior_nonzero
#check @FT1536.Source3.StableBinarySourceProof.each_source_copy_matches_byte_memcpy
#print FT1536.Source3.StableBinarySourceProof.byte_interpreter_refinement
#print FT1536.Source3.StableBinarySourceProof.pinned_byte_source_outcome
#print FT1536.Source3.StableBinarySourceProof.pinned_byte_source_prior_nonzero
#print FT1536.Source3.StableBinarySourceProof.each_source_copy_matches_byte_memcpy
#print axioms FT1536.Source3.StableBinarySourceProof.byte_interpreter_refinement
#print axioms FT1536.Source3.StableBinarySourceProof.pinned_byte_source_outcome
#print axioms FT1536.Source3.StableBinarySourceProof.pinned_byte_source_prior_nonzero
#print axioms FT1536.Source3.StableBinarySourceProof.each_source_copy_matches_byte_memcpy
