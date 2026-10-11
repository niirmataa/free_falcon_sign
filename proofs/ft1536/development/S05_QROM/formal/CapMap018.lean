import CapExecution016

namespace FT1536.S05.CapMap018
open CapExecution016

theorem first_map {Coin A B : Type} (trial : Coin → Option A) (f : A → B)
    (n : ℕ) (tape : Fin n → Coin) :
    Option.map f (first trial n tape)=first (fun c => Option.map f (trial c)) n tape := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [first]
    cases hh : trial (tape 0) with
    | none => exact ih (fun i => tape i.succ)
    | some a => rfl

theorem first_congr {Coin A : Type} (p q : Coin → Option A)
    (h : ∀ c,p c=q c) (n : ℕ) (tape : Fin n → Coin) : first p n tape=first q n tape := by
  have hpq : p=q := funext h
  rw [hpq]

#print axioms first_map
#print axioms first_congr
end FT1536.S05.CapMap018
