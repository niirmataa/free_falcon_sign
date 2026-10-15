import Source3.FftLoadShape140
import Source3.C99LoopScalar141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLoopShape141

theorem condition : FftMiddleShape139.butterflyCondition=
    .cmp .lt (.var "v".toList) (.var "v2".toList) := by rfl

theorem increment : FftMiddleShape139.butterflyIncrement=
    .base (.scalar (.update "v".toList .add (.literal .i32 1))) := by rfl

theorem index0 : FftLoadShape140.index 0=.var "v".toList := by rfl

theorem index1 : FftLoadShape140.index 1=.bin .add (.var "v".toList) (.var "hn".toList) := by rfl

theorem index2 : FftLoadShape140.index 2=.bin .add (.var "v".toList) (.var "ht".toList) := by rfl

theorem index3 : FftLoadShape140.index 3=
    .bin .add (.bin .add (.var "v".toList) (.var "ht".toList)) (.var "hn".toList) := by rfl

end FT1536.Source3.FftLoopShape141
