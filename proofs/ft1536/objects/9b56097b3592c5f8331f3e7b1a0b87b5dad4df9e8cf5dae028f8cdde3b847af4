import Source3.StableBinaryCExec
import Source3.StableBinarySourceTyped

/- The byte-memory simulation below is discharged separately by
   SourceProof.byte_interpreter_refinement, not accepted as an axiom or
   hypothesis. The two further types at the end remain UNPROVED. -/
namespace FT1536.Source3.StableBinaryRefinementGoal
open FT1536.Source3

def allowedByte (l : StableBinary.Layout) (q : B20.C.Byte.Pointer) : Prop :=
  q.block=0 ∧
    (StableBinary.inBytes l.values l.length q.offset ∨
      StableBinary.inBytes l.scratch l.length q.offset ∨
      (l.bad≤q.offset ∧ q.offset<l.bad+4))

def byteInterpreterRefinement : Prop :=
  ∀ (l : StableBinary.Layout) (k : Nat) (before : B20.C.Byte.Memory)
    (after : StableBinaryCExec.State),
    l.wellFormed k → StableBinaryByteView.Legal l before →
    StableBinaryCExec.run l k before=some after →
    ∃ typed : StableBinary.State l (StableBinaryByteView.view l before),
      StableBinarySourceTyped.sourceRun l k (StableBinaryByteView.view l before)=some typed ∧
      typed.memory=StableBinaryByteView.view l after.heap ∧
      typed.checks=after.checks ∧
      ∀ q, ¬allowedByte l q → after.heap.contents q=before.contents q

/- Sufficient source-domain obligation, stronger than the helper actually
   needs. Finite probes are not a proof of this universal type. -/
def allPinnedFprWordsDefined : Prop :=
  (∀ x y : BitVec 64, (FprPrimitives.add x y).isSome) ∧
  (∀ x y : BitVec 64, (FprPrimitives.mul x y).isSome) ∧
  (∀ x y : BitVec 64, (FprPrimitives.div x y).isSome)

/- End-to-end no-extra-filter theorem for memory-only legality. `n=1`
   is proved in StableBinaryTotality.base_total; general k is not yet. -/
def allLegalHelpersDefined : Prop :=
  ∀ (l : StableBinary.Layout) (k : Nat) (heap : B20.C.Byte.Memory),
    l.wellFormed k → StableBinaryByteView.Legal l heap →
    (StableBinaryCExec.run l k heap).isSome

end FT1536.Source3.StableBinaryRefinementGoal

#check FT1536.Source3.StableBinaryRefinementGoal.byteInterpreterRefinement
#check FT1536.Source3.StableBinaryRefinementGoal.allPinnedFprWordsDefined
#check FT1536.Source3.StableBinaryRefinementGoal.allLegalHelpersDefined
