import Source3.SelectedTreeStage170_6

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTreeStage170_7
open GeneratedPublicTree170 (stage6 stage7)
open PublicTreeEvaluation170 (value)

def predicate (i : Fin 1536) : Prop := value stage7 i.val=PublicTreeRootValues170.stage stage6
  (KeygenPublicRadixStages.count 6) (KeygenPublicRadixStages.size 6/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _

theorem checked : (List.finRange 1536).all (fun i => decide (predicate i))=true := by decide +kernel

theorem stage_checked : PublicTreeEvaluation170.StageCheck stage6 stage7 6 := by
  refine ⟨by decide +kernel,?_⟩
  intro i
  rw [← PublicTreeRootValues170.stage_eq stage6 6 i.val (by decide) i.isLt]
  exact of_decide_eq_true (List.all_eq_true.mp checked i (by simp))

theorem source : PublicTreeEvaluation170.Represents stage7
    (KeygenPublicRadixStages.image (KeygenPublicFirstFold.image SelectedEvaluation169.fVector 768) 7) :=
  PublicTreeEvaluation170.stage_sound stage6 stage7 _ 6 (by decide) SelectedTreeStage170_6.source stage_checked

end FT1536.Source3.SelectedTreeStage170_7
