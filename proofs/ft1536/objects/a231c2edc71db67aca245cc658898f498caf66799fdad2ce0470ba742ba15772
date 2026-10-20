import Source3.KeygenMkgm3Frame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- B1.03 Acceptance interface. Entry is only the M0 function arguments,
   source-initialized static REV10 and legal caller memory. The initializer
   execution is kept explicit, as in BATCH_016. The whole caller/allocator
   and later NTT evaluation are separate enclosing steps. -/
namespace FT1536.Source3.KeygenMkgm3
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer Memory Load32)
open KeygenSmallOutput (element)

def Entry (s : State) (p0i : BitVec 32) (scratch rev : ArrayPointer) : Prop :=
  KeygenMkgm3Atoms.Params s p0i ∧
  KeygenNttButterflyCalls.U32Slot s "logn" 10 ∧ KeygenNttButterflyCalls.U32Slot s "full" 1 ∧
  KeygenNttButterflyCalls.U32Slot s "g" KeygenFirstPrime.generator ∧
  KeygenMkgm3Frame.Bindings s scratch ∧ s.arrays "REV10".toList=some rev ∧
  KeygenMkgm3RevMemory.SourceTable s.heap rev ∧ KeygenMkgm3Layout.Legal s.heap scratch

def Rows (heap : Memory) (gm : ArrayPointer) : Prop := ∀ i<1024, ∃ word,
  Load32 heap (element gm i) word ∧ word.toNat<KeygenNinv31.prime.toNat ∧
  KeygenNttWordAlgebra.value word=KeygenNttWordAlgebra.radix*
    KeygenMkgm3Rows.root^KeygenMkgm3Indices.tableExponent i ∧
  orderOf (KeygenMkgm3Rows.root^KeygenMkgm3Indices.tableExponent i)=KeygenMkgm3Indices.tableOrder i

def Preserved (before after : Memory) (scratch : ArrayPointer) : Prop :=
  after.size=before.size ∧ after.writable=before.writable ∧
  ∀ block offset, KeygenMkgm3Frame.Outside scratch block offset → after.bytes block offset=before.bytes block offset

def Contract (before : State) (out : Result) (scratch rev : ArrayPointer) : Prop :=
  out.flow=.normal ∧ KeygenMkgm3Table.Initialized out.state.heap (KeygenMkgm3Layout.gm scratch) ∧
  Rows out.state.heap (KeygenMkgm3Layout.gm scratch) ∧ Preserved before.heap out.state.heap scratch ∧
  KeygenMkgm3Layout.Legal out.state.heap scratch ∧ out.state.heap.writable rev.block=false

theorem source_contract (s : State) (out : Result) (p0i : BitVec 32) (scratch rev : ArrayPointer)
    (entry : Entry s p0i scratch rev)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : C99ModularReference.Exec KeygenMkgm3Program.code s out) : Contract s out scratch rev := by
  obtain ⟨params,logn,full,g,bindings,revBinding,staticTable,legal⟩ := entry
  have separate := KeygenMkgm3Layout.table_separation scratch legal.1
  obtain ⟨normal,table⟩ := KeygenMkgm3Assembly.source_table s out p0i (KeygenMkgm3Layout.gm scratch) scratch rev
    params logn full g ⟨bindings.1,bindings.2⟩ revBinding staticTable legal.1 legal.1 separate initialization source
  have steps := KeygenMkgm3RevMemory.memory_steps _ s out source
  have metadata := C99InitializationTrace.steps_preserve _ _ steps
  refine ⟨normal,table,fun i hi => KeygenMkgm3Table.canonical_root _ _ i hi (table i hi),
    ⟨metadata.size,metadata.writable,KeygenMkgm3Frame.outside_bytes _ s out scratch legal.1
      KeygenMkgm3Control.source_supported KeygenMkgm3Frame.source_footprint bindings source⟩,?_,?_⟩
  · simpa only [KeygenMkgm3Layout.Legal,metadata.size,metadata.writable] using legal
  · rw [metadata.writable]
    exact staticTable.1

theorem parsed_contract (program : C99ModularReference.Stmt) (s : State) (out : Result)
    (p0i : BitVec 32) (scratch rev : ArrayPointer)
    (binding : C99ModularParser.region 2945 91=some program)
    (entry : Entry s p0i scratch rev)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : C99ModularReference.Exec program s out) : Contract s out scratch rev := by
  have same : program=KeygenMkgm3Program.code := Option.some.inj (binding.symm.trans KeygenMkgm3Program.source_bound)
  subst program
  exact source_contract s out p0i scratch rev entry initialization source

theorem allocated_tables (s : State) (out : Result) (scratch rev : ArrayPointer)
    (contract : Contract s out scratch rev) :
    (∀ i<1024, C99MemoryReference.Allocated out.state.heap (element (KeygenMkgm3Layout.gm scratch) i)) ∧
    (∀ i<1024, C99MemoryReference.Allocated out.state.heap (element (KeygenMkgm3Layout.igm scratch) i)) ∧
    KeygenMkgm3Layout.DisjointBytes (KeygenMkgm3Layout.gm scratch) 4096 (KeygenMkgm3Layout.igm scratch) 4096 ∧
    (∀ slot : Fin 4, KeygenMkgm3Layout.DisjointBytes (KeygenMkgm3Layout.output scratch slot) 6144
      (KeygenMkgm3Layout.gm scratch) 4096) := by
  have legal := contract.2.2.2.2.1
  exact ⟨fun i hi => KeygenMkgm3Layout.gm_allocated _ scratch legal i hi,
    fun i hi => KeygenMkgm3Layout.allocated_cell _ scratch legal i (by dsimp [KeygenMkgm3Layout.scratchWords]; omega),
    KeygenMkgm3Layout.table_separation scratch legal.1,
    KeygenMkgm3Layout.output_gm_separation scratch legal.1⟩

