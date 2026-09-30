import Source3.StableBinaryStepRefinement

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryGroupRefinement
open FT1536.Source3
open FT1536.Source3.StableBinaryRelation

theorem source_pair_refines (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (source mid : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (v u : Nat) (a b : BitVec 64)
    (hl : l.wellFormed k) (rel : Related l m source typed)
    (h0 : l.allowed (StableBinary.addr v (2*u)))
    (h1 : l.allowed (StableBinary.addr v (2*u+1)))
    (hs : StableBinaryCExec.sourcePair l StableBinarySourceSyntax.expected v u source=
      some ((a,b),mid)) :
    ∃ next, StableBinarySourceTyped.sourcePair l StableBinarySourceSyntax.expected
      typed v u=some ((a,b),next) ∧ Related l m mid next := by
  unfold StableBinaryCExec.sourcePair at hs
  simp only [StableBinarySourceSyntax.expected,pow_one,Nat.add_zero] at hs
  have haddr0 : StableBinary.addr v (u*2) = StableBinary.addr v (2*u) := by simp [Nat.mul_comm]
  have haddr1 : StableBinary.addr v (u*2+1) = StableBinary.addr v (2*u+1) := by simp [Nat.mul_comm]
  rw [haddr0,haddr1] at hs
  obtain ⟨x,hx,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨first,s1⟩,hfirst,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨y,hy,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨second,s2⟩,hsecond,hret⟩ := Option.bind_eq_some_iff.mp hs
  have hp : first=a := (Prod.mk.inj (Prod.mk.inj (Option.some.inj hret)).1).1
  have hq : second=b := (Prod.mk.inj (Prod.mk.inj (Option.some.inj hret)).1).2
  have hm : s2=mid := (Prod.mk.inj (Option.some.inj hret)).2
  subst a; subst b; subst mid
  obtain ⟨t1,ht1,rel1⟩ := load_step l m source typed _ x h0 rel hx
  obtain ⟨t2,ht2,rel2⟩ := positive_refines l k m source s1 t1 x first hl rel1 hfirst
  obtain ⟨t3,ht3,rel3⟩ := load_step l m s1 t2 _ y h1 rel2 hy
  obtain ⟨t4,ht4,rel4⟩ := positive_refines l k m s1 s2 t3 y second hl rel3 hsecond
  refine ⟨t4,?_,rel4⟩
  simp [StableBinarySourceTyped.sourcePair,StableBinarySourceSyntax.expected,
    ht1,ht2,ht3,ht4]

private theorem typed_gram_two_groups (l : StableBinary.Layout) {m : StableBinary.Memory}
    (typed : StableBinary.State l m) (a b : BitVec 64) :
    StableBinarySourceTyped.sourceGram l StableBinarySourceSyntax.expected typed a b =
      (do
        let (sum,t1) ← (do
          let (r,t0) ← StableBinarySourceTyped.callBinary typed "fpr_add".toList a b
          StableBinary.stable t0 r)
        let (product,t2) ← (do
          let (r,t0) ← StableBinarySourceTyped.callBinary t1 "fpr_mul".toList a b
          StableBinary.stable t0 r)
        pure ((sum,product),t2)) := by
  rfl

theorem source_gram_refines (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (source mid : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (a b sum product : BitVec 64)
    (hl : l.wellFormed k) (rel : Related l m source typed)
    (hs : StableBinaryCExec.sourceGram l StableBinarySourceSyntax.expected a b source=
      some ((sum,product),mid)) :
    ∃ next, StableBinarySourceTyped.sourceGram l StableBinarySourceSyntax.expected
      typed a b=some ((sum,product),next) ∧ Related l m mid next := by
  unfold StableBinaryCExec.sourceGram at hs
  simp only [StableBinarySourceSyntax.expected] at hs
  obtain ⟨⟨sumValue,s2⟩,haddGroup,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨productValue,s4⟩,hmulGroup,hret⟩ := Option.bind_eq_some_iff.mp hs
  have hp : sumValue=sum := (Prod.mk.inj (Prod.mk.inj (Option.some.inj hret)).1).1
  have hq : productValue=product := (Prod.mk.inj (Prod.mk.inj (Option.some.inj hret)).1).2
  have hm : s4=mid := (Prod.mk.inj (Option.some.inj hret)).2
  subst sum; subst product; subst mid
  obtain ⟨t2,htSum,rel2⟩ :=
    StableBinaryStepRefinement.add_positive l k m source s2 typed a b sumValue hl rel haddGroup
  obtain ⟨t4,htProduct,rel4⟩ :=
    StableBinaryStepRefinement.mul_positive l k m s2 s4 t2 a b productValue hl rel2 hmulGroup
  refine ⟨t4,?_,rel4⟩
  rw [typed_gram_two_groups]
  rw [htSum]
  change ((some (sumValue,t2) : Option (BitVec 64 × StableBinary.State l m)).bind
    (fun p => (do
      let (r,t0) ← StableBinarySourceTyped.callBinary p.2 "fpr_mul".toList a b
      StableBinary.stable t0 r).bind
      (fun q => some ((p.1,q.1),q.2)))) = some ((sumValue,productValue),t4)
  simp only [Option.bind_some]
  rw [htProduct]
  rfl

theorem source_half_store_refines (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (source mid : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (u : Nat) (sum : BitVec 64)
    (hl : l.wellFormed k) (rel : Related l m source typed)
    (hsc : l.allowed (StableBinary.addr l.scratch u))
    (hs : StableBinaryCExec.sourceHalfStore l StableBinarySourceSyntax.expected u sum source=
      some mid) :
    ∃ next, StableBinarySourceTyped.sourceHalfStore l StableBinarySourceSyntax.expected
      typed u sum=some next ∧ Related l m mid next := by
  unfold StableBinaryCExec.sourceHalfStore at hs
  simp only [StableBinarySourceSyntax.expected] at hs
  obtain ⟨⟨raw,s1⟩,hhalf,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨out,s2⟩,hpositive,hstore⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨t1,ht1,rel1⟩ :=
    StableBinaryCalleeBridge.half_refines l m source s1 typed sum raw rel hhalf
  obtain ⟨t2,ht2,rel2⟩ := positive_refines l k m s1 s2 t1 raw out hl rel1 hpositive
  have hm : (StableBinary.store t2 (StableBinary.addr l.scratch u) out).isSome := by
    simp [StableBinary.store,hsc]
  obtain ⟨t3,ht3⟩ := Option.isSome_iff_exists.mp hm
  have rel3 := store_step l k m s2 mid t2 t3 (StableBinary.addr l.scratch u)
    out hl hsc rel2 hstore ht3
  refine ⟨t3,?_,rel3⟩
  change (StableBinarySourceTyped.callUnary typed "fpr_half".toList sum).bind
    (fun p1 => (StableBinary.stable p1.2 p1.1).bind
      (fun p2 => StableBinary.store p2.2 (StableBinary.addr l.scratch u) p2.1)) =
      some t3
  simp only [Option.bind,ht1,ht2,ht3]

end FT1536.Source3.StableBinaryGroupRefinement

#print axioms FT1536.Source3.StableBinaryGroupRefinement.source_pair_refines
#print axioms FT1536.Source3.StableBinaryGroupRefinement.source_gram_refines
#print axioms FT1536.Source3.StableBinaryGroupRefinement.source_half_store_refines
