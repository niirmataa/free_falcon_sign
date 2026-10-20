import Source3.KeygenMakePrologue

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual cap BEFORE ternary-local setup and BOTH sampler calls. No repeated
   dimension execution is inserted at the loop entry. This is the first
   sampling prefix, not a whole-loop or six-gate acceptance theorem. -/
namespace FT1536.Source3.KeygenMakeSampling
open C99ArrayReference (State Name bindPointer)
open C99MemoryReference
open KeygenSearchContext (Context)
open C99ProcedureReference (Result)
open KeygenCapWords (Count advanced)

def prepared (ctx : Context) (s : State) : State :=
  bindPointer (bindPointer (bindPointer (KeygenCallerInit.rtDeclared s)
    "rt1".toList (KeygenCallerInit.rt ctx 0)) "rt2".toList (KeygenCallerInit.rt ctx 1))
    "rt3".toList (KeygenCallerInit.rt ctx 2)
theorem setup_result (ctx : Context) (before after : State) (size : C99CountedWords.Limit before)
    (source : KeygenCallerInit.Setup ctx before after) : after=prepared ctx before := by
  cases source with
  | run p q r first second third =>
    have hp : p=KeygenSearchMemory.view ctx.scratch 8 := by
      cases first with
      | cast width e raw p value cast =>
        cases value with
        | tmp raw read =>
          rw [KeygenSearchContext.tmp_value ctx _ raw read] at cast
          exact cast.2.2.2.2
    subst p
    have hq := KeygenCallerInit.pointer_n (bindPointer (KeygenCallerInit.rtDeclared before) "rt1".toList _)
      "rt1".toList _ q rfl size second
    subst q
    have hr := KeygenCallerInit.pointer_n (bindPointer (bindPointer (KeygenCallerInit.rtDeclared before)
      "rt1".toList _) "rt2".toList _) "rt2".toList _ r rfl size third
    subst r
    simp only [prepared,KeygenCallerInit.rt,Nat.mul_zero,Nat.add_zero,Nat.mul_succ,Nat.add_assoc]
theorem prepared_slot (ctx : Context) (s : State) (n : Name) (outside : n∉KeygenCallerInit.rtNames) :
    (prepared ctx s).arrays n=s.arrays n := by
  have absent : KeygenCallerInit.rtNames.contains n=false := by
    cases h : KeygenCallerInit.rtNames.contains n with
    | false => rfl
    | true => exact (outside (List.contains_iff_mem.mp h)).elim
  have h1 : n≠"rt1".toList := fun h => outside (h ▸ (by decide))
  have h2 : n≠"rt2".toList := fun h => outside (h ▸ (by decide))
  have h3 : n≠"rt3".toList := fun h => outside (h ▸ (by decide))
  simp only [prepared,bindPointer,KeygenCallerInit.rtDeclared,C99DeclarationStatements.effect,
    h1,h2,h3,absent,ite_false,Bool.false_eq_true]
theorem prepared_count (ctx : Context) (s : State) (i : Nat) (source : Count s i) : Count (prepared ctx s) i := by
  simpa only [Count,prepared,bindPointer,KeygenCallerInit.rtDeclared,C99DeclarationStatements.effect,
    C99DeclarationCells.declareCells,C99ScalarReference.set,
    show "local_attempts".toList≠"norm".toList by decide,
    show "local_attempts".toList≠"bound".toList by decide,ite_false] using source
theorem prepared_initial (ctx : Context) (s : State) (i : Nat) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (source : KeygenCallerEntry.Initial ctx s input h primes rev) :
    KeygenCallerEntry.Initial ctx (prepared ctx (advanced s i)) input h primes rev := by
  refine ⟨?_,?_,?_,source.profile,source.table,source.primeObject,source.revBinding,source.revSource,
    source.scratch,source.allocated,source.width,source.scratchSeparate,source.distinct,source.contextSeparate,
    source.contextScratch,source.contextTables,source.inputTables,source.publicSeparate,source.publicContext,source.staticLive⟩
  · exact (prepared_slot ctx (advanced s i) _ (by decide)).trans source.context
  · intro slot; exact (prepared_slot ctx (advanced s i) _ (KeygenCallerEntry.input_not_rt slot)).trans (source.inputs slot)
  · exact (prepared_slot ctx (advanced s i) _ (by decide)).trans source.publicPointer

inductive CappedSetup (ctx : Context) (before : State) : Result → Prop where
  | abort (out : Result) (cap : C99ProcedureReference.Exec KeygenSearchFft.program KeygenAttemptCap.code before out)
      (exit : out.flow≠.normal) : CappedSetup ctx before out
  | run (counted after : State)
      (cap : C99ProcedureReference.Exec KeygenSearchFft.program KeygenAttemptCap.code before ⟨counted,.normal⟩)
      (setup : KeygenCallerInit.Setup ctx counted after) : CappedSetup ctx before ⟨after,.normal⟩
