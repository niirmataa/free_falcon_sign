import Source3.FprAST
import Source3.ExpressionFuel

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprAST

/- FprAST.lean is an untrusted pretty-print of the already-pinned parser
   result. These kernel equalities are the trust boundary of that transport. -/
theorem add_binding : FprPrimitives.addProgram=some addCode := by rfl
theorem mul_binding : FprPrimitives.mulProgram=some mulCode := by rfl
theorem div_binding : FprPrimitives.divProgram=some divCode := by rfl
theorem ursh_binding : FprPrimitives.ursh=some urshCode := by rfl
theorem ulsh_binding : FprPrimitives.ulsh=some ulshCode := by rfl
theorem pack_binding : FprPrimitives.pack=some packCode := by rfl
theorem norm_binding : FprPrimitives.normStatements ['x','u'] ['e','x']=some normCode := by rfl

end FT1536.Source3.FprAST

#print axioms FT1536.Source3.FprAST.add_binding
#print axioms FT1536.Source3.FprAST.mul_binding
#print axioms FT1536.Source3.FprAST.div_binding
#print axioms FT1536.Source3.FprAST.norm_binding
