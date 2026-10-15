import Source3.FftMiddleShape139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftControlShape142

theorem group_condition : FftMiddleShape139.groupCondition=
    .cmp .lt (.var "u1".toList) (.var "hm".toList) := by rfl

theorem group_increment : FftMiddleShape139.groupIncrement=
    .seq (.base (.scalar (.update "u1".toList .add (.literal .i32 1))))
      (.base (.scalar (.update "v1".toList .add (.var "t".toList)))) := by rfl

theorem next_t : FftMiddleShape139.setTNext=.base (.assign "t".toList (.scalar (.var "ht".toList))) := by rfl

theorem outer_increment : FftMiddleShape139.outerIncrement=
    .base (.scalar (.update "m".toList .shl (.literal .i32 1))) := by rfl

theorem group_names : FftMiddleShape139.scopeLocals FftMiddleShape139.groupBody=
    ["v".toList,"v2".toList,"sr".toList,"si".toList] := by rfl

theorem group_pointers : FftMiddleShape139.scopePointers FftMiddleShape139.groupBody=[] := by rfl

end FT1536.Source3.FftControlShape142
