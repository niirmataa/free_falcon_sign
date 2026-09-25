import FT1536.AdversaryFold

-- Instance hygiene: `SigmaMath.nonceFintype` duplicates the canonical
-- `Fintype (Fin (2^320))`; one instance keeps `Law (Fin (2^320))` elaboration
-- consistent across all modules of this run.
attribute [-instance] FT1536.SigmaMath.nonceFintype


/-! # Fold invariants and the Hist-level extraction implication
(binding type `hist_extraction_implication`)

The machine-level extraction (`GameMach.verdict_fresh` +
`Reduction.indexed_extraction`) lifts to the event level of reply histories:

* `readPath` — fresh table reads along the run (H queries and the final read);
* `advance_used_le` / `stateAt_used` — `used` counts fresh reads and never
  exceeds `readPath`;
* `advance_good` / `stateAt_good` — the folded table maintains `ROM.Good`
  against the run target vector (Sign-programmed entries carry `target =
  none` with the message already in SeenSign; read entries carry
  `targets[used]` — exactly the inherited `ROM.hash_good`/`submit_good`);
* `isWin` / `isMT` — winning and extraction events on `Hist (Reply C)`,
  defined with full reply consistency (`finReply`), so histories that the
  machine cannot produce carry no win;
* `hist_extraction_implication` — a winning history extracts a
  `Relation.ShortPreimage` witness at an explicit target index `j < Q_H+1`
  (strictly stronger than `Win ∧ ¬Bad → MT`: the Bad conjunct is not needed).

All proofs complete. -/

namespace FT1536.FinalBind
open GameMach GameNames GameByte GameLaw AdversaryFold PathCounter ROM Divergence

variable {C : Type} [Fintype C] [DecidableEq C]

theorem hash_seen {CC : Type}
    (targets : ℕ → CC) (x : GameNames.NameBody × Message)
    (s : ROM.State GameNames.NameBody Message CC) :
    (ROM.hash targets x s).2.seen = s.seen := by
  unfold ROM.hash
  cases ROM.lookup x s <;> rfl

/-- Fresh table reads (H queries and the final read) along the run. -/
def readPath (A : Adv C) : (k : ℕ) → Hist (Reply C) k → ℕ
  | 0, _ => 0
  | k+1, x => readPath A k x.1 + (match A k x.1 with | .sq _ => 0 | _ => 1)

