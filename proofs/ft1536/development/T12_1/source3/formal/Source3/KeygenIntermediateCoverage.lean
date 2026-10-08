import Source3.KeygenIntermediateParser

/- Reject a word-level fallback to a name outside the closed modular table.
   Actual structured calls already carry a fixed Kind with a bound body. -/
namespace FT1536.Source3.KeygenIntermediateCoverage
def scalar : CLogic.Expr → Bool
  | .var _ | .literal _ _ => true
  | .cast _ e | .neg e | .bitNot e | .lnot e => scalar e
  | .bin _ a b | .cmp _ a b | .land a b | .lor a b => scalar a && scalar b
  | .call1 _ _ | .call2 _ _ _ | .call3 _ _ _ _ => false
def word : KeygenWordExpr.Expr → Bool
  | .scalar e => scalar e
  | .load32 _ index | .load16 _ index => scalar index
  | .cast _ e | .neg e | .bitNot e | .lnot e => word e
  | .bin _ a b | .cmp _ a b | .land a b | .lor a b => word a && word b
  | .call1 n a => (["modp_ninv31","modp_R"].map String.toList).contains n && word a
  | .call2 n a b => (["modp_set","modp_R2"].map String.toList).contains n && word a && word b
  | .call3 n a b c => (["modp_add","modp_sub"].map String.toList).contains n && word a && word b && word c
  | .call4 n a b c d => (["modp_montymul","modp_Rx"].map String.toList).contains n && word a && word b && word c && word d
  | .call5 n a b c d e => n=="modp_div".toList && word a && word b && word c && word d && word e
def pointer : KeygenIntermediateMemory.Expr → Bool
  | .named _ | .tmp => true
  | .cast _ e => pointer e
  | .add e index => pointer e && scalar index
  | .align32 a b | .align64 a b => pointer a && pointer b
def expression : KeygenIntermediateCalls.Expr → Bool
  | .word e => word e
  | .load64 _ index | .rint _ index | .prime _ index _ => scalar index
  | .logn | .ternary => true
  | .pointerLt a b => pointer a && pointer b
  | .land a b => expression a && expression b
def argument : KeygenIntermediateCalls.Arg → Bool
  | .scalar e => expression e
  | .pointer e => pointer e
def scalarStatement : CLogic.Stmt → Bool
  | .declare _ _ => true
  | .assign _ e | .update _ _ e | .ret e => scalar e
def statement : KeygenIntermediateExec.Stmt → Bool
  | .skip | .declarePtr _ | .breakLoop | .continueLoop => true
  | .scalar s => scalarStatement s
  | .pointer _ e => pointer e
  | .assign _ e | .ret e => expression e
  | .store _ i e => scalar i && expression e
  | .move a b n => pointer a && pointer b && scalar n
  | .call _ args dst => args.all argument && match dst with
    | .discard | .into _ => true
    | .store _ index => scalar index
  | .seq a b => statement a && statement b
  | .scope _ _ body => statement body
  | .branch c a b | .loop c a b => expression c && statement a && statement b
theorem sequence (a b : KeygenIntermediateExec.Stmt) : statement (.seq a b)=(statement a && statement b) := rfl
end FT1536.Source3.KeygenIntermediateCoverage
