import Source3.Gate00Scalar
import Source3.CertificateMemory

/- Byte-memory Gate00, including the separate source reads, RMW bad and
   actual root store. The word trace records one positive/half-check pair
   per iteration in newest-first order. Full-prefix entry is not assumed
   here to have been proved: the enclosing function must supply this call. -/
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.Gate00Memory
open C99MemoryReference CertificateMemory

def rootPtr (l : Layout) (i : Nat) : ArrayPointer := ⟨0,l.g00,768,8,i⟩

theorem load32_deterministic (h : Memory) (p : ArrayPointer) (x y : BitVec 32)
    (hx : Load32 h p x) (hy : Load32 h p y) : x=y := by
  cases hx with
  | load b ha ht hb =>
    cases hy with
    | load c hc hs hd =>
      have he : b=c := by
        funext i
        exact Option.some.inj ((hb i).symm.trans (hd i))
      rw [he]

theorem load32_transport (before after : Memory) (p : ArrayPointer) (w : BitVec 32)
    (h : Load32 before p w) (hs : after.size=before.size)
    (hb : ∀ i : Fin 4, after.bytes p.block (p.offset+i.val)=before.bytes p.block (p.offset+i.val)) :
    Load32 after p w := by
  cases h with
  | load bytes ha ht hi =>
    apply Load32.load after p bytes
    · simpa only [Allocated,hs] using ha
    · exact ht
    · intro i
      exact (hb i).trans (hi i)

theorem stored32_load (before after : Memory) (p : ArrayPointer) (w : BitVec 32)
    (h : Store32 before p w after) : Load32 after p w := by
  have he : le32 (byte32 w)=w := StableBinaryByteView.flag_join_bytes w
  rw [← he]
  apply Load32.load after p (byte32 w)
  · simpa only [Allocated,h.2.2.2.1] using h.1
  · exact h.2.1
  · exact h.2.2.2.2.2.1

inductive Step (l : Layout) (i : Nat) (before : Memory) : Memory → BitVec 64 → Prop where
  | step (middle after : Memory) (w z : BitVec 64) (old flag : BitVec 32)
      (guard : i<768)
      (positiveRead : Load64 before (rootPtr l i) w)
      (compareRead : Load64 before (rootPtr l i) w)
      (badRead : Load32 before (badPtr l) old)
      (scalar : Gate00Scalar.Exec w old z flag)
      (badWrite : Store32 before (badPtr l) flag middle)
      (bitsRead : Load64 middle (rootPtr l i) w)
      (rootWrite : Store64 middle (rootPtr l i) z after) : Step l i before after w

theorem step_post_flag (l : Layout) (hl : WellFormed l) (i : Nat) (before middle after : Memory)
    (w : BitVec 64) (flag : BitVec 32) (hi : i<768)
    (hb : Store32 before (badPtr l) flag middle)
    (hw : Store64 middle (rootPtr l i) w after) : Load32 after (badPtr l) flag := by
  apply load32_transport middle after (badPtr l) flag (stored32_load before middle _ flag hb) hw.2.2.2.1
  intro b
  apply hw.2.2.2.2.2.2
  have hs := hl.rootsBad
  have hbyte := b.isLt
  dsimp [StableTopMemory.Separate,rootPtr,badPtr,ArrayPointer.offset] at *
  omega

theorem step_clear (l : Layout) (hl : WellFormed l) (i : Nat) (before after : Memory) (w : BitVec 64)
    (step : Step l i before after w) (clear : Load32 after (badPtr l) 0) :
    Load32 before (badPtr l) 0 ∧ RootGate00.allowed w ∧
    (∀ b : Fin 8, after.bytes 0 ((rootPtr l i).offset+b.val)=some (byte64 w b)) := by
  cases step with
  | step middle _ _ z old flag hi hp hc hb hs hw hr hz =>
    have hf : flag=0 := load32_deterministic after (badPtr l) flag 0
      (step_post_flag l hl i before middle after z flag hi hw hz) clear
    have he := Gate00Scalar.exact_result w old z flag hs
    have hzero : (RootGate00.step w old).2=0 := by rw [← he,hf]
    obtain ⟨hold,allowed⟩ := (RootGate00.step_clear w old).mp hzero
    have hword : z=w := by
      have he' := congrArg Prod.fst he
      rw [RootGate00.step_cases,ite_eq_left allowed] at he'
      exact he'
    refine ⟨by change Load32 before (badPtr l) 0#32; rw [← hold]; exact hb,allowed,?_⟩
    simpa only [hword,rootPtr] using hz.2.2.2.2.2.1

inductive Loop (l : Layout) : Nat → Memory → Memory → List (BitVec 64) → Prop where
  | done (i : Nat) (h : Memory) (guard : ¬i<768) : Loop l i h h []
  | next (i : Nat) (before middle after : Memory) (w : BitVec 64) (tail : List (BitVec 64))
      (guard : i<768) (step : Step l i before middle w)
      (rest : Loop l (i+1) middle after tail) : Loop l i before after (tail++[w])

