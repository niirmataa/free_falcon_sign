import Source3.GsMapShape155

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsAutoShape155
open C99ArrayReference (Expr)
open C99ProcedureReference (Stmt Function)

def expression (index : CLogic.Expr) : Expr := FftWordExpressions140.mul
  (.load "a".toList index) (.load "b".toList FftFirstShape149.index0)
def store0 : Stmt := .base (.store64 "a".toList FftFirstShape149.index0 (expression FftFirstShape149.index0))
def store1 : Stmt := .base (.store64 "a".toList FftFirstShape149.index1 (expression FftFirstShape149.index1))
def body : Stmt := .scope [] [] (C99ProcedureParser.chain [store0,store1])
def loop : Stmt := .loop (C99VectorLoop155.condition "hn".toList) body C99VectorLoop155.increment
def function : Function :=
  ⟨(KeygenSearchFft.header (.inherited (.leaf .mulAuto))).parameters.map C99ArrayParser.Parameter.value,none,
    C99ProcedureParser.chain [GsInvNormShape154.declaration,FftShape138.size,FftShape138.halfSize,
      .seq FftShape138.firstInitial loop]⟩

theorem source : KeygenSearchFft.program "falcon_poly_mul_autoadj_fft3".toList=some function := by decide +kernel

end FT1536.Source3.GsAutoShape155
