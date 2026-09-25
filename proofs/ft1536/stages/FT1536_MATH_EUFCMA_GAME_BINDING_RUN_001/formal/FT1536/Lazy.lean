import FT1536.Basic
import FT1536.Mixture
import FT1536.ROM
import Mathlib.Data.Fintype.BigOperators

/-! # Lazy sampling refinement (binding type `lazy_sampling_refinement`)

The target list of the SIM game is an input vector `Fin (Q_H+1) → C` drawn
once, read lazily in read order (`ROM.hash` reads `targets[used]` and `used`
counts fresh reads — machine discipline is in `GameMach.used_le_of_step`).
This module proves the probabilistic agreement with the lazy oracle:

* `seqTargets` — the sequential construction: T independent uniform draws
  appended one per fresh read slot;
* `seqTargets_snoc` — the mass recursion of the sequential construction;
* `lazy_independence` — **the unused target (next read slot) is uniform and
  independent of the entire read prefix** (the past that determines the next
  operation): the joint law of `(prefix, next)` is exactly the product of the
  prefix law and `Law.uniform`;
* `seqTargets_eq_uniform` — the refinement: the sequential construction *is*
  the flat uniform input vector (so the input-vector experiment and the lazy
  sequential experiment induce the same laws).

Read order matters only through `extendAt`/`restrictTo`: `ROM.hash` reads
exactly slot `used` on a miss and no slot on a hit (`ROM.hash_nonanticipating`
is the code-level non-anticipation). No `sorry` in this module. -/

namespace FT1536.Lazy
open Finset

variable {C : Type} [Fintype C] [DecidableEq C] [Nonempty C]

/-- Append one fresh value at slot `k` (the next read slot). -/
def extendAt {k : ℕ} (v : Fin k → C) (c : C) : Fin (k+1) → C :=
  fun i => if h : i.val < k then v ⟨i.val, h⟩ else c

/-- Restrict a full target vector to the already-read prefix. -/
def restrictTo {T : ℕ} (u : ℕ) (hu : u ≤ T) (v : Fin T → C) : Fin u → C :=
  fun i => v ⟨i.val, lt_of_lt_of_le i.isLt hu⟩

/-- The next unread value of a full target vector. -/
def lastOf {T : ℕ} (u : ℕ) (hu : u < T) (v : Fin T → C) : C := v ⟨u, hu⟩

omit [Fintype C] [DecidableEq C] [Nonempty C] in
lemma extendAt_prefix {k : ℕ} (v : Fin k → C) (c : C) :
    restrictTo k (Nat.le_succ k) (extendAt v c) = v := by
  funext i
  show (extendAt v c) ⟨i.val, _⟩ = v i
  simp [extendAt, i.isLt]

omit [Fintype C] [DecidableEq C] [Nonempty C] in
lemma extendAt_last {k : ℕ} (v : Fin k → C) (c : C) :
    lastOf k (Nat.lt_succ_self k) (extendAt v c) = c := by
  show (extendAt v c) ⟨k, _⟩ = c
  simp [extendAt]

omit [Fintype C] [DecidableEq C] [Nonempty C] in
lemma extendAt_injective {k : ℕ} (v : Fin k → C) : Function.Injective (extendAt v) := by
  intro c c' h
  have h1 := congrArg (lastOf k (Nat.lt_succ_self k)) h
  rw [extendAt_last, extendAt_last] at h1
  exact h1

omit [Fintype C] [DecidableEq C] [Nonempty C] in
lemma extendAt_complete {k : ℕ} (w : Fin (k+1) → C) :
    extendAt (restrictTo k (Nat.le_succ k) w) (lastOf k (Nat.lt_succ_self k) w) = w := by
  funext i
  show (if h : i.val < k then (restrictTo k _ w) ⟨i.val, h⟩ else lastOf k _ w) = w i
  by_cases hi : i.val < k
  · simp [restrictTo, hi]
  · have hi2 : i = ⟨k, Nat.lt_succ_self k⟩ := by
      apply Fin.ext
      show i.val = k
      have hlt := i.isLt
      omega
    subst hi2
    simp [lastOf]

/-- Splitting a full vector at the next read slot is a bijection. -/
noncomputable def extEquiv (k : ℕ) : ((Fin k → C) × C) ≃ (Fin (k+1) → C) where
  toFun p := extendAt p.1 p.2
  invFun w := (restrictTo k (Nat.le_succ k) w, lastOf k (Nat.lt_succ_self k) w)
  left_inv p := by
    rcases p with ⟨v, c⟩
    show (restrictTo k _ (extendAt v c), lastOf k _ (extendAt v c)) = (v, c)
    simp [extendAt_prefix, extendAt_last]
  right_inv w := extendAt_complete w

