import Source3.KeygenNttPolynomial
import Source3.KeygenMkgm3

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The first-pass seam consumes table generation and conversion executions.
   Only caller memory/material and cross-call bindings are premises. The
   enclosing whole-NTT/caller derivation still has to supply these fragments. -/
namespace FT1536.Source3.KeygenNttFirstComposition
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)

structure Entry (s : State) (p gm : ArrayPointer) (p0i : BitVec 32) : Prop where
  logn : KeygenNttForwardExec.lognAt s
  full : KeygenNttForwardExec.fullAt s
  prime : KeygenNttButterflyCalls.U32Slot s "p" KeygenNinv31.prime
  inverse : KeygenNttButterflyCalls.U32Slot s "p0i" p0i
  stride : KeygenNttLoopSupport.USlot s "stride" 1
  array : KeygenNttLoopSupport.PSlot s "a" p
  table : KeygenNttLoopSupport.PSlot s "gm" gm

def Contract (before after : Memory) (p gm : ArrayPointer) (v : Geometry.Vec) : Prop :=
  KeygenNttPolynomial.FirstImage after p v ∧ KeygenNttPolynomial.RemainderImage after p v ∧
  KeygenMkgm3Table.Initialized after gm ∧ KeygenNttFirstValues.Frame before after p

theorem table_preserved (before after : Memory) (p gm : ArrayPointer)
    (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (table : KeygenMkgm3Table.Initialized before gm) (frame : KeygenNttFirstValues.Frame before after p) :
    KeygenMkgm3Table.Initialized after gm := by
  intro j hj
  obtain ⟨w,read,range,law⟩ := table j hj
  have outside : KeygenNttFirstValues.Outside p (element gm j) := by
    intro i hi
    unfold KeygenNttCells.Separate KeygenMkgm3Layout.DisjointBytes at *
    simp only [element,ArrayPointer.offset,pw,gw] at *
    omega
  obtain ⟨word,loaded,canonical,scaled⟩ := frame (element gm j) _ outside ⟨w,read,range,law⟩
  exact ⟨word,loaded,canonical,scaled⟩

theorem source_prefix (before ready : State) (out : Result) (p gm : ArrayPointer)
    (v : Geometry.Vec) (p0i : BitVec 32) (entry : Entry before p gm p0i)
    (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (input : KeygenResidueVectors.Represents before.heap p v)
    (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (prologue : Exec KeygenNttForwardPrograms.prologue before ⟨ready,.normal⟩)
    (firstPass : Exec KeygenNttForwardPrograms.firstPass ready out) :
    out.flow=.normal ∧ Contract before.heap out.state.heap p gm v := by
  have he := KeygenNttForwardExec.prologue_result before ⟨ready,.normal⟩ entry.logn entry.full prologue
  have hs := congrArg Result.state he
  dsimp only at hs
  subst ready
  obtain ⟨flow,image,frame⟩ := KeygenNttPolynomial.source_first_pass (KeygenNttForwardExec.ready before) out p gm v p0i pw
    ⟨none,rfl⟩ entry.prime entry.inverse entry.stride
    (by
      change (KeygenNttForwardExec.ready before).locals "hn".toList=some (.uint64,some (.uint64 768))
      exact KeygenNttForwardExec.ready_hn_slot before)
    ⟨none,rfl⟩ entry.array entry.table input table initialization firstPass
  exact ⟨flow,image,KeygenNttPolynomial.image_remainders _ p v image,
    table_preserved before.heap out.state.heap p gm pw gw separate table frame,frame⟩

/- Composition with the BATCH_017 generator and the actual igm=ft overwrite.
   No canonical-array or initialized-gm predicate is a premise here. -/
theorem generated_converted_prefix (s : State) (generated : Result)
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
    (slot : Fin 4) (nttEntry ready : State) (out : Result)
    (sameConversionHeap : nttEntry.heap=converted.state.heap)
    (nttArgs : Entry nttEntry (arrays.output slot) (KeygenMkgm3Layout.gm scratch) p0i)
    (prologue : Exec KeygenNttForwardPrograms.prologue nttEntry ⟨ready,.normal⟩)
    (firstPass : Exec KeygenNttForwardPrograms.firstPass ready out) :
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
  exact source_prefix nttEntry ready out _ _ (material slot) p0i nttArgs pw legal.1 sg
    (by rw [sameConversionHeap]; exact vectors slot)
    (by rw [sameConversionHeap]; exact convertedTable) initialization prologue firstPass

end FT1536.Source3.KeygenNttFirstComposition
