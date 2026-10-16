import Source3.PublicDivisionSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicFastCalls157
open B20.C (Val)
open PublicArgumentSource157 (word)

def calls (name : B20.C.Name) (args : List Val) : Option Val :=
  if name="mq_conv_small".toList then
    match args with
    | [x,q] => some (.u32 (KeygenModpSet.word (word x) (word q)))
    | _ => none
  else if name="mq_add".toList then
    match args with
    | [x,y,q] => some (.u32 (KeygenModpAddSub.result .add (word x) (word y) (word q)))
    | _ => none
  else if name="mq_sub".toList then
    match args with
    | [x,y,q] => some (.u32 (KeygenModpAddSub.result .sub (word x) (word y) (word q)))
    | _ => none
  else if name="mq_rshift1".toList then
    match args with
    | [x,q] => some (.u32 (KeygenPublicLeafWords.half (word x) (word q)))
    | _ => none
  else if name="mq_montymul".toList then
    match args with
    | [x,y,q,qi] => some (.u32 (KeygenPublicLeafWords.montgomery (word x) (word y) (word q) (word qi)))
    | _ => none
  else if name="mq_montysqr".toList then
    match args with
    | [x,q,qi] => some (.u32 (KeygenPublicLeafWords.montgomery (word x) (word x) (word q) (word qi)))
    | _ => none
  else if name="mq_div_18433".toList then
    match args with
    | [x,y] => some (.u32 (KeygenPublicDivisionWords.division (word x) (word y)))
    | _ => none
  else none

theorem sound : C99ExpressionSound.CallsSound KeygenPublicScalar.Call calls := by
  intro name args out computed
  unfold calls at computed
  split_ifs at computed with name0 name1 name2 name3 name4 name5 name6
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest0 =>
      cases rest0 with
      | nil => cases computed
      | cons q rest1 =>
        cases rest1 with
        | cons _ _ => cases computed
        | nil =>
          have same := Option.some.inj computed
          subst out
          exact PublicArgumentSource157.conv x q
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest0 =>
      cases rest0 with
      | nil => cases computed
      | cons y rest1 =>
        cases rest1 with
        | nil => cases computed
        | cons q rest2 =>
          cases rest2 with
          | cons _ _ => cases computed
          | nil =>
            have same := Option.some.inj computed
            subst out
            exact PublicArgumentSource157.add x y q
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest0 =>
      cases rest0 with
      | nil => cases computed
      | cons y rest1 =>
        cases rest1 with
        | nil => cases computed
        | cons q rest2 =>
          cases rest2 with
          | cons _ _ => cases computed
          | nil =>
            have same := Option.some.inj computed
            subst out
            exact PublicArgumentSource157.sub x y q
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest0 =>
      cases rest0 with
      | nil => cases computed
      | cons q rest1 =>
        cases rest1 with
        | cons _ _ => cases computed
        | nil =>
          have same := Option.some.inj computed
          subst out
          exact PublicArgumentSource157.half x q
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest0 =>
      cases rest0 with
      | nil => cases computed
      | cons y rest1 =>
        cases rest1 with
        | nil => cases computed
        | cons q rest2 =>
          cases rest2 with
          | nil => cases computed
          | cons qi rest3 =>
            cases rest3 with
            | cons _ _ => cases computed
            | nil =>
              have same := Option.some.inj computed
              subst out
              exact PublicArgumentSource157.mul x y q qi
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest0 =>
      cases rest0 with
      | nil => cases computed
      | cons q rest1 =>
        cases rest1 with
        | nil => cases computed
        | cons qi rest2 =>
          cases rest2 with
          | cons _ _ => cases computed
          | nil =>
            have same := Option.some.inj computed
            subst out
            exact PublicSquareSource157.source x q qi
  · subst name
    cases args with
    | nil => cases computed
    | cons x rest0 =>
      cases rest0 with
      | nil => cases computed
      | cons y rest1 =>
        cases rest1 with
        | cons _ _ => cases computed
        | nil =>
          have same := Option.some.inj computed
          subst out
          exact PublicDivisionSource157.source x y

end FT1536.Source3.PublicFastCalls157