-- Cardinality of the input vector type.
omit [DecidableEq C] [Nonempty C] in
lemma card_vec (T : ℕ) : Fintype.card (Fin T → C) = Fintype.card C ^ T := by
  rw [Fintype.card_pi]
  show (∏ _i : Fin T, Fintype.card C) = Fintype.card C ^ T
  rw [Finset.prod_eq_pow_card (fun _ _ => rfl), Finset.card_univ, Fintype.card_fin]

/-- The sequential construction: T independent uniform draws appended one per
read slot. This is the lazy-oracle law in sequential form. -/
noncomputable def seqTargets : (T : ℕ) → Law (Fin T → C)
  | 0 => Law.pure (fun i => (Fin.elim0 i))
  | T+1 => (seqTargets T).bind (fun v => ((Law.uniform : Law C).map (extendAt v)))

theorem seqTargets_succ (T : ℕ) :
    seqTargets (T+1) = (seqTargets T).bind (fun v => (Law.uniform : Law C).map (extendAt v)) := rfl

/-- Mass of a mapped uniform draw at a fixed vector. -/
theorem map_uniform_mass {k : ℕ} (v : Fin k → C) (w : Fin (k+1) → C) :
    ((Law.uniform : Law C).map (extendAt v)).mass w =
      ∑ c, if w = extendAt v c then (1 / Fintype.card C : ℝ) else 0 := by
  show (∑ c, (Law.uniform : Law C).mass c * (Law.pure (extendAt v c)).mass w) = _
  refine Finset.sum_congr rfl ?_
  intro c _
  by_cases hw : w = extendAt v c <;> simp [hw, Law.uniform, Law.pure]

-- Only the vector assembled from the prefix and the next slot can produce a
-- given full vector.
omit [Fintype C] [DecidableEq C] [Nonempty C] in
lemma extendAt_eq_iff {k : ℕ} (v : Fin k → C) (w : Fin (k+1) → C) (c : C) :
    w = extendAt v c ↔ (v = restrictTo k (Nat.le_succ k) w ∧ c = lastOf k (Nat.lt_succ_self k) w) := by
  constructor
  · intro h
    refine ⟨?_, ?_⟩
    · rw [← extendAt_prefix v c, h]
    · rw [← extendAt_last v c, h]
  · intro h
    rcases h with ⟨hv, hc⟩
    subst hv
    subst hc
    exact (extendAt_complete w).symm

