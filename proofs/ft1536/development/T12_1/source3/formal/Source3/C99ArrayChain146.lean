import Source3.FpcSourceExpansion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ArrayChain146
open C99ArrayReference (State Program Stmt Exec)
open FpcSourceExpansion (sequence)

theorem append (program : Program) (first rest : List Stmt) (before middle after : State)
    (head : Exec program (sequence first) before middle) (tail : Exec program (sequence rest) middle after) :
    Exec program (sequence (first++rest)) before after := by
  induction first generalizing before with
  | nil => cases head; exact tail
  | cons code codes ih =>
    cases head with
    | seq _ _ _ next _ source remaining => exact .seq _ _ _ _ _ source (ih next remaining)

end FT1536.Source3.C99ArrayChain146