theorem cap_before_setup (ctx : Context) (before : State) (i : Nat) (out : Result)
    (reachable : i≤KeygenAttemptCap.limit) (counter : Count before i) (size : C99CountedWords.Limit before)
    (source : CappedSetup ctx before out) :
    (i=KeygenAttemptCap.limit ∧ out=⟨advanced before i,KeygenCapExecution.abortFlow⟩) ∨
    (i < KeygenAttemptCap.limit ∧ out=⟨prepared ctx (advanced before i),.normal⟩ ∧ Count out.state (i+1)) := by
  cases source with
  | abort out cap exit =>
    have equal := KeygenCapExecution.source_result KeygenSearchFft.program before i out reachable counter cap
    by_cases exhausted : i=KeygenAttemptCap.limit
    · left
      rw [KeygenCapExecution.result,ite_eq_left (show KeygenAttemptCap.limit < i+1 by omega)] at equal
      exact ⟨exhausted,equal⟩
    · have bound : ¬KeygenAttemptCap.limit < i+1 := by omega
      rw [KeygenCapExecution.result,ite_eq_right bound] at equal
      exact (exit (congrArg Result.flow equal)).elim
  | run counted after cap setup =>
    have equal := KeygenCapExecution.source_result KeygenSearchFft.program before i ⟨counted,.normal⟩ reachable counter cap
    have bound : i < KeygenAttemptCap.limit := by
      by_contra h
      rw [KeygenCapExecution.result,ite_eq_left (show KeygenAttemptCap.limit < i+1 by omega)] at equal
      have bad := congrArg Result.flow equal
      cases bad
    rw [KeygenCapExecution.result,ite_eq_right (show ¬KeygenAttemptCap.limit < i+1 by omega)] at equal
    have stateEq : counted=advanced before i := congrArg Result.state equal
    subst counted
    have ready := setup_result ctx (advanced before i) after size setup
    subst after
    exact Or.inr ⟨bound,rfl,prepared_count ctx _ (i+1) (KeygenCapWords.advanced_count before i)⟩
theorem cap_exhaustion_has_no_setup (ctx : Context) (before : State) (out : Result)
    (counter : Count before KeygenAttemptCap.limit) (size : C99CountedWords.Limit before)
    (source : CappedSetup ctx before out) : out.flow=KeygenCapExecution.abortFlow := by
  rcases cap_before_setup ctx before KeygenAttemptCap.limit out (by omega) counter size source with aborted | running
  · rw [aborted.2]
  · exact (Nat.lt_irrefl _ running.1).elim
theorem no_counter_wrap (i : Nat) (reachable : i≤KeygenAttemptCap.limit) :
    (BitVec.ofNat 64 (i+1)).toNat=i+1 := by
  rw [BitVec.toNat_ofNat]
  exact Nat.mod_eq_of_lt (by dsimp [KeygenAttemptCap.limit] at reachable; omega)
def firstEntry (ctx : Context) (before : State) (blocks : Fin 6 → Nat) : State :=
  prepared ctx (advanced (KeygenMakePrologue.ready before blocks) 0)
theorem first_cap (ctx : Context) (before after : State) (blocks : Fin 6 → Nat) (out : Result) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (head : KeygenMakePrologue.AlreadyReadyPrefix ctx before blocks after) (source : CappedSetup ctx after out) :
    out=⟨firstEntry ctx before blocks,.normal⟩ ∧ Count out.state 1 ∧
    KeygenCallerEntry.Initial ctx out.state (KeygenMakeEntry.input blocks) (KeygenMakeEntry.publicPointer blocks) primes rev := by
  obtain ⟨equal,count,entry⟩ := KeygenMakePrologue.prefix_result ctx before after blocks primes rev original head
  subst after
  rcases cap_before_setup ctx _ 0 out (by decide) count (by rfl) source with aborted | running
  · have bad := aborted.1; dsimp [KeygenAttemptCap.limit] at bad; omega
  · refine ⟨running.2.1,running.2.2,?_⟩
    rw [running.2.1]
    exact prepared_initial ctx _ 0 _ _ primes rev entry

