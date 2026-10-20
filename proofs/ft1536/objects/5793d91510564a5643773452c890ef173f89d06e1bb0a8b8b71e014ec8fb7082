import Source3.StableBinaryCopyRefinement
import Mathlib.Tactic.FinCases

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryMemcpySpec
open B20.C.Byte
open FT1536.Source3
open FT1536.Source3.StableBinaryByteView

/- The inverse of the pinned LE load/store lemma: re-encoding a loaded
   fpr word reproduces each of its original eight object bytes. -/
theorem byte_of_join (b : Fin 8 → BitVec 8) (i : Fin 8) :
    B20.Word.LE.byteOf (B20.Word.LE.join b) i=b i := by
  have bits (i : Fin 8) (j : Fin 8) :
      (B20.Word.LE.byteOf (B20.Word.LE.join b) i).getLsbD j.val =
      (b i).getLsbD j.val := by
    fin_cases i <;> fin_cases j <;>
      simp only [B20.Word.LE.byteOf,B20.Word.LE.join,
        BitVec.getLsbD_setWidth,BitVec.getLsbD_ushiftRight,
        BitVec.getLsbD_append] <;> rfl
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  exact bits i ⟨j,hj⟩

theorem loaded_word_reencodes_bytes (mem : B20.C.Byte.Memory) (a : Nat)
    (w : BitVec 64) (byte : Fin 8)
    (h : wordRead mem a=some w) :
    mem.contents ((ptr a).add byte.val)=some (B20.Word.LE.byteOf w byte) := by
  have hr : ReadRegion mem (ptr a) := by
    by_contra hn
    simp [wordRead,hn] at h
  have hw : w=B20.Word.LE.join (B20.Word.LE.bufferBytes mem (ptr a)) := by
    have hp : some (B20.Word.LE.join (B20.Word.LE.bufferBytes mem (ptr a)))=some w := by
      simpa [wordRead,hr] using h
    exact (Option.some.inj hp).symm
  rw [hw,byte_of_join]
  exact B20.Word.LE.bufferBytes_spec mem (ptr a) hr byte

theorem word_store_address_frame (source final : StableBinaryCExec.State)
    (a : Nat) (w : BitVec 64) (q : Pointer)
    (hq : q.block≠0 ∨ q.offset<a ∨ a+8≤q.offset)
    (hs : StableBinaryCExec.store source a w=some final) :
    final.heap.contents q=source.heap.contents q := by
  have owned : OwnedWriteRegion source.heap (ptr a) := by
    by_contra hn
    simp [StableBinaryCExec.store,wordWrite,hn] at hs
  have eqs : final={source with heap := B20.Word.LE.stored source.heap (ptr a) w} := by
    simpa [StableBinaryCExec.store,wordWrite,owned] using hs.symm
  subst final
  apply word_write_byte_frame
  intro i he
  have hblock := congrArg Pointer.block he
  have hoffset := congrArg Pointer.offset he
  dsimp [ptr,Pointer.add] at hblock hoffset
  have hi := i.isLt
  rcases hq with hq | hq | hq <;> omega

theorem word_store_byte_exact (source final : StableBinaryCExec.State)
    (a : Nat) (w : BitVec 64) (i : Fin 8)
    (hs : StableBinaryCExec.store source a w=some final) :
    final.heap.contents ((ptr a).add i.val) = some (B20.Word.LE.byteOf w i) := by
  have owned : OwnedWriteRegion source.heap (ptr a) := by
    by_contra hn
    simp [StableBinaryCExec.store,wordWrite,hn] at hs
  have eqs : final={source with heap := B20.Word.LE.stored source.heap (ptr a) w} := by
    simpa [StableBinaryCExec.store,wordWrite,owned] using hs.symm
  subst final
  exact B20.Word.LE.stored_bytes source.heap (ptr a) w i

