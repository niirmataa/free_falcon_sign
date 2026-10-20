import Source3.TripleBlockCertificate170_0
import Source3.TripleBlockCertificate170_1
import Source3.TripleBlockCertificate170_2
import Source3.TripleBlockCertificate170_3

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedNonzeroCertificate170
open GeneratedPublicEvaluation170 (stage8 output)

open PublicTriplePredicate170 (predicate)

theorem predicate_blocks (b : Fin 24) : PublicBlockChecks170.block predicate b.val=true :=
  match b with
  | ⟨0,_⟩ => TripleBlockCertificate170_0.block0
  | ⟨1,_⟩ => TripleBlockCertificate170_0.block1
  | ⟨2,_⟩ => TripleBlockCertificate170_0.block2
  | ⟨3,_⟩ => TripleBlockCertificate170_0.block3
  | ⟨4,_⟩ => TripleBlockCertificate170_0.block4
  | ⟨5,_⟩ => TripleBlockCertificate170_0.block5
  | ⟨6,_⟩ => TripleBlockCertificate170_1.block6
  | ⟨7,_⟩ => TripleBlockCertificate170_1.block7
  | ⟨8,_⟩ => TripleBlockCertificate170_1.block8
  | ⟨9,_⟩ => TripleBlockCertificate170_1.block9
  | ⟨10,_⟩ => TripleBlockCertificate170_1.block10
  | ⟨11,_⟩ => TripleBlockCertificate170_1.block11
  | ⟨12,_⟩ => TripleBlockCertificate170_2.block12
  | ⟨13,_⟩ => TripleBlockCertificate170_2.block13
  | ⟨14,_⟩ => TripleBlockCertificate170_2.block14
  | ⟨15,_⟩ => TripleBlockCertificate170_2.block15
  | ⟨16,_⟩ => TripleBlockCertificate170_2.block16
  | ⟨17,_⟩ => TripleBlockCertificate170_2.block17
  | ⟨18,_⟩ => TripleBlockCertificate170_3.block18
  | ⟨19,_⟩ => TripleBlockCertificate170_3.block19
  | ⟨20,_⟩ => TripleBlockCertificate170_3.block20
  | ⟨21,_⟩ => TripleBlockCertificate170_3.block21
  | ⟨22,_⟩ => TripleBlockCertificate170_3.block22
  | ⟨23,_⟩ => TripleBlockCertificate170_3.block23
  | ⟨n+24,h⟩ => False.elim (by omega)

theorem triple_checked : PublicEvaluationCertificate170.TripleCheck stage8 output := by
  refine ⟨by decide +kernel,?_⟩
  intro i
  rw [← PublicRootArrayValues170.triple_eq stage8 i.val i.isLt]
  exact PublicBlockChecks170.sound predicate predicate_blocks i

theorem output_values : PublicEvaluationCertificate170.Represents output
    (KeygenPublicTripleFold.value (KeygenPublicRadixEntry.radixImage SelectedEvaluation169.fVector)) :=
  PublicEvaluationCertificate170.triple_sound stage8 output _ SelectedStageCertificate170_8.source triple_checked

theorem nonzero_checked : PublicEvaluationCertificate170.NonzeroCheck output := by
  apply PublicFiniteChecks170.sound
  decide +kernel

theorem evaluations_nonzero (i : Fin 1536) :
    (FT1536.Run2.CoefficientQuotient.polynomial (Relation.reduceVec SelectedEvaluation169.fVector)).eval
      (KeygenPublicRoots.point i)≠0 :=
  PublicEvaluationCertificate170.nonzero_sound output SelectedEvaluation169.fVector output_values nonzero_checked i

theorem t_nonzero (i : Fin 1536) : ∃ w : BitVec 16,
    C99NarrowReads.Load16 SelectedForwardT168.output.heap (KeygenSmallOutput.element SelectedPublicStart157.t i.val) w ∧
      w.toNat<18433 ∧ w.toNat≠0 := by
  obtain ⟨w,read,bound,equal⟩ := SelectedEvaluation169.source.2.2 i
  refine ⟨w,read,bound,?_⟩
  intro zero
  have nz := evaluations_nonzero i
  rw [← equal,zero,Nat.cast_zero] at nz
  exact nz rfl

end FT1536.Source3.SelectedNonzeroCertificate170
