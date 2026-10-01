import Source3.C99ModularParser

namespace FT1536.Source3.C99ModularAnnotation
open C99ModularReference
open C99ArrayReference (Name)

/- Elaborate the signed16 reads from the enclosing source declaration.
   Scalar operators, indices, call arguments and destination widths persist. -/
def expression (names : List Name) : Expr → Expr
  | .load32 name index => if names.contains name then .load16 name index else .load32 name index
  | .call1 name a => .call1 name (expression names a)
  | .call2 name a b => .call2 name (expression names a) (expression names b)
  | .call3 name a b c => .call3 name (expression names a) (expression names b) (expression names c)
  | .call4 name a b c d => .call4 name (expression names a) (expression names b) (expression names c) (expression names d)
  | e => e
def statement (names : List Name) : Stmt → Stmt
  | .base code => .base code
  | .assign name e => .assign name (expression names e)
  | .store32 name index e => .store32 name index (expression names e)
  | .seq a b => .seq (statement names a) (statement names b)
  | .scope locals body => .scope locals (statement names body)
  | .branch condition yes no => .branch condition (statement names yes) (statement names no)
  | .loop condition body increment => .loop condition (statement names body) (statement names increment)
  | .ret e => .ret (expression names e)

end FT1536.Source3.C99ModularAnnotation
