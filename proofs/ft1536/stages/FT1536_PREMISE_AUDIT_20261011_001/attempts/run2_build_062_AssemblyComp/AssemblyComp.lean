import CompPrg

/-! # AssemblyComp — public-simulation bounds and the exact generalized Phi inverse

B2/B5 corrections E1–E5. The principal export
`advMT_ge_of_public_sim_stream_win` concerns `AdvPublicSimStream`, not honest
`Games.AdvEUF`. It gives `AdvMT >= max 0 (epsilon_stream - deltaPRG)` together
with the certified test-cost line. The hop consumes `CompPRGBound` directly,
then `streamGame_uniform_eq_advMT` identifies the public fair-tape game.

The key laws on the two sides are explicit: the stream game uses `muEmitted`,
the MT experiment uses `muKey`. `KeyLawBinding.identify hkey` supplies their
equality and is used to rewrite the MT law. B1.10 owns the eventual exact
proposition `keyIdent` AND its law-binding proof. Setting `keyIdent := True`
does not supply a binding between arbitrary unequal key laws.

The exports named `phi_weakening` are deliberately weaker consequences for
PUBLIC SIMULATION, with arbitrary `D >= 0`. Here D is not a B4 certificate.
The honest-game comparison instead consumes `LocalJointCertificate S e`
through `Run2.concrete_euf_cma_to_mt_isis`, giving `D = (1+e)^beta.qs - 1`.
The computational assembly still needs a tape-parametrized honest signer,
its certified winning test, and a proved fair-tape binding to `Games.runEUF`.
Only then can its hop be composed with that second-moment comparison.

`phiInv` is total using Lean's `Real.sqrt` (zero on negative arguments).
For D >= 0 and a <= 1 its ordinary-real presentation is
0 if a <= D/(1+D), and a - sqrt(D*a*(1-a)) otherwise; the second branch has
nonnegative radicand. The direct bound dominates this inverse only after
clipping the direct bound at zero (`phiInv_le_clipped_direct`).
-/

namespace FT1536.AssemblyComp
open Finset FT1536 FT1536.Run2 FT1536.Relation
open FT1536.CompPrg

/-! ## 1. The exact inversion of `FT1536.EventTransfer.phi` -/

/-- THE exact inverse of `FT1536.EventTransfer.phi` at level `a` — the
review's `max{0, a - sqrt(D * a * (1 - a))}` shape, checked against the
repo's `phi`. For `b ∈ [0,1]` and `D ≥ 0` the equation `a = phi D b` is
solved exactly by `b = a - sqrt(D * a * (1 - a))` on its branch
(`EventTransfer.phi_satisfies` with `EventTransfer.phi_ge_b`), clamped at
zero below the boundary `phi D 0 = D/(1+D)`. `Real.sqrt` is total and is
zero on negative arguments; `phiInv_piecewise` gives the ordinary-real
formula for `D >= 0`, `a <= 1`. No inverse claim is made for `a > 1`. -/
noncomputable def phiInv (D a : ℝ) : ℝ := max 0 (a - Real.sqrt (D * a * (1 - a)))

