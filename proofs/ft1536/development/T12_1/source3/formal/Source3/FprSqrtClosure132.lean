import Source3.GeneratedSqrt132

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprSqrtClosure132
open B20.C (Name)

def expression : CLogic.Expr → List Name
  | .literal _ _ | .var _ => []
  | .cast _ e | .neg e | .bitNot e | .lnot e => expression e
  | .bin _ a b | .cmp _ a b | .land a b | .lor a b => expression a++expression b
  | .call1 name a => name::expression a
  | .call2 name a b => name::(expression a++expression b)
  | .call3 name a b c => name::(expression a++expression b++expression c)

def statement : CLogic.Stmt → List Name
  | .declare _ _ => []
  | .assign _ e | .update _ _ e | .ret e => expression e

def names : List Name :=
  (GeneratedSqrt132.code.pre++GeneratedSqrt132.code.round++GeneratedSqrt132.code.tail).flatMap statement ++
  expression FprSqrtSyntax132.condition ++ statement FprSqrtSyntax132.increment

theorem only_pack : names=["FPR".toList] := by decide +kernel

theorem pack_no_callees : FprAST.packCode.body.flatMap statement=[] := by decide +kernel

theorem pack_lookup : C99Frontend.lookup "FPR".toList=some (C99Frontend.headerFunction FprAST.packCode) := by rfl

end FT1536.Source3.FprSqrtClosure132
