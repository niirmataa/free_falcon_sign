import FT1536.Basic
import Mathlib.Algebra.Polynomial.Inductions
import Mathlib.Algebra.Polynomial.Eval.Defs

namespace FT1536.Run2.PackedConvolution
open Polynomial Finset

def Cut (n : ℕ) (p : Polynomial ℕ) : Prop := ∀ k,n≤k → p.coeff k=0
def Fits (base : ℕ) (p : Polynomial ℕ) : Prop := ∀ k,p.coeff k<base

theorem eval_head (p : Polynomial ℕ) (base : ℕ) :
    p.eval base=p.coeff 0+base*p.divX.eval base := by
  have hh := congrArg (fun f : Polynomial ℕ => f.eval base) (X_mul_divX_add p)
  simp only [eval_add,eval_mul,eval_X,eval_C] at hh
  omega

theorem split_unique (base lo hi lo' hi' : ℕ) (hb : 0<base)
    (hl : lo<base) (hl' : lo'<base) (h : lo+base*hi=lo'+base*hi') :
    lo=lo' ∧ hi=hi' := by
  have hm := congrArg (fun x : ℕ => x%base) h
  have he : lo=lo' := by
    simpa only [Nat.add_mod,Nat.mul_mod,Nat.mod_self,zero_mul,Nat.zero_mod,
      Nat.add_zero,Nat.mod_eq_of_lt hl,Nat.mod_eq_of_lt hl'] using hm
  refine ⟨he,?_⟩
  have ht : base*hi=base*hi' := by omega
  exact mul_left_cancel₀ (Nat.ne_of_gt hb) ht

theorem cut_divX {n : ℕ} {p : Polynomial ℕ} (h : Cut (n+1) p) : Cut n p.divX := by
  intro k hk
  rw [coeff_divX]
  exact h (k+1) (by omega)

theorem fits_divX {base : ℕ} {p : Polynomial ℕ} (h : Fits base p) : Fits base p.divX := by
  intro k
  rw [coeff_divX]
  exact h (k+1)

theorem cut_zero {p : Polynomial ℕ} (h : Cut 0 p) : p=0 := by
  apply Polynomial.ext
  intro k
  simpa only [coeff_zero] using h k (Nat.zero_le k)

theorem eval_injective (base : ℕ) (hb : 0<base) (n : ℕ) (p q : Polynomial ℕ)
    (hp : Cut n p) (hq : Cut n q) (hpf : Fits base p) (hqf : Fits base q)
    (he : p.eval base=q.eval base) : p=q := by
  induction n generalizing p q with
  | zero => rw [cut_zero hp,cut_zero hq]
  | succ n ih =>
    have hh : p.coeff 0+base*p.divX.eval base=q.coeff 0+base*q.divX.eval base := by
      rw [←eval_head,←eval_head]
      exact he
    obtain ⟨hc,ht⟩ := split_unique base _ _ _ _ hb (hpf 0) (hqf 0) hh
    have hd := ih p.divX q.divX (cut_divX hp) (cut_divX hq) (fits_divX hpf) (fits_divX hqf) ht
    calc
      p = X*p.divX+C (p.coeff 0) := (X_mul_divX_add p).symm
      _ = X*q.divX+C (q.coeff 0) := by rw [hd,hc]
      _ = q := X_mul_divX_add q

noncomputable def slice (start n : ℕ) (p : Polynomial ℕ) : Polynomial ℕ :=
  ∑ i : Fin n,monomial i.val (p.coeff (i.val+start))

theorem coeff_slice (start n : ℕ) (p : Polynomial ℕ) (k : ℕ) :
    (slice start n p).coeff k=if k<n then p.coeff (k+start) else 0 := by
  classical
  rw [slice,finsetSum_coeff]
  by_cases hk : k<n
  · rw [ite_eq_left hk,sum_eq_single (⟨k,hk⟩ : Fin n)]
    · simp only [coeff_monomial,ite_true]
    · intro i _ hi
      have he : i.val≠k := fun h => hi (Fin.ext h)
      simp only [coeff_monomial,he,ite_false]
    · simp
  · rw [ite_eq_right hk]
    apply sum_eq_zero
    intro i _
    have he : i.val≠k := by have hi:=i.isLt; omega
    simp only [coeff_monomial,he,ite_false]

theorem cut_slice (start n : ℕ) (p : Polynomial ℕ) : Cut n (slice start n p) := by
  intro k hk
  rw [coeff_slice,ite_eq_right (by omega : ¬k<n)]

theorem split_polynomial (n : ℕ) (p : Polynomial ℕ) (hp : Cut (2*n) p) :
    p=slice 0 n p+X^n*slice n n p := by
  apply Polynomial.ext
  intro k
  rw [coeff_add,coeff_X_pow_mul',coeff_slice,coeff_slice]
  by_cases hk : k<n
  · simp only [hk,ite_true,show ¬n≤k by omega,ite_false,Nat.add_zero]
  · by_cases h2 : k<2*n
    · have he : k-n+n=k := by omega
      simp only [hk,ite_false,show n≤k by omega,ite_true,show k-n<n by omega,he,zero_add]
    · have he := hp k (by omega)
      simp only [hk,ite_false,show n≤k by omega,ite_true,show ¬k-n<n by omega,he,zero_add]

noncomputable def cyclic (n : ℕ) (p : Polynomial ℕ) : Polynomial ℕ := slice 0 n p+slice n n p

theorem cut_cyclic (n : ℕ) (p : Polynomial ℕ) : Cut n (cyclic n p) := by
  intro k hk
  simp only [cyclic,coeff_add,cut_slice 0 n p k hk,cut_slice n n p k hk,Nat.zero_add]

theorem cyclic_coeff (n : ℕ) (p : Polynomial ℕ) (k : ℕ) (hk : k<n) :
    (cyclic n p).coeff k=p.coeff k+p.coeff (k+n) := by
  simp only [cyclic,coeff_add,coeff_slice,hk,ite_true,Nat.add_zero]

theorem product_cut (n : ℕ) (p q : Polynomial ℕ) (hp : Cut n p) (hq : Cut n q) :
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

theorem coeff_le_eval_one (p : Polynomial ℕ) (k : ℕ) : p.coeff k≤p.eval 1 := by
  simp only [eval_eq_sum,Polynomial.sum,one_pow,mul_one]
  by_cases hk : k∈p.support
  · exact Finset.single_le_sum (fun _ _ => Nat.zero_le _) hk
  · have hc : p.coeff k=0 := by
      exact not_ne_iff.mp ((Polynomial.mem_support_iff.not).mp hk)
    rw [hc]
    exact Nat.zero_le _

theorem cyclic_eval_one (n : ℕ) (p : Polynomial ℕ) (hp : Cut (2*n) p) :
    (cyclic n p).eval 1=p.eval 1 := by
  have hh := congrArg (fun f : Polynomial ℕ => f.eval 1) (split_polynomial n p hp)
  simpa only [cyclic,eval_add,eval_mul,eval_pow,eval_X,one_pow,one_mul] using hh.symm

/- A number written with `n` digits in base `base`, each below `base`,
   evaluates strictly below `base^n`. This is the proved radix range used to
   rule out carry ambiguity in the certificate. -/
theorem eval_lt_power (base : ℕ) (hb : 0<base) :
    ∀ (n : ℕ) (p : Polynomial ℕ), Cut n p → Fits base p → p.eval base<base^n := by
  intro n
  induction n with
  | zero => intro p hp _; rw [cut_zero hp]; simp
  | succ n ih =>
    intro p hp hpf
    have h0 : p.coeff 0<base := hpf 0
    have hd : p.divX.eval base<base^n := ih _ (cut_divX hp) (fits_divX hpf)
    have hps : base^(n+1)=base*base^n := by rw [pow_succ]; exact Nat.mul_comm _ _
    have hX : 1≤base^n := Nat.succ_le_of_lt (show 0<base^n from Nat.pow_pos hb)
    have hd' : p.divX.eval base≤base^n-1 := by omega
    have hm : base*p.divX.eval base≤base*base^n-base := by
      have h2 : base*(base^n-1)=base*base^n-base := by rw [mul_tsub,mul_one]
      have h1 : base*p.divX.eval base≤base*(base^n-1) :=
        Nat.mul_le_mul_left base hd'
      omega
    have hT : base≤base*base^n := by
      simpa [one_mul] using Nat.mul_le_mul_left base hX
    rw [eval_head,hps]
    omega

/- A certificate supplies integer products and a radix split. The conclusion
   is equality of the whole cyclic coefficient vector, with carry ambiguity
   excluded by proved coefficient/mass bounds. No floating FFT is trusted. -/
theorem certificate_sound (base n : ℕ) (hb : 0<base) (a b c : Polynomial ℕ)
    (ha : Cut n a) (hbcut : Cut n b) (hc : Cut n c) (hcf : Fits base c)
    (mass : a.eval 1*b.eval 1<base) (lo hi : ℕ) (hlo : lo<base^n)
    (product : a.eval base*b.eval base=lo+base^n*hi)
    (fold : c.eval base=lo+hi) : c=cyclic n (a*b) := by
  have hcut := product_cut n a b ha hbcut
  have hpbound : ∀ k,(a*b).coeff k<base := fun k =>
    (coeff_le_eval_one (a*b) k).trans_lt (by simpa only [eval_mul] using mass)
  have hlow : Fits base (slice 0 n (a*b)) := by
    intro k
    rw [coeff_slice]
    split_ifs
    · simpa only [Nat.add_zero] using hpbound k
    · exact hb
  have hlowlt := by
    have hlt := eval_lt_power (base:=base) hb n (slice 0 n (a*b)) (cut_slice 0 n (a*b)) hlow
    exact hlt
  have hs := congrArg (fun p : Polynomial ℕ => p.eval base) (split_polynomial n (a*b) hcut)
  simp only [eval_add,eval_mul,eval_pow,eval_X] at hs
  have he : (slice 0 n (a*b)).eval base+base^n*(slice n n (a*b)).eval base=lo+base^n*hi :=
    hs.symm.trans product
  obtain ⟨h0,h1⟩ := split_unique (base^n) _ _ _ _ (Nat.pow_pos hb) hlowlt hlo he
  have hactual : Fits base (cyclic n (a*b)) := by
    intro k
    have hh := coeff_le_eval_one (cyclic n (a*b)) k
    rw [cyclic_eval_one n (a*b) hcut,eval_mul] at hh
    exact hh.trans_lt mass
  apply eval_injective base hb n c (cyclic n (a*b)) hc (cut_cyclic _ _) hcf hactual
  rw [cyclic,eval_add,h0,h1,fold]

end FT1536.Run2.PackedConvolution
