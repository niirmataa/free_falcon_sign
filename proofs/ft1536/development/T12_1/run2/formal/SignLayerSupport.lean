import SecondMoment
import Run2.FiberBinding
import Run2.T5ScalarMass
import RejectionBound
import CenteringClosure

/-! # SignLayerSupport — Layer-2 support map for `emit`/`cap` and the AC question

Rung B4/2 (the `delta -> e` core of `notes/S3_E_PROVENANCE.md`): the reply
layer of one `S.run` against the pinned honest law `signBody (syndrome h) c`
(MTISIS stage `FT1536.PublicSimulation`). Deliverables of THIS module (all
kernel-checked, no new model):

1. **Support map** — exact mass formulas and support characterization of
   `signBodyOf` (the `cap 16` retry combinator followed by the `emit`
   encoding) over an arbitrary attempt law, specialized to the pinned
   `signBody A c = signBodyOf (trial A c)`. All `none` cases are carried
   explicitly: the attempt-level miss (`trial`'s `none` = empty-fiber abort
   or an out-of-box norm rejection), the 16-fold exhaustion of `cap`, and
   the encode-failure tag of `emit` (`¬ signed16 z.2`).
2. **AC feasibility and THE wrap-error verdict** — sufficient conditions on a
   sampler reply law `j` for `Divergence.AC j (signBody (syndrome h) c)`, and
   the settled question: the wrap/centering channel (`delta` = the
   probability that a POSITIVE Sign reply is rejected by mathematical
   `Verify`) leaks mass on `some z.2` points of the `emit` image over in-box
   `z` — i.e. INSIDE the support of `signBody`, where the honest law itself
   carries mass (cf. `Run2.BadVerify.emitted_bad_mass`, which exhibits
   positive honest mass on a `Verify`-rejected reply). The channel is a
   Verify-side verdict, not a change of the emitted reply value. Hence the
   pointwise route (`SecondMoment.second_le_of_pointwise`) applies; the
   conservative `SecondMoment.second_cond_le` fallback is not needed for
   this channel. The complementary failure mode (mass outside the `emit`
   image breaks AC and forces `chi2 = ⊤`) is proved as the honest flip side.
3. **Mass comparison pieces** — the per-challenge multiplicative bound
   `j.mass o ≤ (1+d2) * (signBody (syndrome h) c).mass o` is reduced by
   PROVED propagation through `cap`/`map` to a per-attempt bound with factor
   `k` (amplified to `k^16`, hence `e2 = k^32 - 1`). The remaining analytic
   obligations are stated as exact named types (`AttemptPointwise`,
   `ReplyShape`) and are NEVER assumed: `layer2_of_obligations` consumes them
   as premises. Their reduction to the available analytic inputs (T5 machine
   sandwich `t5lo`/`t5hi`, A2/tower mass sandwich at `rowBudget = 2^-46`,
   wrap budgets `tauB`/`rejB`/`boxB`) and the candidate composite factor
   `attemptFactor` are recorded in `notes/B4_LAYER2_WORK_STATE.md`.

No unfinished-proof markers; standard axioms only. Scope boundary: the real
`S.code` (C-side sign sampler) binding is other lanes (B1/source3 per the
B4/2 task boundary); this module works the MODEL side
(`signBody`/`trial`/`cap`/`emit` over `fiberWeight`). Source-bound facts are
cited from `notes/VERIFY_BIND_SIGN_SIDE_NOTES.md` (norm gate `falcon_is_short`
both sides; emission `Extra/c/falcon-sign.c:3412-3418`); the `#error`-enforced
`SIGN_MAX_ATTEMPTS = 16` is pinned in `notes/S3_E_PROVENANCE.md`. All
fiber/attempt statements are over the pinned public-key space
`A : BoxPair → FT1536.Relation.Rq`, `c : FT1536.Relation.Rq`.
-/

namespace FT1536.SignLayerSupport
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry

/-! ## 0. The reply body of an arbitrary attempt law -/

/-- The pinned reply body shape over an arbitrary per-attempt law `jT`:
`cap 16` norm-reject retries, then one `emit` encoding. The pinned honest
body is exactly `signBodyOf (trial A c)` (`signBody_eq_signBodyOf`). -/
noncomputable def signBodyOf (jT : Law (Option BoxPair)) : Law (Option BoxVec) := by
  classical
  exact (MathSign.cap jT 16).map (MathSign.emit emit)

/-- Geometric retry factor of `cap`: `∑_{i < n} miss^i`. -/
noncomputable def geo (jT : Law (Option BoxPair)) (n : ℕ) : ℝ :=
  ∑ i ∈ range n, jT.mass none ^ i

/-- Mass an attempt law sends to the emitted reply `r` through `emit` (the
`emit`-image numerator of the support map). -/
noncomputable def imageMass (jT : Law (Option BoxPair)) (r : Option BoxVec) : ℝ :=
  ∑ z : BoxPair, if emit z = r then jT.mass (some z) else 0

theorem signBody_eq_signBodyOf (A : BoxPair → Relation.Rq) (c : Relation.Rq) :
    signBody A c = signBodyOf (trial A c) := rfl

/-! ## 1. Support map: exact mass formulas -/

/-- Sum of nonnegative terms is positive iff some term is. -/
theorem sum_pos_iff_exists {α : Type*} [Fintype α] (f : α → ℝ) (hn : ∀ x, 0 ≤ f x) :
    0 < ∑ x, f x ↔ ∃ x, 0 < f x := by
  constructor
  · intro h
    by_contra hc
    have hz : ∑ x, f x = 0 :=
      sum_eq_zero (fun x _ => le_antisymm
        (le_of_not_gt (fun hp => hc ⟨x, hp⟩)) (hn x))
    rw [hz] at h
    exact lt_irrefl 0 h
  · exact fun ⟨x, hx⟩ => sum_pos' (fun y _ => hn y) ⟨x, mem_univ x, hx⟩

/-- A strictly positive factor does not change the sign question of a
nonnegative factor. -/
theorem pos_mul_iff {x y : ℝ} (hx : 0 < x) (hy : 0 ≤ y) : (0 < x * y ↔ 0 < y) := by
  constructor
  · intro h
    by_contra hc
    have hz : y = 0 := le_antisymm (le_of_not_gt hc) hy
    rw [hz, mul_zero] at h
    exact lt_irrefl 0 h
  · exact fun h => mul_pos hx h

