import Source3.KeygenMakeCertMaterial
import Source3.KeygenMakePublicCall
import Source3.KeygenMakeWorkspaceTables

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- ONE material witness across the six gates. The solver call keeps the h
    frame (its writes stay in F/G and the scratch, so the public-equation
    material survives gate 5 byte-for-byte), the accepted attempt carries one
    material with BOTH equations (the public equation over h and the exact
    integer NTRU equation over F/G) on the same physical f/g/F/G/h arrays,
    and that accepted physical material is what the encoding tail reads.
    No certificate outcome, NTRU equation or codec fact is a premise; the
    certificate call execution, the caller cells and the h block separation
    stay explicit inputs. Not a review and not a codec or law claim. -/
namespace FT1536.Source3.KeygenMakeMaterialWitness
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

/-! ## 1. The one-material witness (definitions first) -/

/-- ONE material witness on the five actual arrays: the SAME physical
    f/g/F/G/h bytes carry the sampled small vectors, the solved F/G, the
    public equation over h and the f-inverse equation. -/
def Witness (heap : Memory) (input : Fin 4 → ArrayPointer) (pub : ArrayPointer) : Prop :=
  ∃ (fv gv F G : Geometry.Vec) (hv fInv : Relation.Rq),
    KeygenMaterial.Represents heap (input 0) fv ∧
    KeygenMaterial.Represents heap (input 1) gv ∧
    KeygenMaterial.Represents heap (input 2) F ∧
    KeygenMaterial.Represents heap (input 3) G ∧
    KeygenPublicNormalizePolynomial.Represents heap pub hv ∧
    KeygenSolverEquation.Bounds (KeygenOutputGateValidation.material fv gv F G) ∧
    KeygenSolverEquation.Equation (KeygenOutputGateValidation.material fv gv F G) ∧
    Relation.mulRq hv (Relation.reduceVec fv)=Relation.reduceVec gv ∧
    Relation.mulRq fInv (Relation.reduceVec fv)=
      FT1536.Run2.CoefficientQuotient.constantCoeffs (1 : KeygenPublicAlgebra.R)

/-- The encoding-tail input boundary: the five automatic arrays read by the
    18-statement encoding tail (`KeygenMakeProgram.encoding`) carry the
    witness material. The tail's codec bodies are B1.08/09. -/
def EncodingInputs (heap : Memory) (input : Fin 4 → ArrayPointer) (pub : ArrayPointer) : Prop :=
  Witness heap input pub

theorem element_block (p : ArrayPointer) (i : Nat) :
    (KeygenSmallOutput.element p i).block=p.block := rfl

theorem output_block (root : ArrayPointer) (slot : Fin 4) :
    (KeygenMkgm3Layout.output root slot).block=root.block := rfl

/-! ## 2. Byte frames on foreign blocks through the solver body -/

theorem small_writes_bytes (dst : ArrayPointer) (i : Nat) (before after : Memory)
    (source : KeygenSmallBounds.Writes dst i before after) (block : Nat) (separate : block≠dst.block) :
    ∀ offset, after.bytes block offset=before.bytes block offset := by
  induction source with
  | done index heap guard =>
    intro offset
    rfl
  | next index first middle last z inside bound store rest ih =>
    intro offset
    have step := store.2.2.2.2.2.2 block offset (Or.inl (by rw [element_block]; exact separate))
    exact (ih offset).trans step

theorem residue_writes_bytes (arrays : KeygenResidueTrace.Arrays) (i : Nat) (indices : List (Fin 4))
    (before after : Memory) (source : KeygenResidueTrace.Writes arrays i indices before after)
    (block : Nat) (separate : ∀ slot : Fin 4, block≠(arrays.output slot).block) :
    ∀ offset, after.bytes block offset=before.bytes block offset := by
  induction source with
  | done =>
    intro offset
    rfl
  | next slot rest first middle last cell tail ih =>
    intro offset
    have step := cell.write.2.2.2.2.2.2 block offset
      (Or.inl (by rw [element_block]; exact separate slot))
    exact (ih offset).trans step

