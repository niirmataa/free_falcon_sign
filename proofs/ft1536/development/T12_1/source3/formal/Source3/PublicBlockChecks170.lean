import Source3.PublicFiniteChecks170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicBlockChecks170

def block (p : Fin 1536 → Prop) [DecidablePred p] (b : Nat) : Bool :=
  (List.finRange 64).all (fun j => decide (p ⟨(64*b+j.val)%1536,Nat.mod_lt _ (by decide)⟩))

theorem sound (p : Fin 1536 → Prop) [DecidablePred p]
    (checked : ∀ b : Fin 24, block p b.val=true) (i : Fin 1536) : p i := by
  have hi:=i.isLt
  have hb : i.val/64<24 := by omega
  have hj : i.val%64<64 := Nat.mod_lt _ (by decide)
  have item := List.all_eq_true.mp (checked ⟨i.val/64,hb⟩) ⟨i.val%64,hj⟩ (by simp)
  have point := of_decide_eq_true item
  have addr : 64*(i.val/64)+i.val%64=i.val := by omega
  have index : (⟨(64*(i.val/64)+i.val%64)%1536,Nat.mod_lt _ (by decide)⟩ : Fin 1536)=i := by
    apply Fin.ext
    change (64*(i.val/64)+i.val%64)%1536=i.val
    rw [addr,Nat.mod_eq_of_lt hi]
  exact index ▸ point

end FT1536.Source3.PublicBlockChecks170
