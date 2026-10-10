import CDFProbability017

set_option exponentiation.threshold 100000
namespace FT1536.S05.PairBudget017
open CDFProbability017
noncomputable def tau : ℝ := 1/2^130
noncomputable def upperFactor : ℝ := (1+beta)^2*(1+delta)^2
noncomputable def lowerFactor : ℝ := (1-beta)^2*(1-delta)^3

theorem signs : 0<lowerFactor ∧ 0<upperFactor ∧ 0<1-tau := by
  norm_num [lowerFactor,upperFactor,beta,delta,tau]

theorem acceptance_budget : (9/16 : ℝ)≤lowerFactor*(1-tau)*4200000/2723^2 := by
  norm_num [lowerFactor,beta,delta,tau]

theorem density_budget : upperFactor≤(1+1/(2 : ℝ)^100)*lowerFactor*(1-tau) := by
  norm_num [upperFactor,lowerFactor,beta,delta,tau]

#print axioms signs
#print axioms acceptance_budget
#print axioms density_budget
end FT1536.S05.PairBudget017
