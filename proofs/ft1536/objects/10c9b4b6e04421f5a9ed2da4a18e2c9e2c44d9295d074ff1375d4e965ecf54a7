import Source3.C99HelperReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99HelperAtoms
open C99MemoryReference C99HelperReference StableBinaryByteView

def encode (s : C99HelperReference.State) : StableBinaryCExec.State := ⟨C99MemoryBridge.encode s.heap,s.checks⟩
def decode (s : StableBinaryCExec.State) : C99HelperReference.State := ⟨C99MemoryBridge.decode s.heap,s.checks⟩
theorem encode_decode (s : StableBinaryCExec.State) : encode (decode s)=s := by cases s; rfl
theorem decode_encode (s : C99HelperReference.State) : decode (encode s)=s := by cases s; rfl

theorem positive_complete (l : StableBinary.Layout) (s out : C99HelperReference.State) (w z : BitVec 64)
    (h : Positive l s w z out) : StableBinaryCExec.positive l (encode s) w=some (z,encode out) := by
  obtain ⟨hc,htrace⟩ := h
  obtain ⟨rfl,old,hr,hw⟩ := C99CheckBridge.check_iff _ _ _ _ _ |>.mp hc
  have hread := C99MemoryAccess.load32_to_model s.heap (C99HelperObjects.bad l) old rfl hr
  rw [C99HelperObjects.bad_offset] at hread
  have hwrite := (C99MemoryAccess.store32_iff s.heap out.heap (C99HelperObjects.bad l) _ rfl hw.1 rfl).mp hw
  rw [C99HelperObjects.bad_offset] at hwrite
  have writable : FlagWritable (C99MemoryBridge.encode s.heap) l.bad := by
    by_contra hn
    simp [flagWrite,hn] at hwrite
  have hmem : C99MemoryBridge.encode out.heap=flagStored (C99MemoryBridge.encode s.heap) l.bad
      (Run2.KeygenLeafGate.stableBad w old) :=
    (Option.some.inj (by simpa [flagWrite,writable] using hwrite)).symm
  have hout : encode out=⟨flagStored (encode s).heap l.bad (Run2.KeygenLeafGate.stableBad w old),w::(encode s).checks⟩ := by
    simp [encode,hmem,htrace]
  rw [hout]
  exact StableBinaryTotality.positive_total l (encode s) w old hread writable

theorem positive_sound (l : StableBinary.Layout) (k : Nat) (s out : StableBinaryCExec.State) (w z : BitVec 64)
    (hl : l.wellFormed k) (legal : Legal l s.heap)
    (h : StableBinaryCExec.positive l s w=some (z,out)) :
    Positive l (decode s) w z (decode out) ∧ Legal l out.heap := by
  obtain ⟨old,hr⟩ := Option.isSome_iff_exists.mp legal.badReadable
  obtain ⟨hz,htrace,hmem,_⟩ := StableBinaryBytePositive.source_positive_bad_update l s out w z old hr legal.badWritable h
  have ha := C99HelperObjects.bad_allocated l k (C99MemoryBridge.decode s.heap) hl
    (by simpa only [C99MemoryBridge.encode_decode] using legal)
  refine ⟨⟨?_,htrace⟩,?_⟩
  · apply (C99CheckBridge.check_iff _ _ _ _ _).mpr
    refine ⟨hz,old,?_,?_⟩
    · apply (C99MemoryAccess.load32_iff _ _ _ rfl ha rfl).mpr
      simpa [C99MemoryBridge.encode_decode,C99HelperObjects.bad_offset] using hr
    · apply (C99MemoryAccess.store32_iff _ _ _ _ rfl ha rfl).mpr
      simp [decode,C99MemoryBridge.encode_decode,C99HelperObjects.bad_offset,hmem,flagWrite,legal.badWritable]
  · rw [hmem]
    exact HelperMemoryTotal.flag_legal l k s.heap _ hl legal

theorem store_complete (p : ArrayPointer) (s out : C99HelperReference.State) (w : BitVec 64)
    (hp : p.block=0) (h : Store p s w out) :
    StableBinaryCExec.store (encode s) p.offset w=some (encode out) := by
  have hw := (C99MemoryAccess.store64_iff s.heap out.heap p w hp h.1.1 h.1.2.1).mp h.1
  simp [StableBinaryCExec.store,encode,hw,h.2]

theorem store_sound (p : ArrayPointer) (s out : StableBinaryCExec.State) (w : BitVec 64)
    (hp : p.block=0) (ha : Allocated (C99MemoryBridge.decode s.heap) p) (ht : p.elementBytes=8)
    (h : StableBinaryCExec.store s p.offset w=some out) : Store p (decode s) w (decode out) := by
  obtain ⟨heap,hw,hout⟩ := Option.bind_eq_some_iff.mp h
  have heq : out={s with heap := heap} := (Option.some.inj hout).symm
  subst out
  refine ⟨?_,rfl⟩
  apply (C99MemoryAccess.store64_iff _ _ p w hp ha ht).mpr
  simpa only [decode,C99MemoryBridge.encode_decode] using hw

theorem add_complete (s : StableBinaryCExec.State) (x y z : BitVec 64)
    (h : Binary "fpr_add".toList x y z) : StableBinaryCExec.binary "fpr_add".toList s x y=some (z,s) := by
  rw [StableBinaryCalleeBridge.add_source_word_and_frame,C99AddProof.pinned_add_complete x y z h]
  rfl
theorem mul_complete (s : StableBinaryCExec.State) (x y z : BitVec 64)
    (h : Binary "fpr_mul".toList x y z) : StableBinaryCExec.binary "fpr_mul".toList s x y=some (z,s) := by
  rw [StableBinaryCalleeBridge.mul_source_word_and_frame,C99MulProof.pinned_mul_complete x y z h]
  rfl
theorem div_complete (s : StableBinaryCExec.State) (x y z : BitVec 64)
    (h : Binary "fpr_div".toList x y z) : StableBinaryCExec.binary "fpr_div".toList s x y=some (z,s) := by
  rw [StableBinaryCalleeBridge.div_source_word_and_frame,C99DivProof.pinned_div_complete x y z h]
  rfl

theorem half_complete (s : StableBinaryCExec.State) (x z : BitVec 64)
    (h : Unary "fpr_half".toList x z) : StableBinaryCExec.unary "fpr_half".toList s x=some (z,s) := by
  rcases h with ⟨_,hh⟩ | ⟨hn,_⟩
  · rw [StableBinaryCalleeBridge.half_source_word_and_frame]
    simp [StableBinary.half,(C99LeafCalls.half_iff x z).mp hh]
  · cases hn
theorem double_complete (s : StableBinaryCExec.State) (x z : BitVec 64)
    (h : Unary "fpr_double".toList x z) : StableBinaryCExec.unary "fpr_double".toList s x=some (z,s) := by
  rcases h with ⟨hn,_⟩ | ⟨_,hh⟩
  · cases hn
  · rw [StableBinaryCalleeBridge.double_source_word_and_frame]
    simp [StableBinary.double,(C99LeafCalls.double_iff x z).mp hh]

end FT1536.Source3.C99HelperAtoms

#print axioms FT1536.Source3.C99HelperAtoms.positive_complete
#print axioms FT1536.Source3.C99HelperAtoms.positive_sound
