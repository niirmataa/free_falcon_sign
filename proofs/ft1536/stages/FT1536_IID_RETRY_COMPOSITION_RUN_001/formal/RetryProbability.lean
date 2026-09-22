import RetryState
namespace RetryIID
def sumFirst (xs : List (Int×Int)) := (xs.map Prod.fst).sum
def sumSecond (xs : List (Int×Int)) := (xs.map Prod.snd).sum
theorem weighted_stopped_sum (xs : List (Int×Int)) (bound scale : Int)
    (h : ∀x∈xs,scale*x.2≤bound*x.1) : scale*sumSecond xs≤bound*sumFirst xs := by
  induction xs with
  | nil => simp [sumFirst,sumSecond]
  | cons x xs ih =>
    have hx:=h x (by simp)
    have hs : ∀y∈xs,scale*y.2≤bound*y.1 := by intro y hy;exact h y (by simp [hy])
    have hh:=ih hs
    simp only [sumFirst,sumSecond,List.map_cons,List.sum_cons,Int.mul_add] at *
    omega
theorem bounded_reach_sum (xs : List Int) (h : ∀x∈xs,0≤x ∧ x≤1) :
    0≤xs.sum ∧ xs.sum≤(xs.length:Int) := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    have hx:=h x (by simp)
    have hs : ∀y∈xs,0≤y ∧ y≤1 := by intro y hy;exact h y (by simp [hy])
    have hh:=ih hs;simp only [List.sum_cons,List.length_cons];omega
theorem survival_product (v : Nat→Nat) (C : Nat) (h0 : 1≤v 0)
    (step : ∀n,v n*C≤v (n+1)) : ∀n,C^n≤v n := by
  intro n;induction n with
  | zero => simpa using h0
  | succ n ih => exact Nat.le_trans (by simpa [Nat.pow_succ] using Nat.mul_le_mul_right C ih) (step n)
theorem conjunction_not_conditioning (joint success bound : Int)
    (h : joint≤bound) (hs : 0≤success) : joint*success≤bound*success :=
  Int.mul_le_mul_of_nonneg_right h hs
theorem sum_cap_proposals : (16*24576:Nat)=393216 ∧ (16*49152:Nat)=786432 := by decide
end RetryIID
