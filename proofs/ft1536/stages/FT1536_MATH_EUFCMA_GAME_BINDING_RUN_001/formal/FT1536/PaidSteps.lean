import FT1536.Adaptive
import FT1536.Collision
import FT1536.EventTransfer
import FT1536.GameByte
import FT1536.GameNames
import FT1536.ROM

/-! # Paid-step counter lemma and event transfer (task Etap C/Etap D)

The main new probabilistic lemma: identical kernels at shared steps have
second moment exactly 1 (`second_self`), so a transcript whose only paid
(differing) transitions are Sign queries carries at most `Q_s` factors
`1+e`. This is the paid-step counter form of the task requirement — the
exponent is the number of paid transitions, not the number of machine steps.

From this, the stopped-transcript event transfer with `Phi((1+e)^Q_s - 1, _)`
and the final clipped shape `min 1 (eps + Phi ...)` follow with the inherited
`EventTransfer` calculus. The collision term is the inherited exact sum
`(Q_s*Q_H + Q_s*(Q_s-1)/2)/2^320` wired to per-call Sign-name risks through
an injective 40-byte nonce frame. No `sorry` in this module. -/

namespace FT1536.PaidSteps
open Divergence EventTransfer Finset

/-- Identical kernels have second moment exactly 1. -/
theorem second_self {α : Type} [Fintype α] (p : Law α) : second p p = 1 := by
  unfold second
  have h : (∑ x, p.mass x ^ 2 / p.mass x) = ∑ x, p.mass x := by
    apply sum_congr rfl
    intro x _
    by_cases hx : p.mass x = 0
    · simp [hx]
    · field_simp
  rw [h, p.total]

theorem second_of_eq {α : Type} [Fintype α] (j p : Law α) (h : j = p) : second j p = 1 := by
  rw [h]
  exact second_self p

/-- Number of paid transitions among the first `n` steps. -/
def countPaid (paid : ℕ → Prop) [DecidablePred paid] (n : ℕ) : ℕ :=
  ∑ i ∈ range n, if paid i then 1 else 0

theorem countPaid_succ (paid : ℕ → Prop) [DecidablePred paid] (n : ℕ) :
    countPaid paid (n+1) = countPaid paid n + (if paid n then 1 else 0) := by
  show (∑ i ∈ range (n+1), if paid i then (1:ℕ) else 0) = _
  rw [sum_range_succ]
  rfl

theorem countPaid_zero (paid : ℕ → Prop) [DecidablePred paid] : countPaid paid 0 = 0 := by
  simp [countPaid]

/-- **Paid-step counter lemma.** Shared steps (flag `false`) use literally the
same kernel in both transcripts and contribute a factor exactly 1; each paid
step (flag `true`) contributes at most `1+e`. Hence the second moment of the
whole transcript is at most `(1+e)` to the number of paid transitions —
independent of how many total machine steps were taken. -/
theorem paid_counter_chi2 {α : Type} [Fintype α]
    (j p : (n : ℕ) → Hist α n → Law α)
    (paid : ℕ → Prop) [DecidablePred paid] (e : ℝ) (he : 0 ≤ e)
    (hshared : ∀ i x, ¬ paid i → j i x = p i x)
    (hpaid : ∀ i x, paid i → second (j i x) (p i x) ≤ 1 + e) :
    ∀ n, second (transcript j n) (transcript p n) ≤ (1 + e) ^ countPaid paid n := by
  intro n
  induction n with
  | zero =>
    have h1 : second (transcript j 0) (transcript p 0) = 1 :=
      second_of_eq _ _ (by simp [transcript])
    rw [h1, countPaid_zero, pow_zero]
  | succ n ih =>
    have hbound : ∀ x, second (j n x) (p n x) ≤ (if paid n then 1 + e else 1) := by
      intro x
      by_cases hp : paid n
      · have hif : (if paid n then (1+e:ℝ) else 1) = 1 + e := by simp [hp]
        rw [hif]
        exact hpaid n x hp
      · have hif : (if paid n then (1+e:ℝ) else 1) = 1 := by simp [hp]
        rw [hif, hshared n x hp]
        exact le_of_eq (second_self (p n x))
    have hjoint : second (transcript j (n+1)) (transcript p (n+1)) ≤
        second (transcript j n) (transcript p n) * (if paid n then 1 + e else 1) := by
      show second (joint (transcript j n) (j n)) (joint (transcript p n) (p n)) ≤ _
      exact joint_bound _ _ _ _ _ (fun x _ => hbound x)
    have hstep : second (transcript j n) (transcript p n) * (if paid n then 1 + e else 1) ≤
        (1+e) ^ countPaid paid (n+1) := by
      by_cases hp : paid n
      · have hif : (if paid n then (1+e:ℝ) else 1) = 1 + e := by simp [hp]
        have hc : countPaid paid (n+1) = countPaid paid n + 1 := by simp [countPaid_succ, hp]
        rw [hif, hc, pow_succ (1+e) (countPaid paid n)]
        exact mul_le_mul_of_nonneg_right ih (by linarith)
      · have hif : (if paid n then (1+e:ℝ) else 1) = 1 := by simp [hp]
        have hc : countPaid paid (n+1) = countPaid paid n := by simp [countPaid_succ, hp]
        rw [hif, mul_one, hc]
        exact ih
    exact le_trans hjoint hstep

