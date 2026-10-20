import Source3.KeygenPublicNormalizePolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Final canonical h of the SAME successful compute, including actual
   return syntax and the caller's t disposal. No output image is a premise. -/
namespace FT1536.Source3.KeygenPublicNormalizeMaterial
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed)
open KeygenPublicInputLoop (Pointers)
open KeygenPublicInputCells (Cells)
open KeygenPublicSuccessfulSuffix (Success Nonzero)
open KeygenPublicInverseMaterial (quotients)
open KeygenPublicNormalizeEntry (normalized)
open KeygenPublicNormalizePolynomial (vector Represents)

theorem return_heap (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program signed (.seq KeygenPublicSuffixProgram.success .skip) s out) :
    out.state.heap=s.heap := by
  cases source with
  | seqNormal _ _ _ middle _ returned last => cases returned
  | seqExit _ _ _ _ returned exit => cases returned; rfl

theorem run_output (s : State) (out : Result) (p : Pointers) (f g : Geometry.Vec)
    (run : KeygenPublicRootInverseMaterial.Run s out p f g) :
    Cells out.state.heap p.h 1536 (normalized (quotients f g)) := by
  obtain ⟨before,after,_,_,_,_,_,_,inverse,ret⟩ := run
  have final := (KeygenPublicNormalizeEntry.complete_output (quotients f g) p.h ⟨after,.normal⟩ inverse).2
  rw [return_heap after out ret]
  exact final

def ResultMaterial (out : Result) (p : ArrayPointer) (f g : Geometry.Vec) : Prop :=
  Nonzero f ∧ Represents out.state.heap p (vector (quotients f g)) ∧
    ∀ i : Fin 1536,
      (FT1536.Run2.CoefficientQuotient.polynomial (vector (quotients f g))).eval (KeygenPublicRoots.point i)=
        quotients f g i.val

theorem source_same_material (s : State) (out : Result) (f g h : ArrayPointer) (fv gv : Geometry.Vec)
    (profile : KeygenPublicTableAtoms.Slot s "logn" 10) (ternary : KeygenPublicForwardWrapper.Ternary s)
    (arrays : s.arrays "f".toList=some f ∧ s.arrays "g".toList=some g ∧ s.arrays "h".toList=some h)
    (legalF : KeygenPublicInputMaterial.Legal s.heap f) (legalG : KeygenPublicInputMaterial.Legal s.heap g)
    (legalH : KeygenPublicInputMaterial.Legal s.heap h)
    (materialF : KeygenMaterial.Represents s.heap f fv) (materialG : KeygenMaterial.Represents s.heap g gv)
    (boundF : KeygenIntegerLift.Bound fv 1) (boundG : KeygenIntegerLift.Bound gv 1)
    (hf : h.block≠f.block) (hg : h.block≠g.block) (liveTables : KeygenPublicInputLifetime.LiveTables s)
    (hTables : KeygenPublicFrame.Tables s h.block) (succeeded : Success out)
    (source : Exec KeygenPublicSource.program signed (KeygenPublicSource.code .compute) s out) : ResultMaterial out h fv gv := by
  obtain ⟨block,afterT,inner,_,layout,_,_,_,run,nonzero,_,heap⟩ :=
    KeygenPublicRootInverseMaterial.source_same_material s out f g h fv gv profile ternary arrays legalF legalG legalH
      materialF materialG boundF boundG hf hg liveTables hTables succeeded source
  have cells := run_output afterT inner _ fv gv run
  have disposal := KeygenPublicForwardMemory.disposed_other s.heap inner.state.heap block h.block (Ne.symm layout.different)
  have final : Cells out.state.heap h 1536 (normalized (quotients fv gv)) := by
    rw [heap]; exact KeygenPublicFirstTables.cells_block _ _ h _ _ disposal cells
  exact ⟨nonzero,KeygenPublicNormalizePolynomial.canonical_material _ _ h final,
    KeygenPublicNormalizePolynomial.all_evaluations (quotients fv gv)⟩

end FT1536.Source3.KeygenPublicNormalizeMaterial
