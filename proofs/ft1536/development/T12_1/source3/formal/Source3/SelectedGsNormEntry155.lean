import Source3.SelectedGsAuto155

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsNormEntry155
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open KeygenNormInvariant151 (Fixed Norm names)
open FftLocalCells140 (put)
open SelectedGsStart155 (p q)

noncomputable def before := SelectedGsAuto155.after
noncomputable def zero := put before "norm".toList 0
noncomputable def initial := put zero "u".toList 0

theorem locals : before.locals=SelectedRawNorm151.after.locals := SelectedGsAuto155.locals.trans SelectedGsAuto155.before_locals
theorem arrays : before.arrays=SelectedGsStart155.before.arrays := SelectedGsAuto155.arrays.trans SelectedGsAuto155.before_arrays

theorem norm_type : (before.locals "norm".toList).map Prod.fst=some .uint64 := by
  rw [locals,SelectedRawNorm151.norm_cell]
  rfl
theorem u_type : (before.locals "u".toList).map Prod.fst=some .uint64 := by
  have cell : SelectedRawNorm151.after.locals "u".toList=some (.uint64,some (.uint64 (C99NatWord141.word 1536))) :=
    (FftLocalCells140.outside SelectedRawNorm151.loopAfter "norm".toList "u".toList SelectedRawNorm151.finalWord (by decide)).trans
      (Classical.choose_spec SelectedRawNorm151.exists_loop).2.2.1
  rw [locals,cell]
  rfl
theorem n : Cell before "n".toList 1536 :=
  (congrFun locals "n".toList).trans
    ((FftLocalCells140.outside SelectedRawNorm151.loopAfter "norm".toList "n".toList SelectedRawNorm151.finalWord (by decide)).trans
      ((SelectedRawNorm151.loop_frame.locals _ (by decide)).trans
        ((SelectedNormEntry151.frame.locals _ (by decide)).trans SelectedNormEntry151.n)))
theorem bound : before.locals "bound".toList=some (.uint64,some (.uint64 GeneratedBound135.finalWord)) :=
  (congrFun locals "bound".toList).trans SelectedRawNorm151.bound_cell
theorem p_binding : before.arrays "rt1".toList=some p := (congrFun arrays "rt1".toList).trans SelectedGsStart155.p_binding
theorem q_binding : before.arrays "rt2".toList=some q := (congrFun arrays "rt2".toList).trans SelectedGsStart155.q_binding

theorem before_fixed : Fixed before p q 1536 SelectedGsAuto155.fValues SelectedGsAuto155.gValues :=
  ⟨by decide,by decide,by decide,p_binding,q_binding,n,SelectedGsAuto155.f_image,SelectedGsAuto155.g_image⟩

theorem zero_source : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormShape151.zero before ⟨zero,.normal⟩ := by
  obtain ⟨old,cell⟩ := KeygenNormBoundary151.declared before "norm".toList norm_type
  exact KeygenNormBoundary151.zero _ before old cell
theorem initialization : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormShape151.initial zero ⟨initial,.normal⟩ := by
  obtain ⟨old,cell⟩ := KeygenNormBoundary151.declared before "u".toList u_type
  exact .procedure _ _ _ (C99OuterScalar144.clear _ zero "u".toList old
    ((FftLocalCells140.outside before "norm".toList "u".toList 0 (by decide)).trans cell))
theorem frame : C99ScopeFrame147.Frame names before initial :=
  C99ScopeFrame147.trans names before zero initial (C99ScopeFrame147.put names before "norm".toList 0 (by decide))
    (C99ScopeFrame147.put names zero "u".toList 0 (by decide))
theorem fixed : Fixed initial p q 1536 SelectedGsAuto155.fValues SelectedGsAuto155.gValues :=
  KeygenNormInvariant151.transfer _ _ _ _ _ _ _ before_fixed frame rfl
theorem norm : Norm initial 0 := (FftLocalCells140.outside zero "u".toList "norm".toList 0 (by decide)).trans
  (FftLocalCells140.cell_at before "norm".toList 0)
theorem counter : Cell initial "u".toList 0 := FftLocalCells140.cell_at zero "u".toList 0

end FT1536.Source3.SelectedGsNormEntry155