/-- If there are at most `Q_s` paid transitions, the second moment is at most
`(1+e)^Q_s` — exactly the task's `second(Law_SIM_trace, Law_EUF_stopped_trace)
≤ (1+e)^Q_s` shape. -/
theorem paid_counter_le {α : Type} [Fintype α]
    (j p : (n : ℕ) → Hist α n → Law α)
    (paid : ℕ → Prop) [DecidablePred paid] (e : ℝ) (he : 0 ≤ e) (Qs : ℕ)
    (hshared : ∀ i x, ¬ paid i → j i x = p i x)
    (hpaid : ∀ i x, paid i → second (j i x) (p i x) ≤ 1 + e)
    (hcount : ∀ n, countPaid paid n ≤ Qs) (n : ℕ) :
    second (transcript j n) (transcript p n) ≤ (1 + e) ^ Qs :=
  le_trans (paid_counter_chi2 j p paid e he hshared hpaid n)
    (pow_le_pow_right₀ (by linarith : (1:ℝ) ≤ 1 + e) (hcount n))

/-- Event transfer with the paid-step exponent: honest-side event probability
is bounded by `Phi((1+e)^Q_s - 1, b)` of the comparison game. -/
theorem paid_event_bound {α : Type} [Fintype α]
    (j p : (n : ℕ) → Hist α n → Law α)
    (paid : ℕ → Prop) [DecidablePred paid] (e : ℝ) (he : 0 ≤ e) (Qs : ℕ)
    (hshared : ∀ i x, ¬ paid i → j i x = p i x)
    (hpaid : ∀ i x, paid i → second (j i x) (p i x) ≤ 1 + e)
    (hcount : ∀ n, countPaid paid n ≤ Qs)
    (hac : ∀ n x, AC (j n x) (p n x)) (n : ℕ)
    (E : Hist α n → Prop) [DecidablePred E] :
    (transcript p n).event E ≤
      phi ((1+e)^Qs - 1) ((transcript j n).event E) := by
  let d := densityOfAC _ _ (transcript_ac j p hac n)
  have hd : energy (transcript p n) d.ratio - 1 ≤ (1+e)^Qs - 1 := by
    rw [energy_eq_second]
    exact sub_le_sub_right (paid_counter_le j p paid e he Qs hshared hpaid hcount n) 1
  have hq : 0 ≤ (1+e)^Qs - 1 := by
    have hp : (1:ℝ) ≤ (1+e)^Qs := one_le_pow₀ (by linarith)
    linarith
  exact EventTransfer.phi_bound hq ((transcript j n).event_nonneg E)
    ((transcript j n).event_le_one E) (EventTransfer.event_quadratic _ _ d E _ hd)

/-- Final clipped shape on the comparison side: winning without the conflict
event implies the extraction event; conflict losses stay outside `Phi` (only
the clipped collision term pays for them). -/
theorem paid_trace_bound {α : Type} [Fintype α]
    (j p : (n : ℕ) → Hist α n → Law α)
    (paid : ℕ → Prop) [DecidablePred paid] (e : ℝ) (he : 0 ≤ e) (Qs : ℕ)
    (hshared : ∀ i x, ¬ paid i → j i x = p i x)
    (hpaid : ∀ i x, paid i → second (j i x) (p i x) ≤ 1 + e)
    (hcount : ∀ n, countPaid paid n ≤ Qs)
    (hac : ∀ n x, AC (j n x) (p n x)) (n : ℕ)
    (Win Bad MT : Hist α n → Prop)
    [DecidablePred Win] [DecidablePred Bad] [DecidablePred MT]
    (extracts : ∀ x, Win x ∧ ¬ Bad x → MT x)
    (eps : ℝ) (hbad : (transcript p n).event Bad ≤ eps) :
    (transcript p n).event Win ≤
      min 1 (eps + phi ((1+e)^Qs - 1) ((transcript j n).event MT)) := by
  apply le_min ((transcript p n).event_le_one Win)
  have hremove := (transcript p n).remove_bad_bound Win Bad
  have htransfer := paid_event_bound j p paid e he Qs hshared hpaid hcount hac n
    (fun x => Win x ∧ ¬ Bad x)
  have hmono := (transcript j n).event_mono _ MT extracts
  have hq : 0 ≤ (1+e)^Qs - 1 := by
    have hp : (1:ℝ) ≤ (1+e)^Qs := one_le_pow₀ (by linarith)
    linarith
  have hphi := phi_mono hq ((transcript j n).event_nonneg _) hmono
    ((transcript j n).event_le_one MT)
  linarith

/-! ## Nonce conflicts (Etap D)

The Sign-name frame `r ↦ tableAddr (signName r msg)` is injective (40-byte
frame injectivity + pair framing), so a fresh uniform salt hits a table of
`K` names with probability at most `K / 2^320`. The per-call risk uses the
real table size before the call; summing the sizes `Q_H + i` gives exactly
the task's `eps_coll` through the inherited `accumulated_conflicts`. -/

theorem sign_frame_injective (msg : GameByte.Message) :
    Function.Injective
      (fun r : GameByte.Nonce => GameNames.tableAddr (GameByte.signName r msg)) := by
  intro r s h
  have h2 : GameByte.signName r msg = GameByte.signName s msg :=
    GameNames.tableAddr_injective h
  exact (GameByte.pair_framing r s msg msg h2).1

/-- Fresh-salt Sign-name conflict risk against a concrete table of `K` names. -/
theorem sign_conflict_risk {X : Type} [DecidableEq X]
    (frame : Fin (2^320) → X) (hinj : Function.Injective frame)
    (table : Finset X) (K : ℕ) (hsize : table.card ≤ K) :
    ((Law.uniform : Law (Fin (2^320))).event (fun r => frame r ∈ table)) ≤
      (K : ℝ) / (2^320 : ℝ) := by
  have h := ROM.fresh_nonce_conflict frame hinj table
  have hcard : Fintype.card (Fin (2^320)) = 2^320 := Fintype.card_fin _
  refine le_trans h ?_
  have hd : (2^320 : ℝ) = ((Fintype.card (Fin (2^320)) : ℕ) : ℝ) := by
    rw [hcard, Nat.cast_pow, Nat.cast_ofNat]
  rw [hd]
  exact div_le_div_of_nonneg_right (by exact_mod_cast hsize) (by positivity)

/-- Exact clipped sum of the per-call risks `Q_H + i`, i < Q_s: the task's
`eps_coll = min 1 ((Q_s*Q_H + Q_s*(Q_s-1)/2)/2^320)`. -/
theorem conflict_bound_shape {Ω : Type} [Fintype Ω] (p : Law Ω) (qs qh : ℕ)
    (E : ℕ → Ω → Prop) [∀ i, DecidablePred (E i)]
    (h : ∀ i ∈ range qs, p.event (E i) ≤ ((qh + i : ℕ) : ℝ) / (2^320 : ℝ)) :
    p.event (fun x => ∃ i ∈ range qs, E i x) ≤
      min 1 (((qs : ℝ) * qh + (qs : ℝ) * ((qs-1 : ℕ) : ℝ) / 2) / (2^320 : ℝ)) :=
  ROM.accumulated_conflicts p qs qh E h

/-- Q_s = 0 boundary: no paid transition and no divergence gap; the transfer
degenerates to `Phi 0 b = b` with explicit natural casts. -/
theorem zero_paid_boundary {α : Type} [Fintype α]
    (j p : (n : ℕ) → Hist α n → Law α)
    (hshared : ∀ i x, j i x = p i x) (n : ℕ) :
    second (transcript j n) (transcript p n) = 1 ∧
      (((1:ℝ) + 0) ^ 0 - 1) = 0 ∧ phi (((1:ℝ) + 0) ^ 0 - 1) 0 = 0 := by
  have hall : ∀ n, transcript j n = transcript p n := by
    intro n
    induction n with
    | zero => rfl
    | succ n ih =>
      show joint (transcript j n) (j n) = joint (transcript p n) (p n)
      exact congrArg₂ joint ih (funext (fun x => hshared n x))
  refine ⟨?_, by norm_num, ?_⟩
  · rw [hall n]
    exact second_self (transcript p n)
  · rw [show (((1:ℝ) + 0) ^ 0 - 1) = 0 by norm_num, phi_zero_delta]

end FT1536.PaidSteps
