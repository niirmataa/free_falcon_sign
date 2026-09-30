import Source3.C99HelperGroupExists

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99HelperExists
open C99HelperReference C99HelperAtoms StableBinaryByteView
local notation "code" => StableBinarySourceSyntax.expected

theorem length_bound (l : StableBinary.Layout) (k : Nat) (hl : l.wellFormed k) : l.length≤256 := by
  calc l.length=2^k := hl.1
       _ ≤ 2^8 := Nat.pow_le_pow_right (by decide) hl.2.1
       _ = 256 := by decide

theorem execute_exists (l : StableBinary.Layout) (rootK : Nat) (hl : l.wellFormed rootK) :
    ∀ (k start : Nat) (s : StableBinaryCExec.State), start+2^k≤l.length → Legal l s.heap →
      ∃ out, Exec l code (2^k) start (decode s) (decode out) ∧ Legal l out.heap := by
  intro k
  induction k with
  | zero =>
      intro start s hb legal
      obtain ⟨w,hr⟩ := C99HelperGroupExists.value_read l rootK start s hl legal (by simpa using hb)
      obtain ⟨z,mid,hc,_,_⟩ := HelperMemoryTotal.positive_total l rootK s w hl legal
      obtain ⟨hrc,lmid⟩ := positive_sound l rootK s mid w z hl legal hc
      obtain ⟨out,hw,lout,_,_⟩ := HelperMemoryTotal.store_total l rootK mid (StableBinary.addr l.values start) z
        hl lmid (values_allowed l start (by simpa using hb))
      have ha := C99HelperObjects.values_allocated l rootK start (decode mid).heap hl
        (by simpa [decode,C99MemoryBridge.encode_decode] using lmid) (by simpa using hb)
      have hrw := store_sound (C99HelperObjects.values l start) mid out z rfl ha rfl hw
      exact ⟨out,Exec.base 1 start (decode s) (decode mid) (decode out) w z rfl hr hrc hrw,lout⟩
  | succ k ih =>
      intro start s hb legal
      have hsub : start+2*(2^k)≤l.length := by simpa [pow_succ,Nat.mul_comm] using hb
      obtain ⟨sl,hloop,ll⟩ := C99HelperGroupExists.loop_exists l rootK start (2^k) s hl legal hsub (2^k) (by omega)
      have hmloop := C99HelperGroups.loop_complete l start (2^k) (2^k) (decode s) (decode sl) hloop
      rw [encode_decode,encode_decode] at hmloop
      obtain ⟨model,hm,lm,_,filled⟩ := HelperLoopTotal.loop_total l rootK start (2^k) s hl legal hsub (2^k) (by omega)
      have heq : model=sl := Option.some.inj (hm.symm.trans hmloop)
      subst model
      have hpow : 2^(k+1)=2*(2^k) := by rw [pow_succ,Nat.mul_comm]
      have fill : ∀ i<2^(k+1), (wordRead sl.heap (StableBinary.addr l.scratch i)).isSome := by
        rw [hpow]
        exact HelperLoopTotal.filled_all l sl.heap (2^k) filled
      obtain ⟨sc,hcopy,lc,_⟩ := HelperCopyTotal.copy_total l rootK start (2^(k+1)) sl hl ll hb fill
      have hrcopy : Copy l start (2^(k+1)) (decode sl) (decode sc) :=
        ⟨C99HelperCopy.model_memory l rootK start (2^(k+1)) sl sc hl ll hb hcopy,
          C99HelperCopy.copy_trace _ _ _ _ _ hcopy⟩
      obtain ⟨left,hleft,lleft⟩ := ih start sc (by omega) lc
      obtain ⟨out,hright,lout⟩ := ih (start+2^k) left (by omega) lleft
      have hhalf : 2^(k+1)/2=2^k := by rw [pow_succ,Nat.mul_div_cancel _ (by decide)]
      have hn : 2^(k+1)≠(code).baseSize := by
        change 2^(k+1)≠1
        have hp : 0<2^k := pow_pos (by decide) k
        rw [hpow]; omega
      have hlen := length_bound l rootK hl
      refine ⟨out,Exec.branch (2^(k+1)) start (decode s) (decode sl) (decode sc) (decode left) (decode out)
        hn (by omega) (by omega) ?_ (by omega) hrcopy ?_ ?_,lout⟩
      · rw [hhalf]; exact hloop
      · rw [hhalf]; exact hleft
      · rw [hhalf]; exact hright

theorem pinned_inhabited (l : StableBinary.Layout) (k : Nat) (before : C99MemoryReference.Memory)
    (hl : l.wellFormed k) (legal : Legal l (C99MemoryBridge.encode before)) :
    ∃ after checks, PinnedExec l (2^k) before after checks := by
  obtain ⟨out,he,_⟩ := execute_exists l k hl k 0 ⟨C99MemoryBridge.encode before,[]⟩ (by simp [hl.1]) legal
  refine ⟨C99MemoryBridge.decode out.heap,out.checks,code,StableBinarySourceSyntax.pinned_source,?_⟩
  simpa only [decode,C99MemoryBridge.decode_encode] using he

end FT1536.Source3.C99HelperExists

#check @FT1536.Source3.C99HelperExists.pinned_inhabited
#print axioms FT1536.Source3.C99HelperExists.pinned_inhabited