/-- Sum of two nonnegative terms is positive iff one term is. -/
theorem pos_add_iff {x y : ℝ} (hx : 0 ≤ x) (hy : 0 ≤ y) :
    (0 < x + y ↔ 0 < x ∨ 0 < y) := by
  constructor
  · intro h
    by_contra hc
    have h1 : x = 0 :=
      le_antisymm (le_of_not_gt (fun hp => hc (Or.inl hp))) hx
    have h2 : y = 0 :=
      le_antisymm (le_of_not_gt (fun hp => hc (Or.inr hp))) hy
    rw [h1, h2, add_zero] at h
    exact lt_irrefl 0 h
  · intro h
    rcases h with h | h
    · linarith
    · linarith

theorem geo_pos (jT : Law (Option BoxPair)) {n : ℕ} (hn : 0 < n) : 0 < geo jT n := by
  show 0 < ∑ i ∈ range n, jT.mass none ^ i
  exact sum_pos' (fun i _ => pow_nonneg (jT.nonneg none) i)
    ⟨0, mem_range.mpr hn, by simp⟩

theorem geo16_pos (jT : Law (Option BoxPair)) : 0 < geo jT 16 :=
  geo_pos jT (by norm_num)

theorem imageMass_nonneg (jT : Law (Option BoxPair)) (r : Option BoxVec) :
    0 ≤ imageMass jT r := by
  show 0 ≤ ∑ z : BoxPair, if emit z = r then jT.mass (some z) else 0
  refine sum_nonneg (fun z _ => ?_)
  split_ifs with h
  · exact jT.nonneg (some z)
  · exact le_refl 0

theorem imageMass_term_pos_iff (jT : Law (Option BoxPair)) (r : Option BoxVec)
    (z : BoxPair) :
    (0 < (if emit z = r then jT.mass (some z) else 0)) ↔
      (emit z = r ∧ 0 < jT.mass (some z)) := by
  constructor
  · intro hpos
    by_cases h : emit z = r
    · have key : (if emit z = r then jT.mass (some z) else 0)
          = jT.mass (some z) := by simp [h]
      rw [key] at hpos
      exact ⟨h, hpos⟩
    · have key : (if emit z = r then jT.mass (some z) else 0) = (0:ℝ) := by
        simp [h]
      rw [key] at hpos
      exact absurd hpos (lt_irrefl 0)
  · intro hex
    obtain ⟨he, hp⟩ := hex
    have key : (if emit z = r then jT.mass (some z) else 0)
        = jT.mass (some z) := by simp [he]
    rw [key]
    exact hp

theorem imageMass_pos_iff (jT : Law (Option BoxPair)) (r : Option BoxVec) :
    0 < imageMass jT r ↔ ∃ z : BoxPair, emit z = r ∧ 0 < jT.mass (some z) := by
  show 0 < ∑ z : BoxPair, (if emit z = r then jT.mass (some z) else 0) ↔ _
  rw [sum_pos_iff_exists
    (fun z : BoxPair => if emit z = r then jT.mass (some z) else 0)
    (fun z => by
      split_ifs with h
      · exact jT.nonneg (some z)
      · exact le_refl 0)]
  constructor
  · intro hex
    obtain ⟨z, hz⟩ := hex
    exact ⟨z, (imageMass_term_pos_iff jT r z).1 hz⟩
  · intro hex
    obtain ⟨z, he, hp⟩ := hex
    exact ⟨z, (imageMass_term_pos_iff jT r z).2 ⟨he, hp⟩⟩

/-- Exact mass of the emitted body at `some x`: the `emit` image of the
attempt masses, amplified by the retry factor `geo 16`. -/
theorem signBodyOf_mass_some (jT : Law (Option BoxPair)) (x : BoxVec) :
    (signBodyOf jT).mass (some x) = geo jT 16 * imageMass jT (some x) := by
  classical
  show ((MathSign.cap jT 16).map (MathSign.emit emit)).mass (some x)
      = (∑ i ∈ range 16, jT.mass none ^ i)
          * ∑ z : BoxPair, if emit z = some x then jT.mass (some z) else 0
  rw [Run2.FiberBinding.map_mass, Fintype.sum_option]
  have hnone : (if MathSign.emit emit (none : Option BoxPair) = some x
      then (MathSign.cap jT 16).mass none else (0:ℝ)) = 0 := by
    simp [MathSign.emit]
  rw [hnone, zero_add]
  have hpull : (∑ a : BoxPair, if MathSign.emit emit (some a) = some x
        then (MathSign.cap jT 16).mass (some a) else (0:ℝ))
      = (∑ i ∈ range 16, jT.mass none ^ i)
          * ∑ z : BoxPair, if emit z = some x then jT.mass (some z) else 0 := by
    have hfold : (∑ z : BoxPair, (∑ i ∈ range 16, jT.mass none ^ i)
          * (if emit z = some x then jT.mass (some z) else 0))
        = (∑ i ∈ range 16, jT.mass none ^ i)
            * ∑ z : BoxPair, if emit z = some x then jT.mass (some z) else 0 :=
      (Finset.mul_sum univ
        (fun z : BoxPair => if emit z = some x then jT.mass (some z) else 0)
        (∑ i ∈ range 16, jT.mass none ^ i)).symm
    calc (∑ a : BoxPair, if MathSign.emit emit (some a) = some x
          then (MathSign.cap jT 16).mass (some a) else (0:ℝ))
          = ∑ z : BoxPair, (∑ i ∈ range 16, jT.mass none ^ i)
              * (if emit z = some x then jT.mass (some z) else 0) := by
            apply Finset.sum_congr rfl
            intro z _
            by_cases h : emit z = some x
            · have h1 : MathSign.emit emit (some z) = some x := by
                simp [MathSign.emit, h]
              have h2 : (MathSign.cap jT 16).mass (some z)
                  = (∑ i ∈ range 16, jT.mass none ^ i) * jT.mass (some z) :=
                MathSign.cap_some jT 16 z
              simp [h, h1, h2]
            · have h1 : ¬ MathSign.emit emit (some z) = some x := by
                simp [MathSign.emit, h]
              simp [h, h1]
        _ = (∑ i ∈ range 16, jT.mass none ^ i)
              * ∑ z : BoxPair, if emit z = some x then jT.mass (some z) else 0 := hfold
  exact hpull

