import Source3.StableTopBranchLayout
import Source3.StableBinary004Outcome

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableTopBinaryBridge
open StableTopMemory StableTopBranchLayout StableTopAtoms StableTopEffects StableBinaryByteView

def descriptor (j : Nat) : StableTopSyntax.Branch := ⟨256*j,256⟩
theorem reference_layout (l : Layout) (j : Nat) : StableTopReference.binaryLayout l (256*j) 256=branch l j := by
  unfold StableTopReference.binaryLayout branch
  congr 1
  omega
theorem model_layout (l : Layout) (j : Nat) : StableTopExec.binaryLayout l (256*j) 256=branch l j := by
  exact reference_layout l j

theorem complete (l : Layout) (hl : WellFormed l) (j : Nat) (hj : j<3)
    (s : StableBinaryCExec.State) (out : C99HelperReference.State)
    (legal : Legal l s.heap) (read : LeavesRead l s.heap)
    (h : StableTopReference.Binary l (descriptor j) (C99HelperAtoms.decode s) out) :
    StableTopExec.binary l (descriptor j) s=some (C99HelperAtoms.encode out) ∧
      Effect l s (C99HelperAtoms.encode out) ∧ LeavesRead l (C99HelperAtoms.encode out).heap := by
  obtain ⟨checks,hpin,htrace⟩ := h
  change C99HelperReference.PinnedExec (StableTopReference.binaryLayout l (256*j) 256) 256
    (C99MemoryBridge.decode s.heap) out.heap checks at hpin
  rw [reference_layout] at hpin
  have hbl := branch_wellFormed l hl j hj
  have hblegal := branch_legal l s.heap legal read j hj
  obtain ⟨model,hm,hmem,hchecks⟩ := C99HelperComplete.pinned_complete (branch l j) 8
    (C99MemoryBridge.decode s.heap) out.heap checks hbl (by simpa only [C99MemoryBridge.encode_decode] using hblegal) hpin
  rw [C99MemoryBridge.encode_decode] at hm
  have hheap : C99MemoryBridge.encode out.heap=model.heap := (C99MemoryBridge.related_iff _ _).mp hmem
  have hout : C99HelperAtoms.encode out={model with checks := model.checks++s.checks} := by
    change (⟨C99MemoryBridge.encode out.heap,out.checks⟩ : StableBinaryCExec.State)=_
    rw [hheap,htrace,hchecks]
    rfl
  have hmodel : StableTopExec.binary l (descriptor j) s=some (C99HelperAtoms.encode out) := by
    change (StableBinaryCExec.run (StableTopExec.binaryLayout l (256*j) 256) 8 s.heap).bind
      (fun b => some {b with checks := b.checks++s.checks})=_
    rw [model_layout,hm]
    exact congrArg some hout.symm
  have hexec : StableBinaryCExec.execute (branch l j) StableBinarySourceSyntax.expected 8
      (StableBinary.addr (branch l j).values 0) ⟨s.heap,[]⟩=some model := by
    simpa [StableBinaryCExec.run,hbl,StableBinarySourceSyntax.pinned_source,StableBinary.addr] using hm
  have lm := C99HelperComplete.defined_legal (branch l j) 8 8 0 ⟨s.heap,[]⟩ model hbl hblegal
    (by change 0+2^8≤256; decide) hexec
  have lout : StableBinaryByteView.Legal (branch l j) (C99HelperAtoms.encode out).heap := by
    change StableBinaryByteView.Legal _ (C99MemoryBridge.encode out.heap)
    rw [hheap]; exact lm
  have shape : (C99HelperAtoms.encode out).heap.length=s.heap.length ∧
      (C99HelperAtoms.encode out).heap.writable=s.heap.writable := C99HelperShape.pinned_shape _ _ _ _ _ hpin
  have outcome := StableBinary004Outcome.source_outcome (branch l j) 8
    (C99MemoryBridge.decode s.heap) out.heap checks hbl
    (by simpa only [C99MemoryBridge.encode_decode] using hblegal) hpin
  have frame : ∀ p, ¬StableBinaryRefinementGoal.allowedByte (branch l j) p →
      (C99HelperAtoms.encode out).heap.contents p=s.heap.contents p := by
    intro p hp
    exact outcome.2.1 p.block p.offset hp
  have clear : flagRead (C99HelperAtoms.encode out).heap l.bad=some 0 →
      flagRead s.heap l.bad=some 0 ∧ ∀ w∈checks, Good w := by
    have hc := outcome.2.2.2
    rw [C99MemoryBridge.encode_decode] at hc
    exact hc
  have topLegal : Legal l (C99HelperAtoms.encode out).heap := by
    refine ⟨?_,?_,?_,lout.badReadable,?_⟩
    · intro i hi
      apply (HelperMemoryTotal.read_some_iff _ _).mp
      rw [word_read_congr s.heap (C99HelperAtoms.encode out).heap (StableBinary.addr l.roots i) shape.1
        (fun byte => frame _ (fun hp => root_outside l hl i hi byte (allowed_subset l j hj _ hp)))]
      exact (HelperMemoryTotal.read_some_iff _ _).mpr (legal.rootsReadable i hi)
    · intro i hi
      simpa only [OwnedWriteRegion,shape.1,shape.2] using legal.leavesWritable i hi
    · intro i hi
      simpa only [OwnedWriteRegion,shape.1,shape.2] using legal.scratchWritable i hi
    · simpa only [FlagWritable,B20.C.Byte.inBounds,shape.1,shape.2] using legal.badWritable
  have newRead := leaves_after_branch l hl j s.heap (C99HelperAtoms.encode out).heap read lout shape.1 frame
  refine ⟨hmodel,⟨topLegal,fun i hi _ => newRead i hi,?_⟩,newRead⟩
  intro before safe
  refine ⟨shape.1.trans safe.size,shape.2.trans safe.writable,?_,?_,?_⟩
  · intro p hp
    exact (frame p (fun hb => hp (allowed_subset l j hj p hb))).trans (safe.frame p hp)
  · intro old hr hn hz
    exact safe.sticky old hr hn (clear hz).1
  · intro hz
    obtain ⟨hprev,hnew⟩ := clear hz
    obtain ⟨hfirst,hold⟩ := safe.clear hprev
    refine ⟨hfirst,?_⟩
    intro w hw
    change w∈out.checks at hw
    rw [htrace] at hw
    rcases List.mem_append.mp hw with hw | hw
    · exact hnew w hw
    · exact hold w hw

