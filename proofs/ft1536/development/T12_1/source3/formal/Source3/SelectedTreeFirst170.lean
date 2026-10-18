import Source3.SelectedTreeInput170
import Source3.PublicTreeRootValues170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTreeFirst170
open GeneratedPublicTree170 (input first roots)
open PublicTreeEvaluation170 (value)

def predicate (i : Fin 1536) : Prop := value first i.val=PublicTreeEvaluation170.firstValue input (value roots 1) i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _

theorem checked : (List.finRange 1536).all (fun i => decide (predicate i))=true := by decide +kernel

theorem first_checked : PublicTreeEvaluation170.FirstCheck input first KeygenPublicRoots.firstRoot := by
  rw [← PublicTreeRoots170.first]
  refine ⟨by decide +kernel,?_⟩
  intro i
  exact of_decide_eq_true (List.all_eq_true.mp checked i (by simp))

theorem source : PublicTreeEvaluation170.Represents first (KeygenPublicFirstFold.image SelectedEvaluation169.fVector 768) :=
  PublicTreeEvaluation170.first_sound input first SelectedEvaluation169.fVector SelectedTreeInput170.source first_checked

end FT1536.Source3.SelectedTreeFirst170
