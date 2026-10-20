import Source3.KeygenOutputGateBounds
import Source3.KeygenSolverValidation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The source output gate feeds the existing common-memory NTRU validation.
   This is a local suffix theorem: f/g material and Bound1 must arrive from
   the sampler THROUGH the still-open search/caller frame. The Validation
   record exposes the inherited legal/source entry and execution premises;
   it contains no equation, transform image or output-bound hypothesis. -/
namespace FT1536.Source3.KeygenOutputGateValidation
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)

structure Validation (arrays : KeygenResidueTrace.Arrays) where
  start : State
  generated : Result
  scratch : ArrayPointer
  rev : ArrayPointer
  p0i : BitVec 32
  generationEntry : KeygenMkgm3.Entry start p0i scratch rev
  initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i)
  generation : C99ModularReference.Exec KeygenMkgm3Program.code start generated
  conversionEntry : State
  converted : Result
  sameGenerationHeap : conversionEntry.heap=generated.state.heap
  layout : KeygenResidueRanges.Layout arrays scratch
  inputWidth : ∀ slot, (arrays.input slot).elementBytes=2
  separate : ∀ slot, KeygenMkgm3Layout.DisjointBytes (arrays.input slot) 3072 scratch
    (KeygenMkgm3Frame.objectBytes scratch)
  old : Option C99IntegerReference.Value
  counter : conversionEntry.locals "u".toList=some (.uint64,old)
  inputs : KeygenResidueTrace.Inputs arrays conversionEntry
  caller : KeygenSolverNttCalls.Caller conversionEntry p0i (KeygenMkgm3Layout.gm scratch)
  declared : KeygenNttButterflyCalls.U32Declared conversionEntry "r"
  conversion : C99ModularReference.Exec KeygenResidueProgram.code conversionEntry converted
  transformed : State
  out : Result
  transforms : KeygenSolverNttCalls.Exec KeygenSolverNttCalls.code converted.state transformed
  validation : C99ModularReference.Exec KeygenSolverTarget.code transformed out
  success : out.flow=.returned (some (.int32 1))

theorem checked (arrays : KeygenResidueTrace.Arrays) (source : Validation arrays) (v : Fin 4 → Geometry.Vec)
    (represented : ∀ slot, KeygenMaterial.Represents source.start.heap (arrays.input slot) (v slot))
    (bounded : KeygenSolverEquation.Bounds v) : KeygenSolverEquation.Equation v ∧
    ∀ slot, KeygenMaterial.Represents source.out.state.heap (arrays.input slot) (v slot) :=
  KeygenSolverValidation.generated_converted_checked source.start source.generated source.scratch source.rev source.p0i
    source.generationEntry source.initialization source.generation arrays source.conversionEntry source.converted
    source.sameGenerationHeap source.layout source.inputWidth source.separate source.old source.counter source.inputs
    source.caller source.declared source.conversion v represented bounded source.transformed source.out
    source.transforms source.validation source.success

def material (f g F G : Geometry.Vec) : Fin 4 → Geometry.Vec := ![f,g,F,G]

theorem gate_validated (ctx : KeygenOutputGateSource.Context) (before : State) (gateOut : Result)
    (arrays : KeygenResidueTrace.Arrays) (m0 : ctx.ternary=1)
    (caller : KeygenOutputGateBounds.Caller before (arrays.input 2) (arrays.input 3))
    (disjoint : ∀ a b : Fin 4, a≠b → KeygenMkgm3Layout.DisjointBytes (arrays.input a) 3072 (arrays.input b) 3072)
    (f g : Geometry.Vec)
    (fRepr : KeygenMaterial.Represents before.heap (arrays.input 0) f)
    (gRepr : KeygenMaterial.Represents before.heap (arrays.input 1) g)
    (fBound : KeygenIntegerLift.Bound f 1) (gBound : KeygenIntegerLift.Bound g 1)
    (gate : KeygenOutputGateSource.Exec ctx before gateOut) (passed : gateOut.flow=.normal)
    (validation : Validation arrays) (sameHeap : validation.start.heap=gateOut.state.heap) :
    ∃ F G : Geometry.Vec, KeygenSolverEquation.Bounds (material f g F G) ∧
      KeygenSolverEquation.Equation (material f g F G) ∧
      ∀ slot, KeygenMaterial.Represents validation.out.state.heap (arrays.input slot) (material f g F G slot) := by
  obtain ⟨F,G,reprF,boundF,reprG,boundG⟩ := KeygenOutputGateBounds.gate_material ctx before gateOut
    (arrays.input 2) (arrays.input 3) m0 caller (validation.inputWidth 2) (validation.inputWidth 3)
    (disjoint 3 2 (by decide)) gate passed
  have smallF := KeygenOutputGateBounds.gate_preserves ctx before gateOut (arrays.input 2) (arrays.input 3)
    (arrays.input 0) m0 caller (validation.inputWidth 2) (validation.inputWidth 3) (validation.inputWidth 0)
    (disjoint 2 0 (by decide)) (disjoint 3 0 (by decide)) f fRepr gate passed
  have smallG := KeygenOutputGateBounds.gate_preserves ctx before gateOut (arrays.input 2) (arrays.input 3)
    (arrays.input 1) m0 caller (validation.inputWidth 2) (validation.inputWidth 3) (validation.inputWidth 1)
    (disjoint 2 1 (by decide)) (disjoint 3 1 (by decide)) g gRepr gate passed
  have represented : ∀ slot, KeygenMaterial.Represents validation.start.heap (arrays.input slot) (material f g F G slot) := by
    intro slot
    rw [sameHeap]
    fin_cases slot
    · exact smallF
    · exact smallG
    · exact reprF
    · exact reprG
  have bounded : KeygenSolverEquation.Bounds (material f g F G) := ⟨fBound,gBound,boundF,boundG⟩
  exact ⟨F,G,bounded,checked arrays validation (material f g F G) represented bounded⟩

end FT1536.Source3.KeygenOutputGateValidation
