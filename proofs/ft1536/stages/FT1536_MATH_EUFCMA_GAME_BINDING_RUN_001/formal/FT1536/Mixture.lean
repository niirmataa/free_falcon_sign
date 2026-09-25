import FT1536.Basic
import FT1536.Divergence
import FT1536.Model

/-! # One-shot key mixture (binding type `one_key_lift`)

The experiment draws the key once from `muKey` and the per-key experiment law
depends only on the public marginal `h` (`sk` stays latent). This module
closes the lift from per-key statements to the one-shot experiment:

* `mixture_event_eq` — the event probability of the keyed experiment is the
  `muKey`-average of per-key event probabilities (no conditioning);
* `mixture_event_le` — a uniform per-key bound lifts through the mixture with
  no positivity hypothesis on any key success probability;
* `mixture_split` / `mixture_good_bound` — the explicit p_K split (the p_K = 0
  boundary is a literal value of the split, not a separate semantic case);
* `latent_secret_event` — if the per-key law only uses `h`, the keyed law is
  exactly the `muH`-mixture (`SigmaMath.muH` is the marginal, never uniform).

No `sorry` in this module. -/

namespace FT1536.Mixture
open Finset

/-- Law extensionality from pointwise masses (Prop fields are irrelevant). -/
theorem law_ext {α : Type} [Fintype α] {p q : Law α} (h : ∀ x, p.mass x = q.mass x) :
    p = q := by
  rcases p with ⟨pm, _, _⟩
  rcases q with ⟨qm, _, _⟩
  have hpq : pm = qm := funext h
  subst hpq
  rfl

/-- One-shot key draw: the experiment law is the mixture over key outcomes. -/
noncomputable def keyed {K Ω : Type} [Fintype K] [Fintype Ω] (muK : Law K)
    (perKey : K → Law Ω) : Law Ω := muK.bind perKey

theorem keyed_mass {K Ω : Type} [Fintype K] [Fintype Ω] (muK : Law K)
    (perKey : K → Law Ω) (w : Ω) :
    (keyed muK perKey).mass w = ∑ k, muK.mass k * (perKey k).mass w := rfl

/-- Event probability of the one-shot keyed experiment is the exact average
of per-key event probabilities. -/
theorem mixture_event_eq {K Ω : Type} [Fintype K] [Fintype Ω] (muK : Law K)
    (perKey : K → Law Ω) (E : Ω → Prop) [DecidablePred E] :
    (keyed muK perKey).event E = ∑ k, muK.mass k * (perKey k).event E := by
  show (∑ w, if E w then (keyed muK perKey).mass w else 0) = _
  simp only [keyed_mass]
  have hswap : (∑ w, if E w then (∑ k, muK.mass k * (perKey k).mass w) else 0)
      = ∑ k, ∑ w, if E w then muK.mass k * (perKey k).mass w else 0 := by
    have h1 : (∑ w, if E w then (∑ k, muK.mass k * (perKey k).mass w) else 0)
        = ∑ w, ∑ k, if E w then muK.mass k * (perKey k).mass w else 0 := by
      apply Finset.sum_congr rfl
      intro w _
      by_cases hw : E w <;> simp [hw]
    rw [h1]
    exact Finset.sum_comm
  rw [hswap]
  apply Finset.sum_congr rfl
  intro k _
  show (∑ w, if E w then muK.mass k * (perKey k).mass w else 0)
      = muK.mass k * (perKey k).event E
  have h2 : (∑ w, if E w then muK.mass k * (perKey k).mass w else 0)
      = ∑ w, muK.mass k * (if E w then (perKey k).mass w else 0) := by
    apply Finset.sum_congr rfl
    intro w _
    by_cases hw : E w <;> simp [hw]
  rw [h2, ← Finset.mul_sum]
  rfl

/-- A uniform per-key bound lifts through the one-shot mixture. No hypothesis
on per-key success probabilities is required (in particular p_K = 0 is
included and needs no separate case). -/
theorem mixture_event_le {K Ω : Type} [Fintype K] [Fintype Ω] (muK : Law K)
    (perKey : K → Law Ω) (E : Ω → Prop) [DecidablePred E] (B : ℝ)
    (h : ∀ k, (perKey k).event E ≤ B) :
    (keyed muK perKey).event E ≤ B := by
  rw [mixture_event_eq]
  calc _ ≤ ∑ k, muK.mass k * B :=
      Finset.sum_le_sum fun k _ => mul_le_mul_of_nonneg_left (h k) (muK.nonneg k)
    _ = _ := by rw [← Finset.sum_mul, muK.total, one_mul]

