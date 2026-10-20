import Source3.FirstBlockCertificate170_0
import Source3.FirstBlockCertificate170_1
import Source3.FirstBlockCertificate170_2
import Source3.FirstBlockCertificate170_3

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFirstCertificate170
open GeneratedPublicEvaluation170 (input first)

open PublicFirstPredicate170 (predicate)

theorem predicate_blocks (b : Fin 24) : PublicBlockChecks170.block predicate b.val=true :=
  match b with
  | ⟨0,_⟩ => FirstBlockCertificate170_0.block0
  | ⟨1,_⟩ => FirstBlockCertificate170_0.block1
  | ⟨2,_⟩ => FirstBlockCertificate170_0.block2
  | ⟨3,_⟩ => FirstBlockCertificate170_0.block3
  | ⟨4,_⟩ => FirstBlockCertificate170_0.block4
  | ⟨5,_⟩ => FirstBlockCertificate170_0.block5
  | ⟨6,_⟩ => FirstBlockCertificate170_1.block6
  | ⟨7,_⟩ => FirstBlockCertificate170_1.block7
  | ⟨8,_⟩ => FirstBlockCertificate170_1.block8
  | ⟨9,_⟩ => FirstBlockCertificate170_1.block9
  | ⟨10,_⟩ => FirstBlockCertificate170_1.block10
  | ⟨11,_⟩ => FirstBlockCertificate170_1.block11
  | ⟨12,_⟩ => FirstBlockCertificate170_2.block12
  | ⟨13,_⟩ => FirstBlockCertificate170_2.block13
  | ⟨14,_⟩ => FirstBlockCertificate170_2.block14
  | ⟨15,_⟩ => FirstBlockCertificate170_2.block15
  | ⟨16,_⟩ => FirstBlockCertificate170_2.block16
  | ⟨17,_⟩ => FirstBlockCertificate170_2.block17
  | ⟨18,_⟩ => FirstBlockCertificate170_3.block18
  | ⟨19,_⟩ => FirstBlockCertificate170_3.block19
  | ⟨20,_⟩ => FirstBlockCertificate170_3.block20
  | ⟨21,_⟩ => FirstBlockCertificate170_3.block21
  | ⟨22,_⟩ => FirstBlockCertificate170_3.block22
  | ⟨23,_⟩ => FirstBlockCertificate170_3.block23
  | ⟨n+24,h⟩ => False.elim (by omega)

theorem checked : PublicEvaluationCertificate170.FirstCheck input first KeygenPublicRoots.firstRoot := by
  rw [← PublicRootCertificate170.first]
  exact ⟨by decide +kernel,PublicBlockChecks170.sound predicate predicate_blocks⟩

theorem source : PublicEvaluationCertificate170.Represents first
    (KeygenPublicFirstFold.image SelectedEvaluation169.fVector 768) :=
  PublicEvaluationCertificate170.first_sound input first SelectedEvaluation169.fVector SelectedInputCertificate170.source checked

end FT1536.Source3.SelectedFirstCertificate170
