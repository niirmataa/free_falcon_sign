import Source3.KeygenExternalSampling082

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenExternalGates082
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenExternalSampling082 (Outside)
open ShakeExtractFrame (SameBlock)

theorem public_call (ctx : Context) (before after : State) (value : C99IntegerReference.Value)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer) (block : Nat)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (outside : Outside ctx before input h block) (source : KeygenPublicSource.Call before after value) :
    SameBlock before.heap after.heap block := by
  apply KeygenPublicSource.frame before after value source block _ outside.tables outside.live
  intro name member p binding
  have nameEq := List.mem_singleton.mp member
  subst name
  have pointerEq := Option.some.inj (initial.publicPointer.symm.trans binding)
  subst p
  exact outside.publicBlock

theorem after_ternary (ctx : Context) (saved entry normed : State) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (block : Nat)
    (initial : KeygenCallerEntry.Initial ctx entry input h primes rev)
    (material : KeygenAttemptMaterial.Entry ctx entry (input 0) (input 1))
    (contextShield : KeygenAttemptNorm.Protected ctx entry ctx.object.block)
    (shield : KeygenAttemptNorm.Protected ctx entry block)
    (outside : Outside ctx entry input h block)
    (source : KeygenCallerPrefix.Ternary ctx entry ⟨normed,.normal⟩) :
    KeygenCallerEntry.Initial ctx (KeygenCallerPrefix.close saved normed) input h primes rev ∧
      Outside ctx (KeygenCallerPrefix.close saved normed) input h block ∧ SameBlock entry.heap normed.heap block := by
  have initialAfter := KeygenMakeRetryTransport.initial_of_close ctx saved normed input h primes rev
    (KeygenMakeRetryTransport.initial_of_ternary ctx entry ⟨normed,.normal⟩ input h primes rev initial material contextShield source)
  have frame := KeygenExternalSampling082.ternary ctx entry ⟨normed,.normal⟩ input h block outside material shield source
  have tables : (KeygenCallerPrefix.close saved normed).tables=entry.tables :=
    (KeygenMakeAttemptSpine.close_tables saved normed).trans (KeygenCallerPrefix.ternary_slots ctx entry _ source).2
  exact ⟨initialAfter,KeygenExternalSampling082.moved ctx entry _ input h block outside tables frame.1,frame⟩

theorem gates (ctx : Context) (saved entry : State) (out : Result) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (block : Nat)
    (initial : KeygenCallerEntry.Initial ctx entry input h primes rev)
    (material : KeygenAttemptMaterial.Entry ctx entry (input 0) (input 1))
    (contextShield : KeygenAttemptNorm.Protected ctx entry ctx.object.block)
    (shield : KeygenAttemptNorm.Protected ctx entry block)
    (outside : Outside ctx entry input h block)
    (source : KeygenMakeSearchPrefix.Gates ctx saved entry out) : SameBlock entry.heap out.state.heap block := by
  cases source with
  | ternaryRejected raw run rejected =>
    exact KeygenExternalSampling082.ternary ctx entry raw input h block outside material shield run
  | publicRejected normed raw run gate rejected =>
    obtain ⟨closedInitial,closedOutside,normFrame⟩ := after_ternary ctx saved entry normed input h primes rev block
      initial material contextShield shield outside run
    obtain ⟨value,call⟩ := KeygenMakeRetryTransport.public_gate_any _ _ gate
    exact KeygenPublicForeign081.same_trans _ _ _ block normFrame
      (public_call ctx (KeygenCallerPrefix.close saved normed) _ value input h primes rev block closedInitial closedOutside call)
  | solver normed publicState raw run publicGate rootGate =>
    obtain ⟨closedInitial,closedOutside,normFrame⟩ := after_ternary ctx saved entry normed input h primes rev block
      initial material contextShield shield outside run
    obtain ⟨pv,publicCall⟩ := KeygenMakeRetryTransport.public_gate_any _ _ publicGate
    have publicFrame := public_call ctx _ publicState pv input h primes rev block closedInitial closedOutside publicCall
    have publicInitial := KeygenMakeRetryTransport.initial_of_public ctx _ publicState pv input h primes rev closedInitial publicCall
    have publicOutside := KeygenExternalSampling082.moved ctx _ publicState input h block closedOutside
      (KeygenMakeAttemptSpine.public_slots_state _ _ _ publicCall).2.2 publicFrame.1
    obtain ⟨sv,rootCall⟩ := KeygenMakeRetryTransport.root_gate_any ctx publicState _ rootGate
    have rootFrame := KeygenMakeRetryFrames.solver_frame ctx publicState out.state sv input h primes rev
      (KeygenMakeSearchMaterial.root_initial ctx publicState input h primes rev publicInitial) rootCall block
      ⟨publicOutside.scratch,publicOutside.tables⟩ (Ne.symm (outside.inputs 2)) (Ne.symm (outside.inputs 3))
    exact KeygenPublicForeign081.same_trans _ _ _ block normFrame
      (KeygenPublicForeign081.same_trans _ _ _ block publicFrame rootFrame)

/-- The public capacity cell survives the actual five-gate prefix; all
    frames are derived from source bodies and structural input separation. -/
theorem sampled (ctx : Context) (before : State) (out : Result) (i : Nat) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (block : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (outside : Outside ctx before input h block)
    (source : KeygenMakeSearchPrefix.Sampled ctx before out) : SameBlock before.heap out.state.heap block := by
  cases source with
  | run entry result cap body =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
      remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
    · have impossible := congrArg Result.flow aborted.2
      cases impossible
    · have equal : entry=KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i) := congrArg Result.state running.2.1
      subst entry
      exact gates ctx before (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)) out input h primes rev block
        (KeygenMakeSampling.prepared_initial ctx before i input h primes rev initial)
        (KeygenMakeSampling.entry_from_prepared ctx before i input h primes rev initial remaining.2.1.1)
        (KeygenMakeAttemptSpine.context_norm_prepared ctx before i input h primes rev initial)
        (KeygenExternalSampling082.norm_prepared ctx before i input h block outside)
        (KeygenExternalSampling082.prepared ctx before i input h block outside) body

end FT1536.Source3.KeygenExternalGates082
