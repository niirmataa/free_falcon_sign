import Source3.StageBlockCertificate170_8_0
import Source3.StageBlockCertificate170_8_1
import Source3.StageBlockCertificate170_8_2
import Source3.StageBlockCertificate170_8_3

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedStageCertificate170_8
open GeneratedPublicEvaluation170 (stage7 stage8)

open PublicStagePredicate170_8 (predicate)

theorem predicate_blocks (b : Fin 24) : PublicBlockChecks170.block predicate b.val=true :=
  match b with
  | ⟨0,_⟩ => StageBlockCertificate170_8_0.block0
  | ⟨1,_⟩ => StageBlockCertificate170_8_0.block1
  | ⟨2,_⟩ => StageBlockCertificate170_8_0.block2
  | ⟨3,_⟩ => StageBlockCertificate170_8_0.block3
  | ⟨4,_⟩ => StageBlockCertificate170_8_0.block4
  | ⟨5,_⟩ => StageBlockCertificate170_8_0.block5
  | ⟨6,_⟩ => StageBlockCertificate170_8_1.block6
  | ⟨7,_⟩ => StageBlockCertificate170_8_1.block7
  | ⟨8,_⟩ => StageBlockCertificate170_8_1.block8
  | ⟨9,_⟩ => StageBlockCertificate170_8_1.block9
  | ⟨10,_⟩ => StageBlockCertificate170_8_1.block10
  | ⟨11,_⟩ => StageBlockCertificate170_8_1.block11
  | ⟨12,_⟩ => StageBlockCertificate170_8_2.block12
  | ⟨13,_⟩ => StageBlockCertificate170_8_2.block13
  | ⟨14,_⟩ => StageBlockCertificate170_8_2.block14
  | ⟨15,_⟩ => StageBlockCertificate170_8_2.block15
  | ⟨16,_⟩ => StageBlockCertificate170_8_2.block16
  | ⟨17,_⟩ => StageBlockCertificate170_8_2.block17
  | ⟨18,_⟩ => StageBlockCertificate170_8_3.block18
  | ⟨19,_⟩ => StageBlockCertificate170_8_3.block19
  | ⟨20,_⟩ => StageBlockCertificate170_8_3.block20
  | ⟨21,_⟩ => StageBlockCertificate170_8_3.block21
  | ⟨22,_⟩ => StageBlockCertificate170_8_3.block22
  | ⟨23,_⟩ => StageBlockCertificate170_8_3.block23
  | ⟨n+24,h⟩ => False.elim (by omega)

theorem checked : PublicEvaluationCertificate170.StageCheck stage7 stage8 7 := by
  refine ⟨by decide +kernel,?_⟩
  intro i
  rw [← PublicRootArrayValues170.stage_eq stage7 7 i.val (by decide) i.isLt]
  exact PublicBlockChecks170.sound predicate predicate_blocks i

theorem source : PublicEvaluationCertificate170.Represents stage8
    (KeygenPublicRadixStages.image (KeygenPublicFirstFold.image SelectedEvaluation169.fVector 768) 8) :=
  PublicEvaluationCertificate170.stage_sound stage7 stage8 _ 7 (by decide) SelectedStageCertificate170_7.source checked

end FT1536.Source3.SelectedStageCertificate170_8
