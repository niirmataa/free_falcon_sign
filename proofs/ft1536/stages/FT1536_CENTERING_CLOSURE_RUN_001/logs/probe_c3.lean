import Mathlib.Topology.Algebra.InfiniteSum.Order
#check @ite_eq_left
#check @ite_eq_right
#check @if_pos
#check @if_neg
#check @dif_pos

-- TEST: rozwinięcie def-a przez simp only + ite-rewrite
def Wt (j : ℤ) : ℝ := if j ∈ Finset.Icc (0 : ℤ) 5 then (j:ℝ) else 0

example (j : ℤ) (hj : j ∈ Finset.Icc (0 : ℤ) 5) : Wt j = (j:ℝ) := by
  simp only [Wt]
  exact ite_eq_left hj

example (j : ℤ) (hj : j ∉ Finset.Icc (0 : ℤ) 5) : Wt j = 0 := by
  simp only [Wt]
  exact ite_eq_right hj