/-- THE exact `Phi` inversion (kernelized): `a ≤ phi D b`, `0 ≤ D`,
`0 ≤ b ≤ 1` imply `phiInv D a ≤ b`. The inverse is SHARP: at
`a = phi D b` the identity `b = a - sqrt(D * a * (1 - a))` holds with
equality. -/
theorem phi_inv_le {D a b : ℝ} (hD : 0 ≤ D) (hb0 : 0 ≤ b) (hb1 : b ≤ 1)
    (h : a ≤ EventTransfer.phi D b) : phiInv D a ≤ b := by
  by_cases hab : a ≤ b
  · have hsq : 0 ≤ Real.sqrt (D * a * (1 - a)) := Real.sqrt_nonneg _
    have hle : a - Real.sqrt (D * a * (1 - a)) ≤ b := by linarith
    exact max_le hb0 hle
  have hba : b < a := lt_of_not_ge hab
  set p : ℝ := EventTransfer.phi D b
  have hge : b ≤ p := EventTransfer.phi_ge_b hD hb0 hb1
  have hple : p ≤ 1 := EventTransfer.phi_le_one hD hb0 hb1
  have hsat : (p - b) ^ 2 = D * p * (1 - p) := EventTransfer.phi_satisfies hD hb0 hb1
  -- the quadratic identity for `q x = D*x*(1-x) - (x-b)^2` at `b, a, p`
  have hident : (p - b) * (D * a * (1 - a) - (a - b) ^ 2)
      = (p - a) * (D * b * (1 - b) - (b - b) ^ 2)
        + (a - b) * (D * p * (1 - p) - (p - b) ^ 2)
        + (1 + D) * (p - a) * (a - b) * (p - b) := by ring
  have hqp : D * p * (1 - p) - (p - b) ^ 2 = 0 := by linarith
  have hqb : 0 ≤ D * b * (1 - b) - (b - b) ^ 2 := by
    have h0 : (b - b : ℝ) ^ 2 = 0 := by ring
    rw [h0, sub_zero]
    exact mul_nonneg (mul_nonneg hD hb0) (sub_nonneg.mpr hb1)
  have h4 : 0 ≤ (p - a) * (D * b * (1 - b) - (b - b) ^ 2) :=
    mul_nonneg (by linarith) hqb
  have h3 : 0 ≤ (1 + D) * (p - a) * (a - b) * (p - b) :=
    mul_nonneg (mul_nonneg (mul_nonneg (by linarith) (by linarith))
      (le_of_lt (sub_pos.mpr hba))) (by linarith)
  have h5 : (a - b) * (D * p * (1 - p) - (p - b) ^ 2) = (0:ℝ) := by
    rw [hqp]
    ring
  have hsum : 0 ≤ (p - a) * (D * b * (1 - b) - (b - b) ^ 2)
      + (a - b) * (D * p * (1 - p) - (p - b) ^ 2)
      + (1 + D) * (p - a) * (a - b) * (p - b) := by linarith
  have hpb : 0 < p - b := by linarith
  have hprod : (p - b) * 0 ≤ (p - b) * (D * a * (1 - a) - (a - b) ^ 2) := by
    rw [mul_zero, hident]
    exact hsum
  have hq : 0 ≤ D * a * (1 - a) - (a - b) ^ 2 :=
    le_of_mul_le_mul_left hprod hpb
  have hs : (a - b) ^ 2 ≤ D * a * (1 - a) := by linarith
  have hsqab : Real.sqrt ((a - b) ^ 2) = a - b := by
    rw [Real.sqrt_sq_eq_abs, abs_of_nonneg (le_of_lt (sub_pos.mpr hba))]
  have hsqrt : a - b ≤ Real.sqrt (D * a * (1 - a)) := by
    rw [← hsqab]
    exact Real.sqrt_le_sqrt hs
  have hle : a - Real.sqrt (D * a * (1 - a)) ≤ b := by linarith
  exact max_le hb0 hle

/-- Boundary sanity of the inversion at the task's requested check point:
`phiInv D (D / (1 + D)) = 0` — the exact inverse at `b = 0`, consistent with
the already-present `FT1536.EventTransfer.phi_at_zero : phi D 0 = D/(1+D)`. -/
theorem phiInv_at_phi_zero (D : ℝ) :
    phiInv D (D / (1 + D)) = 0 := by
  by_cases hd : 1 + D = 0
  · rw [hd, div_zero]
    unfold phiInv
    simp
  have hkey : D * (D / (1 + D)) * (1 - D / (1 + D)) = (D / (1 + D)) ^ 2 := by
    field_simp [hd]
    ring
  have hsq : Real.sqrt (D * (D / (1 + D)) * (1 - D / (1 + D)))
      = |D / (1 + D)| := by
    rw [hkey, Real.sqrt_sq_eq_abs]
  unfold phiInv
  rw [hsq]
  have hx : (D / (1 + D)) - |D / (1 + D)| ≤ 0 := by
    by_cases h2 : 0 ≤ D / (1 + D)
    · rw [abs_of_nonneg h2]
      linarith
    · rw [abs_of_neg (lt_of_not_ge h2)]
      linarith
  exact max_eq_left hx

/-- The already-present boundary fact, re-exported at the seam
(`FT1536.EventTransfer.phi_at_zero`): `phi D 0 = D / (1 + D)`. -/
theorem phi_at_zero_export {D : ℝ} (hD : 0 ≤ D) :
    EventTransfer.phi D 0 = D / (1 + D) :=
  EventTransfer.phi_at_zero hD

