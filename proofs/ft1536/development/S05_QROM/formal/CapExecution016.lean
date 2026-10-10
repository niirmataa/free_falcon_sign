import FiniteLaw016

/- Exact executable first-success selection on independent finite tapes.
   A fresh fallback is an additional independent input, never conditioned away. -/
namespace FT1536.S05.CapExecution016
open Finset FT1536.Run2 FT1536.Run2.FiberBinding FiniteLaw016
variable {Coin A B : Type}

def first (trial : Coin → Option A) : (n : ℕ) → (Fin n → Coin) → Option A
  | 0,_ => none
  | n+1,tape => match trial (tape 0) with
    | some x => some x
    | none => first trial n (fun i => tape i.succ)

theorem first_all_reject (trial : Coin → Option A) (n : ℕ) (tape : Fin n → Coin)
    (h : ∀ i,trial (tape i)=none) : first trial n tape=none := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [first,h 0]
    exact ih (fun i => tape i.succ) (fun i => h i.succ)

theorem first_none_iff (trial : Coin → Option A) (n : ℕ) (tape : Fin n → Coin) :
    first trial n tape=none ↔ ∀ i,trial (tape i)=none := by
  induction n with
  | zero => simp [first]
  | succ n ih =>
    simp only [first]
    cases hx : trial (tape 0) with
    | none =>
      rw [ih]
      constructor
      · intro hh i
        refine Fin.cases hx (fun j => hh j) i
      · intro hh i
        exact hh i.succ
    | some x =>
      constructor
      · intro hh; cases hh
      · intro hh
        have := hh 0
        rw [hx] at this
        cases this

theorem first_some_witness (trial : Coin → Option A) (n : ℕ) (tape : Fin n → Coin) (a : A)
    (ha : first trial n tape=some a) : ∃ i,trial (tape i)=some a := by
  induction n with
  | zero => cases ha
  | succ n ih =>
    simp only [first] at ha
    cases hx : trial (tape 0) with
    | none =>
      rw [hx] at ha
      obtain ⟨i,hi⟩ := ih (fun i => tape i.succ) ha
      exact ⟨i.succ,hi⟩
    | some x =>
      rw [hx] at ha
      exact ⟨0,hx.trans ha⟩

variable [Fintype Coin] [Nonempty Coin] [Fintype A] [DecidableEq A]

noncomputable def trialLaw (trial : Coin → Option A) : Law (Option A) := Law.uniform.map trial

theorem first_law (trial : Coin → Option A) (n : ℕ) :
    (Law.uniform : Law (Fin n → Coin)).map (first trial n)=MathSign.cap (trialLaw trial) n := by
  classical
  induction n with
  | zero => exact map_const _ none
  | succ n ih =>
    have he := uniform_equiv (consEquiv Coin n)
    rw [←he,FiniteLaw016.map_map,uniform_product_map]
    rw [MathSign.cap,trialLaw,FiniteLaw016.map_bind]
    congr 1
    funext coin
    cases hc : trial coin with
    | none =>
      change (Law.uniform : Law (Fin n → Coin)).map
        (fun tail => match trial coin with | some a => some a | none => first trial n tail)=_
      simp only [hc]
      exact ih
    | some a =>
      change (Law.uniform : Law (Fin n → Coin)).map
        (fun tail => match trial coin with | some a => some a | none => first trial n tail)=_
      simp only [hc]
      exact map_const _ (some a)

def finish (fallback : B → A) (input : Option A × B) : A :=
  match input.1 with | some a => a | none => fallback input.2

noncomputable def fallbackLaw (p : Law (Option A)) (n : ℕ) (u : Law A) : Law A :=
  (MathSign.cap p n).bind (fun x => match x with | some a => Law.pure a | none => u)

theorem fallback_mass (p : Law (Option A)) (n : ℕ) (u : Law A) (a : A) :
    (fallbackLaw p n u).mass a=
      p.mass none^n*u.mass a+(∑ i ∈ range n,p.mass none^i)*p.mass (some a) := by
  simp only [fallbackLaw,Law.bind,Fintype.sum_option,Law.pure]
  simp only [mul_ite,mul_one,mul_zero,sum_ite_eq,mem_univ,ite_true]
  rw [MathSign.cap_none,MathSign.cap_some]

theorem fallback_mixture (p : Law (Option A)) (l u : Law A)
    (factor : ∀ a,p.mass (some a)=(1-p.mass none)*l.mass a) (n : ℕ) (a : A) :
    (fallbackLaw p n u).mass a=(1-p.mass none^n)*l.mass a+p.mass none^n*u.mass a := by
  rw [fallback_mass,factor]
  have hg := MathSign.geometric_acceptance (p.mass none) n
  nlinarith [congrArg (fun t => t*l.mass a) hg]

theorem fallback_zero_cap (p : Law (Option A)) (u : Law A) : fallbackLaw p 0 u=u := by
  apply law_ext
  intro a
  simp [fallback_mass]

theorem fallback_code_law [Fintype B] [Nonempty B] (trial : Coin → Option A)
    (fallback : B → A) (n : ℕ) :
    (Law.uniform : Law ((Fin n → Coin)×B)).map
      (fun input => finish fallback (first trial n input.1,input.2))=
    fallbackLaw (trialLaw trial) n ((Law.uniform : Law B).map fallback) := by
  rw [uniform_product_map,fallbackLaw,←first_law,FiniteLaw016.map_bind]
  congr 1
  funext tape
  cases hx : first trial n tape with
  | none => simp only [hx,finish]
  | some a =>
    simp only [hx,finish]
    exact map_const _ a

#print axioms first_all_reject
#print axioms first_none_iff
#print axioms first_some_witness
#print axioms first_law
#print axioms fallback_mass
#print axioms fallback_mixture
#print axioms fallback_zero_cap
#print axioms fallback_code_law
end FT1536.S05.CapExecution016
