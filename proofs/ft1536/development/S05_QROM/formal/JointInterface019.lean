import FT1536.Divergence
import Mathlib.Data.Fintype.Pi

/- Game-independent interfaces. This identical source is compiled in two
   isolated worlds, so neither version of Run2.Sampler is silently substituted.
   Standard finite-law identities below are extracted from the repository's
   FiberBinding/JointDecomp argument, avoiding their Games dependency. -/
namespace FT1536.S05.JointInterface019
open Finset

abbrev Bits (n : ℕ) := Fin n → Bool
structure PairCode (C O : Type) where
  bits : ℕ
  code : Bits bits → C × O
structure ReplyCode (C O : Type) where
  bits : ℕ
  code : C → Bits bits → O

variable {A B C O : Type} [Fintype A] [Fintype B] [Fintype C] [Fintype O]

theorem law_ext (p q : Law A) (h : ∀ x,p.mass x=q.mass x) : p=q := by
  cases p
  cases q
  congr
  funext x
  exact h x

theorem map_mass [DecidableEq B] (p : Law A) (f : A → B) (b : B) :
    (p.map f).mass b=∑ a,if f a=b then p.mass a else 0 := by
  simp only [Law.map,Law.bind,Law.pure]
  apply sum_congr rfl
  intro a _
  by_cases h : f a=b
  · simp [h]
  · simp [h,Ne.symm h]

theorem map_map [DecidableEq B] [DecidableEq C] (p : Law A) (f : A → B) (g : B → C) :
    (p.map f).map g=p.map (fun a => g (f a)) := by
  apply law_ext
  intro c
  simp only [map_mass]
  have distribute (b : B) :
      (if g b=c then ∑ a,if f a=b then p.mass a else 0 else 0)=
        ∑ a,if g b=c then (if f a=b then p.mass a else 0) else 0 := by
    by_cases h : g b=c <;> simp [h]
  simp_rw [distribute]
  rw [Finset.sum_comm]
  apply sum_congr rfl
  intro a _
  rw [sum_eq_single (f a)]
  · simp
  · intro b _ hb
    simp [Ne.symm hb]
  · intro h
    exact (h (mem_univ _)).elim

noncomputable def pairLaw [DecidableEq C] [DecidableEq O] (s : PairCode C O) : Law (C×O) :=
  (Law.uniform : Law (Bits s.bits)).map s.code
noncomputable def replyLaw [DecidableEq O] (s : ReplyCode C O) (c : C) : Law O :=
  (Law.uniform : Law (Bits s.bits)).map (s.code c)
noncomputable def freshLaw [Nonempty C] [DecidableEq O] (s : ReplyCode C O) : Law (C×O) :=
  Divergence.joint (Law.uniform : Law C) (replyLaw s)
noncomputable def marginal [DecidableEq C] (p : Law (C×O)) : Law C := p.map Prod.fst

theorem marginal_mass [DecidableEq C] (p : Law (C×O)) (c : C) :
    (marginal p).mass c=∑ o,p.mass (c,o) := by
  rw [marginal,map_mass,Fintype.sum_prod_type,Finset.sum_comm]
  simp

theorem marginal_joint [DecidableEq C] (p : Law C) (k : C → Law O) :
    marginal (Divergence.joint p k)=p := by
  apply law_ext
  intro c
  rw [marginal_mass]
  simp only [Divergence.joint,←mul_sum,Law.total,mul_one]

theorem fresh_marginal [DecidableEq C] [Nonempty C] [DecidableEq O] (s : ReplyCode C O) :
    marginal (freshLaw s)=(Law.uniform : Law C) := marginal_joint _ _

theorem pair_marginal [DecidableEq C] [DecidableEq O] (s : PairCode C O) :
    marginal (pairLaw s)=(Law.uniform : Law (Bits s.bits)).map (fun w => (s.code w).1) :=
  map_map _ _ _

/-- This is a comparison with a full honest law; it imposes no extra marginal
    condition on the public pair generator. Failures are ordinary O atoms. -/
def Certificate [DecidableEq C] [DecidableEq O] (s : PairCode C O) (p : Law (C×O)) (e : ℝ) : Prop :=
  Divergence.AC (pairLaw s) p ∧ Divergence.second (pairLaw s) p≤1+e

#print axioms law_ext
#print axioms map_mass
#print axioms map_map
#print axioms marginal_mass
#print axioms marginal_joint
#print axioms fresh_marginal
#print axioms pair_marginal
end FT1536.S05.JointInterface019
