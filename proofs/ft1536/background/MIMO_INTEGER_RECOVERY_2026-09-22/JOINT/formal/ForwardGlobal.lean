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

theorem forwardMem_eval (s : Mem) (hs : CanonMem s) (b : Fin 512) (j : Fin 3) :
    forwardMem s (3*b.val+j.val)=peval 1536 s (node b.val j) := by
  obtain ⟨hr,hb,hphi,hcube⟩:=leaf_facts b.val b.isLt j
  have hp : 3*b.val<1536 := by have h:=b.isLt; omega
  let root:=pairStage 768 forwardRootOp s
  let mid:=forwardMiddle (forwardSchedule 9 2 768) root
  have hm : CanonMem mid := forwardMiddle_canonical _ forward_params_half root (froot_canonical s hs)
  have hbase : blockBase 3 (3*b.val)=3*b.val := by unfold blockBase; omega
  calc
    forwardMem s (3*b.val+j.val)=blockEval 3 (3*b.val) mid (node b.val j) := cubic_eval b.val b.isLt mid hm j _ hcube
    _ = blockEval 3 (blockBase 3 (3*b.val)) mid (node b.val j) := by rw [hbase]
    _ = blockEval 768 (blockBase 768 (3*b.val)) root (node b.val j) :=
      middle_eval _ 768 actual_chain (3*b.val) hp _ hb root
    _ = peval 1536 s (node b.val j) := root_block_eval _ hp s _ hr

theorem forwardC_eval (v : Vec) (hv : CanonVec v) (b : Fin 512) (j : Fin 3) :
    forwardC v ⟨3*b.val+j.val,by have h:=b.isLt;have hj:=j.isLt;omega⟩=
      peval 1536 (fromVec v) (node b.val j) :=
  forwardMem_eval (fromVec v) (fromVec_canonical v hv) b j

theorem FORWARD_GLOBAL (v : Vec) (hv : CanonVec v) (b : Fin 512) (j : Fin 3) :
    forwardC v ⟨3*b.val+j.val,by have h:=b.isLt;have hj:=j.isLt;omega⟩=
      (sumN 1536 (fun k => fromVec v k*(ordinary (gmAt (512+b.val))*14648^j.val)^k))%18433 := by
  exact (forwardC_eval v hv b j).trans
    (eval_mod_node 1536 (fromVec v) (ordinary (gmAt (512+b.val))*14648^j.val))

theorem fromVec_canonical_mod (v : Vec) :
    fromVec (FT1536Composition.canonical v)=(fun k => fromVec v k%18433) := by
  funext k
  by_cases hk : k<1536 <;> simp [fromVec,FT1536Composition.canonical,hk]
theorem liftForward_eval (v : Vec) (b : Fin 512) (j : Fin 3) :
    liftForward v ⟨3*b.val+j.val,by have h:=b.isLt;have hj:=j.isLt;omega⟩=
      peval 1536 (fromVec v) (node b.val j) := by
  unfold liftForward
  rw [forwardC_eval _ (canonicalVec v),fromVec_canonical_mod,eval_mod_coeff]
theorem node_zero (b : Nat) (hb : b<512) (j : Fin 3) : PhiZero (node b j) := (leaf_facts b hb j).2.2.1

#check @middle_eval
#check @FORWARD_GLOBAL
#check @liftForward_eval
#check @node_zero
#print axioms actual_chain
#print axioms middle_eval
#print axioms cubic_eval
#print axioms forwardMem_eval
#print axioms forwardC_eval
#print axioms FORWARD_GLOBAL
#print axioms fromVec_canonical_mod
#print axioms liftForward_eval
#print axioms node_zero
end FT1536Forward
