import Source3.SelectedBezoutLoopLine217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Parser structural facts quantified over an arbitrary unparsed suffix. -/
namespace FT1536.Source3.BezoutParserPrefix217
open KeygenZintCall (Stmt)
open B20.C (Token)
open KeygenWordExpr (Expr Types)

def guardTokens : List Token := ["alen".toList,">=".toList,"3".toList,"||".toList,"blen".toList,">=".toList,"3".toList,")".toList]

theorem guard_prefix (types : Types) (ptrs : List C99ArrayReference.Name) (tail : List Token) :
    KeygenWordExpr.expression (KeygenZintCall.env types ptrs) (guardTokens++tail)=
      some (BezoutLoopGuard217.condition,")".toList::tail) := by
  rfl

end FT1536.Source3.BezoutParserPrefix217
