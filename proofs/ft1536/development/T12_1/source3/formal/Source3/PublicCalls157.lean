import Source3.PublicFastCalls157
import Source3.PublicRevSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicCalls157
open B20.C (Val)

def calls (name : B20.C.Name) (args : List Val) : Option Val :=
  if name="rev10".toList then
    match args with
    | [x] => some (.u32 (KeygenPublicRev.reversed 10 (PublicArgumentSource157.word x) 0))
    | _ => none
  else PublicFastCalls157.calls name args

/-- Exact source rules for the eight scalar helpers used on the pinned ternary public path. -/
theorem sound : C99ExpressionSound.CallsSound KeygenPublicScalar.Call calls := by
  intro name args out computed
  unfold calls at computed
  split_ifs at computed with revName
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest =>
      cases rest with
      | cons _ _ => cases computed
      | nil =>
        have same := Option.some.inj computed
        subst out
        exact PublicRevSource157.source x
  · exact PublicFastCalls157.sound name args out computed

end FT1536.Source3.PublicCalls157
