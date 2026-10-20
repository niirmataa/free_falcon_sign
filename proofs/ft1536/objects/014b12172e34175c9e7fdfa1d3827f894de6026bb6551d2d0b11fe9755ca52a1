import Run2.ConcreteReduction
import FT1536.GameNames
import FT1536.BitCost

namespace FT1536.Run2.MiMoIntegration

def nonceToOurs (r : FT1536.GameByte.Nonce) : Run2.Nonce :=
  ⟨FT1536.GameByte.nonceBytes r,FT1536.GameByte.nonceBytes_length r⟩

def nonceToMiMo (r : Run2.Nonce) : FT1536.GameByte.Nonce :=
  FT1536.GameByte.nonceOf r.val r.property

theorem nonce_roundtrip_mimo (r : FT1536.GameByte.Nonce) : nonceToMiMo (nonceToOurs r)=r :=
  FT1536.GameByte.nonceOf_nonceBytes r

theorem nonce_roundtrip_ours (r : Run2.Nonce) : nonceToOurs (nonceToMiMo r)=r := by
  apply Subtype.ext
  exact FT1536.GameByte.nonceBytes_nonceOf r.val r.property

def nonceEquiv : FT1536.GameByte.Nonce ≃ Run2.Nonce where
  toFun := nonceToOurs
  invFun := nonceToMiMo
  left_inv := nonce_roundtrip_mimo
  right_inv := nonce_roundtrip_ours

theorem frame_agrees (r : FT1536.GameByte.Nonce) (m : Run2.Bytes) :
    Run2.frame (nonceToOurs r) m=FT1536.GameByte.signName r m := rfl

theorem parsed_frame_agrees (r : FT1536.GameByte.Nonce) (m : Run2.Bytes) :
    Run2.parse (FT1536.GameByte.signName r m)=(some (nonceToOurs r),m) :=
  Run2.parse_frame (nonceToOurs r) m

theorem byte_frontends_same_name (x : Run2.Bytes) :
    Run2.unparse (Run2.parse x)=FT1536.GameByte.render (FT1536.GameNames.decodeName x) := by
  rw [Run2.unparse_parse,FT1536.GameNames.render_decodeName]

/- Reuse the genuinely generic MiMo cost-sum theorem. Primitive costs below
are actual component bounds to be supplied/proved by the reference code,
not MiMo's unbound hard-coded price table. Persistent storage is separate. -/
theorem integrated_component_cost_sum (actual caps : List FT1536.BitCost.Cost)
    (h : List.Forall₂ (fun a b => a≤b) actual caps) : actual.sum≤caps.sum := by
  induction h with
  | nil => exact ⟨Nat.le_refl _,Nat.le_refl _,Nat.le_refl _⟩
  | @cons a b as bs hab htail ih =>
    rcases hab with ⟨ht,hw,hL⟩
    rcases ih with ⟨iht,ihw,ihL⟩
    exact ⟨Nat.add_le_add ht iht,Nat.add_le_add hw ihw,Nat.add_le_add hL ihL⟩

theorem integrated_cost_components (costs : List FT1536.BitCost.Cost) :
    costs.sum.t=(costs.map (fun c => c.t)).sum ∧
    costs.sum.w=(costs.map (fun c => c.w)).sum ∧
    costs.sum.L=(costs.map (fun c => c.L)).sum := FT1536.BitCost.sum_comp costs

end FT1536.Run2.MiMoIntegration
