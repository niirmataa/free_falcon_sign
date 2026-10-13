import Source3.KeygenDecodeMemory
import Source3.KeygenDecodeStaticPointerFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Full STATIC source-frame consequence, with unrestricted actual flow.
   The statement checker is discharged on the complete pinned body. -/
namespace FT1536.Source3.KeygenDecodeStaticFrame
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticCellFrame (parts)
open KeygenDecodeMemory

theorem exec_window (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) (safe : KeygenDecodeStaticPointerFrame.statement stmt=true)
    (ptr : ArrayPointer) (held : s.locals.x=some ptr) : Window ptr s.heap t.heap := by
  induction source with
  | skip => exact window_refl ptr _
  | breakLoop => exact window_refl ptr _
  | declare => exact window_refl ptr _
  | bind => exact window_refl ptr _
  | scalar => exact window_refl ptr _
  | store s index rhs m last actual atWord offset word after original indexValue nonnegative advance rhsValue write =>
    have same := Option.some.inj (original.symm.trans held)
    subst actual
    exact store_window ptr atWord offset.integer.toNat (BitVec.ofInt 16 word.integer) s.heap after advance write
  | increment => exact window_refl ptr _
  | evaluate => exact window_refl ptr _
  | seq a b s m t flow first second ih1 ih2 =>
    have middle := (KeygenDecodeStaticPointerFrame.exec_frame args a s m .normal first (parts safe).1).trans held
    exact window_trans ptr _ _ _ (ih1 (parts safe).1 held) (ih2 (parts safe).2 middle)
  | seqBreak a b s t first ih => exact ih (parts safe).1 held
  | seqReturn a b s t ret first ih => exact ih (parts safe).1 held
  | scope a s t flow noBufShadow inside ih => exact ih safe held
  | branchTrue test a b s t flow value locals evaluated yes selected ih =>
    have middle := (KeygenDecodeStaticPointerFrame.eval_frame args s.heap s.buf test s.locals locals value evaluated (parts (parts safe).1).1).trans held
    exact ih (parts (parts safe).1).2 middle
  | branchFalse test a b s t flow value locals evaluated no selected ih =>
    have middle := (KeygenDecodeStaticPointerFrame.eval_frame args s.heap s.buf test s.locals locals value evaluated (parts (parts safe).1).1).trans held
    exact ih (parts safe).2 middle
  | whileDone => exact window_refl ptr _
  | whileNext test a s m t flow value locals evaluated yes iteration rest ih1 ih2 =>
    have middle := (KeygenDecodeStaticPointerFrame.eval_frame args s.heap s.buf test s.locals locals value evaluated (parts safe).1).trans held
    have next := (KeygenDecodeStaticPointerFrame.exec_frame args a (withLocals s locals) m .normal iteration (parts safe).2).trans middle
    exact window_trans ptr _ _ _ (ih1 (parts safe).2 middle) (ih2 safe next)
  | whileBreak test a s t value locals evaluated yes iteration ih =>
    have middle := (KeygenDecodeStaticPointerFrame.eval_frame args s.heap s.buf test s.locals locals value evaluated (parts safe).1).trans held
    exact ih (parts safe).2 middle
  | whileReturn test a s t ret value locals evaluated yes iteration ih =>
    have middle := (KeygenDecodeStaticPointerFrame.eval_frame args s.heap s.buf test s.locals locals value evaluated (parts safe).1).trans held
    exact ih (parts safe).2 middle
  | forLoop initial test increment loopBody s t flow expanded ih =>
    apply ih
    · simpa only [desugar,KeygenDecodeStaticPointerFrame.statement,KeygenDecodeStaticCellFrame.statement,
        Bool.and_eq_true,and_assoc,and_left_comm,and_comm] using safe
    · exact held
  | ret => exact window_refl ptr _

/-- Every finite defined execution of the complete pinned STATIC decoder
    preserves destination metadata and all bytes outside its physical array.
    This proves the frame only, with no desired value or length assumption. -/
theorem source_frame (args : Args) (before : Memory) (after : State) (flow : Flow)
    (ptr : ArrayPointer) (destination : args.x=some ptr)
    (source : Exec args KeygenDecodeStaticBinding.code (initial args before) after flow) :
    Window ptr before after.heap := by
  exact exec_window args _ _ after flow source (by decide +kernel) ptr destination

end FT1536.Source3.KeygenDecodeStaticFrame
