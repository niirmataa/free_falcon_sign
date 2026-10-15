import Source3.FftMulShape140
import Source3.C99ExpressionEnvironment

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftPairShape140
open C99ArrayReference (Name Expr Stmt)
open FftMulShape140 (varExpr)

inductive Kind where
  | add | sub
  deriving DecidableEq, Repr

def operation : Kind → Expr → Expr → Expr
  | .add => FftWordExpressions140.add
  | .sub => FftWordExpressions140.sub

def word : Kind → BitVec 64 → BitVec 64 → BitVec 64
  | .add => FprAddFast137.word
  | .sub => FprHeadersFast137.sub

def position : Kind → Nat | .add => 6 | .sub => 7

def sourcePart (kind : Kind) : C99ProcedureReference.Stmt :=
  let parts := FftMiddleShape139.spine (FftMiddleShape139.unscoped FftMiddleShape139.butterflyBody)
  (parts[position kind]?).getD (.base .skip)

def arrayBody : C99ProcedureReference.Stmt → Stmt
  | .base code => code | _ => .skip

def unscoped : Stmt → Stmt
  | .scope _ _ code => code | code => code

def spine : Stmt → List Stmt
  | .seq first second => first::spine second
  | .skip => []
  | code => [code]

def storeIndex : Stmt → CLogic.Expr
  | .store64 _ index _ => index | _ => .literal .i32 0

def realIndex (kind : Kind) : CLogic.Expr :=
  storeIndex (((spine (unscoped (arrayBody (sourcePart kind))))[3]?).getD .skip)

def imagIndex (kind : Kind) : CLogic.Expr :=
  storeIndex (((spine (unscoped (arrayBody (sourcePart kind))))[4]?).getD .skip)

def temporaries : List Name := ["fpct_re".toList,"fpct_im".toList]

def operations (kind : Kind) : List Stmt := [
  .scalar (.declare .u64 temporaries),
  .assign "fpct_re".toList (operation kind (varExpr "a0r") (varExpr "a1r")),
  .assign "fpct_im".toList (operation kind (varExpr "a0i") (varExpr "a1i")),
  .store64 "a".toList (realIndex kind) (varExpr "fpct_re"),
  .store64 "a".toList (imagIndex kind) (varExpr "fpct_im")]

def code (kind : Kind) : Stmt := .scope temporaries [] (FpcSourceExpansion.sequence (operations kind))

theorem source_bound (kind : Kind) : sourcePart kind=.base (code kind) := by cases kind <;> rfl

theorem operation_source (kind : Kind) (state : C99ArrayReference.State) (a b : Expr) (x y : BitVec 64)
    (left : C99ArrayReference.Eval state a (.uint64 x)) (right : C99ArrayReference.Eval state b (.uint64 y)) :
    C99ArrayReference.Eval state (operation kind a b) (.uint64 (word kind x y)) := by
  cases kind
  · exact FftWordExpressions140.add_source state a b x y left right
  · exact FftWordExpressions140.sub_source state a b x y left right

theorem real_read_names (kind : Kind) :
    C99ExpressionEnvironment.readNames (C99Frontend.expression (realIndex kind))=
      match kind with | .add => ["v".toList] | .sub => ["v".toList,"ht".toList] := by cases kind <;> rfl

theorem imag_read_names (kind : Kind) :
    C99ExpressionEnvironment.readNames (C99Frontend.expression (imagIndex kind))=
      match kind with | .add => ["v".toList,"hn".toList] | .sub => ["v".toList,"ht".toList,"hn".toList] := by cases kind <;> rfl

end FT1536.Source3.FftPairShape140
