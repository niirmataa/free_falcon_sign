import Source3.CertificateAcceptedScan

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateTop
open CertificateMemory CertificateEffects CertificateAtoms StableBinaryByteView

def run (l : Layout) (s : State) : Option State :=
  (StableTopExec.run (top l) s.heap).map (fun out => ⟨out.heap,out.checks.map Event.positive ++ s.trace⟩)
def Exec (l : Layout) (s out : RState) : Prop := ∃ checks,
  StableTopReference.PinnedExec (top l) s.heap out.heap checks ∧ out.trace=checks.map Event.positive ++ s.trace

/- Postcondition extraction using existing top loop/branch theorems. No
   stable-top primitive or loop proof is reconstructed. -/
theorem model_post (l : StableTopMemory.Layout) (h : B20.C.Byte.Memory)
    (hl : StableTopMemory.WellFormed l) (legal : StableTopMemory.Legal l h) :
    ∃ out, StableTopExec.run l h=some out ∧ StableTopMemory.Legal l out.heap ∧
      StableTopBranchLayout.LeavesRead l out.heap := by
  obtain ⟨sl,hr,el,fill⟩:=StableTopLoop.loop_exists l hl FprOfThree.three ⟨h,[]⟩ legal 256 (by omega)
  obtain ⟨out,hb,eb,rb⟩:=StableTopBranches.exists_execution l hl StableTopSyntax.expected.branches
    StableTopBranches.pinned_branches sl el.legal (StableTopLoop.filled_all l sl.heap fill)
  have hloop:=StableTopBodyBridge.loop_complete l StableTopSyntax.expected FprOfThree.three 256
    (C99HelperAtoms.decode ⟨h,[]⟩) (C99HelperAtoms.decode sl) hr
  rw [C99HelperAtoms.encode_decode,C99HelperAtoms.encode_decode] at hloop
  have hbranches:=(StableTopBranches.complete l hl StableTopSyntax.expected.branches
    StableTopBranches.pinned_branches sl (C99HelperAtoms.decode out) el.legal
    (StableTopLoop.filled_all l sl.heap fill) hb).1
  rw [C99HelperAtoms.encode_decode] at hbranches
  exact ⟨out,by rw [StableTopCore.run_expansion,hloop]; exact hbranches,eb.legal,rb⟩

theorem second_outside (l : Layout) (hl : WellFormed l) (i : Nat) (hi : 768 ≤ i ∧ i<1536) (b : Fin 8) :
    ¬StableTopMemory.Allowed (top l) ((ptr (StableBinary.addr (leaves l) i)).add b.val) := by
  have hbad:=hl.bufferBad; have hb:=b.isLt
  dsimp [StableTopMemory.Allowed,top,leaves,scratch,ptr,B20.C.Byte.Pointer.add,StableBinary.addr,StableTopMemory.Separate] at *
  omega

