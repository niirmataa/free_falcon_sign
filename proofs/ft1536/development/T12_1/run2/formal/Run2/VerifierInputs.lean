import Run2.FileVerifier
import Run2.VerifierResources
import FT1536.PublicSimulation

namespace FT1536.Run2.FileVerifier
open FT1536.Relation BitArithmetic FileArithmetic PolynomialReference PublicSimulation

/- Boundary encodings: h and c arrive as 1536 sixteen-bit residues; a BoxVec
arrives as 1536 sign-magnitude words. Encoding is not an uncharged runtime
operation in the verifier; these maps specify the input representation. -/
def fieldEncoding (a : Rq) : List (List Bool) :=
  List.ofFn fun r : Fin 1536 => encodeNat (PolynomialMachine.flat a r).val 16

theorem fieldEncoding_length (a : Rq) : (fieldEncoding a).length=1536 := List.length_ofFn

theorem fieldEncoding_width (a : Rq) : ∀ w∈fieldEncoding a,w.length≤16 := by
  intro w hw
  obtain ⟨r,rfl⟩:=List.mem_ofFn.mp hw
  rw [encodeNat_length]

theorem fieldEncoding_represents (a : Rq) : FieldRepresents (fieldEncoding a) a := by
  intro i
  rw [FieldProgram.load_correct]
  change (value (((List.ofFn _)[exponent i]?.getD [])) : F)=_
  rw [getD_ofFn _ ⟨exponent i,exponent_lt i⟩]
  rw [encodeNat_value _ _ ((ZMod.val_lt _).trans (by decide)),ZMod.natCast_zmod_val,
    PolynomialMachine.flat_exponent]

def flatInt (s : Geometry.Vec) (r : Fin 1536) : ℤ :=
  if h : r.val<768 then (s ⟨r.val,h⟩).1 else (s ⟨r.val-768,by omega⟩).2

theorem flatInt_exponent (s : Geometry.Vec) (i : TermIndex) :
    flatInt s ⟨exponent i,exponent_lt i⟩=intCoefficient s i := by
  obtain ⟨i,b⟩:=i
  have hi:=i.isLt
  cases b <;> simp [flatInt,exponent,intCoefficient,hi]

def signatureEncoding (s : BoxVec) : List SignedWord :=
  List.ofFn fun r : Fin 1536 => encodeSigned (flatInt (decodeVec s) r) 16

theorem signatureEncoding_length (s : BoxVec) : (signatureEncoding s).length=1536 := List.length_ofFn

theorem signatureEncoding_width (s : BoxVec) :
    ∀ w∈signatureEncoding s,w.magnitude.length≤16 := by
  intro w hw
  obtain ⟨r,rfl⟩:=List.mem_ofFn.mp hw
  rw [encodeSigned_length]

theorem box_magnitude (s : BoxVec) (r : Fin 1536) : (flatInt (decodeVec s) r).natAbs<2^16 := by
  have hb : -65535≤flatInt (decodeVec s) r ∧ flatInt (decodeVec s) r≤65535 := by
    unfold flatInt
    split
    next hr =>
      have hi:=(s ⟨r.val,hr⟩).1.isLt
      dsimp only [decodeVec]
      omega
    next hr =>
      have hi:=(s ⟨r.val-768,by have hh:=r.isLt; omega⟩).2.isLt
      dsimp only [decodeVec]
      omega
  generalize flatInt (decodeVec s) r=z at *
  cases z <;> simp_all <;> omega

theorem signatureEncoding_represents (s : BoxVec) : SignedRepresents (signatureEncoding s) (decodeVec s) := by
  intro i
  rw [loadSigned_correct]
  change signedValue (((List.ofFn _)[exponent i]?.getD zeroSigned))=_
  rw [getD_ofFn _ ⟨exponent i,exponent_lt i⟩,encodeSigned_correct _ _ (box_magnitude s _),flatInt_exponent]

theorem concrete_bit_verifier (h c : Rq) (s : BoxVec) :
    decision (fieldEncoding h) (fieldEncoding c) (signatureEncoding s)=true ↔ Verify h c (decodeVec s) :=
  decision_correct _ _ _ h c (decodeVec s) (fieldEncoding_length h)
    (fieldEncoding_represents h) (fieldEncoding_represents c) (signatureEncoding_represents s)

theorem concrete_bit_verifier_steps (h c : Rq) (s : BoxVec) :
    decisionSteps (fieldEncoding h) (fieldEncoding c) (signatureEncoding s)≤2^66 :=
  decision_bit_steps _ _ _ (fieldEncoding_width h) (fieldEncoding_width c)
    (signatureEncoding_width s) (fieldEncoding_length h).le (fieldEncoding_length c).le
    (signatureEncoding_length s).le

end FT1536.Run2.FileVerifier
