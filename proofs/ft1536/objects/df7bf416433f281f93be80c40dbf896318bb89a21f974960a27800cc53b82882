import Source3.C99NarrowReads
import Source3.FprPrefixCalls
import Source3.C99InitializationTrace

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The M0 conversion loop reads actual signed16 objects and executes the
   fixed fpr_of source closure. Its memory/initialization contract is local;
   full certificate call/layout/control refinement is a separate obligation. -/
namespace FT1536.Source3.SmallintsConversion
open C99MemoryReference C99NarrowReads C99InitializationTrace
open KeygenSmallOutput (element)

theorem source_body : (Pinned.keygenLines.drop 7428).take 9 =
    ["static void\n",
     "smallints_to_fpr_keygen(fpr *r, const int16_t *t, unsigned logn, unsigned ter)\n",
     "{\n","\tsize_t n, u;\n","\tn = MKN(logn, ter);\n",
     "\tfor (u = 0; u < n; u ++) {\n","\t\tr[u] = fpr_of(t[u]);\n","\t}\n","}\n"] := by decide

inductive Loop (dst src : ArrayPointer) : Nat → Memory → Memory → Prop where
  | done (i : Nat) (h : Memory) (guard : ¬i<1536) : Loop dst src i h h
  | next (i : Nat) (before middle after : Memory) (w : BitVec 16) (z : BitVec 64)
      (guard : i<1536) (read : Load16 before (element src i) w)
      (conversion : FprPrefixCalls.calls "fpr_of".toList [signedPromotion w] (.uint64 z))
      (write : Store64 before (element dst i) z middle)
      (rest : Loop dst src (i+1) middle after) : Loop dst src i before after

theorem memory_steps (dst src : ArrayPointer) (i : Nat) (before after : Memory)
    (source : Loop dst src i before after) : Steps before after := by
  induction source with
  | done => exact .done _
  | next i before middle after w z guard read conversion write rest ih =>
      exact .write64 before middle after (element dst i) z write ih

theorem frame (dst src : ArrayPointer) (i : Nat) (before after : Memory)
    (source : Loop dst src i before after) (block offset : Nat)
    (outside : block≠dst.block ∨ offset<dst.offset ∨ dst.base+dst.elementBytes*dst.count≤offset) :
    after.bytes block offset=before.bytes block offset := by
  induction source with
  | done => rfl
  | next i before middle after w z guard read conversion write rest ih =>
      have hi := write.1.2.2.1
      change dst.index+i<dst.count at hi
      have hs := write.2.1
      have hlo : dst.elementBytes*dst.index≤dst.elementBytes*(dst.index+i) :=
        Nat.mul_le_mul_left dst.elementBytes (by omega)
      have hhi : dst.elementBytes*(dst.index+i+1)≤dst.elementBytes*dst.count :=
        Nat.mul_le_mul_left dst.elementBytes (by omega)
      have hf := write.2.2.2.2.2.2 block offset (by
        dsimp [element,ArrayPointer.offset] at *
        rw [Nat.mul_add,Nat.mul_one] at hhi
        omega)
      exact ih.trans hf

theorem earlier_bytes (dst src : ArrayPointer) (i : Nat) (before after : Memory)
    (source : Loop dst src i before after) (width : dst.elementBytes=8)
    (j : Nat) (hj : j < i) (b : Fin 8) :
    after.bytes dst.block ((element dst j).offset+b.val)=before.bytes dst.block ((element dst j).offset+b.val) := by
  induction source with
  | done => rfl
  | next i before middle after w z guard read conversion write rest ih =>
      have hf := write.2.2.2.2.2.2 dst.block ((element dst j).offset+b.val) (Or.inr (Or.inl (by
        have hb := b.isLt
        dsimp [element,ArrayPointer.offset]
        rw [width]
        omega)))
      exact (ih (by omega)).trans hf

theorem initialized_elements (dst src : ArrayPointer) (i : Nat) (before after : Memory)
    (source : Loop dst src i before after) (width : dst.elementBytes=8) :
    ∀ j, i≤j → j<1536 → ∀ b : Fin 8, (after.bytes dst.block ((element dst j).offset+b.val)).isSome := by
  induction source with
  | done i h guard => intro j hj hn; omega
  | next i before middle after w z guard read conversion write rest ih =>
      intro j hj hn b
      by_cases he : j=i
      · subst j
        rw [earlier_bytes dst src (i+1) middle after rest width i (by omega) b]
        have hw := write.2.2.2.2.2.1 b
        change middle.bytes dst.block ((element dst i).offset+b.val)=some (byte64 z b) at hw
        rw [hw]
        rfl
      · exact ih j (by omega) hn b

theorem output_initialized (dst src : ArrayPointer) (before after : Memory)
    (source : Loop dst src 0 before after) (width : dst.elementBytes=8) :
    Initialized after dst.block dst.offset 12288 := by
  intro k hk
  let b : Fin 8 := ⟨k%8,by omega⟩
  have h := initialized_elements dst src 0 before after source width (k/8) (Nat.zero_le _) (by omega) b
  have he : (element dst (k/8)).offset+b.val=dst.offset+k := by
    dsimp [element,ArrayPointer.offset,b]
    rw [width,Nat.mul_add]
    omega
  rw [he] at h
  exact h

end FT1536.Source3.SmallintsConversion
