import Source3.C99ProcedureParser

/- Type-directed elaboration for a declared narrow read-only array. The
   frontend still rejects unsupported expression syntax. The caller binds
   the declaration's name and signedness to the source header. -/
namespace FT1536.Source3.C99NarrowAnnotation
open C99ArrayReference (Name Expr)

def expression (name : Name) (isSigned : Bool) : Expr → Expr
  | .load array index => if array=name then .load16 isSigned array index else .load array index
  | .call1 function a => .call1 function (expression name isSigned a)
  | .call2 function a b => .call2 function (expression name isSigned a) (expression name isSigned b)
  | e => e

def arrayStatement (name : Name) (isSigned : Bool) : C99ArrayReference.Stmt → C99ArrayReference.Stmt
  | .assign target value => .assign target (expression name isSigned value)
  | .store64 array index value => .store64 array index (expression name isSigned value)
  | .store32 array index value => .store32 array index (expression name isSigned value)
  | .seq first second => .seq (arrayStatement name isSigned first) (arrayStatement name isSigned second)
  | .scope locals pointers body => .scope locals pointers (arrayStatement name isSigned body)
  | .branch condition yes no => .branch condition (arrayStatement name isSigned yes) (arrayStatement name isSigned no)
  | .while condition body => .while condition (arrayStatement name isSigned body)
  | s => s

def statement (name : Name) (isSigned : Bool) : C99ProcedureReference.Stmt → C99ProcedureReference.Stmt
  | .base code => .base (arrayStatement name isSigned code)
  | .seq first second => .seq (statement name isSigned first) (statement name isSigned second)
  | .scope locals pointers body => .scope locals pointers (statement name isSigned body)
  | .branch condition yes no => .branch condition (statement name isSigned yes) (statement name isSigned no)
  | .loop condition body increment => .loop condition (statement name isSigned body) (statement name isSigned increment)
  | .ret value => .ret (value.map (expression name isSigned))
  | s => s

end FT1536.Source3.C99NarrowAnnotation
