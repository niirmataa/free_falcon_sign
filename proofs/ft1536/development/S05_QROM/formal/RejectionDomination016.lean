import CapExecution016

/- Q-SAMPLER: domination through rejection with normalization cancellation.
   Arbitrary finite laws; neither TV nor successful-only final laws are used. -/
namespace FT1536.S05.RejectionDomination016
open Finset FT1536.Run2.FiberBinding FiniteLaw016 CapExecution016
variable {A : Type} [Fintype A] [DecidableEq A]

def accept (good : A → Prop) [DecidablePred good] (a : A) : Option A :=
  if good a then some a else none
noncomputable def reject (p : Law A) (good : A → Prop) [DecidablePred good] : Law (Option A) :=
  p.map (accept good)
noncomputable def conditioned (p : Law A) (good : A → Prop) [DecidablePred good]
    (hp : 0<p.event good) : Law A :=
  Law.weighted (fun a => if good a then p.mass a else 0)
    (by intro a; split_ifs; exact p.nonneg a; rfl) hp

omit [DecidableEq A] in
theorem complement (p : Law A) (good : A → Prop) [DecidablePred good] :
    p.event good+p.event (fun a => ¬good a)=1 := by
  rw [Law.event,Law.event,←sum_add_distrib,←p.total]
  apply sum_congr rfl
  intro a _
  by_cases ha : good a <;> simp [ha]

theorem reject_none (p : Law A) (good : A → Prop) [DecidablePred good] :
    (reject p good).mass none=p.event (fun a => ¬good a) := by
  rw [reject,map_mass]
  unfold Law.event
  apply sum_congr rfl
  intro a _
  by_cases ha : good a <;> simp [accept,ha]

theorem reject_some (p : Law A) (good : A → Prop) [DecidablePred good] (a : A) :
    (reject p good).mass (some a)=if good a then p.mass a else 0 := by
  rw [reject,map_mass]
  have hi (x : A) : (if accept good x=some a then p.mass x else 0)=
      if x=a then (if good a then p.mass a else 0) else 0 := by
    by_cases hx : x=a
    · subst x; by_cases ha : good a <;> simp [accept,ha]
    · by_cases hg : good x <;> simp [accept,hg,hx]
  simp_rw [hi]
  simp

theorem reject_factor (p : Law A) (good : A → Prop) [DecidablePred good]
    (hp : 0<p.event good) (a : A) :
    (reject p good).mass (some a)=(1-(reject p good).mass none)*(conditioned p good hp).mass a := by
  rw [reject_some,reject_none]
  have hh := complement p good
  have he : 1-p.event (fun a => ¬good a)=p.event good := by linarith
  rw [he]
  change _=p.event good*((if good a then p.mass a else 0)/p.event good)
  field_simp

omit [DecidableEq A] in
theorem event_domination (p q : Law A) (C : ℝ) (hd : ∀ a,p.mass a≤C*q.mass a)
    (event : A → Prop) [DecidablePred event] : p.event event≤C*q.event event := by
  unfold Law.event
  rw [mul_sum]
  apply sum_le_sum
  intro a _
  by_cases ha : event a
  · simpa only [ha,ite_true] using hd a
  · simp [ha]

omit [DecidableEq A] in
theorem domination_one_le (p q : Law A) (C : ℝ) (hd : ∀ a,p.mass a≤C*q.mass a) : 1≤C := by
  have hh := sum_le_sum (fun a (_ : a ∈ univ) => hd a)
  rwa [←mul_sum,p.total,q.total,mul_one] at hh

omit [DecidableEq A] in
theorem acceptance_lower (p q : Law A) (C r : ℝ) (hd : ∀ a,p.mass a≤C*q.mass a)
    (good : A → Prop) [DecidablePred good] (tail : q.event (fun a => ¬good a)≤r) :
    1-C*r≤p.event good := by
  have hC := domination_one_le p q C hd
  have hh := event_domination p q C hd (fun a => ¬good a)
  have ht := mul_le_mul_of_nonneg_left tail (by linarith : 0≤C)
  have hs := complement p good
  linarith

omit [DecidableEq A] in
theorem conditioned_domination (p q : Law A) (C r : ℝ)
    (hd : ∀ a,p.mass a≤C*q.mass a) (good : A → Prop) [DecidablePred good]
    (hp : 0<p.event good) (hq : 0<q.event good)
    (tail : q.event (fun a => ¬good a)≤r) (cap : C*r<1) :
    ∀ a,(conditioned p good hp).mass a≤
      (1+(C-1)/(1-C*r))*(conditioned q good hq).mass a := by
  have hC := domination_one_le p q C hd
  have hden : 0<1-C*r := by linarith
  have hl := acceptance_lower p q C r hd good tail
  have hc := complement p good
  have hq' := complement q good
  have hn := event_domination p q C hd (fun a => ¬good a)
  have hf : C*q.event good≤p.event good+(C-1) := by nlinarith
  have hratio : C-1≤((C-1)/(1-C*r))*p.event good := by
    have hh := mul_le_mul_of_nonneg_left hl (div_nonneg (by linarith : 0≤C-1) hden.le)
    have he : ((C-1)/(1-C*r))*(1-C*r)=C-1 := by field_simp
    rwa [he] at hh
  have hk : C*q.event good≤(1+(C-1)/(1-C*r))*p.event good := by nlinarith
  intro a
  by_cases ha : good a
  · change (if good a then p.mass a else 0)/p.event good≤
      (1+(C-1)/(1-C*r))*((if good a then q.mass a else 0)/q.event good)
    simp only [ha,ite_true]
    apply (div_le_iff₀ hp).2
    have h1 := mul_le_mul_of_nonneg_right hk (div_nonneg (q.nonneg a) hq.le)
    have he : C*q.event good*(q.mass a/q.event good)=C*q.mass a := by field_simp
    rw [he] at h1
    exact (hd a).trans (by convert h1 using 1; ring)
  · simp [conditioned,Law.weighted,ha]

#print axioms complement
#print axioms reject_none
#print axioms reject_some
#print axioms reject_factor
#print axioms event_domination
#print axioms domination_one_le
#print axioms acceptance_lower
#print axioms conditioned_domination
end FT1536.S05.RejectionDomination016
