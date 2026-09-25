import FT1536.Adaptive

namespace FT1536.Reduction
open Divergence EventTransfer

/- This is a finite-trace theorem, not a completed cryptographic game
interpreter. The missing semantic identification is stated in NEXT_INTERFACE. -/
theorem finite_trace_bound {α : Type} [Fintype α]
    (j p : (n : ℕ) → Hist α n → Law α) (e : ℝ) (he : 0 ≤ e)
    (hac : ∀ n x, AC (j n x) (p n x))
    (hchi : ∀ n x, second (j n x) (p n x) ≤ 1+e) (n : ℕ)
    (Win Bad MT : Hist α n → Prop)
    [DecidablePred Win] [DecidablePred Bad] [DecidablePred MT]
    (extracts : ∀ x, Win x ∧ ¬ Bad x → MT x)
    (eps : ℝ) (hbad : (transcript p n).event Bad ≤ eps) :
    (transcript p n).event Win ≤
      min 1 (eps + phi ((1+e)^n-1) ((transcript j n).event MT)) := by
  apply le_min ((transcript p n).event_le_one Win)
  have hremove := (transcript p n).remove_bad_bound Win Bad
  have htransfer := stopped_transcript_event_bound j p e he hac hchi n
    (fun x => Win x ∧ ¬ Bad x)
  have hmono := (transcript j n).event_mono _ MT extracts
  have hn : 0 ≤ (1+e)^n-1 := by
    have hp : 1 ≤ (1+e)^n := one_le_pow₀ (by linarith)
    linarith
  have hphi := phi_mono hn ((transcript j n).event_nonneg _) hmono
    ((transcript j n).event_le_one MT)
  linarith

theorem hardness_substitution {a eps D b epsilonMT : ℝ}
    (hD : 0 ≤ D) (hb : 0 ≤ b) (hMT : b ≤ epsilonMT) (heps : epsilonMT ≤ 1)
    (h : a ≤ min 1 (eps + phi D b)) : a ≤ min 1 (eps + phi D epsilonMT) := by
  apply h.trans
  apply min_le_min_left
  exact add_le_add_left (phi_mono hD hb hMT heps) eps

theorem one_key_unconditional {pK a bound : ℝ} (hp : 0 ≤ pK) (h : a ≤ bound) :
    pK*a ≤ pK*bound := mul_le_mul_of_nonneg_left h hp

theorem zero_key_success (a : ℝ) : (0 : ℝ)*a = 0 := zero_mul a

end FT1536.Reduction
