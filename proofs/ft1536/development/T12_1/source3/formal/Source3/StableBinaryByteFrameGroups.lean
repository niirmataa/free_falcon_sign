import Source3.StableBinaryByteFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryByteFrameGroups
open FT1536.Source3
open FT1536.Source3.StableBinaryByteFrame

theorem pair_frame (l : StableBinary.Layout) (v u : Nat)
    (source final : StableBinaryCExec.State) (a b : BitVec 64)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hs : StableBinaryCExec.sourcePair l StableBinarySourceSyntax.expected v u source=
      some ((a,b),final)) :
    final.heap.contents q=source.heap.contents q := by
  unfold StableBinaryCExec.sourcePair at hs
  obtain ⟨x,_,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨first,s1⟩,hfirst,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨y,_,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨second,s2⟩,hsecond,hret⟩ := Option.bind_eq_some_iff.mp hs
  have hfinal : s2=final := (Prod.mk.inj (Option.some.inj hret)).2
  subst final
  exact (positive_frame l s1 s2 y second q hq hsecond).trans
    (positive_frame l source s1 x first q hq hfirst)

private theorem checked_frame (l : StableBinary.Layout)
    (source final : StableBinaryCExec.State) (name : B20.C.Name)
    (a b out : BitVec 64) (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hbinary : ∀ r mid,
      StableBinaryCExec.binary name source a b=some (r,mid) → mid=source)
    (hs : (do
      let (r,mid) ← StableBinaryCExec.binary name source a b
      StableBinaryCExec.positive l mid r)=some (out,final)) :
    final.heap.contents q=source.heap.contents q := by
  obtain ⟨⟨r,mid⟩,hc,hp⟩ := Option.bind_eq_some_iff.mp hs
  exact (positive_frame l mid final r out q hq hp).trans (by
    rw [hbinary r mid hc])

theorem gram_frame (l : StableBinary.Layout)
    (source final : StableBinaryCExec.State) (a b sum product : BitVec 64)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hs : StableBinaryCExec.sourceGram l StableBinarySourceSyntax.expected a b source=
      some ((sum,product),final)) :
    final.heap.contents q=source.heap.contents q := by
  unfold StableBinaryCExec.sourceGram at hs
  simp only [StableBinarySourceSyntax.expected] at hs
  obtain ⟨⟨sumValue,s1⟩,hadd,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨productValue,s2⟩,hmul,hret⟩ := Option.bind_eq_some_iff.mp hs
  have hfinal : s2=final := (Prod.mk.inj (Option.some.inj hret)).2
  subst final
  have hfirst := checked_frame l source s1 "fpr_add".toList a b sumValue q hq
    (fun r mid hc => add_frame source mid a b r hc) hadd
  have hsecond := checked_frame l s1 s2 "fpr_mul".toList a b productValue q hq
    (fun r mid hc => mul_frame s1 mid a b r hc) hmul
  exact hsecond.trans hfirst

theorem half_store_frame (l : StableBinary.Layout) (u : Nat)
    (source final : StableBinaryCExec.State) (sum : BitVec 64)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hsc : l.allowed (StableBinary.addr l.scratch u))
    (hs : StableBinaryCExec.sourceHalfStore l StableBinarySourceSyntax.expected u sum source=
      some final) :
    final.heap.contents q=source.heap.contents q := by
  unfold StableBinaryCExec.sourceHalfStore at hs
  simp only [StableBinarySourceSyntax.expected] at hs
  obtain ⟨⟨raw,s1⟩,hhalf,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨out,s2⟩,hpos,hstore⟩ := Option.bind_eq_some_iff.mp hs
  have h1 : s1=source := half_frame source s1 sum raw hhalf
  have h2 := positive_frame l s1 s2 raw out q hq hpos
  have h3 := store_frame l s2 final (StableBinary.addr l.scratch u) out q hsc hq hstore
  rw [h1] at h2
  exact h3.trans h2

