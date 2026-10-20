import Source3.HelperCopyTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.HelperAllTotal
open StableBinaryByteView HelperMemoryTotal
local notation "code" => StableBinarySourceSyntax.expected

theorem execute_total (l : StableBinary.Layout) (rootK : Nat) (hl : l.wellFormed rootK) :
    ∀ (k start : Nat) (s : StableBinaryCExec.State),
      start+2^k≤l.length → Legal l s.heap →
      ∃ out, StableBinaryCExec.execute l code k (StableBinary.addr l.values start) s=some out ∧
        Legal l out.heap ∧ ReadsGrow l s.heap out.heap := by
  intro k
  induction k with
  | zero =>
      intro start s hsub legal
      have hstart : start<l.length := by simpa using hsub
      obtain ⟨w,hw⟩ := Option.isSome_iff_exists.mp ((read_some_iff _ _).mpr (legal.valuesReadable start hstart))
      obtain ⟨z,sp,hp,lp,gp⟩ := HelperMemoryTotal.positive_total l rootK s w hl legal
      obtain ⟨out,ho,lo,go,_⟩ := HelperMemoryTotal.store_total l rootK sp
        (StableBinary.addr l.values start) z hl lp (values_allowed l start hstart)
      refine ⟨out,?_,lo,grow_trans gp go⟩
      simp [StableBinaryCExec.execute,StableBinarySourceSyntax.expected,StableBinaryCExec.load,hw,hp,ho]
  | succ k ih =>
      intro start s hsub legal
      have hbound : start+2*(2^k)≤l.length := by simpa [pow_succ,Nat.mul_comm] using hsub
      obtain ⟨sl,hlop,ll,gl,fill⟩ := HelperLoopTotal.loop_total l rootK start (2^k) s
        hl legal hbound (2^k) (by omega)
      obtain ⟨sc,hcopy,lc,gc⟩ := HelperCopyTotal.copy_total l rootK start (2*(2^k)) sl
        hl ll hbound (HelperLoopTotal.filled_all l sl.heap (2^k) fill)
      obtain ⟨sleft,hleft,lleft,gleft⟩ := ih start sc (by omega) lc
      obtain ⟨sright,hright,lright,gright⟩ := ih (start+2^k) sleft (by omega) lleft
      have haddr : StableBinary.addr l.values start+8*(2^k)=
          StableBinary.addr l.values (start+2^k) := by simp [StableBinary.addr]; omega
      refine ⟨sright,?_,lright,grow_trans (grow_trans (grow_trans gl gc) gleft) gright⟩
      simp [StableBinaryCExec.execute,hlop,hcopy,hleft,haddr,hright]

theorem all_legal_helpers_defined : StableBinaryRefinementGoal.allLegalHelpersDefined := by
  intro l k heap hl legal
  obtain ⟨out,he,_,_⟩ := execute_total l k hl k 0 {heap} (by simp [hl.1]) legal
  have hdefined : StableBinaryCExec.run l k heap=some out := by
    simpa [StableBinaryCExec.run,hl,StableBinarySourceSyntax.pinned_source,StableBinary.addr] using he
  rw [hdefined]
  rfl

end FT1536.Source3.HelperAllTotal

#check @FT1536.Source3.HelperAllTotal.all_legal_helpers_defined
#print FT1536.Source3.HelperAllTotal.all_legal_helpers_defined
#print axioms FT1536.Source3.HelperAllTotal.all_legal_helpers_defined