/-- Exact mass of the emitted body at `none`: 16-fold exhaustion plus the
encode-failure tag of `emit` (`¬ signed16 z.2`). -/
theorem signBodyOf_mass_none (jT : Law (Option BoxPair)) :
    (signBodyOf jT).mass none
      = jT.mass none ^ 16 + geo jT 16 * imageMass jT none := by
  classical
  show ((MathSign.cap jT 16).map (MathSign.emit emit)).mass none
      = jT.mass none ^ 16
          + (∑ i ∈ range 16, jT.mass none ^ i)
              * ∑ z : BoxPair, if emit z = none then jT.mass (some z) else 0
  rw [Run2.FiberBinding.map_mass, Fintype.sum_option]
  have hnone : (if MathSign.emit emit (none : Option BoxPair) = none
      then (MathSign.cap jT 16).mass none else (0:ℝ)) = jT.mass none ^ 16 := by
    simp [MathSign.emit, MathSign.cap_none]
  rw [hnone]
  have hpull : (∑ a : BoxPair, if MathSign.emit emit (some a) = none
        then (MathSign.cap jT 16).mass (some a) else (0:ℝ))
      = (∑ i ∈ range 16, jT.mass none ^ i)
          * ∑ z : BoxPair, if emit z = none then jT.mass (some z) else 0 := by
    have hfold : (∑ z : BoxPair, (∑ i ∈ range 16, jT.mass none ^ i)
          * (if emit z = none then jT.mass (some z) else 0))
        = (∑ i ∈ range 16, jT.mass none ^ i)
            * ∑ z : BoxPair, if emit z = none then jT.mass (some z) else 0 :=
      (Finset.mul_sum univ
        (fun z : BoxPair => if emit z = none then jT.mass (some z) else 0)
        (∑ i ∈ range 16, jT.mass none ^ i)).symm
    calc (∑ a : BoxPair, if MathSign.emit emit (some a) = none
          then (MathSign.cap jT 16).mass (some a) else (0:ℝ))
          = ∑ z : BoxPair, (∑ i ∈ range 16, jT.mass none ^ i)
              * (if emit z = none then jT.mass (some z) else 0) := by
            apply Finset.sum_congr rfl
            intro z _
            by_cases h : emit z = none
            · have h1 : MathSign.emit emit (some z) = none := by
                simp [MathSign.emit, h]
              have h2 : (MathSign.cap jT 16).mass (some z)
                  = (∑ i ∈ range 16, jT.mass none ^ i) * jT.mass (some z) :=
                MathSign.cap_some jT 16 z
              simp [h, h1, h2]
            · have h1 : ¬ MathSign.emit emit (some z) = none := by
                simp [MathSign.emit, h]
              simp [h, h1]
        _ = (∑ i ∈ range 16, jT.mass none ^ i)
              * ∑ z : BoxPair, if emit z = none then jT.mass (some z) else 0 := hfold
  rw [hpull]

/-! ### Positive-mass patterns of the pinned pieces -/

theorem fiberWeight_pos_iff (A : BoxPair → Relation.Rq) (c : Relation.Rq)
    (z : BoxPair) : 0 < fiberWeight A c z ↔ A z = c := by
  unfold fiberWeight gaussianWeight
  split_ifs with h
  · exact ⟨fun _ => h, fun _ => Real.exp_pos _⟩
  · simp [h]

theorem fiberWeight_eq_zero_iff (A : BoxPair → Relation.Rq) (c : Relation.Rq)
    (z : BoxPair) : fiberWeight A c z = 0 ↔ A z ≠ c := by
  constructor
  · intro h hp
    have := (fiberWeight_pos_iff A c z).2 hp
    rw [h] at this
    exact lt_irrefl 0 this
  · intro h
    exact le_antisymm
      (le_of_not_gt (fun hp => h ((fiberWeight_pos_iff A c z).1 hp)))
      (fiberWeight_nonneg A c z)

theorem emit_eq_some_iff (z : BoxPair) (v : BoxVec) :
    emit z = some v ↔ PublicSimulation.signed16 z.2 ∧ z.2 = v := by
  classical
  change (if PublicSimulation.signed16 z.2 then some z.2 else none) = some v ↔ _
  by_cases h : PublicSimulation.signed16 z.2
  · simp [h]
  · simp [h]

theorem emit_eq_none_iff (z : BoxPair) :
    emit z = none ↔ ¬ PublicSimulation.signed16 z.2 := by
  classical
  change (if PublicSimulation.signed16 z.2 then some z.2 else none) = none ↔ _
  by_cases h : PublicSimulation.signed16 z.2
  · simp [h]
  · simp [h]

/-- One attempt puts mass on `some z` exactly for in-box fiber candidates
(in the pinned model the fiber weights are strictly positive on the fiber). -/
theorem trial_some_pos_iff (A : BoxPair → Relation.Rq) (c : Relation.Rq)
    (z : BoxPair) : 0 < (trial A c).mass (some z) ↔ A z = c ∧ Q (decode z) < B := by
  classical
  by_cases hZ : 0 < ∑ y, fiberWeight A c y
  · rw [Run2.FiberBinding.trial_some A c hZ z]
    have hden : ∀ u : ℝ, (0 < u / ∑ y, fiberWeight A c y ↔ 0 < u) := by
      intro u
      constructor
      · intro h
        by_contra hc
        have hle : u / ∑ y, fiberWeight A c y ≤ 0 :=
          div_nonpos_of_nonpos_of_nonneg (le_of_not_gt hc) hZ.le
        linarith
      · exact fun h => div_pos h hZ
    rw [hden]
    by_cases hq : Q (decode z) < B
    · simp [hq, fiberWeight_pos_iff A c z]
    · simp [hq]
  · rw [RejectionBound.trial_of_empty A c hZ]
    have hmass : (Law.pure none : Law (Option BoxPair)).mass (some z) = 0 := by
      simp [Law.pure]
    rw [hmass]
    simp only [lt_self_iff_false, false_iff]
    intro h
    exact hZ (sum_pos' (fun y _ => fiberWeight_nonneg A c y)
      ⟨z, mem_univ z, (fiberWeight_pos_iff A c z).2 h.1⟩)

