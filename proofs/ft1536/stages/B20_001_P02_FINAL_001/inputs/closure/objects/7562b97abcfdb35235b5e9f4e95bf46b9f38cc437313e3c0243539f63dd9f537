import ReachOutcomes
namespace ScalarIID
def next64 (p : Nat) := if 4087≤p then 8 else p+8
def drop64 (p : Nat) := if 4087≤p then 4096-p else 0
def refill64 (p : Nat) := if 4087≤p then 1 else 0
theorem getter64_ranges (p : Nat) (hp : p<4096) :
    8≤next64 p ∧ next64 p≤4094 ∧ drop64 p≤9*refill64 p ∧
    p+8+drop64 p=4096*refill64 p+next64 p := by
  unfold next64 drop64 refill64;split <;> omega
theorem getter64_read_range (p : Nat) (hp : p<4087) : p+7<4096 := by omega
theorem getter8_ranges (p : Nat) (hp : p<4096) :
    p+1≤4096 ∧ (if p+1=4096 then 0 else p+1)<4096 := by split <;> omega
theorem sign_getter_no_refill (p : Nat) (hp : p≤4094) : p+1<4096 := by omega
theorem exact_boundary : next64 4086=4094 ∧ next64 4087=8 ∧ drop64 4087=9 := by decide
theorem returned_proposal_bytes : (8+8+1+8+8:Nat)=33 := by decide
theorem refill_budget (p q n d r : Nat) (hp : p<4096) (hq : 8≤q)
    (hd : d≤9*r) (hc : p+33*n+d=4096*r+q) :
    4087*r≤4087+33*n ∧ r≤1+(33*n)/4087 := by omega
theorem discarded_budget (d r : Nat) (h : d≤9*r) : d+r*4087≤4096*r := by omega
theorem unique_read_positions (start i j : Nat) (h : start+i=start+j) : i=j := by omega
end ScalarIID
