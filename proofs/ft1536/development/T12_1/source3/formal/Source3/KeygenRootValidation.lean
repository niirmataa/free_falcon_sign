import Source3.KeygenRootValidationSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Derive every legacy Validation field from the actual root suffix.
   The input record contains caller slots and legal source objects only;
   there is no generated table, NTT image, equation or Validation premise. -/
namespace FT1536.Source3.KeygenRootValidation
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99MemoryReference
open KeygenSearchContext (Context)
open KeygenRootValidationSource

def arrays (input : Fin 4 → ArrayPointer) (root : ArrayPointer) : KeygenResidueTrace.Arrays :=
  ⟨input,KeygenMkgm3Layout.output root⟩
structure Entry (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer) : Prop where
  logn : KeygenNttForwardExec.lognAt s
  size : C99CountedWords.Limit s
  counter : s.locals "u".toList=some (.uint64,none)
  target : s.locals "r".toList=some (.uint32,none)
  inputs : ∀ slot, s.arrays (KeygenResidueTrace.names slot).2.toList=some (input slot)
  table : s.arrays "PRIMES3".toList=some primes
  primeObject : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  legal : KeygenMkgm3Layout.Legal s.heap ctx.scratch
  width : ∀ slot, (input slot).elementBytes=2
  separate : ∀ slot, KeygenMkgm3Layout.DisjointBytes (input slot) 3072 ctx.scratch (KeygenMkgm3Frame.objectBytes ctx.scratch)

theorem ready_inputs (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (entry : Entry ctx s input primes rev) (p0i : BitVec 32) :
    KeygenResidueTrace.Inputs (arrays input ctx.scratch) (ready s ctx.scratch primes p0i) := by
  refine ⟨?_,?_,rfl,entry.size⟩
  · intro slot
    fin_cases slot <;> exact entry.inputs _
  · intro slot
    fin_cases slot <;> rfl
theorem ready_caller (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (entry : Entry ctx s input primes rev) (p0i : BitVec 32) :
    KeygenSolverNttCalls.Caller (ready s ctx.scratch primes p0i) p0i (KeygenMkgm3Layout.gm ctx.scratch) := by
  refine ⟨entry.logn,rfl,?_,rfl⟩
  change some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 p0i).integer))=_
  rw [uint32_cast]
theorem validation (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (entry : Entry ctx before input primes rev) (source : Exec ctx before out)
    (success : out.flow=.returned (some (.int32 1))) :
    ∃ v : KeygenOutputGateValidation.Validation (arrays input ctx.scratch), v.start.heap=before.heap ∧ v.out=out := by
  cases source with
  | run prepared genEntry generated converted transformed out genTernary nttTernary preparation genMember genNonzero binding generation genReturn conversion convNormal nttMember nttNonzero transforms check =>
    obtain ⟨p0i,state,inverse⟩ := KeygenRootValidationSource.prepared ctx before prepared primes entry.size entry.table entry.primeObject preparation
    subst prepared
    have bound := generator_entry before genEntry ctx.scratch primes rev p0i entry.logn entry.primeObject
      entry.revBinding entry.revSource entry.legal binding
    have heap := KeygenLevelCalls.bind_heap _ _ _ _ binding
    have inputs := ready_inputs ctx before input primes rev entry p0i
    have caller := ready_caller ctx before input primes rev entry p0i
    let v : KeygenOutputGateValidation.Validation (arrays input ctx.scratch) := {
      start := genEntry
      generated := generated
      scratch := ctx.scratch
      rev := rev
      p0i := p0i
      generationEntry := bound
      initialization := inverse
      generation := generation
      conversionEntry := returned (ready before ctx.scratch primes p0i) generated
      converted := converted
      sameGenerationHeap := rfl
      layout := ⟨entry.legal.1,fun _ => rfl⟩
      inputWidth := entry.width
      separate := entry.separate
      old := none
      counter := entry.counter
      inputs := ⟨inputs.input,inputs.output,inputs.prime,inputs.size⟩
      caller := ⟨caller.logn,caller.prime,caller.inverse,caller.table⟩
      declared := ⟨none,entry.target⟩
      conversion := conversion
      transformed := transformed
      out := out
      transforms := transforms
      validation := check
      success := success }
    exact ⟨v,heap,rfl⟩
theorem checked (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (entry : Entry ctx before input primes rev) (source : Exec ctx before out)
    (success : out.flow=.returned (some (.int32 1))) (material : Fin 4 → Geometry.Vec)
    (represented : ∀ slot, KeygenMaterial.Represents before.heap (input slot) (material slot))
    (bounded : KeygenSolverEquation.Bounds material) :
    KeygenSolverEquation.Equation material ∧ ∀ slot, KeygenMaterial.Represents out.state.heap (input slot) (material slot) := by
  obtain ⟨v,heap,result⟩ := validation ctx before out input primes rev entry source success
  have checked := KeygenOutputGateValidation.checked (arrays input ctx.scratch) v material
    (by intro slot; rw [heap]; exact represented slot) bounded
  rw [result] at checked
  exact checked

end FT1536.Source3.KeygenRootValidation
