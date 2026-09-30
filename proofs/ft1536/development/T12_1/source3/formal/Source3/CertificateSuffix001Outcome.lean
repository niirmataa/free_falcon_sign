import Source3.CertificateCore

namespace FT1536.Source3.CertificateSuffix001Outcome
open CertificateMemory CertificateEffects CertificateAtoms StableBinaryByteView

theorem reference_exists (l : Layout) (before : C99MemoryReference.Memory) (hl : WellFormed l)
    (legal : Legal l (C99MemoryBridge.encode before)) :
    ∃ after trace ret, CertificateExec.PinnedExec l before after trace ret := CertificateCore.reference_exists l before hl legal

theorem complete (l : Layout) (before after : C99MemoryReference.Memory) (trace : List Event) (ret : Bool)
    (hl : WellFormed l) (legal : Legal l (C99MemoryBridge.encode before))
    (source : CertificateExec.PinnedExec l before after trace ret) :
    CertificateExec.run l (C99MemoryBridge.encode before)=some ⟨⟨C99MemoryBridge.encode after,trace⟩,ret⟩ :=
  (CertificateCore.complete l before after trace ret hl legal source).1

theorem source_outcome (l : Layout) (before after : C99MemoryReference.Memory) (trace : List Event) (ret : Bool)
    (hl : WellFormed l) (legal : Legal l (C99MemoryBridge.encode before))
    (source : CertificateExec.PinnedExec l before after trace ret) :
    after.size=before.size ∧ after.writable=before.writable ∧
    (∀ i<768, ∀ b : Fin 8, after.bytes 0 (l.g00+8*i+b.val)=before.bytes 0 (l.g00+8*i+b.val)) ∧
    (∀ block offset, ¬Allowed l ⟨block,offset⟩ → after.bytes block offset=before.bytes block offset) ∧
    (∀ i<1536, (wordRead (C99MemoryBridge.encode after) (StableBinary.addr (leaves l) i)).isSome) ∧
    (∀ old : BitVec 32, flagRead (C99MemoryBridge.encode before) l.bad=some old → old≠0 → ret=false) ∧
    (ret=true → flagRead (C99MemoryBridge.encode before) l.bad=some 0 ∧ (∀ e∈trace, Good e) ∧
      ∀ i<1536, ∀ w, wordRead (C99MemoryBridge.encode after) (StableBinary.addr (leaves l) i)=some w →
        Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.lowerBits.toNat≤w.toNat ∧
        w.toNat≤Run2.KeygenLeafGate.upperBits.toNat ∧ (1024 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue w ∧
        Run2.KeygenLeafGate.positiveNormalValue w<(332054 : ℝ)) := by
  obtain ⟨_,safe,topState,reverseState,D,p⟩:=CertificateCore.complete l before after trace ret hl legal source
  have reads:=CertificateReverse.initialized l CertificateQSquared.word D reverseState p.preserved p.writes
  have hmret:=CertificateReturn.complete l ⟨after,trace⟩ ret p.returned
  refine ⟨safe.size,safe.writable,?_,?_,?_,?_,?_⟩
  · intro i hi b
    exact safe.frame ((ptr (StableBinary.addr l.g00 i)).add b.val) (root_outside l hl i hi b)
  · intro block offset ho; exact safe.frame ⟨block,offset⟩ ho
  · intro i hi
    exact p.scanEffect.grows i hi (reads i hi)
  · intro old ho hn
    cases ret with
    | false => rfl
    | true => exact False.elim (safe.sticky old ho hn ((CertificateReturn.true_iff _ _).mp hmret))
  · intro htrue
    subst ret
    have clear:=(CertificateReturn.true_iff _ _).mp hmret
    have accepted:=CertificateAcceptedScan.accepted l hl reverseState ⟨after,trace⟩ p.reverseEffect.legal reads p.scan p.returned
    exact ⟨(safe.clear clear).1,(safe.clear clear).2,accepted.2.2.1⟩

theorem reverse_order (l : Layout) (before after : C99MemoryReference.Memory) (trace : List Event)
    (hl : WellFormed l) (legal : Legal l (C99MemoryBridge.encode before))
    (source : CertificateExec.PinnedExec l before after trace true) :
    ∃ (topState reverseState : State) (D : Fin 768 → BitVec 64),
      CertificateTop.Exec l ⟨before,[]⟩ (decode topState) ∧
      CertificateReverse.Finished l CertificateQSquared.word (decode topState) (decode reverseState) ∧
      CertificateScan.Exec l 0 (decode reverseState) ⟨after,trace⟩ ∧
      CertificateReverse.Snapshot l D topState ∧ CertificateReverse.Snapshot l D reverseState ∧
      (∀ i<1536, read l (encode ⟨after,trace⟩) i=read l reverseState i) ∧
      (∀ i : Fin 768, read l (encode ⟨after,trace⟩) i.val=some (D i) ∧ ∃ raw,
        C99Frontend.primitiveCall "fpr_div".toList [.uint64 CertificateQSquared.word,.uint64 (D i)] (.uint64 raw) ∧
        read l (encode ⟨after,trace⟩) (1535-i.val)=some raw ∧ Run2.KeygenLeafGate.positive raw=true) := by
  obtain ⟨_,_,topState,reverseState,D,p⟩:=CertificateCore.complete l before after trace true hl legal source
  have reads:=CertificateReverse.initialized l CertificateQSquared.word D reverseState p.preserved p.writes
  have accepted:=CertificateAcceptedScan.accepted l hl reverseState ⟨after,trace⟩ p.reverseEffect.legal reads p.scan p.returned
  have safeReverse:=p.reverseEffect.safe _ (p.topEffect.safe _ (safe_initial l (C99MemoryBridge.encode before)))
  have divs:=CertificateReverse.clear_written l CertificateQSquared.word D reverseState _ safeReverse accepted.1 p.writes
  refine ⟨topState,reverseState,D,?_,p.reverse,p.scan,p.first,p.preserved,accepted.2.1,?_⟩
  · simpa only [decode,C99MemoryBridge.decode_encode] using p.top
  · intro i
    refine ⟨(accepted.2.1 i.val (by have hi:=i.isLt; omega)).trans (p.preserved i),?_⟩
    obtain ⟨raw,hd,hw,hp⟩:=divs i
    exact ⟨raw,hd,(accepted.2.1 (1535-i.val) (by have hi:=i.isLt; omega)).trans hw,hp⟩

end FT1536.Source3.CertificateSuffix001Outcome

#check @FT1536.Source3.CertificateSuffix001Outcome.reference_exists
#check @FT1536.Source3.CertificateSuffix001Outcome.complete
#check @FT1536.Source3.CertificateSuffix001Outcome.source_outcome
#check @FT1536.Source3.CertificateSuffix001Outcome.reverse_order
#print axioms FT1536.Source3.CertificateSuffix001Outcome.reference_exists
#print axioms FT1536.Source3.CertificateSuffix001Outcome.complete
#print axioms FT1536.Source3.CertificateSuffix001Outcome.source_outcome
#print axioms FT1536.Source3.CertificateSuffix001Outcome.reverse_order
