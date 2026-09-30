import Source3.StableTopMemory

namespace FT1536.Source3.StableTopEffects
open StableTopMemory StableBinaryByteView

theorem root_bad_sep (l : Layout) (hl : WellFormed l) (i : Nat) (hi : i<768) :
    StableBinary.addr l.roots i+8≤l.bad ∨ l.bad+4≤StableBinary.addr l.roots i := by
  have h:=hl.rootsBad; dsimp [Separate,StableBinary.addr] at *; omega
theorem leaf_bad_sep (l : Layout) (hl : WellFormed l) (i : Nat) (hi : i<768) :
    StableBinary.addr l.leaves i+8≤l.bad ∨ l.bad+4≤StableBinary.addr l.leaves i := by
  have h:=hl.leavesBad; dsimp [Separate,StableBinary.addr] at *; omega
theorem leaf_root_sep (l : Layout) (hl : WellFormed l) (i j : Nat) (hi : i<768) (hj : j<768) :
    StableBinary.addr l.roots j+8≤StableBinary.addr l.leaves i ∨
      StableBinary.addr l.leaves i+8≤StableBinary.addr l.roots j := by
  have h:=hl.rootsLeaves; dsimp [Separate,StableBinary.addr] at *; omega

theorem flag_legal (l : Layout) (h : B20.C.Byte.Memory) (w : BitVec 32)
    (hl : WellFormed l) (legal : Legal l h) : Legal l (flagStored h l.bad w) := by
  refine ⟨?_,legal.leavesWritable,legal.scratchWritable,?_,legal.badWritable⟩
  · intro i hi
    apply (HelperMemoryTotal.read_some_iff _ _).mp
    rw [flag_write_other_word h l.bad _ w legal.badWritable (root_bad_sep l hl i hi)]
    exact (HelperMemoryTotal.read_some_iff _ _).mpr (legal.rootsReadable i hi)
  · rw [flag_stored_read h l.bad w legal.badWritable]; rfl

theorem word_legal (l : Layout) (h : B20.C.Byte.Memory) (i : Nat) (w : BitVec 64)
    (hl : WellFormed l) (legal : Legal l h) (hi : i<768) :
    Legal l (B20.Word.LE.stored h (ptr (StableBinary.addr l.leaves i)) w) := by
  refine ⟨?_,legal.leavesWritable,legal.scratchWritable,?_,legal.badWritable⟩
  · intro j hj
    apply (HelperMemoryTotal.read_some_iff _ _).mp
    rw [word_write_other h _ _ w (leaf_root_sep l hl i j hi hj)]
    exact (HelperMemoryTotal.read_some_iff _ _).mpr (legal.rootsReadable j hj)
  · rw [word_write_other_flag h _ l.bad w (leaf_bad_sep l hl i hi).symm]
    exact legal.badReadable

def Grows (l : Layout) (a b : B20.C.Byte.Memory) : Prop :=
  ∀ i<768, (wordRead a (StableBinary.addr l.leaves i)).isSome →
    (wordRead b (StableBinary.addr l.leaves i)).isSome
theorem grows_refl (l : Layout) (h : B20.C.Byte.Memory) : Grows l h h := fun _ _ h => h
theorem grows_trans {l : Layout} {a b c : B20.C.Byte.Memory} (h1 : Grows l a b) (h2 : Grows l b c) : Grows l a c :=
  fun i hi hr => h2 i hi (h1 i hi hr)
theorem flag_grows (l : Layout) (h : B20.C.Byte.Memory) (w : BitVec 32) (hl : WellFormed l) (legal : Legal l h) :
    Grows l h (flagStored h l.bad w) := by
  intro i hi hr
  rw [flag_write_other_word h l.bad _ w legal.badWritable (leaf_bad_sep l hl i hi)]
  exact hr
theorem word_grows (l : Layout) (h : B20.C.Byte.Memory) (i : Nat) (w : BitVec 64)
    (legal : Legal l h) (hi : i<768) : Grows l h (B20.Word.LE.stored h (ptr (StableBinary.addr l.leaves i)) w) := by
  intro j hj hr
  by_cases he : j=i
  · subst j
    rw [word_write_read h _ w (legal.leavesWritable i hi)]; rfl
  · rw [word_write_other h _ _ w (by dsimp [StableBinary.addr]; omega)]
    exact hr

