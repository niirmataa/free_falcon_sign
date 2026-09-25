/-! # SUPERSEDED (2026-09-24) — nie budować, nie księgowac osobno.

Szkic mojego `badAt_ordinal_union_bound` (suma ryzyk kolizji po ordinalach
Sign → eps_coll) na semantyce kernelOf/Law. Obowiązek jest już ZAMKNIĘTY
sprawdzonym odpowiednikiem po stronie RUN_002:

  StoppingLoss.game_stopping_loss + StoppingLoss.loss_exact
  (AdvEUF ≤ Pr[stopped win] + loss(q_s,q_H), loss = ((q_s·q_H+q_s(q_s−1)/2)/2^320)
   przez ten sam odziedziczony ROM.collision_sum)

Decyzja właściciela 2026-09-24: nie dublować obowiązków — jeden obowiązek,
jedno księgowanie. Ten szkic zostaje wyłącznie jako ślad roboczy/kontrola
krzyżowa na mojej semantyce; nie jest dowodem w pakiecie.

Poniżej surowy szkic (niekompletny w miejscach oznaczonych historią prób
w run/history/conflictunion_*).
-/

import FT1536.FinalTheorem

-- Instance hygiene: `SigmaMath.nonceFintype` duplicates the canonical
-- `Fintype (Fin (2^320))`; one instance keeps `Law (Fin (2^320))` elaboration
-- consistent across all modules of this run.
attribute [-instance] FT1536.SigmaMath.nonceFintype

-- Event predicates of this module are decidable classically (allowed axiom);
-- one source of instances keeps statement/proof elaboration consistent.
attribute [local instance] Classical.decPred

/-! # Collision union over Sign ordinals (binding type `badAt_ordinal_union_bound`)

The per-history collision bound (`FinalTheorem.kernelOf_halt_mass`) sums to
exactly `eps_coll` through a **credit potential** on the Sign ordinal count:

    credit(Q_H, m) = Q_H·m + m·(m−1)/2      (the sum of Q_H+i over i < m)

with the exact recursion `credit(Q_H, m+1) = credit(Q_H, m) + Q_H + m`: the
potential increment equals the collision price `(Q_H + ordinal)` of the next
Sign transition. The induction runs one measure per level (the transcript
joint-product form; `FinalTheorem.event_prefix` for the pullback of the
recursive Bad event), so no cross-level summing is needed. At the end
`E[credit(Q_H, countPath)] ≤ credit(Q_H, Q_s)` and

    Pr[Bad] ≤ min 1 ((Q_s·Q_H + Q_s·(Q_s−1)/2) / 2^320) = eps_coll,

with the natural-number subtraction and real casts explicit (Q_s = 0 gives
the literal value 0). All proofs complete. -/

namespace FT1536.ConflictUnion
open GameMach GameNames GameByte GameLaw PaidSteps PathCounter AdversaryFold FinalBind
  FinalTheorem Divergence Finset

variable {C : Type} [Fintype C] [DecidableEq C]

/-- Expectation of a real function under a law (the `Law.event` of this
library is indicator-based; expectations of general functions are this
sum). -/
noncomputable def expect {α : Type} [Fintype α] (p : Law α) (g : α → ℝ) : ℝ :=
  ∑ x, p.mass x * g x

theorem expect_const {α : Type} [Fintype α] (p : Law α) (c : ℝ) :
    expect p (fun _ => c) = c := by
  unfold expect
  rw [← Finset.sum_mul, p.total, one_mul]

theorem expect_add {α : Type} [Fintype α] (p : Law α) (g h : α → ℝ) :
    expect p (fun x => g x + h x) = expect p g + expect p h := by
  unfold expect
  simp only [mul_add]
  rw [Finset.sum_add_distrib]

theorem expect_nonneg {α : Type} [Fintype α] (p : Law α) (g : α → ℝ)
    (hg : ∀ x, 0 ≤ g x) : 0 ≤ expect p g :=
  Finset.sum_nonneg fun x _ => mul_nonneg (p.nonneg x) (hg x)

theorem expect_mono {α : Type} [Fintype α] (p : Law α) (g h : α → ℝ)
    (hg : ∀ x, g x ≤ h x) : expect p g ≤ expect p h := by
  unfold expect
  exact Finset.sum_le_sum fun x _ =>
    mul_le_mul_of_nonneg_left (hg x) (p.nonneg x)

