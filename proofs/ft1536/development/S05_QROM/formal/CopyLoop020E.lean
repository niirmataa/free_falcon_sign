import CopyBank020E

namespace FT1536.S05.CopyLoop020E

structure Registers (A : Type) (n : Nat) where
  cursor : Nat
  destination : Fin n → A
  buffer : Option A
  clock : Nat
  fault : Bool

/-- Public driver setup writes cursor, empty buffer, and clear fault.
    Unit prices of bank operations are part of the declared driver model. -/
def start {A : Type} {n : Nat} (destination : Fin n → A) : Registers A n :=
  ⟨0,destination,none,3,false⟩

/-- Checked read3, checked write3, increment1 and loop branch1. A tick
    transfers exactly one cell, not an arbitrary bank in one primitive. -/
def tick {A : Type} {n : Nat} (source : Fin n → A) (s : Registers A n) : Registers A n :=
  if h : s.cursor<n then
    let value := source ⟨s.cursor,h⟩
    ⟨s.cursor+1,Function.update s.destination ⟨s.cursor,h⟩ value,some value,s.clock+8,s.fault⟩
  else {s with clock := s.clock+1,fault := true}

def execute {A : Type} {n : Nat} (source destination : Fin n → A) : Nat → Registers A n
  | 0 => start destination
  | k+1 => tick source (execute source destination k)

theorem run_prefix {A : Type} {n : Nat} (source destination : Fin n → A) (k : Nat) (hk : k≤n) :
    let s := execute source destination k
    s.cursor=k ∧ s.destination=CopyBank020E.fill source destination k ∧
      s.clock=3+8*k ∧ s.fault=false := by
  induction k with
  | zero => exact ⟨rfl,rfl,rfl,rfl⟩
  | succ k ih =>
    have h := ih (by omega)
    have hn : k<n := by omega
    simp only [execute,tick,h.1,dite_eq_left hn]
    refine ⟨by trivial,?_,?_,h.2.2.2⟩
    · rw [CopyBank020E.fill,dite_eq_left hn]
      exact congrArg (fun bank => Function.update bank ⟨k,hn⟩ (source ⟨k,hn⟩)) h.2.1
    · exact (congrArg (fun x => x+8) h.2.2.1).trans (by omega)

/-- One final guard/check is paid after all cells. Initial bank contents
    are irrelevant to the copied result. No range or no-fault premise remains. -/
theorem complete {A : Type} {n : Nat} (source destination : Fin n → A) :
    let s := execute source destination n
    s.destination=source ∧ s.fault=false ∧ s.clock+1=CopyBank020E.price n n := by
  have h := run_prefix source destination n (le_refl _)
  exact ⟨h.2.1.trans (CopyBank020E.complete _ _),h.2.2.2,
    by rw [h.2.2.1,CopyBank020E.complete_price];omega⟩

theorem cursor_bound {A : Type} {n : Nat} (source destination : Fin n → A) (k : Nat) (hk : k≤n) :
    (execute source destination k).cursor≤n := by
  rw [(run_prefix source destination k hk).1]
  exact hk

end FT1536.S05.CopyLoop020E
