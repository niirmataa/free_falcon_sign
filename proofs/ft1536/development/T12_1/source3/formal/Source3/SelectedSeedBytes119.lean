import Source3.SelectedSeedFlip119
import Source3.KeygenSeedEntry089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSeedBytes119
open C99CompactState115 (reference)
open GeneratedSeed119Fixture

def seed : KeygenSeedEntry089.Seed := fun i => seedBytes[i.val]!

theorem lengths : seedBytes.length=32 ∧ newBytes.length=416 ∧ seededBytes.length=416 ∧ flippedBytes.length=416 := by decide +kernel

theorem input_image : ∀ i : Fin 32, (reference before).heap.bytes 0 i.val=some (seed i) := by decide +kernel

theorem new_image : ∀ i : Fin 416, (reference before).heap.bytes 1 (8+i.val)=some (newBytes[i.val]!) := by decide +kernel

theorem initialized_image : ∀ i : Fin 416, (reference initialized).heap.bytes 1 (8+i.val)=some (newBytes[i.val]!) := by decide +kernel

theorem injected_image : ∀ i : Fin 416, (reference injected).heap.bytes 1 (8+i.val)=some (seededBytes[i.val]!) := by decide +kernel

theorem flipped_image : ∀ i : Fin 416, (reference flipped).heap.bytes 1 (8+i.val)=some (flippedBytes[i.val]!) := by decide +kernel

end FT1536.Source3.SelectedSeedBytes119
