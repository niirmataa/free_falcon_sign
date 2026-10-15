import Source3.SelectedFftGroupFacts142
import Source3.C99ControlCells142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGroupControl142
open C99CompactState115 (reference)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open FftLocalCells140 (put)
open C99ControlCells142 (at_cell other_cell)
open FftMiddleShape139

noncomputable def one := put SelectedFftGroup141.after "u1".toList (word 1)
noncomputable def after := put one "v1".toList (word 768)

theorem one_v1 : Cell one "v1".toList 0 :=
  other_cell _ _ _ _ _ (by decide) SelectedFftGroupFacts142.v1

theorem one_t : Cell one "t".toList 768 :=
  other_cell _ _ _ _ _ (by decide) SelectedFftGroupFacts142.t

theorem increment_source : C99ProcedureReference.Exec KeygenSearchFft.program groupIncrement
    SelectedFftGroup141.after ⟨after,.normal⟩ := by
  rw [FftControlShape142.group_increment]
  exact .seqNormal _ _ _ one _
    (C99LoopScalar141.increment _ _ "u1".toList 0 (by decide) SelectedFftGroupFacts142.u1)
    (C99LoopAssign142.add _ one "v1".toList "t".toList 0 768 (by decide) (by decide) one_v1 one_t)

theorem u1 : Cell after "u1".toList 1 :=
  other_cell _ _ _ _ _ (by decide) (at_cell _ _ _)

theorem hm : Cell after "hm".toList 1 :=
  other_cell _ _ _ _ _ (by decide) (other_cell _ _ _ _ _ (by decide) SelectedFftGroupFacts142.hm)

theorem t : Cell after "t".toList 768 :=
  other_cell _ _ _ _ _ (by decide) one_t

theorem ht : Cell after "ht".toList 384 :=
  other_cell _ _ _ _ _ (by decide) (other_cell _ _ _ _ _ (by decide) SelectedFftGroupFacts142.ht)

theorem initial_guard : C99ArrayReference.scalar (reference SelectedFftMiddleStart139.groupInit)
    groupCondition (C99ScalarReference.boolean true) := by
  rw [FftControlShape142.group_condition]
  exact C99LoopScalar141.less _ _ _ 0 1 (by decide) (by decide)
    (C99LoopScalar141.read _ _ 0 (by unfold Cell; decide +kernel))
    (C99LoopScalar141.read _ _ 1 (by unfold Cell; decide +kernel))

theorem final_guard : C99ArrayReference.scalar after groupCondition (C99ScalarReference.boolean false) := by
  rw [FftControlShape142.group_condition]
  exact C99LoopScalar141.less _ _ _ 1 1 (by decide) (by decide)
    (C99LoopScalar141.read _ _ 1 u1) (C99LoopScalar141.read _ _ 1 hm)

theorem source : C99ProcedureReference.Exec KeygenSearchFft.program groupLoop
    (reference SelectedFftMiddleStart139.groupInit) ⟨after,.normal⟩ := by
  rw [group_shape]
  exact .loopNormal _ _ _ _ _ _ _ _ initial_guard (by decide)
    SelectedFftGroup141.source increment_source (.loopFalse _ _ _ _ _ final_guard rfl)

theorem image : C99WordBuffer140.Represents after.heap SelectedFftBuffer141.base SelectedFftLoop141.finalValues :=
  SelectedFftGroup141.image

end FT1536.Source3.SelectedFftGroupControl142