theorem exists_execution (l : Layout) (hl : WellFormed l) (j : Nat) (hj : j<3)
    (s : StableBinaryCExec.State) (legal : Legal l s.heap) (read : LeavesRead l s.heap) :
    ∃ out, StableTopReference.Binary l (descriptor j) (C99HelperAtoms.decode s) (C99HelperAtoms.decode out) ∧
      Effect l s out ∧ LeavesRead l out.heap := by
  have hbl := branch_wellFormed l hl j hj
  have hblegal := branch_legal l s.heap legal read j hj
  obtain ⟨after,checks,hpin⟩ := C99HelperExists.pinned_inhabited (branch l j) 8
    (C99MemoryBridge.decode s.heap) hbl (by simpa only [C99MemoryBridge.encode_decode] using hblegal)
  let out : StableBinaryCExec.State := ⟨C99MemoryBridge.encode after,checks++s.checks⟩
  have hr : StableTopReference.Binary l (descriptor j) (C99HelperAtoms.decode s) (C99HelperAtoms.decode out) := by
    refine ⟨checks,?_,rfl⟩
    change C99HelperReference.PinnedExec (StableTopReference.binaryLayout l (256*j) 256) 256
      (C99MemoryBridge.decode s.heap) (C99MemoryBridge.decode (C99MemoryBridge.encode after)) checks
    rw [reference_layout,C99MemoryBridge.decode_encode]
    exact hpin
  obtain ⟨_,he,hread⟩ := complete l hl j hj s (C99HelperAtoms.decode out) legal read hr
  rw [C99HelperAtoms.encode_decode] at he hread
  exact ⟨out,hr,he,hread⟩

end FT1536.Source3.StableTopBinaryBridge

#print axioms FT1536.Source3.StableTopBinaryBridge.complete
#print axioms FT1536.Source3.StableTopBinaryBridge.exists_execution