def Good (w : BitVec 64) : Prop := Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w
structure Safe (l : Layout) (before : B20.C.Byte.Memory) (s : StableBinaryCExec.State) : Prop where
  size : s.heap.length=before.length
  writable : s.heap.writable=before.writable
  frame : ∀ p, ¬Allowed l p → s.heap.contents p=before.contents p
  sticky : ∀ old, flagRead before l.bad=some old → old≠0 → flagRead s.heap l.bad≠some 0
  clear : flagRead s.heap l.bad=some 0 → flagRead before l.bad=some 0 ∧ ∀ w∈s.checks, Good w

theorem safe_initial (l : Layout) (h : B20.C.Byte.Memory) : Safe l h ⟨h,[]⟩ := by
  refine ⟨rfl,rfl,fun _ _ => rfl,?_,?_⟩
  · intro old hr hn hz
    exact hn (Option.some.inj (hr.symm.trans hz))
  · intro hz
    exact ⟨hz,by simp⟩

theorem safe_flag (l : Layout) (before : B20.C.Byte.Memory) (s : StableBinaryCExec.State)
    (w : BitVec 64) (old : BitVec 32) (safe : Safe l before s)
    (hr : flagRead s.heap l.bad=some old) (hw : FlagWritable s.heap l.bad) :
    Safe l before ⟨flagStored s.heap l.bad (Run2.KeygenLeafGate.stableBad w old),w::s.checks⟩ := by
  have hread := flag_stored_read s.heap l.bad (Run2.KeygenLeafGate.stableBad w old) hw
  have clearOld (hz : flagRead (flagStored s.heap l.bad (Run2.KeygenLeafGate.stableBad w old)) l.bad=some 0) :
      old=0 ∧ Good w := by
    have heq : Run2.KeygenLeafGate.stableBad w old=0 := Option.some.inj (hread.symm.trans hz)
    obtain ⟨ho,hp,hs⟩ := StablePositive.clear_result w old heq
    exact ⟨ho,hp,hs⟩
  refine ⟨safe.size,safe.writable,?_,?_,?_⟩
  · intro p hout
    have hf := flag_write_byte_frame s.heap (flagStored s.heap l.bad (Run2.KeygenLeafGate.stableBad w old)) l.bad
      (Run2.KeygenLeafGate.stableBad w old) p (by simp [flagWrite,hw])
      (by dsimp [Allowed] at hout; omega)
    exact hf.trans (safe.frame p hout)
  · intro initial hi hn hz
    have ho := (clearOld hz).1
    exact safe.sticky initial hi hn (by rw [hr,ho])
  · intro hz
    obtain ⟨ho,hg⟩ := clearOld hz
    obtain ⟨hi,hall⟩ := safe.clear (by rw [hr,ho])
    refine ⟨hi,?_⟩
    intro x hx
    rcases List.mem_cons.mp hx with rfl | hx
    · exact hg
    · exact hall x hx

theorem safe_word (l : Layout) (before : B20.C.Byte.Memory) (s : StableBinaryCExec.State)
    (i : Nat) (w : BitVec 64) (hl : WellFormed l) (hi : i<768) (safe : Safe l before s) :
    Safe l before ⟨B20.Word.LE.stored s.heap (ptr (StableBinary.addr l.leaves i)) w,s.checks⟩ := by
  have hb := word_write_other_flag s.heap _ l.bad w (leaf_bad_sep l hl i hi).symm
  refine ⟨safe.size,safe.writable,?_,?_,?_⟩
  · intro p hout
    have hf : (B20.Word.LE.stored s.heap (ptr (StableBinary.addr l.leaves i)) w).contents p=s.heap.contents p := by
      apply word_write_byte_frame
      intro byte heq
      apply hout
      rw [heq]
      refine ⟨rfl,Or.inl ?_⟩
      dsimp [ptr,B20.C.Byte.Pointer.add,StableBinary.addr]
      have hbyte:=byte.isLt
      omega
    exact hf.trans (safe.frame p hout)
  · simpa only [hb] using safe.sticky
  · simpa only [hb] using safe.clear

end FT1536.Source3.StableTopEffects

#print axioms FT1536.Source3.StableTopEffects.flag_legal
#print axioms FT1536.Source3.StableTopEffects.safe_flag
#print axioms FT1536.Source3.StableTopEffects.safe_word
