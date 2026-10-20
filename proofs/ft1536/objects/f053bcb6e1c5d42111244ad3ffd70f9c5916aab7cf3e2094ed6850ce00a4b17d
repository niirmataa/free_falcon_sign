import Source3.C99HelperCopy

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99HelperComplete
open C99HelperReference C99HelperAtoms StableBinaryByteView
local notation "code" => StableBinarySourceSyntax.expected

theorem base_inv (l : StableBinary.Layout) (c : StableBinarySourceSyntax.Code)
    (n start : Nat) (s out : State) (hn : n=c.baseSize) (h : Exec l c n start s out) :
    ∃ mid w z, C99MemoryReference.Load64 s.heap (C99HelperObjects.values l start) w ∧
      Positive l s w z mid ∧ Store (C99HelperObjects.values l start) mid z out := by
  cases h
  · exact ⟨_,_,_,by assumption,by assumption,by assumption⟩
  · contradiction

theorem branch_inv (l : StableBinary.Layout) (c : StableBinarySourceSyntax.Code)
    (n start : Nat) (s out : State) (hn : n≠c.baseSize) (h : Exec l c n start s out) :
    ∃ sl sc left, Loop l c start (n/2) (n/2) s sl ∧ Copy l start n sl sc ∧
      Exec l c (n/2) start sc left ∧ Exec l c (n/2) (start+n/2) left out := by
  cases h
  · contradiction
  · exact ⟨_,_,_,by assumption,by assumption,by assumption,by assumption⟩

theorem loop_legal (l : StableBinary.Layout) (rootK start hn u : Nat) (s out : State)
    (hl : l.wellFormed rootK) (legal : Legal l (encode s).heap) (hb : start+2*hn≤l.length) (hu : u≤hn)
    (h : Loop l code start hn u s out) : Legal l (encode out).heap := by
  obtain ⟨model,hm,lm,_,_⟩ := HelperLoopTotal.loop_total l rootK start hn (encode s) hl legal hb u hu
  have he := C99HelperGroups.loop_complete l start hn u s out h
  have heq : model=encode out := Option.some.inj (hm.symm.trans he)
  simpa [heq] using lm

theorem defined_legal (l : StableBinary.Layout) (rootK k start : Nat)
    (s out : StableBinaryCExec.State) (hl : l.wellFormed rootK) (legal : Legal l s.heap)
    (hb : start+2^k≤l.length)
    (h : StableBinaryCExec.execute l code k (StableBinary.addr l.values start) s=some out) : Legal l out.heap := by
  obtain ⟨model,hm,lm,_⟩ := HelperAllTotal.execute_total l rootK hl k start s hb legal
  have heq : model=out := Option.some.inj (hm.symm.trans h)
  simpa [heq] using lm

