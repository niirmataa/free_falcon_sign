import Source3.C99MemoryReference
import Source3.KeygenHelpers
import Mathlib.Tactic.NormNum

/- Direct natural semantics of poly_big_to_small in the fixed M0 profile.
   Every iteration loads the actual source word, executes the sign-extension
   and the two source guards, and writes two bytes only on the accepted edge.
   This local result does not assume or prove the preceding solver's success. -/
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenSmallOutput
open C99MemoryReference

def element (p : ArrayPointer) (i : Nat) : ArrayPointer := {p with index := p.index+i}
def plain (w : BitVec 32) : ℤ := (w ||| ((w &&& 0x40000000#32) <<< 1)).toInt
def accepted (z : ℤ) : Prop := ¬(z < -2047 ∨ z > 2047)
def byte16 (w : BitVec 16) (i : Fin 2) : Byte := (w >>> (8*i.val)).setWidth 8

def Stored (h : Memory) (p : ArrayPointer) (w : BitVec 16) : Prop :=
  ∀ i : Fin 2, h.bytes p.block (p.offset+i.val)=some (byte16 w i)

def Store16 (before : Memory) (p : ArrayPointer) (w : BitVec 16) (after : Memory) : Prop :=
  Allocated before p ∧ p.elementBytes=2 ∧ before.writable p.block=true ∧
  after.size=before.size ∧ after.writable=before.writable ∧ Stored after p w ∧
  (∀ block offset, block≠p.block ∨ offset<p.offset ∨ p.offset+2≤offset →
    after.bytes block offset=before.bytes block offset)

inductive Loop (dst src : ArrayPointer) : Nat → Memory → Memory → Bool → Prop where
  | done (i : Nat) (h : Memory) (guard : ¬i<1536) : Loop dst src i h h true
  | rejected (i : Nat) (h : Memory) (w : BitVec 32) (guard : i<1536)
      (load : Load32 h (element src i) w) (test : ¬accepted (plain w)) : Loop dst src i h h false
  | next (i : Nat) (before middle after : Memory) (w : BitVec 32) (ret : Bool)
      (guard : i<1536) (load : Load32 before (element src i) w)
      (test : accepted (plain w))
      (write : Store16 before (element dst i) (BitVec.ofInt 16 (plain w)) middle)
      (rest : Loop dst src (i+1) middle after ret) : Loop dst src i before after ret

theorem source_plain : (Pinned.keygenLines.drop 4429).take 9 =
    ["static inline int32_t\n","zint_one_to_plain(const uint32_t *x)\n","{\n",
     "\tuint32_t w;\n","\n","\tw = x[0];\n","\tw |= (w & 0x40000000) << 1;\n",
     "\treturn *(int32_t *)&w;\n","}\n"] := by decide

theorem source_body : (Pinned.keygenLines.drop 4491).take 17 =
    ["static int\n","poly_big_to_small(int16_t *d, const uint32_t *s, unsigned logn, unsigned ter)\n",
     "{\n","\tsize_t n, u;\n","\n","\tn = MKN(logn, ter);\n",
     "\tfor (u = 0; u < n; u ++) {\n","\t\tint32_t z;\n","\n",
     "\t\tz = zint_one_to_plain(s + u);\n","\t\tif (z < -2047 || z > 2047) {\n",
     "\t\t\treturn 0;\n","\t\t}\n","\t\td[u] = (int16_t)z;\n",
     "\t}\n","\treturn 1;\n","}\n"] := by decide

theorem accepted_bounds (z : ℤ) (h : accepted z) : -2047≤z ∧ z≤2047 := by
  dsimp [accepted] at h
  omega

theorem narrowed_exact (z : ℤ) (h : accepted z) : (BitVec.ofInt 16 z).toInt=z := by
  have hz := accepted_bounds z h
  exact BitVec.toInt_ofInt_eq_self (by decide) (by norm_num; omega) (by norm_num; omega)

theorem loop_metadata (dst src : ArrayPointer) (i : Nat) (before after : Memory) (ret : Bool)
    (h : Loop dst src i before after ret) : after.size=before.size ∧ after.writable=before.writable := by
  induction h with
  | done => exact ⟨rfl,rfl⟩
  | rejected => exact ⟨rfl,rfl⟩
  | next _ _ _ _ _ _ _ _ _ write _ ih =>
    exact ⟨ih.1.trans write.2.2.2.1,ih.2.trans write.2.2.2.2.1⟩

theorem earlier_bytes (dst src : ArrayPointer) (i : Nat) (before after : Memory) (ret : Bool)
    (h : Loop dst src i before after ret) (hd : dst.elementBytes=2)
    (j : Nat) (hj : j < i) (b : Fin 2) :
    after.bytes dst.block ((element dst j).offset+b.val)=before.bytes dst.block ((element dst j).offset+b.val) := by
  induction h with
  | done => rfl
  | rejected => rfl
  | next i before middle after w ret guard load test write rest ih =>
    have ht := ih (by omega)
    have hf := write.2.2.2.2.2.2 dst.block ((element dst j).offset+b.val) (Or.inr (Or.inl (by
      have hb := b.isLt
      dsimp [element,ArrayPointer.offset] at *
      rw [hd]
      omega)))
    exact ht.trans hf

theorem success_bound_bytes (dst src : ArrayPointer) (i : Nat) (before after : Memory)
    (h : Loop dst src i before after true) (hd : dst.elementBytes=2) :
    ∀ j, i≤j → j<1536 → ∃ z : ℤ,
      -2047≤z ∧ z≤2047 ∧ Stored after (element dst j) (BitVec.ofInt 16 z) ∧
      (BitVec.ofInt 16 z).toInt=z := by
  generalize hr : true=ret at h
  induction h with
  | done i h guard => intro j hij hj; omega
  | rejected i h w guard load test => cases hr
  | next i before middle after w ret guard load test write rest ih =>
    intro j hij hj
    by_cases he : j=i
    · subst j
      obtain ⟨hlo,hhi⟩ := accepted_bounds (plain w) test
      refine ⟨plain w,hlo,hhi,?_,narrowed_exact _ test⟩
      intro b
      have hf := earlier_bytes dst src (i+1) middle after ret rest hd i (by omega) b
      exact hf.trans (write.2.2.2.2.2.1 b)
    · exact ih hr j (by omega) hj

theorem output_range (dst src : ArrayPointer) (before after : Memory)
    (source : Loop dst src 0 before after true) (hd : dst.elementBytes=2) :
    ∀ j : Fin 1536, ∃ z : ℤ,
      -2047≤z ∧ z≤2047 ∧ Stored after (element dst j.val) (BitVec.ofInt 16 z) ∧
      (BitVec.ofInt 16 z).toInt=z := by
  intro j
  exact success_bound_bytes dst src 0 before after source hd j.val (Nat.zero_le _) j.isLt

end FT1536.Source3.KeygenSmallOutput
