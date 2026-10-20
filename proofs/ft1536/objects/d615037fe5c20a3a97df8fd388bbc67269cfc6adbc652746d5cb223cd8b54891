import Source3.FprAllTotal
import Source3.StableBinaryInlineTotal
import Source3.StableBinaryByteLayout

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.HelperMemoryTotal
open FT1536.Source3.StableBinaryByteView
open B20.C.Byte

def ReadsGrow (l : StableBinary.Layout) (before after : B20.C.Byte.Memory) : Prop :=
  ∀ a, l.allowed a → (wordRead before a).isSome → (wordRead after a).isSome

theorem grow_refl (l : StableBinary.Layout) (m : B20.C.Byte.Memory) : ReadsGrow l m m :=
  fun _ _ h => h
theorem grow_trans {l : StableBinary.Layout} {a b c : B20.C.Byte.Memory}
    (hab : ReadsGrow l a b) (hbc : ReadsGrow l b c) : ReadsGrow l a c :=
  fun p hp hr => hbc p hp (hab p hp hr)

theorem read_some_iff (m : B20.C.Byte.Memory) (a : Nat) :
    (wordRead m a).isSome ↔ ReadRegion m (ptr a) := by
  by_cases h : ReadRegion m (ptr a) <;> simp [wordRead,h]

theorem owned_allowed (l : StableBinary.Layout) (m : B20.C.Byte.Memory)
    (legal : Legal l m) (a : Nat) (ha : l.allowed a) : OwnedWriteRegion m (ptr a) := by
  rcases StableBinaryByteLayout.allowed_index l a ha with ⟨i,hi,rfl⟩ | ⟨i,hi,rfl⟩
  · exact legal.valuesWritable i hi
  · exact legal.scratchWritable i hi

theorem word_grows (l : StableBinary.Layout) (k : Nat) (m : B20.C.Byte.Memory)
    (a : Nat) (w : BitVec 64) (hl : l.wellFormed k) (legal : Legal l m)
    (ha : l.allowed a) : ReadsGrow l m (B20.Word.LE.stored m (ptr a) w) := by
  intro b hb hread
  by_cases eq : b=a
  · subst b
    rw [word_write_read m a w (owned_allowed l m legal a ha)]
    rfl
  · have hsep := StableBinaryByteLayout.allowed_pair_separated l k a b hl ha hb (Ne.symm eq)
    rw [word_write_other m a b w hsep.symm]
    exact hread

theorem word_legal (l : StableBinary.Layout) (k : Nat) (m : B20.C.Byte.Memory)
    (a : Nat) (w : BitVec 64) (hl : l.wellFormed k) (legal : Legal l m)
    (ha : l.allowed a) : Legal l (B20.Word.LE.stored m (ptr a) w) := by
  refine ⟨?_,?_,?_,?_,?_⟩
  · intro i hi
    apply (read_some_iff _ _).mp
    exact word_grows l k m a w hl legal ha _ (values_allowed l i hi)
      ((read_some_iff _ _).mpr (legal.valuesReadable i hi))
  · exact legal.valuesWritable
  · exact legal.scratchWritable
  · rw [word_write_other_flag m a l.bad w
      (StableBinaryByteLayout.allowed_bad_separated l k a hl ha).symm]
    exact legal.badReadable
  · exact legal.badWritable

theorem flag_grows (l : StableBinary.Layout) (k : Nat) (m : B20.C.Byte.Memory)
    (w : BitVec 32) (hl : l.wellFormed k) (legal : Legal l m) :
    ReadsGrow l m (flagStored m l.bad w) := by
  intro a ha hread
  rw [flag_write_other_word m l.bad a w legal.badWritable
    (StableBinaryByteLayout.allowed_bad_separated l k a hl ha)]
  exact hread

theorem flag_legal (l : StableBinary.Layout) (k : Nat) (m : B20.C.Byte.Memory)
    (w : BitVec 32) (hl : l.wellFormed k) (legal : Legal l m) :
    Legal l (flagStored m l.bad w) := by
  refine ⟨?_,legal.valuesWritable,legal.scratchWritable,?_,legal.badWritable⟩
  · intro i hi
    apply (read_some_iff _ _).mp
    exact flag_grows l k m w hl legal _ (values_allowed l i hi)
      ((read_some_iff _ _).mpr (legal.valuesReadable i hi))
  · rw [flag_stored_read m l.bad w legal.badWritable]
    rfl

theorem store_total (l : StableBinary.Layout) (k : Nat) (s : StableBinaryCExec.State)
    (a : Nat) (w : BitVec 64) (hl : l.wellFormed k) (legal : Legal l s.heap)
    (ha : l.allowed a) :
    ∃ out, StableBinaryCExec.store s a w=some out ∧ Legal l out.heap ∧
      ReadsGrow l s.heap out.heap ∧ wordRead out.heap a=some w := by
  let out : StableBinaryCExec.State := {s with heap := B20.Word.LE.stored s.heap (ptr a) w}
  have owned := owned_allowed l s.heap legal a ha
  exact ⟨out,by simp [StableBinaryCExec.store,wordWrite,owned,out],
    word_legal l k s.heap a w hl legal ha,word_grows l k s.heap a w hl legal ha,
    word_write_read s.heap a w owned⟩

theorem positive_total (l : StableBinary.Layout) (k : Nat) (s : StableBinaryCExec.State)
    (w : BitVec 64) (hl : l.wellFormed k) (legal : Legal l s.heap) :
    ∃ z out, StableBinaryCExec.positive l s w=some (z,out) ∧ Legal l out.heap ∧
      ReadsGrow l s.heap out.heap := by
  obtain ⟨bad,hbad⟩ := Option.isSome_iff_exists.mp legal.badReadable
  exact ⟨_,_,StableBinaryTotality.positive_total l s w bad hbad legal.badWritable,
    flag_legal l k s.heap _ hl legal,flag_grows l k s.heap _ hl legal⟩

end FT1536.Source3.HelperMemoryTotal

#print axioms FT1536.Source3.HelperMemoryTotal.store_total
#print axioms FT1536.Source3.HelperMemoryTotal.positive_total
