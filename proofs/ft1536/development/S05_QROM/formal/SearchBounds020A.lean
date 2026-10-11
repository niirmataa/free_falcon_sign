import StandaloneRuntime019

namespace FT1536.S05.SearchBounds020A
open StandaloneRuntime019

/-- Machine interval invariant; no monotonicity/CDF correctness hypothesis. -/
theorem interval_step (lo len : Nat) (hp : 0<len) (h : lo+len≤30721) :
    lo+len/2<30721 ∧ lo+len/2≤30721 ∧
    lo+len/2+1+(len-len/2-1)=lo+len ∧ len/2<len := by
  have hm := Nat.div_lt_self hp (by decide : 1<2)
  omega

theorem search_interval (cdf : Nat → Nat) (u fuel lo len : Nat) :
    lo≤(search cdf u fuel lo len).1 ∧ (search cdf u fuel lo len).1≤lo+len := by
  induction fuel generalizing lo len with
  | zero => simp [search]
  | succ fuel ih =>
    by_cases hz : len=0
    · simp [search,hz]
    · have hm := Nat.div_lt_self (show 0<len by omega) (by decide : 1<2)
      simp only [search,ite_eq_right hz]
      split
      · have hh := ih lo (len/2)
        exact ⟨hh.1,le_trans hh.2 (by omega)⟩
      · have hh := ih (lo+len/2+1) (len-len/2-1)
        constructor <;> omega

/-- Every initial search result is a finite one-past-end index; the final
    clamp in020 is still required until the sharper017/018 CDF result is used. -/
theorem initial_search_bound (cdf : Nat → Nat) (u fuel : Nat) :
    (search cdf u fuel 0 30721).1≤30721 := (search_interval cdf u fuel 0 30721).2

end FT1536.S05.SearchBounds020A
