import Source3.HelperCalleesTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.HelperGroupsTotal
open StableBinaryByteView HelperMemoryTotal
local notation "code" => StableBinarySourceSyntax.expected

theorem pair_total (l : StableBinary.Layout) (k start u hn : Nat) (s : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap)
    (hsub : start+2*hn≤l.length) (hu : u<hn) :
    ∃ a b out, StableBinaryCExec.sourcePair l code (StableBinary.addr l.values start) u s=
      some ((a,b),out) ∧ Legal l out.heap ∧ ReadsGrow l s.heap out.heap := by
  have h0 : start+2*u<l.length := by omega
  have h1 : start+2*u+1<l.length := by omega
  obtain ⟨x,hx⟩ := Option.isSome_iff_exists.mp ((read_some_iff _ _).mpr (legal.valuesReadable _ h0))
  obtain ⟨a,s1,ha,l1,g1⟩ := HelperMemoryTotal.positive_total l k s x hl legal
  obtain ⟨y,hy⟩ := Option.isSome_iff_exists.mp ((read_some_iff _ _).mpr (l1.valuesReadable _ h1))
  obtain ⟨b,s2,hb,l2,g2⟩ := HelperMemoryTotal.positive_total l k s1 y hl l1
  have addr0 : StableBinary.addr (StableBinary.addr l.values start) (u*2+0)=
      StableBinary.addr l.values (start+2*u) := by simp [StableBinary.addr]; omega
  have addr1 : StableBinary.addr (StableBinary.addr l.values start) (u*2+1)=
      StableBinary.addr l.values (start+2*u+1) := by simp [StableBinary.addr]; omega
  refine ⟨a,b,s2,?_,l2,grow_trans g1 g2⟩
  simp only [StableBinaryCExec.sourcePair,StableBinarySourceSyntax.expected,pow_one]
  rw [addr0,addr1]
  simp [StableBinaryCExec.load,hx,ha,hy,hb]

theorem checked_add_total (l : StableBinary.Layout) (k : Nat) (s : StableBinaryCExec.State)
    (a b : BitVec 64) (hl : l.wellFormed k) (legal : Legal l s.heap) :
    ∃ w out, (StableBinaryCExec.binary "fpr_add".toList s a b).bind
        (fun p => StableBinaryCExec.positive l p.2 p.1)=some (w,out) ∧
      Legal l out.heap ∧ ReadsGrow l s.heap out.heap := by
  obtain ⟨raw,hraw⟩ := HelperCalleesTotal.add_total s a b
  obtain ⟨w,out,hpos,lout,gout⟩ := HelperMemoryTotal.positive_total l k s raw hl legal
  exact ⟨w,out,by rw [hraw]; exact hpos,lout,gout⟩

theorem checked_mul_total (l : StableBinary.Layout) (k : Nat) (s : StableBinaryCExec.State)
    (a b : BitVec 64) (hl : l.wellFormed k) (legal : Legal l s.heap) :
    ∃ w out, (StableBinaryCExec.binary "fpr_mul".toList s a b).bind
        (fun p => StableBinaryCExec.positive l p.2 p.1)=some (w,out) ∧
      Legal l out.heap ∧ ReadsGrow l s.heap out.heap := by
  obtain ⟨raw,hraw⟩ := HelperCalleesTotal.mul_total s a b
  obtain ⟨w,out,hpos,lout,gout⟩ := HelperMemoryTotal.positive_total l k s raw hl legal
  exact ⟨w,out,by rw [hraw]; exact hpos,lout,gout⟩

