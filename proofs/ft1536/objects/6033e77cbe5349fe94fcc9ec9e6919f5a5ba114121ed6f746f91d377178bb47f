import Source3.KeygenPublicReverseCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- SAME successful compute through all actual reverse stages. The final
   h image, first-root/normalization correctness and equations are not assumed. -/
namespace FT1536.Source3.KeygenPublicReverseMaterial
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed)
open KeygenPublicInputLoop (Pointers)
open KeygenPublicInputCells (Cells)
open KeygenPublicCommonCalls (Header)
open KeygenPublicSuccessfulSuffix (Success Nonzero values Quotients)
open KeygenPublicInverseMaterial (quotients)

def Run (s : State) (out : Result) (p : Pointers) (f g : Geometry.Vec) : Prop :=
  ∃ beforeInverse afterInverse,
    Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.pass s ⟨beforeInverse,.normal⟩ ∧
    Header p beforeInverse ∧ Nonzero f ∧ Cells beforeInverse.heap p.t 1536 (values f) ∧
    Quotients beforeInverse.heap p.h f g ∧
    Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.inverse beforeInverse ⟨afterInverse,.normal⟩ ∧
    KeygenPublicReverseInvocation.Outcome (quotients f g) p.h ⟨afterInverse,.normal⟩ ∧
    Exec KeygenPublicSource.program signed (.seq KeygenPublicSuffixProgram.success .skip) afterInverse out
theorem refine_run (s : State) (out : Result) (p : Pointers) (f g : Geometry.Vec)
    (source : KeygenPublicSuccessfulSuffix.Run s out p f g) : Run s out p f g := by
  obtain ⟨before,after,pass,header,nonzero,tc,hc,inverse,ret⟩ := source
  exact ⟨before,after,pass,header,nonzero,tc,hc,inverse,
    KeygenPublicReverseCalls.source_public_call (quotients f g) before ⟨after,.normal⟩ p.h
      header.profile header.ternary header.fixed.h hc inverse,ret⟩

def Front (s : State) (out : Result) (f g h : ArrayPointer) (fv gv : Geometry.Vec) : Prop :=
  ∃ (block : Nat) (afterT : State) (inner : Result),
    KeygenRngSource.Fresh s.heap block ∧
    KeygenPublicInputLoop.Layout ⟨f,g,KeygenPublicExec.localPointer block 3072,h⟩ ∧
    Header ⟨f,g,KeygenPublicExec.localPointer block 3072,h⟩ afterT ∧
    KeygenPublicEvaluation.Evaluations afterT.heap h gv ∧
    KeygenPublicEvaluation.Evaluations afterT.heap (KeygenPublicExec.localPointer block 3072) fv ∧
    Run afterT inner ⟨f,g,KeygenPublicExec.localPointer block 3072,h⟩ fv gv ∧
    Nonzero fv ∧ out.flow=inner.flow ∧ out.state.heap=KeygenRngSource.disposed s.heap inner.state.heap block

theorem source_same_material (s : State) (out : Result) (f g h : ArrayPointer) (fv gv : Geometry.Vec)
    (profile : KeygenPublicTableAtoms.Slot s "logn" 10) (ternary : KeygenPublicForwardWrapper.Ternary s)
    (arrays : s.arrays "f".toList=some f ∧ s.arrays "g".toList=some g ∧ s.arrays "h".toList=some h)
    (legalF : KeygenPublicInputMaterial.Legal s.heap f) (legalG : KeygenPublicInputMaterial.Legal s.heap g)
    (legalH : KeygenPublicInputMaterial.Legal s.heap h)
    (materialF : KeygenMaterial.Represents s.heap f fv) (materialG : KeygenMaterial.Represents s.heap g gv)
    (boundF : KeygenIntegerLift.Bound fv 1) (boundG : KeygenIntegerLift.Bound gv 1)
    (hf : h.block≠f.block) (hg : h.block≠g.block) (liveTables : KeygenPublicInputLifetime.LiveTables s)
    (hTables : KeygenPublicFrame.Tables s h.block) (succeeded : Success out)
    (source : Exec KeygenPublicSource.program signed (KeygenPublicSource.code .compute) s out) : Front s out f g h fv gv := by
  obtain ⟨block,afterT,inner,fresh,layout,header,hValues,tValues,run,nonzero,flow,heap⟩ :=
    KeygenPublicSuccessfulSuffix.source_same_material s out f g h fv gv profile ternary arrays legalF legalG legalH
      materialF materialG boundF boundG hf hg liveTables hTables succeeded source
  exact ⟨block,afterT,inner,fresh,layout,header,hValues,tValues,refine_run afterT inner _ fv gv run,nonzero,flow,heap⟩

end FT1536.Source3.KeygenPublicReverseMaterial
