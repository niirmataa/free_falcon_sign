import ScatterBranches020D
import Run2.PolynomialReference

namespace FT1536.S05.ScatterAlgebra020D
open BufferField020D ScatterBranches020D Residue020D
open FT1536.Run2.PolynomialReference

/-- The three concrete buffer cases are exactly the reference monomial
    remainder, including the negative term(s). No polynomial identity is assumed. -/
theorem reduced_at (v : Coeffs) (e : Fin 3072) (c : Residue020D.F) (r : Fin 1536) :
    reduced v e c r=v r+c*coefficientOfTerms (remainderTerms e) r := by
  unfold reduced remainderTerms
  split
  · simp only [addAt_at,coefficientOfTerms,List.map_cons,List.map_nil,List.sum_cons,List.sum_nil,add_zero]
    split <;> simp_all
  · split
    · simp only [addAt_at,coefficientOfTerms,List.map_cons,List.map_nil,List.sum_cons,List.sum_nil,add_zero]
      split_ifs <;> ring
    · simp only [addAt_at,coefficientOfTerms,List.map_cons,List.map_nil,List.sum_cons,List.sum_nil,add_zero]
      split <;> simp_all

end FT1536.S05.ScatterAlgebra020D
