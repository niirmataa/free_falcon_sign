import JointInterface019

/- Finite negative controls: equal challenge/reply marginals and equal abort
   probability do not preserve the joint law or its support. -/
namespace FT1536.S05.BoundaryControls019
open JointInterface019 FT1536.Divergence

def answer (c : Bool) : Option Bool := if c then some true else none
noncomputable def correlated : Law (Bool×Option Bool) :=
  (Law.uniform : Law Bool).map (fun c => (c,answer c))
noncomputable def independent : Law (Bool×Option Bool) :=
  Divergence.joint (Law.uniform : Law Bool) (fun _ => (Law.uniform : Law Bool).map answer)

theorem impossible_pair : correlated.mass (true,none)=0 ∧ independent.mass (true,none)=1/4 := by
  norm_num [correlated,independent,answer,Law.map,Law.bind,Law.pure,Law.uniform,Divergence.joint,Fintype.sum_prod_type]

theorem independent_not_ac : ¬AC independent correlated := by
  intro ac
  have hh := ac (true,none) impossible_pair.1
  rw [impossible_pair.2] at hh
  norm_num at hh

theorem different_joint : independent≠correlated := by
  intro eqn
  apply independent_not_ac
  rw [eqn]
  intro x hx
  exact hx

theorem same_marginals : correlated.map Prod.fst=independent.map Prod.fst ∧
    correlated.map Prod.snd=independent.map Prod.snd := by
  constructor
  · apply law_ext
    intro c
    cases c <;> norm_num [correlated,independent,answer,Law.map,Law.bind,Law.pure,Law.uniform,Divergence.joint,Fintype.sum_prod_type]
  · apply law_ext
    intro o
    cases o with
    | none => norm_num [correlated,independent,answer,Law.map,Law.bind,Law.pure,Law.uniform,Divergence.joint,Fintype.sum_prod_type]
    | some b => cases b <;> norm_num [correlated,independent,answer,Law.map,Law.bind,Law.pure,Law.uniform,Divergence.joint,Fintype.sum_prod_type]

theorem same_failure_mass : (correlated.map Prod.snd).mass none=1/2 ∧
    (independent.map Prod.snd).mass none=1/2 := by
  norm_num [correlated,independent,answer,Law.map,Law.bind,Law.pure,Law.uniform,Divergence.joint,Fintype.sum_prod_type]

/-- A bound in the opposite direction cannot pay the denominator change:
    for J=(1,0), P=(1/2,1/2), R=(1/8,7/8), R≤2P but second(J,R)>2 second(J,P). -/
theorem reversed_lower_bound_fails :
    (1/8 : ℝ)≤2*(1/2) ∧ (7/8 : ℝ)≤2*(1/2) ∧
    (1 : ℝ)^2/(1/8)+0^2/(7/8)>2*(1^2/(1/2)+0^2/(1/2)) := by norm_num

#print axioms impossible_pair
#print axioms independent_not_ac
#print axioms different_joint
#print axioms same_marginals
#print axioms same_failure_mass
#print axioms reversed_lower_bound_fails
end FT1536.S05.BoundaryControls019
