import Source3.HelperLoopTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.HelperCopyTotal
open StableBinaryByteView HelperMemoryTotal

theorem read_copy_total (base n : Nat) (s : StableBinaryCExec.State)
    (h : ∀ i<n, (wordRead s.heap (StableBinary.addr base i)).isSome) :
    ∃ words, StableBinaryCExec.readCopy base n s=some words ∧ words.length=n := by
  induction n with
  | zero => exact ⟨[],rfl,rfl⟩
  | succ n ih =>
      obtain ⟨xs,hxs,hlen⟩ := ih (fun i hi => h i (by omega))
      obtain ⟨w,hw⟩ := Option.isSome_iff_exists.mp (h n (by omega))
      exact ⟨xs++[w],by simp [StableBinaryCExec.readCopy,StableBinaryCExec.load,hxs,hw],by simp [hlen]⟩

theorem write_copy_total (l : StableBinary.Layout) (k start : Nat) (words : List (BitVec 64))
    (hl : l.wellFormed k) :
    ∀ (s : StableBinaryCExec.State) (i : Nat), Legal l s.heap → start+i+words.length≤l.length →
      ∃ out, StableBinaryCExec.writeCopy (StableBinary.addr l.values start) i words s=some out ∧
        Legal l out.heap ∧ ReadsGrow l s.heap out.heap := by
  induction words with
  | nil => intro s i legal _; exact ⟨s,rfl,legal,grow_refl l s.heap⟩
  | cons w tail ih =>
      intro s i legal bound
      have hi : start+i<l.length := by simp only [List.length_cons] at bound; omega
      have ha : StableBinary.addr (StableBinary.addr l.values start) i=
          StableBinary.addr l.values (start+i) := by simp [StableBinary.addr]; omega
      have allowed : l.allowed (StableBinary.addr (StableBinary.addr l.values start) i) := by
        rw [ha]; exact values_allowed l (start+i) hi
      obtain ⟨mid,hm,lm,gm,_⟩ := HelperMemoryTotal.store_total l k s
        (StableBinary.addr (StableBinary.addr l.values start) i) w hl legal allowed
      obtain ⟨out,ho,lo,go⟩ := ih mid (i+1) lm (by simp only [List.length_cons] at bound; omega)
      exact ⟨out,by simp [StableBinaryCExec.writeCopy,hm,ho],lo,grow_trans gm go⟩

theorem copy_total (l : StableBinary.Layout) (k start n : Nat) (s : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hsub : start+n≤l.length)
    (hscratch : ∀ i<n, (wordRead s.heap (StableBinary.addr l.scratch i)).isSome) :
    ∃ out, StableBinaryCExec.copy s (StableBinary.addr l.values start) l.scratch n=some out ∧
      Legal l out.heap ∧ ReadsGrow l s.heap out.heap := by
  obtain ⟨words,hr,hlen⟩ := read_copy_total l.scratch n s hscratch
  obtain ⟨out,hw,lo,go⟩ := write_copy_total l k start words hl s 0 legal (by simp [hlen,hsub])
  exact ⟨out,by simp [StableBinaryCExec.copy,hr,hw],lo,go⟩

end FT1536.Source3.HelperCopyTotal

#print axioms FT1536.Source3.HelperCopyTotal.copy_total
