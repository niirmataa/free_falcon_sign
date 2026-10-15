import Source3.FftMiddleShape139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterShape144
open FftMiddleShape139

def names : List C99ArrayReference.Name := ["ht".toList,"hm".toList,"u1".toList,"v1".toList]
def declaration : C99ProcedureReference.Stmt := .base (.scalar (.declare .u64 names))
def halfT : C99ProcedureReference.Stmt := .base (.assign "ht".toList (.scalar (.bin .shr (.var "t".toList) (.literal .i32 1))))
def halfM : C99ProcedureReference.Stmt := .base (.assign "hm".toList (.scalar (.bin .shr (.var "m".toList) (.literal .i32 1))))

theorem prologue : outerPrologue=.seq declaration (.seq halfT (.seq halfM (.base .skip))) := by rfl
theorem initialization : groupInitial=.seq (.base (.scalar (.assign "u1".toList (.literal .i32 0))))
    (.base (.scalar (.assign "v1".toList (.literal .i32 0)))) := by rfl
theorem locals : scopeLocals outerBody=names := by rfl
theorem pointers : scopePointers outerBody=[] := by rfl
theorem condition : outerCondition=.cmp .gt (.var "t".toList) (.var "tmin".toList) := by rfl

end FT1536.Source3.FftOuterShape144
