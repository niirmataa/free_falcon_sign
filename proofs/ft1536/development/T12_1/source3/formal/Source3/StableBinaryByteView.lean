import Source3.StableBinary
import B20.Word.LESpec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryByteView
open B20.C.Byte
open FT1536.Source3.StableBinary

/- Flat LP64 addresses in one explicit C block. The byte heap has a length
   and allocation/initialization bits independent of the typed word overlay.
   The representation of `fpr` is LE uint64_t in pinned M0. -/
def ptr (a : Nat) : Pointer := ⟨0,a⟩

instance (mem : B20.C.Byte.Memory) (p : Pointer) : Decidable (ReadRegion mem p) := by
  unfold ReadRegion
  infer_instance

def wordRead (mem : B20.C.Byte.Memory) (a : Nat) : Option (BitVec 64) :=
  if ReadRegion mem (ptr a) then
    some (B20.Word.LE.join (B20.Word.LE.bufferBytes mem (ptr a)))
  else none

/- A C store does not require initialized old bytes. This deliberately
   differs from the historical bitcast helper's WriteRegion, which demanded
   a prior initialized source. Fresh scratch may be overwritten. -/
def OwnedWriteRegion (mem : B20.C.Byte.Memory) (p : Pointer) : Prop :=
  p.offset+8≤mem.length p.block ∧ mem.length p.block<2^64 ∧
  mem.writable p.block=true

instance (mem : B20.C.Byte.Memory) (p : Pointer) : Decidable (OwnedWriteRegion mem p) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _))

def wordWrite (mem : B20.C.Byte.Memory) (a : Nat) (w : BitVec 64) :
    Option B20.C.Byte.Memory :=
  if OwnedWriteRegion mem (ptr a) then some (B20.Word.LE.stored mem (ptr a) w) else none

def flagRead (mem : B20.C.Byte.Memory) (a : Nat) : Option (BitVec 32) := do
  let b0 ← readByte mem (ptr a)
  let b1 ← readByte mem ((ptr a).add 1)
  let b2 ← readByte mem ((ptr a).add 2)
  let b3 ← readByte mem ((ptr a).add 3)
  pure (b3 ++ (b2 ++ (b1 ++ b0)))

def flagBytes (w : BitVec 32) (i : Fin 4) : BitVec 8 :=
  (w >>> (8*i.val)).setWidth 8

theorem flag_join_bytes (w : BitVec 32) :
    flagBytes w 3 ++ (flagBytes w 2 ++ (flagBytes w 1 ++ flagBytes w 0)) = w := by
  have bits (i : Fin 32) :
      (flagBytes w 3 ++ (flagBytes w 2 ++ (flagBytes w 1 ++ flagBytes w 0))).getLsbD i.val =
      w.getLsbD i.val := by
    fin_cases i <;>
      simp only [flagBytes, BitVec.getLsbD_append, BitVec.getLsbD_setWidth,
        BitVec.getLsbD_ushiftRight] <;> rfl
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  exact bits ⟨i,hi⟩

def flagStored (mem : B20.C.Byte.Memory) (a : Nat) (w : BitVec 32) :
    B20.C.Byte.Memory :=
  putByte
    (putByte
      (putByte
        (putByte mem (ptr a) (flagBytes w 0))
        ((ptr a).add 1) (flagBytes w 1))
      ((ptr a).add 2) (flagBytes w 2))
    ((ptr a).add 3) (flagBytes w 3)

def FlagWritable (mem : B20.C.Byte.Memory) (a : Nat) : Prop :=
  inBounds mem (ptr a) ∧ inBounds mem ((ptr a).add 3) ∧ mem.writable 0=true

instance (mem : B20.C.Byte.Memory) (a : Nat) : Decidable (FlagWritable mem a) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _))

def flagWrite (mem : B20.C.Byte.Memory) (a : Nat) (w : BitVec 32) :
    Option B20.C.Byte.Memory :=
  if FlagWritable mem a then some (flagStored mem a w) else none

