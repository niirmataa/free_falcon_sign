import Source3.StableTopReference

namespace FT1536.Source3.StableTopAtoms
open StableTopMemory StableTopEffects StableBinaryByteView
abbrev MState := StableBinaryCExec.State

structure Effect (l : Layout) (s out : MState) : Prop where
  legal : Legal l out.heap
  grows : Grows l s.heap out.heap
  safe : ∀ before, Safe l before s → Safe l before out
theorem effect_refl (l : Layout) (s : MState) (legal : Legal l s.heap) : Effect l s s :=
  ⟨legal,grows_refl l s.heap,fun _ h => h⟩
theorem effect_trans {l : Layout} {a b c : MState} (hab : Effect l a b) (hbc : Effect l b c) : Effect l a c :=
  ⟨hbc.legal,grows_trans hab.grows hbc.grows,fun before h => hbc.safe before (hab.safe before h)⟩

theorem checked_total (l : Layout) (s : MState) (raw : BitVec 64) (hl : WellFormed l) (legal : Legal l s.heap) :
    ∃ w out, StableBinaryCExec.positive (branch l 0) s raw=some (w,out) ∧
      C99HelperReference.Positive (branch l 0) (C99HelperAtoms.decode s) raw w (C99HelperAtoms.decode out) ∧ Effect l s out := by
  obtain ⟨old,hr⟩ := Option.isSome_iff_exists.mp legal.badReadable
  let w := Run2.KeygenLeafGate.stableWord raw
  let new := Run2.KeygenLeafGate.stableBad raw old
  let out : MState := ⟨flagStored s.heap l.bad new,raw::s.checks⟩
  have hm : StableBinaryCExec.positive (branch l 0) s raw=some (w,out) :=
    StableBinaryTotality.positive_total (branch l 0) s raw old hr legal.badWritable
  have ha := bad_allocated l s.heap hl legal
  have hread : C99MemoryReference.Load32 (C99MemoryBridge.decode s.heap) (badPtr l) old := by
    apply (C99MemoryAccess.load32_iff _ _ _ rfl ha rfl).mpr
    simpa [C99MemoryBridge.encode_decode,badPtr,C99MemoryReference.ArrayPointer.offset] using hr
  have hwrite : C99MemoryReference.Store32 (C99MemoryBridge.decode s.heap) (badPtr l) new
      (C99MemoryBridge.decode out.heap) := by
    apply (C99MemoryAccess.store32_iff _ _ _ _ rfl ha rfl).mpr
    simp [C99MemoryBridge.encode_decode,badPtr,C99MemoryReference.ArrayPointer.offset,flagWrite,legal.badWritable,out]
  refine ⟨w,out,hm,⟨C99CheckBridge.reference_of_memory _ _ _ raw old hread hwrite,rfl⟩,?_,?_,?_⟩
  · exact flag_legal l s.heap new hl legal
  · exact flag_grows l s.heap new hl legal
  · intro before safe
    exact safe_flag l before s raw old safe hr legal.badWritable

theorem stored_total (l : Layout) (s : MState) (i : Nat) (w : BitVec 64)
    (hl : WellFormed l) (legal : Legal l s.heap) (hi : i<768) :
    ∃ out, StableBinaryCExec.store s (StableBinary.addr l.leaves i) w=some out ∧
      C99HelperReference.Store (leavesPtr l i) (C99HelperAtoms.decode s) w (C99HelperAtoms.decode out) ∧
      Effect l s out ∧ wordRead out.heap (StableBinary.addr l.leaves i)=some w := by
  let out : MState := ⟨B20.Word.LE.stored s.heap (ptr (StableBinary.addr l.leaves i)) w,s.checks⟩
  have hm : StableBinaryCExec.store s (StableBinary.addr l.leaves i) w=some out := by
    simp [StableBinaryCExec.store,wordWrite,legal.leavesWritable i hi,out]
  have ha := leaves_allocated l s.heap hl legal i hi
  refine ⟨out,hm,C99HelperAtoms.store_sound (leavesPtr l i) s out w rfl ha rfl hm,
    ⟨word_legal l s.heap i w hl legal hi,word_grows l s.heap i w legal hi,?_⟩,?_⟩
  · intro before safe
    exact safe_word l before s i w hl hi safe
  · exact word_write_read s.heap _ w (legal.leavesWritable i hi)

end FT1536.Source3.StableTopAtoms

#print axioms FT1536.Source3.StableTopAtoms.checked_total
#print axioms FT1536.Source3.StableTopAtoms.stored_total