theorem allocated_outputs (s : State) (out : Result) (scratch rev : ArrayPointer)
    (contract : Contract s out scratch rev) (slot : Fin 4) (i : Nat) (hi : i<1536) :
    C99MemoryReference.Allocated out.state.heap (element (KeygenMkgm3Layout.output scratch slot) i) :=
  KeygenMkgm3Layout.output_allocated _ scratch contract.2.2.2.2.1 slot i hi

theorem output_pairwise (scratch : ArrayPointer) (width : scratch.elementBytes=4)
    (a b : Fin 4) (different : a≠b) :
    KeygenMkgm3Layout.DisjointBytes (KeygenMkgm3Layout.output scratch a) 6144
      (KeygenMkgm3Layout.output scratch b) 6144 := by
  have ne : a.val≠b.val := fun h => different (Fin.ext h)
  simp only [KeygenMkgm3Layout.DisjointBytes,KeygenMkgm3Layout.output,element,
    C99MemoryReference.ArrayPointer.offset,width]
  omega

theorem inverse_prefix (scratch : ArrayPointer) :
    KeygenMkgm3Layout.igm scratch=KeygenMkgm3Layout.output scratch 0 ∧
    (KeygenMkgm3Layout.igm scratch).offset+4096 ≤ (KeygenMkgm3Layout.output scratch 0).offset+6144 := by
  rw [KeygenMkgm3Layout.inverse_alias]
  exact ⟨rfl,by omega⟩

theorem prefix_separate (heap : Memory) (scratch input : ArrayPointer)
    (legal : KeygenMkgm3Layout.Legal heap scratch)
    (separate : KeygenMkgm3Layout.DisjointBytes input 3072 scratch (KeygenMkgm3Frame.objectBytes scratch)) :
    KeygenMkgm3Layout.DisjointBytes input 3072 scratch KeygenMkgm3Layout.scratchBytes := by
  have count := legal.2.2.1
  have bound : KeygenMkgm3Layout.scratchBytes ≤ KeygenMkgm3Frame.objectBytes scratch := by
    dsimp [KeygenMkgm3Frame.objectBytes,KeygenMkgm3Layout.scratchBytes]
    dsimp [KeygenMkgm3Layout.scratchWords] at count
    omega
  dsimp [KeygenMkgm3Layout.DisjointBytes] at *
  omega

theorem source_then_overwrite (s : State) (generated : Result) (p0i : BitVec 32) (scratch rev : ArrayPointer)
    (entry : Entry s p0i scratch rev)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (generation : C99ModularReference.Exec KeygenMkgm3Program.code s generated)
    (arrays : KeygenResidueTrace.Arrays) (conversionEntry : State) (converted : Result)
    (sameHeap : conversionEntry.heap=generated.state.heap)
    (layout : KeygenResidueRanges.Layout arrays scratch)
    (inputWidth : ∀ slot, (arrays.input slot).elementBytes=2)
    (separate : ∀ slot, KeygenMkgm3Layout.DisjointBytes (arrays.input slot) 3072 scratch (KeygenMkgm3Frame.objectBytes scratch))
    (old : Option C99IntegerReference.Value)
    (counter : conversionEntry.locals "u".toList=some (.uint64,old))
    (inputs : KeygenResidueTrace.Inputs arrays conversionEntry)
    (conversion : C99ModularReference.Exec KeygenResidueProgram.code conversionEntry converted)
    (material : Fin 4 → FT1536.Geometry.Vec)
    (represented : ∀ slot, KeygenMaterial.Represents s.heap (arrays.input slot) (material slot)) :
    Rows converted.state.heap (KeygenMkgm3Layout.gm scratch) ∧
    ∀ slot, KeygenMaterial.Represents converted.state.heap (arrays.input slot) (material slot) := by
  have contract := source_contract s generated p0i scratch rev entry initialization generation
  have legal := entry.2.2.2.2.2.2.2
  have table : KeygenMkgm3Table.Initialized conversionEntry.heap (KeygenMkgm3Layout.gm scratch) := by
    rw [sameHeap]; exact contract.2.1
  have finalTable := KeygenMkgm3Table.overwritten_table arrays scratch layout conversionEntry old converted counter inputs table conversion
  refine ⟨fun i hi => KeygenMkgm3Table.canonical_root _ _ i hi (finalTable i hi),?_⟩
  have isolated := KeygenMkgm3Layout.input_separation arrays scratch layout
    (fun slot => prefix_separate s.heap scratch (arrays.input slot) legal (separate slot)) inputWidth
  have trace := (KeygenResidueLoop.source_trace arrays conversionEntry old converted counter inputs conversion).2.2.2
  intro slot
  have afterGen := KeygenMkgm3Frame.source_material s generated scratch (arrays.input slot) legal.1
    (by have := legal.2.2.1; omega) (inputWidth slot) entry.2.2.2.2.1 (separate slot) (material slot) (represented slot) generation
  have beforeConversion : KeygenMaterial.Represents conversionEntry.heap (arrays.input slot) (material slot) := by
    rw [sameHeap]; exact afterGen
  intro i
  constructor
  · intro byte
    rw [KeygenResidueFrame.trace_input_bytes arrays isolated 0 i.val _ _ trace (by have := i.isLt; omega) slot byte]
    exact (beforeConversion i).1 byte
  · intro byte
    rw [KeygenResidueFrame.trace_input_bytes arrays isolated 0 (i.val+768) _ _ trace (by have := i.isLt; omega) slot byte]
    exact (beforeConversion i).2 byte

end FT1536.Source3.KeygenMkgm3
