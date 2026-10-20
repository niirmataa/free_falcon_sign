import FT1536.Adaptive
import Mathlib.Algebra.Polynomial.BigOperators

namespace FT1536.Run2.GeneratingFunction
open Finset Polynomial Divergence

noncomputable def pgf {α : Type} [Fintype α] (p : Law α) (e : α → ℕ) : Polynomial ℝ :=
  ∑ x, monomial (e x) (p.mass x)

theorem joint_pgf {α β : Type} [Fintype α] [Fintype β]
    (p : Law α) (q : Law β) (e : α → ℕ) (f : β → ℕ) :
    pgf (joint p (fun _ => q)) (fun z => e z.1+f z.2) = pgf p e * pgf q f := by
  unfold pgf
  rw [Fintype.sum_prod_type,Finset.sum_mul]
  apply sum_congr rfl
  intro x _
  rw [mul_sum]
  apply sum_congr rfl
  intro y _
  exact (monomial_mul_monomial _ _ _ _).symm

def sumEnergy {α : Type} (e : α → ℕ) : (n : ℕ) → Hist α n → ℕ
  | 0,_ => 0
  | n+1,z => sumEnergy e n z.1+e z.2

theorem iid_pgf {α : Type} [Fintype α] (p : Law α) (e : α → ℕ) (n : ℕ) :
    pgf (transcript (fun _ _ => p) n) (sumEnergy e n) = pgf p e ^ n := by
  induction n with
  | zero => simp [pgf,transcript,sumEnergy,Law.pure]
  | succ n ih =>
    change pgf (joint (transcript (fun _ _ => p) n) (fun _ => p))
      (fun z => sumEnergy e n z.1+e z.2) = _
    rw [joint_pgf,ih,pow_succ]

end FT1536.Run2.GeneratingFunction
