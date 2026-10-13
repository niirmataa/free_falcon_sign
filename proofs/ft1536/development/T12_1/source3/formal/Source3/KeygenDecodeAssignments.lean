import Source3.KeygenDecodeCalculation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact source compound assignments, in both inversion and construction
   directions. Canonical operations are checked C99 rules. -/
namespace FT1536.Source3.KeygenDecodeAssignments
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation

theorem compound (args : Args) (s t : State) (flow : Flow) (name : Name)
    (ty : C99IntegerReference.Ty) (old : IV) (op : Assign) (binary : Op) (rhs : Expr) (value result : IV)
    (cell : s.locals.scalars name=some (ty,some old))
    (operator : assignOp op=some binary)
    (calculation : Computes args s.heap s.buf s.locals rhs value)
    (operation : BinaryOp binary (.integer old) (.integer value) (.integer result))
    (source : Exec args (.write (.variable name) op rhs) s t flow) :
    t=withLocals s (localSet s.locals name ty (some (C99IntegerReference.convert ty result.integer))) ∧ flow=.normal := by
  cases source with
  | bind => cases operator
  | scalar s name op rhs actualTy actualOld actualValue actualResult locals notBuf notData declared evaluated assigned =>
    have equal := Option.some.inj (declared.symm.trans cell)
    cases equal
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals rhs value calculation locals (.integer actualValue) evaluated
    have sameValue := Value.integer.inj same
    subst actualValue; subst locals
    cases assigned with
    | set => cases operator
    | compound op actualBinary old rhs z actualOperator actualOperation =>
      have sameBinary := Option.some.inj (actualOperator.symm.trans operator)
      subst actualBinary
      have equalValue := Value.integer.inj (KeygenDecodePure.binary_unique _ _ _ _ _ actualOperation operation)
      subst actualResult
      exact ⟨rfl,rfl⟩

theorem compound_exists (args : Args) (s : State) (name : Name)
    (ty : C99IntegerReference.Ty) (old : IV) (op : Assign) (binary : Op) (rhs : Expr) (value result : IV)
    (notBuf : name≠"buf".toList) (notData : name≠"data".toList)
    (cell : s.locals.scalars name=some (ty,some old)) (operator : assignOp op=some binary)
    (calculation : Computes args s.heap s.buf s.locals rhs value)
    (operation : BinaryOp binary (.integer old) (.integer value) (.integer result)) :
    Exec args (.write (.variable name) op rhs) s
      (withLocals s (localSet s.locals name ty (some (C99IntegerReference.convert ty result.integer)))) .normal :=
  .scalar args s name op rhs ty (some old) value result s.locals notBuf notData cell
    (computes_exists args s.heap s.buf s.locals rhs value calculation)
    (.compound op binary old value result operator operation)

end FT1536.Source3.KeygenDecodeAssignments
