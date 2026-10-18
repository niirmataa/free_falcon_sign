import Source3.SelectedTreeStage170_7

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTreeStage170_8
open GeneratedPublicTree170 (stage7 stage8)
open PublicTreeEvaluation170 (value)

def predicate (i : Fin 1536) : Prop := value stage8 i.val=PublicTreeRootValues170.stage stage7
  (KeygenPublicRadixStages.count 7) (KeygenPublicRadixStages.size 7/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _

theorem checked : (List.finRange 1536).all (fun i => decide (predicate i))=true := by decide +kernel

theorem stage_checked : PublicTreeEvaluation170.StageCheck stage7 stage8 7 := by
  refine ⟨by decide +kernel,?_⟩
  intro i
  rw [← PublicTreeRootValues170.stage_eq stage7 7 i.val (by decide) i.isLt]
  exact of_decide_eq_true (List.all_eq_true.mp checked i (by simp))

theorem source : PublicTreeEvaluation170.Represents stage8
    (KeygenPublicRadixStages.image (KeygenPublicFirstFold.image SelectedEvaluation169.fVector 768) 8) :=
  PublicTreeEvaluation170.stage_sound stage7 stage8 _ 7 (by decide) SelectedTreeStage170_7.source stage_checked

end FT1536.Source3.SelectedTreeStage170_8