theorem write_copy_destination_frame (base index : Nat) (words : List (BitVec 64))
    (source final : StableBinaryCExec.State) (q : Pointer)
    (hq : q.block≠0 ∨ q.offset<base+8*index ∨
      base+8*(index+words.length)≤q.offset)
    (hs : StableBinaryCExec.writeCopy base index words source=some final) :
    final.heap.contents q=source.heap.contents q := by
  induction words generalizing index source final with
  | nil =>
      have heq : source=final := Option.some.inj (by simpa [StableBinaryCExec.writeCopy] using hs)
      subst final
      rfl
  | cons w rest ih =>
      have hsrc : (do
        let mid ← StableBinaryCExec.store source (StableBinary.addr base index) w
        StableBinaryCExec.writeCopy base (index+1) rest mid)=some final := by
        simpa [StableBinaryCExec.writeCopy] using hs
      obtain ⟨mid,hstore,hrest⟩ := Option.bind_eq_some_iff.mp hsrc
      have hword : q.block≠0 ∨ q.offset<StableBinary.addr base index ∨
          StableBinary.addr base index+8≤q.offset := by
        simp only [List.length_cons] at hq
        dsimp [StableBinary.addr]
        omega
      have htail : q.block≠0 ∨ q.offset<base+8*(index+1) ∨
          base+8*(index+1+rest.length)≤q.offset := by
        simp only [List.length_cons] at hq
        omega
      exact (ih (index+1) mid final htail hrest).trans
        (word_store_address_frame source mid (StableBinary.addr base index) w q hword hstore)

theorem write_copy_byte_at (base index : Nat) (words : List (BitVec 64))
    (source final : StableBinaryCExec.State) (j : Nat) (w : BitVec 64)
    (byte : Fin 8)
    (hword : words[j]?=some w)
    (hs : StableBinaryCExec.writeCopy base index words source=some final) :
    final.heap.contents ((ptr (StableBinary.addr base (index+j))).add byte.val)=
      some (B20.Word.LE.byteOf w byte) := by
  induction words generalizing index source final j w with
  | nil => simp at hword
  | cons head rest ih =>
      have hsrc : (do
          let mid ← StableBinaryCExec.store source (StableBinary.addr base index) head
          StableBinaryCExec.writeCopy base (index+1) rest mid)=some final := by
        simpa [StableBinaryCExec.writeCopy] using hs
      obtain ⟨mid,hstore,hrest⟩ := Option.bind_eq_some_iff.mp hsrc
      cases j with
      | zero =>
          have hw : head=w := by simpa using hword
          subst w
          have hbefore : (ptr (StableBinary.addr base (index+0))).add byte.val =
              (ptr (StableBinary.addr base index)).add byte.val := by simp
          rw [hbefore]
          have hframe := write_copy_destination_frame base (index+1) rest mid final
            ((ptr (StableBinary.addr base index)).add byte.val)
            (Or.inr (Or.inl (by dsimp [ptr,B20.C.Byte.Pointer.add,StableBinary.addr]; have hi:=byte.isLt; omega)))
            hrest
          rw [hframe]
          exact word_store_byte_exact source mid (StableBinary.addr base index) head byte hstore
      | succ j =>
          have hw : rest[j]?=some w := by simpa using hword
          have haddr : StableBinary.addr base (index+(j+1)) =
              StableBinary.addr base ((index+1)+j) := by simp [StableBinary.addr]; omega
          rw [haddr]
          exact ih (index+1) mid final j w hw hrest