theorem complete (l : Layout) (hl : WellFormed l) (s : State) (out : RState)
    (legal : Legal l s.heap) (h : Exec l (decode s) out) :
    run l s=some (encode out) ∧ Effect l s (encode out) ∧ ∀ i<768, (read l (encode out) i).isSome := by
  obtain ⟨checks,htop,htrace⟩:=h
  have htl:=top_wellFormed l hl
  have htlegal:=top_legal l s.heap legal
  obtain ⟨model,hm,lm,rm⟩:=model_post (top l) s.heap htl htlegal
  have src:=StableTop001Outcome.source_outcome (top l) (C99MemoryBridge.decode s.heap) out.heap checks htl
    (by simpa only [C99MemoryBridge.encode_decode] using htlegal) htop
  obtain ⟨actual,ha,hrel,hchecks⟩:=src.1
  rw [C99MemoryBridge.encode_decode] at ha
  have heq : model=actual := Option.some.inj (hm.symm.trans ha)
  subst model
  have hheap : C99MemoryBridge.encode out.heap=actual.heap := (C99MemoryBridge.related_iff _ _).mp hrel
  have shape : (encode out).heap.length=s.heap.length ∧ (encode out).heap.writable=s.heap.writable := ⟨src.2.1,src.2.2.1⟩
  have frame : ∀ p, ¬StableTopMemory.Allowed (top l) p → (encode out).heap.contents p=s.heap.contents p := by
    intro p hp; exact src.2.2.2.2.1 p.block p.offset hp
  have clear : flagRead (encode out).heap l.bad=some 0 → flagRead s.heap l.bad=some 0 ∧
      ∀ w∈checks, Good (.positive w) := by
    have hc:=src.2.2.2.2.2.2
    rw [C99MemoryBridge.encode_decode] at hc
    exact hc
  have hmodel : run l s=some (encode out) := by
    simp [run,ha,encode,hheap,htrace,hchecks]
    rfl
  have newRead : ∀ i<768, (read l (encode out) i).isSome := by
    intro i hi
    change (wordRead (C99MemoryBridge.encode out.heap) (StableBinary.addr (leaves l) i)).isSome
    rw [hheap]
    exact rm i hi
  have legalOut : Legal l (encode out).heap := by
    refine ⟨?_,?_,?_,?_,?_⟩
    · intro i hi
      change B20.C.Byte.ReadRegion (C99MemoryBridge.encode out.heap) _
      rw [hheap]; exact lm.rootsReadable i hi
    · intro i hi; simpa only [OwnedWriteRegion,shape.1,shape.2] using legal.leavesWritable i hi
    · intro i hi; simpa only [OwnedWriteRegion,shape.1,shape.2] using legal.scratchWritable i hi
    · change (flagRead (C99MemoryBridge.encode out.heap) l.bad).isSome
      rw [hheap]; exact lm.badReadable
    · simpa only [FlagWritable,B20.C.Byte.inBounds,shape.1,shape.2] using legal.badWritable
  refine ⟨hmodel,⟨legalOut,?_,?_⟩,newRead⟩
  · intro i hi hr
    by_cases hf : i<768
    · exact newRead i hf
    · have he:=word_read_congr s.heap (encode out).heap (StableBinary.addr (leaves l) i) shape.1
        (fun b => frame _ (second_outside l hl i (by omega) b))
      rw [he]; exact hr
  · intro before safe
    refine ⟨shape.1.trans safe.size,shape.2.trans safe.writable,?_,?_,?_⟩
    · intro p hp
      exact (frame p (fun h => hp (top_allowed_subset l p h))).trans (safe.frame p hp)
    · intro old hr hn hz; exact safe.sticky old hr hn (clear hz).1
    · intro hz
      obtain ⟨hp,hnew⟩:=clear hz
      obtain ⟨hfirst,hold⟩:=safe.clear hp
      refine ⟨hfirst,?_⟩
      intro e he
      change e∈out.trace at he
      rw [htrace] at he
      rcases List.mem_append.mp he with he | he
      · obtain ⟨w,hw,rfl⟩:=List.mem_map.mp he
        exact hnew w hw
      · exact hold e he

theorem exists_execution (l : Layout) (hl : WellFormed l) (s : State) (legal : Legal l s.heap) :
    ∃ out, Exec l (decode s) (decode out) ∧ Effect l s out ∧ ∀ i<768, (read l out i).isSome := by
  obtain ⟨after,checks,h⟩:=StableTop001Outcome.reference_exists (top l) (C99MemoryBridge.decode s.heap)
    (top_wellFormed l hl) (by simpa only [C99MemoryBridge.encode_decode] using top_legal l s.heap legal)
  let out : State:=⟨C99MemoryBridge.encode after,checks.map Event.positive ++ s.trace⟩
  have hr : Exec l (decode s) (decode out) :=
    ⟨checks,by simpa only [decode,out,C99MemoryBridge.decode_encode] using h,rfl⟩
  obtain ⟨_,effect,reads⟩:=complete l hl s (decode out) legal hr
  rw [encode_decode] at effect reads
  exact ⟨out,hr,effect,reads⟩

end FT1536.Source3.CertificateTop

#print axioms FT1536.Source3.CertificateTop.complete
#print axioms FT1536.Source3.CertificateTop.exists_execution