theorem loop_count (l : Layout) (i : Nat) (before after : Memory) (trace : List (BitVec 64))
    (h : Loop l i before after trace) (hi : i≤768) : trace.length=768-i := by
  induction h with
  | done i h hg => simp only [List.length_nil]; omega
  | next i before middle after w tail hg hs hr ih =>
    have ht := ih (by omega)
    simp only [List.length_append,List.length_singleton]
    omega

theorem step_frame (l : Layout) (i : Nat) (before after : Memory) (w : BitVec 64)
    (h : Step l i before after w) (block offset : Nat)
    (hroot : block≠0 ∨ offset<(rootPtr l i).offset ∨ (rootPtr l i).offset+8≤offset)
    (hbad : block≠0 ∨ offset<l.bad ∨ l.bad+4≤offset) :
    after.bytes block offset=before.bytes block offset := by
  cases h with
  | step middle _ _ z old flag hi hp hc hb hs hw hr hz =>
    have ha := hz.2.2.2.2.2.2 block offset hroot
    have hb := hw.2.2.2.2.2.2 block offset (by simpa [badPtr,ArrayPointer.offset] using hbad)
    exact ha.trans hb

theorem earlier_root_bytes (l : Layout) (hl : WellFormed l) (i : Nat) (before after : Memory)
    (trace : List (BitVec 64)) (h : Loop l i before after trace) (j : Nat) (hj : j < i)
    (hjmax : j<768) (b : Fin 8) :
    after.bytes 0 ((rootPtr l j).offset+b.val)=before.bytes 0 ((rootPtr l j).offset+b.val) := by
  induction h with
  | done => rfl
  | next i before middle after w tail hg hs hr ih =>
    have ht := ih (by omega)
    have hf := step_frame l i before middle w hs 0 ((rootPtr l j).offset+b.val) ?_ ?_
    · exact ht.trans hf
    · have hb := b.isLt
      dsimp [rootPtr,ArrayPointer.offset]
      omega
    · have sep := hl.rootsBad
      have hb := b.isLt
      dsimp [rootPtr,ArrayPointer.offset,StableTopMemory.Separate] at *
      omega

theorem accepted_checks (l : Layout) (hl : WellFormed l) (i : Nat) (before after : Memory)
    (trace : List (BitVec 64)) (h : Loop l i before after trace)
    (clear : Load32 after (badPtr l) 0) :
    Load32 before (badPtr l) 0 ∧ ∀ w∈trace, RootGate00.allowed w := by
  induction h with
  | done => exact ⟨clear,by simp⟩
  | next i before middle after w tail hg hs hr ih =>
    obtain ⟨hc,ht⟩ := ih clear
    obtain ⟨hb,hw,_⟩ := step_clear l hl i before middle w hs hc
    refine ⟨hb,?_⟩
    intro x hx
    rcases List.mem_append.mp hx with hx | hx
    · exact ht x hx
    · have he : x=w := by simpa using hx
      subst x
      exact hw

theorem accepted_words (l : Layout) (hl : WellFormed l) (i : Nat) (before after : Memory)
    (trace : List (BitVec 64)) (h : Loop l i before after trace)
    (clear : Load32 after (badPtr l) 0) :
    ∀ j, i≤j → j<768 → ∃ w∈trace, RootGate00.allowed w ∧
      ∀ b : Fin 8, after.bytes 0 ((rootPtr l j).offset+b.val)=some (byte64 w b) := by
  induction h with
  | done i h hg => intro j hij hj; omega
  | next i before middle after w tail hg hs hr ih =>
    have midclear := (accepted_checks l hl (i+1) middle after tail hr clear).1
    obtain ⟨_,allowed,stored⟩ := step_clear l hl i before middle w hs midclear
    intro j hij hj
    by_cases he : j=i
    · subst j
      refine ⟨w,List.mem_append.mpr (Or.inr (by simp)),allowed,?_⟩
      intro b
      exact (earlier_root_bytes l hl (i+1) middle after tail hr i (by omega) hj b).trans (stored b)
    · obtain ⟨z,hz,hgood,hbytes⟩ := ih clear j (by omega) hj
      exact ⟨z,List.mem_append.mpr (Or.inl hz),hgood,hbytes⟩

theorem source_checks_768 (l : Layout) (hl : WellFormed l) (before after : Memory)
    (trace : List (BitVec 64)) (h : Loop l 0 before after trace)
    (clear : Load32 after (badPtr l) 0) :
    trace.length=768 ∧ Load32 before (badPtr l) 0 ∧
      ∀ w∈trace, Run2.KeygenLeafGate.positive w=true ∧
        (1/2 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue w := by
  obtain ⟨hb,hgood⟩ := accepted_checks l hl 0 before after trace h clear
  refine ⟨loop_count l 0 before after trace h (by decide),hb,?_⟩
  intro w hw
  exact ⟨(hgood w hw).1,RootGate00.allowed_real_lower w (hgood w hw)⟩

end FT1536.Source3.Gate00Memory
