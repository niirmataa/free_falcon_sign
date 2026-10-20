import Source3.KeygenPublicSuffixLoop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- SAME successful public call: source tests derive nonzero original f
   evaluations and source stores derive g/f at the actual inverse-call entry.
   The actual inverse execution is retained, not assumed mathematically correct. -/
namespace FT1536.Source3.KeygenPublicSuccessfulSuffix
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed)
open KeygenPublicInputLoop (Pointers Layout)
open KeygenPublicInputCells (Cells)
open KeygenPublicAlgebra (R)
open KeygenPublicEvaluation (Evaluations)
open KeygenPublicSuffixProgram (pass inverse success complete)
open KeygenPublicSuffixBody (Inv image)
open KeygenPublicCommonCalls (Header)
open FT1536.Run2

def Success (out : Result) : Prop := out.flow=.returned (some (.int32 1))
noncomputable def values (v : Geometry.Vec) (j : Nat) : R :=
  (CoefficientQuotient.polynomial (Relation.reduceVec v)).eval
    (KeygenPublicRoots.point ⟨j%1536,Nat.mod_lt j (by decide)⟩)
def Nonzero (v : Geometry.Vec) : Prop := ∀ i : Fin 1536, values v i.val≠0
def Quotients (heap : Memory) (h : ArrayPointer) (f g : Geometry.Vec) : Prop :=
  Cells heap h 1536 (fun j => values g j*(values f j)⁻¹)
def Run (s : State) (out : Result) (p : Pointers) (f g : Geometry.Vec) : Prop :=
  ∃ beforeInverse afterInverse,
    Exec KeygenPublicSource.program signed pass s ⟨beforeInverse,.normal⟩ ∧
    Header p beforeInverse ∧ Nonzero f ∧ Cells beforeInverse.heap p.t 1536 (values f) ∧
    Quotients beforeInverse.heap p.h f g ∧
    Exec KeygenPublicSource.program signed inverse beforeInverse ⟨afterInverse,.normal⟩ ∧
    Exec KeygenPublicSource.program signed (.seq success .skip) afterInverse out

theorem values_physical (v : Geometry.Vec) (i : Fin 1536) : values v i.val=
    (CoefficientQuotient.polynomial (Relation.reduceVec v)).eval (KeygenPublicRoots.point i) := by
  unfold values
  have index : (⟨i.val%1536,Nat.mod_lt i.val (by decide)⟩ : Fin 1536)=i :=
    Fin.ext (Nat.mod_eq_of_lt i.isLt)
  rw [index]

theorem evaluation_cells (heap : Memory) (p : ArrayPointer) (v : Geometry.Vec)
    (input : Evaluations heap p v) : Cells heap p 1536 (values v) := by
  intro j hj
  rw [values_physical v ⟨j,hj⟩]
  exact input ⟨j,hj⟩

theorem source_success (s : State) (out : Result) (p : Pointers) (f g : Geometry.Vec)
    (layout : Layout p) (header : Header p s)
    (tValues : Evaluations s.heap p.t f) (hValues : Evaluations s.heap p.h g)
    (succeeded : Success out)
    (source : Exec KeygenPublicSource.program signed KeygenPublicInputProgram.suffix s out) : Run s out p f g := by
  rw [KeygenPublicSuffixProgram.source_complete] at source
  cases source with
  | seqNormal _ _ _ beforeInverse _ first last =>
      have result := KeygenPublicSuffixLoop.source_pass s ⟨beforeInverse,.normal⟩ p (values f) (values g)
        layout header (evaluation_cells _ _ f tValues) (evaluation_cells _ _ g hValues) first
      have inv := (result.resolve_left (by intro eq; cases eq)).2
      obtain ⟨afterInverse,inverseExec,returnExec⟩ := KeygenPublicInputCalls.normal_seq_inv inverse (.seq success .skip)
        beforeInverse out (by decide) last
      refine ⟨beforeInverse,afterInverse,first,⟨inv.fixed,inv.profile,inv.ternary,inv.counter⟩,?_,inv.t,?_,inverseExec,returnExec⟩
      · intro i; exact inv.tested i.val i.isLt
      · intro j hj
        simpa only [image,hj,ite_true] using inv.h j hj
  | seqExit _ _ _ _ first exit =>
      have result := KeygenPublicSuffixLoop.source_pass s out p (values f) (values g) layout header
        (evaluation_cells _ _ f tValues) (evaluation_cells _ _ g hValues) first
      have failed := result.resolve_right (fun normal => exit normal.1)
      rw [succeeded] at failed
      cases failed

def Front (s : State) (out : Result) (f g h : ArrayPointer) (fv gv : Geometry.Vec) : Prop :=
  ∃ (block : Nat) (afterT : State) (inner : Result),
    KeygenRngSource.Fresh s.heap block ∧
    KeygenPublicInputLoop.Layout ⟨f,g,KeygenPublicExec.localPointer block 3072,h⟩ ∧
    Header ⟨f,g,KeygenPublicExec.localPointer block 3072,h⟩ afterT ∧
    Evaluations afterT.heap h gv ∧ Evaluations afterT.heap (KeygenPublicExec.localPointer block 3072) fv ∧
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
  obtain ⟨block,afterT,inner,fresh,layout,header,hValues,tValues,suffix,flow,heap⟩ :=
    KeygenPublicCommonMaterial.source_same_material s out f g h fv gv profile ternary arrays legalF legalG legalH
      materialF materialG boundF boundG hf hg liveTables hTables source
  have successInner : Success inner := flow.symm.trans succeeded
  have run := source_success afterT inner ⟨f,g,KeygenPublicExec.localPointer block 3072,h⟩ fv gv
    layout header tValues hValues successInner suffix
  obtain ⟨beforeInverse,afterInverse,first,headerI,nonzero,tc,hc,inv,ret⟩ := run
  exact ⟨block,afterT,inner,fresh,layout,header,hValues,tValues,
    ⟨beforeInverse,afterInverse,first,headerI,nonzero,tc,hc,inv,ret⟩,nonzero,flow,heap⟩

end FT1536.Source3.KeygenPublicSuccessfulSuffix
