import Source3.HelperGroupsTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.HelperLoopTotal
open StableBinaryByteView HelperMemoryTotal
local notation "code" => StableBinarySourceSyntax.expected

theorem prefix_total (l : StableBinary.Layout) (k start u hn : Nat) (s : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hsub : start+2*hn≤l.length) (hu : u<hn) :
    ∃ product sum out, StableBinaryCExec.sourcePrefix l code (StableBinary.addr l.values start) u s=
      some ((product,sum),out) ∧ Legal l out.heap ∧ ReadsGrow l s.heap out.heap ∧
      (wordRead out.heap (StableBinary.addr l.scratch u)).isSome := by
  obtain ⟨a,b,s1,hpair,l1,g1⟩ := HelperGroupsTotal.pair_total l k start u hn s hl legal hsub hu
  obtain ⟨sum,product,s2,hgram,l2,g2⟩ := HelperGroupsTotal.gram_total l k s1 a b hl l1
  obtain ⟨s3,hhalf,l3,g3,hread⟩ := HelperGroupsTotal.half_store_total l k u s2 sum hl l2 (by omega)
  refine ⟨product,sum,s3,?_,l3,grow_trans (grow_trans g1 g2) g3,hread⟩
  simp [StableBinaryCExec.sourcePrefix,hpair,hgram,hhalf]

theorem step_total (l : StableBinary.Layout) (k start u hn : Nat) (s : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hsub : start+2*hn≤l.length) (hu : u<hn) :
    ∃ out, StableBinaryCExec.sourceStep l code (StableBinary.addr l.values start) u hn s=some out ∧
      Legal l out.heap ∧ ReadsGrow l s.heap out.heap ∧
      (wordRead out.heap (StableBinary.addr l.scratch u)).isSome ∧
      (wordRead out.heap (StableBinary.addr l.scratch (u+hn))).isSome := by
  obtain ⟨product,sum,s1,hprefix,l1,g1,hread1⟩ := prefix_total l k start u hn s hl legal hsub hu
  obtain ⟨s2,hsuffix,l2,g2,hread2⟩ := HelperGroupsTotal.suffix_total l k u hn s1 product sum
    hl l1 (by omega)
  refine ⟨s2,?_,l2,grow_trans g1 g2,?_,hread2⟩
  · simp [StableBinaryCExec.sourceStep,hprefix,hsuffix]
  · exact g2 _ (StableBinaryLoopRefinement.scratch_allowed l u (by omega)) hread1

def Filled (l : StableBinary.Layout) (heap : B20.C.Byte.Memory) (hn n : Nat) : Prop :=
  ∀ j<n, (wordRead heap (StableBinary.addr l.scratch j)).isSome ∧
    (wordRead heap (StableBinary.addr l.scratch (j+hn))).isSome

theorem loop_total (l : StableBinary.Layout) (k start hn : Nat) (s : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hsub : start+2*hn≤l.length) :
    ∀ n≤hn, ∃ out,
      StableBinaryCExec.sourceLoop l code (StableBinary.addr l.values start) hn n s=some out ∧
      Legal l out.heap ∧ ReadsGrow l s.heap out.heap ∧ Filled l out.heap hn n := by
  intro n
  induction n with
  | zero =>
      intro _
      exact ⟨s,rfl,legal,grow_refl l s.heap,fun j hj => by omega⟩
  | succ n ih =>
      intro hnext
      obtain ⟨mid,hm,lm,gm,fill⟩ := ih (by omega)
      obtain ⟨out,hs,lo,go,read0,read1⟩ := step_total l k start n hn mid hl lm hsub (by omega)
      refine ⟨out,?_,lo,grow_trans gm go,?_⟩
      · simp [StableBinaryCExec.sourceLoop,hm,hs]
      · intro j hj
        by_cases heq : j=n
        · subst j; exact ⟨read0,read1⟩
        · have hsmall : j<n := by omega
          obtain ⟨hr0,hr1⟩ := fill j hsmall
          exact ⟨go _ (StableBinaryLoopRefinement.scratch_allowed l j (by omega)) hr0,
            go _ (StableBinaryLoopRefinement.scratch_allowed l (j+hn) (by omega)) hr1⟩

theorem filled_all (l : StableBinary.Layout) (heap : B20.C.Byte.Memory) (hn : Nat)
    (h : Filled l heap hn hn) :
    ∀ j<2*hn, (wordRead heap (StableBinary.addr l.scratch j)).isSome := by
  intro j hj
  by_cases hj0 : j<hn
  · exact (h j hj0).1
  · have hjs : j-hn<hn := by omega
    simpa [Nat.sub_add_cancel (by omega : hn≤j)] using (h (j-hn) hjs).2

end FT1536.Source3.HelperLoopTotal

#print axioms FT1536.Source3.HelperLoopTotal.loop_total
#print axioms FT1536.Source3.HelperLoopTotal.filled_all
