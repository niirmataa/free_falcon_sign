import Source3.KeygenNttRoundPolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- B1.04: canonical range and original-polynomial evaluation are conclusions
   about every cell of the same complete parsed forward NTT execution. -/
namespace FT1536.Source3.KeygenNttTransform
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttFirstComposition (Entry)
open FT1536.Run2

def Image (heap : Memory) (p : ArrayPointer) (v : Geometry.Vec) : Prop :=
  ∀ i : Fin 1536, ∃ word, Load32 heap (element p i.val) word ∧
    KeygenNttButterflyAlgebra.Canonical word ∧
    KeygenNttWordAlgebra.value word=(CoefficientQuotient.polynomial (KeygenNttPolynomial.castVec v)).eval
      (KeygenNttRoots.point i)

def Contract (before after : Memory) (p gm : ArrayPointer) (v : Geometry.Vec) : Prop :=
  Image after p v ∧ KeygenMkgm3Table.Initialized after gm ∧ KeygenNttFirstValues.Frame before after p

theorem source_transform (before : State) (out : Result) (p gm : ArrayPointer) (v : Geometry.Vec) (p0i : BitVec 32)
    (entry : Entry before p gm p0i) (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (input : KeygenResidueVectors.Represents before.heap p v) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.forwardBody before out) :
    out.flow=.normal ∧ Contract before.heap out.state.heap p gm v := by
  obtain ⟨flow,cells,tableOut,frame⟩ := KeygenNttExecution.source_values before out p gm p0i _ entry pw gw separate
    (KeygenNttPolynomial.converted_cells before.heap p v input) table initialization source
  refine ⟨flow,?_,tableOut,frame⟩
  intro i
  have cell := cells i.val i.isLt
  rw [KeygenNttRoundPolynomial.transform_evaluation (KeygenNttPolynomial.castVec v) i] at cell
  exact cell

/- This composition derives canonical inputs and initialized gm from their
   preceding source executions. Caller memory/profile and cross-call State
   bindings remain explicit; no desired transform result is a premise. -/
theorem generated_converted_transform (s : State) (generated : Result)
    (scratch rev : ArrayPointer) (p0i : BitVec 32)
    (generationEntry : KeygenMkgm3.Entry s p0i scratch rev)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (generation : Exec KeygenMkgm3Program.code s generated)
    (arrays : KeygenResidueTrace.Arrays) (conversionEntry : State) (converted : Result)
    (sameGenerationHeap : conversionEntry.heap=generated.state.heap)
    (layout : KeygenResidueRanges.Layout arrays scratch)
    (inputWidth : ∀ slot, (arrays.input slot).elementBytes=2)
    (separate : ∀ slot, KeygenMkgm3Layout.DisjointBytes (arrays.input slot) 3072 scratch
      (KeygenMkgm3Frame.objectBytes scratch))
    (old : Option C99IntegerReference.Value)
    (counter : conversionEntry.locals "u".toList=some (.uint64,old))
    (inputs : KeygenResidueTrace.Inputs arrays conversionEntry)
    (conversion : Exec KeygenResidueProgram.code conversionEntry converted)
    (material : Fin 4 → Geometry.Vec)
    (represented : ∀ slot, KeygenMaterial.Represents s.heap (arrays.input slot) (material slot))
    (bounded : ∀ slot, KeygenIntegerLift.Bound (material slot) 2047)
    (slot : Fin 4) (nttEntry : State) (out : Result)
    (sameConversionHeap : nttEntry.heap=converted.state.heap)
    (nttArgs : Entry nttEntry (arrays.output slot) (KeygenMkgm3Layout.gm scratch) p0i)
    (transform : Exec KeygenNttForwardPrograms.forwardBody nttEntry out) :
    out.flow=.normal ∧ Contract nttEntry.heap out.state.heap (arrays.output slot)
      (KeygenMkgm3Layout.gm scratch) (material slot) := by
  have gen := KeygenMkgm3.source_contract s generated p0i scratch rev generationEntry initialization generation
  have legal := generationEntry.2.2.2.2.2.2.2
  have table : KeygenMkgm3Table.Initialized conversionEntry.heap (KeygenMkgm3Layout.gm scratch) := by
    rw [sameGenerationHeap]
    exact gen.2.1
  have convertedTable := KeygenMkgm3Table.overwritten_table arrays scratch layout conversionEntry old converted
    counter inputs table conversion
  have materialBefore (which : Fin 4) : KeygenMaterial.Represents conversionEntry.heap
      (arrays.input which) (material which) := by
    rw [sameGenerationHeap]
    exact KeygenMkgm3Frame.source_material s generated scratch (arrays.input which) legal.1
      (by have := legal.2.2.1; omega) (inputWidth which) generationEntry.2.2.2.2.1
      (separate which) (material which) (represented which) generation
  have isolated := KeygenMkgm3Layout.input_separation arrays scratch layout
    (fun which => KeygenMkgm3.prefix_separate s.heap scratch (arrays.input which) legal (separate which)) inputWidth
  have vectors := KeygenResidueVectors.source_vectors arrays scratch layout isolated conversionEntry old converted
    counter inputs material materialBefore bounded conversion
  have ptr : arrays.output slot=KeygenMkgm3Layout.output scratch slot := layout.2 slot
  have pw : (arrays.output slot).elementBytes=4 := by rw [ptr]; exact legal.1
  have sg : KeygenMkgm3Layout.DisjointBytes (arrays.output slot) 6144 (KeygenMkgm3Layout.gm scratch) 4096 := by
    rw [ptr]
    exact KeygenMkgm3Layout.output_gm_separation scratch legal.1 slot
  exact source_transform nttEntry out _ _ (material slot) p0i nttArgs pw legal.1 sg
    (by rw [sameConversionHeap]; exact vectors slot)
    (by rw [sameConversionHeap]; exact convertedTable) initialization transform

end FT1536.Source3.KeygenNttTransform
