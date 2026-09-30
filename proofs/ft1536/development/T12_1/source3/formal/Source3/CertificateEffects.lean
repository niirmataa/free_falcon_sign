import Source3.CertificateMemory
import Source3.LeafWordBounds

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateEffects
open CertificateMemory StableBinaryByteView

inductive Event where
  | positive (word : BitVec 64)
  | lower (word : BitVec 64)
  | upper (word : BitVec 64)
  deriving DecidableEq, Repr
def Good : Event → Prop
  | .positive w => Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w
  | .lower w => Run2.KeygenLeafGate.lowerBits.toNat≤w.toNat
  | .upper w => w.toNat≤Run2.KeygenLeafGate.upperBits.toNat
structure State where
  heap : B20.C.Byte.Memory
  trace : List Event := []
structure RState where
  heap : C99MemoryReference.Memory
  trace : List Event := []
def encode (s : RState) : State := ⟨C99MemoryBridge.encode s.heap,s.trace⟩
def decode (s : State) : RState := ⟨C99MemoryBridge.decode s.heap,s.trace⟩
theorem encode_decode (s : State) : encode (decode s)=s := by cases s; rfl
theorem decode_encode (s : RState) : decode (encode s)=s := by cases s; rfl

structure Safe (l : Layout) (before : B20.C.Byte.Memory) (s : State) : Prop where
  size : s.heap.length=before.length
  writable : s.heap.writable=before.writable
  frame : ∀ p, ¬Allowed l p → s.heap.contents p=before.contents p
  sticky : ∀ old, flagRead before l.bad=some old → old≠0 → flagRead s.heap l.bad≠some 0
  clear : flagRead s.heap l.bad=some 0 → flagRead before l.bad=some 0 ∧ ∀ e∈s.trace, Good e
def Grows (l : Layout) (a b : B20.C.Byte.Memory) : Prop := ∀ i<1536,
  (wordRead a (StableBinary.addr (leaves l) i)).isSome → (wordRead b (StableBinary.addr (leaves l) i)).isSome
structure Effect (l : Layout) (s out : State) : Prop where
  legal : Legal l out.heap
  grows : Grows l s.heap out.heap
  safe : ∀ before, Safe l before s → Safe l before out
theorem effect_refl (l : Layout) (s : State) (legal : Legal l s.heap) : Effect l s s :=
  ⟨legal,fun _ _ h => h,fun _ h => h⟩
theorem effect_trans {l : Layout} {s mid out : State} (a : Effect l s mid) (b : Effect l mid out) : Effect l s out :=
  ⟨b.legal,fun i hi h => b.grows i hi (a.grows i hi h),fun before h => b.safe before (a.safe before h)⟩

theorem root_bad_sep (l : Layout) (hl : WellFormed l) (i : Nat) (hi : i<768) :
    StableBinary.addr l.g00 i+8≤l.bad ∨ l.bad+4≤StableBinary.addr l.g00 i := by
  have h:=hl.rootsBad; dsimp [StableTopMemory.Separate,StableBinary.addr] at *; omega
theorem leaf_bad_sep (l : Layout) (hl : WellFormed l) (i : Nat) (hi : i<1536) :
    StableBinary.addr (leaves l) i+8≤l.bad ∨ l.bad+4≤StableBinary.addr (leaves l) i := by
  have h:=hl.bufferBad; dsimp [StableTopMemory.Separate,StableBinary.addr,leaves] at *; omega
theorem leaf_root_sep (l : Layout) (hl : WellFormed l) (i j : Nat) (hi : i<1536) (hj : j<768) :
    StableBinary.addr l.g00 j+8≤StableBinary.addr (leaves l) i ∨
      StableBinary.addr (leaves l) i+8≤StableBinary.addr l.g00 j := by
  have h:=hl.rootsBuffer; dsimp [StableTopMemory.Separate,StableBinary.addr,leaves] at *; omega

theorem flag_legal (l : Layout) (h : B20.C.Byte.Memory) (w : BitVec 32)
    (hl : WellFormed l) (legal : Legal l h) : Legal l (flagStored h l.bad w) := by
  refine ⟨?_,legal.leavesWritable,legal.scratchWritable,?_,legal.badWritable⟩
  · intro i hi
    apply (HelperMemoryTotal.read_some_iff _ _).mp
    rw [flag_write_other_word h l.bad _ w legal.badWritable (root_bad_sep l hl i hi)]
    exact (HelperMemoryTotal.read_some_iff _ _).mpr (legal.rootsReadable i hi)
  · rw [flag_stored_read h l.bad w legal.badWritable]; rfl