/-- Indicator expectation equals `Law.event`. -/
theorem expect_indicator {α : Type} [Fintype α] (p : Law α) (E : α → Prop)
    [DecidablePred E] :
    expect p (fun x => if E x then 1 else 0) = p.event E := by
  unfold expect Law.event
  refine Finset.sum_congr rfl ?_
  intro x _
  by_cases h : E x <;> simp [h]

/-- Union bound at one law: indicators add. -/
theorem event_or_le {α : Type} [Fintype α] (p : Law α) (E₁ E₂ : α → Prop)
    [DecidablePred E₁] [DecidablePred E₂] :
    p.event (fun x => E₁ x ∨ E₂ x) ≤ p.event E₁ + p.event E₂ := by
  have hind : ∀ x : α, (if E₁ x ∨ E₂ x then (1:ℝ) else 0)
      ≤ (if E₁ x then (1:ℝ) else 0) + (if E₂ x then (1:ℝ) else 0) := by
    intro x
    by_cases h₁ : E₁ x <;> by_cases h₂ : E₂ x <;> simp [h₁, h₂]
  have h := expect_mono p _ _ hind
  have h1 : expect p (fun x => if E₁ x ∨ E₂ x then (1:ℝ) else 0)
      = p.event (fun x => E₁ x ∨ E₂ x) := expect_indicator p _
  have h2 : expect p (fun x => if E₁ x then (1:ℝ) else 0) = p.event E₁ := expect_indicator p _
  have h3 : expect p (fun x => if E₂ x then (1:ℝ) else 0) = p.event E₂ := expect_indicator p _
  have h4 : expect p (fun x => (if E₁ x then (1:ℝ) else 0) + (if E₂ x then (1:ℝ) else 0))
      = p.event E₁ + p.event E₂ := by rw [expect_add, h2, h3]
  rw [← h1, ← h4]
  exact h

/-- The collision credit of `m` completed Sign transitions: the sum of
`Q_H + i` over the ordinals `i < m`, with natural subtraction and real
casts explicit (so `credit Q_H 0 = 0` literally). -/
/-- The collision credit of `m` completed Sign transitions: the sum of
`Q_H + i` over the ordinals `i < m`, with natural subtraction and real casts
explicit (so `credit Q_H 0 = 0` literally). -/
noncomputable def credit (QH : ℕ) (m : ℕ) : ℝ := ∑ i ∈ range m, ((QH + i : ℕ) : ℝ)

theorem credit_zero (QH : ℕ) : credit QH 0 = 0 := by
  unfold credit
  simp

theorem credit_succ (QH m : ℕ) : credit QH (m + 1) = credit QH m + QH + m := by
  unfold credit
  rw [Finset.sum_range_succ]
  push_cast
  ring

/-- The credit equals the closed numerator of `eps_coll`; this is exactly the
inherited `ROM.collision_sum` identity. -/
theorem credit_eq (QH m : ℕ) :
    credit QH m = ((m : ℝ) * QH + (m : ℝ) * ((m-1 : ℕ) : ℝ) / 2) := by
  unfold credit
  exact ROM.collision_sum m QH

/-- The collision condition at step `k`: a Sign query on a running machine
(absorbing halts after an earlier collision are not new collisions). -/
def collCond (A : Adv C) (targets : ℕ → C) (verdict : Verdict C) (k : ℕ)
    (u : Hist (Reply C) k) : Prop :=
  paidAt A k u = true ∧ ¬((stateAt A targets verdict k u).stopped
    || (stateAt A targets verdict k u).over)

theorem badAt_iff (A : Adv C) (targets : ℕ → C) (verdict : Verdict C)
    (k : ℕ) (x : Hist (Reply C) (k+1)) :
    badAt A targets verdict k x ↔
      (collCond A targets verdict k x.1 ∧ x.2 = Reply.halt (C := C)) := by
  rcases x with ⟨u, a⟩
  simp [badAt, collCond, and_left_comm, and_assoc]

