import Source3.CertificateRangeBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateScanStep
open CertificateMemory CertificateEffects CertificateAtoms StableBinaryByteView
abbrev Word := BitVec 64

def run (l : Layout) (i : Nat) (s : State) : Option State := do
  if ¬i<1536 then none else do
  let x ← read l s i
  let (z,mid) ← positive l s x
  let stored ← store l mid i z
  let value ← read l stored i
  let bits ← BitcastObjects.execute KeygenHelpers.bitsProgram value
  CertificateRange.run l stored bits

inductive Exec (l : Layout) (i : Nat) : RState → RState → Prop where
  | step (s mid stored out : RState) (x z value bits : Word) (guard : i<1536)
      (load : C99MemoryReference.Load64 s.heap (leafPtr l i) x)
      (check : Positive l s x z mid) (write : Store l mid i z stored)
      (reload : C99MemoryReference.Load64 stored.heap (leafPtr l i) value)
      (bitcast : C99BitcastReference.Exec value bits)
      (range : CertificateRange.Exec l stored bits out) : Exec l i s out

theorem complete (l : Layout) (i : Nat) (s out : RState) (h : Exec l i s out) : run l i (encode s)=some (encode out) := by
  cases h with
  | step mid stored _ x z value bits hi hr hc hw hl hb hg =>
      have he:=C99BitcastReference.result_exact value bits hb
      subst bits
      have hr' : read l (encode s) i=some x := C99MemoryBridge.load64_source_to_interpreter _ _ _ rfl hr
      have hl' : read l (encode stored) i=some value := C99MemoryBridge.load64_source_to_interpreter _ _ _ rfl hl
      have hc':=positive_complete l s mid x z hc
      have hw':=store_complete l mid stored i z hw
      have hg':=CertificateRangeBridge.complete l stored out value hg
      simp only [run,hi,not_true_eq_false,ite_false,hr',hc',hw',hl',KeygenHelpers.bits_execution,hg',Bind.bind,Option.bind]

theorem stable_positive (w : Word) : Run2.KeygenLeafGate.positive (Run2.KeygenLeafGate.stableWord w)=true := by
  rw [Run2.KeygenLeafGate.stableWord_cases]
  cases hp : Run2.KeygenLeafGate.positive w
  · change Run2.KeygenLeafGate.positive Run2.KeygenLeafGate.oneBits=true
    decide
  · exact hp

theorem positive_formula (l : Layout) (s : State) (x : Word) (bad : BitVec 32)
    (hr : flagRead s.heap l.bad=some bad) (hw : FlagWritable s.heap l.bad) :
    positive l s x=some (Run2.KeygenLeafGate.stableWord x,
      ⟨flagStored s.heap l.bad (Run2.KeygenLeafGate.stableBad x bad),Event.positive x::s.trace⟩) := by
  have h:=StableBinaryTotality.positive_total (checkLayout l) ⟨s.heap,[]⟩ x bad hr hw
  unfold positive
  rw [h]
  rfl

theorem store_flag (l : Layout) (hl : WellFormed l) (s out : State) (i : Nat) (w : Word)
    (hi : i<1536) (h : store l s i w=some out) : flagRead out.heap l.bad=flagRead s.heap l.bad := by
  have owned : OwnedWriteRegion s.heap (ptr (StableBinary.addr (leaves l) i)) := by
    by_contra hn
    simp [store,wordWrite,hn] at h
  have heq : out=⟨B20.Word.LE.stored s.heap (ptr (StableBinary.addr (leaves l) i)) w,s.trace⟩ := by
    simpa [store,wordWrite,owned] using h.symm
  rw [heq]
  exact word_write_other_flag s.heap _ l.bad w (leaf_bad_sep l hl i hi).symm

theorem total (l : Layout) (hl : WellFormed l) (i : Nat) (hi : i<1536) (s : State) (x : Word)
    (legal : Legal l s.heap) (hr : read l s i=some x) : ∃ out,
    Exec l i (decode s) (decode out) ∧ Effect l s out ∧
    read l out i=some (Run2.KeygenLeafGate.stableWord x) ∧
    (∀ j<1536, j≠i → read l out j=read l s j) ∧
    (∀ old, flagRead s.heap l.bad=some old → flagRead out.heap l.bad=some (Run2.KeygenLeafGate.leafStep x old).2) ∧
    (∀ e∈s.trace, e∈out.trace) := by
  have hload:=read_reference l s i x hl legal hi hr
  obtain ⟨z,mid,hc,hcm,hz,em,pm⟩:=positive_total l s x hl legal
  obtain ⟨stored,hw,hwm,ew,hrw,pw⟩:=store_total l mid i z hl em.legal hi
  have hzpos : Run2.KeygenLeafGate.positive z=true := by rw [hz]; exact stable_positive x
  have hreload:=read_reference l stored i z hl ew.legal hi hrw
  obtain ⟨out,hg,_,eg,pg,bg⟩:=CertificateRangeBridge.total l stored z hl ew.legal hzpos
  have trace : out.trace=Event.upper z::Event.lower z::Event.positive x::s.trace := by
    obtain ⟨_,_,_,_,_,ht⟩:=hg
    exact ht.trans (congrArg (fun xs => Event.upper z::Event.lower z::xs) (hw.2.trans hc.2))
  refine ⟨out,Exec.step (decode s) (decode mid) (decode stored) (decode out) x z z z hi hload hc hw hreload
    (C99BitcastReference.inhabited z) hg,effect_trans (effect_trans em ew) eg,?_,?_,?_,?_⟩
  · rw [pg i hi,hrw,hz]
  · intro j hj hji
    exact (pg j hj).trans ((pw j hj hji).trans (pm j hj))
  · intro old hold
    have hcanon:=positive_formula l s x old hold legal.badWritable
    have hpair:=Option.some.inj (hcm.symm.trans hcanon)
    have hmheap : mid.heap=flagStored s.heap l.bad (Run2.KeygenLeafGate.stableBad x old) := congrArg (fun p => p.2.heap) hpair
    have hbmid : flagRead mid.heap l.bad=some (Run2.KeygenLeafGate.stableBad x old) := by
      rw [hmheap]; exact flag_stored_read s.heap l.bad _ legal.badWritable
    have hbstored : flagRead stored.heap l.bad=some (Run2.KeygenLeafGate.stableBad x old) := by
      rw [store_flag l hl mid stored i z hi hwm]; exact hbmid
    have hbout:=bg _ hbstored
    rw [hz] at hbout
    exact hbout
  · intro e he
    rw [trace]
    exact List.mem_cons_of_mem _ (List.mem_cons_of_mem _ (List.mem_cons_of_mem _ he))

end FT1536.Source3.CertificateScanStep

#print axioms FT1536.Source3.CertificateScanStep.complete
#print axioms FT1536.Source3.CertificateScanStep.total
