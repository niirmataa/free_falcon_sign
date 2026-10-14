import Source3.SelectedReady124

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedImages124
open C99CompactState115 (reference)

/-- Comparison conclusions, never premises of the actual source calls. -/
theorem injected_image : ∀ i : Fin 416,
    (reference SelectedInput124.seeded).heap.bytes 1 (8+i.val)=
      some (GeneratedSeed119Fixture.seededBytes[i.val]!) := by decide +kernel

theorem ready_image : ∀ i : Fin 416,
    (reference SelectedReady124.ready).heap.bytes 1 (8+i.val)=
      some (GeneratedSeed119Fixture.flippedBytes[i.val]!) := by decide +kernel

theorem seed_flags : C99FiniteRead114.read32 SelectedInput124.seeded.heap
    (KeygenReadyFast.field KeygenCallerData123.env.ctx .seeded)=some 1 ∧
    C99FiniteRead114.read32 SelectedInput124.seeded.heap
      (KeygenReadyFast.field KeygenCallerData123.env.ctx .flipped)=some 0 := by decide +kernel

theorem ready_flags : C99FiniteRead114.read32 SelectedReady124.ready.heap
    (KeygenReadyFast.field KeygenCallerData123.env.ctx .seeded)=some 1 ∧
    C99FiniteRead114.read32 SelectedReady124.ready.heap
      (KeygenReadyFast.field KeygenCallerData123.env.ctx .flipped)=some 1 := by decide +kernel

end FT1536.Source3.SelectedImages124
