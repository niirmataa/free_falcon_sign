import ActualScatter020D
import RuntimeAgreement019
import Mathlib.Algebra.BigOperators.Fin

namespace FT1536.S05.ScatterSums020D
open Residue020D BufferField020D ActualScatter020D IndexReference020D
open FT1536.Relation FT1536.Run2.PolynomialReference

def row (a b : Rq) (p : Fin 1536) (count : Nat) : Coeffs := fun r =>
  ∑ j ∈ Finset.range count, if hj : j<1536 then contribution a b p ⟨j,hj⟩ r else 0
def outer (a b : Rq) (count : Nat) : Coeffs := fun r =>
  ∑ p ∈ Finset.range count, if hp : p<1536 then row a b ⟨p,hp⟩ 1536 r else 0

theorem row_zero (a b : Rq) (p : Fin 1536) : row a b p 0=(fun _ => 0) := by
  funext r;simp [row]
theorem outer_zero (a b : Rq) : outer a b 0=(fun _ => 0) := by
  funext r;simp [outer]
theorem row_succ (a b : Rq) (p : Fin 1536) (k : Nat) (hk : k<1536) (r : Fin 1536) :
    row a b p (k+1) r=row a b p k r+contribution a b p ⟨k,hk⟩ r := by
  simp only [row,Finset.sum_range_succ,dite_eq_left hk]
theorem outer_succ (a b : Rq) (k : Nat) (hk : k<1536) (r : Fin 1536) :
    outer a b (k+1) r=outer a b k r+row a b ⟨k,hk⟩ 1536 r := by
  simp only [outer,Finset.sum_range_succ,dite_eq_left hk]

theorem row_full (a b : Rq) (p : Fin 1536) (r : Fin 1536) :
    row a b p 1536 r=∑ j : Fin 1536, contribution a b p j r := by
  rw [row,Finset.sum_range]
  apply Finset.sum_congr rfl
  intro j _
  rw [dite_eq_left j.isLt]

theorem outer_full (a b : Rq) (r : Fin 1536) :
    outer a b 1536 r=∑ p : Fin 1536, ∑ j : Fin 1536, contribution a b p j r := by
  rw [outer,Finset.sum_range]
  apply Finset.sum_congr rfl
  intro p _
  rw [dite_eq_left p.isLt,row_full]

theorem original_multiply (a b : Rq) (r : Fin 1536) :
    outer a b 1536 r=(StandaloneRuntime019.Scatter.multiply a b)[r.val] := by
  rw [RuntimeAgreement019.multiply_eq,Scatter018.get_multiply,outer_full]
  have inner (p : Fin 1536) : (∑ j : Fin 1536,contribution a b p j r)=
      ∑ j : TermIndex,coefficient a (term p)*coefficient b j*
        coefficientOfTerms (remainderTerms (productExponent (term p) j)) r :=
    sum_term (fun j => coefficient a (term p)*coefficient b j*
      coefficientOfTerms (remainderTerms (productExponent (term p) j)) r)
  simp_rw [inner]
  exact sum_term (fun p => ∑ j : TermIndex,coefficient a p*coefficient b j*
    coefficientOfTerms (remainderTerms (productExponent p j)) r)

end FT1536.S05.ScatterSums020D