/-- Sharpness at every point of the Phi branch, not just its zero boundary. -/
theorem phiInv_at_phi {D b : ℝ} (hD : 0 ≤ D) (hb0 : 0 ≤ b) (hb1 : b ≤ 1) :
    phiInv D (EventTransfer.phi D b) = b := by
  have hge := EventTransfer.phi_ge_b hD hb0 hb1
  have hs : Real.sqrt (D * EventTransfer.phi D b * (1 - EventTransfer.phi D b)) =
      EventTransfer.phi D b - b := by
    rw [← EventTransfer.phi_satisfies hD hb0 hb1, Real.sqrt_sq_eq_abs,
      abs_of_nonneg (sub_nonneg.mpr hge)]
  simp only [phiInv, hs, sub_sub_cancel, max_eq_right hb0]

/-- Total, ordinary-real presentation on the inverse's domain `a <= 1`.
The lower branch includes negative a; it requires no square root. -/
theorem phiInv_piecewise {D a : ℝ} (hD : 0 ≤ D) (ha1 : a ≤ 1) :
    phiInv D a = if a ≤ D / (1 + D) then 0 else a - Real.sqrt (D * a * (1 - a)) := by
  by_cases ha : a ≤ D / (1 + D)
  · have hle := phi_inv_le hD (le_refl (0 : ℝ)) (by norm_num : (0 : ℝ) ≤ 1)
      (ha.trans_eq (EventTransfer.phi_at_zero hD).symm)
    have hz : phiInv D a = 0 := le_antisymm hle (le_max_left _ _)
    simp only [ha, ite_true, hz]
  · have hden : 0 < 1 + D := by linarith
    have ha0 : 0 ≤ a := (div_nonneg hD (le_of_lt hden)).trans (le_of_lt (lt_of_not_ge ha))
    have hscale : D < a * (1 + D) := (div_lt_iff₀ hden).mp (lt_of_not_ge ha)
    have hrad : 0 ≤ D * a * (1 - a) :=
      mul_nonneg (mul_nonneg hD ha0) (sub_nonneg.mpr ha1)
    have hmul := mul_le_mul_of_nonneg_left (show D * (1 - a) ≤ a by linarith) ha0
    have hs := Real.sq_sqrt hrad
    have hs0 := Real.sqrt_nonneg (D * a * (1 - a))
    have hroot : Real.sqrt (D * a * (1 - a)) ≤ a := by nlinarith
    simp only [ha, ite_false, phiInv, max_eq_right (sub_nonneg.mpr hroot)]

/-- The direct lower bound dominates the inverse only with clipping at zero.
This comparison uses total `Real.sqrt` and holds even for negative a. -/
theorem phiInv_le_clipped_direct (D epsilon delta epsColl : ℝ) (hcol : 0 ≤ epsColl) :
    phiInv D (epsilon - delta - epsColl) ≤ max 0 (epsilon - delta) := by
  apply max_le (le_max_left _ _)
  have hs := Real.sqrt_nonneg (D * (epsilon - delta - epsColl) *
    (1 - (epsilon - delta - epsColl)))
  have hd := le_max_right (0 : ℝ) (epsilon - delta)
  linarith

/-! ## 2. Exact key-law binding and the principal public-simulation exports -/

/-- Consumer interface for B1.10's exact proposition. Its conclusion names
the two key laws used below; a proof of `keyIdent` must yield their equality.
The source-to-law identification is an explicit open premise, not inferred
from a free proposition or from naming a law `muEmitted`. -/
structure KeyLawBinding {SK : Type} [Fintype SK] (keyIdent : Prop)
    (muEmitted muKey : Law (SK × Rq)) : Prop where
  identify : keyIdent → muEmitted = muKey

