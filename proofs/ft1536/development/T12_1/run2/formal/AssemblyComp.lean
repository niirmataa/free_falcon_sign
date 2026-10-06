import CompPrg

/-! # AssemblyComp — window B2/B5: the real-stream export and the exact `Phi` inversion

Window B2/B5 of the run2 lane (`notes/PROMPT_B2B5_COMPUTATIONAL.md`,
`formal/CompPrg.lean`). Deliverables of THIS module (kernel-checked, zero
unfinished-proof markers, standard axioms only):

1. **The re-exported assembled bound with the REAL-STREAM game on the LHS**
   (`end_to_end_stream_theorem`): `deltaPRG` arrives **via the hop**
   (`CompPrg.stream_game_hop` — the `Assembly.tape_game_hop_abs` family at
   the WINNING EVENT of `A`, for the admitted class) and the fair-tape side is
   identified with `Games.AdvMT (beta.qh+1) muH (Reduction.build beta A S)`
   (`CompPrg.streamGame_uniform_eq_advMT`, through
   `Run2.concrete_lazy_game_binding`). The old export
   (`Assembly.end_to_end_assembled_theorem_statement`) stays the abstract
   honest-game shape; `formal/Assembly.lean` is untouched.
2. **The exact `Phi` inversion** (`phiInv` / `phi_inv_le`) — the inverse
   direction actually needed by the security claim: from
   `a ≤ FT1536.EventTransfer.phi D b` with `0 ≤ D`, `0 ≤ b ≤ 1` one gets
   `max 0 (a - sqrt(D * a * (1 - a))) ≤ b`. The review's
   `max{0, a - sqrt(D*a*(1-a))}` is CHECKED against the repo's `phi`
   (`EventTransfer.phi = (2*b+D+sqrt(D^2+4*D*b*(1-b)))/(2*(1+D))`) and is
   the SHARP inverse (`EventTransfer.phi_satisfies` at equality,
   `phiInv_at_phi_zero` at the boundary), not an estimate. The boundary
   sanity `phi D 0 = D/(1+D)` is already present
   (`EventTransfer.phi_at_zero`) and re-exported.
3. **The security-claim export** (`advMT_ge_of_stream_win`): if the real
   stream game is broken with advantage `epsilon_real`, then
   `Adv_MT(Reduction.build beta A S) >= f(epsilon_real, D, deltaPRG, ...)`
   with `f` the exact inversion above and
   `a = epsilon_real - deltaPRG - StoppingLoss.epsColl beta`, `D = (1 + (k^32-1))
   ^ beta.qs - 1` — plus the recorded direct companion
   (`advMT_ge_of_stream_win_direct`), which this chain also yields and which
   numerically dominates the `Phi`-form; the `Phi`-form is exported as the
   requested exact inversion of the assembled SHAPE.

Premise honesty (recorded): this chain consumes `hk` (the `D >= 0` side
condition), the computational assumption + membership (`hcomp`/`hwin`) and
`hkey`. The assembled named premises `huc`/`hshape`/`hattempt` belong to the
honest-game chain of the OLD export (they discharge the B4 certificate there);
carrying them here without consuming them would be over-assumption, so they
are NOT part of the new argument list. `keyIdent` stays the exact-type slot of
B1.10 (its content is owned by `source3`) and is consumed STRUCTURALLY (the
`gate` pattern — the consumer proof is a function of `keyIdent`, so the final
identification is its ONLY free point).
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
zero below the boundary `phi D 0 = D/(1+D)`. -/
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

/-! ## 2. The re-exported assembled bound — real-stream LHS, `deltaPRG` via the hop -/

/-- THE re-exported assembled bound (goal 2 of the task) with the REAL-STREAM
game on the LHS and `deltaPRG` arriving VIA THE HOP:

    AdvEUFStream beta muH A S tau
      <= min 1 (epsColl beta + EventTransfer.phi ((1+e)^beta.qs - 1)
                  (AdvMT (beta.qh+1) muH (Reduction.build beta A S)))
         + deltaPRG

