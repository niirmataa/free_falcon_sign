import Source3.StableBinaryGroupRefinement

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryPrefixGrouping
open FT1536.Source3

/- Monad associativity only. This statement is parametrized by the parsed
   AST and all bit words: it does not posit a successful arithmetic call. -/
theorem typed_prefix_three (l : StableBinary.Layout)
    (code : StableBinarySourceSyntax.Code) {m : StableBinary.Memory}
    (typed : StableBinary.State l m) (v u : Nat) :
    StableBinarySourceTyped.sourcePrefix l code typed v u = (do
      let ((a,b),t1) ← StableBinarySourceTyped.sourcePair l code typed v u
      let ((sum,product),t2) ← StableBinarySourceTyped.sourceGram l code t1 a b
      let t3 ← StableBinarySourceTyped.sourceHalfStore l code t2 u sum
      pure ((product,sum),t3)) := by
  simp [StableBinarySourceTyped.sourcePrefix,StableBinarySourceTyped.sourcePair,
    StableBinarySourceTyped.sourceGram,StableBinarySourceTyped.sourceHalfStore,
    Option.bind_assoc]

theorem prefix_refines (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (source mid : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (v u : Nat)
    (hl : l.wellFormed k) (rel : StableBinaryRelation.Related l m source typed)
    (h0 : l.allowed (StableBinary.addr v (2*u)))
    (h1 : l.allowed (StableBinary.addr v (2*u+1)))
    (hsc : l.allowed (StableBinary.addr l.scratch u))
    (product sum : BitVec 64)
    (hs : StableBinaryCExec.sourcePrefix l StableBinarySourceSyntax.expected v u source=
      some ((product,sum),mid)) :
    ∃ next, StableBinarySourceTyped.sourcePrefix l StableBinarySourceSyntax.expected
        typed v u=some ((product,sum),next) ∧
      StableBinaryRelation.Related l m mid next := by
  unfold StableBinaryCExec.sourcePrefix at hs
  obtain ⟨⟨⟨a,b⟩,s1⟩,hpair,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨⟨sumValue,productValue⟩,s2⟩,hgram,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨s3,hhalf,hret⟩ := Option.bind_eq_some_iff.mp hs
  have heq : ((productValue,sumValue),s3)=((product,sum),mid) :=
    Option.some.inj hret
  have hp : productValue=product := (Prod.mk.inj (Prod.mk.inj heq).1).1
  have hq : sumValue=sum := (Prod.mk.inj (Prod.mk.inj heq).1).2
  have hm : s3=mid := (Prod.mk.inj heq).2
  subst product; subst sum; subst mid
  obtain ⟨t1,ht1,rel1⟩ :=
    StableBinaryGroupRefinement.source_pair_refines l k m source s1 typed v u a b
      hl rel h0 h1 hpair
  obtain ⟨t2,ht2,rel2⟩ :=
    StableBinaryGroupRefinement.source_gram_refines l k m s1 s2 t1 a b
      sumValue productValue hl rel1 hgram
  obtain ⟨t3,ht3,rel3⟩ :=
    StableBinaryGroupRefinement.source_half_store_refines l k m s2 s3 t2 u
      sumValue hl rel2 hsc hhalf
  refine ⟨t3,?_,rel3⟩
  rw [typed_prefix_three]
  simp [ht1,ht2,ht3]

end FT1536.Source3.StableBinaryPrefixGrouping

#print axioms FT1536.Source3.StableBinaryPrefixGrouping.typed_prefix_three
#print axioms FT1536.Source3.StableBinaryPrefixGrouping.prefix_refines