theorem execute_complete (l : StableBinary.Layout) (rootK : Nat) (hl : l.wellFormed rootK) :
    ∀ (k start : Nat) (s out : State), start+2^k≤l.length → Legal l (encode s).heap →
      Exec l code (2^k) start s out →
      StableBinaryCExec.execute l code k (StableBinary.addr l.values start) (encode s)=some (encode out) ∧
        Legal l (encode out).heap := by
  intro k
  induction k with
  | zero =>
      intro start s out hb legal hs
      obtain ⟨mid,w,z,hr,hc,hw⟩ := base_inv l code 1 start s out rfl hs
      have hread := C99MemoryBridge.load64_source_to_interpreter _ _ _ rfl hr
      have hcheck := positive_complete l s mid w z hc
      have hwrite := store_complete _ mid out z rfl hw
      have hm : StableBinaryCExec.execute l code 0 (StableBinary.addr l.values start) (encode s)=some (encode out) := by
        change (StableBinaryCExec.load (encode s) (StableBinary.addr l.values start)).bind
          (fun x => (StableBinaryCExec.positive l (encode s) x).bind
            (fun p => StableBinaryCExec.store p.2 (StableBinary.addr l.values start) p.1))=_
        have hr' : StableBinaryCExec.load (encode s) (StableBinary.addr l.values start)=some w := hread
        rw [hr']
        dsimp only [Option.bind]
        rw [hcheck]
        exact hwrite
      exact ⟨hm,defined_legal l rootK 0 start _ _ hl legal hb hm⟩
  | succ k ih =>
      intro start s out hb legal hs
      have hn : 2^(k+1)≠(code).baseSize := by
        change 2^(k+1)≠1
        have hp : 0<2^k := pow_pos (by decide) k
        rw [pow_succ]
        omega
      have hhalf : 2^(k+1)/2=2^k := by rw [pow_succ,Nat.mul_div_cancel _ (by decide)]
      obtain ⟨sl,sc,left,hloop,hcopy,hleft,hright⟩ := branch_inv l code (2^(k+1)) start s out hn hs
      rw [hhalf] at hloop hleft hright
      have hsub : start+2*(2^k)≤l.length := by simpa [pow_succ,Nat.mul_comm] using hb
      have lloop := loop_legal l rootK start (2^k) (2^k) s sl hl legal hsub (by omega) hloop
      have mloop := C99HelperGroups.loop_complete l start (2^k) (2^k) s sl hloop
      obtain ⟨mcopy,lcopy⟩ := C99HelperCopy.copy_complete l rootK start (2^(k+1)) sl sc hl lloop hb hcopy
      obtain ⟨mleft,lleft⟩ := ih start sc left (by omega) lcopy hleft
      obtain ⟨mright,lright⟩ := ih (start+2^k) left out (by omega) lleft hright
      have haddr : StableBinary.addr l.values start+8*(2^k)=StableBinary.addr l.values (start+2^k) := by
        simp [StableBinary.addr]; omega
      refine ⟨?_,lright⟩
      change (StableBinaryCExec.sourceLoop l code (StableBinary.addr l.values start) (2^k) (2^k) (encode s)).bind
        (fun a => (StableBinaryCExec.copy a (StableBinary.addr l.values start) l.scratch (2*(2^k))).bind
          (fun b => (StableBinaryCExec.execute l code k (StableBinary.addr l.values start) b).bind
            (fun c => StableBinaryCExec.execute l code k (StableBinary.addr l.values start+8*(2^k)) c)))=_
      rw [mloop]
      dsimp only [Option.bind]
      rw [show 2*(2^k)=2^(k+1) by rw [pow_succ,Nat.mul_comm],mcopy]
      dsimp only [Option.bind]
      rw [mleft]
      dsimp only [Option.bind]
      rw [haddr]
      exact mright

theorem pinned_complete (l : StableBinary.Layout) (k : Nat)
    (before after : C99MemoryReference.Memory) (checks : List Word)
    (hl : l.wellFormed k) (legal : Legal l (C99MemoryBridge.encode before))
    (hs : PinnedExec l (2^k) before after checks) :
    ∃ final, StableBinaryCExec.run l k (C99MemoryBridge.encode before)=some final ∧
      C99MemoryBridge.Related after final.heap ∧ checks=final.checks := by
  obtain ⟨c,hsource,h⟩ := hs
  have hc : c=code := Option.some.inj (hsource.symm.trans StableBinarySourceSyntax.pinned_source)
  subst c
  have hm := (execute_complete l k hl k 0 ⟨before,[]⟩ ⟨after,checks⟩ (by simp [hl.1]) legal h).1
  refine ⟨encode ⟨after,checks⟩,?_,(C99MemoryBridge.related_iff _ _).mpr rfl,rfl⟩
  simpa [StableBinaryCExec.run,hl,StableBinarySourceSyntax.pinned_source,StableBinary.addr,encode] using hm

end FT1536.Source3.C99HelperComplete

#check @FT1536.Source3.C99HelperComplete.pinned_complete
#print axioms FT1536.Source3.C99HelperComplete.pinned_complete
