import Source3.C99ScalarReference

/- Pure expression evaluation depends only on the variables it reads.
   Calls retain their original source relation and evaluated arguments. -/
namespace FT1536.Source3.C99ExpressionEnvironment
open C99ScalarReference

def readNames : Expr → List Name
  | .literal _ _ => []
  | .variable name => [name]
  | .cast _ e | .neg e | .complement e | .logicalNot e | .call1 _ e => readNames e
  | .arithmetic _ a b | .bitwise _ a b | .shift _ a b | .compare _ a b |
    .logicalAnd a b | .logicalOr a b | .call2 _ a b => readNames a++readNames b
  | .call3 _ a b c => readNames a++readNames b++readNames c

def Agree (before after : Env) (names : List Name) : Prop := ∀ name∈names, before name=after name
theorem agree_left (before after : Env) (a b : List Name) (h : Agree before after (a++b)) :
    Agree before after a := fun name hn => h name (List.mem_append.mpr (Or.inl hn))
theorem agree_right (before after : Env) (a b : List Name) (h : Agree before after (a++b)) :
    Agree before after b := fun name hn => h name (List.mem_append.mpr (Or.inr hn))

theorem transport (calls : CallRelation) (before after : Env) (e : Expr) (v : C99IntegerReference.Value)
    (source : Eval calls before e v) (same : Agree before after (readNames e)) : Eval calls after e v := by
  induction source with
  | literal t n => exact .literal t n
  | «variable» name ty v bound =>
      exact .variable name ty v ((same name (by simp [readNames])).symm.trans bound)
  | cast t e v h ih => exact .cast t e v (ih same)
  | neg e v z h op ih => exact .neg e v z (ih same) op
  | complement e v z h op ih => exact .complement e v z (ih same) op
  | arithmetic op a b x y z ha hb operation iha ihb =>
      exact .arithmetic op a b x y z (iha (agree_left _ _ _ _ same)) (ihb (agree_right _ _ _ _ same)) operation
  | bitwise op a b x y z ha hb operation iha ihb =>
      exact .bitwise op a b x y z (iha (agree_left _ _ _ _ same)) (ihb (agree_right _ _ _ _ same)) operation
  | shift op a b x y z ha hb operation iha ihb =>
      exact .shift op a b x y z (iha (agree_left _ _ _ _ same)) (ihb (agree_right _ _ _ _ same)) operation
  | compare op a b x y z ha hb operation iha ihb =>
      exact .compare op a b x y z (iha (agree_left _ _ _ _ same)) (ihb (agree_right _ _ _ _ same)) operation
  | logicalNot e v h ih => exact .logicalNot e v (ih same)
  | andFalse a b v h hz ih => exact .andFalse a b v (ih (agree_left _ _ _ _ same)) hz
  | andTrue a b x y ha hn hb iha ihb =>
      exact .andTrue a b x y (iha (agree_left _ _ _ _ same)) hn (ihb (agree_right _ _ _ _ same))
  | orTrue a b v h hn ih => exact .orTrue a b v (ih (agree_left _ _ _ _ same)) hn
  | orFalse a b x y ha hz hb iha ihb =>
      exact .orFalse a b x y (iha (agree_left _ _ _ _ same)) hz (ihb (agree_right _ _ _ _ same))
  | call1 name e a z he hc ih => exact .call1 name e a z (ih same) hc
  | call2 name e f a b z he hf hc ihe ihf =>
      exact .call2 name e f a b z (ihe (agree_left _ _ _ _ same)) (ihf (agree_right _ _ _ _ same)) hc
  | call3 name e f g a b c z he hf hg hc ihe ihf ihg =>
      have hab := agree_left _ _ _ _ same
      exact .call3 name e f g a b c z (ihe (agree_left _ _ _ _ hab)) (ihf (agree_right _ _ _ _ hab))
        (ihg (agree_right _ _ _ _ same)) hc

end FT1536.Source3.C99ExpressionEnvironment