theorem read_copy_word_at (scratch n : Nat) (source : StableBinaryCExec.State)
    (words : List (BitVec 64)) (j : Nat) (w : BitVec 64)
    (hj : j<n) (hread : StableBinaryCExec.readCopy scratch n source=some words)
    (hword : words[j]?=some w) :
    StableBinaryByteView.wordRead source.heap (StableBinary.addr scratch j)=some w := by
  induction n generalizing words j w with
  | zero => omega
  | succ n ih =>
      have hsource : (do
          let xs ← StableBinaryCExec.readCopy scratch n source
          let last ← StableBinaryCExec.load source (StableBinary.addr scratch n)
          pure (xs++[last]))=some words := by
        simpa [StableBinaryCExec.readCopy] using hread
      obtain ⟨xs,hprefix,hrest⟩ := Option.bind_eq_some_iff.mp hsource
      obtain ⟨last,hload,hret⟩ := Option.bind_eq_some_iff.mp hrest
      have hwords : words=xs++[last] := (Option.some.inj hret).symm
      have hlen := StableBinaryCopyRefinement.read_copy_length scratch n source xs hprefix
      by_cases hj0 : j<n
      · rw [hwords,List.getElem?_append_left (by omega)] at hword
        exact ih xs j w hj0 hprefix hword
      · have hlast : j=n := by omega
        subst j
        rw [hwords,List.getElem?_append_right (by omega)] at hword
        have heq : last=w := Option.some.inj (by simpa [hlen] using hword)
        subst w
        simpa [StableBinaryCExec.load] using hload

theorem bytewise_copy (dst scratch n : Nat) (source final : StableBinaryCExec.State)
    (j : Nat) (byte : Fin 8) (hj : j<n)
    (hs : StableBinaryCExec.copy source dst scratch n=some final) :
    final.heap.contents ((ptr (StableBinary.addr dst j)).add byte.val) =
      source.heap.contents ((ptr (StableBinary.addr scratch j)).add byte.val) := by
  unfold StableBinaryCExec.copy at hs
  obtain ⟨words,hread,hwrite⟩ := Option.bind_eq_some_iff.mp hs
  have hlen : words.length=n :=
    StableBinaryCopyRefinement.read_copy_length scratch n source words hread
  have hidx : j<words.length := by rw [hlen]; exact hj
  let w := words[j]
  have hword : words[j]?=some w := by simp [w,hidx]
  have hdst := write_copy_byte_at dst 0 words source final j w byte hword hwrite
  have hsrc := read_copy_word_at scratch n source words j w hj hread hword
  have hsourceByte := loaded_word_reencodes_bytes source.heap
    (StableBinary.addr scratch j) w byte hsrc
  simpa using hdst.trans hsourceByte.symm

theorem copy_outside_destination (dst scratch n : Nat)
    (source final : StableBinaryCExec.State) (q : Pointer)
    (hq : q.block≠0 ∨ q.offset<dst ∨ dst+8*n≤q.offset)
    (hs : StableBinaryCExec.copy source dst scratch n=some final) :
    final.heap.contents q=source.heap.contents q := by
  unfold StableBinaryCExec.copy at hs
  obtain ⟨words,hread,hwrite⟩ := Option.bind_eq_some_iff.mp hs
  have hlen : words.length=n :=
    StableBinaryCopyRefinement.read_copy_length scratch n source words hread
  exact write_copy_destination_frame dst 0 words source final q (by
    simpa [hlen] using hq) hwrite

theorem word_store_shape (source final : StableBinaryCExec.State)
    (a : Nat) (w : BitVec 64)
    (hs : StableBinaryCExec.store source a w=some final) :
    final.heap.length=source.heap.length ∧ final.heap.writable=source.heap.writable := by
  have owned : OwnedWriteRegion source.heap (ptr a) := by
    by_contra hn
    simp [StableBinaryCExec.store,wordWrite,hn] at hs
  have eqs : final={source with heap := B20.Word.LE.stored source.heap (ptr a) w} := by
    simpa [StableBinaryCExec.store,wordWrite,owned] using hs.symm
  subst final
  exact word_write_preserves_shape source.heap a w

