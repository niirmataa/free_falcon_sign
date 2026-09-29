import FloorWord
namespace FloorCT
open ZeroScalar
theorem FLOOR_ZERO_CANDIDATE (x : Word) (hx : NumericCenter x) : candidateLong x=floorVal x-eps0 x := by
  rw [all_word64_equivalence]
  exact FLOOR_ZERO x hx
theorem C_INT_BRIDGE_CANDIDATE (x : Word) (hx : NumericCenter x) (z : Int) (hz : -365≤z ∧ z≤366) :
    -2147483648≤candidateLong x ∧ candidateLong x≤2147483647 ∧
    -2147483648≤candidateLong x+z ∧ candidateLong x+z≤2147483647 := by
  rw [all_word64_equivalence]
  exact C_INT_BRIDGE x hx z hz
theorem zero_endpoints : candidateLong ⟨0,by decide⟩=0 ∧ candidateLong ⟨9223372036854775808,by decide⟩= -1 := by
  rw [all_word64_equivalence,all_word64_equivalence]
  decide
end FloorCT
