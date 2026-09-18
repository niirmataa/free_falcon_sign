import LeafFacts
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Forward
open FT1536Global

def StageChain : Nat → List (Nat × Nat) → Prop
  | t,[] => t=3
  | t,(_m,u)::ps => u=t ∧ u=2*(u/2) ∧ HalfOK (u/2) ∧ StageChain (u/2) ps

theorem actual_chain : StageChain 768 (forwardSchedule 9 2 768) := by
  simp [forward_schedule,StageChain,HalfOK]

-- Induction over the ACTUAL ordered stage list; the selected block follows
-- physical pos. Stage-local equalities consume the imported in-place proof.

end FT1536Forward