/-- One attempt misses (`none`) exactly on a fiber-less target (empty-fiber
abort) or on an out-of-box fiber candidate (norm rejection). -/
theorem trial_none_pos_iff (A : BoxPair → Relation.Rq) (c : Relation.Rq) :
    0 < (trial A c).mass none ↔
      (∃ z : BoxPair, A z = c ∧ ¬ Q (decode z) < B) ∨ (∀ z : BoxPair, A z ≠ c) := by
  classical
  have htail : 0 < RejectionBound.fiberTailMass A c ↔
      ∃ z : BoxPair, A z = c ∧ ¬ Q (decode z) < B := by
    have hnn : ∀ z : BoxPair,
        0 ≤ fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1) := by
      intro z
      split_ifs with h
      · exact mul_nonneg (fiberWeight_nonneg A c z) (le_refl 0)
      · exact mul_nonneg (fiberWeight_nonneg A c z) zero_le_one
    have hterm : ∀ z : BoxPair,
        (0 < fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1)) ↔
          (A z = c ∧ ¬ Q (decode z) < B) := by
      intro z
      by_cases h : Q (decode z) < B
      · have hif : (if Q (decode z) < B then (0:ℝ) else 1) = (0:ℝ) := by
          simp [h]
        rw [hif, mul_zero]
        constructor
        · intro hp
          exact absurd hp (lt_irrefl 0)
        · intro hp
          exact absurd h hp.2
      · have hif : (if Q (decode z) < B then (0:ℝ) else 1) = (1:ℝ) := by
          simp [h]
        rw [hif, mul_one]
        exact ⟨fun hp => ⟨(fiberWeight_pos_iff A c z).1 hp, h⟩,
          fun hp => (fiberWeight_pos_iff A c z).2 hp.1⟩
    show 0 < ∑ z, fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1) ↔ _
    rw [sum_pos_iff_exists _ hnn]
    constructor
    · intro hex
      obtain ⟨z, hz⟩ := hex
      exact ⟨z, (hterm z).1 hz⟩
    · intro hex
      obtain ⟨z, ha, hq⟩ := hex
      exact ⟨z, (hterm z).2 ⟨ha, hq⟩⟩
  rw [RejectionBound.trial_none_mass]
  by_cases hm : 0 < RejectionBound.fiberMass A c
  · have hif :
        (if 0 < RejectionBound.fiberMass A c
          then RejectionBound.fiberTailMass A c / RejectionBound.fiberMass A c
          else (1:ℝ)) = RejectionBound.fiberTailMass A c / RejectionBound.fiberMass A c := by
      simp [hm]
    rw [hif]
    have hden : ∀ u : ℝ, (0 < u / RejectionBound.fiberMass A c ↔ 0 < u) := by
      intro u
      constructor
      · intro h
        by_contra hc
        have hle : u / RejectionBound.fiberMass A c ≤ 0 :=
          div_nonpos_of_nonpos_of_nonneg (le_of_not_gt hc) hm.le
        linarith
      · exact fun h => div_pos h hm
    rw [hden, htail]
    constructor
    · exact Or.inl
    · intro h
      rcases h with h | h
      · exact h
      · obtain ⟨z, hz⟩ :=
          (sum_pos_iff_exists (fun y => fiberWeight A c y)
            (fun y => fiberWeight_nonneg A c y)).1 hm
        exact absurd ((fiberWeight_pos_iff A c z).1 hz) (h z)
  · have hif :
        (if 0 < RejectionBound.fiberMass A c
          then RejectionBound.fiberTailMass A c / RejectionBound.fiberMass A c
          else (1:ℝ)) = (1:ℝ) := by
      simp [hm]
    rw [hif]
    simp only [zero_lt_one, true_iff]
    apply Or.inr
    intro z hz
    exact hm (sum_pos' (fun y _ => fiberWeight_nonneg A c y)
      ⟨z, mem_univ z, (fiberWeight_pos_iff A c z).2 hz⟩)

/-! ## 2. Support of the pinned `signBody` -/

/-- Support map, positive side: `some v` carries mass exactly for the `emit`
image of in-box fiber candidates over `c`. -/
theorem signBody_some_pos_iff (A : BoxPair → Relation.Rq) (c : Relation.Rq)
    (v : BoxVec) :
    0 < (signBody A c).mass (some v) ↔
      ∃ z : BoxPair, A z = c ∧ Q (decode z) < B ∧ emit z = some v := by
  classical
  rw [signBody_eq_signBodyOf A c, signBodyOf_mass_some (trial A c) v,
    pos_mul_iff (geo16_pos (trial A c)) (imageMass_nonneg (trial A c) (some v)),
    imageMass_pos_iff (trial A c) (some v)]
  constructor
  · intro hex
    obtain ⟨z, he, hp⟩ := hex
    exact ⟨z, ((trial_some_pos_iff A c z).1 hp).1,
      ((trial_some_pos_iff A c z).1 hp).2, he⟩
  · intro hex
    obtain ⟨z, ha, hq, he⟩ := hex
    exact ⟨z, he, (trial_some_pos_iff A c z).2 ⟨ha, hq⟩⟩

/-- Support map in candidate form: `some v` carries mass exactly when some
fiber candidate `(z1, v)` over `c` is in-box and `v` is encodable
(`signed16`). -/
theorem signBody_some_pos_iff_signed16 (A : BoxPair → Relation.Rq) (c : Relation.Rq)
    (v : BoxVec) :
    0 < (signBody A c).mass (some v) ↔
      ∃ z1 : BoxVec, A (z1, v) = c ∧ Q (decode (z1, v)) < B
        ∧ PublicSimulation.signed16 v := by
  classical
  rw [signBody_some_pos_iff A c v]
  constructor
  · intro hex
    obtain ⟨z, ha, hq, he⟩ := hex
    obtain ⟨hs, hv⟩ := (emit_eq_some_iff z v).1 he
    subst hv
    exact ⟨z.1, ha, hq, hs⟩
  · intro hex
    obtain ⟨z1, ha, hq, hs⟩ := hex
    exact ⟨(z1, v), ha, hq, (emit_eq_some_iff (z1, v) v).2 ⟨hs, rfl⟩⟩