/-- Principal upper bound for PUBLIC SIMULATION, with certified test cost.
The only key-law identification occurs in the rewrite using `binding` and
`hkey`; the PRG term enters through the admitted-class hop. -/
theorem public_sim_stream_bound {SK : Type} [Fintype SK]
    (beta : Budget) (muEmitted muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (tau : Law (Fin (tapeWidth beta S) → Bool)) (deltaPRG : ℝ)
    (keyIdent : Prop) (binding : KeyLawBinding keyIdent muEmitted muKey)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (cost : CompTest (Fin (tapeWidth beta S) → Bool) → ℝ) (TA blockCost : ℝ)
    (hkey : keyIdent) (hcomp : CompPRGBound C tau deltaPRG)
    (hcert : CompWinCert C cost (streamWinTest beta (SigmaMath.muH muEmitted) A S)
      TA blockCost (AdvPrg.chachaBlocksTotal beta S)) :
    (AdvPublicSimStream beta (SigmaMath.muH muEmitted) A S tau ≤
      Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S) + deltaPRG) ∧
    cost (streamWinTest beta (SigmaMath.muH muEmitted) A S) ≤
      TA + AdvPrg.chachaBlocksTotal beta S * blockCost := by
  obtain ⟨hhop, hcost⟩ := stream_game_hop beta (SigmaMath.muH muEmitted) A S C tau
    deltaPRG cost TA blockCost hcomp hcert
  have hident : AdvPublicSimStream beta (SigmaMath.muH muEmitted) A S Law.uniform =
      Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S) := by
    change (streamGame beta (SigmaMath.muH muEmitted) A S Law.uniform).event _ = _
    rw [streamGame_uniform_eq_advMT, binding.identify hkey]
  rw [hident] at hhop
  exact ⟨hhop, hcost⟩

/-- Hardness substitution for PUBLIC SIMULATION and the same cost contract. -/
theorem public_sim_stream_hardness_substitution {SK : Type} [Fintype SK]
    (beta : Budget) (muEmitted muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (tau : Law (Fin (tapeWidth beta S) → Bool)) (deltaPRG : ℝ)
    (keyIdent : Prop) (binding : KeyLawBinding keyIdent muEmitted muKey)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (cost : CompTest (Fin (tapeWidth beta S) → Bool) → ℝ) (TA blockCost : ℝ)
    (hkey : keyIdent) (hcomp : CompPRGBound C tau deltaPRG)
    (hcert : CompWinCert C cost (streamWinTest beta (SigmaMath.muH muEmitted) A S)
      TA blockCost (AdvPrg.chachaBlocksTotal beta S))
    (epsilonMT : ℝ)
    (hardness : Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) ≤ epsilonMT) :
    (AdvPublicSimStream beta (SigmaMath.muH muEmitted) A S tau ≤ epsilonMT + deltaPRG) ∧
    cost (streamWinTest beta (SigmaMath.muH muEmitted) A S) ≤
      TA + AdvPrg.chachaBlocksTotal beta S * blockCost := by
  obtain ⟨hbound, hcost⟩ := public_sim_stream_bound beta muEmitted muKey A S tau deltaPRG
    keyIdent binding C cost TA blockCost hkey hcomp hcert
  exact ⟨by linarith, hcost⟩

/-- MAIN reduction form for PUBLIC SIMULATION. `epsilon_stream` lower-bounds
this experiment's win probability, not `Games.AdvEUF`. No D is needed. -/
theorem advMT_ge_of_public_sim_stream_win {SK : Type} [Fintype SK]
    (beta : Budget) (muEmitted muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (tau : Law (Fin (tapeWidth beta S) → Bool)) (deltaPRG : ℝ)
    (keyIdent : Prop) (binding : KeyLawBinding keyIdent muEmitted muKey)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (cost : CompTest (Fin (tapeWidth beta S) → Bool) → ℝ) (TA blockCost : ℝ)
    (hkey : keyIdent) (hcomp : CompPRGBound C tau deltaPRG)
    (hcert : CompWinCert C cost (streamWinTest beta (SigmaMath.muH muEmitted) A S)
      TA blockCost (AdvPrg.chachaBlocksTotal beta S))
    (epsilon_stream : ℝ)
    (hbreak : epsilon_stream ≤ AdvPublicSimStream beta (SigmaMath.muH muEmitted) A S tau) :
    (max 0 (epsilon_stream - deltaPRG) ≤
      Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S)) ∧
    cost (streamWinTest beta (SigmaMath.muH muEmitted) A S) ≤
      TA + AdvPrg.chachaBlocksTotal beta S * blockCost := by
  obtain ⟨hbound, hcost⟩ := public_sim_stream_bound beta muEmitted muKey A S tau deltaPRG
    keyIdent binding C cost TA blockCost hkey hcomp hcert
  exact ⟨max_le (Dist.event_nonneg _ _) (by linarith), hcost⟩

/-! ## 3. Explicitly redundant Phi weakenings for the same public experiment -/

