import Source3.KeygenDecodeNoneEntryCalculations

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual q branch and length gate of the NONE prologue, with source
   assignment and honest execution construction. No desired codec result. -/
namespace FT1536.Source3.KeygenDecodeNoneEntryControl
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeNoneCore KeygenDecodeNoneEntryCalculations

theorem empty_scope (body : Stmt) (s t : State) (empty : scopeObjects body=[]) : scopeExit body s t=t := by
  unfold scopeExit
  rw [empty]
  rfl

theorem false_split (args : Args) (s t : State) (flow : Flow) (test : Expr) (yes no : Stmt)
    (calculation : Computes args s.heap s.buf s.locals test (.int32 0))
    (source : Exec args (.branch test yes no) s t flow) : Exec args no s t flow := by
  cases source with
  | branchTrue test yes no s t flow value locals evaluated selected branch =>
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals _ _ calculation locals value evaluated
    subst value
    cases selected
  | branchFalse test yes no s t flow value locals evaluated selected branch =>
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals _ _ calculation locals value evaluated
    subst locals
    exact branch

theorem false_exists (args : Args) (s t : State) (flow : Flow) (test : Expr) (yes no : Stmt)
    (calculation : Computes args s.heap s.buf s.locals test (.int32 0))
    (selected : Exec args no s t flow) : Exec args (.branch test yes no) s t flow :=
  .branchFalse args test yes no s t flow (.integer (.int32 0)) s.locals
    (computes_exists args s.heap s.buf s.locals test (.int32 0) calculation) rfl selected

def nAfter (s : State) : State := withLocals s (localSet s.locals "n".toList .uint64 (some (.uint64 1536)))

theorem q_branch_source (args : Args) (s t : State) (flow : Flow)
    (q : Cell "q" .uint32 (.uint32 18433) s.locals)
    (logn : Cell "logn" .uint32 (.uint32 10) s.locals)
    (declaredN : s.locals.scalars "n".toList=some (.uint64,none))
    (source : Exec args KeygenDecodeNoneBinding.node011 s t flow) : t=nAfter s ∧ flow=.normal := by
  have selected := false_split args s t flow _ _ _ (q_calculation args s q) source
  cases selected with
  | scope body s t flow noBufShadow inside =>
    obtain ⟨middle,assigned,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node007
      KeygenDecodeNoneBinding.node008 s t flow inside (by rfl)
    cases rest
    have result := assign_set args s t .normal "n".toList .uint64 none nRhs (.uint64 1536) declaredN
      (n_calculation args s logn) assigned
    simpa only [KeygenDecodeNoneCounter.self_uint64,nAfter,
      empty_scope KeygenDecodeNoneBinding.node009 s t (by rfl)] using result

theorem q_branch_exists (args : Args) (s : State)
    (q : Cell "q" .uint32 (.uint32 18433) s.locals)
    (logn : Cell "logn" .uint32 (.uint32 10) s.locals)
    (declaredN : s.locals.scalars "n".toList=some (.uint64,none)) :
    Exec args KeygenDecodeNoneBinding.node011 s (nAfter s) .normal := by
  have assigned : Exec args KeygenDecodeNoneBinding.node007 s (nAfter s) .normal := by
    have actual := assign_exists args s "n".toList .uint64 none nRhs (.uint64 1536)
      (by decide +kernel) (by decide +kernel) declaredN (n_calculation args s logn)
    simpa only [KeygenDecodeNoneCounter.self_uint64,KeygenDecodeNoneBinding.node007,nRhs,nAfter] using actual
  have inside : Exec args KeygenDecodeNoneBinding.node009 s (nAfter s) .normal :=
    .seq args _ _ s (nAfter s) (nAfter s) .normal assigned (.skip args _)
  have closedScope : Exec args KeygenDecodeNoneBinding.node010 s
      (scopeExit KeygenDecodeNoneBinding.node009 s (nAfter s)) .normal :=
    .scope args _ s (nAfter s) .normal (by intro impossible; cases impossible) inside
  have selected : Exec args KeygenDecodeNoneBinding.node010 s (nAfter s) .normal := by
    simpa only [empty_scope KeygenDecodeNoneBinding.node009 s (nAfter s) (by rfl)] using closedScope
  exact false_exists args s (nAfter s) .normal _ _ _ (q_calculation args s q) selected

theorem length_gate_source (args : Args) (s t : State) (flow : Flow) (enough : 3072≤args.len.toNat)
    (length : Cell "len" .uint64 (.uint64 args.len) s.locals)
    (n : Cell "n" .uint64 (.uint64 1536) s.locals)
    (source : Exec args KeygenDecodeNoneBinding.node016 s t flow) : t=s ∧ flow=.normal := by
  have selected := false_split args s t flow _ _ _ (length_test_calculation args s enough length n) source
  cases selected
  exact ⟨rfl,rfl⟩

theorem length_gate_exists (args : Args) (s : State) (enough : 3072≤args.len.toNat)
    (length : Cell "len" .uint64 (.uint64 args.len) s.locals)
    (n : Cell "n" .uint64 (.uint64 1536) s.locals) :
    Exec args KeygenDecodeNoneBinding.node016 s s .normal :=
  false_exists args s s .normal _ _ _ (length_test_calculation args s enough length n) (.skip args s)

end FT1536.Source3.KeygenDecodeNoneEntryControl
