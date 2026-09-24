-- FT1536 adaptive proposal: support analysis (new work, not a frozen stage).
--
-- Frozen facts used as model (not edited):
--   stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/formal/CDF.lean:
--     bank0 nonzero = 29, bank1 = 59, bank2 = 118, bank3 = 235, bank4 = 365.
--   stages/.../source/ft1536-adaptive-cdf-tables.h:
--     nominal variances [5, 20, 80, 320, 768] (5 levels, 512 rows each).
--   stages/.../SUPPORT_AND_METRICS.md:
--     K_C has finite support inside [s_C - 365, s_C + 366];
--     G has strictly positive mass for EVERY integer y, hence K_C << G
--     but NOT G << K_C (witness y = s_C + 367, reverse chi2 = infinity).
--     Kernel witness: GaussianMetrics.finite_support_reverse_failure.
--
-- Consequence: the requested direction
--     target_pdf z > 0 -> proposal_pdf σ z > 0
-- is FALSE for the infinite Gaussian target and the finite proposal.
-- This file formalizes that: target is everywhere-positive, proposal is a
-- finite window per level, the universal coverage claim is refuted with an
-- explicit counterexample, and the true direction (proposal << target) plus
-- the conditioned-target fix are proved. No placeholders, no extra axioms.

def admissible (σ : Nat) : Prop :=
  σ = 5 ∨ σ = 20 ∨ σ = 80 ∨ σ = 320 ∨ σ = 768

def maxK : Nat → Nat
  | 5 => 29
  | 20 => 59
  | 80 => 118
  | 320 => 235
  | 768 => 365
  | _ => 0

-- Support indicator of the finite proposal at level σ (1 on window, 0 off).
def proposal_pdf (σ : Nat) (z : Int) : Nat :=
  if z.natAbs ≤ maxK σ then 1 else 0

-- Model of the scalar Gaussian target G: strictly positive on all of ℤ.
-- (Frozen SUPPORT_AND_METRICS: variance > 0, exp of finite argument > 0,
-- finite positive normalizer, hence G(y) > 0 for every integer y.)
def target_pdf (_ : Int) : Nat := 1

theorem target_pos (z : Int) : target_pdf z > 0 := by
  unfold target_pdf
  omega

theorem proposal_pos_iff (σ : Nat) (z : Int) :
    proposal_pdf σ z > 0 ↔ z.natAbs ≤ maxK σ := by
  unfold proposal_pdf
  split
  · omega
  · omega

theorem maxK_bound (σ : Nat) (h : admissible σ) : maxK σ ≤ 365 := by
  unfold admissible at h
  rcases h with rfl | rfl | rfl | rfl | rfl
  · decide
  · decide
  · decide
  · decide
  · decide

-- Explicit counterexample: z = 1000 lies outside every level window
-- (widest window is 365), so the proposal vanishes while the target is 1.
theorem counterexample_outside (σ : Nat) (h : admissible σ) :
    proposal_pdf σ 1000 = 0 := by
  have hle : maxK σ ≤ 365 := maxK_bound σ h
  unfold proposal_pdf
  have h1000 : (1000 : Int).natAbs = 1000 := by decide
  rw [h1000]
  have hneg : ¬ (1000 ≤ maxK σ) := by omega
  simp [hneg]

-- Requested universal coverage is false.
theorem proposal_covers_support_false :
    ¬ ∀ σ : Nat, admissible σ → ∀ z : Int,
      target_pdf z > 0 → proposal_pdf σ z > 0 := by
  intro h
  have h5 := h 5 (Or.inl rfl) 1000 (target_pos 1000)
  have hz : proposal_pdf 5 1000 = 0 :=
    counterexample_outside 5 (Or.inl rfl)
  omega

-- True direction (already the frozen K_C << G fact): proposal support
-- is contained in target support.
theorem proposal_supported_by_target (σ : Nat) (z : Int)
    (_ : proposal_pdf σ z > 0) : target_pdf z > 0 :=
  target_pos z

-- Conditioned fix: restrict the target to the proposal window S σ;
-- then coverage holds by construction, at the frozen TV cost
-- t = G(S^c) > 0 recorded in SUPPORT_AND_METRICS.md.
def target_cond (σ : Nat) (z : Int) : Nat :=
  if z.natAbs ≤ maxK σ then 1 else 0

theorem conditioned_covers (σ : Nat) (z : Int)
    (h : target_cond σ z > 0) : proposal_pdf σ z > 0 := by
  unfold target_cond at h
  unfold proposal_pdf
  by_cases hc : z.natAbs ≤ maxK σ <;> simp [hc] at h ⊢ <;> omega

#check @target_pos
#check @proposal_pos_iff
#check @maxK_bound
#check @counterexample_outside
#check @proposal_covers_support_false
#check @proposal_supported_by_target
#check @conditioned_covers
#print axioms target_pos
#print axioms proposal_pos_iff
#print axioms maxK_bound
#print axioms counterexample_outside
#print axioms proposal_covers_support_false
#print axioms proposal_supported_by_target
#print axioms conditioned_covers
