import Source3.GeneratedPublicTree170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTreeInput170
open PublicTreeEvaluation170 (value Represents)
open GeneratedPublicTree170 (input)
open KeygenPublicAlgebra (R)

def predicate (i : Fin 1536) : Prop := value input i.val=((SelectedSamplerWords158.fValues i).toInt : R)
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _

theorem checked : (List.finRange 1536).all (fun i => decide (predicate i))=true := by decide +kernel

theorem source : Represents input (KeygenPublicInputMaterial.reduced SelectedEvaluation169.fVector) := by
  refine ⟨by decide +kernel,?_⟩
  intro i hi
  change value input i=(KeygenPublicInputMaterial.coefficient (SamplerVector169.vector SelectedSamplerWords158.fValues) i : R)
  rw [SamplerVector169.coefficient_word _ i hi]
  exact of_decide_eq_true (List.all_eq_true.mp checked ⟨i,hi⟩ (by simp))

end FT1536.Source3.SelectedTreeInput170