/-- Support map, miss side: `none` carries mass exactly through 16-fold
exhaustion of the attempt-level miss, or through the encode-failure tag of
`emit` on an in-box fiber candidate. -/
theorem signBody_none_pos_iff (A : BoxPair → Relation.Rq) (c : Relation.Rq) :
    0 < (signBody A c).mass none ↔
      (0 < (trial A c).mass none ∨
        ∃ z : BoxPair, A z = c ∧ Q (decode z) < B ∧ ¬ PublicSimulation.signed16 z.2) := by
  classical
  rw [signBody_eq_signBodyOf A c, signBodyOf_mass_none (trial A c)]
  have hmnn : 0 ≤ (trial A c).mass none ^ 16 := pow_nonneg ((trial A c).nonneg none) 16
  have hmul := pos_mul_iff (geo16_pos (trial A c)) (imageMass_nonneg (trial A c) none)
  rw [pos_add_iff hmnn (mul_nonneg (geo16_pos (trial A c)).le
    (imageMass_nonneg (trial A c) none))]
  have hpow : (0 < (trial A c).mass none ^ 16 ↔ 0 < (trial A c).mass none) := by
    constructor
    · intro h
      by_contra hc
      have hz : (trial A c).mass none = 0 :=
        le_antisymm (le_of_not_gt hc) ((trial A c).nonneg none)
      rw [hz, zero_pow (by norm_num : (16:ℕ) ≠ 0)] at h
      exact lt_irrefl 0 h
    · exact fun h => pow_pos h 16
  rw [hpow, hmul, imageMass_pos_iff (trial A c) none]
  constructor
  · intro h
    rcases h with h | hex
    · exact Or.inl h
    · obtain ⟨z, he, hp⟩ := hex
      exact Or.inr ⟨z, ((trial_some_pos_iff A c z).1 hp).1,
        ((trial_some_pos_iff A c z).1 hp).2, (emit_eq_none_iff z).1 he⟩
  · intro h
    rcases h with h | hex
    · exact Or.inl h
    · obtain ⟨z, ha, hq, hs⟩ := hex
      exact Or.inr ⟨z, (emit_eq_none_iff z).2 hs,
        (trial_some_pos_iff A c z).2 ⟨ha, hq⟩⟩

/-! ## 3. AC feasibility and the wrap-error verdict -/

/-- Support-level AC criterion: absolute continuity holds as soon as the real
reply law concentrates on the support map of Part 2 (miss point covered, and
every positive reply inside the `emit` image of in-box fiber candidates). -/
theorem ac_of_reply_support (j : Law (Option BoxVec)) (A : BoxPair → Relation.Rq)
    (c : Relation.Rq)
    (hnone : j.mass none ≠ 0 → (signBody A c).mass none ≠ 0)
    (hsome : ∀ v : BoxVec, j.mass (some v) ≠ 0 →
      ∃ z : BoxPair, A z = c ∧ Q (decode z) < B ∧ emit z = some v) :
    Divergence.AC j (signBody A c) := by
  intro x hx
  by_contra hj
  cases x with
  | none => exact hnone hj hx
  | some v =>
    have hex := hsome v hj
    have hpos : 0 < (signBody A c).mass (some v) :=
      (signBody_some_pos_iff A c v).2 hex
    exact (ne_of_gt hpos) hx

/-- THE wrap-error verdict (kernel form): every positive reply emitted from
an accepted candidate `z` carries STRICTLY POSITIVE `signBody` mass at its own
challenge `A z` — independently of whether mathematical `Verify` accepts the
reply. The wrap/centering channel is a Verify-side verdict on the emitted
reply value, not a change of that value, so its `delta` mass lands INSIDE the
support of `signBody` (the `some z` image of `emit` over in-box `z`). -/
theorem emitted_reply_supported (A : BoxPair → Relation.Rq) (z : BoxPair)
    (hz : Q (decode z) < B) (hs : PublicSimulation.signed16 z.2) :
    0 < (signBody A (A z)).mass (some z.2) := by
  classical
  exact (signBody_some_pos_iff A (A z) z.2).2
    ⟨z, rfl, hz, (emit_eq_some_iff z z.2).2 ⟨hs, rfl⟩⟩

/-- Wrap-error verdict at the pinned comparison pair: the leaked `delta` mass
of a positive Sign reply rejected by mathematical `Verify` is on points where
`signBody (syndrome h) (syndrome h z)` has positive mass. Combined with
`Run2.BadVerify.emitted_bad_mass` (the honest law itself carries mass on
`Verify`-rejected replies) this settles the question of
`notes/S3_E_PROVENANCE.md`: the pointwise route applies, not the conservative
`second_cond_le` conditioning route. -/
theorem wrap_channel_in_support (h : Relation.Rq) (z : BoxPair)
    (hz : Q (decode z) < B) (hs : PublicSimulation.signed16 z.2) :
    0 < (signBody (SigmaMath.syndrome h) (SigmaMath.syndrome h z)).mass (some z.2) :=
  emitted_reply_supported (SigmaMath.syndrome h) z hz hs

/-- Complementary failure mode (the honest flip side of the verdict): a real
reply law with mass OUTSIDE the `emit` image (e.g. a byte-bridge decode
artifact landing on a non-encodable tail, or on a tail outside the fiber
image) breaks AC and `Divergence.chi2 = ⊤`; only the conservative
`SecondMoment.second_cond_le` route would survive there. -/
theorem chi2_top_of_out_of_support (j : Law (Option BoxVec))
    (A : BoxPair → Relation.Rq) (c : Relation.Rq)
    (v : BoxVec) (hj : j.mass (some v) ≠ 0)
    (hout : ∀ z : BoxPair,
      A z ≠ c ∨ ¬ Q (decode z) < B ∨ ¬ emit z = some v) :
    Divergence.chi2 j (signBody A c) = ⊤ := by
  classical
  have hp : (signBody A c).mass (some v) = 0 := by
    by_contra hc
    have hpos : 0 < (signBody A c).mass (some v) :=
      lt_of_le_of_ne ((signBody A c).nonneg (some v)) (Ne.symm hc)
    obtain ⟨z, ha, hq, he⟩ := (signBody_some_pos_iff A c v).1 hpos
    rcases hout z with h | h | h
    · exact h ha
    · exact h hq
    · exact h he
  exact Divergence.support_mismatch j (signBody A c) (some v) hp hj