theorem trace_bytes (arrays : KeygenResidueTrace.Arrays) (i : Nat) (before after : Memory)
    (source : KeygenResidueLoop.Trace arrays i before after)
    (block : Nat) (separate : ∀ slot : Fin 4, block≠(arrays.output slot).block) :
    ∀ offset, after.bytes block offset=before.bytes block offset := by
  induction source with
  | done index heap guard =>
    intro offset
    rfl
  | next index first middle last guard writes rest ih =>
    intro offset
    have step := residue_writes_bytes arrays index KeygenResidueTrace.slots first middle writes
      block separate offset
    exact (ih offset).trans step

/-- The four-leg validation body (generation, conversion, transforms, final
    check) keeps every byte of a block outside the scratch. -/
theorem validation_record_same (arrays : KeygenResidueTrace.Arrays)
    (v : KeygenOutputGateValidation.Validation arrays) (block : Nat)
    (separate : block≠v.scratch.block) :
    ShakeExtractFrame.SameBlock v.start.heap v.out.state.heap block := by
  have outSeparate : ∀ slot : Fin 4, block≠(arrays.output slot).block := by
    intro slot bad
    have shape := congrArg ArrayPointer.block (v.layout.2 slot)
    exact separate (bad.trans shape)
  have width : v.scratch.elementBytes=4 := (v.generationEntry.2.2.2.2.2.2.2).1
  have genBytes : ∀ offset, v.generated.state.heap.bytes block offset=v.start.heap.bytes block offset := by
    intro offset
    exact KeygenMkgm3Frame.outside_bytes KeygenMkgm3Program.code v.start v.generated v.scratch width
      (by decide) KeygenMkgm3Frame.source_footprint v.generationEntry.2.2.2.2.1 v.generation
      block offset (Or.inl separate)
  have trace := KeygenResidueLoop.source_trace arrays v.conversionEntry v.old v.converted
    v.counter v.inputs v.conversion
  have convBytes : ∀ offset, v.converted.state.heap.bytes block offset=v.conversionEntry.heap.bytes block offset :=
    trace_bytes arrays 0 v.conversionEntry.heap v.converted.state.heap trace.2.2.2 block outSeparate
  have conversionControl := KeygenNttControl.frame KeygenResidueProgram.code v.conversionEntry
    v.converted (by decide) v.conversion
  have callerOut : KeygenSolverNttCalls.Caller v.converted.state v.p0i (KeygenMkgm3Layout.gm v.scratch) :=
    ⟨(conversionControl.2.1 _ (by decide)).trans v.caller.logn,
      (conversionControl.2.1 _ (by decide)).trans v.caller.prime,
      (conversionControl.2.1 _ (by decide)).trans v.caller.inverse,
      (congrFun trace.2.2.1 _).trans v.caller.table⟩
  have bindings : KeygenSolverTransforms.Bindings v.converted.state v.scratch := by
    intro slot
    have ptr : arrays.output slot=KeygenMkgm3Layout.output v.scratch slot := v.layout.2 slot
    rw [← ptr]
    exact trace.2.1.output slot
  have frame : KeygenNttMemoryFrame.Frame v.converted.state.heap v.transformed.heap v.scratch :=
    KeygenSolverValidation.sequence_frame [0,1,2,3] v.converted.state v.transformed v.scratch v.p0i
      width callerOut bindings (by rw [KeygenSolverTransforms.four_code]; exact v.transforms)
  have finalHeap : v.out.state.heap=v.transformed.heap :=
    KeygenSolverValidation.read_only_heap KeygenSolverTarget.code v.transformed v.out (by decide) v.validation
  have genStable : KeygenMemoryStability.Stable v.start.heap v.generated.state.heap :=
    KeygenMemoryStability.modular KeygenMkgm3Program.code v.start v.generated v.generation
  have convStable : KeygenMemoryStability.Stable v.conversionEntry.heap v.converted.state.heap :=
    KeygenMemoryStability.modular KeygenResidueProgram.code v.conversionEntry v.converted v.conversion
  refine ⟨?_,?_,?_⟩
  · rw [finalHeap]
    have size := frame.1.trans (convStable.size.trans
      ((congrArg Memory.size v.sameGenerationHeap).trans genStable.size))
    exact size
  · rw [finalHeap]
    have writable := frame.2.1.trans (convStable.writable.trans
      ((congrArg Memory.writable v.sameGenerationHeap).trans genStable.writable))
    exact writable
  · intro offset
    rw [finalHeap]
    have chain := (frame.2.2 block offset (Or.inl separate)).trans
      ((convBytes offset).trans
        ((congrArg (fun m : Memory => m.bytes block offset) v.sameGenerationHeap).trans (genBytes offset)))
    exact chain

