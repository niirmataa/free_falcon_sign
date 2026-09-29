import LeafChecks
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Forward
open FT1536Global

theorem leaf_facts (b : Nat) (hb : b<512) (j : Fin 3) :
    let pos:=3*b;let z:=node b j
    z^768%18433=rootLabel pos%18433 ∧
    (∀ p, p∈forwardSchedule 9 2 768 → z^(p.2/2)%18433=splitLabel p.1 (p.2/2) pos%18433) ∧
    PhiZero z ∧ (∀ k, (cubeFExpr (gmAt (512+b)) fW j).eval (basis k)=z^k.val%18433) := by
  have hi : 512+b<1024 := by omega
  have h:=FT1536Tables.all_sound _ _ leaf_checked (unitRow ⟨512+b,hi⟩) (List.get_mem _ _)
  have hidx : rowID (unitRow ⟨512+b,hi⟩)=(512+b : Nat) := unitRow_id _
  have hn : ¬rowID (unitRow ⟨512+b,hi⟩)<512 := by rw [hidx]; omega
  simp only [leafCheck,ite_eq_right hn] at h
  have hnode:=nodeCheck_sound _ _ j (List.all_eq_true.mp h j (fin3_mem j))
  have hg : rowGM (unitRow ⟨512+b,hi⟩)=gmAt (512+b) := by simp only [gmAt,dite_eq_left hi,gm]
  rw [hidx,hg] at hnode
  simpa only [Int.toNat_natCast,Nat.add_sub_cancel_left,node] using hnode

#check @leaf_facts
#print axioms leaf_facts
end FT1536Forward
