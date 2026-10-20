import Source3.CertificateEffects

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateAtoms
open CertificateMemory CertificateEffects StableBinaryByteView

def checkLayout (l : Layout) := StableTopMemory.branch (top l) 0
def read (l : Layout) (s : State) (i : Nat) := wordRead s.heap (StableBinary.addr (leaves l) i)
def store (l : Layout) (s : State) (i : Nat) (w : BitVec 64) : Option State :=
  (wordWrite s.heap (StableBinary.addr (leaves l) i) w).map (fun heap => ⟨heap,s.trace⟩)
def positive (l : Layout) (s : State) (w : BitVec 64) : Option (BitVec 64 × State) := do
  let (z,out) ← StableBinaryCExec.positive (checkLayout l) ⟨s.heap,[]⟩ w
  pure (z,⟨out.heap,out.checks.map Event.positive ++ s.trace⟩)

def Positive (l : Layout) (s : RState) (w z : BitVec 64) (out : RState) : Prop :=
  C99CheckReference.Check s.heap (badPtr l) w z out.heap ∧ out.trace=Event.positive w::s.trace
def Store (l : Layout) (s : RState) (i : Nat) (w : BitVec 64) (out : RState) : Prop :=
  C99MemoryReference.Store64 s.heap (leafPtr l i) w out.heap ∧ out.trace=s.trace

theorem positive_complete (l : Layout) (s out : RState) (w z : BitVec 64) (h : Positive l s w z out) :
    positive l (encode s) w=some (z,encode out) := by
  have hm := C99HelperAtoms.positive_complete (checkLayout l) ⟨s.heap,[]⟩ ⟨out.heap,[w]⟩ w z ⟨h.1,rfl⟩
  unfold positive
  change (StableBinaryCExec.positive (checkLayout l) (C99HelperAtoms.encode ⟨s.heap,[]⟩) w).bind _ = _
  rw [hm]
  simp [encode,C99HelperAtoms.encode,h.2]

theorem store_complete (l : Layout) (s out : RState) (i : Nat) (w : BitVec 64) (h : Store l s i w out) :
    store l (encode s) i w=some (encode out) := by
  have hw := (C99MemoryAccess.store64_iff s.heap out.heap (leafPtr l i) w rfl h.1.1 rfl).mp h.1
  change wordWrite (C99MemoryBridge.encode s.heap) (StableBinary.addr (leaves l) i) w=some (C99MemoryBridge.encode out.heap) at hw
  simp [store,encode,hw,h.2]

theorem positive_total (l : Layout) (s : State) (w : BitVec 64) (hl : WellFormed l) (legal : Legal l s.heap) :
    ∃ z out, Positive l (decode s) w z (decode out) ∧ positive l s w=some (z,out) ∧
      z=Run2.KeygenLeafGate.stableWord w ∧ Effect l s out ∧
      ∀ j<1536, read l out j=read l s j := by
  obtain ⟨old,hr⟩:=Option.isSome_iff_exists.mp legal.badReadable
  let z:=Run2.KeygenLeafGate.stableWord w
  let flag:=Run2.KeygenLeafGate.stableBad w old
  let out : State:=⟨flagStored s.heap l.bad flag,Event.positive w::s.trace⟩
  have ha:=bad_allocated l s.heap hl legal
  have hread : C99MemoryReference.Load32 (C99MemoryBridge.decode s.heap) (badPtr l) old := by
    apply (C99MemoryAccess.load32_iff _ _ _ rfl ha rfl).mpr
    simpa [C99MemoryBridge.encode_decode,badPtr,C99MemoryReference.ArrayPointer.offset] using hr
  have hwrite : C99MemoryReference.Store32 (C99MemoryBridge.decode s.heap) (badPtr l) flag (C99MemoryBridge.decode out.heap) := by
    apply (C99MemoryAccess.store32_iff _ _ _ _ rfl ha rfl).mpr
    simp [C99MemoryBridge.encode_decode,badPtr,C99MemoryReference.ArrayPointer.offset,out,flagWrite,legal.badWritable]
  have href : Positive l (decode s) w z (decode out) :=
    ⟨C99CheckBridge.reference_of_memory _ _ _ w old hread hwrite,rfl⟩
  have hm:=positive_complete l (decode s) (decode out) w z href
  rw [encode_decode,encode_decode] at hm
  refine ⟨z,out,href,hm,rfl,⟨flag_legal l s.heap flag hl legal,flag_grows l s.heap flag hl legal,?_⟩,?_⟩
  · intro before safe
    exact safe_positive l before s w old safe hr legal.badWritable
  · intro j hj
    exact flag_write_other_word s.heap l.bad _ flag legal.badWritable (leaf_bad_sep l hl j hj)

theorem store_total (l : Layout) (s : State) (i : Nat) (w : BitVec 64)
    (hl : WellFormed l) (legal : Legal l s.heap) (hi : i<1536) :
    ∃ out, Store l (decode s) i w (decode out) ∧ store l s i w=some out ∧ Effect l s out ∧
      read l out i=some w ∧ ∀ j<1536, j≠i → read l out j=read l s j := by
  let out : State:=⟨B20.Word.LE.stored s.heap (ptr (StableBinary.addr (leaves l) i)) w,s.trace⟩
  have hm : store l s i w=some out := by simp [store,wordWrite,legal.leavesWritable i hi,out]
  have ha:=leaf_allocated l s.heap hl legal i hi
  have href : Store l (decode s) i w (decode out) := by
    refine ⟨?_,rfl⟩
    exact C99MemoryAccess.store64_model _ _ w rfl ha rfl (legal.leavesWritable i hi).2.2
  refine ⟨out,href,hm,⟨word_legal l s.heap i w hl legal hi,word_grows l s.heap i w legal hi,?_⟩,
    word_write_read s.heap _ w (legal.leavesWritable i hi),?_⟩
  · intro before safe
    exact safe_word l before s i w hl hi safe
  · intro j hj hji
    exact word_write_other s.heap _ _ w (by dsimp [StableBinary.addr]; omega)

theorem read_reference (l : Layout) (s : State) (i : Nat) (w : BitVec 64)
    (hl : WellFormed l) (legal : Legal l s.heap) (hi : i<1536) (h : read l s i=some w) :
    C99MemoryReference.Load64 (decode s).heap (leafPtr l i) w := by
  apply (C99MemoryAccess.load64_iff _ _ _ rfl (leaf_allocated l s.heap hl legal i hi) rfl).mpr
  exact h

end FT1536.Source3.CertificateAtoms

#print axioms FT1536.Source3.CertificateAtoms.positive_total
#print axioms FT1536.Source3.CertificateAtoms.store_total
