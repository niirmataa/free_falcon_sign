import Source3.C99VectorLoop155
import Source3.GsInvNormShape154
import Source3.KeygenAttemptFft

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsMapShape155
open C99ArrayReference (Expr)
open C99ProcedureReference (Stmt Function)

inductive Operation where
  | adjoint | scale
  deriving DecidableEq

def expression : Operation → Expr
  | .adjoint => .call1 "fpr_neg".toList (.load "a".toList FftFirstShape149.index0)
  | .scale => .call2 "fpr_mul".toList (.load "a".toList FftFirstShape149.index0) (.scalar (.var "x".toList))
def body (op : Operation) : Stmt :=
  .scope [] [] (C99ProcedureParser.chain [.base (.store64 "a".toList FftFirstShape149.index0 (expression op))])
def loop (op : Operation) : Stmt := .loop (C99VectorLoop155.condition "n".toList) (body op) C99VectorLoop155.increment
def adjointInitial : Stmt := .base (.scalar (.assign "u".toList (.var "hn".toList)))
def adjointFunction : Function :=
  ⟨(KeygenSearchFft.header (.inherited (.leaf .adj))).parameters.map C99ArrayParser.Parameter.value,none,
    C99ProcedureParser.chain [GsInvNormShape154.declaration,FftShape138.size,FftShape138.halfSize,
      .seq adjointInitial (loop .adjoint)]⟩
def scaleDeclaration : Stmt := .base (.scalar (.declare .u64 ["n".toList,"u".toList]))
def scaleCode : Stmt := C99ProcedureParser.chain [scaleDeclaration,FftShape138.size,
  .seq FftShape138.firstInitial (loop .scale)]

theorem adjoint_source : KeygenSearchFft.program "falcon_poly_adj_fft3".toList=some adjointFunction := by decide +kernel
theorem scale_source : KeygenAttemptFft.code=scaleCode := by decide +kernel

def value (op : Operation) (factor word : BitVec 64) : BitVec 64 :=
  match op with
  | .adjoint => FprHeadersFast137.neg word
  | .scale => FprMulFast137.word word factor

def Extra (op : Operation) (factor : BitVec 64) (s : C99ArrayReference.State) : Prop :=
  match op with
  | .adjoint => True
  | .scale => s.locals "x".toList=some (.uint64,some (.uint64 factor))

theorem evaluated (op : Operation) (factor word : BitVec 64) (s : C99ArrayReference.State) (p : C99MemoryReference.ArrayPointer)
    (extra : Extra op factor s) (address : C99ArrayReference.Pointer s "a".toList FftFirstShape149.index0 p)
    (read : C99MemoryReference.Load64 s.heap p word) :
    C99ArrayReference.Eval s (expression op) (.uint64 (value op factor word)) := by
  have loaded : C99ArrayReference.Eval s (.load "a".toList FftFirstShape149.index0) (.uint64 word) := .load _ _ p word address read
  cases op with
  | adjoint => exact .call1 _ _ _ _ loaded (FprHeadersFast137.neg_source word)
  | scale => exact .call2 _ _ _ _ _ _ loaded (FftLocalCells140.read_var s "x".toList factor extra) (FprMulFast137.source word factor)

end FT1536.Source3.GsMapShape155
