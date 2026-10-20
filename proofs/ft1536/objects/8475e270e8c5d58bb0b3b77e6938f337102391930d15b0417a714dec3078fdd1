import Source3.KeygenPublicParameterFrames

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- B1.06 acceptance: BOTH equations, actual final canonical h, and the SAME
   original f/g bytes retained by this successful public invocation. No
   correctness, invertibility, round-trip or equation premise is introduced. -/
namespace FT1536.Source3.KeygenPublicAccepted
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed)
open KeygenPublicSuccessfulSuffix (Success Nonzero)
open KeygenPublicEquations (publicVector fInverse)
open FT1536.Run2.CoefficientQuotient (constantCoeffs)

def Material (out : Result) (f g h : ArrayPointer) (fv gv : Geometry.Vec) : Prop :=
  KeygenMaterial.Represents out.state.heap f fv ∧ KeygenMaterial.Represents out.state.heap g gv ∧
  ∃ hv fInv : Relation.Rq,
    KeygenPublicNormalizePolynomial.Represents out.state.heap h hv ∧ Nonzero fv ∧
    Relation.mulRq hv (Relation.reduceVec fv)=Relation.reduceVec gv ∧
    Relation.mulRq fInv (Relation.reduceVec fv)=constantCoeffs (1 : KeygenPublicAlgebra.R)

theorem source_same_material (s : State) (out : Result) (f g h : ArrayPointer) (fv gv : Geometry.Vec)
    (profile : KeygenPublicTableAtoms.Slot s "logn" 10) (ternary : KeygenPublicForwardWrapper.Ternary s)
    (arrays : s.arrays "f".toList=some f ∧ s.arrays "g".toList=some g ∧ s.arrays "h".toList=some h)
    (legalF : KeygenPublicInputMaterial.Legal s.heap f) (legalG : KeygenPublicInputMaterial.Legal s.heap g)
    (legalH : KeygenPublicInputMaterial.Legal s.heap h)
    (materialF : KeygenMaterial.Represents s.heap f fv) (materialG : KeygenMaterial.Represents s.heap g gv)
    (boundF : KeygenIntegerLift.Bound fv 1) (boundG : KeygenIntegerLift.Bound gv 1)
    (hf : h.block≠f.block) (hg : h.block≠g.block) (liveTables : KeygenPublicInputLifetime.LiveTables s)
    (hTables : KeygenPublicFrame.Tables s h.block) (succeeded : Success out)
    (source : Exec KeygenPublicSource.program signed (KeygenPublicSource.code .compute) s out) : Material out f g h fv gv := by
  obtain ⟨nonzero,canonical,_⟩ := KeygenPublicNormalizeMaterial.source_same_material s out f g h fv gv
    profile ternary arrays legalF legalG legalH materialF materialG boundF boundG hf hg liveTables hTables succeeded source
  obtain ⟨publicEq,inverseEq⟩ := KeygenPublicEquations.both_equations fv gv nonzero
  exact ⟨KeygenPublicParameterFrames.source_input s out h f fv arrays.2.2 hf legalF materialF source,
    KeygenPublicParameterFrames.source_input s out h g gv arrays.2.2 hg legalG materialG source,
    publicVector fv gv,fInverse fv,canonical,nonzero,publicEq,inverseEq⟩

end FT1536.Source3.KeygenPublicAccepted
