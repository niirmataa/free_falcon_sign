import Source3.C99ModularReference

namespace FT1536.Source3.C99ModularFlow
open C99ModularReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)

def onlyReturn (n : Nat) : Stmt → Bool
  | .base _ | .assign _ _ | .store32 _ _ _ => true
  | .seq a b | .branch _ a b => onlyReturn n a && onlyReturn n b
  | .scope _ b => onlyReturn n b
  | .loop _ body increment => onlyReturn n body && onlyReturn n increment
  | .ret e => e==.scalar (.literal .i32 n)
  | .retVoid => false

theorem source_flow (n : Nat) (code : Stmt) (before : State) (result : Result)
    (source : Exec code before result) (checked : onlyReturn n code=true) :
    result.flow=.normal ∨ result.flow=.returned (some (C99IntegerReference.convert .int32 n)) := by
  induction source with
  | base | assign | store32 | loopFalse => exact Or.inl rfl
  | seqNormal first second before middle result head tail ih1 ih2 =>
      exact ih2 (Bool.and_eq_true_iff.mp checked).2
  | seqExit first second before result head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals body before result inner ih => exact ih checked
  | branchTrue condition yes no before result v guard nonzero body ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse condition yes no before result v guard zero body ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact ih3 checked
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      exact ih (Bool.and_eq_true_iff.mp checked).1
  | ret e before v value =>
      have he : e=.scalar (.literal .i32 n) := beq_iff_eq.mp checked
      subst e
      cases value with
      | scalar _ _ source => cases source; exact Or.inr rfl
  | retVoid => exact False.elim (Bool.false_ne_true checked)

end FT1536.Source3.C99ModularFlow
