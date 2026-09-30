import Source3.StableTopBinaryBridge

namespace FT1536.Source3.StableTopBranches
open StableTopMemory StableTopBranchLayout StableTopAtoms StableTopBinaryBridge

def GoodBranches (bs : List StableTopSyntax.Branch) : Prop := ∀ b∈bs, ∃ j, j<3 ∧ b=descriptor j
theorem pinned_branches : GoodBranches StableTopSyntax.expected.branches := by
  intro b hb
  change b∈[descriptor 0,descriptor 1,descriptor 2] at hb
  simp only [List.mem_cons,List.not_mem_nil,or_false] at hb
  rcases hb with rfl | rfl | rfl
  · exact ⟨0,by decide,rfl⟩
  · exact ⟨1,by decide,rfl⟩
  · exact ⟨2,by decide,rfl⟩

theorem nil_inv (l : Layout) (s out : C99HelperReference.State)
    (h : StableTopReference.Branches l [] s out) : out=s := by cases h; rfl
theorem cons_inv (l : Layout) (b : StableTopSyntax.Branch) (bs : List StableTopSyntax.Branch)
    (s out : C99HelperReference.State) (h : StableTopReference.Branches l (b::bs) s out) :
    ∃ mid, StableTopReference.Binary l b s mid ∧ StableTopReference.Branches l bs mid out := by
  cases h
  exact ⟨_,by assumption,by assumption⟩

theorem complete (l : Layout) (hl : WellFormed l) (bs : List StableTopSyntax.Branch) (good : GoodBranches bs) :
    ∀ (s : StableBinaryCExec.State) (out : C99HelperReference.State), Legal l s.heap → LeavesRead l s.heap →
      StableTopReference.Branches l bs (C99HelperAtoms.decode s) out →
      StableTopExec.branches l bs s=some (C99HelperAtoms.encode out) ∧
        Effect l s (C99HelperAtoms.encode out) ∧ LeavesRead l (C99HelperAtoms.encode out).heap := by
  induction bs with
  | nil =>
      intro s out legal read h
      have heq := nil_inv l _ _ h
      subst out
      rw [C99HelperAtoms.encode_decode]
      exact ⟨rfl,effect_refl l s legal,read⟩
  | cons b bs ih =>
      intro s out legal read h
      obtain ⟨j,hj,rfl⟩ := good b (by simp)
      obtain ⟨mid,hb,ht⟩ := cons_inv _ _ _ _ _ h
      obtain ⟨hm,em,rm⟩ := StableTopBinaryBridge.complete l hl j hj s mid legal read hb
      obtain ⟨ho,eo,ro⟩ := ih (fun b hb => good b (List.mem_cons_of_mem _ hb))
        (C99HelperAtoms.encode mid) out em.legal rm (by simpa only [C99HelperAtoms.decode_encode] using ht)
      exact ⟨by simp [StableTopExec.branches,hm,ho],effect_trans em eo,ro⟩

theorem exists_execution (l : Layout) (hl : WellFormed l) (bs : List StableTopSyntax.Branch) (good : GoodBranches bs) :
    ∀ (s : StableBinaryCExec.State), Legal l s.heap → LeavesRead l s.heap → ∃ out,
      StableTopReference.Branches l bs (C99HelperAtoms.decode s) (C99HelperAtoms.decode out) ∧
        Effect l s out ∧ LeavesRead l out.heap := by
  induction bs with
  | nil => intro s legal read; exact ⟨s,StableTopReference.Branches.nil _,effect_refl l s legal,read⟩
  | cons b bs ih =>
      intro s legal read
      obtain ⟨j,hj,rfl⟩ := good b (by simp)
      obtain ⟨mid,hm,em,rm⟩ := StableTopBinaryBridge.exists_execution l hl j hj s legal read
      obtain ⟨out,ho,eo,ro⟩ := ih (fun b hb => good b (List.mem_cons_of_mem _ hb)) mid em.legal rm
      exact ⟨out,StableTopReference.Branches.cons _ _ _ _ _ hm ho,effect_trans em eo,ro⟩

end FT1536.Source3.StableTopBranches

#print axioms FT1536.Source3.StableTopBranches.complete
#print axioms FT1536.Source3.StableTopBranches.exists_execution