/- Only declared fpr and uint32_t objects project into the typed view.
   Overlapping, unaligned byte windows are not additional C objects; all
   unrelated bytes remain observable in the byte heap for the final frame. -/
def view (l : FT1536.Source3.StableBinary.Layout) (mem : B20.C.Byte.Memory) :
    FT1536.Source3.StableBinary.Memory where
  words a := if l.allowed a then wordRead mem a else none
  flags a := if a=l.bad then flagRead mem a else none

structure Legal (l : FT1536.Source3.StableBinary.Layout)
    (mem : B20.C.Byte.Memory) : Prop where
  valuesReadable : ∀ i<l.length, ReadRegion mem (ptr (StableBinary.addr l.values i))
  valuesWritable : ∀ i<l.length, OwnedWriteRegion mem (ptr (StableBinary.addr l.values i))
  scratchWritable : ∀ i<l.length, OwnedWriteRegion mem (ptr (StableBinary.addr l.scratch i))
  badReadable : (flagRead mem l.bad).isSome
  badWritable : FlagWritable mem l.bad

theorem values_allowed (l : FT1536.Source3.StableBinary.Layout) (i : Nat)
    (hi : i<l.length) : l.allowed (StableBinary.addr l.values i) := by
  unfold StableBinary.Layout.allowed
  have hleft : (List.range l.length).any
      (fun j => StableBinary.addr l.values i == StableBinary.addr l.values j) = true :=
    List.any_eq_true.mpr ⟨i,List.mem_range.mpr hi,by simp⟩
  simp [hleft]

theorem view_initialized (l : FT1536.Source3.StableBinary.Layout)
    (mem : B20.C.Byte.Memory) (legal : Legal l mem) :
    (view l mem).initialized l := by
  unfold StableBinary.Memory.initialized
  constructor
  · apply List.all_eq_true.mpr
    intro i hi
    have hr := legal.valuesReadable i (List.mem_range.mp hi)
    have ha := values_allowed l i (List.mem_range.mp hi)
    simp [view,ha,wordRead,hr]
  · simpa [view] using legal.badReadable

theorem word_write_read (mem : B20.C.Byte.Memory) (a : Nat) (w : BitVec 64)
    (h : OwnedWriteRegion mem (ptr a)) :
    wordRead (B20.Word.LE.stored mem (ptr a) w) a = some w := by
  have hr : ReadRegion (B20.Word.LE.stored mem (ptr a) w) (ptr a) := by
    exact ⟨h.1, h.2.1, fun i => by rw [B20.Word.LE.stored_bytes mem (ptr a) w i]; simp⟩
  have hb : B20.Word.LE.bufferBytes (B20.Word.LE.stored mem (ptr a) w) (ptr a) =
      B20.Word.LE.byteOf w := by
    funext i
    have hi := B20.Word.LE.stored_bytes mem (ptr a) w i
    simp [B20.Word.LE.bufferBytes,hi]
  simp [wordRead,hr,hb,B20.Word.LE.join_byteOf]

theorem word_write_byte_frame (mem : B20.C.Byte.Memory) (a : Nat) (w : BitVec 64)
    (q : Pointer) (h : ∀ i : Fin 8, q ≠ (ptr a).add i.val) :
    (B20.Word.LE.stored mem (ptr a) w).contents q=mem.contents q :=
  B20.Word.LE.storeBytes_frame (ptr a) q w B20.Word.LE.indices mem h

