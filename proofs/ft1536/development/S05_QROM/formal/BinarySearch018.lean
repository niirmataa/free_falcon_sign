import CDFSelection017

namespace FT1536.S05.BinarySearch018

/-- A bounded binary first-threshold machine. The second component counts
    exactly the CDF probes on the executed path, including an unsuccessful path. -/
def search (cdf : ℕ → ℕ) (u : ℕ) : ℕ → ℕ → ℕ → ℕ×ℕ
  | 0,lo,_ => (lo,0)
  | fuel+1,lo,len =>
    if len=0 then (lo,0) else
      let mid := len/2
      let next := if u<cdf (lo+mid)
        then search cdf u fuel lo mid
        else search cdf u fuel (lo+mid+1) (len-mid-1)
      (next.1,next.2+1)

def Cut (cdf : ℕ → ℕ) (u lo len j : ℕ) : Prop :=
  lo≤j ∧ j≤lo+len ∧
    (∀ k,lo≤k → k<j → cdf k≤u) ∧
    (∀ k,j≤k → k<lo+len → u<cdf k)

theorem probe_bound (cdf : ℕ → ℕ) (u fuel lo len : ℕ) :
    (search cdf u fuel lo len).2≤fuel := by
  induction fuel generalizing lo len with
  | zero => simp [search]
  | succ fuel ih =>
    simp only [search]
    split
    · simp
    · split
      · exact Nat.succ_le_succ (ih lo (len/2))
      · exact Nat.succ_le_succ (ih (lo+len/2+1) (len-len/2-1))

theorem halve_capacity (fuel len : ℕ) (h : len<2^(fuel+1)) :
    len/2<2^fuel ∧ len-len/2-1<2^fuel := by
  rw [pow_succ] at h
  omega

theorem search_cut (cdf : ℕ → ℕ) (hc : Monotone cdf) (u fuel lo len : ℕ)
    (capacity : len<2^fuel) : Cut cdf u lo len (search cdf u fuel lo len).1 := by
  induction fuel generalizing lo len with
  | zero =>
    have hz : len=0 := by simpa using capacity
    subst len
    simp only [search,Cut,Nat.add_zero,le_refl,true_and]
    constructor <;> intro k h0 h1 <;> omega
  | succ fuel ih =>
    by_cases hz : len=0
    · subst len
      simp only [search,ite_true,Cut,Nat.add_zero,le_refl,true_and]
      constructor <;> intro k h0 h1 <;> omega
    · have hm : len/2<len := Nat.div_lt_self (by omega) (by norm_num)
      have caps := halve_capacity fuel len capacity
      by_cases hh : u<cdf (lo+len/2)
      · have ihResult := ih lo (len/2) caps.1
        have hj0 := ihResult.1
        have hj1 := ihResult.2.1
        simp only [search,ite_eq_right hz,ite_eq_left hh] at ⊢
        refine ⟨ihResult.1,by omega,ihResult.2.2.1,?_⟩
        intro k hj hk
        by_cases hkm : k<lo+len/2
        · exact ihResult.2.2.2 k hj hkm
        · exact hh.trans_le (hc (by omega))
      · have ihResult := ih (lo+len/2+1) (len-len/2-1) caps.2
        have hj0 := ihResult.1
        have hj1 := ihResult.2.1
        simp only [search,ite_eq_right hz,ite_eq_right hh] at ⊢
        have hend : lo+len/2+1+(len-len/2-1)=lo+len := by omega
        refine ⟨by omega,by omega,?_,?_⟩
        · intro k hk hj
          by_cases hkm : k<lo+len/2+1
          · exact (hc (show k≤lo+len/2 by omega)).trans (by omega)
          · exact ihResult.2.2.1 k (by omega) hj
        · intro k hj hk
          exact ihResult.2.2.2 k hj (by omega)

theorem cut_unique (cdf : ℕ → ℕ) (u lo len a b : ℕ)
    (ha : Cut cdf u lo len a) (hb : Cut cdf u lo len b) : a=b := by
  have ha1 := ha.2.1
  have hb1 := hb.2.1
  by_contra h
  rcases lt_or_gt_of_ne h with hab | hba
  · exact (not_lt_of_ge (hb.2.2.1 a ha.1 hab)) (ha.2.2.2 a le_rfl (by omega))
  · exact (not_lt_of_ge (ha.2.2.1 b hb.1 hba)) (hb.2.2.2 b le_rfl (by omega))

#print axioms probe_bound
#print axioms halve_capacity
#print axioms search_cut
#print axioms cut_unique
end FT1536.S05.BinarySearch018
