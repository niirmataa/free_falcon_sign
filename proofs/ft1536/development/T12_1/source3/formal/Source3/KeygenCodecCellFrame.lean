import Source3.KeygenCodecExecution

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-checked scalar-cell frames, including expression updates and
   lexical restoration. Calls are deliberately rejected by this checker. -/
namespace FT1536.Source3.KeygenCodecCellFrame
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

def expression (name : Name) : Expr → Bool
  | .preInc (.variable n) | .postInc (.variable n) | .preDec (.variable n) | .postDec (.variable n) => n != name
  | .preInc _ | .postInc _ | .preDec _ | .postDec _ => false
  | .number _ _ | .variable _ | .argsNil => true
  | .unary _ e | .cast _ e | .member e _ => expression name e
  | .binary _ a b | .index a b | .argsCons a b => expression name a && expression name b
  | .conditional t a b => expression name t && expression name a && expression name b
  | .call _ _ => false

theorem parts {a b : Bool} (held : (a && b)=true) : a=true ∧ b=true := by
  simpa only [Bool.and_eq_true] using held

theorem update_frame (name changed : Name) (delta : Int) (l t : Locals) (old value : Value)
    (source : Update changed delta l old value t) (different : changed≠name) :
    t.scalars name=l.scalars name := by
  cases source with
  | scalar => simp [localSet,C99ScalarReference.set,Ne.symm different]
  | pointer => rfl