theorem word_write_other (mem : B20.C.Byte.Memory) (a b : Nat) (w : BitVec 64)
    (disjoint : b+8≤a ∨ a+8≤b) :
    wordRead (B20.Word.LE.stored mem (ptr a) w) b = wordRead mem b := by
  let final := B20.Word.LE.stored mem (ptr a) w
  have hc (i : Fin 8) : final.contents ((ptr b).add i.val) =
      mem.contents ((ptr b).add i.val) := by
    apply word_write_byte_frame
    intro j he
    have ho := congrArg Pointer.offset he
    dsimp [ptr,Pointer.add] at ho
    have hi := i.isLt
    have hj := j.isLt
    rcases disjoint with disjoint | disjoint <;> omega
  have hlen : final.length=mem.length := rfl
  have hr : ReadRegion final (ptr b) ↔ ReadRegion mem (ptr b) := by
    constructor
    · rintro ⟨h0,h1,h2⟩
      refine ⟨by simpa only [hlen] using h0,by simpa only [hlen] using h1,?_⟩
      intro i
      simpa only [hc i] using h2 i
    · rintro ⟨h0,h1,h2⟩
      refine ⟨by simpa only [hlen] using h0,by simpa only [hlen] using h1,?_⟩
      intro i
      simpa only [hc i] using h2 i
  have hb : B20.Word.LE.bufferBytes final (ptr b)=B20.Word.LE.bufferBytes mem (ptr b) := by
    funext i
    exact congrArg (·.getD 0) (hc i)
  change (if ReadRegion final (ptr b) then
      some (B20.Word.LE.join (B20.Word.LE.bufferBytes final (ptr b))) else none) =
    (if ReadRegion mem (ptr b) then
      some (B20.Word.LE.join (B20.Word.LE.bufferBytes mem (ptr b))) else none)
  by_cases read : ReadRegion mem (ptr b)
  · have readFinal := hr.mpr read
    simp [read,readFinal,hb]
  · have notFinal : ¬ReadRegion final (ptr b) := fun h => read (hr.mp h)
    simp [read,notFinal]

theorem word_write_preserves_shape (mem : B20.C.Byte.Memory) (a : Nat) (w : BitVec 64) :
    (B20.Word.LE.stored mem (ptr a) w).length=mem.length ∧
    (B20.Word.LE.stored mem (ptr a) w).writable=mem.writable := by
  exact ⟨rfl,rfl⟩

theorem flag_write_preserves_shape (mem : B20.C.Byte.Memory) (a : Nat) (w : BitVec 32) :
    (flagStored mem a w).length=mem.length ∧
    (flagStored mem a w).writable=mem.writable := by
  exact ⟨rfl,rfl⟩

theorem flag_write_byte_frame (mem final : B20.C.Byte.Memory) (a : Nat)
    (w : BitVec 32) (q : Pointer)
    (hw : flagWrite mem a w=some final)
    (hq : q.block≠0 ∨ q.offset<a ∨ a+4≤q.offset) :
    final.contents q=mem.contents q := by
  have hneq (i : Fin 4) : q≠(ptr a).add i.val := by
    intro eq
    have hb := congrArg Pointer.block eq
    have ho := congrArg Pointer.offset eq
    rcases hq with hq | hq | hq
    · exact hq (by simpa [ptr,Pointer.add] using hb)
    · have hi := i.isLt
      dsimp [ptr,Pointer.add] at ho
      omega
    · have hi := i.isLt
      dsimp [ptr,Pointer.add] at ho
      omega
  by_cases legal : FlagWritable mem a
  · have hfinal : final=flagStored mem a w := by
      exact (Option.some.inj (by simpa [flagWrite,legal] using hw)).symm
    subst final
    have h0 : q≠ptr a := by simpa [ptr,Pointer.add] using hneq 0
    have h1 : q≠(ptr a).add 1 := by simpa using hneq (1 : Fin 4)
    have h2 : q≠(ptr a).add 2 := by simpa using hneq (2 : Fin 4)
    have h3 : q≠(ptr a).add 3 := by simpa using hneq (3 : Fin 4)
    simp [flagStored,putByte,h0,h1,h2,h3]
  · simp [flagWrite,legal] at hw

