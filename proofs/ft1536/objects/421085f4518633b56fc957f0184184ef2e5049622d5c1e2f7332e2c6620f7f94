import Source3.KeygenMakeSearchPrefix

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Chronology extracted from actual finite FIVE-gate prefix executions.
   A normal stop is BEFORE the mandatory certificate. This deliberately does
   not define the final AttemptAccepted/LoopSucceeded interfaces: certificate
   rejection, final break and actual encoding-input identity are still open. -/
namespace FT1536.Source3.KeygenMakeSearchTrace
open C99ArrayReference (State Name)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenMakeSearchPrefix (Remaining Dimensions Sampled)
open KeygenCapWords (Count)
open C99MemoryReference (ArrayPointer)

structure Attempt (ctx : Context) where
  before : State
  out : Result
  source : Sampled ctx before out
def Rejected (ctx : Context) (a : Attempt ctx) : Prop := a.out.flow=.continueLoop
def AtCertificate (ctx : Context) (a : Attempt ctx) : Prop := a.out.flow=.normal
inductive Trace (ctx : Context) : State → Result → List (Attempt ctx) → Prop where
  | exhausted (before : State) (out : Result) (cap : KeygenMakeSampling.CappedSetup ctx before out)
      (exit : out.flow≠.normal) : Trace ctx before out []
  | atCertificate (a : Attempt ctx) (stopped : AtCertificate ctx a) : Trace ctx a.before a.out [a]
  | retry (a : Attempt ctx) (out : Result) (rest : List (Attempt ctx)) (rejected : Rejected ctx a)
      (tail : Trace ctx a.out.state out rest) : Trace ctx a.before out (a::rest)
inductive Numbered (ctx : Context) : Nat → List (Attempt ctx) → Prop where
  | nil (i : Nat) : Numbered ctx i []
  | next (i : Nat) (a : Attempt ctx) (rest : List (Attempt ctx))
      (before : Count a.before i) (after : Count a.out.state (i+1)) (tail : Numbered ctx (i+1) rest) :
      Numbered ctx i (a::rest)
def Aborted (out : Result) : Prop := out.flow=KeygenCapExecution.abortFlow
def BoundFacts (ctx : Context) (i : Nat) (out : Result) (attempts : List (Attempt ctx)) : Prop :=
  i+attempts.length≤KeygenAttemptCap.limit ∧ Numbered ctx i attempts ∧
  (out.flow=.normal → Count out.state (i+attempts.length)) ∧
  (Aborted out → i+attempts.length=KeygenAttemptCap.limit ∧ Count out.state (KeygenAttemptCap.limit+1)) ∧
  (out.flow=.normal ∨ Aborted out)
theorem source_bounds (ctx : Context) (before : State) (out : Result) (attempts : List (Attempt ctx))
    (source : Trace ctx before out attempts) (i : Nat) (entry : Remaining before i) : BoundFacts ctx i out attempts := by
  induction source generalizing i with
  | exhausted before out cap exit =>
    obtain ⟨equal,result⟩ := KeygenMakeSearchPrefix.exhaustion ctx before out i entry cap exit
    subst i
    rw [result]
    refine ⟨by simp,Numbered.nil _,?_,?_,Or.inr rfl⟩
    · intro bad; cases bad
    · intro _; exact ⟨rfl,KeygenCapWords.advanced_count before KeygenAttemptCap.limit⟩
  | atCertificate a stopped =>
    obtain ⟨strict,remaining,flow⟩ := KeygenMakeSearchPrefix.sampled_remaining ctx a.before a.out i entry a.source
    refine ⟨by simpa using remaining.2.2,Numbered.next i a [] entry.1 remaining.1 (.nil _),
      fun _ => remaining.1,?_,Or.inl stopped⟩
    intro aborted
    change a.out.flow=KeygenCapExecution.abortFlow at aborted
    rw [stopped] at aborted
    cases aborted
  | retry a out rest rejected tail ih =>
    obtain ⟨strict,remaining,flow⟩ := KeygenMakeSearchPrefix.sampled_remaining ctx a.before a.out i entry a.source
    obtain ⟨bound,numbered,normal,aborted,exit⟩ := ih (i+1) remaining
    have length : i+(a::rest).length=(i+1)+rest.length := by simp only [List.length_cons]; omega
    refine ⟨by rw [length]; exact bound,Numbered.next i a rest entry.1 remaining.1 numbered,?_,?_,exit⟩
    · rw [length]; exact normal
    · rw [length]; exact aborted
theorem chronological (ctx : Context) (before : State) (out : Result) (attempts : List (Attempt ctx))
    (source : Trace ctx before out attempts) (normal : out.flow=.normal) :
    ∃ rejected final, attempts=rejected++[final] ∧
      (∀ a∈rejected, Rejected ctx a) ∧ AtCertificate ctx final ∧ final.out=out := by
  induction source with
  | exhausted before out cap exit => exact (exit normal).elim
  | atCertificate a stopped => exact ⟨[],a,rfl,by simp,stopped,rfl⟩
  | retry a out rest rejected tail ih =>
    obtain ⟨earlier,final,shape,rejects,last,same⟩ := ih normal
    refine ⟨a::earlier,final,by simp only [shape,List.cons_append],?_,last,same⟩
    intro b member
    rcases List.mem_cons.mp member with equal | member
    · subst b; exact rejected
    · exact rejects b member
