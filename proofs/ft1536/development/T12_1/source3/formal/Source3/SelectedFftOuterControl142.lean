import Source3.SelectedFftGroupControl142
import Source3.C99ControlShift142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftOuterControl142
open C99CompactState115 (reference)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open C99ControlCells142 (at_cell other_cell)
open FftLocalCells140 (put)
open FftMiddleShape139

noncomputable def assigned := put SelectedFftGroupControl142.after "t".toList (word 384)
noncomputable def bodyAfter := C99ArrayReference.restoreScope
  (reference SelectedFftMiddleStart139.setup) assigned (scopeLocals outerBody) (scopePointers outerBody)
noncomputable def after := put bodyAfter "m".toList (word 4)

theorem outer_names : scopeLocals outerBody=["ht".toList,"hm".toList,"u1".toList,"v1".toList] := by rfl
theorem outer_pointers : scopePointers outerBody=[] := by rfl

theorem assignment_source : C99ProcedureReference.Exec KeygenSearchFft.program setTNext
    SelectedFftGroupControl142.after ⟨assigned,.normal⟩ := by
  rw [FftControlShape142.next_t]
  exact C99ControlCells142.array_copy _ _ _ _ 768 384 SelectedFftGroupControl142.t SelectedFftGroupControl142.ht

theorem body_source : C99ProcedureReference.Exec KeygenSearchFft.program outerBody
    (reference SelectedFftMiddleStart139.setup) ⟨bodyAfter,.normal⟩ :=
  FftReferenceCompose141.outer _ _ _ _ _ SelectedFftMiddleStart139.outerEntry_source
    SelectedFftMiddleStart139.groupInit_source SelectedFftGroupControl142.source assignment_source

theorem body_local (name : C99ArrayReference.Name) (outside : name∉scopeLocals outerBody) :
    bodyAfter.locals name=assigned.locals name := by
  have absent : (scopeLocals outerBody).contains name=false := by
    cases found : (scopeLocals outerBody).contains name with
    | false => rfl
    | true => exact (outside (List.contains_iff_mem.mp found)).elim
  change (if (scopeLocals outerBody).contains name then
    (reference SelectedFftMiddleStart139.setup).locals name else assigned.locals name)=_
  simp only [absent, Bool.false_eq_true, ite_false]

theorem body_t : Cell bodyAfter "t".toList 384 := by
  unfold Cell
  rw [body_local _ (by rw [outer_names]; decide)]
  exact at_cell _ _ _

theorem body_m : Cell bodyAfter "m".toList 2 := by
  unfold Cell
  rw [body_local _ (by rw [outer_names]; decide)]
  exact other_cell _ _ _ _ _ (by decide)
    (other_cell _ _ _ _ _ (by decide) (other_cell _ _ _ _ _ (by decide) SelectedFftGroupFacts142.m))

theorem increment_source : C99ProcedureReference.Exec KeygenSearchFft.program outerIncrement
    bodyAfter ⟨after,.normal⟩ := by
  rw [FftControlShape142.outer_increment]
  exact C99ControlShift142.double _ _ _ 2 (by decide) body_m

theorem initial_guard : C99ArrayReference.scalar (reference SelectedFftMiddleStart139.setup)
    outerCondition (.int32 1) :=
  C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls SelectedFftMiddleStart139.setup.locals
    outerCondition (.i32 1) (by decide +kernel)

/-- One complete original outer iteration, including group termination and m increment. -/
theorem source : C99ProcedureSegments136.Prefix KeygenSearchFft.program
    outerCondition outerBody outerIncrement 1 (reference SelectedFftMiddleStart139.setup) after :=
  .next 0 _ _ _ _ _ initial_guard (by decide) body_source increment_source (.done _)

theorem t : Cell after "t".toList 384 := other_cell _ _ _ _ _ (by decide) body_t
theorem m : Cell after "m".toList 4 := at_cell _ _ _

theorem image : C99WordBuffer140.Represents after.heap SelectedFftBuffer141.base SelectedFftLoop141.finalValues :=
  SelectedFftGroup141.image

end FT1536.Source3.SelectedFftOuterControl142
