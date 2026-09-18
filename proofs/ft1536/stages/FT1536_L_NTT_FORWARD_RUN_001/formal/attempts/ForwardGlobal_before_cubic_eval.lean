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
theorem middle_eval (ps : List (Nat × Nat)) (t : Nat) (hc : StageChain t ps)
    (pos : Nat) (hp : pos<1536) (z : Int)
    (hz : ∀ p, p∈ps → z^(p.2/2)%18433=splitLabel p.1 (p.2/2) pos%18433) (s : Mem) :
    blockEval 3 (blockBase 3 pos) (forwardMiddle ps s) z=blockEval t (blockBase t pos) s z := by
  induction ps generalizing t s with
  | nil =>
    have ht : t=3 := hc
    subst t
    rfl
  | cons p ps ih =>
    rcases p with ⟨m,u⟩
    obtain ⟨hut,heven,hh,htail⟩:=hc
    change blockEval 3 (blockBase 3 pos)
      (forwardMiddle ps (pairStage (u/2) (forwardBinaryOp m (u/2)) s)) z=_
    have htailz : ∀ p, p∈ps → z^(p.2/2)%18433=splitLabel p.1 (p.2/2) pos%18433 :=
      fun p hp => hz p (List.mem_cons_of_mem (m,u) hp)
    rw [ih (u/2) htail htailz (pairStage (u/2) (forwardBinaryOp m (u/2)) s)]
    have htu : t=2*(u/2) := hut.symm.trans heven
    rw [htu]
    exact binary_block_eval (u/2) m pos hh hp s z (hz (m,u) (by simp))


end FT1536Forward
