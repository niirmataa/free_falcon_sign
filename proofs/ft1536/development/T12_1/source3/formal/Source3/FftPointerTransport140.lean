import Source3.C99ExpressionEnvironment
import Source3.C99ArrayReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftPointerTransport140
open C99ArrayReference (State Name Pointer)

theorem source (before after : State) (name : Name) (index : CLogic.Expr)
    (pointer : C99MemoryReference.ArrayPointer)
    (address : Pointer before name index pointer)
    (binding : after.arrays name=before.arrays name)
    (same : C99ExpressionEnvironment.Agree before.locals after.locals
      (C99ExpressionEnvironment.readNames (C99Frontend.expression index))) :
    Pointer after name index pointer := by
  cases address with
  | add root pointer value bound evaluated nonnegative within =>
    exact .add name index root pointer value (binding.trans bound)
      (C99ExpressionEnvironment.transport FprPrefixCalls.calls before.locals after.locals _ _ evaluated same)
      nonnegative within

end FT1536.Source3.FftPointerTransport140