theorem word_legal (l : Layout) (h : B20.C.Byte.Memory) (i : Nat) (w : BitVec 64)
    (hl : WellFormed l) (legal : Legal l h) (hi : i<1536) :
    Legal l (B20.Word.LE.stored h (ptr (StableBinary.addr (leaves l) i)) w) := by
  refine ⟨?_,legal.leavesWritable,legal.scratchWritable,?_,legal.badWritable⟩
  · intro j hj
    apply (HelperMemoryTotal.read_some_iff _ _).mp
    rw [word_write_other h _ _ w (leaf_root_sep l hl i j hi hj)]
    exact (HelperMemoryTotal.read_some_iff _ _).mpr (legal.rootsReadable j hj)
  · rw [word_write_other_flag h _ l.bad w (leaf_bad_sep l hl i hi).symm]
    exact legal.badReadable
theorem flag_grows (l : Layout) (h : B20.C.Byte.Memory) (w : BitVec 32) (hl : WellFormed l) (legal : Legal l h) :
    Grows l h (flagStored h l.bad w) := by
  intro i hi hr
  rw [flag_write_other_word h l.bad _ w legal.badWritable (leaf_bad_sep l hl i hi)]
  exact hr
theorem word_grows (l : Layout) (h : B20.C.Byte.Memory) (i : Nat) (w : BitVec 64)
    (legal : Legal l h) (hi : i<1536) : Grows l h (B20.Word.LE.stored h (ptr (StableBinary.addr (leaves l) i)) w) := by
  intro j hj hr
  by_cases he : j=i
  · subst j; rw [word_write_read h _ w (legal.leavesWritable i hi)]; rfl
  · rw [word_write_other h _ _ w (by dsimp [StableBinary.addr]; omega)]; exact hr

theorem safe_initial (l : Layout) (h : B20.C.Byte.Memory) : Safe l h ⟨h,[]⟩ := by
  refine ⟨rfl,rfl,fun _ _ => rfl,?_,?_⟩
  · intro old hr hn hz; exact hn (Option.some.inj (hr.symm.trans hz))
  · intro hz; exact ⟨hz,by simp⟩

theorem safe_positive (l : Layout) (before : B20.C.Byte.Memory) (s : State) (w : BitVec 64) (old : BitVec 32)
    (safe : Safe l before s) (hr : flagRead s.heap l.bad=some old) (hw : FlagWritable s.heap l.bad) :
    Safe l before ⟨flagStored s.heap l.bad (Run2.KeygenLeafGate.stableBad w old),Event.positive w::s.trace⟩ := by
  have hread:=flag_stored_read s.heap l.bad (Run2.KeygenLeafGate.stableBad w old) hw
  have clearOld (hz : flagRead (flagStored s.heap l.bad (Run2.KeygenLeafGate.stableBad w old)) l.bad=some 0) :
      old=0 ∧ Good (.positive w) := by
    have he:=Option.some.inj (hread.symm.trans hz)
    obtain ⟨ho,hp,hs⟩:=StablePositive.clear_result w old he
    exact ⟨ho,hp,hs⟩
  refine ⟨safe.size,safe.writable,?_,?_,?_⟩
  · intro p hout
    have hf:=flag_write_byte_frame s.heap (flagStored s.heap l.bad (Run2.KeygenLeafGate.stableBad w old))
      l.bad (Run2.KeygenLeafGate.stableBad w old) p
      (by simp [flagWrite,hw]) (by dsimp [Allowed] at hout; omega)
    exact hf.trans (safe.frame p hout)
  · intro initial hi hn hz
    exact safe.sticky initial hi hn (by rw [hr,(clearOld hz).1])
  · intro hz
    obtain ⟨ho,hg⟩:=clearOld hz
    obtain ⟨hi,hall⟩:=safe.clear (by rw [hr,ho])
    refine ⟨hi,?_⟩
    intro e he
    rcases List.mem_cons.mp he with rfl | he
    · exact hg
    · exact hall e he

theorem safe_word (l : Layout) (before : B20.C.Byte.Memory) (s : State) (i : Nat) (w : BitVec 64)
    (hl : WellFormed l) (hi : i<1536) (safe : Safe l before s) :
    Safe l before ⟨B20.Word.LE.stored s.heap (ptr (StableBinary.addr (leaves l) i)) w,s.trace⟩ := by
  have hb:=word_write_other_flag s.heap _ l.bad w (leaf_bad_sep l hl i hi).symm
  refine ⟨safe.size,safe.writable,?_,?_,?_⟩
  · intro p hout
    have hf : (B20.Word.LE.stored s.heap (ptr (StableBinary.addr (leaves l) i)) w).contents p=s.heap.contents p := by
      apply word_write_byte_frame
      intro byte heq
      apply hout
      rw [heq]
      refine ⟨rfl,Or.inl ?_⟩
      dsimp [ptr,B20.C.Byte.Pointer.add,StableBinary.addr,leaves]
      have hbyte:=byte.isLt
      omega
    exact hf.trans (safe.frame p hout)
  · simpa only [hb] using safe.sticky
  · simpa only [hb] using safe.clear

end FT1536.Source3.CertificateEffects

#print axioms FT1536.Source3.CertificateEffects.safe_positive
#print axioms FT1536.Source3.CertificateEffects.safe_word
