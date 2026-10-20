import FT1536.Basic
import Mathlib.Analysis.Fourier.ZMod

namespace FT1536.Run2.DiscreteFourier
open Finset
variable {N : ℕ} [NeZero N]

noncomputable def convolution (p q : ZMod N → ℂ) (r : ZMod N) : ℂ :=
  ∑ a, ∑ b, if a+b=r then p a*q b else 0

theorem dft_convolution (p q : ZMod N → ℂ) (k : ZMod N) :
    ZMod.dft (convolution p q) k = ZMod.dft p k * ZMod.dft q k := by
  simp only [ZMod.dft_apply,smul_eq_mul,convolution]
  simp_rw [mul_sum]
  conv_rhs => simp only [Finset.sum_mul]
  conv_rhs => rw [sum_comm]
  rw [sum_comm]
  apply sum_congr rfl
  intro a _
  rw [sum_comm]
  apply sum_congr rfl
  intro b _
  simp only [mul_ite,mul_zero,sum_ite_eq,mem_univ,ite_true]
  rw [add_mul,neg_add,AddChar.map_add_eq_mul]
  ring

noncomputable def unitWeight (r : ZMod N) : ℂ := if r=0 then 1 else 0

noncomputable def convolutionPower (p : ZMod N → ℂ) : ℕ → ZMod N → ℂ
  | 0 => unitWeight
  | n+1 => convolution (convolutionPower p n) p

theorem dft_unit (k : ZMod N) : ZMod.dft unitWeight k = 1 := by
  simp [ZMod.dft_apply,smul_eq_mul,unitWeight,mul_ite]

theorem dft_power (p : ZMod N → ℂ) (n : ℕ) :
    ZMod.dft (convolutionPower p n) = fun k => (ZMod.dft p k)^n := by
  induction n with
  | zero => funext k; simp only [convolutionPower,dft_unit,pow_zero]
  | succ n ih =>
    funext k
    rw [convolutionPower,dft_convolution,ih,pow_succ]

theorem inverse_power_is_cyclic_convolution (p : ZMod N → ℂ) (n : ℕ) :
    ZMod.dft.symm (fun k => (ZMod.dft p k)^n) = convolutionPower p n := by
  rw [←dft_power]
  exact LinearEquiv.symm_apply_apply _ _

end FT1536.Run2.DiscreteFourier
