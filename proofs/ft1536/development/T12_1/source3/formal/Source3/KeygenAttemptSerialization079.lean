import Source3.KeygenSerializationEntry079

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenAttemptSerialization079
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env inputOf publicOf)
open KeygenCodecTypedSegments (Site arguments)
open KeygenInt16Representation076 (wordList)
open KeygenMakeCertChronology

def CallsCarry (env : Env) (heap : Memory) (calls : List (Site env)) : Prop :=
  ∃ (v : KeygenInt16FourMaterial076.Vectors) (h fInv : Relation.Rq),
    KeygenSolverEquation.Bounds v ∧ KeygenSolverEquation.Equation v ∧
    KeygenPublicNormalizePolynomial.Represents heap (publicOf env) h ∧
    Relation.mulRq h (Relation.reduceVec (v 0))=Relation.reduceVec (v 1) ∧
    Relation.mulRq fInv (Relation.reduceVec (v 0))=
      FT1536.Run2.CoefficientQuotient.constantCoeffs (1 : KeygenPublicAlgebra.R) ∧
    calls.length=4 ∧ KeygenCodecInvocation.Consecutive 0 calls ∧
    ∀ c, c∈calls → KeygenMaterial.Represents c.before.heap (inputOf env c.index) (v c.index) ∧
      c.ret=BitVec.ofNat 64 (KeygenCodecStaticComplete.encoded (wordList (v c.index))).length ∧
      KeygenCodecByteHistory.Trace c.before.heap c.after
        (KeygenCodecStaticHistory.positions (arguments env c.before c.index c.after c.ret c.site).out 0
          (KeygenCodecStaticComplete.encoded (wordList (v c.index))))

/-- Bridge from the accepted loop to ALL FOUR actual body-bound serializer
    calls. The entry-frame residual is explicit until the next assembly step;
    there is no assumed material witness or codec return/length/frame. -/
theorem accepted_loop_to_calls (env : Env) (before : State) (loopOut tailOut : Result)
    (attempts : List (AttemptExecution env.ctx)) (calls : List (Site env))
    (primes rev : ArrayPointer)
    (loop : LoopTrace env.ctx before loopOut attempts)
    (remaining : KeygenMakeSearchPrefix.Remaining before 0)
    (facts : KeygenMakeAttemptSpine.EntryFacts env.ctx before (inputOf env) (publicOf env) primes rev)
    (shape : KeygenMakeWorkspaceBridge.Shape env.ctx)
    (space : C99Automatic32.Space before.heap)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call env.ctx s t w ret →
        KeygenMakeRetryTransport.CertEntryFrame env.ctx s.heap t.heap primes rev)
    (loopNormal : loopOut.flow=.normal)
    (cells : KeygenMakeInvocation.TailCells env loopOut.state)
    (tail : KeygenCodecInvocation.Encoding env KeygenMakeProgram.encoding loopOut.state tailOut calls)
    (success : tailOut.flow=.returned (some (.int32 1)))
    (comp : env.args.comp=1)
    (privateSeparate : KeygenCodecStaticCalls.Separate env)
    (skeSeparate : ∀ slot : Fin 4, (inputOf env slot).block≠env.blocks 5)
    (publicPrivate : (publicOf env).block≠env.args.privkey.block)
    (publicSke : (publicOf env).block≠env.blocks 5)
    (privateSke : env.args.privkey.block≠env.blocks 5)
    (virtualLegal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb)
    (legal : KeygenInt16FourMaterial076.Legal before.heap (inputOf env)) :
    (∃ rejected final, attempts=rejected++[final] ∧
      (∀ a∈rejected, AttemptRejected a) ∧ AttemptAccepted final ∧
      final.out.state=loopOut.state) ∧
    ∃ headState segmentState,
      KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain loopOut.state ⟨headState,.normal⟩ ∧
      KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter headState)
        ⟨segmentState,.normal⟩ calls ∧ CallsCarry env headState.heap calls := by
  have witness := KeygenAcceptedLoop079.loop_material env.ctx before loopOut attempts loop
    (inputOf env) (publicOf env) primes rev shape certFrame 0 remaining facts space loopNormal
  obtain ⟨_,_,frame⟩ := KeygenMakeLoopChronology.loop_retry_entry env.ctx before loopOut
    attempts loop (inputOf env) (publicOf env) primes rev 0 remaining facts.initial certFrame loopNormal
  have loopLegal : KeygenInt16FourMaterial076.Legal loopOut.state.heap (inputOf env) :=
    fun slot => KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm (legal slot)
  obtain ⟨headState,segmentState,prelude,segments⟩ :=
    KeygenCodecInvocation.tail_trace env loopOut.state tailOut calls tail success
  have headMaterial := KeygenSerializationEntry079.prefix_material env loopOut.state _ prelude rfl
    privateSeparate skeSeparate publicPrivate publicSke witness
  have headLegal := KeygenSerializationEntry079.prefix_legal env loopOut.state _ prelude rfl
    privateSeparate skeSeparate loopLegal
  exact ⟨KeygenAcceptedLoop079.final_state env.ctx before loopOut attempts loop loopNormal,
    headState,segmentState,prelude,segments,
    KeygenInt16Caller076.witness_transport env loopOut.state _ _ calls (publicOf env)
      cells prelude rfl segments rfl comp privateSeparate privateSke virtualLegal headLegal headMaterial⟩

end FT1536.Source3.KeygenAttemptSerialization079
