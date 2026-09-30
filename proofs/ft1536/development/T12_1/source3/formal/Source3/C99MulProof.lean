import Source3.C99ScalarToFpr
import Source3.FprUnsignedPrefixes

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99MulProof
open B20.C C99ValueBridge

def body : List CLogic.Stmt := (FprUnsignedPrefixes.scalars FprAST.mulCode.body).getD []
def function : CLogic.Function := ⟨FprAST.mulCode.name,FprAST.mulCode.result,FprAST.mulCode.params,body⟩

theorem body_shape : FprAST.mulCode.body=body.map FprPrimitives.Instr.scalar := by rfl
theorem checked : C99HeaderProof.checked C99HeaderSignature.signature function=true := by decide
theorem lowering : C99Frontend.function FprAST.mulCode=some (C99Frontend.headerFunction function) := by
  unfold C99Frontend.function
  rw [body_shape,C99ScalarToFpr.lower_scalars]
  rfl

theorem mul_complete (args : List Val) (z : C99IntegerReference.Value)
    (hs : C99ScalarReference.FunctionExec C99Frontend.headerCalls
      (C99Frontend.headerFunction function) (args.map value) z) :
    FprPrimitives.execute FprAST.mulCode args=some (encode z) := by
  have h := C99HeaderProof.function_complete C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSignature.calls_ok function args z checked hs
  exact C99ScalarToFpr.scalar_function FprAST.mulCode body body_shape (by decide) args (encode z) h

theorem pinned_mul_complete (x y z : BitVec 64)
    (hs : C99Frontend.primitiveCall ['f','p','r','_','m','u','l'] [.uint64 x,.uint64 y] (.uint64 z)) :
    FprPrimitives.mul x y=some z := by
  obtain ⟨f,hlookup,hf⟩ := hs
  have heq : f=C99Frontend.headerFunction function := by
    simpa [C99Frontend.lookup,lowering] using hlookup.symm
  subst f
  have he := mul_complete [.u64 x,.u64 y] (.uint64 z) hf
  simp [FprPrimitives.mul,FprPrimitives.call,FprAST.mul_binding,he,encode]

end FT1536.Source3.C99MulProof

#check @FT1536.Source3.C99MulProof.pinned_mul_complete
#print axioms FT1536.Source3.C99MulProof.pinned_mul_complete