theorem write_copy_shape (base index : Nat) (words : List (BitVec 64))
    (source final : StableBinaryCExec.State)
    (hs : StableBinaryCExec.writeCopy base index words source=some final) :
    final.heap.length=source.heap.length ∧ final.heap.writable=source.heap.writable := by
  induction words generalizing index source final with
  | nil =>
      have heq : source=final := Option.some.inj (by simpa [StableBinaryCExec.writeCopy] using hs)
      subst final
      exact ⟨rfl,rfl⟩
  | cons w rest ih =>
      have hsrc : (do
          let mid ← StableBinaryCExec.store source (StableBinary.addr base index) w
          StableBinaryCExec.writeCopy base (index+1) rest mid)=some final := by
        simpa [StableBinaryCExec.writeCopy] using hs
      obtain ⟨mid,hstore,hrest⟩ := Option.bind_eq_some_iff.mp hsrc
      have h0 := word_store_shape source mid (StableBinary.addr base index) w hstore
      have h1 := ih (index+1) mid final hrest
      exact ⟨h1.1.trans h0.1,h1.2.trans h0.2⟩

theorem copy_shape (dst scratch n : Nat) (source final : StableBinaryCExec.State)
    (hs : StableBinaryCExec.copy source dst scratch n=some final) :
    final.heap.length=source.heap.length ∧ final.heap.writable=source.heap.writable := by
  unfold StableBinaryCExec.copy at hs
  obtain ⟨words,_,hwrite⟩ := Option.bind_eq_some_iff.mp hs
  exact write_copy_shape dst 0 words source final hwrite

/- Extensional C99 memcpy contract for non-overlapping fpr arrays. `dst` and
   `scratch` are byte addresses; every one of the 8*n destination bytes
   equals its *pre-copy* source byte. No initial scratch value is required
   before the preceding source loop has filled it. -/
def RawMemcpyContract (before after : B20.C.Byte.Memory)
    (dst scratch n : Nat) : Prop :=
  (dst+8*n≤scratch ∨ scratch+8*n≤dst) ∧
  (∀ j<n, ∀ byte : Fin 8,
    after.contents ((ptr (StableBinary.addr dst j)).add byte.val) =
      before.contents ((ptr (StableBinary.addr scratch j)).add byte.val)) ∧
  (∀ q : Pointer, q.block≠0 ∨ q.offset<dst ∨ dst+8*n≤q.offset →
    after.contents q=before.contents q) ∧
  after.length=before.length ∧ after.writable=before.writable

theorem source_copy_is_byte_memcpy (l : StableBinary.Layout) (k start n : Nat)
    (source final : StableBinaryCExec.State)
    (hl : l.wellFormed k) (hbound : start+n≤l.length)
    (hs : StableBinaryCExec.copy source (StableBinary.addr l.values start)
      l.scratch n=some final) :
    RawMemcpyContract source.heap final.heap
      (StableBinary.addr l.values start) l.scratch n := by
  obtain ⟨_,_,_,_,_,_,_,_,hsep,_,_,_,_⟩ := hl
  have hdis : StableBinary.addr l.values start + 8*n≤l.scratch ∨
      l.scratch+8*n≤StableBinary.addr l.values start := by
    dsimp [StableBinary.addr]
    rcases hsep with hsep | hsep <;> omega
  refine ⟨hdis,?_,?_,(copy_shape _ _ _ _ _ hs).1,(copy_shape _ _ _ _ _ hs).2⟩
  · intro j hj byte
    exact bytewise_copy (StableBinary.addr l.values start) l.scratch n source final j byte hj hs
  · intro q hq
    exact copy_outside_destination (StableBinary.addr l.values start) l.scratch n
      source final q hq hs

end FT1536.Source3.StableBinaryMemcpySpec

#print axioms FT1536.Source3.StableBinaryMemcpySpec.byte_of_join
#print axioms FT1536.Source3.StableBinaryMemcpySpec.write_copy_destination_frame
#print axioms FT1536.Source3.StableBinaryMemcpySpec.write_copy_byte_at
#print axioms FT1536.Source3.StableBinaryMemcpySpec.bytewise_copy
#print axioms FT1536.Source3.StableBinaryMemcpySpec.copy_outside_destination
#print axioms FT1536.Source3.StableBinaryMemcpySpec.copy_shape
#print axioms FT1536.Source3.StableBinaryMemcpySpec.source_copy_is_byte_memcpy
