import Source3.PublicBlockChecks170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedInputCertificate170
open PublicEvaluationCertificate170 (value Represents)
open GeneratedPublicEvaluation170 (input)
open KeygenPublicAlgebra (R)

def InputCheck : Prop := input.size=1536 ∧ ∀ i : Fin 1536,
  value input i.val=((SelectedSamplerWords158.fValues i).toInt : R)
instance inputCheckDecidable : Decidable InputCheck := by unfold InputCheck; infer_instance

def predicate (i : Fin 1536) : Prop := value input i.val=((SelectedSamplerWords158.fValues i).toInt : R)
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _

theorem block0 : PublicBlockChecks170.block predicate 0=true := by decide +kernel
theorem block1 : PublicBlockChecks170.block predicate 1=true := by decide +kernel
theorem block2 : PublicBlockChecks170.block predicate 2=true := by decide +kernel
theorem block3 : PublicBlockChecks170.block predicate 3=true := by decide +kernel
theorem block4 : PublicBlockChecks170.block predicate 4=true := by decide +kernel
theorem block5 : PublicBlockChecks170.block predicate 5=true := by decide +kernel
theorem block6 : PublicBlockChecks170.block predicate 6=true := by decide +kernel
theorem block7 : PublicBlockChecks170.block predicate 7=true := by decide +kernel
theorem block8 : PublicBlockChecks170.block predicate 8=true := by decide +kernel
theorem block9 : PublicBlockChecks170.block predicate 9=true := by decide +kernel
theorem block10 : PublicBlockChecks170.block predicate 10=true := by decide +kernel
theorem block11 : PublicBlockChecks170.block predicate 11=true := by decide +kernel
theorem block12 : PublicBlockChecks170.block predicate 12=true := by decide +kernel
theorem block13 : PublicBlockChecks170.block predicate 13=true := by decide +kernel
theorem block14 : PublicBlockChecks170.block predicate 14=true := by decide +kernel
theorem block15 : PublicBlockChecks170.block predicate 15=true := by decide +kernel
theorem block16 : PublicBlockChecks170.block predicate 16=true := by decide +kernel
theorem block17 : PublicBlockChecks170.block predicate 17=true := by decide +kernel
theorem block18 : PublicBlockChecks170.block predicate 18=true := by decide +kernel
theorem block19 : PublicBlockChecks170.block predicate 19=true := by decide +kernel
theorem block20 : PublicBlockChecks170.block predicate 20=true := by decide +kernel
theorem block21 : PublicBlockChecks170.block predicate 21=true := by decide +kernel
theorem block22 : PublicBlockChecks170.block predicate 22=true := by decide +kernel
theorem block23 : PublicBlockChecks170.block predicate 23=true := by decide +kernel

theorem blocks (b : Fin 24) : PublicBlockChecks170.block predicate b.val=true :=
  match b with
  | ⟨0,_⟩ => block0
  | ⟨1,_⟩ => block1
  | ⟨2,_⟩ => block2
  | ⟨3,_⟩ => block3
  | ⟨4,_⟩ => block4
  | ⟨5,_⟩ => block5
  | ⟨6,_⟩ => block6
  | ⟨7,_⟩ => block7
  | ⟨8,_⟩ => block8
  | ⟨9,_⟩ => block9
  | ⟨10,_⟩ => block10
  | ⟨11,_⟩ => block11
  | ⟨12,_⟩ => block12
  | ⟨13,_⟩ => block13
  | ⟨14,_⟩ => block14
  | ⟨15,_⟩ => block15
  | ⟨16,_⟩ => block16
  | ⟨17,_⟩ => block17
  | ⟨18,_⟩ => block18
  | ⟨19,_⟩ => block19
  | ⟨20,_⟩ => block20
  | ⟨21,_⟩ => block21
  | ⟨22,_⟩ => block22
  | ⟨23,_⟩ => block23
  | ⟨n+24,h⟩ => False.elim (by omega)

theorem checked : InputCheck := ⟨by decide +kernel,PublicBlockChecks170.sound predicate blocks⟩

theorem source : Represents input (KeygenPublicInputMaterial.reduced SelectedEvaluation169.fVector) := by
  refine ⟨checked.1,?_⟩
  intro i hi
  change value input i=(KeygenPublicInputMaterial.coefficient (SamplerVector169.vector SelectedSamplerWords158.fValues) i : R)
  rw [SamplerVector169.coefficient_word _ i hi]
  exact checked.2 ⟨i,hi⟩

end FT1536.Source3.SelectedInputCertificate170