theorem no_cap_sample (ctx : Context) (before : State) (out : Result) (attempts : List (Attempt ctx))
    (source : Trace ctx before out attempts) (entry : Remaining before KeygenAttemptCap.limit) :
    attempts=[] ∧ Aborted out ∧ Count out.state (KeygenAttemptCap.limit+1) := by
  obtain ⟨bound,numbered,normal,aborted,exit⟩ := source_bounds ctx before out attempts source _ entry
  have empty : attempts=[] := List.length_eq_zero_iff.mp (by omega)
  rcases exit with succeeded | failure
  · obtain ⟨rejected,final,shape,rejects,last,same⟩ := chronological ctx before out attempts source succeeded
    rw [empty] at shape
    have length := congrArg List.length shape
    simp only [List.length_nil,List.length_append,List.length_cons] at length
    omega
  · exact ⟨empty,failure,(aborted failure).2⟩

inductive Invocation (args : KeygenMakeArguments.Arguments) (ctx : Context) (caller : State) (blocks : Fin 6 → Nat) :
    List KeygenEntropySource.Event → Result → List (Attempt ctx) → Prop where
  | run (bound ready : State) (events : List KeygenEntropySource.Event) (out : Result) (attempts : List (Attempt ctx))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values args) bound)
      (head : KeygenMakeReady.Prefix ctx bound blocks events ⟨ready,.normal⟩)
      (search : Trace ctx ready out attempts) : Invocation args ctx caller blocks events out attempts
theorem prefix_remaining (ctx : Context) (before after : State) (blocks : Fin 6 → Nat) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original ctx before primes rev) (events : List KeygenEntropySource.Event)
    (source : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩) : Remaining after 0 := by
  have facts := KeygenMakeReady.normal_prefix ctx before after blocks primes rev original events source
  have locals := KeygenMakeReady.normal_prefix_locals ctx before after blocks primes rev original events source
  refine ⟨facts.1,?_,by decide⟩
  rw [show Dimensions after ↔ Dimensions (KeygenMakePrologue.ready before blocks) by
    unfold Dimensions C99CountedWords.Limit; rw [locals]]
  exact ⟨rfl,rfl,rfl⟩
theorem actual_initial_chronology (args : KeygenMakeArguments.Arguments) (ctx : Context) (caller : State)
    (blocks : Fin 6 → Nat) (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (out : Result) (attempts : List (Attempt ctx))
    (original : KeygenMakeEntry.Original ctx (KeygenMakeArguments.entry caller args) primes rev)
    (source : Invocation args ctx caller blocks events out attempts) : BoundFacts ctx 0 out attempts := by
  cases source with
  | run bound ready events out attempts binding head search =>
    have equal := KeygenMakeArguments.bind_exact caller args bound binding
    subst bound
    exact source_bounds ctx ready out attempts search 0 (prefix_remaining ctx _ ready blocks primes rev original events head)
theorem actual_final_prefix (args : KeygenMakeArguments.Arguments) (ctx : Context) (caller : State)
    (blocks : Fin 6 → Nat) (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (out : Result) (attempts : List (Attempt ctx))
    (original : KeygenMakeEntry.Original ctx (KeygenMakeArguments.entry caller args) primes rev)
    (source : Invocation args ctx caller blocks events out attempts) (normal : out.flow=.normal) :
    ∃ rejected final, attempts=rejected++[final] ∧ (∀ a∈rejected, Rejected ctx a) ∧
      AtCertificate ctx final ∧ final.out=out ∧ attempts.length≤KeygenAttemptCap.limit ∧
      Numbered ctx 0 attempts ∧ Count out.state attempts.length := by
  have facts := actual_initial_chronology args ctx caller blocks primes rev events out attempts original source
  cases source with
  | run bound ready events out attempts binding head search =>
    obtain ⟨rejected,final,shape,rejects,last,same⟩ := chronological ctx ready out attempts search normal
    exact ⟨rejected,final,shape,rejects,last,same,by simpa using facts.1,facts.2.1,by simpa using facts.2.2.1 normal⟩

inductive CapFailure (args : KeygenMakeArguments.Arguments) (ctx : Context) (caller : State) (blocks : Fin 6 → Nat) :
    List KeygenEntropySource.Event → Result → List (Attempt ctx) → Prop where
  | run (bound ready : State) (events : List KeygenEntropySource.Event) (raw : Result) (attempts : List (Attempt ctx))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values args) bound)
      (head : KeygenMakeReady.Prefix ctx bound blocks events ⟨ready,.normal⟩)
      (search : Trace ctx ready raw attempts) (returned : Aborted raw) :
      CapFailure args ctx caller blocks events (KeygenMakeLifetime.close bound blocks raw) attempts
theorem cap_failure_lifetime (args : KeygenMakeArguments.Arguments) (ctx : Context) (caller : State)
    (blocks : Fin 6 → Nat) (events : List KeygenEntropySource.Event) (out : Result) (attempts : List (Attempt ctx))
    (source : CapFailure args ctx caller blocks events out attempts) :
    Aborted out ∧ (∀ slot : Fin 6, out.state.heap.size (blocks slot)=0) ∧
    (∀ n∈KeygenMakeLifetime.scalars, out.state.locals n=(KeygenMakeArguments.entry caller args).locals n) ∧
    (∀ n∈KeygenMakeLifetime.pointers, out.state.arrays n=(KeygenMakeArguments.entry caller args).arrays n) := by
  cases source with
  | run bound ready events raw attempts binding head search returned =>
    have equal := KeygenMakeArguments.bind_exact caller args bound binding
    subst bound
    exact ⟨returned,fun slot => (KeygenMakeLifetime.close_object _ blocks raw slot).1.trans
      (KeygenMakeLifetime.prefix_empty ctx _ blocks events ⟨ready,.normal⟩ head slot),
      KeygenMakeLifetime.close_local _ blocks raw,KeygenMakeLifetime.close_pointer _ blocks raw⟩

end FT1536.Source3.KeygenMakeSearchTrace
