import RejectionDomination016

namespace FT1536.S05.CapDomination016
open Finset FT1536.Run2.FiberBinding CapExecution016 RejectionDomination016
variable {A : Type} [Fintype A] [DecidableEq A]

theorem pure_domination (g : Law A) (a : A) (ha : 0<g.mass a) :
    ∀ x,(Law.pure a).mass x≤(1/g.mass a)*g.mass x := by
  intro x
  by_cases hx : x=a
  · subst x; simp [Law.pure,ne_of_gt ha]
  · simp only [Law.pure,hx,ite_false]
    exact mul_nonneg (by positivity) (g.nonneg x)

theorem fallback_domination (trial : Law (Option A)) (l u g : Law A)
    (factor : ∀ a,trial.mass (some a)=(1-trial.mass none)*l.mass a)
    (K r R : ℝ) (hR : 0≤R)
    (hl : ∀ a,l.mass a≤K*g.mass a) (hu : ∀ a,u.mass a≤R*g.mass a)
    (tail : trial.mass none≤r) (n : ℕ) :
    ∀ a,(fallbackLaw trial n u).mass a≤(K+r^n*R)*g.mass a := by
  intro a
  rw [fallback_mixture trial l u factor]
  have hrn : trial.mass none^n≤r^n := pow_le_pow_left₀ (trial.nonneg none) tail n
  have h1 : (1-trial.mass none^n)*l.mass a≤l.mass a := by
    nlinarith [mul_nonneg (pow_nonneg (trial.nonneg none) n) (l.nonneg a)]
  have h2 := mul_le_mul_of_nonneg_left (hu a) (pow_nonneg (trial.nonneg none) n)
  have h3 := mul_le_mul_of_nonneg_right hrn (mul_nonneg hR (g.nonneg a))
  nlinarith [hl a]

theorem rejected_fallback_domination (p q fallback : Law A) (C r R : ℝ)
    (hd : ∀ a,p.mass a≤C*q.mass a) (good : A → Prop) [DecidablePred good]
    (hq : 0<q.event good) (tail : q.event (fun a => ¬good a)≤r)
    (cap : C*r<1) (hR : 0≤R)
    (hu : ∀ a,fallback.mass a≤R*(conditioned q good hq).mass a) (n : ℕ) :
    ∀ a,(fallbackLaw (reject p good) n fallback).mass a≤
      (1+(C-1)/(1-C*r)+(C*r)^n*R)*(conditioned q good hq).mass a := by
  have hC := domination_one_le p q C hd
  have hp : 0<p.event good := (by linarith : 0<1-C*r).trans_le (acceptance_lower p q C r hd good tail)
  apply fallback_domination (reject p good) (conditioned p good hp) fallback
    (conditioned q good hq) (reject_factor p good hp) _ (C*r) R
    hR
    (conditioned_domination p q C r hd good hp hq tail cap) hu
  rw [reject_none]
  exact (event_domination p q C hd _).trans (mul_le_mul_of_nonneg_left tail (by linarith))

#print axioms pure_domination
#print axioms fallback_domination
#print axioms rejected_fallback_domination
end FT1536.S05.CapDomination016
