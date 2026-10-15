import Source3.FpcSourceExpansion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99MacroExpand145
open FpcSourceExpansion

theorem source (kind : Kind) (args : List C99ArrayReference.Expr)
    (macroCode : FT1536.FftBind.FftSem.Macro) (ops : List C99ArrayReference.Stmt)
    (length : args.length=(parameters kind).length)
    (mapped : macroCode.mapM (operation (substitution (parameters kind) args))=some ops) :
    expandCode kind args macroCode=some (.scope (C99ArrayParser.declarations (sequence ops)) [] (sequence ops)) := by
  unfold expandCode
  split
  next bad => exact (bad length).elim
  next =>
    rw [mapped]
    rfl

end FT1536.Source3.C99MacroExpand145
