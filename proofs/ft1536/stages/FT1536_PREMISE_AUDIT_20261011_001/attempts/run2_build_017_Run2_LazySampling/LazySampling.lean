import Run2.FiniteDist

namespace FT1536.Run2
open FT1536.Relation
open Finset

/- Typed oracle-reading code. Local randomness may depend on every revealed
answer; it has no argument carrying the unread target suffix. -/
inductive Reader (α : Type) : ℕ → Type 1
  | ret {n} : α → Reader α n
  | sample {n} {β : Type} : (p : Dist β) → (β → Reader α n) → Reader α n
  | read {n} : (Rq → Reader α n) → Reader α (n+1)
  | weaken {n} : Reader α n → Reader α (n+1)

namespace Dist
theorem same_refl {α : Type} (p : Dist α) : Same p p := fun _ => rfl
theorem expect_map {α β : Type} (p : Dist α) (g : α → β) (f : β → ℝ) :
    (p.map g).expect f = p.expect (fun x => f (g x)) := rfl
theorem expect_congr {α : Type} (p : Dist α) (f g : α → ℝ) (h : ∀ x, f x=g x) :
    p.expect f = p.expect g := by
  unfold expect
  apply sum_congr rfl
  intro x _
  rw [h]
theorem expect_const {α : Type} (p : Dist α) (c : ℝ) : p.expect (fun _ => c) = c := by
  unfold expect
  rw [← sum_mul,p.law.total,one_mul]
end Dist

namespace Reader
noncomputable def lazy {α : Type} : {n : ℕ} → Reader α n → Dist α
  | _,.ret a => Dist.pure a
  | _,.sample p k => p.bind fun x => lazy (k x)
  | _,.read k => (Dist.draw (Law.uniform : Law Rq)).bind fun c => lazy (k c)
  | _,.weaken p => lazy p

/- Vector length is part of the type; exhaustion cannot occur. -/
noncomputable def preloaded {α : Type} : {n : ℕ} → Reader α n → (Fin n → Rq) → Dist α
  | _,.ret a,_ => Dist.pure a
  | _,.sample p k,cs => p.bind fun x => preloaded (k x) cs
  | _,.read k,cs => preloaded (k (cs 0)) (fun i => cs i.succ)
  | _,.weaken p,cs => preloaded p (fun i => cs i.castSucc)

noncomputable def iid : (n : ℕ) → Dist (Fin n → Rq)
  | 0 => Dist.pure (fun i => Fin.elim0 i)
  | n+1 => (Dist.draw (Law.uniform : Law Rq)).bind fun c =>
      (iid n).map (fun tail => fun i => Fin.cases c tail i)

theorem iid_prefix (n : ℕ) :
    Dist.Same ((iid (n+1)).map (fun cs => fun i : Fin n => cs i.castSucc)) (iid n) := by
  induction n with
  | zero =>
    intro f
    have he (cs : Fin 1 → Rq) : (fun i : Fin 0 => cs i.castSucc) = (fun i => Fin.elim0 i) := by
      funext i; exact Fin.elim0 i
    simp only [Dist.expect_map]
    simp_rw [he]
    rw [Dist.expect_const]
    exact (Dist.expect_pure _ f).symm
  | succ n ih =>
    intro f
    have he (c : Rq) (tail : Fin (n+1) → Rq) :
        (fun i : Fin (n+1) => Fin.cases (motive := fun _ => Rq) c tail i.castSucc) =
        (fun i => Fin.cases (motive := fun _ => Rq) c (fun j : Fin n => tail j.castSucc) i) := by
      funext i
      refine Fin.cases ?_ (fun j => ?_) i <;> rfl
    simp only [Dist.expect_map,iid,Dist.expect_bind]
    apply Dist.expect_congr
    intro c
    simp_rw [he]
    have hh := ih (fun tail => f (fun i => Fin.cases c tail i))
    simpa only [iid,Dist.expect_bind,Dist.expect_map] using hh

theorem lazy_sampling {α : Type} {n : ℕ} (p : Reader α n) :
    Dist.Same ((iid n).bind (preloaded p)) (lazy p) := by
  induction p with
  | ret a =>
    intro f
    simp only [preloaded,lazy,Dist.expect_bind,Dist.expect_pure,Dist.expect_const]
  | @sample n β d k ih =>
    intro f
    change ((iid n).bind fun cs => d.bind fun x => preloaded (k x) cs).expect f = _
    rw [Dist.bind_comm (iid n) d (fun cs x => preloaded (k x) cs) f]
    simp only [Dist.expect_bind,lazy]
    exact Dist.expect_congr d _ _ (fun x => by simpa only [Dist.expect_bind] using ih x f)
  | @read n k ih =>
    intro f
    simp only [iid,Dist.expect_bind,Dist.expect_map,preloaded,lazy,Fin.cases_zero,Fin.cases_succ]
    apply Dist.expect_congr
    intro c
    simpa only [Dist.expect_bind] using ih c f
  | @weaken n p ih =>
    intro f
    simp only [Dist.expect_bind,preloaded,lazy]
    have hh := iid_prefix n (fun cs => (preloaded p cs).expect f)
    rw [Dist.expect_map] at hh
    rw [hh]
    simpa only [Dist.expect_bind] using ih f

end Reader
end FT1536.Run2
