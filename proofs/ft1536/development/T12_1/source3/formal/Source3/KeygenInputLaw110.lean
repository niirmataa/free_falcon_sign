import Source3.KeygenByteFacts109
import Source3.KeygenWholeLaw088
import Mathlib.SetTheory.Cardinal.Finite

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenInputLaw110
open KeygenSeedEntry089 (Seed)

def byteEquiv : BitVec 8 ≃ Fin (2^8) where
  toFun := BitVec.toFin
  invFun := BitVec.ofFin
  left_inv x := by cases x; rfl
  right_inv x := rfl

theorem seed_card : Fintype.card Seed = 2^256 := by
  rw [Fintype.card_eq_nat_card]
  change Nat.card (Fin 32 → BitVec 8) = 2^256
  rw [Nat.card_fun, Nat.card_fin, Nat.card_congr byteEquiv, Nat.card_fin]
  norm_num

/-- Existing A2 input boundary: ONE uniform32-byte object for the whole
    public replacement-seed call, not a fresh draw for each attempt. -/
noncomputable def seedLaw : Law Seed := Law.uniform

theorem seed_mass (seed : Seed) : seedLaw.mass seed = 1 / (2:ℝ)^256 := by
  simp [seedLaw, Law.uniform, seed_card]
  norm_num

end FT1536.Source3.KeygenInputLaw110
