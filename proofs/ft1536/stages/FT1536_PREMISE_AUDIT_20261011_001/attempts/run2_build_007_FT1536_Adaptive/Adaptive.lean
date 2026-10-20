import FT1536.EventTransfer

namespace FT1536.Divergence
open Finset
variable {α : Type} [Fintype α]

/- Every state contains the entire prefix, in reverse chronological order.
The two runs have identical prefix type and may have arbitrary adaptive kernels.
No independence of complete answers is asserted. -/
abbrev Hist (α : Type) : ℕ → Type
  | 0 => Unit
  | n+1 => Hist α n × α

instance histFintype : (n : ℕ) → Fintype (Hist α n)
  | 0 => inferInstanceAs (Fintype Unit)
  | n+1 => @instFintypeProd _ _ (histFintype n) inferInstance

noncomputable def transcript (k : (n : ℕ) → Hist α n → Law α) : (n : ℕ) → Law (Hist α n)
  | 0 => Law.pure ()
  | n+1 => joint (transcript k n) (k n)

theorem transcript_ac (j p : (n : ℕ) → Hist α n → Law α)
    (h : ∀ n x, AC (j n x) (p n x)) : ∀ n, AC (transcript j n) (transcript p n) := by
  intro n
  induction n with
  | zero => intro x hx; exact hx
  | succ n ih => exact joint_ac _ _ _ _ ih (fun x _ => h n x)

theorem stopped_adaptive_chi2 (j p : (n : ℕ) → Hist α n → Law α)
    (C : ℕ → ℝ) (hC : ∀ n, 0 ≤ C n)
    (h : ∀ n x, second (j n x) (p n x) ≤ C n) :
    ∀ n, second (transcript j n) (transcript p n) ≤ ∏ i ∈ range n, C i := by
  intro n
  induction n with
  | zero => simp [transcript, second, Law.pure]
  | succ n ih =>
    calc
      _ ≤ second (transcript j n) (transcript p n) * C n :=
        joint_bound _ _ _ _ _ (fun x _ => h n x)
      _ ≤ (∏ i ∈ range n, C i) * C n := mul_le_mul_of_nonneg_right ih (hC n)
      _ = _ := (prod_range_succ C n).symm

theorem constant_adaptive_chi2 (j p : (n : ℕ) → Hist α n → Law α)
    (e : ℝ) (he : 0 ≤ e) (h : ∀ n x, second (j n x) (p n x) ≤ 1+e) (n : ℕ) :
    second (transcript j n) (transcript p n) - 1 ≤ (1+e)^n-1 := by
  have hb := stopped_adaptive_chi2 j p (fun _ => 1+e) (fun _ => by positivity) h n
  simpa using sub_le_sub_right hb 1

theorem stopped_transcript_event_bound (j p : (n : ℕ) → Hist α n → Law α)
    (e : ℝ) (he : 0 ≤ e) (hac : ∀ n x, AC (j n x) (p n x))
    (h : ∀ n x, second (j n x) (p n x) ≤ 1+e) (n : ℕ)
    (E : Hist α n → Prop) [DecidablePred E] :
    (transcript p n).event E ≤
      EventTransfer.phi ((1+e)^n-1) ((transcript j n).event E) := by
  let d := densityOfAC _ _ (transcript_ac j p hac n)
  have hd : energy (transcript p n) d.ratio - 1 ≤ (1+e)^n-1 := by
    rw [energy_eq_second]
    exact constant_adaptive_chi2 j p e he h n
  have hn : 0 ≤ (1+e)^n-1 := by
    have hp : 1 ≤ (1+e)^n := one_le_pow₀ (by linarith)
    linarith
  exact EventTransfer.phi_bound hn ((transcript j n).event_nonneg E)
    ((transcript j n).event_le_one E) (EventTransfer.event_quadratic _ _ d E _ hd)

end FT1536.Divergence