/-! ## 4. Mass comparison pieces: per-attempt bound -> per-challenge bound -/

/-- Base-monotonicity of `x ^ n` on `ℝ` at nonnegative base. -/
theorem pow_mono_base {x y : ℝ} (h : x ≤ y) (hx : 0 ≤ x) (n : ℕ) :
    x ^ n ≤ y ^ n := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [pow_succ, pow_succ]
    exact mul_le_mul ih h hx (pow_nonneg (le_trans hx h) n)

/-- Exponent-monotonicity of `k ^ n` for `1 ≤ k`. -/
theorem pow_mono_exp {k : ℝ} (hk : 1 ≤ k) {i j : ℕ} (hij : i ≤ j) :
    k ^ i ≤ k ^ j := by
  obtain ⟨d, hd⟩ := Nat.exists_eq_add_of_le hij
  subst hd
  clear hij
  rw [pow_add]
  have h1 : (1:ℝ) ≤ k ^ d := by
    induction d with
    | zero => simp
    | succ n ih =>
      rw [pow_succ]
      have hstep := mul_le_mul ih hk (by norm_num)
        (pow_nonneg (le_trans zero_le_one hk) n)
      simpa using hstep
  have hstep := mul_le_mul_of_nonneg_left h1
    (pow_nonneg (le_trans zero_le_one hk) i)
  simpa using hstep

/-- A pointwise mass bound survives `Law.map` (deterministic post-processing). -/
theorem map_le_of_pointwise {α β : Type} [Fintype α] [DecidableEq α]
    [Fintype β] [DecidableEq β] (p q : Law α) (k : ℝ) (f : α → β)
    (hk : 0 ≤ k) (hpt : ∀ x, p.mass x ≤ k * q.mass x) (y : β) :
    (p.map f).mass y ≤ k * (q.map f).mass y := by
  rw [Run2.FiberBinding.map_mass, Run2.FiberBinding.map_mass]
  have hterm : ∀ x, (if f x = y then p.mass x else 0)
      ≤ k * (if f x = y then q.mass x else 0) := by
    intro x
    split_ifs with h
    · exact hpt x
    · exact mul_nonneg hk (le_refl 0)
  calc (∑ x, if f x = y then p.mass x else 0)
        ≤ ∑ x, k * (if f x = y then q.mass x else 0) :=
          sum_le_sum (fun x _ => hterm x)
    _ = k * ∑ x, if f x = y then q.mass x else 0 :=
          (Finset.mul_sum univ (fun x => if f x = y then q.mass x else 0) k).symm

/-- The `cap` retry combinator amplifies a per-attempt factor `k` to `k^n`:
the miss powers contribute `k^(n-1)` and the retained attempt `k`. -/
theorem cap_le_of_pointwise {α : Type} [Fintype α] [DecidableEq α]
    (jT pT : Law (Option α)) (k : ℝ) (n : ℕ)
    (hk : 1 ≤ k) (hpt : ∀ o, jT.mass o ≤ k * pT.mass o) (o : Option α) :
    (MathSign.cap jT n).mass o ≤ k ^ n * (MathSign.cap pT n).mass o := by
  cases o with
  | none =>
    rw [MathSign.cap_none, MathSign.cap_none]
    calc jT.mass none ^ n ≤ (k * pT.mass none) ^ n :=
        pow_mono_base (hpt none) (jT.nonneg none) n
      _ = k ^ n * pT.mass none ^ n := mul_pow k (pT.mass none) n
  | some x =>
    rcases n with _ | m
    · rw [MathSign.cap_some, MathSign.cap_some]
      simp
    · rw [MathSign.cap_some, MathSign.cap_some]
      have hgeo : (∑ i ∈ range (m+1), jT.mass none ^ i)
          ≤ k ^ m * ∑ i ∈ range (m+1), pT.mass none ^ i := by
        calc (∑ i ∈ range (m+1), jT.mass none ^ i)
            ≤ ∑ i ∈ range (m+1), (k * pT.mass none) ^ i :=
              sum_le_sum (fun i _ =>
                pow_mono_base (hpt none) (jT.nonneg none) i)
          _ = ∑ i ∈ range (m+1), k ^ i * pT.mass none ^ i := by
              simp only [mul_pow]
          _ ≤ ∑ i ∈ range (m+1), k ^ m * pT.mass none ^ i :=
              sum_le_sum (fun i hi => mul_le_mul_of_nonneg_right
                (pow_mono_exp hk (Nat.le_of_lt_succ (mem_range.mp hi)))
                (pow_nonneg (pT.nonneg none) i))
          _ = k ^ m * ∑ i ∈ range (m+1), pT.mass none ^ i :=
              (Finset.mul_sum (range (m+1))
                (fun i => pT.mass none ^ i) (k ^ m)).symm
      calc (∑ i ∈ range (m+1), jT.mass none ^ i) * jT.mass (some x)
            ≤ (k ^ m * ∑ i ∈ range (m+1), pT.mass none ^ i)
                * (k * pT.mass (some x)) :=
              mul_le_mul hgeo (hpt (some x))
                (jT.nonneg (some x))
                (mul_nonneg (pow_nonneg (le_trans zero_le_one hk) m)
                  (sum_nonneg (fun i _ => pow_nonneg (pT.nonneg none) i)))
        _ = k ^ (m+1)
              * ((∑ i ∈ range (m+1), pT.mass none ^ i) * pT.mass (some x)) := by
              rw [pow_succ]
              ring