theorem prefix_frame (l : StableBinary.Layout) (v u : Nat)
    (source final : StableBinaryCExec.State) (product sum : BitVec 64)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hsc : l.allowed (StableBinary.addr l.scratch u))
    (hs : StableBinaryCExec.sourcePrefix l StableBinarySourceSyntax.expected v u source=
      some ((product,sum),final)) :
    final.heap.contents q=source.heap.contents q := by
  unfold StableBinaryCExec.sourcePrefix at hs
  obtain ⟨⟨⟨a,b⟩,s1⟩,hpair,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨⟨sumValue,productValue⟩,s2⟩,hgram,hs⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨s3,hhalf,hret⟩ := Option.bind_eq_some_iff.mp hs
  have heq : s3=final := (Prod.mk.inj (Option.some.inj hret)).2
  subst final
  have h1 := pair_frame l v u source s1 a b q hq hpair
  have h2 := gram_frame l s1 s2 a b sumValue productValue q hq hgram
  have h3 := half_store_frame l u s2 s3 sumValue q hq hsc hhalf
  exact h3.trans (h2.trans h1)

theorem suffix_frame (l : StableBinary.Layout) (u hn : Nat)
    (source final : StableBinaryCExec.State) (product sum : BitVec 64)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hsc : l.allowed (StableBinary.addr l.scratch (u+hn)))
    (hs : StableBinaryCExec.sourceSuffix l StableBinarySourceSyntax.expected u hn
      product sum source=some final) :
    final.heap.contents q=source.heap.contents q := by
  have htwo : StableBinaryCExec.sourceSuffix l StableBinarySourceSyntax.expected
      u hn product sum source = (do
        let (out,s) ← (do
          let (twice,s) ← StableBinaryCExec.unary "fpr_double".toList source product
          let (quotient,s) ← StableBinaryCExec.binary "fpr_div".toList s twice sum
          StableBinaryCExec.positive l s quotient)
        StableBinaryCExec.store s (StableBinary.addr l.scratch (u+hn)) out) := by
    simp [StableBinaryCExec.sourceSuffix,StableBinarySourceSyntax.expected,Option.bind_assoc]
  rw [htwo] at hs
  obtain ⟨⟨out,s3⟩,htriple,hstore⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨twice,s1⟩,hdouble,hrest⟩ := Option.bind_eq_some_iff.mp htriple
  obtain ⟨⟨quotient,s2⟩,hdiv,hpos⟩ := Option.bind_eq_some_iff.mp hrest
  have h1 : s1=source := double_frame source s1 product twice hdouble
  have h2 : s2=s1 := div_frame s1 s2 twice sum quotient hdiv
  have h3 := positive_frame l s2 s3 quotient out q hq hpos
  have h4 := store_frame l s3 final (StableBinary.addr l.scratch (u+hn)) out q hsc hq hstore
  rw [h2,h1] at h3
  exact h4.trans h3

theorem step_frame (l : StableBinary.Layout) (v u hn : Nat)
    (source final : StableBinaryCExec.State)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hsc0 : l.allowed (StableBinary.addr l.scratch u))
    (hsc1 : l.allowed (StableBinary.addr l.scratch (u+hn)))
    (hs : StableBinaryCExec.sourceStep l StableBinarySourceSyntax.expected v u hn
      source=some final) :
    final.heap.contents q=source.heap.contents q := by
  unfold StableBinaryCExec.sourceStep at hs
  obtain ⟨⟨⟨product,sum⟩,mid⟩,hp,ht⟩ := Option.bind_eq_some_iff.mp hs
  have h1 := prefix_frame l v u source mid product sum q hq hsc0 hp
  have h2 := suffix_frame l u hn mid final product sum q hq hsc1 ht
  exact h2.trans h1

end FT1536.Source3.StableBinaryByteFrameGroups

#print axioms FT1536.Source3.StableBinaryByteFrameGroups.pair_frame
#print axioms FT1536.Source3.StableBinaryByteFrameGroups.gram_frame
#print axioms FT1536.Source3.StableBinaryByteFrameGroups.half_store_frame
#print axioms FT1536.Source3.StableBinaryByteFrameGroups.prefix_frame
#print axioms FT1536.Source3.StableBinaryByteFrameGroups.suffix_frame
#print axioms FT1536.Source3.StableBinaryByteFrameGroups.step_frame
