import CostBounds020E4
import ArrayBank020E4

namespace FT1536.S05.CostSpaceGap020E4
open CostRun020E4

/-- A counterexample about the certificate type, not about the concrete
    sampler: arbitrary pure values need not be covered by its counters. -/
def uncharged (n : Nat) : Run (ArrayBank020E4.Bank Bool n) :=
  CostRun020E4.pure (ArrayBank020E4.zero n false)

theorem zero_counters (n : Nat) : Bounded (uncharged n) 0 0 := ⟨le_rfl,le_rfl⟩

theorem full_payload (n : Nat) : (uncharged n).value.cells.size=n :=
  (uncharged n).value.size_eq

theorem counterexample (n : Nat) (hn : 0<n) :
    Bounded (uncharged n) 0 0 ∧ ¬(uncharged n).value.cells.size≤(uncharged n).allocated := by
  refine ⟨zero_counters n,?_⟩
  rw [full_payload]
  change ¬n≤0
  omega

/-- A charged-count bound does not by itself establish the storage bridge.
    The concrete sampler requires an allocation/layout derivation as well. -/
theorem no_universal_storage_rule :
    ¬(∀ (n : Nat) (r : Run (ArrayBank020E4.Bank Bool n)),r.value.cells.size≤r.allocated) := by
  intro h
  exact (counterexample 1 (by omega)).2 (h 1 (uncharged 1))

end FT1536.S05.CostSpaceGap020E4