theorem eval_frame (name : Name) (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (e : Expr) (l t : Locals) (value : Value) (source : Eval args heap buf e l value t)
    (checked : expression name e=true) : t.scalars name=l.scalars name := by
  induction source with
  | number => rfl
  | scalar => rfl
  | out => rfl
  | null => rfl
  | input => rfl
  | buffer => rfl
  | preInc changed l t old value operation => exact update_frame name changed 1 l t old value operation (by simpa [expression] using checked)
  | postInc changed l t old value operation => exact update_frame name changed 1 l t old value operation (by simpa [expression] using checked)
  | preDec changed l t old value operation => exact update_frame name changed (-1) l t old value operation (by simpa [expression] using checked)
  | postDec changed l t old value operation => exact update_frame name changed (-1) l t old value operation (by simpa [expression] using checked)
  | cast ty e l t v z evaluated cast ih => exact ih checked
  | unary op e l t v z evaluated operation ih => exact ih checked
  | dereference e l t p w evaluated load ih => exact ih checked
  | binary op a b l m t x y z first second operation ih1 ih2 => exact (ih2 (parts checked).2).trans (ih1 (parts checked).1)
  | andFalse a b l t v first zero ih => exact ih (parts checked).1
  | andTrue a b l m t x y first nonzero second ih1 ih2 => exact (ih2 (parts checked).2).trans (ih1 (parts checked).1)
  | orTrue a b l t v first nonzero ih => exact ih (parts checked).1
  | orFalse a b l m t x y first zero second ih1 ih2 => exact (ih2 (parts checked).2).trans (ih1 (parts checked).1)
  | conditionalTrue test a b l m t v z condition nonzero selected ih1 ih2 =>
    exact (ih2 (parts (parts checked).1).2).trans (ih1 (parts (parts checked).1).1)
  | conditionalFalse test a b l m t v z condition zero selected ih1 ih2 =>
    exact (ih2 (parts checked).2).trans (ih1 (parts (parts checked).1).1)

def objects (name : Name) (os : List Object) : Bool := os.all fun o => o.name != name

theorem declare_frame (name : Name) (os : List Object) (l t : Locals)
    (source : declareLocals os l=some t) (checked : objects name os=true) :
    t.scalars name=l.scalars name := by
  induction os generalizing l with
  | nil => simp only [declareLocals,Option.some.injEq] at source; subst t; rfl
  | cons o rest ih =>
    have pair : o.name≠name ∧ objects name rest=true := by simpa [objects,Bool.and_eq_true] using checked
    simp only [declareLocals] at source
    split at source
    · cases source
    · split at source
      · split at source
        · exact ih l source pair.2
        · cases source
      · cases typeEq : scalarTy o.type with
        | none => simp [typeEq] at source
        | some ty =>
          simp only [typeEq] at source
          exact (ih _ source pair.2).trans (by simp [localSet,C99ScalarReference.set,Ne.symm pair.1])

def statement (name : Name) : Stmt → Bool
  | .skip => true
  | .declare os => objects name os
  | .write (.variable n) _ rhs => n != name && expression name rhs
  | .write (.index (.variable _) index) .set rhs => expression name index && expression name rhs
  | .increment (.variable n) => n != name
  | .evaluate e | .ret e => expression name e
  | .seq a b => statement name a && statement name b
  | .scope a => statement name a
  | .branch t a b => expression name t && statement name a && statement name b
  | .switch t a b c => expression name t && statement name a && statement name b && statement name c
  | .whileLoop t a => expression name t && statement name a
  | .loop initial test increment loopBody => statement name initial && expression name (testExpr test) && statement name increment && statement name loopBody
  | _ => false

theorem exec_frame (name : Name) (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) (safe : statement name stmt=true) :
    t.locals.scalars name=s.locals.scalars name := by
  induction source with
  | skip => rfl
  | declare args s os l declarations => exact declare_frame name os s.locals l declarations safe
  | bind => rfl
  | scalar args s changed op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have pair := parts safe
    have different : changed≠name := by simpa only [bne_iff_ne] using pair.1
    exact (show (localSet locals changed ty _).scalars name=locals.scalars name by simp [localSet,C99ScalarReference.set,Ne.symm different]).trans
      (eval_frame name args s.heap s.buf rhs s.locals locals (.integer value) evaluated pair.2)
  | store args s index rhs m last ptr offset word after held indexValue nonnegative rhsValue write =>
    exact (eval_frame name args s.heap s.buf rhs m last (.integer word) rhsValue (parts safe).2).trans
      (eval_frame name args s.heap s.buf index s.locals m (.integer offset) indexValue (parts safe).1)
  | increment args s changed l old value step => exact update_frame name changed 1 s.locals l old value step (by simpa [statement] using safe)
  | evaluate args s e value l evaluated => exact eval_frame name args s.heap s.buf e s.locals l value evaluated safe
  | seq args a b s m t flow first second ih1 ih2 => exact (ih2 (parts safe).2).trans (ih1 (parts safe).1)
  | seqReturn args a b s t value first ih => exact ih (parts safe).1
  | scope args a s t flow noBufShadow inside ih =>
    change (if _ then s.locals.scalars name else t.locals.scalars name)=_
    split
    · rfl
    · exact ih safe
  | branchTrue args test a b s t flow value locals evaluated yes selected ih =>
    exact (ih (parts (parts safe).1).2).trans
      (eval_frame name args s.heap s.buf test s.locals locals value evaluated (parts (parts safe).1).1)
  | branchFalse args test a b s t flow value locals evaluated no selected ih =>
    exact (ih (parts safe).2).trans
      (eval_frame name args s.heap s.buf test s.locals locals value evaluated (parts (parts safe).1).1)
  | whileDone args test a s value locals evaluated no => exact eval_frame name args s.heap s.buf test s.locals locals value evaluated (parts safe).1
  | whileNext args test a s m t flow value locals evaluated yes iteration rest ih1 ih2 =>
    exact (ih2 safe).trans ((ih1 (parts safe).2).trans
      (eval_frame name args s.heap s.buf test s.locals locals value evaluated (parts safe).1))
  | whileReturn args test a s t ret value locals evaluated yes iteration ih =>
    exact (ih (parts safe).2).trans
      (eval_frame name args s.heap s.buf test s.locals locals value evaluated (parts safe).1)
  | forLoop args initial test increment body s t flow expanded ih =>
    apply ih
    simpa only [desugar,statement,Bool.and_eq_true,and_assoc,and_left_comm,and_comm] using safe
  | switchNone args test a b c s t flow value locals evaluated zero selected ih =>
    exact (ih (parts (parts (parts safe).1).1).2).trans
      (eval_frame name args s.heap s.buf test s.locals locals (.integer value) evaluated (parts (parts (parts safe).1).1).1)
  | switchStatic args test a b c s t flow value locals evaluated one selected ih =>
    exact (ih (parts (parts safe).1).2).trans
      (eval_frame name args s.heap s.buf test s.locals locals (.integer value) evaluated (parts (parts (parts safe).1).1).1)
  | switchOther args test a b c s t flow value locals evaluated notZero notOne selected ih =>
    exact (ih (parts safe).2).trans
      (eval_frame name args s.heap s.buf test s.locals locals (.integer value) evaluated (parts (parts (parts safe).1).1).1)
  | ret args s e value locals evaluated => exact eval_frame name args s.heap s.buf e s.locals locals (.integer value) evaluated safe
  | call => simp [statement,expression] at safe

end FT1536.Source3.KeygenCodecCellFrame
