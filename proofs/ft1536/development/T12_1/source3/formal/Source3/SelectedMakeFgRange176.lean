import Source3.SelectedMakeFgConvert176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMakeFgRange176

theorem word_range (w : BitVec 16) (small : w=0 ∨ w=1 ∨ w=65535) :
    (MakeFgConversionBody176.word w).toNat<KeygenNinv31.prime.toNat := by
  rcases small with rfl|rfl|rfl <;> decide +kernel

theorem f_range (i : Fin 1536) : (SelectedMakeFgConvert176.fImage i).toNat<KeygenNinv31.prime.toNat :=
  word_range _ (SelectedPublicBounds158.sound _ SelectedPublicBounds158.f_checked i)
theorem g_range (i : Fin 1536) : (SelectedMakeFgConvert176.gImage i).toNat<KeygenNinv31.prime.toNat :=
  word_range _ (SelectedPublicBounds158.sound _ SelectedPublicBounds158.g_checked i)

end FT1536.Source3.SelectedMakeFgRange176
