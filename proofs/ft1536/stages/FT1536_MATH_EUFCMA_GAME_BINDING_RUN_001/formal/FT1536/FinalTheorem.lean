import FT1536.FinalBind

-- Instance hygiene: `SigmaMath.nonceFintype` duplicates the canonical
-- `Fintype (Fin (2^320))`; keeping one instance makes `Law (Fin (2^320))`
-- applications elaborate identically to the pinned kernel lemmas.
attribute [-instance] FT1536.SigmaMath.nonceFintype

/-! # Conflict chain and the end-to-end assembled theorem
(binding type `end_to_end_assembled_theorem_statement`)

The collision term is derived, not assumed: at the `k`-th Sign query the
table holds at most `Q_H + k` names (`stateAt_table`), the salt frame
`r ↦ tableAddr (signName r msg)` is injective (`sign_frame_injective`), so
the per-history collision probability is at most `(Q_H+k)/2^320`
(`sign_conflict_risk`); averaging over histories (`badAt_bound`) and summing
(`isBad_bound`) gives exactly

    eps_coll = min 1 ((Q_s·Q_H + Q_s·(Q_s−1)/2) / 2^320)

through the inherited `accumulated_conflicts`/`collision_sum`. The final
The final statement composes: the fold binding (`adversary_fold_paid_flag_binding`),
the Hist-level extraction (`FinalBind.hist_extraction_implication`), the
event transfer, the derived conflict term and the MT-IPS hardness
substitution. All proofs complete. -/

namespace FT1536.FinalTheorem
open GameMach GameNames GameByte GameLaw AdversaryFold PathCounter PaidSteps
  FinalBind ROM Divergence Finset

variable {C : Type} [Fintype C] [DecidableEq C]

-- Events that depend only on the prefix are unchanged by extending the history.
omit [DecidableEq C] in
lemma event_prefix (p : (n : ℕ) → Hist (Reply C) n → Law (Reply C)) (n : ℕ)
    (Q : Hist (Reply C) n → Prop) [DecidablePred Q] :
    (transcript p (n+1)).event (fun x => Q x.1) = (transcript p n).event Q := by
  show (∑ x : Hist (Reply C) (n+1),
      if Q x.1 then (transcript p (n+1)).mass x else 0) = _
  have hmass : ∀ x : Hist (Reply C) (n+1),
      (transcript p (n+1)).mass x = (transcript p n).mass x.1 * (p n x.1).mass x.2 := by
    intro x
    rcases x with ⟨u, a⟩
    rfl
  rw [Fintype.sum_prod_type]
  have h1 : (∑ u : Hist (Reply C) n, ∑ a : Reply C,
      if Q u then (transcript p (n+1)).mass (u, a) else 0)
      = ∑ u : Hist (Reply C) n, ∑ a : Reply C,
          if Q u then (transcript p n).mass u * (p n u).mass a else 0 := by
    refine Finset.sum_congr rfl ?_
    intro u _
    refine Finset.sum_congr rfl ?_
    intro a _
    rw [hmass]
  rw [h1]
  have h2 : (∑ u : Hist (Reply C) n, ∑ a : Reply C,
      if Q u then (transcript p n).mass u * (p n u).mass a else 0)
      = ∑ u : Hist (Reply C) n, if Q u then (transcript p n).mass u else 0 := by
    refine Finset.sum_congr rfl ?_
    intro u _
    by_cases hq : Q u
    · simp [hq]
      rw [← Finset.mul_sum, (p n u).total]
      simp
    · simp [hq]
  rw [h2]
  rfl

/-- Table-length helper for `ROM.hash`. -/
theorem hash_table_len {CC : Type} (targets : ℕ → CC) (x : GameNames.NameBody × Message)
    (s : ROM.State GameNames.NameBody Message CC) :
    (ROM.hash targets x s).2.table.length ≤ s.table.length + 1 := by
  unfold ROM.hash
  cases ROM.lookup x s <;> simp

/-- The collision event at one Sign step: the fresh salt hits an existing
Sign-name in a still-running machine (absorbing halts after an earlier
collision are not new collisions). -/
def badAt (A : Adv C) (targets : ℕ → C) (verdict : Verdict C)
    (k : ℕ) (x : Hist (Reply C) (k+1)) : Prop :=
  paidAt A k x.1 = true ∧ x.2 = Reply.halt ∧
    ¬((stateAt A targets verdict k x.1).stopped
      || (stateAt A targets verdict k x.1).over)
/-- The conflict event along the run. -/
def isBad (A : Adv C) (targets : ℕ → C) (verdict : Verdict C) :
    (k : ℕ) → Hist (Reply C) k → Prop
  | 0, _ => False
  | k+1, x => badAt A targets verdict k x ∨ isBad A targets verdict k x.1

