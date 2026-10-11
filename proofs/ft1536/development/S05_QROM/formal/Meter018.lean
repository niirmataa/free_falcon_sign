import CapMap018
import Mathlib.Data.Vector.Basic
import Init.Data.Vector.OfFn

/- Instrumentation algebra. A unit below is a supplied block price, not an
   asserted machine instruction or bit cost. Concrete calibration remains
   a separate obligation. Counts follow the executed stopping branches. -/
namespace FT1536.S05.Meter018
abbrev Run (A : Type) := A × ℕ

def first {A C : Type} (trial : C → Run (Option A)) (step stop : ℕ) :
    (n : ℕ) → (Fin n → C) → Run (Option A)
  | 0,_ => (none,stop)
  | n+1,coins =>
    let x := trial (coins 0)
    match x.1 with
    | some a => (some a,x.2+step)
    | none =>
      let tail := first trial step stop n (fun i => coins i.succ)
      (tail.1,x.2+step+tail.2)

theorem first_value {A C : Type} (trial : C → Run (Option A)) (step stop n : ℕ)
    (coins : Fin n → C) :
    (first trial step stop n coins).1=CapExecution016.first (fun c => (trial c).1) n coins := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [first,CapExecution016.first]
    cases h : (trial (coins 0)).1 <;> simp [ih]

theorem first_bound {A C : Type} (trial : C → Run (Option A)) (step stop cap : ℕ)
    (hc : ∀ c,(trial c).2≤cap) (n : ℕ) (coins : Fin n → C) :
    (first trial step stop n coins).2≤n*(cap+step)+stop := by
  induction n with
  | zero => simp [first]
  | succ n ih =>
    have h := hc (coins 0)
    have ht := ih (fun i => coins i.succ)
    simp only [first]
    split <;> simp only
    · nlinarith
    · nlinarith

/-- Traverses the same ordered cells that are materialized by Vector.ofFn. -/
def vector {A : Type} {n : ℕ} (f : Fin n → Run A) (write : ℕ) : Run (Vector A n) :=
  (Vector.ofFn (fun i => (f i).1),∑ i,((f i).2+write))

theorem vector_value {A : Type} {n : ℕ} (f : Fin n → Run A) (write : ℕ) :
    (vector f write).1=Vector.ofFn (fun i => (f i).1) := rfl

theorem vector_bound {A : Type} {n : ℕ} (f : Fin n → Run A) (write cap : ℕ)
    (hc : ∀ i,(f i).2≤cap) : (vector f write).2≤n*(cap+write) := by
  unfold vector
  dsimp only
  calc
    _ ≤ ∑ _i : Fin n,(cap+write) := Finset.sum_le_sum (fun i _ => Nat.add_le_add_right (hc i) write)
    _ = _ := by simp

#print axioms first_value
#print axioms first_bound
#print axioms vector_value
#print axioms vector_bound
end FT1536.S05.Meter018