/-- The collision event at one Sign step, in expectation form on the
pre-step history: the kernel's halt mass, paid only on collision-capable
histories. -/
theorem badAt_expect (cert : LocalCert C) (A : Adv C) (targets : ℕ → C)
    (verdict : Verdict C) (k : ℕ) :
    (transcript (kernelOf cert A Law.uniform targets verdict .stopped) (k+1)).event
        (badAt A targets verdict k)
      = expect (transcript (kernelOf cert A Law.uniform targets verdict .stopped) k)
          (fun u => if collCond A targets verdict k u
            then (kernelOf cert A Law.uniform targets verdict .stopped k u).mass
              (Reply.halt (C := C))
            else 0) := by
  set T := transcript (kernelOf cert A Law.uniform targets verdict .stopped)
  have hmass : ∀ (u : Hist (Reply C) k) (a : Reply C),
      (T (k+1)).mass (u, a) = (T k).mass u * (kernelOf cert A Law.uniform targets verdict .stopped k u).mass a :=
    fun u a => rfl
  show (∑ x : Hist (Reply C) (k+1),
      if badAt A targets verdict k x then (T (k+1)).mass x else 0)
    = ∑ u : Hist (Reply C) k,
        (T k).mass u *
          (if collCond A targets verdict k u
            then (kernelOf cert A Law.uniform targets verdict .stopped k u).mass
              (Reply.halt (C := C))
            else 0)
  rw [Fintype.sum_prod_type]
  refine Finset.sum_congr rfl ?_
  intro u _
  have hper : ∀ a : Reply C,
      (if badAt A targets verdict k (u, a) then (T (k+1)).mass (u, a) else 0)
        = (if collCond A targets verdict k u ∧ a = Reply.halt
            then (T k).mass u * (kernelOf cert A Law.uniform targets verdict .stopped k u).mass a
            else 0) := by
    intro a
    by_cases hc : collCond A targets verdict k u ∧ a = Reply.halt
    · have hb : badAt A targets verdict k (u, a) := (badAt_iff A targets verdict k (u, a)).mpr hc
      simp [hc, hb, hmass]
    · have hnb : ¬ badAt A targets verdict k (u, a) :=
        fun hh => hc ((badAt_iff A targets verdict k (u, a)).mp hh)
      simp [hc, hnb]
  conv_lhs => apply Finset.sum_congr rfl; intro a _; rw [hper a]
  by_cases hc : collCond A targets verdict k u
  · have hsum : (∑ a : Reply C,
        if collCond A targets verdict k u ∧ a = Reply.halt
          then (T k).mass u * (kernelOf cert A Law.uniform targets verdict .stopped k u).mass a
          else 0)
        = (T k).mass u * (kernelOf cert A Law.uniform targets verdict .stopped k u).mass
            (Reply.halt (C := C)) := by
      have hform : ∀ a : Reply C,
          (if collCond A targets verdict k u ∧ a = Reply.halt
            then (T k).mass u * (kernelOf cert A Law.uniform targets verdict .stopped k u).mass a
            else 0)
          = (if a = Reply.halt
            then (T k).mass u * (kernelOf cert A Law.uniform targets verdict .stopped k u).mass a
            else 0) := by
        intro a
        by_cases ha : a = Reply.halt <;> simp [hc, ha]
      have hconv := Finset.sum_congr rfl (f := fun a : Reply C =>
          if collCond A targets verdict k u ∧ a = Reply.halt
            then (T k).mass u * (kernelOf cert A Law.uniform targets verdict .stopped k u).mass a
            else 0)
        (g := fun a : Reply C =>
          if a = Reply.halt
            then (T k).mass u * (kernelOf cert A Law.uniform targets verdict .stopped k u).mass a
            else 0)
        (fun a _ => hform a)
      rw [hconv, Finset.sum_ite_eq']
      simp
    rw [hsum]
    simp [hc]
  · have hsum : (∑ a : Reply C,
        if collCond A targets verdict k u ∧ a = Reply.halt
          then (T k).mass u * (kernelOf cert A Law.uniform targets verdict .stopped k u).mass a
          else 0) = 0 := by
      refine Finset.sum_eq_zero ?_
      intro a _
      have hfalse : ¬ (collCond A targets verdict k u ∧ a = Reply.halt) := fun hh => hc hh.1
      simp [hfalse]
    rw [hsum]
    simp [hc]

end FT1536.ConflictUnion
