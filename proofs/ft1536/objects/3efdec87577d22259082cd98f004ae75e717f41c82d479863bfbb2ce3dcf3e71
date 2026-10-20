import FT1536.Basic
import Mathlib.Algebra.Polynomial.Inductions
import Mathlib.Algebra.Polynomial.Eval.Defs

namespace FT1536.Run2.Scratch
open Polynomial Finset

def Cut (n : ℕ) (p : Polynomial ℕ) : Prop := ∀ k,n≤k → p.coeff k=0
def Fits (base : ℕ) (p : Polynomial ℕ) : Prop := ∀ k,p.coeff k<base

theorem cut_zero {p : Polynomial ℕ} (h : Cut 0 p) : p=0 := by
  apply Polynomial.ext
  intro k
  simpa only [coeff_zero] using h k (Nat.zero_le k)

theorem cut_divX {n : ℕ} {p : Polynomial ℕ} (h : Cut (n+1) p) : Cut n p.divX := by
  intro k hk
  rw [coeff_divX]
  exact h (k+1) (by omega)

theorem fits_divX {base : ℕ} {p : Polynomial ℕ} (h : Fits base p) : Fits base p.divX := by
  intro k
  rw [coeff_divX]
  exact h (k+1)

theorem eval_head (p : Polynomial ℕ) (base : ℕ) :
    p.eval base=p.coeff 0+base*p.divX.eval base := by
  have hh := congrArg (fun f : Polynomial ℕ => f.eval base) (X_mul_divX_add p)
  simp only [eval_add,eval_mul,eval_X,eval_C] at hh
  omega

/- Original body, with state trace to see the goal shape. -/
theorem product_cutA (n : ℕ) (p q : Polynomial ℕ) (hp : Cut n p) (hq : Cut n q) :
    Cut (2*n) (p*q) := by
  intro k hk
  rw [coeff_mul]
  apply Finset.sum_eq_zero
  intro ij hij
  have he : ij.1+ij.2=k := Finset.mem_antidiagonal.mp hij
  trace_state
  by_cases hi : n≤ij.1
  · rw [hp _ hi,zero_mul]
  · have hj : n≤ij.2 := by omega
    rw [hq _ hj,mul_zero]

/- Rintro variant with named coordinates. -/
theorem product_cutB (n : ℕ) (p q : Polynomial ℕ) (hp : Cut n p) (hq : Cut n q) :
    Cut (2*n) (p*q) := by
  intro k hk
  rw [coeff_mul]
  apply Finset.sum_eq_zero
  rintro ⟨a, b⟩ hij
  have he : a+b=k := Finset.mem_antidiagonal.mp hij
  by_cases ha : n≤a
  · rw [hp a ha,zero_mul]
  · have hbb : n≤b := by omega
    rw [hq b hbb,mul_zero]

/- Restored bound: digits in base `base` with n slots evaluate below base^n. -/
theorem eval_lt_power (base : ℕ) (hb : 0 < base) :
    ∀ (n : ℕ) (p : Polynomial ℕ), Cut n p → Fits base p → p.eval base<base^n := by
  intro n
  induction n with
  | zero => intro p hp _; rw [cut_zero hp]; simp
  | succ n ih =>
    intro p hp hpf
    have h0 : p.coeff 0<base := hpf 0
    have hd : p.divX.eval base<base^n := ih _ (cut_divX hp) (fits_divX hpf)
    have hps : base^(n+1)=base*base^n := by rw [pow_succ]; exact Nat.mul_comm _ _
    have hX : 1≤base^n := Nat.succ_le_of_lt (Nat.pow_pos hb n)
    have hd' : p.divX.eval base≤base^n-1 := by omega
    have hm : base*p.divX.eval base≤base*base^n-base := by
      have h2 : base*(base^n-1)=base*base^n-base := by
        rw [Nat.mul_sub_right_distrib,mul_one]
      have h1 : base*p.divX.eval base≤base*(base^n-1) := Nat.mul_le_mul_left hd' base
      omega
    have hT : base≤base*base^n := by
      have h1 : base*1≤base*base^n := Nat.mul_le_mul_left hX base
      simpa [one_mul] using h1
    rw [eval_head,hps]
    omega

end FT1536.Run2.Scratch