-- Each step keeps `used` within the number of fresh reads so far.
omit [Fintype C] [DecidableEq C] in
lemma advance_used_le (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (op : Op) (ρ : Reply C) :
    (advance targets verdict m op ρ).st.used
      ≤ m.st.used + (match op with | .sq _ => 0 | _ => 1) := by
  unfold advance
  by_cases hcond : (m.stopped || m.over) = true
  · simp [hcond]
  · have hn : ¬(m.stopped || m.over) := by
      cases h : (m.stopped || m.over) <;> simp_all
    simp [hn]
    cases op with
    | hq k => exact ROM.hash_used_le targets (tableAddr (render k)) m.st
    | fin r msg sg => exact ROM.hash_used_le targets (tableAddr (signName r msg)) m.st
    | sq msg =>
      cases ρ with
      | sign c o =>
        cases o with
        | some pr =>
          by_cases hl : ROM.lookup (tableAddr (signName pr.1 msg)) (ROM.submit msg m.st) = none
          · simp [hl]
            exact le_rfl
          · simp [hl]
            exact le_rfl
        | none => exact le_rfl
      | hval _ => exact le_rfl
      | verdict _ _ => exact le_rfl
      | halt => exact le_rfl

omit [Fintype C] [DecidableEq C] in
lemma stateAt_used (A : Adv C) (targets : ℕ → C) (verdict : Verdict C) :
    ∀ (k : ℕ) (x : Hist (Reply C) k),
      (stateAt A targets verdict k x).st.used ≤ readPath A k x
  | 0, _ => Nat.zero_le _
  | k+1, x => by
    have ih := stateAt_used A targets verdict k x.1
    have hstep := advance_used_le targets verdict
      (stateAt A targets verdict k x.1) (A k x.1) x.2
    exact le_trans hstep (Nat.add_le_add_right ih _)

-- The folded table maintains `ROM.Good` against the run target vector.
omit [Fintype C] [DecidableEq C] in
lemma advance_good (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (op : Op) (ρ : Reply C) (hg : Good targets m.st) :
    Good targets (advance targets verdict m op ρ).st := by
  unfold advance
  by_cases hcond : (m.stopped || m.over) = true
  · simp [hcond]
    exact hg
  · have hn : ¬(m.stopped || m.over) := by
      cases h : (m.stopped || m.over) <;> simp_all
    simp [hn]
    cases op with
    | hq k => exact ROM.hash_good targets (tableAddr (render k)) m.st hg
    | fin r msg sg => exact ROM.hash_good targets (tableAddr (signName r msg)) m.st hg
    | sq msg =>
      have hsub : Good targets (ROM.submit msg m.st) := ROM.submit_good targets msg m.st hg
      cases ρ with
      | sign c o =>
        cases o with
        | some pr =>
          have hmem : (tableAddr (signName pr.1 msg)).2 ∈ (ROM.submit msg m.st).seen := by
            rw [GameNames.tableAddr_sign pr.1 msg]
            exact ROM.submitted_even_on_abort msg m.st
          by_cases hl : ROM.lookup (tableAddr (signName pr.1 msg)) (ROM.submit msg m.st) = none
          · simp [hl]
            intro e he
            rcases List.mem_cons.mp he with rfl | he
            · show (tableAddr (signName pr.1 msg)).2 ∈ (ROM.submit msg m.st).seen
              exact hmem
            · exact hsub e he
          · simp [hl]
            exact hsub
        | none => exact hsub
      | hval _ => exact hsub
      | verdict _ _ => exact hsub
      | halt => exact hsub

omit [Fintype C] [DecidableEq C] in
lemma stateAt_good (A : Adv C) (targets : ℕ → C) (verdict : Verdict C) :
    ∀ (k : ℕ) (x : Hist (Reply C) k), Good targets (stateAt A targets verdict k x).st
  | 0, _ => ROM.empty_good targets
  | k+1, x => advance_good targets verdict (stateAt A targets verdict k x.1)
      (A k x.1) x.2 (stateAt_good A targets verdict k x.1)

/-! ## Events on reply histories -/

/-- The winning event: some step issues a final operation and the machine
produces its positive final reply (full reply consistency). -/
def isWin (A : Adv C) (targets : ℕ → C) (verdict : Verdict C) :
    (k : ℕ) → Hist (Reply C) k → Prop
  | 0, _ => False
  | k+1, x =>
      (∃ r msg sg, A k x.1 = Op.fin r msg sg ∧
        x.2 = finReply targets verdict (stateAt A targets verdict k x.1) r msg sg ∧
        (decide (msg ∉ (ROM.hash targets (tableAddr (signName r msg))
            (stateAt A targets verdict k x.1).st).2.seen) &&
          verdict (ROM.hash targets (tableAddr (signName r msg))
            (stateAt A targets verdict k x.1).st).1 msg (sigVec sg)) = true)
      ∨ isWin A targets verdict k x.1

/-- The extraction event: some winning step extracts a short-preimage witness
at an explicit target index below `Q_H+1`. -/
def isMT (A : Adv Relation.Rq) (h : Relation.Rq) (targets : ℕ → Relation.Rq)
    (verdict : Verdict Relation.Rq) (QH : ℕ) :
    (k : ℕ) → Hist (Reply Relation.Rq) k → Prop
  | 0, _ => False
  | k+1, x =>
      (∃ r msg sg, A k x.1 = Op.fin r msg sg ∧
        x.2 = finReply targets verdict (stateAt A targets verdict k x.1) r msg sg ∧
        (decide (msg ∉ (ROM.hash targets (tableAddr (signName r msg))
            (stateAt A targets verdict k x.1).st).2.seen) &&
          verdict (ROM.hash targets (tableAddr (signName r msg))
            (stateAt A targets verdict k x.1).st).1 msg (sigVec sg)) = true ∧
        ∃ j, j < QH + 1 ∧
          Relation.ShortPreimage h (targets j)
            (Relation.extract h (ROM.hash targets (tableAddr (signName r msg))
              (stateAt A targets verdict k x.1).st).1 (sigVec sg)))
      ∨ isMT A h targets verdict QH k x.1

/-- **Hist-level extraction implication.** A winning reply history extracts a
`Relation.ShortPreimage` witness at some target index below `Q_H+1` — the
event-level form of `Win ∧ ¬Bad → MT` (strictly stronger: the Bad conjunct is
not needed). -/
theorem hist_extraction_implication
    (A : Adv Relation.Rq) (h : Relation.Rq) (targets : ℕ → Relation.Rq)
    (verdict : Verdict Relation.Rq)
    (hverdict : ∀ c msg sig, verdict c msg (sigVec sig) = true ↔
      Relation.Verify h c (sigVec sig))
    (QH : ℕ)
    (hreads : ∀ k (x : Hist (Reply Relation.Rq) k), readPath A k x ≤ QH) :
    ∀ (k : ℕ) (x : Hist (Reply Relation.Rq) k),
      isWin A targets verdict k x → isMT A h targets verdict QH k x
  | 0, _, hwin => hwin
  | k+1, x, hwin => by
    rcases hwin with hex | hind
    · obtain ⟨r, msg, sg, hop, hrep, hflag⟩ := hex
      refine Or.inl ⟨r, msg, sg, hop, hrep, hflag, ?_⟩
      have hsplit : (decide (msg ∉ (ROM.hash targets (tableAddr (signName r msg))
              (stateAt A targets verdict k x.1).st).2.seen)) = true ∧
          (verdict (ROM.hash targets (tableAddr (signName r msg))
              (stateAt A targets verdict k x.1).st).1 msg (sigVec sg)) = true := by
        cases hd : (decide (msg ∉ (ROM.hash targets (tableAddr (signName r msg))
            (stateAt A targets verdict k x.1).st).2.seen)) with
        | true =>
          cases hv' : (verdict (ROM.hash targets (tableAddr (signName r msg))
              (stateAt A targets verdict k x.1).st).1 msg (sigVec sg)) with
          | true => exact ⟨rfl, rfl⟩
          | false => simp [hd, hv'] at hflag
        | false => simp [hd] at hflag
      have hfresh : msg ∉ (ROM.hash targets (tableAddr (signName r msg))
          (stateAt A targets verdict k x.1).st).2.seen :=
        of_decide_eq_true hsplit.1
      have hver : verdict (ROM.hash targets (tableAddr (signName r msg))
          (stateAt A targets verdict k x.1).st).1 msg (sigVec sg) = true := hsplit.2
      have hv : Relation.Verify h
          (ROM.hash targets (tableAddr (signName r msg))
            (stateAt A targets verdict k x.1).st).1 (sigVec sg) :=
        (hverdict _ _ _).1 hver
      have hg : Good targets (stateAt A targets verdict k x.1).st :=
        stateAt_good A targets verdict k x.1
      have hu : (stateAt A targets verdict k x.1).st.used ≤ QH :=
        le_trans (stateAt_used A targets verdict k x.1) (hreads k x.1)
      have hx2 : (tableAddr (signName r msg)).2 = msg := by
        rw [GameNames.tableAddr_sign r msg]
      have hne : (tableAddr (signName r msg)).2 ∉
          (stateAt A targets verdict k x.1).st.seen := by
        rw [hx2, ← hash_seen targets (tableAddr (signName r msg))
          (stateAt A targets verdict k x.1).st]
        exact hfresh
      obtain ⟨j, hj, hpre⟩ := Reduction.indexed_extraction targets h
        (stateAt A targets verdict k x.1).st (tableAddr (signName r msg))
        (sigVec sg) QH hg hne hu hv
      exact ⟨j, hj, hpre⟩
    · exact Or.inr (hist_extraction_implication A h targets verdict hverdict QH
        hreads k x.1 hind)

end FT1536.FinalBind
