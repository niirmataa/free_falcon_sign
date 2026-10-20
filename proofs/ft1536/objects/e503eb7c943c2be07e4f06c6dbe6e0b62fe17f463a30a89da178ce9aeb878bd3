import Source3.StableBinaryByteLayout

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryByteSimulation
open FT1536.Source3
open FT1536.Source3.StableBinaryByteView
open FT1536.Source3.StableBinaryByteLayout

theorem word_store_typed_words (l : StableBinary.Layout) (k : Nat)
    (mem : B20.C.Byte.Memory) (a b : Nat) (w : BitVec 64)
    (hl : l.wellFormed k) (ha : l.allowed a)
    (hw : OwnedWriteRegion mem (ptr a)) :
    (view l (B20.Word.LE.stored mem (ptr a) w)).words b =
      (if b=a then some w else (view l mem).words b) := by
  by_cases eq : b=a
  · subst b
    simp [view_written_word l mem a w ha hw]
  · by_cases hb : l.allowed b
    · have dis := allowed_pair_separated l k a b hl ha hb (Ne.symm eq)
      simp [view,hb,eq,word_write_other mem a b w (dis.symm)]
    · simp [view,hb,eq]

theorem word_store_typed_flags (l : StableBinary.Layout) (k : Nat)
    (mem : B20.C.Byte.Memory) (a b : Nat) (w : BitVec 64)
    (hl : l.wellFormed k) (ha : l.allowed a) :
    (view l (B20.Word.LE.stored mem (ptr a) w)).flags b=(view l mem).flags b := by
  by_cases eq : b=l.bad
  · subst b
    have sep := allowed_bad_separated l k a hl ha
    have dis : l.bad+4≤a ∨ a+8≤l.bad := sep.symm
    simp [view,word_write_other_flag mem a l.bad w dis]
  · simp [view,eq]

theorem flag_store_typed_words (l : StableBinary.Layout) (k : Nat)
    (mem : B20.C.Byte.Memory) (b : Nat) (w : BitVec 32)
    (hl : l.wellFormed k) (legal : FlagWritable mem l.bad) :
    (view l (flagStored mem l.bad w)).words b=(view l mem).words b := by
  by_cases hb : l.allowed b
  · have dis := allowed_bad_separated l k b hl hb
    simp [view,hb,flag_write_other_word mem l.bad b w legal dis]
  · simp [view,hb]

theorem flag_store_typed_flags (l : StableBinary.Layout)
    (mem : B20.C.Byte.Memory) (b : Nat) (w : BitVec 32)
    (legal : FlagWritable mem l.bad) :
    (view l (flagStored mem l.bad w)).flags b =
      if b=l.bad then some w else (view l mem).flags b := by
  by_cases eq : b=l.bad
  · subst b
    simp [view_written_bad l mem w legal]
  · simp [view,eq]

end FT1536.Source3.StableBinaryByteSimulation

#print axioms FT1536.Source3.StableBinaryByteSimulation.word_store_typed_words
#print axioms FT1536.Source3.StableBinaryByteSimulation.word_store_typed_flags
#print axioms FT1536.Source3.StableBinaryByteSimulation.flag_store_typed_words
#print axioms FT1536.Source3.StableBinaryByteSimulation.flag_store_typed_flags