theorem prepared_rt (ctx : Context) (s : State) (n : Name) (member : n∈KeygenCallerInit.rtNames)
    (p : ArrayPointer) (binding : (prepared ctx s).arrays n=some p) : p.block=ctx.scratch.block := by
  rcases List.mem_cons.mp member with equal | member
  · subst n; have same : KeygenCallerInit.rt ctx 0=p := Option.some.inj binding; rw [← same]; rfl
  rcases List.mem_cons.mp member with equal | member
  · subst n; have same : KeygenCallerInit.rt ctx 1=p := Option.some.inj binding; rw [← same]; rfl
  rcases List.mem_cons.mp member with equal | member
  · subst n; have same : KeygenCallerInit.rt ctx 2=p := Option.some.inj binding; rw [← same]; rfl
  · cases member
theorem prepared_limit (ctx : Context) (s : State) (source : C99CountedWords.Limit s) :
    C99CountedWords.Limit (prepared ctx s) := by
  simpa only [C99CountedWords.Limit,prepared,bindPointer,KeygenCallerInit.rtDeclared,C99DeclarationStatements.effect,
    C99DeclarationCells.declareCells,C99ScalarReference.set,
    show "n".toList≠"norm".toList by decide,show "n".toList≠"bound".toList by decide,ite_false] using source
theorem entry_from_prepared (ctx : Context) (s : State) (i : Nat) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) (size : C99CountedWords.Limit s) :
    KeygenAttemptMaterial.Entry ctx (prepared ctx (advanced s i)) (input 0) (input 1) := by
  have retained := prepared_initial ctx s i input h primes rev initial
  have normProtected : ∀ slot : Fin 4, KeygenAttemptNorm.Protected ctx (prepared ctx (advanced s i)) (input slot).block := by
    intro slot
    refine ⟨initial.scratchSeparate slot,?_,initial.inputTables slot⟩
    intro n member p binding
    rw [prepared_rt ctx (advanced s i) n member p binding]
    exact initial.scratchSeparate slot
  have publicProtected : ∀ slot : Fin 4, KeygenPublicFrame.Outside (prepared ctx (advanced s i)) ["h".toList] (input slot).block := by
    intro slot n member p binding
    have equal := List.mem_singleton.mp member
    subst n
    have pointer := Option.some.inj (retained.publicPointer.symm.trans binding)
    subst p
    exact initial.publicSeparate slot
  exact ⟨initial.contextSeparate 0,initial.contextSeparate 1,initial.distinct 0 1 (by decide),
    KeygenCallerEntry.allocated_live _ _ (initial.allocated 0),KeygenCallerEntry.allocated_live _ _ (initial.allocated 1),
    initial.width 0,initial.width 1,prepared_limit ctx _ size,retained.inputs 0,retained.inputs 1,
    normProtected 0,normProtected 1,publicProtected 0,publicProtected 1⟩
theorem sampler_locals (ctx : Context) (before after : State) (n : String) (source : KeygenSamplerContext.Call ctx before n after) :
    after.locals=before.locals := by
  cases source with
  | run resolved source => cases source; rfl
inductive FirstSamples (ctx : Context) (before : State) (blocks : Fin 6 → Nat) : State → Prop where
  | run (loopEntry samplerEntry middle sampled : State)
      (head : KeygenMakePrologue.AlreadyReadyPrefix ctx before blocks loopEntry)
      (cap : CappedSetup ctx loopEntry ⟨samplerEntry,.normal⟩)
      (first : KeygenSamplerContext.Call ctx samplerEntry "f" middle)
      (second : KeygenSamplerContext.Call ctx middle "g" sampled) : FirstSamples ctx before blocks sampled
theorem first_sampled_material (ctx : Context) (before after : State) (blocks : Fin 6 → Nat) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original ctx before primes rev) (source : FirstSamples ctx before blocks after) :
    Count after 1 ∧ KeygenAttemptMaterial.Material after.heap (KeygenMakeEntry.input blocks 0) (KeygenMakeEntry.input blocks 1) := by
  cases source with
  | run loopEntry samplerEntry middle sampled head cap first second =>
    obtain ⟨equal,count,initial⟩ := first_cap ctx before loopEntry blocks ⟨samplerEntry,.normal⟩ primes rev original head cap
    have entryEq : samplerEntry=firstEntry ctx before blocks := congrArg Result.state equal
    subst samplerEntry
    have incoming := (KeygenMakePrologue.prefix_result ctx before loopEntry blocks primes rev original head).2.2
    have loopEq := (KeygenMakePrologue.prefix_result ctx before loopEntry blocks primes rev original head).1
    subst loopEntry
    have entry := entry_from_prepared ctx _ 0 _ _ primes rev incoming (by rfl)
    refine ⟨?_,KeygenAttemptMaterial.sampled_material ctx _ middle after _ _ entry first second⟩
    change after.locals "local_attempts".toList=some (.uint64,some (.uint64 1))
    rw [sampler_locals ctx middle after "g" second,sampler_locals ctx _ middle "f" first]
    exact count

end FT1536.Source3.KeygenMakeSampling