/-- Explicit split of the key space (the p_K decomposition). -/
theorem mixture_split {K Ω : Type} [Fintype K] [Fintype Ω] (muK : Law K)
    (perKey : K → Law Ω) (E : Ω → Prop) [DecidablePred E]
    (Good : K → Prop) [DecidablePred Good] :
    (keyed muK perKey).event E =
      (∑ k, if Good k then muK.mass k * (perKey k).event E else 0) +
      (∑ k, if Good k then 0 else muK.mass k * (perKey k).event E) := by
  rw [mixture_event_eq, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl ?_
  intro k _
  by_cases hg : Good k <;> simp [hg]

/-- p_K form: with `pK` the mass of good keys and a uniform per-key bound on
them, the one-shot advantage is at most `pK * B + (1 - pK)`. The p_K = 0
boundary is the literal value `0 * B + 1 = 1` of this formula. -/
theorem mixture_good_bound {K Ω : Type} [Fintype K] [Fintype Ω] (muK : Law K)
    (perKey : K → Law Ω) (E : Ω → Prop) [DecidablePred E]
    (Good : K → Prop) [DecidablePred Good] (pK B : ℝ)
    (hmass : (∑ k, if Good k then muK.mass k else 0) = pK)
    (hgood : ∀ k, Good k → (perKey k).event E ≤ B) :
    (keyed muK perKey).event E ≤ pK * B + (1 - pK) := by
  rw [mixture_split muK perKey E Good]
  have hgoodPart : (∑ k, if Good k then muK.mass k * (perKey k).event E else 0) ≤ pK * B := by
    calc _ ≤ ∑ k, if Good k then muK.mass k * B else 0 := by
          apply Finset.sum_le_sum
          intro k _
          by_cases hg : Good k <;> simp [hg]
          exact mul_le_mul_of_nonneg_left (hgood k hg) (muK.nonneg k)
      _ = (∑ k, if Good k then muK.mass k else 0) * B := by
          rw [Finset.sum_mul]
          refine Finset.sum_congr rfl ?_
          intro k _
          by_cases hg : Good k <;> simp [hg, mul_comm]
      _ = pK * B := by rw [hmass]
  have hbadPart : (∑ k, if Good k then 0 else muK.mass k * (perKey k).event E) ≤ 1 - pK := by
    calc _ ≤ ∑ k, if Good k then 0 else muK.mass k := by
          apply Finset.sum_le_sum
          intro k _
          by_cases hg : Good k <;> simp [hg]
          exact (mul_le_mul_of_nonneg_left ((perKey k).event_le_one E) (muK.nonneg k)).trans_eq (mul_one _)
      _ = (∑ k, muK.mass k) - ∑ k, if Good k then muK.mass k else 0 := by
          rw [← Finset.sum_sub_distrib]
          refine Finset.sum_congr rfl ?_
          intro k _
          by_cases hg : Good k <;> simp [hg]
      _ = 1 - pK := by rw [muK.total, hmass]
  exact add_le_add hgoodPart hbadPart

/-- Public marginal of a joint key law (the latent-secret projection). -/
noncomputable def pubMarginal {SK C : Type} [Fintype SK] [Fintype C] [DecidableEq C]
    (muK : Law (SK × C)) : Law C := muK.map Prod.snd

/-- Latent secret: if the per-key law only depends on the public half `h`, the
one-shot keyed experiment is exactly the marginal mixture of those laws. -/
theorem latent_secret_event {SK C Ω : Type} [Fintype SK] [Fintype C] [Fintype Ω]
    [DecidableEq C] [DecidableEq Ω]
    (muK : Law (SK × C)) (pH : C → Law Ω) (E : Ω → Prop) [DecidablePred E] :
    (keyed muK (fun k => pH k.2)).event E = (keyed (pubMarginal muK) pH).event E := by
  rw [mixture_event_eq, mixture_event_eq]
  have hmass : ∀ hC : C, (pubMarginal muK).mass hC
      = ∑ k, muK.mass k * if hC = k.2 then 1 else 0 := by
    intro hC
    show (muK.map Prod.snd).mass hC = _
    simp only [Law.map, Law.bind, Law.pure]
  have hkey : (∑ hC, (pubMarginal muK).mass hC * (pH hC).event E)
      = ∑ hC, (∑ k, muK.mass k * (if hC = k.2 then 1 else 0)) * (pH hC).event E := by
    refine Finset.sum_congr rfl ?_
    intro hC _
    rw [hmass]
  rw [hkey]
  have hstep : (∑ hC, (∑ k, muK.mass k * (if hC = k.2 then 1 else 0)) * (pH hC).event E)
      = ∑ hC, ∑ k, (muK.mass k * (if hC = k.2 then 1 else 0)) * (pH hC).event E := by
    refine Finset.sum_congr rfl ?_
    intro hC _
    simp only [Finset.sum_mul]
  rw [hstep, Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro k _
  have h3 : (∑ hC, (muK.mass k * (if hC = k.2 then 1 else 0)) * (pH hC).event E)
      = ∑ hC, if hC = k.2 then muK.mass k * (pH hC).event E else 0 := by
    apply Finset.sum_congr rfl
    intro hC _
    by_cases hh : hC = k.2 <;> simp [hh]
  rw [h3]
  simp

/-- The same lift in the model's own marginal `SigmaMath.muH` (which is the
projection `muKey.map Prod.snd`, never a uniform key law). -/
theorem latent_secret_event_muH {SK Ω : Type} [Fintype SK] [Fintype Ω] [DecidableEq Ω]
    (muK : Law (SK × Relation.Rq)) (pH : Relation.Rq → Law Ω)
    (E : Ω → Prop) [DecidablePred E] :
    (keyed muK (fun k => pH k.2)).event E = (keyed (SigmaMath.muH muK) pH).event E :=
  latent_secret_event muK pH E

end FT1536.Mixture
