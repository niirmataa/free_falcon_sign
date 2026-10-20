import HacGlue
import Run2.UniformErrorBound
import CompPrg
import Mathlib.Data.Nat.Prime.Basic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.PremiseAuditRun2
open Finset

theorem uniform_map_card_dvd {α β : Type} [Fintype α] [Fintype β]
    [Nonempty α] [Nonempty β] [DecidableEq β] (f : α → β)
    (uniform : (Law.uniform : Law α).map f = (Law.uniform : Law β)) :
    Fintype.card β ∣ Fintype.card α := by
  classical
  let b : β := Classical.choice inferInstance
  let k : ℕ := (univ.filter (fun a => f a = b)).card
  have mass : ((Law.uniform : Law α).map f).mass b =
      (k : ℝ) / (Fintype.card α : ℝ) := by
    rw [Run2.FiberBinding.map_mass]
    simp only [Law.uniform]
    rw [← Finset.sum_filter]
    simp [k,div_eq_mul_inv]
  rw [uniform] at mass
  change 1 / (Fintype.card β : ℝ) = (k : ℝ) / (Fintype.card α : ℝ) at mass
  have ha : (Fintype.card α : ℝ) ≠ 0 := by exact_mod_cast Fintype.card_ne_zero
  have hb : (Fintype.card β : ℝ) ≠ 0 := by exact_mod_cast Fintype.card_ne_zero
  have equal : (Fintype.card α : ℝ) = (Fintype.card β : ℝ) * k := by
    field_simp at mass
    nlinarith
  refine ⟨k,?_⟩
  exact_mod_cast equal

theorem no_fair_bits_uniform_rq (n : ℕ) (f : (Fin n → Bool) → Relation.Rq) :
    (Law.uniform : Law (Fin n → Bool)).map f ≠ (Law.uniform : Law Relation.Rq) := by
  intro uniform
  have divides := uniform_map_card_dvd f uniform
  rw [Run2.UniformErrorBound.rq_card] at divides
  have count : Fintype.card (Fin n → Bool) = 2^n := by simp
  rw [count] at divides
  have small : 18433 ∣ 18433^1536 := dvd_pow_self _ (by decide)
  have factor : 18433 ∣ 2^n := dvd_trans small divides
  have prime : Nat.Prime 18433 := by norm_num
  have impossible : 18433 ∣ 2 := prime.dvd_of_dvd_pow factor
  norm_num at impossible

theorem map_map {α β γ : Type} [Fintype α] [Fintype β] [Fintype γ]
    [DecidableEq β] [DecidableEq γ] (p : Law α) (f : α → β) (g : β → γ) :
    (p.map f).map g = p.map (fun x => g (f x)) := by
  apply JointDecomp.law_ext
  funext c
  simp only [Run2.FiberBinding.map_mass]
  simp_rw [Finset.sum_ite_irrel,Finset.sum_const_zero]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  simp

theorem no_uniform_challenge_at (S : Run2.Sampler) : ¬HacGlue.UniformChallengeAt S := by
  intro uniform
  have h := uniform 0 Run2.initial [] (List.Vector.replicate 40 0)
  change JointDecomp.marginal (Run2.samplerLaw S 0 Run2.initial [] (List.Vector.replicate 40 0)) = Law.uniform at h
  unfold JointDecomp.marginal Run2.samplerLaw at h
  rw [map_map] at h
  exact no_fair_bits_uniform_rq S.bits _ h

#print axioms uniform_map_card_dvd
#print axioms no_fair_bits_uniform_rq
#print axioms map_map
#print axioms no_uniform_challenge_at
end FT1536.PremiseAuditRun2