/-- Mapped uniform draw: mass is `1/|C|` exactly at the assembled vector. -/
theorem map_uniform_at {k : ℕ} (v : Fin k → C) (w : Fin (k+1) → C) :
    ((Law.uniform : Law C).map (extendAt v)).mass w =
      if v = restrictTo k (Nat.le_succ k) w then (1 / Fintype.card C : ℝ) else 0 := by
  rw [map_uniform_mass]
  by_cases hv : v = restrictTo k (Nat.le_succ k) w
  · have hrew : ∀ c : C, (w = extendAt v c) ↔ (c = lastOf k (Nat.lt_succ_self k) w) := by
      intro c
      rw [extendAt_eq_iff v w c]
      constructor
      · intro h; exact h.2
      · intro h; exact ⟨hv, h⟩
    have hsum : (∑ c : C, if w = extendAt v c then (1 / Fintype.card C : ℝ) else 0)
        = 1 / Fintype.card C := by
      have h1 : (∑ c : C, if w = extendAt v c then (1 / Fintype.card C : ℝ) else 0)
          = ∑ c : C, if c = lastOf k (Nat.lt_succ_self k) w then (1 / Fintype.card C : ℝ) else 0 := by
        simp only [hrew]
      rw [h1, Finset.sum_ite_eq']
      simp
    rw [hsum]
    simp [hv]
  · have h0 : (∑ c : C, if w = extendAt v c then (1 / Fintype.card C : ℝ) else 0) = 0 := by
      refine Finset.sum_eq_zero ?_
      intro c _
      by_cases hc : w = extendAt v c
      · exact absurd (by rw [← extendAt_prefix v c, hc]) hv
      · simp [hc]
    rw [h0]
    simp [hv]

/-- Mass recursion of the sequential construction. -/
theorem seqTargets_snoc (T : ℕ) (w : Fin (T+1) → C) :
    (seqTargets (T+1)).mass w =
      (seqTargets T).mass (restrictTo T (Nat.le_succ T) w) / Fintype.card C := by
  show (∑ v, (seqTargets T).mass v * ((Law.uniform : Law C).map (extendAt v)).mass w) = _
  have h1 : (∑ v, (seqTargets T).mass v * ((Law.uniform : Law C).map (extendAt v)).mass w)
      = ∑ v, if v = restrictTo T (Nat.le_succ T) w
          then (seqTargets T).mass v * (1 / Fintype.card C : ℝ) else 0 := by
    refine Finset.sum_congr rfl ?_
    intro v _
    rw [map_uniform_at]
    by_cases hv : v = restrictTo T (Nat.le_succ T) w <;> simp [hv]
  rw [h1, Finset.sum_ite_eq']
  simp [div_eq_mul_inv]

/-- Mass of the sequential construction: uniform on the vector type. -/
theorem seqTargets_mass (T : ℕ) (w : Fin T → C) :
    (seqTargets T).mass w = 1 / Fintype.card C ^ T := by
  induction T with
  | zero =>
    have hsub : (fun i : Fin 0 => (Fin.elim0 i)) = w :=
      ((Pi.uniqueOfIsEmpty (fun _ : Fin 0 => C)).uniq w).symm
    show (Law.pure (fun i => (Fin.elim0 i))).mass w = _
    rw [hsub, Law.pure]
    simp
  | succ T ih =>
    rw [seqTargets_snoc, ih, div_div, ← pow_succ]

/-- **Refinement**: the sequential lazy construction is exactly the flat
uniform input vector. Input-vector and lazy-oracle experiments therefore
induce the same laws. -/
theorem seqTargets_eq_uniform (T : ℕ) :
    seqTargets T = (Law.uniform : Law (Fin T → C)) := by
  apply Mixture.law_ext
  intro w
  rw [seqTargets_mass]
  show (1 / Fintype.card C ^ T : ℝ) = (Law.uniform : Law (Fin T → C)).mass w
  simp only [Law.uniform]
  rw [card_vec, Nat.cast_pow]

/-- **Lazy independence**: the value at the next read slot is uniform and
independent of the entire read prefix (the past that determines the next
operation). -/
theorem lazy_independence (T : ℕ) :
    (seqTargets (T+1)).map
        (fun w => (restrictTo T (Nat.le_succ T) w, lastOf T (Nat.lt_succ_self T) w)) =
      Divergence.joint (seqTargets T) (fun _ => (Law.uniform : Law C)) := by
  apply Mixture.law_ext
  intro p
  rcases p with ⟨v0, c0⟩
  have hiff : ∀ w : Fin (T+1) → C,
      ((v0, c0) = (restrictTo T (Nat.le_succ T) w, lastOf T (Nat.lt_succ_self T) w))
        ↔ (w = extendAt v0 c0) := by
    intro w
    constructor
    · intro h
      have hv : v0 = restrictTo T (Nat.le_succ T) w := congrArg Prod.fst h
      have hc : c0 = lastOf T (Nat.lt_succ_self T) w := congrArg Prod.snd h
      have hcomp := extendAt_complete w
      rw [← hcomp, ← hv, ← hc]
    · intro h
      subst h
      simp [extendAt_prefix, extendAt_last]
  have hmap : ((seqTargets (T+1)).map
      (fun w => (restrictTo T (Nat.le_succ T) w, lastOf T (Nat.lt_succ_self T) w))).mass (v0, c0)
      = (seqTargets (T+1)).mass (extendAt v0 c0) := by
    show (∑ w, (seqTargets (T+1)).mass w *
        (Law.pure ((restrictTo T (Nat.le_succ T) w, lastOf T (Nat.lt_succ_self T) w) : (Fin T → C) × C)).mass (v0, c0)) = _
    have h1 : (∑ w, (seqTargets (T+1)).mass w *
        (Law.pure ((restrictTo T (Nat.le_succ T) w, lastOf T (Nat.lt_succ_self T) w) : (Fin T → C) × C)).mass (v0, c0))
        = ∑ w, if w = extendAt v0 c0
            then (seqTargets (T+1)).mass w * (1 : ℝ) else 0 := by
      refine Finset.sum_congr rfl ?_
      intro w _
      show (seqTargets (T+1)).mass w * (Law.pure ((restrictTo T _ w, lastOf T _ w))).mass (v0, c0)
          = if w = extendAt v0 c0 then (seqTargets (T+1)).mass w * (1 : ℝ) else 0
      simp only [Law.pure, hiff]
      by_cases hw : w = extendAt v0 c0 <;> simp [hw]
    rw [h1, Finset.sum_ite_eq']
    simp
  rw [hmap, seqTargets_snoc, extendAt_prefix]
  show (seqTargets T).mass v0 / Fintype.card C
      = (seqTargets T).mass v0 * (Law.uniform : Law C).mass c0
  simp only [Law.uniform, div_eq_mul_inv, one_mul]

end FT1536.Lazy
