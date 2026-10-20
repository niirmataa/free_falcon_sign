import Source3.CertificateOrders

namespace FT1536.Source3.CertificateSuffix001Audit
open Run2.KeygenLeafGate

theorem wrong_reverse_mapping_detected : 1535-(0 : Nat)≠768+0 := by decide
theorem reverse_endpoints : 1535-(0 : Nat)=1535 ∧ 1535-(767 : Nat)=768 := by decide
theorem wrong_iteration_counts (l : CertificateMemory.Layout) (q : BitVec 64) (s out : CertificateEffects.RState) :
    ¬(CertificateReverse.Loop l q 767 s out ∧ ¬767<768) ∧
    ¬(CertificateReverse.Loop l q 769 s out ∧ ¬769<768) := by
  constructor
  · rintro ⟨_,h⟩; omega
  · rintro ⟨h,hf⟩
    have hn:=CertificateReverse.final_count l q s out 769 h hf
    omega
theorem wrong_q_word_rejected : ¬CertificateQSquared.SourceExec (.uint64 0x41b4409000000000#64) := by
  intro h
  have he:=CertificateQSquared.source_exact _ h
  have no : (0x41b4409000000000#64)=(0x41b4409001000000#64) := C99IntegerReference.Value.uint64.inj he
  cases no
theorem cannot_target_first_half (u : Nat) (hu : u<768) : ¬1535-u<768 := by omega
theorem inclusive_endpoints_are_accepted : rangeValid lowerBits=1#32 ∧ rangeValid upperBits=1#32 := by decide
theorem strict_endpoints_differ : ¬lowerBits.toNat<lowerBits.toNat ∧ ¬upperBits.toNat<upperBits.toNat := by omega
theorem control_trace_detects_drop (l : CertificateMemory.Layout) (s out : CertificateEffects.RState)
    (w z : BitVec 64) (h : CertificateAtoms.Positive l s w z out) : out.trace.length=s.trace.length+1 := by
  rw [h.2]; rfl
theorem return_mutation_detected (l : CertificateMemory.Layout) (s : CertificateEffects.State)
    (hb : Source3.StableBinaryByteView.flagRead s.heap l.bad=some 0) : CertificateReturn.run l s=some true :=
  (CertificateReturn.true_iff l s).mpr hb

end FT1536.Source3.CertificateSuffix001Audit

#print axioms FT1536.Source3.CertificateSuffix001Audit.wrong_iteration_counts
#print axioms FT1536.Source3.CertificateSuffix001Audit.wrong_q_word_rejected
#print axioms FT1536.Source3.CertificateSuffix001Audit.inclusive_endpoints_are_accepted
