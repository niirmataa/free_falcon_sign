import Mathlib.Data.Fin.Basic
import Mathlib.Tactic

namespace FT1536.S05.CopyBank020E

/-- One finite bank, read source cells and write destination cells in order.
    The mathematical source for coins is the fixed outcome of fresh draws. -/
def fill {A : Type} {n : Nat} (source initial : Fin n → A) : Nat → (Fin n → A)
  | 0 => initial
  | k+1 => if h : k<n then Function.update (fill source initial k) ⟨k,h⟩ (source ⟨k,h⟩)
      else fill source initial k

theorem cell {A : Type} {n : Nat} (source initial : Fin n → A) (k : Nat) (hk : k≤n) (j : Fin n) :
    fill source initial k j=if j.val<k then source j else initial j := by
  induction k with
  | zero => simp [fill]
  | succ k ih =>
    have hkn : k<n := by omega
    rw [fill,dite_eq_left hkn]
    by_cases hj : j.val=k
    · have he : j=(⟨k,hkn⟩:Fin n) := Fin.ext hj
      subst j
      simp
    · have he : j≠(⟨k,hkn⟩:Fin n) := by intro e;exact hj (congrArg Fin.val e)
      rw [Function.update_of_ne he,ih (by omega)]
      have iff : j.val<k ↔ j.val<k+1 := by omega
      simp only [iff]

theorem complete {A : Type} {n : Nat} (source initial : Fin n → A) : fill source initial n=source := by
  funext j
  rw [cell source initial n (le_refl _) j,ite_eq_left j.isLt]

/-- Count actual successful source/destination transfers; an out-of-range
    request performs no transfer and is not used by the complete driver. -/
def transfers (n : Nat) : Nat → Nat
  | 0 => 0
  | k+1 => transfers n k + if k<n then 1 else 0

theorem transfers_exact (n k : Nat) (hk : k≤n) : transfers n k=k := by
  induction k with
  | zero => rfl
  | succ k ih => rw [transfers,ih (by omega),ite_eq_left (by omega)]

/-- Declared driver-loop price:8 unit read/write/control operations per
    transfer and4 for initialization/final check. Primitive prices are MODEL. -/
def price (n k : Nat) : Nat := 8*transfers n k+4

theorem complete_price (n : Nat) : price n n=8*n+4 := by
  rw [price,transfers_exact n n (le_refl _)]

end FT1536.S05.CopyBank020E
