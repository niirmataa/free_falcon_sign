import Source3.KeygenDecodeStaticCellFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Pointer preservation checked against the same source syntax. Calls
   and actual x updates are deliberately rejected by the checker. -/
namespace FT1536.Source3.KeygenDecodeStaticPointerFrame
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference

abbrev expression := KeygenDecodeStaticCellFrame.expression "x".toList

theorem parts {a b : Bool} (held : (a && b)=true) : a=true ∧ b=true := by
  simpa only [Bool.and_eq_true] using held

theorem update_frame (changed : Name) (delta : Int) (l t : Locals) (old value : Value)
    (source : Update changed delta l old value t) (different : changed≠"x".toList) :
    t.x=l.x := by
  cases source with
  | scalar => rfl
  | pointer => exact (different rfl).elim

theorem eval_frame (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (e : Expr) (l t : Locals) (value : Value) (source : Eval args heap buf e l value t)
    (checked : expression e=true) : t.x=l.x := by
  induction source with
  | number => rfl
  | scalar => rfl
  | data => rfl
  | null => rfl
  | input => rfl
  | buffer => rfl
  | preInc changed l t old value operation => exact update_frame changed 1 l t old value operation (by simpa [KeygenDecodeStaticCellFrame.expression] using checked)
  | postInc changed l t old value operation => exact update_frame changed 1 l t old value operation (by simpa [KeygenDecodeStaticCellFrame.expression] using checked)
  | preDec changed l t old value operation => exact update_frame changed (-1) l t old value operation (by simpa [KeygenDecodeStaticCellFrame.expression] using checked)
  | postDec changed l t old value operation => exact update_frame changed (-1) l t old value operation (by simpa [KeygenDecodeStaticCellFrame.expression] using checked)
  | cast ty e l t v z evaluated cast ih => exact ih checked
  | unary op e l t v z evaluated operation ih => exact ih checked
  | dereference e l t p w evaluated load ih => exact ih checked
  | byteIndex index l t ptr atByte offset word held evaluated nonnegative advance load ih => exact ih (parts checked).2
  | binary op a b l m t x y z first second operation ih1 ih2 => exact (ih2 (parts checked).2).trans (ih1 (parts checked).1)
  | andFalse a b l t v first zero ih => exact ih (parts checked).1
  | andTrue a b l m t x y first nonzero second ih1 ih2 => exact (ih2 (parts checked).2).trans (ih1 (parts checked).1)
  | orTrue a b l t v first nonzero ih => exact ih (parts checked).1
  | orFalse a b l m t x y first zero second ih1 ih2 => exact (ih2 (parts checked).2).trans (ih1 (parts checked).1)
  | conditionalTrue test a b l m t v z condition nonzero selected ih1 ih2 =>
    exact (ih2 (parts (parts checked).1).2).trans (ih1 (parts (parts checked).1).1)
  | conditionalFalse test a b l m t v z condition zero selected ih1 ih2 =>
    exact (ih2 (parts checked).2).trans (ih1 (parts (parts checked).1).1)

theorem declare_frame (os : List Object) (l t : Locals)
    (source : declareLocals os l=some t) : t.x=l.x := by
  induction os generalizing l with
  | nil => simp only [declareLocals,Option.some.injEq] at source; subst t; rfl
  | cons o rest ih =>
    simp only [declareLocals] at source
    split at source
    · cases source
    · split at source
      · split at source
        · exact ih l source
        · cases source
      · cases typeEq : scalarTy o.type with
        | none => simp [typeEq] at source
        | some ty =>
          simp only [typeEq] at source
          exact ih (localSet l o.name ty none) source

abbrev statement := KeygenDecodeStaticCellFrame.statement "x".toList

theorem exec_frame (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) (safe : statement stmt=true) :
    t.locals.x=s.locals.x := by
  induction source with
  | skip => rfl
  | breakLoop => rfl
  | declare s os l declarations => exact declare_frame os s.locals l declarations
  | bind => rfl
  | scalar s changed op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    exact eval_frame args s.heap s.buf rhs s.locals locals (.integer value) evaluated (parts safe).2
  | store s index rhs m last ptr atWord offset word after held indexValue nonnegative advance rhsValue write =>
    exact (eval_frame args s.heap s.buf rhs m last (.integer word) rhsValue (parts safe).2).trans
      (eval_frame args s.heap s.buf index s.locals m (.integer offset) indexValue (parts safe).1)
  | increment s changed l old value step => exact update_frame changed 1 s.locals l old value step (by simpa [KeygenDecodeStaticCellFrame.statement] using safe)
  | evaluate s e value l evaluated => exact eval_frame args s.heap s.buf e s.locals l value evaluated safe
  | seq a b s m t flow first second ih1 ih2 => exact (ih2 (parts safe).2).trans (ih1 (parts safe).1)
  | seqBreak a b s t first ih => exact ih (parts safe).1
  | seqReturn a b s t value first ih => exact ih (parts safe).1
  | scope a s t flow noBufShadow inside ih =>
    exact ih safe
  | branchTrue test a b s t flow value locals evaluated yes selected ih =>
    exact (ih (parts (parts safe).1).2).trans
      (eval_frame args s.heap s.buf test s.locals locals value evaluated (parts (parts safe).1).1)
  | branchFalse test a b s t flow value locals evaluated no selected ih =>
    exact (ih (parts safe).2).trans
      (eval_frame args s.heap s.buf test s.locals locals value evaluated (parts (parts safe).1).1)
  | whileDone test a s value locals evaluated no => exact eval_frame args s.heap s.buf test s.locals locals value evaluated (parts safe).1
  | whileNext test a s m t flow value locals evaluated yes iteration rest ih1 ih2 =>
    exact (ih2 safe).trans ((ih1 (parts safe).2).trans
      (eval_frame args s.heap s.buf test s.locals locals value evaluated (parts safe).1))
  | whileBreak test a s t value locals evaluated yes iteration ih =>
    exact (ih (parts safe).2).trans
      (eval_frame args s.heap s.buf test s.locals locals value evaluated (parts safe).1)
  | whileReturn test a s t ret value locals evaluated yes iteration ih =>
    exact (ih (parts safe).2).trans
      (eval_frame args s.heap s.buf test s.locals locals value evaluated (parts safe).1)
  | forLoop initial test increment body s t flow expanded ih =>
    apply ih
    simpa only [desugar,KeygenDecodeStaticCellFrame.statement,Bool.and_eq_true,and_assoc,and_left_comm,and_comm] using safe
  | ret s e value locals evaluated => exact eval_frame args s.heap s.buf e s.locals locals (.integer value) evaluated safe

end FT1536.Source3.KeygenDecodeStaticPointerFrame