theorem gram_total (l : StableBinary.Layout) (k : Nat) (s : StableBinaryCExec.State)
    (a b : BitVec 64) (hl : l.wellFormed k) (legal : Legal l s.heap) :
    ∃ sum product out, StableBinaryCExec.sourceGram l code a b s=some ((sum,product),out) ∧
      Legal l out.heap ∧ ReadsGrow l s.heap out.heap := by
  obtain ⟨sum,s1,hsum,l1,g1⟩ := checked_add_total l k s a b hl legal
  obtain ⟨product,s2,hproduct,l2,g2⟩ := checked_mul_total l k s1 a b hl l1
  refine ⟨sum,product,s2,?_,l2,grow_trans g1 g2⟩
  change ((StableBinaryCExec.binary "fpr_add".toList s a b).bind
      (fun p => StableBinaryCExec.positive l p.2 p.1)).bind
    (fun p => ((StableBinaryCExec.binary "fpr_mul".toList p.2 a b).bind
      (fun q => StableBinaryCExec.positive l q.2 q.1)).bind
      (fun q => some ((p.1,q.1),q.2))) = _
  rw [hsum]
  change ((StableBinaryCExec.binary "fpr_mul".toList s1 a b).bind
    (fun p => StableBinaryCExec.positive l p.2 p.1)).bind
      (fun q => some ((sum,q.1),q.2)) = _
  rw [hproduct]
  rfl

theorem half_store_total (l : StableBinary.Layout) (k u : Nat) (s : StableBinaryCExec.State)
    (sum : BitVec 64) (hl : l.wellFormed k) (legal : Legal l s.heap)
    (hu : u<l.length) :
    ∃ out, StableBinaryCExec.sourceHalfStore l code u sum s=some out ∧ Legal l out.heap ∧
      ReadsGrow l s.heap out.heap ∧ (wordRead out.heap (StableBinary.addr l.scratch u)).isSome := by
  obtain ⟨raw,hhalf⟩ := HelperCalleesTotal.half_total s sum
  obtain ⟨w,s1,hpos,l1,g1⟩ := HelperMemoryTotal.positive_total l k s raw hl legal
  obtain ⟨s2,hstore,l2,g2,hread⟩ := HelperMemoryTotal.store_total l k s1
    (StableBinary.addr l.scratch u) w hl l1 (StableBinaryLoopRefinement.scratch_allowed l u hu)
  refine ⟨s2,?_,l2,grow_trans g1 g2,by rw [hread]; rfl⟩
  change (StableBinaryCExec.unary "fpr_half".toList s sum).bind
    (fun p => (StableBinaryCExec.positive l p.2 p.1).bind
      (fun q => StableBinaryCExec.store q.2 (StableBinary.addr l.scratch u) q.1)) = _
  simp only [Option.bind,hhalf,hpos,hstore]

theorem suffix_total (l : StableBinary.Layout) (k u hn : Nat) (s : StableBinaryCExec.State)
    (product sum : BitVec 64) (hl : l.wellFormed k) (legal : Legal l s.heap)
    (hu : u+hn<l.length) :
    ∃ out, StableBinaryCExec.sourceSuffix l code u hn product sum s=some out ∧ Legal l out.heap ∧
      ReadsGrow l s.heap out.heap ∧ (wordRead out.heap (StableBinary.addr l.scratch (u+hn))).isSome := by
  obtain ⟨twice,hdouble⟩ := HelperCalleesTotal.double_total s product
  obtain ⟨raw,hdiv⟩ := HelperCalleesTotal.div_total s twice sum
  obtain ⟨w,s1,hpos,l1,g1⟩ := HelperMemoryTotal.positive_total l k s raw hl legal
  obtain ⟨s2,hstore,l2,g2,hread⟩ := HelperMemoryTotal.store_total l k s1
    (StableBinary.addr l.scratch (u+hn)) w hl l1 (StableBinaryLoopRefinement.scratch_allowed l _ hu)
  refine ⟨s2,?_,l2,grow_trans g1 g2,by rw [hread]; rfl⟩
  change (StableBinaryCExec.unary "fpr_double".toList s product).bind
    (fun p => (StableBinaryCExec.binary "fpr_div".toList p.2 p.1 sum).bind
      (fun q => (StableBinaryCExec.positive l q.2 q.1).bind
        (fun r => StableBinaryCExec.store r.2 (StableBinary.addr l.scratch (u+hn)) r.1))) = _
  simp only [Option.bind,hdouble,hdiv,hpos,hstore]

end FT1536.Source3.HelperGroupsTotal

#print axioms FT1536.Source3.HelperGroupsTotal.pair_total
#print axioms FT1536.Source3.HelperGroupsTotal.gram_total
#print axioms FT1536.Source3.HelperGroupsTotal.half_store_total
#print axioms FT1536.Source3.HelperGroupsTotal.suffix_total
