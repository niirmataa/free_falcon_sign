import Source3.FpcMulFrame145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcMulExec145
open C99ArrayReference (State Program Exec)
open FpcMulShape145 (Parameters Entry varName lastReal lastImag)
open FftMulStates140 (Words s1 s2 s3 s4 s5 s6 s7 s8 s9 real imag)
open FftMulShape140 (aNames bNames dNames varExpr)

theorem step4 (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (.assign "fpct_a_re".toList (varName p.ar)) (s3 s) (s4 s x) := by
  apply FftLocalCells140.assign program (s3 s) _ _ none x.ar
  · simp [s1,s2,s3,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,aNames,bNames,dNames,C99ScalarReference.set,C99ValueBridge.type]
  · exact FftLocalCells140.read_var _ p.ar x.ar ((FpcMulFrame145.outside3 s p.ar entry.arSafe).trans entry.arCell)

theorem step5 (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (.assign "fpct_a_im".toList (varName p.ai)) (s4 s x) (s5 s x) := by
  apply FftLocalCells140.assign program (s4 s x) _ _ none x.ai
  · simp [s1,s2,s3,s4,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,aNames,bNames,dNames,C99ScalarReference.set,C99ValueBridge.type]
  · exact FftLocalCells140.read_var _ p.ai x.ai ((FpcMulFrame145.outside4 s x p.ai entry.aiSafe).trans entry.aiCell)

theorem step6 (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (.assign "fpct_b_re".toList (varName p.br)) (s5 s x) (s6 s x) := by
  apply FftLocalCells140.assign program (s5 s x) _ _ none x.br
  · simp [s1,s2,s3,s4,s5,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,aNames,bNames,dNames,C99ScalarReference.set,C99ValueBridge.type]
  · exact FftLocalCells140.read_var _ p.br x.br ((FpcMulFrame145.outside5 s x p.br entry.brSafe).trans entry.brCell)

theorem step7 (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (.assign "fpct_b_im".toList (varName p.bi)) (s6 s x) (s7 s x) := by
  apply FftLocalCells140.assign program (s6 s x) _ _ none x.bi
  · simp [s1,s2,s3,s4,s5,s6,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,aNames,bNames,dNames,C99ScalarReference.set,C99ValueBridge.type]
  · exact FftLocalCells140.read_var _ p.bi x.bi ((FpcMulFrame145.outside6 s x p.bi entry.biSafe).trans entry.biCell)

theorem step10 (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (.assign p.dr (varExpr "fpct_d_re")) (s9 s x) (lastReal s p x) := by
  obtain ⟨old,declared⟩ := entry.drCell
  apply FftLocalCells140.assign program (s9 s x) p.dr _ old (real x)
  · exact (FpcMulFrame145.outside9 s x p.dr entry.drSafe).trans declared
  · exact FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _))

theorem step11 (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (.assign p.di (varExpr "fpct_d_im")) (lastReal s p x) (lastImag s p x) := by
  obtain ⟨old,declared⟩ := entry.diCell
  apply FftLocalCells140.assign program (lastReal s p x) p.di _ old (imag x)
  · exact (FftLocalCells140.outside _ _ _ _ (Ne.symm entry.distinct)).trans
      ((FpcMulFrame145.outside9 s x p.di entry.diSafe).trans declared)
  · exact FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _
      (Ne.symm (FpcMulFrame145.different p.dr _ entry.drSafe (by decide)))).trans (FftLocalCells140.cell_at _ _ _))

theorem internal_source (program : Program) (s : State) (p : Parameters) (x : Words) (entry : Entry s p x) :
    Exec program (FpcSourceExpansion.sequence (FpcMulShape145.operations p)) s (lastImag s p x) :=
  .seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 aNames s)
    (.seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 bNames (s1 s))
    (.seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 dNames (s2 s))
    (.seq _ _ _ _ _ (step4 program s p x entry)
    (.seq _ _ _ _ _ (step5 program s p x entry)
    (.seq _ _ _ _ _ (step6 program s p x entry)
    (.seq _ _ _ _ _ (step7 program s p x entry)
    (.seq _ _ _ _ _ (FftMulExec140.step8 program s x)
    (.seq _ _ _ _ _ (FftMulExec140.step9 program s x)
    (.seq _ _ _ _ _ (step10 program s p x entry)
    (.seq _ _ _ _ _ (step11 program s p x entry) (.skip _)))))))))))

end FT1536.Source3.FpcMulExec145
