import CoreCountTypes020E13

namespace FT1536.S05.CoreCountBounds020E13
open CoreCountTypes020E13

theorem bounded (c : Counts) (fuel : Nat) (h : Valid c fuel) :
    c.cycles≤14733*fuel ∧ c.slots≤32*fuel ∧ c.writes≤32*fuel ∧ c.tests≤fuel := by
  rcases h with ⟨hc,hs,hscan,hw,hr,ht⟩
  have hb := Nat.mul_le_mul_left 32 hr
  rw [←hs] at hb
  exact ⟨hc.le.trans (Nat.mul_le_mul_left 14733 hr),hb,hw.trans (hscan.trans hb),ht⟩

end FT1536.S05.CoreCountBounds020E13