/-- THE propagation step: the reply body of `jT` is within `k^16` of the reply
body of `pT` pointwise (miss point included), whenever the attempt laws are
within `k` pointwise. -/
theorem signBodyOf_le_of_attempt_le (jT pT : Law (Option BoxPair)) (k : ℝ)
    (hk : 1 ≤ k) (hpt : ∀ o, jT.mass o ≤ k * pT.mass o) (o : Option BoxVec) :
    (signBodyOf jT).mass o ≤ k ^ 16 * (signBodyOf pT).mass o := by
  classical
  show ((MathSign.cap jT 16).map (MathSign.emit emit)).mass o
      ≤ k ^ 16 * ((MathSign.cap pT 16).map (MathSign.emit emit)).mass o
  exact map_le_of_pointwise (MathSign.cap jT 16) (MathSign.cap pT 16) (k ^ 16)
    (MathSign.emit emit) (pow_nonneg (le_trans zero_le_one hk) 16)
    (fun z => cap_le_of_pointwise jT pT k 16 hk hpt z) o

/-! ## 5. Named analytic obligations (exact types, NEVER assumed) -/

/-- NAMED OBLIGATION `AttemptPointwise` — the per-attempt multiplicative mass
comparison of the real sampler's attempt law `jT` against the pinned fiber
law `trial A c`, both on every candidate `some z` and on the miss point
(`none` = empty-fiber abort or out-of-box norm rejection). This is THE
remaining analytic input of Layer 2. Its reduction to the available inputs
(T5 machine sandwich `FT1536.CenteringClosure.t5lo`/`t5hi`, A2/tower mass
sandwich `a2Tower_mass_bounds` at `rowBudget = 2^-46`, wrap budgets `tauB`,
`rejB`, `boxB`; candidate composite `attemptFactor` below) is recorded in
`notes/B4_LAYER2_WORK_STATE.md`. This module consumes the obligation as a
premise only and never assumes it. -/
structure AttemptPointwise (jT : Law (Option BoxPair)) (A : BoxPair → Relation.Rq)
    (c : Relation.Rq) (k : ℝ) : Prop where
  some_le : ∀ z : BoxPair, jT.mass (some z) ≤ k * (trial A c).mass (some z)
  none_le : jT.mass none ≤ k * (trial A c).mass none

/-- NAMED OBLIGATION `ReplyShape` — identification of the real reply law `j`
with the pinned body `signBodyOf jT` over its own attempt law. Source-bound:
the `cap 16` loop is `SIGN_MAX_ATTEMPTS = 16` (enforced in `Extra/c` by
`#error`, pinned in `notes/S3_E_PROVENANCE.md`) and the emission is
`Extra/c/falcon-sign.c:3412-3418`
(`notes/VERIFY_BIND_SIGN_SIDE_NOTES.md`); the binding of `S.code` itself is
other lanes (B1/source3 per the B4/2 task boundary). -/
def ReplyShape (j : Law (Option BoxVec)) (jT : Law (Option BoxPair)) : Prop :=
  ∀ o : Option BoxVec, j.mass o = (signBodyOf jT).mass o

/-- The per-attempt comparison stated over all `Option` points. -/
theorem attemptPointwise_le {A : BoxPair → Relation.Rq} {c : Relation.Rq}
    {jT : Law (Option BoxPair)} {k : ℝ} (h : AttemptPointwise jT A c k) :
    ∀ o : Option BoxPair, jT.mass o ≤ k * (trial A c).mass o := by
  intro o
  cases o with
  | none => exact h.none_le
  | some z => exact h.some_le z

/-- THE Layer-2 chi-square factor from a per-attempt factor `k`: `e2 = k^32 - 1`. -/
noncomputable def e2 (k : ℝ) : ℝ := (k ^ 16) ^ 2 - 1