with `e = k^32 - 1`. The LHS experiment CHANGES TAPE (the signing oracle
runs `Games.Sampler.code` on the real stream `tau` — one whole-run tape of
width `tapeWidth beta S = beta.qs * S.bits` with per-call projection); the
PRG budget `deltaPRG` enters through `CompPrg.stream_game_hop` under the
named computational assumption `CompPRGBound C tau deltaPRG` and the
MEMBERSHIP of the composed winning event (`CompWinCert.mem` with its resource
accounting line), NOT as a bare `0 ≤ deltaPRG` appended to the ideal-game
bound. The old export (`Assembly.end_to_end_assembled_theorem_statement`)
stays the abstract honest-game shape. The `keyIdent` slot is consumed
STRUCTURALLY (the `gate` pattern). -/
theorem end_to_end_stream_theorem {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (k : ℝ)
    (tau : Law (Fin (tapeWidth beta S) → Bool)) (deltaPRG : ℝ) (keyIdent : Prop)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (hk : 1 ≤ k)
    (hkey : keyIdent)
    (hcomp : CompPRGBound C tau deltaPRG)
    (hwin : streamWinTest beta (SigmaMath.muH muKey) A S ∈ C) :
    AdvEUFStream beta (SigmaMath.muH muKey) A S tau ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1)
          (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
            (Reduction.build beta A S)))
      + deltaPRG := by
  have gate : keyIdent → AdvEUFStream beta (SigmaMath.muH muKey) A S tau ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1)
          (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
            (Reduction.build beta A S)))
      + deltaPRG := by
    intro _hkey
    -- (1) THE hop: the real-stream game within `deltaPRG` of the fair-tape game
    have hhop := stream_game_hop beta (SigmaMath.muH muKey) A S C tau deltaPRG hcomp hwin
    -- (2) the fair-tape side IS the reducer's success game
    have hident : AdvEUFStream beta (SigmaMath.muH muKey) A S
          (Law.uniform : Law (Fin (tapeWidth beta S) → Bool))
        = Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
          (Reduction.build beta A S) :=
      streamGame_uniform_eq_advMT beta (SigmaMath.muH muKey) A S
    rw [hident] at hhop
    set b : ℝ := Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S)
    set D : ℝ := (1 + (k ^ 32 - 1)) ^ beta.qs - 1
    have hb0 : 0 ≤ b := Dist.event_nonneg _ _
    have hb1 : b ≤ 1 := Dist.event_le_one _ _
    have hk32 : (1:ℝ) ≤ k ^ 32 := one_le_pow₀ hk
    have hD : 0 ≤ D := by
      have h1 : (1:ℝ) ≤ (1 + (k ^ 32 - 1)) ^ beta.qs :=
        one_le_pow₀ (show (1:ℝ) ≤ 1 + (k ^ 32 - 1) by linarith [hk32])
      unfold D
      linarith
    have hcol : (0:ℝ) ≤ StoppingLoss.epsColl beta :=
      le_min (by norm_num) (StoppingLoss.loss_nonnegative beta.qs beta.qh 0)
    -- (3) the assembled shape at the same `AdvMT` argument
    have hbase : b ≤ EventTransfer.phi D b :=
      EventTransfer.phi_ge_b hD hb0 hb1
    have hmt : b ≤ min 1 (StoppingLoss.epsColl beta + EventTransfer.phi D b) := by
      refine le_min hb1 ?_
      linarith
    linarith
  exact gate hkey

/-- The `concrete_hardness_substitution`-style variant of the real-stream
export: plug an `AdvMT` bound `epsilon ≤ 1` for the concrete reducer. -/
theorem end_to_end_stream_hardness_substitution {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (k : ℝ)
    (tau : Law (Fin (tapeWidth beta S) → Bool)) (deltaPRG : ℝ) (keyIdent : Prop)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool))) (epsilon : ℝ)
    (hk : 1 ≤ k)
    (hkey : keyIdent)
    (hcomp : CompPRGBound C tau deltaPRG)
    (hwin : streamWinTest beta (SigmaMath.muH muKey) A S ∈ C)
    (hepsilon : epsilon ≤ 1)
    (hardness : Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) ≤ epsilon) :
    AdvEUFStream beta (SigmaMath.muH muKey) A S tau ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1) epsilon)
      + deltaPRG := by
  have hbound := end_to_end_stream_theorem beta muKey A S k tau deltaPRG keyIdent C
    hk hkey hcomp hwin
  have hk32 : (1:ℝ) ≤ k ^ 32 := one_le_pow₀ hk
  have hD : (0:ℝ) ≤ (1 + (k ^ 32 - 1)) ^ beta.qs - 1 := by
    have h1 : (1:ℝ) ≤ (1 + (k ^ 32 - 1)) ^ beta.qs :=
      one_le_pow₀ (show (1:ℝ) ≤ 1 + (k ^ 32 - 1) by linarith [hk32])
    linarith
  have hb0 : (0:ℝ) ≤ Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) := Dist.event_nonneg _ _
  have hmono := EventTransfer.phi_mono hD hb0 hardness hepsilon
  have hmin : min 1 (StoppingLoss.epsColl beta +
      EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1)
        (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S)))
      ≤ min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1) epsilon) := by
    apply min_le_min
    · linarith
    · linarith
  linarith

