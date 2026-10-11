import JointInterface019
import FT1536.Model
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.NormNum.Prime

/- Reuse of the F04 audit's cardinal-divisibility argument, extracted from
   pinned PremiseAuditRun2.Run2Probes (019 ENTRY gives its SHA), and rq_card
   from Run2.UniformErrorBound. This common module has no Games/HacGlue
   dependency; its result concerns exact adapters only, not moment bounds. -/
set_option maxRecDepth 8192
namespace FT1536.S05.DyadicBridge019
open Finset JointInterface019

theorem uniform_map_card_dvd {A C : Type} [Fintype A] [Fintype C]
    [Nonempty A] [Nonempty C] [DecidableEq C] (f : A → C)
    (uniform : (Law.uniform : Law A).map f=(Law.uniform : Law C)) :
    Fintype.card C ∣ Fintype.card A := by
  classical
  let c : C := Classical.choice inferInstance
  let k : ℕ := (univ.filter (fun a => f a=c)).card
  have mass : ((Law.uniform : Law A).map f).mass c=(k : ℝ)/(Fintype.card A : ℝ) := by
    rw [map_mass]
    simp only [Law.uniform]
    rw [←Finset.sum_filter]
    simp [k,div_eq_mul_inv]
  rw [uniform] at mass
  change 1/(Fintype.card C : ℝ)=(k : ℝ)/(Fintype.card A : ℝ) at mass
  have ha : (Fintype.card A : ℝ)≠0 := by exact_mod_cast Fintype.card_ne_zero
  have hc : (Fintype.card C : ℝ)≠0 := by exact_mod_cast Fintype.card_ne_zero
  have eqn : (Fintype.card A : ℝ)=(Fintype.card C : ℝ)*k := by
    field_simp at mass
    nlinarith
  refine ⟨k,?_⟩
  exact_mod_cast eqn

theorem rq_card : Fintype.card Relation.Rq=18433^1536 := by
  have hc : SigmaMath.rqFintype=(Pi.instFintype : Fintype Relation.Rq) := Subsingleton.elim _ _
  rw [hc]
  have h := Fintype.card_fun (α:=Fin 768) (β:=ZMod 18433×ZMod 18433)
  have hi : Fintype.card Relation.Rq=(18433*18433)^768 := by
    rw [hc]
    simpa only [Fintype.card_prod,ZMod.card,Fintype.card_fin] using h
  rw [hc] at hi
  rw [hi,←pow_two,←pow_mul]

theorem no_bits_uniform_rq (n : ℕ) (f : Bits n → Relation.Rq) :
    (Law.uniform : Law (Bits n)).map f≠(Law.uniform : Law Relation.Rq) := by
  intro uniform
  have divides := uniform_map_card_dvd f uniform
  rw [rq_card] at divides
  have count : Fintype.card (Bits n)=2^n := by simp [Bits]
  rw [count] at divides
  have small : 18433 ∣ 18433^1536 := dvd_pow_self _ (by decide)
  have factor : 18433 ∣ 2^n := dvd_trans small divides
  have prime : Nat.Prime 18433 := by norm_num
  have impossible : 18433 ∣ 2 := prime.dvd_of_dvd_pow factor
  norm_num at impossible

/-- No exact equality of the joint laws. Approximate comparison J²/P is
    not ruled out; changing an interface is not a law-preserving adapter. -/
theorem no_exact_adapter {O : Type} [Fintype O] [DecidableEq O]
    (j : PairCode Relation.Rq O) (s : ReplyCode Relation.Rq O) :
    pairLaw j≠freshLaw s := by
  intro he
  have hm := congrArg marginal he
  rw [pair_marginal,fresh_marginal] at hm
  exact no_bits_uniform_rq j.bits _ hm

#print axioms uniform_map_card_dvd
#print axioms rq_card
#print axioms no_bits_uniform_rq
#print axioms no_exact_adapter
end FT1536.S05.DyadicBridge019
