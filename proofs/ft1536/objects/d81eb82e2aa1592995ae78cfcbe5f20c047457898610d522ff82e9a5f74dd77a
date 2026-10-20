import Source3.StableBinaryPrefixGrouping

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinarySuffixGrouping
open FT1536.Source3

theorem source_suffix_two (l : StableBinary.Layout)
    (code : StableBinarySourceSyntax.Code) (u hn : Nat)
    (product sum : BitVec 64) (source : StableBinaryCExec.State) :
    StableBinaryCExec.sourceSuffix l code u hn product sum source = (do
      let (out,s) ← (do
        let (twice,s) ← StableBinaryCExec.unary code.secondStore.double source product
        let (quotient,s) ← StableBinaryCExec.binary code.secondStore.div s twice sum
        StableBinaryCExec.positive l s quotient)
      StableBinaryCExec.store s (StableBinary.addr l.scratch (u+hn)) out) := by
  simp [StableBinaryCExec.sourceSuffix,Option.bind_assoc]

theorem typed_suffix_two (l : StableBinary.Layout)
    (code : StableBinarySourceSyntax.Code) {m : StableBinary.Memory}
    (typed : StableBinary.State l m) (u hn : Nat) (product sum : BitVec 64) :
    StableBinarySourceTyped.sourceSuffix l code typed u hn product sum = (do
      let (out,t) ← (do
        let (twice,t) ← StableBinarySourceTyped.callUnary typed code.secondStore.double product
        let (quotient,t) ← StableBinarySourceTyped.callBinary t code.secondStore.div twice sum
        StableBinary.stable t quotient)
      StableBinary.store t (StableBinary.addr l.scratch (u+hn)) out) := by
  simp [StableBinarySourceTyped.sourceSuffix,Option.bind_assoc]

theorem suffix_refines (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (source final : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (u hn : Nat) (product sum : BitVec 64)
    (hl : l.wellFormed k)
    (rel : StableBinaryRelation.Related l m source typed)
    (hsc : l.allowed (StableBinary.addr l.scratch (u+hn)))
    (hs : StableBinaryCExec.sourceSuffix l StableBinarySourceSyntax.expected u hn
      product sum source=some final) :
    ∃ next, StableBinarySourceTyped.sourceSuffix l StableBinarySourceSyntax.expected
        typed u hn product sum=some next ∧
      StableBinaryRelation.Related l m final next := by
  rw [source_suffix_two] at hs
  obtain ⟨⟨out,mid⟩,htriple,hstore⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨t1,ht1,rel1⟩ :=
    StableBinaryStepRefinement.double_div_positive l k m source mid typed product sum out
      hl rel (by simpa only [StableBinarySourceSyntax.expected] using htriple)
  have hm : (StableBinary.store t1 (StableBinary.addr l.scratch (u+hn)) out).isSome := by
    simp [StableBinary.store,hsc]
  obtain ⟨t2,ht2⟩ := Option.isSome_iff_exists.mp hm
  have rel2 := StableBinaryRelation.store_step l k m mid final t1 t2
    (StableBinary.addr l.scratch (u+hn)) out hl hsc rel1 hstore ht2
  refine ⟨t2,?_,rel2⟩
  rw [typed_suffix_two]
  simp only [StableBinarySourceSyntax.expected]
  rw [ht1]
  change ((some (out,t1) : Option (BitVec 64 × StableBinary.State l m)).bind
    (fun p => StableBinary.store p.2 (StableBinary.addr l.scratch (u+hn)) p.1)) = some t2
  simp only [Option.bind_some,ht2]

end FT1536.Source3.StableBinarySuffixGrouping

#print axioms FT1536.Source3.StableBinarySuffixGrouping.source_suffix_two
#print axioms FT1536.Source3.StableBinarySuffixGrouping.typed_suffix_two
#print axioms FT1536.Source3.StableBinarySuffixGrouping.suffix_refines
