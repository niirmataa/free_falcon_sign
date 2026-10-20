import Source3.StageBlockCertificate170_1_0
import Source3.StageBlockCertificate170_1_1
import Source3.StageBlockCertificate170_1_2
import Source3.StageBlockCertificate170_1_3

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedStageCertificate170_1
open GeneratedPublicEvaluation170 (first stage1)

open PublicStagePredicate170_1 (predicate)

theorem predicate_blocks (b : Fin 24) : PublicBlockChecks170.block predicate b.val=true :=
  match b with
  | ⟨0,_⟩ => StageBlockCertificate170_1_0.block0
  | ⟨1,_⟩ => StageBlockCertificate170_1_0.block1
  | ⟨2,_⟩ => StageBlockCertificate170_1_0.block2
  | ⟨3,_⟩ => StageBlockCertificate170_1_0.block3
  | ⟨4,_⟩ => StageBlockCertificate170_1_0.block4
  | ⟨5,_⟩ => StageBlockCertificate170_1_0.block5
  | ⟨6,_⟩ => StageBlockCertificate170_1_1.block6
  | ⟨7,_⟩ => StageBlockCertificate170_1_1.block7
  | ⟨8,_⟩ => StageBlockCertificate170_1_1.block8
  | ⟨9,_⟩ => StageBlockCertificate170_1_1.block9
  | ⟨10,_⟩ => StageBlockCertificate170_1_1.block10
  | ⟨11,_⟩ => StageBlockCertificate170_1_1.block11
  | ⟨12,_⟩ => StageBlockCertificate170_1_2.block12
  | ⟨13,_⟩ => StageBlockCertificate170_1_2.block13
  | ⟨14,_⟩ => StageBlockCertificate170_1_2.block14
  | ⟨15,_⟩ => StageBlockCertificate170_1_2.block15
  | ⟨16,_⟩ => StageBlockCertificate170_1_2.block16
  | ⟨17,_⟩ => StageBlockCertificate170_1_2.block17
  | ⟨18,_⟩ => StageBlockCertificate170_1_3.block18
  | ⟨19,_⟩ => StageBlockCertificate170_1_3.block19
  | ⟨20,_⟩ => StageBlockCertificate170_1_3.block20
  | ⟨21,_⟩ => StageBlockCertificate170_1_3.block21
  | ⟨22,_⟩ => StageBlockCertificate170_1_3.block22
  | ⟨23,_⟩ => StageBlockCertificate170_1_3.block23
  | ⟨n+24,h⟩ => False.elim (by omega)

theorem checked : PublicEvaluationCertificate170.StageCheck first stage1 0 := by
  refine ⟨by decide +kernel,?_⟩
  intro i
  rw [← PublicRootArrayValues170.stage_eq first 0 i.val (by decide) i.isLt]
  exact PublicBlockChecks170.sound predicate predicate_blocks i

theorem source : PublicEvaluationCertificate170.Represents stage1
    (KeygenPublicRadixStages.image (KeygenPublicFirstFold.image SelectedEvaluation169.fVector 768) 1) :=
  PublicEvaluationCertificate170.stage_sound first stage1 _ 0 (by decide) SelectedFirstCertificate170.source checked

end FT1536.Source3.SelectedStageCertificate170_1
