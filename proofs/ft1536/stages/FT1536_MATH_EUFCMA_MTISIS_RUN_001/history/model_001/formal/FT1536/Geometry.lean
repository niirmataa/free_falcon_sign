import FT1536.Basic

namespace FT1536.Geometry
open Finset
abbrev Vec := Fin 768 → ℤ × ℤ
def block (x y : ℤ) : ℤ := x^2 + x*y + y^2
def Q0 (v : Vec) : ℤ := ∑ i, block (v i).1 (v i).2
def Q (z : Vec × Vec) : ℤ := Q0 z.1 + Q0 z.2
def B : ℤ := 2093922385
def center (x : ℤ) : ℤ := (x + 9216) % 18433 - 9216
def centerVec (v : Vec) : Vec := fun i => (center (v i).1, center (v i).2)

theorem block_nonneg (x y : ℤ) : 0 ≤ block x y := by
  unfold block
  nlinarith [sq_nonneg (x+y), sq_nonneg x, sq_nonneg y]

theorem coord_square_le_twice (x y : ℤ) : x^2 ≤ 2 * block x y := by
  unfold block
  nlinarith [sq_nonneg (x+y), sq_nonneg y]

theorem Q0_nonneg (v : Vec) : 0 ≤ Q0 v :=
  Finset.sum_nonneg fun i _ => block_nonneg (v i).1 (v i).2

theorem coord_bound (v w : Vec) (i : Fin 768) (h : Q (v,w) < B) :
    -65535 ≤ (v i).1 ∧ (v i).1 ≤ 65535 := by
  have hi : block (v i).1 (v i).2 ≤ Q0 v :=
    single_le_sum (fun j _ => block_nonneg (v j).1 (v j).2) (mem_univ i)
  have hw := Q0_nonneg w
  have hs := coord_square_le_twice (v i).1 (v i).2
  unfold Q B at h
  constructor <;> nlinarith [sq_nonneg ((v i).1 + 65535),
    sq_nonneg ((v i).1 - 65535)]

def swap (v : Vec) : Vec := fun i => ((v i).2, (v i).1)

theorem Q0_swap (v : Vec) : Q0 (swap v) = Q0 v := by
  apply sum_congr rfl
  intro i _
  dsimp [swap, block]
  ring

theorem all_coord_bounds (v w : Vec) (h : Q (v,w) < B) (i : Fin 768) :
    (-65535 ≤ (v i).1 ∧ (v i).1 ≤ 65535) ∧
    (-65535 ≤ (v i).2 ∧ (v i).2 ≤ 65535) ∧
    (-65535 ≤ (w i).1 ∧ (w i).1 ≤ 65535) ∧
    (-65535 ≤ (w i).2 ∧ (w i).2 ≤ 65535) := by
  have hv : Q (swap v,w) < B := by simpa [Q, Q0_swap] using h
  have hw : Q (w,v) < B := by simpa [Q, add_comm] using h
  have hws : Q (swap w,v) < B := by simpa [Q, Q0_swap] using hw
  exact ⟨coord_bound v w i h, coord_bound (swap v) w i hv,
    coord_bound w v i hw, coord_bound (swap w) v i hws⟩

def spike (x y : ℤ) : Vec := fun i => if i = 0 then (x,y) else (0,0)

theorem Q0_spike (x y : ℤ) : Q0 (spike x y) = block x y := by
  have h (i : Fin 768) : block (spike x y i).1 (spike x y i).2 =
      if i = 0 then block x y else 0 := by
    by_cases hi : i = 0 <;> simp [spike, hi, block]
  simp only [Q0, h]
  simp

theorem center_spike (x y : ℤ) : centerVec (spike x y) = spike (center x) (center y) := by
  funext i
  by_cases h : i = 0 <;> simp [centerVec, spike, h, center]

/- A genuine strict-bound counterexample with signed16 emitted s2. -/
theorem centering_can_break_acceptance :
    Q (spike 9217 (-5000), spike 32767 18000) < B ∧
    ¬ Q (centerVec (spike 9217 (-5000)), spike 32767 18000) < B := by
  rw [center_spike]
  norm_num [Q, Q0_spike, block, center, B]

end FT1536.Geometry
