import Run2.Games

namespace FT1536.Run2.TableCost
open FT1536.Relation

/- Explicit byte comparison loop; one byte comparison reads two eight-bit
bytes. The additional unit is a list/control step in this elementary model.
A machine refinement/calibration is not claimed by these local lemmas. -/
def compare : Bytes → Bytes → Bool × ℕ
  | [],[] => (true,1)
  | [],_::_ => (false,1)
  | _::_,[] => (false,1)
  | a::as,b::bs => if a=b then
      let r := compare as bs
      (r.1,17+r.2)
    else (false,17)

theorem compare_correct (x y : Bytes) : (compare x y).1 = decide (x=y) := by
  induction x generalizing y with
  | nil => cases y <;> simp [compare]
  | cons a as ih =>
    cases y with
    | nil => simp [compare]
    | cons b bs => by_cases h:a=b <;> simp [compare,h,ih]

theorem compare_cost (x y : Bytes) : (compare x y).2 ≤ 17*(min x.length y.length)+1 := by
  induction x generalizing y with
  | nil => cases y <;> simp [compare]
  | cons a as ih =>
    cases y with
    | nil => simp [compare]
    | cons b bs =>
      have hh := ih bs
      by_cases h:a=b <;> simp only [compare,h,ite_true,ite_false,List.length_cons]
      · omega
      · omega

/- Costed associative list keyed by raw bytes, including names shorter than
40 bytes. Repeated names do not trigger a fresh target. -/
def lookup (x : Bytes) : List (Bytes × Rq) → Option Rq × ℕ
  | [] => (none,1)
  | (y,c)::tail =>
      let eq := compare x y
      if eq.1 then (some c,eq.2+1)
      else let r := lookup x tail; (r.1,eq.2+1+r.2)

def reference (x : Bytes) : List (Bytes × Rq) → Option Rq
  | [] => none
  | (y,c)::tail => if x=y then some c else reference x tail

theorem lookup_correct (x : Bytes) (table : List (Bytes × Rq)) :
    (lookup x table).1 = reference x table := by
  induction table with
  | nil => rfl
  | cons entry tail ih =>
    obtain ⟨y,c⟩ := entry
    simp only [lookup,compare_correct,reference]
    by_cases h:x=y <;> simp [h,ih]

theorem lookup_cost (x : Bytes) (table : List (Bytes × Rq)) :
    (lookup x table).2 ≤ table.length*(17*x.length+2)+1 := by
  induction table with
  | nil => simp [lookup]
  | cons entry tail ih =>
    obtain ⟨y,c⟩ := entry
    have he := compare_cost x y
    have hm := Nat.min_le_left x.length y.length
    simp only [lookup,List.length_cons,Nat.add_mul,Nat.one_mul]
    split <;> omega

def storedNameBits (table : List (Bytes × Rq)) : ℕ :=
  table.foldr (fun row total => 8*row.1.length+24576+total) 0

theorem storedNameBits_exact (table : List (Bytes × Rq)) :
    storedNameBits table = 8*(table.map (fun row => row.1.length)).sum + 24576*table.length := by
  induction table with
  | nil => rfl
  | cons row tail ih => simp [storedNameBits,List.map_cons,List.sum_cons] at *; omega

end FT1536.Run2.TableCost
