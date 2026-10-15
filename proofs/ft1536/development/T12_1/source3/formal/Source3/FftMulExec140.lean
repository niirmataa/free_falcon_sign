import Source3.FftMulStates140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMulExec140
open C99ArrayReference (State Exec Program)
open FftMulStates140
open FftMulShape140 (varExpr)

theorem step4 (program : Program) (before : State) (x : Words) (entry : Entry before x) :
    Exec program (.assign "fpct_a_re".toList (varExpr "a1r")) (s3 before) (s4 before x) := by
  apply FftLocalCells140.assign program (s3 before) "fpct_a_re".toList (varExpr "a1r") none x.ar
  · simp [s1,s2,s3,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set,C99ValueBridge.type]
  · apply FftLocalCells140.read_var
    simpa [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set] using entry.ar

theorem step5 (program : Program) (before : State) (x : Words) (entry : Entry before x) :
    Exec program (.assign "fpct_a_im".toList (varExpr "a1i")) (s4 before x) (s5 before x) := by
  apply FftLocalCells140.assign program (s4 before x) "fpct_a_im".toList (varExpr "a1i") none x.ai
  · simp [s1,s2,s3,s4,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set,C99ValueBridge.type]
  · apply FftLocalCells140.read_var
    simpa [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set] using entry.ai

theorem step6 (program : Program) (before : State) (x : Words) (entry : Entry before x) :
    Exec program (.assign "fpct_b_re".toList (varExpr "sr")) (s5 before x) (s6 before x) := by
  apply FftLocalCells140.assign program (s5 before x) "fpct_b_re".toList (varExpr "sr") none x.br
  · simp [s1,s2,s3,s4,s5,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set,C99ValueBridge.type]
  · apply FftLocalCells140.read_var
    simpa [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set] using entry.br

theorem step7 (program : Program) (before : State) (x : Words) (entry : Entry before x) :
    Exec program (.assign "fpct_b_im".toList (varExpr "si")) (s6 before x) (s7 before x) := by
  apply FftLocalCells140.assign program (s6 before x) "fpct_b_im".toList (varExpr "si") none x.bi
  · simp [s1,s2,s3,s4,s5,s6,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set,C99ValueBridge.type]
  · apply FftLocalCells140.read_var
    simpa [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set] using entry.bi

theorem step8 (program : Program) (before : State) (x : Words) :
    Exec program (.assign "fpct_d_re".toList (FftWordExpressions140.sub (FftWordExpressions140.mul (varExpr "fpct_a_re") (varExpr "fpct_b_re")) (FftWordExpressions140.mul (varExpr "fpct_a_im") (varExpr "fpct_b_im")))) (s7 before x) (s8 before x) := by
  apply FftLocalCells140.assign program (s7 before x) "fpct_d_re".toList _ none (real x)
  · simp [s1,s2,s3,s4,s5,s6,s7,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set,C99ValueBridge.type]
  · have values := FftWordExpressions140.complex_source (s7 before x)
      (varExpr "fpct_a_re") (varExpr "fpct_a_im") (varExpr "fpct_b_re") (varExpr "fpct_b_im")
      x.ar x.ai x.br x.bi
      (FftLocalCells140.read_var _ _ _ (by simp [s1,s2,s3,s4,s5,s6,s7,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]))
      (FftLocalCells140.read_var _ _ _ (by simp [s1,s2,s3,s4,s5,s6,s7,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]))
      (FftLocalCells140.read_var _ _ _ (by simp [s1,s2,s3,s4,s5,s6,s7,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]))
      (FftLocalCells140.read_var _ _ _ (by simp [s1,s2,s3,s4,s5,s6,s7,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]))
    exact values.1

theorem step9 (program : Program) (before : State) (x : Words) :
    Exec program (.assign "fpct_d_im".toList (FftWordExpressions140.add (FftWordExpressions140.mul (varExpr "fpct_a_re") (varExpr "fpct_b_im")) (FftWordExpressions140.mul (varExpr "fpct_a_im") (varExpr "fpct_b_re")))) (s8 before x) (s9 before x) := by
  apply FftLocalCells140.assign program (s8 before x) "fpct_d_im".toList _ none (imag x)
  · simp [s1,s2,s3,s4,s5,s6,s7,s8,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set,C99ValueBridge.type]
  · have values := FftWordExpressions140.complex_source (s8 before x)
      (varExpr "fpct_a_re") (varExpr "fpct_a_im") (varExpr "fpct_b_re") (varExpr "fpct_b_im")
      x.ar x.ai x.br x.bi
      (FftLocalCells140.read_var _ _ _ (by simp [s1,s2,s3,s4,s5,s6,s7,s8,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]))
      (FftLocalCells140.read_var _ _ _ (by simp [s1,s2,s3,s4,s5,s6,s7,s8,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]))
      (FftLocalCells140.read_var _ _ _ (by simp [s1,s2,s3,s4,s5,s6,s7,s8,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]))
      (FftLocalCells140.read_var _ _ _ (by simp [s1,s2,s3,s4,s5,s6,s7,s8,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]))
    exact values.2

theorem step10 (program : Program) (before : State) (x : Words) (entry : Entry before x) :
    Exec program (.assign "a1r".toList (varExpr "fpct_d_re")) (s9 before x) (s10 before x) := by
  apply FftLocalCells140.assign program (s9 before x) "a1r".toList _ (some (.uint64 x.ar)) (real x)
  · simpa [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set] using entry.ar
  · apply FftLocalCells140.read_var
    simp [s1,s2,s3,s4,s5,s6,s7,s8,s9,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]

theorem step11 (program : Program) (before : State) (x : Words) (entry : Entry before x) :
    Exec program (.assign "a1i".toList (varExpr "fpct_d_im")) (s10 before x) (s11 before x) := by
  apply FftLocalCells140.assign program (s10 before x) "a1i".toList _ (some (.uint64 x.ai)) (imag x)
  · simpa [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set] using entry.ai
  · apply FftLocalCells140.read_var
    simp [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftMulShape140.aNames,FftMulShape140.bNames,FftMulShape140.dNames,C99ScalarReference.set]

/-- The original complex multiplication macro executes for arbitrary words. -/
theorem internal_source (program : Program) (before : State) (x : Words) (entry : Entry before x) :
    Exec program (FpcSourceExpansion.sequence FftMulShape140.operations) before (s11 before x) := by
  exact (.seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 FftMulShape140.aNames before)
    (.seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 FftMulShape140.bNames (s1 before))
    (.seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 FftMulShape140.dNames (s2 before))
    (.seq _ _ _ _ _ (step4 program before x entry)
    (.seq _ _ _ _ _ (step5 program before x entry)
    (.seq _ _ _ _ _ (step6 program before x entry)
    (.seq _ _ _ _ _ (step7 program before x entry)
    (.seq _ _ _ _ _ (step8 program before x)
    (.seq _ _ _ _ _ (step9 program before x)
    (.seq _ _ _ _ _ (step10 program before x entry)
    (.seq _ _ _ _ _ (step11 program before x entry)
    (.skip _))))))))))))

theorem scoped_source (program : Program) (before : State) (x : Words) (entry : Entry before x) :
    Exec program FftMulShape140.code before
      (C99ArrayReference.restoreScope before (s11 before x) FftMulShape140.temporaries []) :=
  .scope _ _ _ _ _ (internal_source program before x entry)

end FT1536.Source3.FftMulExec140