/-- The validation call keeps the h frame on its accepted edge. -/
theorem validation_h_same (ctx : Context) (before : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (entry : KeygenRootValidation.Entry ctx before input primes rev)
    (source : KeygenRootValidationSource.Exec ctx before out)
    (success : out.flow=.returned (some (.int32 1)))
    (separate : h.block≠ctx.scratch.block) :
    ShakeExtractFrame.SameBlock before.heap out.state.heap h.block := by
  obtain ⟨v,startHeap,outEq⟩ := KeygenRootValidation.validation ctx before out input primes rev
    entry source success
  have scratchBlock : v.scratch.block=ctx.scratch.block :=
    (congrArg ArrayPointer.block (v.layout.2 0)).symm
  have separated : h.block≠v.scratch.block := by
    rw [scratchBlock]
    exact separate
  have same := validation_record_same (KeygenRootValidation.arrays input ctx.scratch) v h.block separated
  rw [← outEq,← startHeap]
  exact same

/-! ## 3. The solver-call h frame and the one-material join -/

/-- THE solver-call h frame: an accepted solve_NTRU call keeps every byte of
    the h block (its writes stay in F/G and the scratch). -/
theorem solver_h_same (ctx : Context) (before after : State) (v : Value)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (legal : KeygenRootCaller.Legal ctx before input primes rev)
    (source : KeygenRootSource.Call ctx before after v) (returned : v=.int32 1)
    (hProtected : KeygenRootSearch.Protected ctx before h.block)
    (hBigF : h.block≠(input 2).block) (hBigG : h.block≠(input 3).block) :
    ShakeExtractFrame.SameBlock before.heap after.heap h.block := by
  cases source with
  | run entry out v binding body conversion =>
    have state := KeygenRootCaller.bind_exact ctx before entry input primes rev legal binding
    subst entry
    have boundHeap : (KeygenRootCaller.bound before ctx input).heap=before.heap := rfl
    have flow := KeygenRootCaller.return_one ctx (KeygenRootCaller.bound before ctx input) out v
      body conversion returned
    have searchProfile : KeygenSearchContext.M0 (KeygenRootCaller.bound before ctx input).heap ctx := by
      simpa only [KeygenRootCaller.bound,C99ArrayReference.bindPointer] using legal.profile
    have searchProtected : KeygenRootSearch.Protected ctx (KeygenRootCaller.bound before ctx input) h.block := by
      refine ⟨hProtected.1,?_⟩
      intro name p tableBinding
      exact hProtected.2 name p
        (by simpa only [KeygenRootCaller.bound,C99ArrayReference.bindPointer] using tableBinding)
    cases body with
    | searchRejected out search reject =>
      rw [flow] at reject
      cases reject
    | outputRejected searched out search gate reject =>
      rw [flow] at reject
      cases reject
    | validated searched passed out search gate validation =>
      have searchBytes : ∀ offset, searched.heap.bytes h.block offset=before.heap.bytes h.block offset := by
        have frame := KeygenRootSearch.frame ctx (KeygenRootCaller.bound before ctx input)
          ⟨searched,.normal⟩ search searchProfile h.block searchProtected
        intro offset
        exact (frame.2.2.2 offset).trans
          (congrArg (fun m : Memory => m.bytes h.block offset) boundHeap)
      have boundEntry := KeygenRootCaller.bound_entry ctx before input primes rev legal
      obtain ⟨ternary,tmp,member,tmpMember,gateExec⟩ := gate
      have hp := KeygenRootObjects.search_profile ctx (KeygenRootCaller.bound before ctx input) _
        search boundEntry.profile boundEntry.contextProtected
      have ht := KeygenSearchContext.ternary_m0 ctx searched ternary hp member
      have hs := KeygenSearchContext.tmp_value ctx searched tmp tmpMember
      subst ternary tmp
      let view : KeygenOutputGateSource.Context := ⟨1,ctx.scratch⟩
      have gateBytes : ∀ offset, passed.heap.bytes h.block offset=searched.heap.bytes h.block offset := by
        have caller := KeygenRootSearch.output_caller ctx (KeygenRootCaller.bound before ctx input) _
          search boundEntry.profile (input 2) (input 3) (boundEntry.inputs 2) (boundEntry.inputs 3)
          ctx.object.block boundEntry.contextProtected
        obtain ⟨middle,first,second⟩ := KeygenOutputGateBounds.gate_writes view searched ⟨passed,.normal⟩
          (input 2) (input 3) rfl caller gateExec rfl
        intro offset
        exact (small_writes_bytes (input 3) 0 middle passed.heap second h.block hBigG offset).trans
          (small_writes_bytes (input 2) 0 searched.heap middle first h.block hBigF offset)
      have validationEntry : KeygenRootValidation.Entry ctx passed input primes rev :=
        KeygenRootSource.suffix_entry ctx (KeygenRootCaller.bound before ctx input) searched passed
          input primes rev boundEntry search view gateExec
      have validationSame : ShakeExtractFrame.SameBlock passed.heap out.state.heap h.block :=
        validation_h_same ctx passed out input h primes rev validationEntry validation flow
          (Ne.symm hProtected.1)
      have searchStable := KeygenSearchStability.root ctx (KeygenRootCaller.bound before ctx input)
        ⟨searched,.normal⟩ search
      have gateStable := KeygenRootObjects.gate view searched ⟨passed,.normal⟩ gateExec
      refine ⟨?_,?_,?_⟩
      · exact validationSame.1.trans (gateStable.size.trans
          (searchStable.size.trans (congrArg Memory.size boundHeap)))
      · exact validationSame.2.1.trans (gateStable.writable.trans
          (searchStable.writable.trans (congrArg Memory.writable boundHeap)))
      · intro offset
        exact (validationSame.2.2 offset).trans ((gateBytes offset).trans (searchBytes offset))

/-- The public-equation material for h survives any same-block execution. -/
theorem h_represented_solver (before after : Memory) (p : ArrayPointer) (hv : Relation.Rq)
    (same : ShakeExtractFrame.SameBlock before after p.block)
    (material : KeygenPublicNormalizePolynomial.Represents before p hv) :
    KeygenPublicNormalizePolynomial.Represents after p hv :=
  KeygenMakeCertMaterial.public_represents_same before after p hv same material

/-- ONE material witness at the accepted solver call: the public material
    (equations over the same f/g/h) and the solved F/G join on one material.
    The f/g bounds are the explicit input of the solver call. -/
theorem witness_at_solver (ctx : Context) (publicState after : State) (v : Value)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (legal : KeygenRootCaller.Legal ctx publicState input primes rev)
    (call : KeygenRootSource.Call ctx publicState after v) (returned : v=.int32 1)
    (hProtected : KeygenRootSearch.Protected ctx publicState h.block)
    (hBigF : h.block≠(input 2).block) (hBigG : h.block≠(input 3).block)
    (fv gv : Geometry.Vec) (fvBound : KeygenIntegerLift.Bound fv 1)
    (gvBound : KeygenIntegerLift.Bound gv 1)
    (material : KeygenMakePublicCall.Material publicState.heap (input 0) (input 1) h fv gv) :
    Witness after.heap input h := by
  obtain ⟨hf,hg,hv,fInv,hvRepr,nonzero,publicEq,inverseEq⟩ := material
  obtain ⟨F,G,bounds,equation,retained⟩ := KeygenRootCaller.success ctx publicState after v input
    primes rev legal call returned fv gv hf hg fvBound gvBound
  have hFrame : ShakeExtractFrame.SameBlock publicState.heap after.heap h.block :=
    solver_h_same ctx publicState after v input h primes rev legal call returned hProtected hBigF hBigG
  have hvAfter := h_represented_solver publicState.heap after.heap h hv hFrame hvRepr
  refine ⟨fv,gv,F,G,hv,fInv,retained 0,retained 1,retained 2,retained 3,hvAfter,bounds,equation,
    publicEq,inverseEq⟩

/-! ## 4. The public gate, the certificate frame and the encoding tail -/

/-- The 046 public-equation material at the public gate on the actual caller
    arrays. The h-side separation/legality facts are explicit local inputs of
    the same class as `LegalWorkspace`; the allocation extraction discharges
    them later. -/
theorem public_material_equations (before after : State) (v : Value)
    (input : Fin 4 → ArrayPointer) (h : ArrayPointer)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (arrays : before.arrays "f".toList=some (input 0) ∧
      before.arrays "g".toList=some (input 1) ∧ before.arrays "h".toList=some h)
    (material : KeygenAttemptMaterial.Material before.heap (input 0) (input 1))
    (legalF : KeygenPublicInputMaterial.Legal before.heap (input 0))
    (legalG : KeygenPublicInputMaterial.Legal before.heap (input 1))
    (legalH : KeygenPublicInputMaterial.Legal before.heap h)
    (separate : h.block≠(input 0).block ∧ h.block≠(input 1).block)
    (liveTables : KeygenPublicInputLifetime.LiveTables before)
    (hTables : KeygenPublicFrame.Tables before h.block)
    (call : KeygenPublicSource.Call before after v) (nonzero : v.integer≠0) :
    ∃ fv gv, KeygenIntegerLift.Bound fv 1 ∧ KeygenIntegerLift.Bound gv 1 ∧
      KeygenMakePublicCall.Material after.heap (input 0) (input 1) h fv gv := by
  obtain ⟨fv,gv,hf,hfBound,hg,hgBound⟩ := material
  exact ⟨fv,gv,hfBound,hgBound,KeygenMakePublicCall.source_same_material before after v
    (input 0) (input 1) h fv gv dimensions arrays legalF legalG legalH hf hg hfBound hgBound
    separate.1 separate.2 liveTables hTables call nonzero⟩

/-- A certificate-live block outside the workspace block0 and the two static
    table blocks keeps every byte through the certificate call. -/
theorem certificate_material_block (args : CertificateFunctionReference.Arguments)
    (caller after : Memory) (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event)
    (source : CertificateFunctionReference.Exec args FftGlobalMemory.environment caller after
      gateTrace events true)
    (frame : CertificateFunctionOutcome.CallerFrame args FftGlobalMemory.environment caller after)
    (block : Nat) (not0 : block≠0) (not1 : block≠1) (not2 : block≠2) :
    ShakeExtractFrame.SameBlock caller after block := by
  obtain ⟨shapeSize,shapeWritable⟩ := KeygenMakeCertMaterial.leave_shape args
    FftGlobalMemory.environment caller after gateTrace events true source
  refine ⟨shapeSize,shapeWritable,fun offset => ?_⟩
  by_cases live : offset<caller.size block
  · exact KeygenMakeWorkspaceTables.foreign_block_retained args caller after frame block offset live
      (Or.inl not0) not1 not2
  · exact KeygenMakeCertMaterial.leave_bytes args FftGlobalMemory.environment caller after
      gateTrace events true source block offset live

theorem witness_represented (before after : Memory) (input : Fin 4 → ArrayPointer) (pub : ArrayPointer)
    (sames : ∀ slot : Fin 4, ShakeExtractFrame.SameBlock before after (input slot).block)
    (pubSame : ShakeExtractFrame.SameBlock before after pub.block)
    (witness : Witness before input pub) : Witness after input pub := by
  obtain ⟨fv,gv,F,G,hv,fInv,hf,hg,hF,hG,hhv,bounds,equation,publicEq,inverseEq⟩ := witness
  exact ⟨fv,gv,F,G,hv,fInv,
    KeygenMakeCertMaterial.represents_same before after (input 0) fv (sames 0) hf,
    KeygenMakeCertMaterial.represents_same before after (input 1) gv (sames 1) hg,
    KeygenMakeCertMaterial.represents_same before after (input 2) F (sames 2) hF,
    KeygenMakeCertMaterial.represents_same before after (input 3) G (sames 3) hG,
    h_represented_solver before after pub hv pubSame hhv,bounds,equation,publicEq,inverseEq⟩

/-- The sixth gate preserves the ONE material: the accepted certificate call
    writes only its workspace/scratch and the leaf words, so the five
    material blocks keep their bytes and the witness survives to the
    accepted-break state — the input boundary of the encoding tail. -/
theorem attempt_witness (ctx : Context) (before after : State) (v : Value)
    (input : Fin 4 → ArrayPointer) (pub : ArrayPointer)
    (call : KeygenMakeCertCall.Call ctx before after v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (workspace : KeygenMakeCertMaterial.LegalWorkspace before ctx)
    (blocks : ∀ slot : Fin 4, (input slot).block≠0 ∧ (input slot).block≠1 ∧ (input slot).block≠2)
    (pubBlocks : pub.block≠0 ∧ pub.block≠1 ∧ pub.block≠2)
    (witness : Witness before.heap input pub) : EncodingInputs after.heap input pub := by
  cases call with
  | run args bind afterMem gateTrace events ret body v bit =>
    have profile := KeygenMakeCertCall.bind_callee_profile before ctx args bind dimensions
    have frame := (CertificateFunctionOutcome.accepted args FftGlobalMemory.environment before.heap
      afterMem gateTrace events profile (workspace args bind) body.2).2.2.1
    have sames : ∀ slot : Fin 4, ShakeExtractFrame.SameBlock before.heap afterMem (input slot).block :=
      fun slot => certificate_material_block args before.heap afterMem gateTrace events body.2 frame
        (input slot).block (blocks slot).1 (blocks slot).2.1 (blocks slot).2.2
    have pubSame : ShakeExtractFrame.SameBlock before.heap afterMem pub.block :=
      certificate_material_block args before.heap afterMem gateTrace events body.2 frame
        pub.block pubBlocks.1 pubBlocks.2.1 pubBlocks.2.2
    exact witness_represented before.heap afterMem input pub sames pubSame witness

/-! ## 5. The encoding-tail boundary -/

/-- Kernel syntax position of the encoding tail: the 18 statements of
    `KeygenMakeProgram.encoding` follow the attempt loop in the caller body,
    so the accepted-break state is the input boundary of the encoding tail.
    The tail's codec bodies are B1.08/09 and the whole-invocation assembly is
    the remaining statement-machine obligation. -/
theorem encoding_position :
    KeygenMakeProgram.encoding=KeygenMakeProgram.outer.drop 15 ∧
      KeygenMakeProgram.get KeygenMakeProgram.outer 14=KeygenMakeProgram.attemptedLoop :=
  ⟨rfl,KeygenMakeProgram.outer_shape.2⟩

theorem encoding_tail_length : (KeygenMakeProgram.encoding).length=18 :=
  KeygenMakeProgram.actual_encoder_tail_length

end FT1536.Source3.KeygenMakeMaterialWitness
