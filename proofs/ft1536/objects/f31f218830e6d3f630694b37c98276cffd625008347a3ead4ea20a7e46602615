import Source3.StableBinarySuffixGrouping

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryStepAssembly
open FT1536.Source3

/- All six controls, three by-value FPEMU calls, both inline calls and both
   scratch byte stores for one actual source-loop iteration. The four address
   hypotheses are pure layout facts, later discharged for every recursion. -/
theorem source_step_refines (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (source final : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (v u hn : Nat)
    (hl : l.wellFormed k)
    (rel : StableBinaryRelation.Related l m source typed)
    (h0 : l.allowed (StableBinary.addr v (2*u)))
    (h1 : l.allowed (StableBinary.addr v (2*u+1)))
    (hsc0 : l.allowed (StableBinary.addr l.scratch u))
    (hsc1 : l.allowed (StableBinary.addr l.scratch (u+hn)))
    (hs : StableBinaryCExec.sourceStep l StableBinarySourceSyntax.expected v u hn source=
      some final) :
    ∃ next, StableBinarySourceTyped.step l StableBinarySourceSyntax.expected typed v u hn=
        some next ∧ StableBinaryRelation.Related l m final next := by
  unfold StableBinaryCExec.sourceStep at hs
  obtain ⟨⟨⟨product,sum⟩,mid⟩,hp,ht⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨tm,hpm,relm⟩ := StableBinaryPrefixGrouping.prefix_refines
    l k m source mid typed v u hl rel h0 h1 hsc0 product sum hp
  obtain ⟨tf,htm,relf⟩ := StableBinarySuffixGrouping.suffix_refines
    l k m mid final tm u hn product sum hl relm hsc1 ht
  refine ⟨tf,?_,relf⟩
  unfold StableBinarySourceTyped.step
  rw [hpm]
  simp [htm]

end FT1536.Source3.StableBinaryStepAssembly

#check @FT1536.Source3.StableBinaryStepAssembly.source_step_refines
#print axioms FT1536.Source3.StableBinaryStepAssembly.source_step_refines
