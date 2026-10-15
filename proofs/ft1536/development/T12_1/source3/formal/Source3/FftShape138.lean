import Source3.GeneratedFft138Syntax
import Source3.KeygenSmallShape136
import Source3.C99ProcedureNormalize138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftShape138
open C99ProcedureReference (Stmt)

def args (destination : String) : List C99ArrayReference.Arg :=
  [.pointer destination.toList (.literal .u64 0),.scalar (.var "logn".toList),.scalar (.literal .i32 1)]

def remaining : KeygenSearchExec.Stmt :=
  match KeygenSmallShape136.remaining with
  | .seq (.procedure _) (.seq (.procedure _) tail) => tail
  | _ => KeygenSearchExec.skip

theorem caller_shape : KeygenSmallShape136.remaining=
    .seq (.procedure (.call "falcon_FFT3".toList (args "rt1") .discard))
      (.seq (.procedure (.call "falcon_FFT3".toList (args "rt2") .discard)) remaining) := by decide +kernel

def part (i : Nat) : Stmt := (GeneratedFft138Syntax.parts[i]?).getD (.base .skip)
def declaration := part 0
def size := part 1
def halfSize := part 2
def firstInitial : Stmt := match part 3 with | .seq initial _ => initial | _ => .base .skip
def firstLoop : Stmt := match part 3 with | .seq _ loop => loop | _ => .base .skip
def firstCondition : CLogic.Expr := match firstLoop with | .loop cond _ _ => cond | _ => .literal .i32 0
def firstBody : Stmt := match firstLoop with | .loop _ body _ => body | _ => .base .skip
def firstIncrement : Stmt := match firstLoop with | .loop _ _ increment => increment | _ => .base .skip
def afterFirst := C99ProcedureParser.chain (GeneratedFft138Syntax.parts.drop 4)

theorem first_loop_shape : firstLoop=.loop firstCondition firstBody firstIncrement := by rfl

theorem body_shape : GeneratedFft138Syntax.function.body=
    .seq declaration (.seq size (.seq halfSize (.seq (.seq firstInitial firstLoop) afterFirst))) := by rfl

theorem first_writes : C99ProcedureFrame138.only ["a".toList] firstBody=true := by decide +kernel
theorem first_increment_writes : C99ProcedureFrame138.only ["a".toList] firstIncrement=true := by decide +kernel
theorem first_arrays : KeygenAttemptSlots.procedureOnly firstBody=true := by decide +kernel
theorem first_increment_arrays : KeygenAttemptSlots.procedureOnly firstIncrement=true := by decide +kernel

end FT1536.Source3.FftShape138
