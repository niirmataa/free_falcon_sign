import Source3.KeygenNormFrame
import Source3.SmallintsInvocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSmallShape136
open C99ProcedureReference (Stmt)

def args (destination source : String) := SmallintsInvocation.args destination.toList source.toList

def remaining : KeygenSearchExec.Stmt :=
  match KeygenNormFrame.code with
  | .seq (.small _) (.seq (.small _) tail) => tail
  | _ => KeygenSearchExec.skip

theorem norm_prefix : KeygenNormFrame.code=
    .seq (.small (args "rt1" "f")) (.seq (.small (args "rt2" "g")) remaining) := by decide +kernel

def declaration : Stmt := .base (.scalar (.declare .u64 ["n".toList,"u".toList]))
def size : Stmt := .base (.assign "n".toList (.scalar (C99ArrayParser.mkn (.var "logn".toList) (.var "ter".toList))))
def initial : Stmt := .base (.scalar (.assign "u".toList (.literal .i32 0)))
def iteration : Stmt := .scope [] [] (C99ProcedureParser.chain [
  .base (.store64 "x".toList (.var "u".toList)
    (.call1 "fpr_of".toList (.load16 true "f".toList (.var "u".toList))))])
def loop : Stmt := .loop SmallintsProgram.condition iteration SmallintsProgram.increment

theorem body_shape : KeygenSearchLeaves.smallBody=
    .seq declaration (.seq size (.seq (.seq initial loop) (.base .skip))) := by rfl

end FT1536.Source3.KeygenSmallShape136
