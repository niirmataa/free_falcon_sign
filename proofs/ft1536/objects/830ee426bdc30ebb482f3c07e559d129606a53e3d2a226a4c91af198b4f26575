import Source3.KeygenMakeSearchTrace

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- SAME physical coefficient material at the pre-certificate boundary. The
   solver equation is consumed from032 after actual setup/sampling/norm/public
   execution. Dimensions are NOT rerun at the attempt entry. This is not the
   sixth gate, accepted material, an encoder input or a whole-KeyGen theorem. -/
namespace FT1536.Source3.KeygenMakeSearchMaterial
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeSearchPrefix (Sampled Remaining Gates updated)
open KeygenAttemptSlots (Slots)

theorem root_initial (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) : KeygenRootCaller.Legal ctx s input primes rev := by
  refine ⟨initial.context,initial.inputs,initial.profile,initial.table,initial.primeObject,initial.revBinding,
    initial.revSource,initial.scratch,initial.width,?_,?_,⟨initial.contextScratch,initial.contextTables⟩,
    ⟨initial.scratchSeparate 0,initial.inputTables 0⟩,⟨initial.scratchSeparate 1,initial.inputTables 1⟩⟩
  · intro slot; exact Or.inl (Ne.symm (initial.scratchSeparate slot))
  · intro a b different; exact Or.inl (initial.distinct a b different)
theorem context_norm (ctx : Context) (s : State) (i : Nat) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) : KeygenAttemptNorm.Protected ctx (updated ctx s i) ctx.object.block := by
  refine ⟨initial.contextScratch,?_,initial.contextTables⟩
  intro name member p binding
  rw [KeygenMakeSampling.prepared_rt ctx (KeygenCapWords.advanced s i) name member p binding]
  exact initial.contextScratch
theorem context_public (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) : KeygenPublicFrame.Outside s ["h".toList] ctx.object.block := by
  intro name member p binding
  have equal := List.mem_singleton.mp member
  subst name
  have same := Option.some.inj (initial.publicPointer.symm.trans binding)
  subst p
  exact initial.publicContext
theorem ternary_root (ctx : Context) (s : State) (i : Nat) (out : Result)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) (size : C99CountedWords.Limit s)
    (source : KeygenCallerPrefix.Ternary ctx (updated ctx s i) out) : KeygenRootCaller.Legal ctx out.state input primes rev := by
  have prepared := KeygenMakeSampling.prepared_initial ctx s i input h primes rev initial
  have material := KeygenMakeSampling.entry_from_prepared ctx s i input h primes rev initial size
  exact KeygenCallerPrefix.ternary_root ctx _ out input primes rev material (root_initial ctx _ input h primes rev prepared)
    (initial.staticLive _ primes initial.table) (initial.staticLive _ rev initial.revBinding)
    (context_norm ctx s i input h primes rev initial) source

