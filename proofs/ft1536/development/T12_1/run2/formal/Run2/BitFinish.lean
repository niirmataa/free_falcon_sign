import Run2.VerifierInputs
import Run2.TableMachine

namespace FT1536.Run2.BitFinish
open Games FT1536.Relation PublicSimulation BitArithmetic FileArithmetic FileVerifier

/- Mathematical decoding of an output file, used only in the semantic view
of the physical file program. -/
def decodeWords (xs : List SignedWord) : Geometry.Vec := fun i =>
  (signedValue (loadSigned xs i.val).word,signedValue (loadSigned xs (i.val+768)).word)

theorem decodeWords_correct (xs : List SignedWord) (s : Geometry.Vec) (h : SignedRepresents xs s) :
    decodeWords xs=s := by
  funext i
  exact Prod.ext (represents_first xs s h i) (represents_second xs s h i)

def accepted (h c : Rq) (f : Forgery) : Bool :=
  decision (fieldEncoding h) (fieldEncoding c) (signatureEncoding f.signature)

theorem accepted_correct (h c : Rq) (f : Forgery) :
    accepted h c f=true ↔ Verify h c (decodeVec f.signature) :=
  concrete_bit_verifier h c f.signature

def extract (h c : Rq) (s : BoxVec) : Geometry.Vec × Geometry.Vec :=
  (decodeWords (residual (fieldEncoding h) (fieldEncoding c) (signatureEncoding s)),
   decodeWords (signatureEncoding s))

theorem extract_correct (h c : Rq) (s : BoxVec) :
    extract h c s=Relation.extract h c (decodeVec s) := by
  have hs:=signatureEncoding_represents s
  have hr:=residual_represents (fieldEncoding h) (fieldEncoding c) (signatureEncoding s)
    h c (decodeVec s) (fieldEncoding_length h) (fieldEncoding_represents h) (fieldEncoding_represents c) hs
  exact Prod.ext (decodeWords_correct _ _ hr) (decodeWords_correct _ _ hs)

def finish (h : Rq) (cs : List Rq) : Option Finished → Option Witness
  | none => none
  | some f =>
      if (TableMachine.seen f.forgery.message f.state.table.seen).1 ||
          decide (f.forgery.nonce.length≠40) then none
      else match (TableMachine.hash cs (f.forgery.nonce++f.forgery.message) f.state).1 with
      | none => none
      | some co => if accepted h co.1 f.forgery then
          match (TableMachine.lookup (parse (f.forgery.nonce++f.forgery.message)) co.2.table.table).1 with
          | none => none
          | some e => e.target.map fun j => (j,extract h co.1 f.forgery.signature)
        else none

theorem finish_correct (h : Rq) (cs : List Rq) (f : Option Finished) :
    finish h cs f=finishSim h cs f := by
  classical
  cases f with
  | none => rfl
  | some f =>
    simp only [finish,finishSim,TableMachine.seen_correct,TableMachine.hash_correct,
      TableMachine.lookup_correct,accepted_correct,extract_correct,Games.accepted,Bool.or_eq_true,
      decide_eq_true_eq]
    congr 1

end FT1536.Run2.BitFinish