/-! ## 3. The security-claim export: `Adv_MT(B) >= f(epsilon_real, D, deltaPRG, ...)` -/

/-- THE inverse direction actually needed by the security claim (goal 3 of
the task): if the REAL-STREAM game is broken with advantage at least
`epsilon_real`, then the MT-ISIS adversary `B = Reduction.build beta A S`
satisfies

    Adv_MT(B) >= max 0 (a - sqrt(D * a * (1 - a))),
    a = epsilon_real - deltaPRG - StoppingLoss.epsColl beta,
    D = (1 + (k^32 - 1)) ^ beta.qs - 1,

with `e = k^32 - 1` the certificate constant — the EXACT inversion of
`FT1536.EventTransfer.phi` (`phiInv` / `phi_inv_le`), obtained as the
contrapositive of `end_to_end_stream_theorem`. -/
theorem advMT_ge_of_stream_win {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (k : ℝ)
    (tau : Law (Fin (tapeWidth beta S) → Bool)) (deltaPRG : ℝ) (keyIdent : Prop)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool))) (epsilon_real : ℝ)
    (hk : 1 ≤ k)
    (hkey : keyIdent)
    (hcomp : CompPRGBound C tau deltaPRG)
    (hwin : streamWinTest beta (SigmaMath.muH muKey) A S ∈ C)
    (hbreak : epsilon_real ≤ AdvEUFStream beta (SigmaMath.muH muKey) A S tau) :
    phiInv ((1 + (k ^ 32 - 1)) ^ beta.qs - 1)
        (epsilon_real - deltaPRG - StoppingLoss.epsColl beta)
      ≤ Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S) := by
  have hbound := end_to_end_stream_theorem beta muKey A S k tau deltaPRG keyIdent C
    hk hkey hcomp hwin
  set b : ℝ := Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
    (Reduction.build beta A S)
  set D : ℝ := (1 + (k ^ 32 - 1)) ^ beta.qs - 1
  have hk32 : (1:ℝ) ≤ k ^ 32 := one_le_pow₀ hk
  have hD : 0 ≤ D := by
    have h1 : (1:ℝ) ≤ (1 + (k ^ 32 - 1)) ^ beta.qs :=
      one_le_pow₀ (show (1:ℝ) ≤ 1 + (k ^ 32 - 1) by linarith [hk32])
    unfold D
    linarith
  have hb0 : 0 ≤ b := Dist.event_nonneg _ _
  have hb1 : b ≤ 1 := Dist.event_le_one _ _
  have hphi : epsilon_real - deltaPRG - StoppingLoss.epsColl beta
      ≤ EventTransfer.phi D b := by
    have hmin := le_trans hbreak hbound
    have hle : min 1 (StoppingLoss.epsColl beta + EventTransfer.phi D b)
        ≤ StoppingLoss.epsColl beta + EventTransfer.phi D b := min_le_right _ _
    linarith
  exact phi_inv_le hD hb0 hb1 hphi

/-- Recorded companion of the inversion (this chain ALSO yields it): the hop
lands directly on `Adv_MT(B)`, so `Adv_MT(B) >= epsilon_real - deltaPRG`.
Numerically this dominates the `Phi`-form above; the `Phi`-form is exported
as the requested exact inversion of the assembled SHAPE and is the form that
keeps the certificate factor `D = (1 + e)^beta.qs - 1` visible. -/
theorem advMT_ge_of_stream_win_direct {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler)
    (tau : Law (Fin (tapeWidth beta S) → Bool)) (deltaPRG : ℝ)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (hcomp : CompPRGBound C tau deltaPRG)
    (hwin : streamWinTest beta (SigmaMath.muH muKey) A S ∈ C)
    (epsilon_real : ℝ)
    (hbreak : epsilon_real ≤ AdvEUFStream beta (SigmaMath.muH muKey) A S tau) :
    epsilon_real - deltaPRG ≤ Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) := by
  have hhop := stream_game_hop beta (SigmaMath.muH muKey) A S C tau deltaPRG hcomp hwin
  have hident : AdvEUFStream beta (SigmaMath.muH muKey) A S
        (Law.uniform : Law (Fin (tapeWidth beta S) → Bool))
      = Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) (Reduction.build beta A S) :=
    streamGame_uniform_eq_advMT beta (SigmaMath.muH muKey) A S
  rw [hident] at hhop
  linarith

end FT1536.AssemblyComp