/-- Weaker upper bound for PUBLIC SIMULATION. `D >= 0` is arbitrary;
`b <= phi D b` is only a weakening, not a second-moment comparison with
honest Sign. In particular D=0 is allowed independently of S. -/
theorem public_sim_stream_phi_weakening {SK : Type} [Fintype SK]
    (beta : Budget) (muEmitted muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (tau : Law (Fin (tapeWidth beta S) → Bool)) (deltaPRG : ℝ)
    (keyIdent : Prop) (binding : KeyLawBinding keyIdent muEmitted muKey)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (cost : CompTest (Fin (tapeWidth beta S) → Bool) → ℝ) (TA blockCost : ℝ)
    (hkey : keyIdent) (hcomp : CompPRGBound C tau deltaPRG)
    (hcert : CompWinCert C cost (streamWinTest beta (SigmaMath.muH muEmitted) A S)
      TA blockCost (AdvPrg.chachaBlocksTotal beta S)) (D : ℝ) (hD : 0 ≤ D) :
    (AdvPublicSimStream beta (SigmaMath.muH muEmitted) A S tau ≤
      min 1 (StoppingLoss.epsColl beta + EventTransfer.phi D
        (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S)))
      + deltaPRG) ∧
    cost (streamWinTest beta (SigmaMath.muH muEmitted) A S) ≤
      TA + AdvPrg.chachaBlocksTotal beta S * blockCost := by
  obtain ⟨hbound, hcost⟩ := public_sim_stream_bound beta muEmitted muKey A S tau deltaPRG
    keyIdent binding C cost TA blockCost hkey hcomp hcert
  have hb0 : 0 ≤ Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) := Dist.event_nonneg _ _
  have hb1 : Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) ≤ 1 := Dist.event_le_one _ _
  have hcol : (0 : ℝ) ≤ StoppingLoss.epsColl beta :=
    le_min (by norm_num) (StoppingLoss.loss_nonnegative beta.qs beta.qh 0)
  have hphi := EventTransfer.phi_ge_b hD hb0 hb1
  have hmt : Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S) ≤
      min 1 (StoppingLoss.epsColl beta + EventTransfer.phi D
        (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S))) :=
    le_min hb1 (by linarith)
  exact ⟨by linarith, hcost⟩

/-- Exact inversion of the PUBLIC-SIMULATION weakening. The principal direct
bound above dominates this one after clipping at zero. This export also
records `a <= 1`, the domain of `phiInv_piecewise`; a may be negative. -/
theorem advMT_ge_of_public_sim_stream_win_phi_weakening {SK : Type} [Fintype SK]
    (beta : Budget) (muEmitted muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (tau : Law (Fin (tapeWidth beta S) → Bool)) (deltaPRG : ℝ)
    (keyIdent : Prop) (binding : KeyLawBinding keyIdent muEmitted muKey)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (cost : CompTest (Fin (tapeWidth beta S) → Bool) → ℝ) (TA blockCost : ℝ)
    (hkey : keyIdent) (hcomp : CompPRGBound C tau deltaPRG)
    (hcert : CompWinCert C cost (streamWinTest beta (SigmaMath.muH muEmitted) A S)
      TA blockCost (AdvPrg.chachaBlocksTotal beta S)) (D : ℝ) (hD : 0 ≤ D)
    (epsilon_stream : ℝ)
    (hbreak : epsilon_stream ≤ AdvPublicSimStream beta (SigmaMath.muH muEmitted) A S tau) :
    (phiInv D (epsilon_stream - deltaPRG - StoppingLoss.epsColl beta) ≤
      Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S)) ∧
    (epsilon_stream - deltaPRG - StoppingLoss.epsColl beta ≤ 1) ∧
    cost (streamWinTest beta (SigmaMath.muH muEmitted) A S) ≤
      TA + AdvPrg.chachaBlocksTotal beta S * blockCost := by
  obtain ⟨hbound, hcost⟩ := public_sim_stream_phi_weakening beta muEmitted muKey A S tau
    deltaPRG keyIdent binding C cost TA blockCost hkey hcomp hcert D hD
  have hb0 : 0 ≤ Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) := Dist.event_nonneg _ _
  have hb1 : Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) ≤ 1 := Dist.event_le_one _ _
  have hphi : epsilon_stream - deltaPRG - StoppingLoss.epsColl beta ≤
      EventTransfer.phi D
        (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S)) := by
    have hmin := min_le_right (1 : ℝ) (StoppingLoss.epsColl beta + EventTransfer.phi D
      (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S)))
    linarith
  exact ⟨phi_inv_le hD hb0 hb1 hphi, hphi.trans (EventTransfer.phi_le_one hD hb0 hb1), hcost⟩

end FT1536.AssemblyComp
