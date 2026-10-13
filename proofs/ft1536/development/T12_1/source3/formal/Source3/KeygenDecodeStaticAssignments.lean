import Source3.KeygenDecodeDynamicCalculation
import Source3.KeygenDecodeStaticFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticAssignments
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeDynamicCalculation

theorem assign_set (args : Args) (s t : State) (flow : Flow) (name : Name)
    (ty : C99IntegerReference.Ty) (old : Option IV) (rhs : Expr) (v : IV) (last : Locals)
    (notBuf : name≠"buf".toList) (cell : s.locals.scalars name=some (ty,old))
    (calculation : Computes args s.heap s.buf rhs s.locals v last)
    (source : Exec args (.write (.variable name) .set rhs) s t flow) :
    t=withLocals s (localSet last name ty (some (C99IntegerReference.convert ty v.integer))) ∧ flow=.normal := by
  cases source with
  | bind => exact (notBuf rfl).elim
  | scalar s name op rhs actualTy actualOld value result locals notBuf notData declared evaluated assigned =>
    have equal := Option.some.inj (declared.symm.trans cell)
    cases equal
    obtain ⟨same,endLocals⟩ := computes_eval args s.heap s.buf rhs s.locals last locals v (.integer value) calculation evaluated
    cases same; subst locals
    cases assigned with
    | set => exact ⟨rfl,rfl⟩
    | compound op binary old rhs z operator operation => cases operator

theorem assign_exists (args : Args) (s : State) (name : Name)
    (ty : C99IntegerReference.Ty) (old : Option IV) (rhs : Expr) (v : IV) (last : Locals)
    (notBuf : name≠"buf".toList) (notData : name≠"data".toList)
    (cell : s.locals.scalars name=some (ty,old))
    (calculation : Computes args s.heap s.buf rhs s.locals v last) :
    Exec args (.write (.variable name) .set rhs) s
      (withLocals s (localSet last name ty (some (C99IntegerReference.convert ty v.integer)))) .normal :=
  .scalar args s name .set rhs ty old v v last notBuf notData cell
    (computes_exists _ _ _ _ _ _ _ calculation) (.set old v)

theorem compound (args : Args) (s t : State) (flow : Flow) (name : Name)
    (ty : C99IntegerReference.Ty) (old : IV) (op : Assign) (binary : Op) (rhs : Expr)
    (value result : IV) (last : Locals)
    (cell : s.locals.scalars name=some (ty,some old)) (operator : assignOp op=some binary)
    (calculation : Computes args s.heap s.buf rhs s.locals value last)
    (operation : BinaryOp binary (.integer old) (.integer value) (.integer result))
    (source : Exec args (.write (.variable name) op rhs) s t flow) :
    t=withLocals s (localSet last name ty (some (C99IntegerReference.convert ty result.integer))) ∧ flow=.normal := by
  cases source with
  | bind => cases operator
  | scalar s name op rhs actualTy actualOld actualValue actualResult locals notBuf notData declared evaluated assigned =>
    have equal := Option.some.inj (declared.symm.trans cell)
    cases equal
    obtain ⟨same,endLocals⟩ := computes_eval args s.heap s.buf rhs s.locals last locals value (.integer actualValue) calculation evaluated
    cases same; subst locals
    cases assigned with
    | set => cases operator
    | compound op actualBinary old rhs z actualOperator actualOperation =>
      have sameBinary := Option.some.inj (actualOperator.symm.trans operator)
      subst actualBinary
      have equalValue := Value.integer.inj (KeygenDecodePure.binary_unique _ _ _ _ _ actualOperation operation)
      subst actualResult
      exact ⟨rfl,rfl⟩

theorem compound_exists (args : Args) (s : State) (name : Name)
    (ty : C99IntegerReference.Ty) (old : IV) (op : Assign) (binary : Op) (rhs : Expr)
    (value result : IV) (last : Locals)
    (notBuf : name≠"buf".toList) (notData : name≠"data".toList)
    (cell : s.locals.scalars name=some (ty,some old)) (operator : assignOp op=some binary)
    (calculation : Computes args s.heap s.buf rhs s.locals value last)
    (operation : BinaryOp binary (.integer old) (.integer value) (.integer result)) :
    Exec args (.write (.variable name) op rhs) s
      (withLocals s (localSet last name ty (some (C99IntegerReference.convert ty result.integer)))) .normal :=
  .scalar args s name op rhs ty (some old) value result last notBuf notData cell
    (computes_exists _ _ _ _ _ _ _ calculation)
    (.compound op binary old value result operator operation)

end FT1536.Source3.KeygenDecodeStaticAssignments