theorem public_material (ctx : Context) (s : State) (i : Nat) (normed after : State)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) (size : C99CountedWords.Limit s)
    (source : KeygenCallerPrefix.Ternary ctx (updated ctx s i) ⟨normed,.normal⟩)
    (gate : KeygenAttemptMaterial.PublicGate (KeygenCallerPrefix.close s normed) ⟨after,.normal⟩) :
    KeygenRootCaller.Legal ctx after input primes rev ∧ KeygenAttemptMaterial.Material after.heap (input 0) (input 1) := by
  have prepared := KeygenMakeSampling.prepared_initial ctx s i input h primes rev initial
  have entry := KeygenMakeSampling.entry_from_prepared ctx s i input h primes rev initial size
  have slots := KeygenCallerPrefix.ternary_slots ctx _ _ source
  have sizes := KeygenCallerPrefix.ternary_size ctx _ _ (input 0) (input 1) entry source
  have legal := KeygenCallerPrefix.close_root ctx s normed input primes rev
    (ternary_root ctx s i _ input h primes rev initial size source)
  have contextOutside := KeygenCallerPrefix.close_public s normed ctx.object.block
    (KeygenAttemptMaterial.public_slots _ _ _ slots (context_public ctx _ input h primes rev prepared))
  have fOutside := KeygenCallerPrefix.close_public s normed (input 0).block
    (KeygenAttemptMaterial.public_slots _ _ _ slots entry.fPublic)
  have gOutside := KeygenCallerPrefix.close_public s normed (input 1).block
    (KeygenAttemptMaterial.public_slots _ _ _ slots entry.gPublic)
  obtain ⟨f,g,hf,bf,hg,bg⟩ := KeygenCallerPrefix.ternary_material ctx _ _ (input 0) (input 1) entry source
  cases gate with
  | accept after v call nonzero =>
    refine ⟨KeygenCallerTransport.public_root ctx _ _ v input primes rev legal contextOutside call,
      f,g,KeygenPublicSource.material _ _ v call (input 0) fOutside legal.fProtected.2 ?_ f hf,bf,
      KeygenPublicSource.material _ _ v call (input 1) gOutside legal.gProtected.2 ?_ g hg,bg⟩
    · change 0<normed.heap.size (input 0).block; rw [sizes]; exact entry.fLive
    · change 0<normed.heap.size (input 1).block; rw [sizes]; exact entry.gLive

theorem source_ntru (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (remaining : Remaining before i) (source : Sampled ctx before out) (normal : out.flow=.normal) :
    KeygenCallerSuccess.Solved out.state.heap input := by
  cases source with
  | run samplerEntry out cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨samplerEntry,.normal⟩ remaining.2.2 remaining.1 remaining.2.1.1 cap with exhausted | running
    · have bad := congrArg Result.flow exhausted.2; cases bad
    · have equal : samplerEntry=updated ctx before i := congrArg Result.state running.2.1
      subst samplerEntry
      cases gates with
      | ternaryRejected raw source rejected =>
        change raw.flow=.normal at normal
        rw [normal] at rejected; cases rejected
      | publicRejected normed raw source gate rejected => rw [normal] at rejected; cases rejected
      | solver normed publicState raw source publicGate gate =>
        obtain ⟨legal,f,g,hf,bf,hg,bg⟩ := public_material ctx before i normed publicState input h primes rev initial remaining.2.1.1 source publicGate
        cases gate with
        | reject after v call zero => cases normal
        | accept after v call nonzero =>
          obtain ⟨F,G,bounds,equation,retained⟩ := KeygenRootCaller.success ctx publicState after v input primes rev legal call
            (KeygenCallerSuccess.nonzero_one ctx publicState after v call nonzero) f g hf hg bf bg
          exact ⟨f,g,F,G,bounds,equation,retained⟩

theorem first_source_ntru (args : KeygenMakeArguments.Arguments) (ctx : Context) (caller loopEntry : State)
    (blocks : Fin 6 → Nat) (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event) (out : Result)
    (original : KeygenMakeEntry.Original ctx (KeygenMakeArguments.entry caller args) primes rev)
    (head : KeygenMakeArguments.PrefixInvocation args ctx caller blocks events ⟨loopEntry,.normal⟩)
    (source : Sampled ctx loopEntry out) (normal : out.flow=.normal) :
    KeygenCallerSuccess.Solved out.state.heap (KeygenMakeEntry.input blocks) := by
  have initial := (KeygenMakeArguments.normal_entry args ctx caller loopEntry blocks events primes rev original head).2.1
  cases head with
  | run bound events raw binding head =>
    have equal := KeygenMakeArguments.bind_exact caller args bound binding
    subst bound
    exact source_ntru ctx loopEntry out 0 _ _ primes rev initial
      (KeygenMakeSearchTrace.prefix_remaining ctx _ loopEntry blocks primes rev original events head) source normal

end FT1536.Source3.KeygenMakeSearchMaterial
