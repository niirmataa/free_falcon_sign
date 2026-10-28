import Source3.BezoutParserLoopScope217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The loop-local int r declaration is parsed from any matching token prefix. -/
namespace FT1536.Source3.BezoutParserDecl217
open KeygenWordExpr (Types)
open B20.C (Token)

def declaration : KeygenZintCall.Stmt := ZintNormWord194.wordScalar (.declare .i32 ["r".toList])

theorem parsed (types : Types) (ptrs : List C99ArrayReference.Name) (fuel : Nat) (tail : List Token) :
    KeygenZintCall.parseStatement types ptrs (fuel+1)
      (["int".toList,"r".toList,";".toList]++tail)=some (declaration,ptrs,tail) := by rfl

end FT1536.Source3.BezoutParserDecl217
