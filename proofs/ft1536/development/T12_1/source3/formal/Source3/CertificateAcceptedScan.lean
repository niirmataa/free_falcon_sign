import Source3.CertificateReturn

namespace FT1536.Source3.CertificateAcceptedScan
open CertificateMemory CertificateEffects CertificateAtoms StableBinaryByteView

theorem accepted (l : Layout) (hl : WellFormed l) (s : State) (out : RState)
    (legal : Legal l s.heap) (reads : ∀ i<1536, (read l s i).isSome)
    (scan : CertificateScan.Exec l 0 (decode s) out) (ret : CertificateReturn.Exec l out true) :
    flagRead s.heap l.bad=some 0 ∧
    (∀ i<1536, read l (encode out) i=read l s i) ∧
    (∀ i<1536, ∀ w, read l (encode out) i=some w →
      Run2.KeygenLeafGate.positive w=true ∧
      Run2.KeygenLeafGate.lowerBits.toNat≤w.toNat ∧ w.toNat≤Run2.KeygenLeafGate.upperBits.toNat ∧
      (1024 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue w ∧
      Run2.KeygenLeafGate.positiveNormalValue w<(332054 : ℝ)) ∧
    (∀ e∈s.trace, e∈(encode out).trace) := by
  obtain ⟨_,_,projection⟩:=CertificateScan.source_refinement l hl s out legal reads scan
  have hr:=CertificateReturn.complete l out true ret
  have clear:=(CertificateReturn.true_iff l (encode out)).mp hr
  obtain ⟨bad,hbad⟩:=Option.isSome_iff_exists.mp legal.badReadable
  obtain ⟨rep,hfinal,trace⟩:=projection bad hbad
  have hscan : (Run2.KeygenLeafGate.scan (CertificateScan.snapshot l s) bad).2=0 :=
    Option.some.inj (hfinal.symm.trans clear)
  have inputRep:=CertificateScan.snapshot_represents l s reads
  have legacy : LeafCertificateSuffix.suffix (CertificateScan.snapshot l s) bad=
      some ((Run2.KeygenLeafGate.scan (CertificateScan.snapshot l s) bad).1,CLogic.boolean true) := by
    rw [LeafCertificateSuffix.suffix_execution _ _ inputRep.1,hscan]
    rfl
  obtain ⟨hb,heq,hbounds⟩:=LeafCertificateSuffix.source_return_one_forces_word_bounds _ _ _ inputRep.1 legacy
  obtain ⟨_,_,hreals⟩:=LeafWordBounds.source_return_one_stored_bounds _ _ _ inputRep.1 legacy
  rw [heq] at rep
  refine ⟨by rw [hbad,hb]; rfl,?_,?_,trace⟩
  · intro i hi
    exact (rep.2 i hi).trans (inputRep.2 i hi).symm
  · intro i hi w hw
    have hget : (CertificateScan.snapshot l s)[i]?=some w := (rep.2 i hi).symm.trans hw
    have hm:=List.mem_of_getElem? hget
    have h1:=hbounds w hm
    have h2:=hreals w hm
    exact ⟨h1.1,h1.2.1,h1.2.2,h2.2.1,h2.2.2.1⟩

theorem accepted_bytes (l : Layout) (hl : WellFormed l) (s : State) (out : RState)
    (legal : Legal l s.heap) (reads : ∀ i<1536, (read l s i).isSome)
    (scan : CertificateScan.Exec l 0 (decode s) out) (ret : CertificateReturn.Exec l out true) :
    ∀ i<1536, ∀ b : Fin 8,
      out.heap.bytes 0 (leaves l+8*i+b.val)=s.heap.contents ⟨0,leaves l+8*i+b.val⟩ := by
  have preserve:=(accepted l hl s out legal reads scan ret).2.1
  intro i hi b
  obtain ⟨w,hw⟩:=Option.isSome_iff_exists.mp (reads i hi)
  have ha : read l (encode out) i=some w := (preserve i hi).trans hw
  have hb:=StableBinaryMemcpySpec.loaded_word_reencodes_bytes s.heap (StableBinary.addr (leaves l) i) w b hw
  have hc:=StableBinaryMemcpySpec.loaded_word_reencodes_bytes (encode out).heap (StableBinary.addr (leaves l) i) w b ha
  exact hc.trans hb.symm

end FT1536.Source3.CertificateAcceptedScan

#print axioms FT1536.Source3.CertificateAcceptedScan.accepted
#print axioms FT1536.Source3.CertificateAcceptedScan.accepted_bytes
