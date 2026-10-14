import Source3.C99ScalarReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ScalarTransport090
open C99ScalarReference

def CallsMap (a b : CallRelation) : Prop := ∀ name args value, a name args value → b name args value

theorem expression (a b : CallRelation) (mapped : CallsMap a b) (env : Env) (e : Expr)
    (v : C99IntegerReference.Value) (source : Eval a env e v) : Eval b env e v := by
  induction source with
  | literal t n => exact .literal t n
  | «variable» name ty v bound => exact .variable name ty v bound
  | cast t e v source ih => exact .cast t e v ih
  | neg e v z source operation ih => exact .neg e v z ih operation
  | complement e v z source operation ih => exact .complement e v z ih operation
  | arithmetic op left right x y z first second operation ih1 ih2 =>
      exact .arithmetic op left right x y z ih1 ih2 operation
  | bitwise op left right x y z first second operation ih1 ih2 =>
      exact .bitwise op left right x y z ih1 ih2 operation
  | shift op left right x y z first second operation ih1 ih2 =>
      exact .shift op left right x y z ih1 ih2 operation
  | compare op left right x y z first second operation ih1 ih2 =>
      exact .compare op left right x y z ih1 ih2 operation
  | logicalNot e v source ih => exact .logicalNot e v ih
  | andFalse left right v source zero ih => exact .andFalse left right v ih zero
  | andTrue left right x y first nonzero second ih1 ih2 => exact .andTrue left right x y ih1 nonzero ih2
  | orTrue left right v source nonzero ih => exact .orTrue left right v ih nonzero
  | orFalse left right x y first zero second ih1 ih2 => exact .orFalse left right x y ih1 zero ih2
  | call1 name e x z source call ih => exact .call1 name e x z ih (mapped name [x] z call)
  | call2 name e f x y z first second call ih1 ih2 =>
      exact .call2 name e f x y z ih1 ih2 (mapped name [x,y] z call)
  | call3 name e f g x y z out first second third call ih1 ih2 ih3 =>
      exact .call3 name e f g x y z out ih1 ih2 ih3 (mapped name [x,y,z] out call)

theorem execution (a b : CallRelation) (mapped : CallsMap a b) (env : Env) (code : Stmt) (out : Result)
    (source : Exec a env code out) : Exec b env code out := by
  induction source with
  | skip env => exact .skip env
  | declare env ty name => exact .declare env ty name
  | assign env name rhs ty old v declared value =>
      exact .assign env name rhs ty old v declared (expression a b mapped env rhs v value)
  | seqNormal env middle left right out first second ih1 ih2 => exact .seqNormal env middle left right out ih1 ih2
  | seqReturn env left right v first ih => exact .seqReturn env left right v ih
  | blockNormal env inner names body source ih => exact .blockNormal env inner names body ih
  | blockReturn env names body v source ih => exact .blockReturn env names body v ih
  | whileFalse env cond body v evaluated zero =>
      exact .whileFalse env cond body v (expression a b mapped env cond v evaluated) zero
  | whileTrue env middle cond body v out evaluated nonzero iteration rest ih1 ih2 =>
      exact .whileTrue env middle cond body v out (expression a b mapped env cond v evaluated) nonzero ih1 ih2
  | whileReturn env cond body v z evaluated nonzero iteration ih =>
      exact .whileReturn env cond body v z (expression a b mapped env cond v evaluated) nonzero ih
  | ret env e v evaluated => exact .ret env e v (expression a b mapped env e v evaluated)

end FT1536.Source3.C99ScalarTransport090
