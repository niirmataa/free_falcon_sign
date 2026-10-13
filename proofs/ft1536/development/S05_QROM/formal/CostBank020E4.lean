import CostRun020E4

namespace FT1536.S05.CostBank020E4
open CostRun020E4 ArrayBank020E4

/-- MODEL: w-word payload, checked addressing/dispatch, and an explicit
    conservative copying-store tariff. These are not native CPU prices. -/
def read {A : Type} {n : Nat} (w : Nat) (a : Bank A n) (k : Fin n) : Run A :=
  charge (w+2) (w+2) (ArrayBank020E4.read a k)

def copyWrite {A : Type} {n : Nat} (a : Bank A n) (k : Fin n) (v : A) : Bank A n :=
  load (fun j => if j=k then v else ArrayBank020E4.read a j)

theorem copyWrite_eq {A : Type} {n : Nat} (a : Bank A n) (k : Fin n) (v : A) :
    copyWrite a k v=ArrayBank020E4.write a k v := by
  apply ArrayBank020E4.ext
  rw [copyWrite,read_load,read_write]
  funext j
  by_cases h : j=k <;> simp [Function.update,h]

/-- Full-cell copy/guard/write budget, including both source and destination
    traffic. No uniqueness or free in-place mutation is presumed. -/
def writePrice (n w : Nat) : Nat := n*(2*w+8)+8

def write {A : Type} {n : Nat} (w : Nat) (a : Bank A n) (k : Fin n) (v : A) : Run (Bank A n) :=
  charge (writePrice n w) (writePrice n w) (copyWrite a k v)

/-- n initializer invocations are charged individually. f is a priced
    initializer, not an unpriced oracle; concrete callers must supply it. -/
def tabulate {A : Type} {n : Nat} (w : Nat) (f : Fin n → Run A) : Run (Bank A n) :=
  ⟨load (fun k => (f k).value),4+n*(w+4)+∑ k,(f k).ticks,
    4+n*(w+4)+∑ k,(f k).allocated⟩

def zero {A : Type} (n w : Nat) (d : A) : Run (Bank A n) := tabulate w (fun _ => pure d)

theorem read_value {A : Type} {n : Nat} (w : Nat) (a : Bank A n) (k : Fin n) :
    (read w a k).value=ArrayBank020E4.read a k := rfl

theorem write_value {A : Type} {n : Nat} (w : Nat) (a : Bank A n) (k : Fin n) (v : A) :
    (write w a k v).value=ArrayBank020E4.write a k v := copyWrite_eq a k v

theorem tabulate_bound {A : Type} {n : Nat} (w t m : Nat) (f : Fin n → Run A)
    (hf : ∀ k,Bounded (f k) t m) :
    Bounded (tabulate w f) (4+n*(w+4)+n*t) (4+n*(w+4)+n*m) := by
  constructor
  · apply Nat.add_le_add_left
    calc
      ∑ k,(f k).ticks ≤ ∑ _k : Fin n,t := Finset.sum_le_sum (fun k _ => (hf k).1)
      _ = n*t := by simp
  · apply Nat.add_le_add_left
    calc
      ∑ k,(f k).allocated ≤ ∑ _k : Fin n,m := Finset.sum_le_sum (fun k _ => (hf k).2)
      _ = n*m := by simp

theorem zero_value {A : Type} (n w : Nat) (d : A) : (zero n w d).value=ArrayBank020E4.zero n d := rfl

theorem zero_budget {A : Type} (n w : Nat) (d : A) :
    (zero n w d).ticks=4+n*(w+4) ∧ (zero n w d).allocated=4+n*(w+4) := by
  simp [zero,tabulate,CostRun020E4.pure]

end FT1536.S05.CostBank020E4
