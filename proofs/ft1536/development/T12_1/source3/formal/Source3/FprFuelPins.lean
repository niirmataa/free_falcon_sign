import Source3.FprASTBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.ExpressionFuel
theorem add_exprs_fit : (FprPrimitives.addProgram.map
    (fun f => bodyFits 256 f.body)) = some true := by
  rw [FprAST.add_binding]
  simp only [Option.map_some,FprAST.addCode,bodyFits]
  rw [FprAST.norm_binding]
  decide
theorem mul_exprs_fit : (FprPrimitives.mulProgram.map
    (fun f => bodyFits 256 f.body)) = some true := by
  rw [FprAST.mul_binding]
  decide
theorem div_exprs_fit : (FprPrimitives.divProgram.map
    (fun f => bodyFits 256 f.body)) = some true := by
  rw [FprAST.div_binding]
  decide
theorem header_exprs_fit :
    (FprPrimitives.ursh.map (fun f => f.body.all stmtFits)) = some true ∧
    (FprPrimitives.ulsh.map (fun f => f.body.all stmtFits)) = some true ∧
    (FprPrimitives.pack.map (fun f => f.body.all stmtFits)) = some true := by
  rw [FprAST.ursh_binding,FprAST.ulsh_binding,FprAST.pack_binding]
  decide
end FT1536.Source3.ExpressionFuel

#print axioms FT1536.Source3.ExpressionFuel.add_exprs_fit
#print axioms FT1536.Source3.ExpressionFuel.mul_exprs_fit
#print axioms FT1536.Source3.ExpressionFuel.div_exprs_fit
#print axioms FT1536.Source3.ExpressionFuel.header_exprs_fit
