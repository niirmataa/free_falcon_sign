import Source3.CertificateRange

namespace FT1536.Source3.CertificateRangeBridge
open CertificateMemory CertificateEffects CertificateAtoms CertificateRange StableBinaryByteView

theorem complete (l : Layout) (s out : RState) (bits : BitVec 64) (h : CertificateRange.Exec l s bits out) :
    run l (encode s) bits=some (encode out) := by
  obtain ⟨old,new,hr,hs,hw,ht⟩:=h
  have hn:=scalar_exact bits old new hs
  subst new
  have hread:=C99MemoryAccess.load32_to_model s.heap (badPtr l) old rfl hr
  have hwrite:=(C99MemoryAccess.store32_iff s.heap out.heap (badPtr l) (flags bits old) rfl hw.1 rfl).mp hw
  have hread' : flagRead (encode s).heap l.bad=some old := hread
  have hwrite' : flagWrite (encode s).heap l.bad (flags bits old)=some (encode out).heap := hwrite
  rw [run_formula,hread']
  dsimp only [Option.bind]
  rw [hwrite']
  simp [encode,ht]

theorem clear_flags (bits : BitVec 64) (old : BitVec 32) (hp : Run2.KeygenLeafGate.positive bits=true)
    (h : flags bits old=0) : old=0 ∧ Good (.lower bits) ∧ Good (.upper bits) := by
  have hf : old=0 ∧ Run2.KeygenLeafGate.rangeValid bits=1 := by
    change old ||| (Run2.KeygenLeafGate.rangeValid bits ^^^ 1#32)=0#32 at h
    rw [BitVec.or_eq_zero_iff,BitVec.xor_eq_zero_iff] at h
    exact h
  have hb:=(Run2.KeygenLeafGate.range_valid_iff bits (Run2.KeygenLeafGate.positive_sign bits hp)).mp hf.2
  exact ⟨hf.1,hb⟩

theorem safe_range (l : Layout) (before : B20.C.Byte.Memory) (s : State) (bits : BitVec 64) (old : BitVec 32)
    (safe : Safe l before s) (hp : Run2.KeygenLeafGate.positive bits=true)
    (hr : flagRead s.heap l.bad=some old) (hw : FlagWritable s.heap l.bad) :
    Safe l before ⟨flagStored s.heap l.bad (flags bits old),Event.upper bits::Event.lower bits::s.trace⟩ := by
  have hread:=flag_stored_read s.heap l.bad (flags bits old) hw
  have clearOld (hz : flagRead (flagStored s.heap l.bad (flags bits old)) l.bad=some 0) :=
    clear_flags bits old hp (Option.some.inj (hread.symm.trans hz))
  refine ⟨safe.size,safe.writable,?_,?_,?_⟩
  · intro p hout
    have hf:=flag_write_byte_frame s.heap (flagStored s.heap l.bad (flags bits old)) l.bad (flags bits old) p
      (by simp [flagWrite,hw]) (by dsimp [Allowed] at hout; omega)
    exact hf.trans (safe.frame p hout)
  · intro initial hi hn hz
    exact safe.sticky initial hi hn (by rw [hr,(clearOld hz).1])
  · intro hz
    obtain ⟨ho,hlo,hhi⟩:=clearOld hz
    obtain ⟨hi,hall⟩:=safe.clear (by rw [hr,ho])
    refine ⟨hi,?_⟩
    intro e he
    rcases List.mem_cons.mp he with rfl | he
    · exact hhi
    · rcases List.mem_cons.mp he with rfl | he
      · exact hlo
      · exact hall e he

theorem total (l : Layout) (s : State) (bits : BitVec 64) (hl : WellFormed l) (legal : Legal l s.heap)
    (hp : Run2.KeygenLeafGate.positive bits=true) : ∃ out,
    CertificateRange.Exec l (decode s) bits (decode out) ∧ run l s bits=some out ∧ Effect l s out ∧
    (∀ i<1536, read l out i=read l s i) ∧
    (∀ old, flagRead s.heap l.bad=some old → flagRead out.heap l.bad=some (flags bits old)) := by
  obtain ⟨old,hr⟩:=Option.isSome_iff_exists.mp legal.badReadable
  let out : State:=⟨flagStored s.heap l.bad (flags bits old),Event.upper bits::Event.lower bits::s.trace⟩
  have ha:=bad_allocated l s.heap hl legal
  have hread : C99MemoryReference.Load32 (C99MemoryBridge.decode s.heap) (badPtr l) old := by
    apply (C99MemoryAccess.load32_iff _ _ _ rfl ha rfl).mpr
    exact hr
  have hwrite : C99MemoryReference.Store32 (C99MemoryBridge.decode s.heap) (badPtr l) (flags bits old)
      (C99MemoryBridge.decode out.heap) := by
    exact C99MemoryAccess.store32_model _ _ _ rfl ha rfl legal.badWritable.2.2
  have href : CertificateRange.Exec l (decode s) bits (decode out) := ⟨old,flags bits old,hread,scalar_exists bits old,hwrite,rfl⟩
  have hm:=complete l (decode s) (decode out) bits href
  rw [encode_decode,encode_decode] at hm
  refine ⟨out,href,hm,⟨flag_legal l s.heap _ hl legal,flag_grows l s.heap _ hl legal,?_⟩,?_,?_⟩
  · intro before safe
    exact safe_range l before s bits old safe hp hr legal.badWritable
  · intro i hi
    exact flag_write_other_word s.heap l.bad _ _ legal.badWritable (leaf_bad_sep l hl i hi)
  · intro other ho
    have he : other=old := Option.some.inj (ho.symm.trans hr)
    subst other
    exact flag_stored_read s.heap l.bad _ legal.badWritable

end FT1536.Source3.CertificateRangeBridge

#print axioms FT1536.Source3.CertificateRangeBridge.complete
#print axioms FT1536.Source3.CertificateRangeBridge.total
