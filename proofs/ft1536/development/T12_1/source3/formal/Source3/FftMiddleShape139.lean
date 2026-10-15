import Source3.NormalizedFftFirst138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMiddleShape139
open C99ProcedureReference (Stmt)

def spine : Stmt → List Stmt
  | .seq first second => first::spine second
  | .base .skip => []
  | other => [other]
def unscoped : Stmt → Stmt | .scope _ _ body => body | other => other
def scopeLocals : Stmt → List C99ArrayReference.Name | .scope locals _ _ => locals | _ => []
def scopePointers : Stmt → List C99ArrayReference.Name | .scope _ pointers _ => pointers | _ => []
def head : Stmt → Stmt | .seq first _ => first | _ => .base .skip
def tail : Stmt → Stmt | .seq _ second => second | _ => .base .skip
def condition : Stmt → CLogic.Expr | .loop test _ _ => test | _ => .literal .i32 0
def body : Stmt → Stmt | .loop _ code _ => code | _ => .base .skip
def increment : Stmt → Stmt | .loop _ _ code => code | _ => .base .skip

def setT := FftShape138.part 4
def setMinimum := FftShape138.part 5
def outerInitial := head (FftShape138.part 6)
def outerLoop := tail (FftShape138.part 6)
def outerCondition := condition outerLoop
def outerBody := body outerLoop
def outerIncrement := increment outerLoop
def outerParts := spine (unscoped outerBody)
def outerPrologue := C99ProcedureParser.chain (outerParts.take 3)
def groupInitial := head ((outerParts[3]?).getD (.base .skip))
def groupLoop := tail ((outerParts[3]?).getD (.base .skip))
def groupCondition := condition groupLoop
def groupBody := body groupLoop
def groupIncrement := increment groupLoop
def groupParts := spine (unscoped groupBody)
def groupPrologue := C99ProcedureParser.chain (groupParts.take 5)
def butterflyInitial := head ((groupParts[5]?).getD (.base .skip))
def butterflyLoop := tail ((groupParts[5]?).getD (.base .skip))
def butterflyCondition := condition butterflyLoop
def butterflyBody := body butterflyLoop
def butterflyIncrement := increment butterflyLoop
def setTNext := (outerParts[4]?).getD (.base .skip)
def tripling := FftShape138.part 7

theorem remaining_shape : FftShape138.afterFirst=
    .seq setT (.seq setMinimum (.seq (.seq outerInitial outerLoop) (.seq tripling (.base .skip)))) := by rfl

theorem outer_shape : outerLoop=.loop outerCondition outerBody outerIncrement := by rfl

theorem outer_body_shape : outerBody=.scope (scopeLocals outerBody) (scopePointers outerBody)
    (C99ProcedureParser.chain (outerParts.take 3 ++ [.seq groupInitial groupLoop,setTNext])) := by rfl

theorem group_shape : groupLoop=.loop groupCondition groupBody groupIncrement := by rfl

theorem group_body_shape : groupBody=.scope (scopeLocals groupBody) (scopePointers groupBody)
    (C99ProcedureParser.chain (groupParts.take 5 ++ [.seq butterflyInitial butterflyLoop])) := by rfl

theorem butterfly_shape : butterflyLoop=.loop butterflyCondition butterflyBody butterflyIncrement := by rfl

theorem butterfly_writes : C99ProcedureFrame138.only ["a".toList] butterflyBody=true := by decide +kernel
theorem butterfly_increment_writes : C99ProcedureFrame138.only ["a".toList] butterflyIncrement=true := by decide +kernel
theorem butterfly_arrays : KeygenAttemptSlots.procedureOnly butterflyBody=true := by decide +kernel
theorem butterfly_increment_arrays : KeygenAttemptSlots.procedureOnly butterflyIncrement=true := by decide +kernel

end FT1536.Source3.FftMiddleShape139
