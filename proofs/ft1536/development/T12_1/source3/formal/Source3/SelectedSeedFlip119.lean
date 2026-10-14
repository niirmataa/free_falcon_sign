import Source3.SelectedSeedInit119

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSeedFlip119
open C99CompactState115 (reference)
open GeneratedSeed119Fixture

theorem flip_computed : ShakeSeedInvoke118.flip ctx 128 injected=some flipped := by decide +kernel

theorem flip_source : ShakeSeedReference.Flip ctx (reference injected) (reference flipped) :=
  ShakeSeedInvoke118.flip_sound ctx 128 injected flipped flip_computed

/-- The actual three source calls for the selected32-byte input, in their
    fixed local caller. The full KeyGen seed API/caller remains separate. -/
theorem source_chain :
    ShakeSeedReference.Init ctx (reference before) (.int32 512) (reference initialized) ∧
    ShakeSeedReference.Inject ctx (reference initialized) seedPointer (.uint64 32) (reference injected) ∧
    ShakeSeedReference.Flip ctx (reference injected) (reference flipped) :=
  ⟨SelectedSeedInit119.init_source,SelectedSeedInit119.inject_source,flip_source⟩

end FT1536.Source3.SelectedSeedFlip119
