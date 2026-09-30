import Run2.LawBinding

namespace FT1536.Run2
open Finset
open FT1536.Relation

namespace Dist
theorem same_trans {α : Type} {p q r : Dist α} (h : Same p q) (k : Same q r) : Same p r :=
  fun f => (h f).trans (k f)
theorem same_symm {α : Type} {p q : Dist α} (h : Same p q) : Same q p := fun f => (h f).symm
theorem same_bind {α β : Type} {p q : Dist α} {f g : α → Dist β}
    (hp : Same p q) (hf : ∀ a,Same (f a) (g a)) : Same (p.bind f) (q.bind g) := by
  intro h
  simp only [expect_bind]
  rw [hp]
  exact expect_congr q _ _ (fun x => hf x h)
theorem same_map {α β : Type} {p q : Dist α} (h : Same p q) (f : α → β) :
    Same (p.map f) (q.map f) := fun g => h (fun x => g (f x))
end Dist

theorem uniform_equiv {α β : Type} [Fintype α] [Fintype β] [Nonempty α] [Nonempty β]
    [DecidableEq β] (e : α ≃ β) : (Law.uniform : Law α).map e = Law.uniform := by
  classical
  apply FiberBinding.law_ext
  intro y
  rw [FiberBinding.map_mass]
  have hxy (x : α) : e x=y ↔ x=e.symm y := (e.eq_symm_apply).symm
  simp only [Law.uniform,hxy,sum_ite_eq',mem_univ,ite_true]
  rw [Fintype.card_congr e]

theorem uniform_joint {α β : Type} [Fintype α] [Fintype β] [Nonempty α] [Nonempty β] :
    Divergence.joint (Law.uniform : Law α) (fun _ => (Law.uniform : Law β)) = Law.uniform := by
  apply FiberBinding.law_ext
  intro z
  simp only [Divergence.joint,Law.uniform,Fintype.card_prod,Nat.cast_mul]
  ring

def consEquiv (C : Type) (n : ℕ) : (C × (Fin n → C)) ≃ (Fin (n+1) → C) where
  toFun z := fun i => Fin.cases z.1 z.2 i
  invFun f := (f 0,fun i => f i.succ)
  left_inv z := by cases z; rfl
  right_inv f := by funext i; refine Fin.cases ?_ (fun j => ?_) i <;> rfl

theorem uniform_split_expect {α β : Type} [Fintype α] [Fintype β] [Nonempty α] [Nonempty β]
    (f : α × β → ℝ) :
    (Dist.draw (Law.uniform : Law (α×β))).expect f =
      (Dist.draw (Law.uniform : Law α)).expect (fun a =>
        (Dist.draw (Law.uniform : Law β)).expect (fun b => f (a,b))) := by
  rw [←uniform_joint]
  change (∑ ab : α×β, (Law.uniform : Law α).mass ab.1*(Law.uniform : Law β).mass ab.2*f ab) =
    ∑ a,(Law.uniform : Law α).mass a*∑ b,(Law.uniform : Law β).mass b*f (a,b)
  rw [Fintype.sum_prod_type]
  simp_rw [mul_sum,mul_assoc]

theorem iid_is_uniform (n : ℕ) :
    Dist.Same (Reader.iid n) (Dist.draw (Law.uniform : Law (Fin n → Rq))) := by
  induction n with
  | zero =>
    intro f
    have he (cs : Fin 0 → Rq) : cs=(fun i => Fin.elim0 i) := by funext i; exact Fin.elim0 i
    rw [Reader.iid,Dist.expect_pure]
    have hh : (Dist.draw (Law.uniform : Law (Fin 0 → Rq))).expect f = f (fun i => Fin.elim0 i) := by
      unfold Dist.expect
      simp_rw [he]
      rw [←sum_mul,Law.total,one_mul]
    exact hh.symm
  | succ n ih =>
    intro f
    have he := uniform_equiv (consEquiv Rq n)
    have hm := draw_pushforward (Law.uniform : Law (Rq × (Fin n → Rq)))
      (consEquiv Rq n) Dist.pure f
    rw [he] at hm
    simp only [Dist.expect_bind,Dist.expect_pure] at hm
    rw [hm,uniform_split_expect]
    simp only [Reader.iid,Dist.expect_bind,Dist.expect_map]
    apply Dist.expect_congr
    intro c
    exact ih (fun tail => f (fun i => Fin.cases c tail i))

theorem vector_targets_iid (n : ℕ) :
    Dist.Same ((Dist.draw (Law.uniform : Law (List.Vector Rq n))).map (Equiv.vectorEquivFin Rq n))
      (Reader.iid n) := by
  have he := uniform_equiv (Equiv.vectorEquivFin Rq n)
  have hh : Dist.Same ((Dist.draw (Law.uniform : Law (List.Vector Rq n))).map (Equiv.vectorEquivFin Rq n))
      (Dist.draw (Law.uniform : Law (Fin n → Rq))) := by
    intro f
    have hm := draw_pushforward (Law.uniform : Law (List.Vector Rq n))
      (Equiv.vectorEquivFin Rq n) Dist.pure f
    rw [he] at hm
    simp only [Dist.expect_bind,Dist.expect_pure] at hm
    exact hm.symm
  exact Dist.same_trans hh (Dist.same_symm (iid_is_uniform n))

end FT1536.Run2
