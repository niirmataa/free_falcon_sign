import Source3.FpcSqrFrame145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcSqrExec145
open C99ArrayReference (State Name Program Exec Eval)
open FpcSqrShape145
open FftMulShape140 (aNames dNames varExpr)

theorem step3 (program : Program) (s : State) (re im : Name) (x y : BitVec 64) (entry : Entry s re im x y) :
    Exec program (.assign "fpct_a_re".toList (.scalar (.var re))) (s2 s) (s3 s x) := by
  apply FftLocalCells140.assign program (s2 s) _ _ none x
  · simp [s1,s2,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,aNames,dNames,C99ScalarReference.set,C99ValueBridge.type]
  · exact FftLocalCells140.read_var _ re x ((FpcSqrFrame145.outside2 s re entry.reSafe).trans entry.reCell)

theorem step4 (program : Program) (s : State) (re im : Name) (x y : BitVec 64) (entry : Entry s re im x y) :
    Exec program (.assign "fpct_a_im".toList (.scalar (.var im))) (s3 s x) (s4 s x y) := by
  apply FftLocalCells140.assign program (s3 s x) _ _ none y
  · simp [s1,s2,s3,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,aNames,dNames,C99ScalarReference.set,C99ValueBridge.type]
  · exact FftLocalCells140.read_var _ im y ((FpcSqrFrame145.outside3 s x im entry.imSafe).trans entry.imCell)

theorem ar4 (s : State) (x y : BitVec 64) : Eval (s4 s x y) (varExpr "fpct_a_re") (.uint64 x) :=
  FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _))
theorem ai4 (s : State) (x y : BitVec 64) : Eval (s4 s x y) (varExpr "fpct_a_im") (.uint64 y) :=
  FftLocalCells140.read_var _ _ _ (FftLocalCells140.cell_at _ _ _)

theorem step5 (program : Program) (s : State) (x y : BitVec 64) :
    Exec program (.assign "fpct_d_re".toList (FftWordExpressions140.sub
      (.call1 "fpr_sqr".toList (varExpr "fpct_a_re")) (.call1 "fpr_sqr".toList (varExpr "fpct_a_im")))) (s4 s x y) (s5 s x y) := by
  apply FftLocalCells140.assign program (s4 s x y) _ _ none (real x y)
  · simp [s1,s2,s3,s4,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,aNames,dNames,C99ScalarReference.set,C99ValueBridge.type]
  · exact FftWordExpressions140.sub_source _ _ _ _ _
      (.call1 _ _ _ _ (ar4 s x y) (FprHeadersFast137.sqr_source x))
      (.call1 _ _ _ _ (ai4 s x y) (FprHeadersFast137.sqr_source y))

theorem step6 (program : Program) (s : State) (x y : BitVec 64) :
    Exec program (.assign "fpct_d_im".toList (.call1 "fpr_double".toList
      (FftWordExpressions140.mul (varExpr "fpct_a_re") (varExpr "fpct_a_im")))) (s5 s x y) (s6 s x y) := by
  apply FftLocalCells140.assign program (s5 s x y) _ _ none (imag x y)
  · simp [s1,s2,s3,s4,s5,FftLocalCells140.put,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,aNames,dNames,C99ScalarReference.set,C99ValueBridge.type]
  · have ar : Eval (s5 s x y) (varExpr "fpct_a_re") (.uint64 x) :=
      FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
        ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _)))
    have ai : Eval (s5 s x y) (varExpr "fpct_a_im") (.uint64 y) :=
      FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _))
    exact .call1 _ _ _ _ (FftWordExpressions140.mul_source _ _ _ _ _ ar ai) (FprHeadersFast137.double_source (FprMulFast137.word x y))

theorem step7 (program : Program) (s : State) (re im : Name) (x y : BitVec 64) (entry : Entry s re im x y) :
    Exec program (.assign re (varExpr "fpct_d_re")) (s6 s x y) (s7 s re x y) := by
  apply FftLocalCells140.assign program (s6 s x y) re _ (some (.uint64 x)) (real x y)
  · exact (FpcSqrFrame145.outside6 s x y re entry.reSafe).trans entry.reCell
  · exact FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _))

theorem step8 (program : Program) (s : State) (re im : Name) (x y : BitVec 64) (entry : Entry s re im x y) :
    Exec program (.assign im (varExpr "fpct_d_im")) (s7 s re x y) (s8 s re im x y) := by
  apply FftLocalCells140.assign program (s7 s re x y) im _ (some (.uint64 y)) (imag x y)
  · exact (FftLocalCells140.outside _ _ _ _ (Ne.symm entry.distinct)).trans ((FpcSqrFrame145.outside6 s x y im entry.imSafe).trans entry.imCell)
  · exact FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _
      (Ne.symm (FpcSqrFrame145.different re _ entry.reSafe (by decide)))).trans (FftLocalCells140.cell_at _ _ _))

theorem internal_source (program : Program) (s : State) (re im : Name) (x y : BitVec 64) (entry : Entry s re im x y) :
    Exec program (FpcSourceExpansion.sequence (operations re im)) s (s8 s re im x y) :=
  .seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 aNames s)
    (.seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 dNames (s1 s))
    (.seq _ _ _ _ _ (step3 program s re im x y entry)
    (.seq _ _ _ _ _ (step4 program s re im x y entry)
    (.seq _ _ _ _ _ (step5 program s x y)
    (.seq _ _ _ _ _ (step6 program s x y)
    (.seq _ _ _ _ _ (step7 program s re im x y entry)
    (.seq _ _ _ _ _ (step8 program s re im x y entry) (.skip _))))))))

end FT1536.Source3.FpcSqrExec145