theorem word_read_congr (before after : B20.C.Byte.Memory) (b : Nat)
    (hlen : after.length=before.length)
    (hbytes : ∀ i : Fin 8,
      after.contents ((ptr b).add i.val)=before.contents ((ptr b).add i.val)) :
    wordRead after b=wordRead before b := by
  have hr : ReadRegion after (ptr b) ↔ ReadRegion before (ptr b) := by
    constructor
    · rintro ⟨h0,h1,h2⟩
      refine ⟨by simpa only [hlen] using h0,by simpa only [hlen] using h1,?_⟩
      intro i
      simpa only [hbytes i] using h2 i
    · rintro ⟨h0,h1,h2⟩
      refine ⟨by simpa only [hlen] using h0,by simpa only [hlen] using h1,?_⟩
      intro i
      simpa only [hbytes i] using h2 i
  have hb : B20.Word.LE.bufferBytes after (ptr b)=
      B20.Word.LE.bufferBytes before (ptr b) := by
    funext i
    exact congrArg (·.getD 0) (hbytes i)
  change (if ReadRegion after (ptr b) then
      some (B20.Word.LE.join (B20.Word.LE.bufferBytes after (ptr b))) else none) =
    (if ReadRegion before (ptr b) then
      some (B20.Word.LE.join (B20.Word.LE.bufferBytes before (ptr b))) else none)
  by_cases read : ReadRegion before (ptr b)
  · have readAfter := hr.mpr read
    simp [read,readAfter,hb]
  · have notAfter : ¬ReadRegion after (ptr b) := fun h => read (hr.mp h)
    simp [read,notAfter]

theorem flag_write_other_word (mem : B20.C.Byte.Memory) (bad a : Nat)
    (w : BitVec 32) (legal : FlagWritable mem bad)
    (disjoint : a+8≤bad ∨ bad+4≤a) :
    wordRead (flagStored mem bad w) a=wordRead mem a := by
  apply word_read_congr mem (flagStored mem bad w) a
  · exact (flag_write_preserves_shape mem bad w).1
  · intro i
    have hw : flagWrite mem bad w=some (flagStored mem bad w) := by
      simp [flagWrite,legal]
    apply flag_write_byte_frame mem (flagStored mem bad w) bad w ((ptr a).add i.val) hw
    right
    have hi := i.isLt
    rcases disjoint with disjoint | disjoint
    · left
      dsimp [ptr,Pointer.add]
      omega
    · right
      dsimp [ptr,Pointer.add]
      omega

theorem flag_read_congr (before after : B20.C.Byte.Memory) (bad : Nat)
    (hlen : after.length=before.length)
    (hbytes : ∀ i : Fin 4,
      after.contents ((ptr bad).add i.val)=before.contents ((ptr bad).add i.val)) :
    flagRead after bad=flagRead before bad := by
  have hr (i : Fin 4) : readByte after ((ptr bad).add i.val)=
      readByte before ((ptr bad).add i.val) := by
    have hbound : inBounds after ((ptr bad).add i.val) ↔
        inBounds before ((ptr bad).add i.val) := by
      simp only [inBounds,hlen]
    by_cases h : inBounds before ((ptr bad).add i.val)
    · simp [readByte,h,hbound.mpr h,hbytes i]
    · have no : ¬inBounds after ((ptr bad).add i.val) := fun p => h (hbound.mp p)
      simp [readByte,h,no]
  have h0 : readByte after (ptr bad)=readByte before (ptr bad) := by
    simpa [ptr,Pointer.add] using hr (0 : Fin 4)
  have h1 : readByte after ((ptr bad).add 1)=readByte before ((ptr bad).add 1) := by
    simpa using hr (1 : Fin 4)
  have h2 : readByte after ((ptr bad).add 2)=readByte before ((ptr bad).add 2) := by
    simpa using hr (2 : Fin 4)
  have h3 : readByte after ((ptr bad).add 3)=readByte before ((ptr bad).add 3) := by
    simpa using hr (3 : Fin 4)
  unfold flagRead
  rw [h0,h1,h2,h3]

