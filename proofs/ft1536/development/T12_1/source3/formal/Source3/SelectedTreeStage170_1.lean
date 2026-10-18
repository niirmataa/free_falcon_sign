import Source3.SelectedTreeFirst170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTreeStage170_1
open GeneratedPublicTree170 (first stage1)
open PublicTreeEvaluation170 (value)

def predicate (i : Fin 1536) : Prop := value stage1 i.val=PublicTreeRootValues170.stage first
  (KeygenPublicRadixStages.count 0) (KeygenPublicRadixStages.size 0/2) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _

theorem checked : (List.finRange 1536).all (fun i => decide (predicate i))=true := by decide +kernel

theorem stage_checked : PublicTreeEvaluation170.StageCheck first stage1 0 := by
  refine ⟨by decide +kernel,?_⟩
  intro i
  rw [← PublicTreeRootValues170.stage_eq first 0 i.val (by decide) i.isLt]
  exact of_decide_eq_true (List.all_eq_true.mp checked i (by simp))

theorem source : PublicTreeEvaluation170.Represents stage1
    (KeygenPublicRadixStages.image (KeygenPublicFirstFold.image SelectedEvaluation169.fVector 768) 1) :=
  PublicTreeEvaluation170.stage_sound first stage1 _ 0 (by decide) SelectedTreeFirst170.source stage_checked

end FT1536.Source3.SelectedTreeStage170_1
