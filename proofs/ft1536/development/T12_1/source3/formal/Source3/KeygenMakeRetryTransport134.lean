import Source3.KeygenMakeRetryTransport
import Source3.KeygenMakeRetryFrames
import Source3.KeygenMakeCertMaterial
import Source3.KeygenAttemptNorm133
import Source3.KeygenCallerPrefix134
import Source3.KeygenMakeSearchPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenMakeRetryTransport134
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open ShakeExtractFrame (SameBlock)








open KeygenMakeRetryTransport
theorem frame_of_ternary (ctx : Context) (entry : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx entry input h primes rev)
    (material : KeygenAttemptMaterial.Entry ctx entry (input 0) (input 1))
    (normProtected : KeygenAttemptNorm.Protected ctx entry ctx.object.block)
    (source : KeygenCallerPrefix134.Ternary ctx entry out) :
    EntryFrame ctx entry.heap out.state.heap primes rev := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    have sampling := frame_of_sampling ctx entry middle sampled input h primes rev initial material
      first second
    have stable := (KeygenAttemptMaterial.resultants sampled out gate).2
    have bytes := KeygenResultantGate.bytes sampled out gate
    exact entry_frame_trans _ _ _ _ _ _ sampling
      ⟨stable.size,stable.writable,
        fun offset _ => congrFun (congrFun bytes ctx.object.block) offset,
        fun offset => congrFun (congrFun bytes primes.block) offset,
        fun offset => congrFun (congrFun bytes rev.block) offset⟩
  | norm middle sampled res out first second resultants norm =>
    have sampling := frame_of_sampling ctx entry middle sampled input h primes rev initial material
      first second
    have resStable := (KeygenAttemptMaterial.resultants sampled ⟨res,.normal⟩ resultants).2
    have resBytes := KeygenResultantGate.bytes sampled ⟨res,.normal⟩ resultants
    have resFrame : EntryFrame ctx sampled.heap res.heap primes rev :=
      ⟨resStable.size,resStable.writable,
        fun offset _ => congrFun (congrFun resBytes ctx.object.block) offset,
        fun offset => congrFun (congrFun resBytes primes.block) offset,
        fun offset => congrFun (congrFun resBytes rev.block) offset⟩
    have normStable := KeygenAttemptNorm133.stable ctx res out norm
    obtain ⟨_,_,_,primeReadonly,_,_,_⟩ := initial.primeObject
    obtain ⟨revReadonly,_,_,_⟩ := initial.revSource
    have resReadonly : res.heap.writable primes.block=false := by
      rw [resStable.writable,sampling.writable]
      exact primeReadonly
    have resRevReadonly : res.heap.writable rev.block=false := by
      rw [resStable.writable,sampling.writable]
      exact revReadonly
    have resSlots := KeygenAttemptSlots.trans _ _ _
      (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second)
        (KeygenAttemptMaterial.resultants _ _ resultants).1)
    have resProtected : KeygenAttemptNorm.Protected ctx res ctx.object.block :=
      KeygenAttemptMaterial.protected_slots _ _ _ ctx.object.block resSlots normProtected
    have normFrame : EntryFrame ctx res.heap out.state.heap primes rev :=
      ⟨normStable.size,normStable.writable,
        fun offset _ => KeygenAttemptNorm133.bytes ctx res out norm ctx.object.block resProtected offset,
        fun offset => normStable.readonly primes.block offset resReadonly,
        fun offset => normStable.readonly rev.block offset resRevReadonly⟩
    exact entry_frame_trans _ _ _ _ _ _ sampling (entry_frame_trans _ _ _ _ _ _ resFrame normFrame)

