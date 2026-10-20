import Source3.MakeFgGsShape194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The false !out_ntt branch (statement s8) of the make_fg_step first-prime
   tail, executed at an arbitrary input state: at this step out_ntt = 1, so
   the guard !out_ntt evaluates false and s8 executes exactly as its skip.
   The branch body is the fd/gd inverse pair at logn-1 = 8 and tlen = 2
   (MakeFgGsShape194.pairCallFd/pairCallGd); it never executes in this
   iteration and no execution of the pair body is claimed here. The state
   is returned unchanged: no value, table or transform property. -/
namespace FT1536.Source3.SelectedStepOutNtt194
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec skip)

theorem source (start : State)
    (outNttCell : start.locals "out_ntt".toList=some (.int32,some (.int32 1))) :
    Exec MakeFgTailShape190.s8 start ⟨start,.normal⟩ := by
  have guard : C99ArrayReference.scalar start
      (CLogic.Expr.lnot MakeFgTailShape190.outNtt) (.int32 0) :=
    by exact .logicalNot _ (.int32 1) (.variable _ _ _ outNttCell)
  have skipped : Exec skip start ⟨start,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip start)))
  rw [MakeFgTailShape190.s8_shape]
  exact .branchFalse _ _ _ start ⟨start,.normal⟩ (.int32 0) guard rfl skipped

end FT1536.Source3.SelectedStepOutNtt194
