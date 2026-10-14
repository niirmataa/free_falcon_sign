import Source3.GeneratedSeed119Fixture

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSeedInit119
open C99CompactState115 (reference)
open GeneratedSeed119Fixture

theorem static_checked : ShakeProcessCompute116.StaticGuard before.heap rcPointer := by decide +kernel

theorem init_computed : ShakeSeedInvoke118.init ctx 128 before (.i32 512)=some initialized := by decide +kernel

theorem init_source : ShakeSeedReference.Init ctx (reference before) (.int32 512) (reference initialized) :=
  ShakeSeedInvoke118.init_sound ctx 128 before initialized (.i32 512) init_computed

theorem inject_computed : ShakeSeedInvoke118.inject ctx 128 initialized seedPointer (.u64 32)=some injected := by decide +kernel

theorem inject_source : ShakeSeedReference.Inject ctx (reference initialized) seedPointer (.uint64 32) (reference injected) :=
  ShakeSeedInvoke118.inject_sound ctx 128 initialized injected seedPointer (.u64 32) inject_computed

end FT1536.Source3.SelectedSeedInit119