theorem initial_of_ternary (ctx : Context) (entry : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx entry input h primes rev)
    (material : KeygenAttemptMaterial.Entry ctx entry (input 0) (input 1))
    (normProtected : KeygenAttemptNorm.Protected ctx entry ctx.object.block)
    (source : KeygenCallerPrefix134.Ternary ctx entry out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev :=
  initial_of_frame ctx entry out.state input h primes rev initial
    (congrFun (KeygenCallerPrefix134.ternary_slots ctx entry out source).1 "fk".toList)
    (fun slot => congrFun (KeygenCallerPrefix134.ternary_slots ctx entry out source).1
      (KeygenResidueTrace.names slot).2.toList)
    (congrFun (KeygenCallerPrefix134.ternary_slots ctx entry out source).1 "h".toList)
    (KeygenCallerPrefix134.ternary_slots ctx entry out source).2
    (frame_of_ternary ctx entry out input h primes rev initial material normProtected source)

theorem gate_entry (ctx : Context) (saved entry : State) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (entryInitial : KeygenCallerEntry.Initial ctx entry input h primes rev)
    (material : KeygenAttemptMaterial.Entry ctx entry (input 0) (input 1))
    (normProtected : KeygenAttemptNorm.Protected ctx entry ctx.object.block)
    (source : KeygenMakeSearchPrefix134.Gates ctx saved entry out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      EntryFrame ctx entry.heap out.state.heap primes rev := by
  cases source with
  | ternaryRejected raw source rejected =>
    exact ⟨initial_of_close ctx saved raw.state input h primes rev
        (initial_of_ternary ctx entry raw input h primes rev entryInitial material normProtected source),
      frame_of_ternary ctx entry raw input h primes rev entryInitial material normProtected source⟩
  | publicRejected normed raw source gate rejected =>
    obtain ⟨pv,publicCall⟩ := public_gate_any _ _ gate
    have ternaryFrame : EntryFrame ctx entry.heap normed.heap primes rev :=
      frame_of_ternary ctx entry ⟨normed,.normal⟩ input h primes rev entryInitial material normProtected source
    have closed : KeygenCallerEntry.Initial ctx (KeygenCallerPrefix.close saved normed) input h primes rev :=
      initial_of_close ctx saved normed input h primes rev
        (initial_of_ternary ctx entry ⟨normed,.normal⟩ input h primes rev entryInitial material
          normProtected source)
    exact ⟨initial_of_public ctx (KeygenCallerPrefix.close saved normed) _ pv input h primes rev
        closed publicCall,
      entry_frame_trans _ _ _ _ _ _ ternaryFrame
        (frame_of_public ctx (KeygenCallerPrefix.close saved normed) _ pv input h primes rev closed
          publicCall)⟩
  | solver normed publicState raw source publicGate gate =>
    obtain ⟨pv,publicCall⟩ := public_gate_any _ _ publicGate
    obtain ⟨sv,solverCall⟩ := root_gate_any ctx _ _ gate
    have ternaryFrame : EntryFrame ctx entry.heap normed.heap primes rev :=
      frame_of_ternary ctx entry ⟨normed,.normal⟩ input h primes rev entryInitial material normProtected source
    have closed : KeygenCallerEntry.Initial ctx (KeygenCallerPrefix.close saved normed) input h primes rev :=
      initial_of_close ctx saved normed input h primes rev
        (initial_of_ternary ctx entry ⟨normed,.normal⟩ input h primes rev entryInitial material
          normProtected source)
    have openState : KeygenCallerEntry.Initial ctx _ input h primes rev :=
      initial_of_public ctx (KeygenCallerPrefix.close saved normed) _ pv input h primes rev closed publicCall
    have closeFrame : EntryFrame ctx normed.heap (KeygenCallerPrefix.close saved normed).heap primes rev :=
      entry_frame_rfl ctx normed.heap primes rev
    exact ⟨initial_of_solver ctx _ _ sv input h primes rev openState solverCall,
      entry_frame_trans _ _ _ _ _ _ ternaryFrame
        (entry_frame_trans _ _ _ _ _ _ closeFrame
          (entry_frame_trans _ _ _ _ _ _
            (frame_of_public ctx (KeygenCallerPrefix.close saved normed) _ pv input h primes rev closed
              publicCall)
            (frame_of_solver ctx _ _ sv input h primes rev openState solverCall)))⟩

theorem sampled_entry (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenMakeSearchPrefix134.Sampled ctx before out) :
    KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
      EntryFrame ctx before.heap out.state.heap primes rev := by
  cases source with
  | run entry out cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
      remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
    · have impossible := congrArg Result.flow aborted.2
      cases impossible
    · have entryEq : entry=KeygenMakeSearchPrefix.updated ctx before i := congrArg Result.state running.2.1
      subst entry
      have entryInitial := KeygenMakeSampling.prepared_initial ctx before i input h primes rev initial
      have material := KeygenMakeSampling.entry_from_prepared ctx before i input h primes rev initial
        remaining.2.1.1
      have normProtected := KeygenMakeSearchMaterial.context_norm ctx before i input h primes rev initial
      exact gate_entry ctx before (KeygenMakeSearchPrefix.updated ctx before i) out input h primes rev
        entryInitial material normProtected gates

end FT1536.Source3.KeygenMakeRetryTransport134
