import CapDomination016
import CoarseBudget016

set_option exponentiation.threshold 100000
namespace FT1536.S05.RawPairDomination016
open Finset FT1536.Run2.FiberBinding CapExecution016 CapDomination016
variable {A : Type} [Fintype A] [DecidableEq A]

omit [DecidableEq A] in
theorem some_mass (p : Law (Option A)) : (∑ a,p.mass (some a))=1-p.mass none := by
  have hh := p.total
  rw [Fintype.sum_option] at hh
  linarith

noncomputable def accepted (p : Law (Option A)) (hp : p.mass none<1) : Law A :=
  Law.weighted (fun a => p.mass (some a)) (fun a => p.nonneg (some a))
    (by rw [some_mass]; linarith)

omit [DecidableEq A] in
theorem accepted_factor (p : Law (Option A)) (hp : p.mass none<1) (a : A) :
    p.mass (some a)=(1-p.mass none)*(accepted p hp).mass a := by
  change p.mass (some a)=(1-p.mass none)*(p.mass (some a)/(∑ a,p.mass (some a)))
  rw [some_mass]
  have hn : 1-p.mass none≠0 := by linarith
  field_simp

omit [DecidableEq A] in
theorem accepted_domination (p : Law (Option A)) (hp : p.mass none<1) (g : Law A) (K : ℝ)
    (bound : ∀ a,p.mass (some a)≤(1-p.mass none)*K*g.mass a) :
    ∀ a,(accepted p hp).mass a≤K*g.mass a := by
  intro a
  change p.mass (some a)/(∑ a,p.mass (some a))≤_
  rw [some_mass]
  apply (div_le_iff₀ (by linarith : 0<1-p.mass none)).2
  simpa only [mul_assoc,mul_comm,mul_left_comm] using bound a

theorem pair_numeric : (1+1/(2 : ℝ)^100)+(7/16)^80*2^23≤CoarseBudget016.pairFactor := by
  norm_num [CoarseBudget016.pairFactor]

theorem cap80_domination (p : Law (Option A)) (g : Law A) (zero : A)
    (rejection : p.mass none≤(7/16 : ℝ))
    (raw : ∀ a,p.mass (some a)≤(1-p.mass none)*(1+1/2^100)*g.mass a)
    (zero_mass : 1/(2 : ℝ)^23≤g.mass zero) :
    ∀ a,(fallbackLaw p 80 (Law.pure zero)).mass a≤CoarseBudget016.pairFactor*g.mass a := by
  have hp : p.mass none<1 := by linarith
  have hz : 0<g.mass zero := (by norm_num : (0 : ℝ)<1/2^23).trans_le zero_mass
  have hu : ∀ a,(Law.pure zero).mass a≤(2 : ℝ)^23*g.mass a := by
    intro a
    have hh := pure_domination g zero hz a
    have hi : 1/g.mass zero≤(2 : ℝ)^23 := by
      apply (div_le_iff₀ hz).2
      linarith [mul_le_mul_of_nonneg_left zero_mass (by positivity : 0≤(2 : ℝ)^23)]
    exact hh.trans (mul_le_mul_of_nonneg_right hi (g.nonneg a))
  have hh := fallback_domination p (accepted p hp) (Law.pure zero) g (accepted_factor p hp)
    (1+1/2^100) (7/16) (2^23) (by positivity) (accepted_domination p hp g _ raw) hu rejection 80
  intro a
  exact (hh a).trans (mul_le_mul_of_nonneg_right pair_numeric (g.nonneg a))

#print axioms some_mass
#print axioms accepted_factor
#print axioms accepted_domination
#print axioms pair_numeric
#print axioms cap80_domination
end FT1536.S05.RawPairDomination016
