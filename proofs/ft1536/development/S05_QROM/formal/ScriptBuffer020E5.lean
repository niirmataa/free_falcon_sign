import BoundaryFill020E5
import WordPatch020E5

namespace FT1536.S05.ScriptBuffer020E5
open WordRAM020 ArrayBank020E4 WordPatch020E5

abbrev Buffer (n capacity : Nat) := Bank (Option (Write n)) capacity

def buffer {n : Nat} (capacity : Nat) (xs : List (Write n)) : Buffer n capacity :=
  load (fun j => xs[j.val]?)

def action {n : Nat} (x : Option (Write n)) (a : Bank Word n) : Bank Word n :=
  match x with | none => a | some w => write a w.1 w.2

/-- Semantic fold for the bounded buffer scan, with no retained history. -/
def scan {n : Nat} : List (Option (Write n)) → Bank Word n → Bank Word n
  | [],a => a
  | x::xs,a => scan xs (action x a)

def execute {n capacity : Nat} (b : Buffer n capacity) (a : Bank Word n) :=
  scan (List.ofFn (read b)) a

theorem scan_append {n : Nat} (xs ys : List (Option (Write n))) (a : Bank Word n) :
    scan (xs++ys) a=scan ys (scan xs a) := by
  induction xs generalizing a with
  | nil => rfl
  | cons x xs ih => exact ih (action x a)

theorem scan_none {n : Nat} (k : Nat) (a : Bank Word n) : scan (List.replicate k none) a=a := by
  induction k with
  | zero => rfl
  | succ k ih => exact ih

theorem scan_some {n : Nat} (xs : List (Write n)) (a : Bank Word n) : scan (xs.map some) a=WordPatch020E5.apply xs a := by
  induction xs generalizing a with
  | nil => rfl
  | cons x xs ih => exact ih (write a x.1 x.2)

theorem buffer_read {n capacity : Nat} (xs : List (Write n)) (h : xs.length≤capacity) :
    List.ofFn (read (buffer capacity xs))=xs.map some++List.replicate (capacity-xs.length) none := by
  apply List.ext_getElem
  · simp only [List.length_ofFn,List.length_append,List.length_map,List.length_replicate];omega
  · intro j hj hj'
    simp only [List.getElem_ofFn,buffer,read_load]
    by_cases hx : j<xs.length
    · rw [List.getElem_append_left (by simpa only [List.length_map] using hx),List.getElem_map,List.getElem?_eq_getElem hx]
    · rw [List.getElem_append_right (by simpa only [List.length_map] using Nat.le_of_not_gt hx),List.getElem_replicate]
      exact List.getElem?_eq_none (Nat.le_of_not_gt hx)

theorem executes {n capacity : Nat} (xs : List (Write n)) (h : xs.length≤capacity) (a : Bank Word n) :
    execute (buffer capacity xs) a=WordPatch020E5.apply xs a := by
  rw [execute,buffer_read xs h,scan_append,scan_some,scan_none]

/-- The buffer is populated by the same proved one-cell fill loop as the
    public input. This is an actual fixed bank, not a numeric allowance. -/
def populate {n : Nat} (capacity : Nat) (xs : List (Write n)) : Buffer n capacity :=
  BoundaryFill020E5.fill (fun j : Fin capacity => xs[j.val]?) none

theorem populate_eq {n capacity : Nat} (xs : List (Write n)) : populate capacity xs=buffer capacity xs :=
  BoundaryFill020E5.fill_eq _ none

end FT1536.S05.ScriptBuffer020E5
