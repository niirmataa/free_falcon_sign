import Run2.PolynomialMachine
import Run2.TableMachine

namespace FT1536.Run2.ReferenceFinish
open Games FT1536.Relation PublicSimulation

/- Executable reference arithmetic. Its bit implementation is supplied by
PolynomialMachine and Scalar/NormMachine; no polynomial remainder oracle
is evaluated by this function. -/
def extract (h c : Rq) (s : Geometry.Vec) : Geometry.Vec × Geometry.Vec :=
  (centerRq (c-PolynomialReference.multiply h (reduceVec s)),s)

def verify (h c : Rq) (s : Geometry.Vec) : Bool := by
  letI : Decidable (Relation.signed16 s) := by unfold Relation.signed16; infer_instance
  exact decide (Relation.signed16 s ∧ Geometry.Q (extract h c s)<Geometry.B)

theorem extract_correct (h c : Rq) (s : Geometry.Vec) : extract h c s=Relation.extract h c s := by
  simp only [extract,Relation.extract,PolynomialReference.multiply_correct]

theorem verify_correct (h c : Rq) (s : Geometry.Vec) :
    verify h c s=true ↔ Verify h c s := by
  simp only [verify,decide_eq_true_eq,Verify,extract_correct]

def finish (h : Rq) (cs : List Rq) : Option Finished → Option Witness
  | none => none
  | some f =>
      if (TableMachine.seen f.forgery.message f.state.table.seen).1 ||
          decide (f.forgery.nonce.length≠40) then none
      else match (TableMachine.hash cs (f.forgery.nonce++f.forgery.message) f.state).1 with
      | none => none
      | some co => if verify h co.1 (decodeVec f.forgery.signature) then
          match (TableMachine.lookup (parse (f.forgery.nonce++f.forgery.message)) co.2.table.table).1 with
          | none => none
          | some e => e.target.map fun j => (j,extract h co.1 (decodeVec f.forgery.signature))
        else none

theorem finish_correct (h : Rq) (cs : List Rq) (f : Option Finished) :
    finish h cs f=finishSim h cs f := by
  classical
  cases f with
  | none => rfl
  | some f =>
    simp only [finish,finishSim,TableMachine.seen_correct,TableMachine.hash_correct,
      TableMachine.lookup_correct,verify_correct,extract_correct,accepted,Bool.or_eq_true,
      decide_eq_true_eq]
    congr 1

end FT1536.Run2.ReferenceFinish
