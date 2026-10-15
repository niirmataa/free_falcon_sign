import Source3.SelectedFftGroup141
import Source3.FftControlShape142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGroupFacts142
open C99CompactState115 (reference)
open C99LoopScalar141 (Cell)
open SelectedFftGroup141 (after)

theorem local_cell (name : C99ArrayReference.Name)
    (outside : name∉FftMiddleShape139.scopeLocals FftMiddleShape139.groupBody)
    (notCounter : name≠"v".toList) :
    after.locals name=(reference SelectedFftBuffer141.before).locals name := by
  have absent : (FftMiddleShape139.scopeLocals FftMiddleShape139.groupBody).contains name=false := by
    cases found : (FftMiddleShape139.scopeLocals FftMiddleShape139.groupBody).contains name with
    | false => rfl
    | true => exact (outside (List.contains_iff_mem.mp found)).elim
  unfold after C99ArrayReference.restoreScope C99ScalarReference.restore
  change (if (FftMiddleShape139.scopeLocals FftMiddleShape139.groupBody).contains name then
    (reference SelectedFftMiddleStart139.groupInit).locals name else SelectedFftLoop141.after.locals name)=_
  simp only [absent, Bool.false_eq_true, ite_false]
  exact SelectedFftLoop141.frame.locals name notCounter

theorem u1 : Cell after "u1".toList 0 := by
  change after.locals "u1".toList=_
  rw [local_cell "u1".toList (by decide +kernel) (by decide)]
  decide +kernel

theorem v1 : Cell after "v1".toList 0 := by
  change after.locals "v1".toList=_
  rw [local_cell "v1".toList (by decide +kernel) (by decide)]
  decide +kernel

theorem t : Cell after "t".toList 768 := by
  change after.locals "t".toList=_
  rw [local_cell "t".toList (by decide +kernel) (by decide)]
  decide +kernel

theorem ht : Cell after "ht".toList 384 := by
  change after.locals "ht".toList=_
  rw [local_cell "ht".toList (by decide +kernel) (by decide)]
  decide +kernel

theorem hm : Cell after "hm".toList 1 := by
  change after.locals "hm".toList=_
  rw [local_cell "hm".toList (by decide +kernel) (by decide)]
  decide +kernel

theorem m : Cell after "m".toList 2 := by
  change after.locals "m".toList=_
  rw [local_cell "m".toList (by decide +kernel) (by decide)]
  decide +kernel

end FT1536.Source3.SelectedFftGroupFacts142
