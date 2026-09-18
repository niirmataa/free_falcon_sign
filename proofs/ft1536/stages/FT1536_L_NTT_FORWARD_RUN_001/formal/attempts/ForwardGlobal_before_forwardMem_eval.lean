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

theorem cubic_eval (b : Nat) (hb : b<512) (s : Mem) (hs : CanonMem s) (j : Fin 3)
    (z : Int) (hc : ∀ k, (cubeFExpr (gmAt (512+b)) fW j).eval (basis k)=z^k.val%18433) :
    tripleStage forwardCubicOp s (3*b+j.val)=blockEval 3 (3*b) s z := by
  have hv : ∀ k : Fin 3, CanonVal (s (3*b+k.val)) := fun k => hs _ (triple_address_bound b hb k)
  have hl:=FT1536Global.eval_linear (cubeFExpr (gmAt (512+b)) fW j) (fun k => s (3*b+k.val)) hv
  rw [cubeF_bind b, hc 0,hc 1,hc 2] at hl
  change tripleStage forwardCubicOp s (tripleAddr b j)=_
  rw [triple_stage_at]
  · change forwardCubicOp b (fun k => s (3*b+k.val)) j=_
    rw [hl]
    simp [FT1536Linear.dot3,blockEval,peval,sumN,Int.pow_one,Int.add_emod,Int.mul_emod,Int.mul_comm]
  · exact hb


end FT1536Forward