/-- THE Layer-2 reduction (per challenge): from the two named obligations
(plus the side condition `1 ≤ k`), the real reply law of one `S.run`
satisfies `Divergence.AC` and `Divergence.second j (signBody A c) ≤ 1 + e2 k`
with `e2 k = k^32 - 1`. This is the promised per-challenge bound of the
`delta -> e` composition; Layer 1 (challenge marginal vs `Law.uniform`) and
the joint composition are rung B4/1 (`formal/JointDecomp.lean`,
`SecondMoment.second_joint_le`). -/
theorem layer2_of_obligations (j : Law (Option BoxVec)) (jT : Law (Option BoxPair))
    (A : BoxPair → Relation.Rq) (c : Relation.Rq) (k : ℝ) (hk : 1 ≤ k)
    (hshape : ReplyShape j jT) (hattempt : AttemptPointwise jT A c k) :
    Divergence.AC j (signBody A c) ∧
      Divergence.second j (signBody A c) ≤ 1 + e2 k := by
  classical
  have hj : j = signBodyOf jT := Run2.FiberBinding.law_ext j (signBodyOf jT) hshape
  have hp : signBody A c = signBodyOf (trial A c) := signBody_eq_signBodyOf A c
  have hpt : ∀ o, (signBodyOf jT).mass o ≤ k ^ 16 * (signBodyOf (trial A c)).mass o :=
    fun o => signBodyOf_le_of_attempt_le jT (trial A c) k hk
      (attemptPointwise_le hattempt) o
  have hd : 0 ≤ k ^ 16 - 1 := by
    have h1 : (1:ℝ) ≤ k ^ 16 := pow_mono_exp hk (Nat.zero_le 16)
    linarith
  have hpt' : ∀ o, (signBodyOf jT).mass o
      ≤ (1 + (k ^ 16 - 1)) * (signBodyOf (trial A c)).mass o := by
    intro o
    rw [show (1 + (k ^ 16 - 1)) = k ^ 16 by ring]
    exact hpt o
  constructor
  · rw [hj, hp]
    exact SecondMoment.ac_of_pointwise (signBodyOf jT) (signBodyOf (trial A c))
      (fun o => hpt' o)
  · rw [hj, hp]
    have hm := SecondMoment.second_le_of_pointwise (signBodyOf jT)
      (signBodyOf (trial A c)) (k ^ 16 - 1) hd (fun o => hpt' o)
    have he : (1 + (k ^ 16 - 1)) ^ 2 = 1 + e2 k := by
      show (1 + (k ^ 16 - 1)) ^ 2 = 1 + ((k ^ 16) ^ 2 - 1)
      rw [show (1 + (k ^ 16 - 1)) = k ^ 16 by ring]
      ring
    rw [← he]
    exact hm

/-! ## 6. Available budget inputs (kernel-pinned) and the candidate composite -/

/-- T5 machine-rounding multiplicative sandwich ratio (the `t5lo`/`t5hi`
family of `FT1536.CenteringClosure`, kernel `t5_leaf_floor_gt`). -/
noncomputable def machineMargin : ℝ :=
  (CenteringClosure.t5hi : ℝ) / CenteringClosure.t5lo

theorem machineMargin_lt : machineMargin < 1 + 1 / 4398046511104 := by
  norm_num [machineMargin, CenteringClosure.t5hi, CenteringClosure.t5lo,
    CenteringClosure.t5plus, CenteringClosure.t5minus, CenteringClosure.u]

theorem machineMargin_one_le : 1 ≤ machineMargin := by
  norm_num [machineMargin, CenteringClosure.t5hi, CenteringClosure.t5lo,
    CenteringClosure.t5plus, CenteringClosure.t5minus, CenteringClosure.u]

/-- A2/tower mass-sandwich margin at the kernel budget `rowBudget = 2^-46`
(`ConvStruct.a2Tower_mass_bounds` via
`TriangularGaussian.triangular_mass_bounds`, `T5ScalarMass.dimension_margins`). -/
noncomputable def towerMargin : ℝ :=
  ((1 + Run2.T5ScalarMass.rowBudget) / (1 - Run2.T5ScalarMass.rowBudget)) ^ 2

theorem towerMargin_lt : towerMargin < 1 + 1 / 8796093022208 := by
  norm_num [towerMargin, Run2.T5ScalarMass.rowBudget]

theorem towerMargin_one_le : 1 ≤ towerMargin := by
  norm_num [towerMargin, Run2.T5ScalarMass.rowBudget]

/-- Candidate composite per-attempt factor — the UPPER TARGET of the pending
analytic reduction `AttemptPointwise` (NOT proved here to bound the real
sampler): the T5 machine sandwich, the A2/tower mass sandwich, and the wrap
budgets `tauB` (centering) and `boxB` (box truncation). The rejection budget
`rejB = 2^-24` is the miss-mass budget consumed by the conditioning fallback
`SecondMoment.second_cond_le` and by the `delta` bridge
(`CenteringClosure.bridgeUb`), not a per-attempt factor. -/
noncomputable def attemptFactor : ℝ :=
  machineMargin * towerMargin
    * ((1 + (CenteringClosure.tauB : ℝ)) / (1 - CenteringClosure.tauB))
    * (1 / (1 - (CenteringClosure.boxB : ℝ)))

theorem attemptFactor_one_le : 1 ≤ attemptFactor := by
  norm_num [attemptFactor, machineMargin, towerMargin, Run2.T5ScalarMass.rowBudget,
    CenteringClosure.tauB, CenteringClosure.boxB,
    CenteringClosure.t5hi, CenteringClosure.t5lo,
    CenteringClosure.t5plus, CenteringClosure.t5minus, CenteringClosure.u]

theorem attemptFactor_lt : attemptFactor < 1 + 1 / 274877906944 := by
  norm_num [attemptFactor, machineMargin, towerMargin, Run2.T5ScalarMass.rowBudget,
    CenteringClosure.tauB, CenteringClosure.boxB,
    CenteringClosure.t5hi, CenteringClosure.t5lo,
    CenteringClosure.t5plus, CenteringClosure.t5minus, CenteringClosure.u]

/-- Real variant of the `(1+a)^n ≤ 1 + 2na` budget step (mirror of
`FT1536.CenteringClosure.pow_succ_le`, on `ℝ`). -/
theorem pow_succ_le_real (a : ℝ) (ha : 0 ≤ a) :
    ∀ n : ℕ, 2 * (n:ℝ) * a ≤ 1 → (1 + a) ^ n ≤ 1 + 2 * (n:ℝ) * a := by
  intro n
  induction n with
  | zero => intro _; simp
  | succ n ih =>
    intro h
    have hnn : (2:ℝ) * (n:ℝ) * a ≤ 1 := by
      have h' := h
      simp only [Nat.cast_succ] at h' ⊢
      nlinarith
    calc (1 + a) ^ n.succ = (1 + a) ^ n * (1 + a) := by rw [pow_succ]
      _ ≤ (1 + 2 * (n:ℝ) * a) * (1 + a) :=
        mul_le_mul_of_nonneg_right (ih hnn) (by nlinarith)
      _ ≤ 1 + 2 * (n.succ:ℝ) * a := by
        push_cast
        nlinarith

/-- Budget arithmetic of the candidate composite: were `AttemptPointwise`
delivered at `k = attemptFactor`, the Layer-2 factor would satisfy
`e2 < 2^-32` (conditional corollary, kernel-checked). -/
theorem e2_attemptFactor_lt : e2 attemptFactor < 1 / 4294967296 := by
  show (attemptFactor ^ 16) ^ 2 - 1 < 1 / 4294967296
  have hlt : attemptFactor - 1 < 1 / 274877906944 := by
    have := attemptFactor_lt
    linarith
  have ha : 0 ≤ attemptFactor - 1 := by
    have := attemptFactor_one_le
    linarith
  have h32 : 2 * (32:ℝ) * (attemptFactor - 1) ≤ 1 := by
    have hle : (2:ℝ) * 32 * (1 / 274877906944) ≤ 1 := by norm_num
    nlinarith
  have hle := pow_succ_le_real (attemptFactor - 1) ha 32 h32
  have hle' : (1 + (attemptFactor - 1)) ^ 32 - 1
      ≤ 2 * (32:ℝ) * (attemptFactor - 1) := by
    have := hle
    push_cast at this
    nlinarith
  have hrew : (1 + (attemptFactor - 1)) ^ 32 = (attemptFactor ^ 16) ^ 2 := by
    have h1 : (1:ℝ) + (attemptFactor - 1) = attemptFactor := by ring
    rw [h1, ← pow_mul]
  rw [← hrew]
  have hz : (2:ℝ) * 32 * (attemptFactor - 1) < 2 * 32 * (1 / 274877906944) :=
    mul_lt_mul_of_pos_left hlt (by norm_num)
  have hc : (2:ℝ) * 32 * (1 / 274877906944) = 1 / 4294967296 := by norm_num
  nlinarith

end FT1536.SignLayerSupport
