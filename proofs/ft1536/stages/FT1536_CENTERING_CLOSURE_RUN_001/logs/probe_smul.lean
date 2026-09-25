import Mathlib.Topology.Algebra.InfiniteSum.Ring
-- test: czy 2 • x = 2 * x przez rfl dla ℝ?
example (x : ℝ) : (2:ℝ) • x = 2 * x := rfl
-- inv_eq_of_mul_eq_one alternatywa
#check @inv_eq_of_mul_eq_one
#check @inv_eq_of_mul_eq_one_left
#check @mul_inv_cancel
#check @eq_inv_of_mul_eq_one
