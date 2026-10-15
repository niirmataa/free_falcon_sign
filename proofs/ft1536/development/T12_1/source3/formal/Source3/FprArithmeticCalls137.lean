import Source3.FprAddFast137
import Source3.FprMulFast137

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprArithmeticCalls137
open B20.C (Val)

def calls (name : B20.C.Name) (args : List Val) : Option Val :=
  if name="fpr_add".toList then
    match args with
    | [x,y] => match x,y with
      | .u64 x,.u64 y => some (.u64 (FprAddFast137.word x y))
      | _,_ => none
    | _ => none
  else if name="fpr_mul".toList then
    match args with
    | [x,y] => match x,y with
      | .u64 x,.u64 y => some (.u64 (FprMulFast137.word x y))
      | _,_ => none
    | _ => none
  else none

theorem sound : C99ExpressionSound.CallsSound FprPrefixCalls.ofCalls calls := by
  intro name args out computed
  unfold calls at computed
  split_ifs at computed with addName mulName
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest =>
      cases rest with
      | nil => cases computed
      | cons y tail =>
        cases tail with
        | cons _ _ => cases computed
        | nil =>
          cases x <;> cases y <;> try (solve | cases computed)
          case u64.u64 x y =>
            have same := Option.some.inj computed
            subst out
            exact FprAddFast137.source x y
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest =>
      cases rest with
      | nil => cases computed
      | cons y tail =>
        cases tail with
        | cons _ _ => cases computed
        | nil =>
          cases x <;> cases y <;> try (solve | cases computed)
          case u64.u64 x y =>
            have same := Option.some.inj computed
            subst out
            exact FprMulFast137.source x y

end FT1536.Source3.FprArithmeticCalls137