theorem word_write_other_flag (mem : B20.C.Byte.Memory) (a bad : Nat)
    (w : BitVec 64) (disjoint : bad+4≤a ∨ a+8≤bad) :
    flagRead (B20.Word.LE.stored mem (ptr a) w) bad=flagRead mem bad := by
  apply flag_read_congr mem (B20.Word.LE.stored mem (ptr a) w) bad
  · exact (word_write_preserves_shape mem a w).1
  · intro i
    apply word_write_byte_frame mem a w ((ptr bad).add i.val)
    intro j he
    have ho := congrArg Pointer.offset he
    dsimp [ptr,Pointer.add] at ho
    have hi := i.isLt
    have hj := j.isLt
    rcases disjoint with disjoint | disjoint <;> omega

theorem flag_stored_read (mem : B20.C.Byte.Memory) (a : Nat) (w : BitVec 32)
    (h : FlagWritable mem a) : flagRead (flagStored mem a w) a=some w := by
  have hb (i : Fin 4) : inBounds (flagStored mem a w) ((ptr a).add i.val) := by
    obtain ⟨h0,h3,_⟩ := h
    dsimp [inBounds,ptr,Pointer.add] at h0 h3 ⊢
    simp only [flagStored,putByte]
    have hi:=i.isLt
    omega
  have hc (i : Fin 4) :
      (flagStored mem a w).contents ((ptr a).add i.val)=some (flagBytes w i) := by
    fin_cases i <;> simp [flagStored,putByte,ptr,Pointer.add]
  have b0 := hb (0 : Fin 4)
  have b1 := hb (1 : Fin 4)
  have b2 := hb (2 : Fin 4)
  have b3 := hb (3 : Fin 4)
  have c0 := hc (0 : Fin 4)
  have c1 := hc (1 : Fin 4)
  have c2 := hc (2 : Fin 4)
  have c3 := hc (3 : Fin 4)
  have h0 : inBounds (flagStored mem a w) (ptr a) := by
    simpa [ptr,Pointer.add] using b0
  have d0 : (flagStored mem a w).contents (ptr a) = some (flagBytes w 0) := by
    simpa [ptr,Pointer.add] using c0
  have b1' : inBounds (flagStored mem a w) ((ptr a).add 1) := by simpa using b1
  have b2' : inBounds (flagStored mem a w) ((ptr a).add 2) := by simpa using b2
  have b3' : inBounds (flagStored mem a w) ((ptr a).add 3) := by simpa using b3
  have c1' : (flagStored mem a w).contents ((ptr a).add 1) = some (flagBytes w 1) := by simpa using c1
  have c2' : (flagStored mem a w).contents ((ptr a).add 2) = some (flagBytes w 2) := by simpa using c2
  have c3' : (flagStored mem a w).contents ((ptr a).add 3) = some (flagBytes w 3) := by simpa using c3
  simp [flagRead,readByte,h0,b1',b2',b3',d0,c1',c2',c3']
  exact flag_join_bytes w

theorem view_written_word (l : FT1536.Source3.StableBinary.Layout)
    (mem : B20.C.Byte.Memory) (a : Nat) (w : BitVec 64)
    (ha : l.allowed a) (hw : OwnedWriteRegion mem (ptr a)) :
    (view l (B20.Word.LE.stored mem (ptr a) w)).words a=some w := by
  simpa [view,ha] using word_write_read mem a w hw

theorem view_written_bad (l : FT1536.Source3.StableBinary.Layout)
    (mem : B20.C.Byte.Memory) (w : BitVec 32)
    (hw : FlagWritable mem l.bad) :
    (view l (flagStored mem l.bad w)).flags l.bad=some w := by
  simpa [view] using flag_stored_read mem l.bad w hw

end FT1536.Source3.StableBinaryByteView

#check @FT1536.Source3.StableBinaryByteView.word_write_read
#print axioms FT1536.Source3.StableBinaryByteView.word_write_read
#print axioms FT1536.Source3.StableBinaryByteView.word_write_byte_frame
#print axioms FT1536.Source3.StableBinaryByteView.flag_stored_read
#print axioms FT1536.Source3.StableBinaryByteView.view_written_word
#print axioms FT1536.Source3.StableBinaryByteView.view_written_bad
