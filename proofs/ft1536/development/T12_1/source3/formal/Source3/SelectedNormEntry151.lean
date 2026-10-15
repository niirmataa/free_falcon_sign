import Source3.KeygenNormBoundary151
import Source3.SelectedFftGFrame150

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedNormEntry151
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open KeygenNormInvariant151 (Fixed Norm names)
open FftLocalCells140 (put)

noncomputable def before := SelectedFftGComplete150.after
noncomputable def zero := put before "norm".toList 0
noncomputable def initial := put zero "u".toList 0

theorem norm_type : (before.locals "norm".toList).map Prod.fst=some .uint64 := by
  change (SelectedFftGComplete150.after.locals "norm".toList).map Prod.fst=_
  rw [SelectedFftGComplete150.locals]
  decide +kernel
theorem u_type : (before.locals "u".toList).map Prod.fst=some .uint64 := by
  change (SelectedFftGComplete150.after.locals "u".toList).map Prod.fst=_
  rw [SelectedFftGComplete150.locals]
  decide +kernel
theorem n : Cell before "n".toList 1536 := by
  change SelectedFftGComplete150.after.locals "n".toList=_
  rw [SelectedFftGComplete150.locals]
  decide +kernel
theorem bound : before.locals "bound".toList=some (.uint64,some (.uint64 GeneratedBound135.finalWord)) := by
  change SelectedFftGComplete150.after.locals "bound".toList=_
  rw [SelectedFftGComplete150.locals]
  decide +kernel

theorem p_binding : before.arrays "rt1".toList=some SelectedFftBuffer141.base := by
  change SelectedFftGComplete150.after.arrays "rt1".toList=_
  rw [SelectedFftGComplete150.arrays]
  decide +kernel
theorem q_binding : before.arrays "rt2".toList=some SelectedFftGInput148.base := by
  change SelectedFftGComplete150.after.arrays "rt2".toList=_
  rw [SelectedFftGComplete150.arrays]
  decide +kernel

theorem before_fixed : Fixed before SelectedFftBuffer141.base SelectedFftGInput148.base 1536
    SelectedTripling148.finalValues SelectedFftGTripling150.finalValues :=
  ⟨by decide,by decide,by decide,p_binding,q_binding,n,SelectedFftGFrame150.rt1_image,SelectedFftGComplete150.image⟩

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
theorem fixed : Fixed initial SelectedFftBuffer141.base SelectedFftGInput148.base 1536
    SelectedTripling148.finalValues SelectedFftGTripling150.finalValues :=
  KeygenNormInvariant151.transfer _ _ _ _ _ _ _ before_fixed frame rfl
theorem norm : Norm initial 0 := (FftLocalCells140.outside zero "u".toList "norm".toList 0 (by decide)).trans
  (FftLocalCells140.cell_at before "norm".toList 0)
theorem counter : Cell initial "u".toList 0 := FftLocalCells140.cell_at zero "u".toList 0

end FT1536.Source3.SelectedNormEntry151