-- Table entries never exceed the number of steps taken.
omit [Fintype C] [DecidableEq C] in
lemma advance_table_len (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (op : Op) (ρ : Reply C) :
    (advance targets verdict m op ρ).st.table.length ≤ m.st.table.length + 1 := by
  unfold advance
  by_cases hcond : (m.stopped || m.over) = true
  · simp [hcond]
  · have hn : ¬(m.stopped || m.over) := by
      cases h : (m.stopped || m.over) <;> simp_all
    simp [hn]
    cases op with
    | hq k => exact hash_table_len targets (tableAddr (render k)) m.st
    | fin r msg sg => exact hash_table_len targets (tableAddr (signName r msg)) m.st
    | sq msg =>
      cases ρ with
      | sign c o =>
        cases o with
        | some pr =>
          by_cases hl : ROM.lookup (tableAddr (signName pr.1 msg)) (ROM.submit msg m.st) = none
          · simp [hl]
            exact le_rfl
          · simp [hl]
            exact Nat.le_succ _
        | none => exact Nat.le_succ _
      | hval _ => exact Nat.le_succ _
      | verdict _ _ => exact Nat.le_succ _
      | halt => exact Nat.le_succ _

omit [Fintype C] [DecidableEq C] in
lemma stateAt_table_len (A : Adv C) (targets : ℕ → C) (verdict : Verdict C) :
    ∀ (k : ℕ) (x : Hist (Reply C) k),
      (stateAt A targets verdict k x).st.table.length ≤ k
  | 0, _ => Nat.zero_le _
  | k+1, x => by
    have ih := stateAt_table_len A targets verdict k x.1
    have hstep := advance_table_len targets verdict
      (stateAt A targets verdict k x.1) (A k x.1) x.2
    exact le_trans hstep (by omega)

/-- Per-history collision bound at one Sign step of a running machine: the
stopped kernel's halt mass is at most `(Q_H + k)/2^320` (the salt frame is
injective and the table holds at most `K` names). -/
theorem kernelOf_halt_mass
    (cert : LocalCert C) (A : Adv C) (targets : ℕ → C) (verdict : Verdict C)
    (k : ℕ) (x : Hist (Reply C) k) (K : ℕ)
    (hrun : ¬((stateAt A targets verdict k x).stopped
      || (stateAt A targets verdict k x).over))
    (hsize : (stateAt A targets verdict k x).st.table.length ≤ K) :
    (kernelOf cert A Law.uniform targets verdict .stopped k x).mass (Reply.halt (C := C))
      ≤ (K : ℝ) / (2^320 : ℝ) := by
  unfold kernelOf
  cases hm : ((stateAt A targets verdict k x).stopped
      || (stateAt A targets verdict k x).over) with
  | true => exact absurd hm hrun
  | false =>
    cases hop : A k x with
    | hq kk =>
      show (hKernel targets (stateAt A targets verdict k x) kk).mass (Reply.halt (C := C)) ≤ _
      unfold hKernel
      simp [Law.pure]
      exact div_nonneg (Nat.cast_nonneg _) (pow_nonneg (by norm_num : (0:ℝ) ≤ 2) 320)
    | fin r msg sg =>
      show (finKernel targets verdict (stateAt A targets verdict k x) r msg sg).mass
          (Reply.halt (C := C)) ≤ _
      unfold finKernel
      simp [Law.pure]
      exact div_nonneg (Nat.cast_nonneg _) (pow_nonneg (by norm_num : (0:ℝ) ≤ 2) 320)
    | sq msg =>
      have hper : ∀ r : GameByte.Nonce,
          (signReplyStp cert (ROM.submit msg (stateAt A targets verdict k x).st) msg r).mass
              (Reply.halt (C := C))
            = if ROM.lookup (GameNames.tableAddr (GameByte.signName r msg))
                (ROM.submit msg (stateAt A targets verdict k x).st) ≠ none then (1:ℝ) else 0 := by
        intro r
        unfold signReplyStp
        cases hl : ROM.lookup (GameNames.tableAddr (GameByte.signName r msg))
            (ROM.submit msg (stateAt A targets verdict k x).st) with
        | some e => simp [Law.pure]
        | none =>
          have h0 : (signMissKernel cert r .stopped).mass (Reply.halt (C := C)) = 0 := by
            unfold signMissKernel
            show (∑ p, (honestCO cert).mass p *
                (Law.pure (signEnc r p)).mass (Reply.halt (C := C))) = 0
            refine Finset.sum_eq_zero ?_
            intro p _
            have hp : (Law.pure (signEnc r p)).mass (Reply.halt (C := C)) = 0 := by
              simp [Law.pure, signEnc]
            rw [hp]
            exact mul_zero _
          simp [h0]
      have hform : ∀ (a : ℝ) (c : Prop) [Decidable c],
          a * (if c then 1 else 0) = (if c then a else 0) := by
        intro a c _
        by_cases hc : c
        · simp [hc]
        · simp [hc]
      have hsum : (signKernel cert Law.uniform
          (ROM.submit msg (stateAt A targets verdict k x).st) .stopped msg).mass
          (Reply.halt (C := C))
          = (Law.uniform : Law GameByte.Nonce).event
              (fun r => ROM.lookup (GameNames.tableAddr (GameByte.signName r msg))
                (ROM.submit msg (stateAt A targets verdict k x).st) ≠ none) := by
        show (Mixture.keyed (Law.uniform : Law GameByte.Nonce)
            (signReplyStp cert (ROM.submit msg (stateAt A targets verdict k x).st) msg)).mass
            (Reply.halt (C := C)) = _
        rw [Mixture.keyed_mass]
        refine Finset.sum_congr rfl ?_
        intro r _
        rw [hper, hform]
      have hbridge : ((Law.uniform : Law GameByte.Nonce).event
            (fun r => ROM.lookup (GameNames.tableAddr (GameByte.signName r msg))
              (ROM.submit msg (stateAt A targets verdict k x).st) ≠ none))
          = ((Law.uniform : Law GameByte.Nonce).event
              (fun r => GameNames.tableAddr (GameByte.signName r msg)
                ∈ ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).toFinset)) := by
        refine Finset.sum_congr rfl ?_
        intro r _
        by_cases hl : ROM.lookup (GameNames.tableAddr (GameByte.signName r msg))
            (ROM.submit msg (stateAt A targets verdict k x).st) = none
        · have hnotin : ¬ GameNames.tableAddr (GameByte.signName r msg)
              ∈ ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).toFinset := by
            intro hc2
            exact ROM.lookup_miss (GameNames.tableAddr (GameByte.signName r msg))
              (ROM.submit msg (stateAt A targets verdict k x).st) hl
              (List.mem_toFinset.mp hc2)
          simp [hl, hnotin]
        · cases hx : ROM.lookup (GameNames.tableAddr (GameByte.signName r msg))
            (ROM.submit msg (stateAt A targets verdict k x).st) with
          | none => exact absurd hx hl
          | some e =>
            have hin : GameNames.tableAddr (GameByte.signName r msg)
                ∈ ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).toFinset := by
              have hmem := ROM.lookup_mem (GameNames.tableAddr (GameByte.signName r msg))
                (ROM.submit msg (stateAt A targets verdict k x).st) e hx
              simp [List.mem_toFinset, List.mem_map]
              exact ⟨e, hmem.1, hmem.2⟩
            show (if ROM.lookup (GameNames.tableAddr (GameByte.signName r msg))
                  (ROM.submit msg (stateAt A targets verdict k x).st) ≠ none
                then (Law.uniform : Law GameByte.Nonce).mass r else 0)
              = (if GameNames.tableAddr (GameByte.signName r msg)
                  ∈ ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).toFinset
                then (Law.uniform : Law GameByte.Nonce).mass r else 0)
            have hc1 : (ROM.lookup (GameNames.tableAddr (GameByte.signName r msg))
                (ROM.submit msg (stateAt A targets verdict k x).st) ≠ none) = True := by
              simp [hx]
            have hc2 : (GameNames.tableAddr (GameByte.signName r msg)
                ∈ ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).toFinset)
                = True := by
              simp [hin]
            simp only [hc1, hc2, ite_true]
      have hsize' : ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).toFinset.card ≤ K := by
        have hle := List.toFinset_card_le
          ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name)
        have hlen : ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).length
            = (stateAt A targets verdict k x).st.table.length := by simp [ROM.submit]
        rw [hlen] at hle
        exact le_trans hle hsize
      have hbound : ((Law.uniform : Law (Fin (2^320))).event
          (fun r => GameNames.tableAddr (GameByte.signName r msg)
            ∈ ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).toFinset))
          ≤ (K : ℝ) / (2^320 : ℝ) :=
        sign_conflict_risk (fun r => GameNames.tableAddr (GameByte.signName r msg))
          (sign_frame_injective msg)
          ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).toFinset
          K hsize'
      calc (signKernel cert Law.uniform
            (ROM.submit msg (stateAt A targets verdict k x).st) .stopped msg).mass
            (Reply.halt (C := C))
          = (Law.uniform : Law GameByte.Nonce).event
              (fun r => ROM.lookup (GameNames.tableAddr (GameByte.signName r msg))
                (ROM.submit msg (stateAt A targets verdict k x).st) ≠ none) := hsum
        _ = (Law.uniform : Law GameByte.Nonce).event
            (fun r => GameNames.tableAddr (GameByte.signName r msg)
              ∈ ((ROM.submit msg (stateAt A targets verdict k x).st).table.map Entry.name).toFinset) :=
            hbridge
        _ ≤ (K : ℝ) / (2^320 : ℝ) := hbound

end FT1536.FinalTheorem
