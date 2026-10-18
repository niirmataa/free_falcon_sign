import Source3.PublicRootCertificate170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRootArrayValues170
open GeneratedPublicEvaluation170 (roots)
open PublicEvaluationCertificate170 (value)
open KeygenPublicAlgebra (R)

def stage (a : Array Nat) (m h i : Nat) : R :=
  let j:=i/(2*h)
  let k:=i%(2*h)
  let z:=value roots (m+j)
  if k<h then value a (j*(2*h)+k)+value a (j*(2*h)+h+k)*z
  else value a (j*(2*h)+(k-h))-value a (j*(2*h)+h+(k-h))*z

theorem stage_eq (a : Array Nat) (k i : Nat) (active : k<8) (inside : i<1536) :
    stage a (KeygenPublicRadixStages.count k) (KeygenPublicRadixStages.size k/2) i=
      PublicEvaluationCertificate170.stageValue a (KeygenPublicRadixStages.count k) (KeygenPublicRadixStages.size k/2) i := by
  obtain ⟨positive,bound,extent,_,_,_,_⟩ := KeygenPublicRadixStages.dimensions k active
  have row : i/(2*(KeygenPublicRadixStages.size k/2))<KeygenPublicRadixStages.count k :=
    (Nat.div_lt_iff_lt_mul (by omega)).2 (by omega)
  have indexBound : KeygenPublicRadixStages.count k+i/(2*(KeygenPublicRadixStages.size k/2))<1024 := by omega
  unfold stage PublicEvaluationCertificate170.stageValue KeygenPublicRadixPolynomial.split
    KeygenPublicRadixFold.low KeygenPublicRadixFold.high KeygenPublicRadixRow.root
  dsimp only
  rw [PublicRootCertificate170.field _ indexBound]

def triple (a : Array Nat) (i : Nat) : R :=
  KeygenPublicTripleOrder.output (value a (3*(i/3))) (value a (3*(i/3)+1)) (value a (3*(i/3)+2))
    (value roots (512+i/3)) ((value roots 1)^2) (i%3)

theorem triple_eq (a : Array Nat) (i : Nat) (inside : i<1536) :
    triple a i=KeygenPublicTripleFold.value (value a) i := by
  unfold triple KeygenPublicTripleFold.value KeygenPublicTripleFold.root
  rw [PublicRootCertificate170.field _ (by omega),PublicRootCertificate170.unity]

end FT1536.Source3.PublicRootArrayValues170
