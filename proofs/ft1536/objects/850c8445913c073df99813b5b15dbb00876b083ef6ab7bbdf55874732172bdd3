import Source3.KeygenMakeCertCall
import Source3.KeygenMakeSearchTrace

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Whole-attempt chronology through ALL SIX gates, including certificate
   rejection retries and the final accepted break. Every attempt record is a
   defined source derivation (five-gate prefix plus the sixth gate edge), not
   an abstract callee outcome. The named PLAN interfaces AttemptExecution /
   AttemptAccepted / AttemptRejected / LoopExecution / LoopSucceeded and the
   successful_loop_last_attempt theorem are instantiated here over the real
   capped loop; the loop's successful exit is the accepted break consumed by
   the loop statement (`exit = .normal`), distinct from call-level return1
   and from the later capacity checks. -/
namespace FT1536.Source3.KeygenMakeCertChronology
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenMakeSearchPrefix (Remaining Sampled)
open KeygenCapWords (Count)

theorem count_cells {s t : State} {i : Nat} (cells : s.locals=t.locals) (h : Count t i) : Count s i := by
  simp only [KeygenCapWords.Count] at *; rw [cells]; exact h
theorem dimensions_cells {s t : State} (cells : s.locals=t.locals)
    (h : KeygenMakeSearchPrefix.Dimensions t) : KeygenMakeSearchPrefix.Dimensions s := by
  simp only [KeygenMakeSearchPrefix.Dimensions,C99CountedWords.Limit] at *; rw [cells]; exact h

/-! ## 1. Six-gate attempt executions -/

/-- One complete attempt body: the five-gate sampled prefix, then (when the
    prefix stops at certificate entry) the mandatory sixth gate. An early
    five-gate rejection exits the attempt directly; the certificate gate
    either retries or takes the final accepted break. -/
inductive AttemptExec (ctx : Context) (before : State) : Result → Prop where
  | earlyRejected (raw : Result) (sample : Sampled ctx before raw)
      (rejected : raw.flow=.continueLoop) : AttemptExec ctx before raw
  | throughCertificate (raw : Result) (sample : Sampled ctx before raw)
      (atCert : raw.flow=.normal) (out : Result)
      (gate : KeygenMakeCertCall.CertificateGate ctx raw.state out) :
      AttemptExec ctx before out

structure AttemptExecution (ctx : Context) where
  before : State
  out : Result
  source : AttemptExec ctx before out

def AttemptExecution.exit (a : AttemptExecution ctx) : Flow := a.out.flow
def AttemptAccepted (a : AttemptExecution ctx) : Prop := a.exit=Flow.breakLoop
def AttemptRejected (a : AttemptExecution ctx) : Prop := a.exit=Flow.continueLoop

theorem attempt_exit_split (a : AttemptExecution ctx) : AttemptRejected a ∨ AttemptAccepted a := by
  obtain ⟨before,out,source⟩ := a
  cases source with
  | earlyRejected raw sample rejected => exact Or.inl rejected
  | throughCertificate raw sample atCert out gate =>
    rcases KeygenMakeCertCall.gate_flow ctx raw.state out gate with h | h
    · exact Or.inl h
    · exact Or.inr h

theorem attempt_no_normal (a : AttemptExecution ctx) : a.exit≠.normal := by
  obtain ⟨before,out,source⟩ := a
  cases source with
  | earlyRejected raw sample rejected =>
    intro bad; rw [AttemptExecution.exit,rejected] at bad; cases bad
  | throughCertificate raw sample atCert out gate =>
    exact KeygenMakeCertCall.gate_no_normal ctx raw.state out gate

theorem attempt_remaining (ctx : Context) (before : State) (out : Result) (i : Nat)
    (entry : Remaining before i) (source : AttemptExec ctx before out) :
    i<KeygenAttemptCap.limit ∧ Remaining out.state (i+1) ∧
      (out.flow=.continueLoop ∨ out.flow=.breakLoop) := by
  rcases source with ⟨_,sample,rejected⟩ | ⟨raw,sample,atCert,_,gate⟩
  · obtain ⟨strict,remaining,flow⟩ := KeygenMakeSearchPrefix.sampled_remaining ctx before out i entry sample
    exact ⟨strict,remaining,Or.inl rejected⟩
  · obtain ⟨strict,remaining,flow⟩ := KeygenMakeSearchPrefix.sampled_remaining ctx before raw i entry sample
    obtain ⟨cells,_,_⟩ := KeygenMakeCertCall.gate_cells ctx raw.state out gate
    have count : Count out.state (i+1) := count_cells cells remaining.1
    have dimensions : KeygenMakeSearchPrefix.Dimensions out.state := dimensions_cells cells remaining.2.1
    rcases KeygenMakeCertCall.gate_flow ctx raw.state out gate with e | e
    · exact ⟨strict,⟨count,dimensions,remaining.2.2⟩,Or.inl e⟩
    · exact ⟨strict,⟨count,dimensions,remaining.2.2⟩,Or.inr e⟩

/-! ## 2. The capped loop and the named PLAN interfaces -/

def Aborted (out : Result) : Prop := out.flow=KeygenCapExecution.abortFlow

inductive Numbered (ctx : Context) : Nat → List (AttemptExecution ctx) → Prop where
  | nil (i : Nat) : Numbered ctx i []
  | next (i : Nat) (a : AttemptExecution ctx) (rest : List (AttemptExecution ctx))
      (before : Count a.before i) (after : Count a.out.state (i+1))
      (tail : Numbered ctx (i+1) rest) : Numbered ctx i (a::rest)

inductive LoopTrace (ctx : Context) : State → Result → List (AttemptExecution ctx) → Prop where
  | exhausted (before : State) (out : Result) (cap : KeygenMakeSampling.CappedSetup ctx before out)
      (exit : out.flow≠.normal) : LoopTrace ctx before out []
  | accepted (a : AttemptExecution ctx) (last : AttemptAccepted a) :
      LoopTrace ctx a.before ⟨a.out.state,.normal⟩ [a]
  | retry (a : AttemptExecution ctx) (out : Result) (rest : List (AttemptExecution ctx))
      (rejected : AttemptRejected a) (tail : LoopTrace ctx a.out.state out rest) :
      LoopTrace ctx a.before out (a::rest)

structure LoopExecution (ctx : Context) where
  before : State
  out : Result
  attempts : List (AttemptExecution ctx)
  source : LoopTrace ctx before out attempts

def LoopExecution.exit (r : LoopExecution ctx) : Flow := r.out.flow
def LoopSucceeded (r : LoopExecution ctx) : Prop := r.exit=.normal

def attemptCap : Nat := KeygenAttemptCap.limit
theorem actual_attempt_cap : attemptCap=3000000 := rfl

def BoundFacts (ctx : Context) (i : Nat) (out : Result) (attempts : List (AttemptExecution ctx)) : Prop :=
  i+attempts.length≤KeygenAttemptCap.limit ∧ Numbered ctx i attempts ∧
  (out.flow=.normal → Count out.state (i+attempts.length)) ∧
  (Aborted out → i+attempts.length=KeygenAttemptCap.limit ∧ Count out.state (KeygenAttemptCap.limit+1)) ∧
  (out.flow=.normal ∨ Aborted out)

theorem source_bounds (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (i : Nat) (entry : Remaining before i) : BoundFacts ctx i out attempts := by
  induction source generalizing i with
  | exhausted before out cap exit =>
    obtain ⟨equal,result⟩ := KeygenMakeSearchPrefix.exhaustion ctx before out i entry cap exit
    subst i
    rw [result]
    refine ⟨by simp,Numbered.nil _,?_,?_,Or.inr rfl⟩
    · intro bad; cases bad
    · intro _; exact ⟨rfl,KeygenCapWords.advanced_count before KeygenAttemptCap.limit⟩
  | accepted a last =>
    obtain ⟨strict,remaining,flow⟩ := attempt_remaining ctx a.before a.out i entry a.source
    refine ⟨by simpa using remaining.2.2,Numbered.next i a [] entry.1 remaining.1 (.nil _),
      fun _ => remaining.1,?_,Or.inl rfl⟩
    intro aborted
    change (Flow.normal:Flow)=KeygenCapExecution.abortFlow at aborted
    cases aborted
  | retry a out rest rejected tail ih =>
    obtain ⟨strict,remaining,flow⟩ := attempt_remaining ctx a.before a.out i entry a.source
    obtain ⟨bound,numbered,normal,aborted,exit⟩ := ih (i+1) remaining
    have length : i+(a::rest).length=(i+1)+rest.length := by simp only [List.length_cons]; omega
    refine ⟨by rw [length]; exact bound,Numbered.next i a rest entry.1 remaining.1 numbered,?_,?_,exit⟩
    · rw [length]; exact normal
    · rw [length]; exact aborted

theorem loop_bounds (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (i : Nat) (entry : Remaining before i) :
    i+attempts.length≤KeygenAttemptCap.limit ∧ Numbered ctx i attempts := by
  obtain ⟨bound,numbered,_,_,_⟩ := source_bounds ctx before out attempts source i entry
  exact ⟨bound,numbered⟩

/-- The PLAN's successful_loop_last_attempt: a successful loop is a sequence
    of rejected attempts followed by the single accepted final attempt. -/
theorem successful_loop_last_attempt (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (succeeded : out.flow=.normal) :
    ∃ rejected final, attempts=rejected++[final] ∧
      (∀ a∈rejected, AttemptRejected a) ∧ AttemptAccepted final := by
  induction source with
  | exhausted before out cap exit => exact (exit succeeded).elim
  | accepted a last => exact ⟨[],a,rfl,by simp,last⟩
  | retry a out rest rejected tail ih =>
    obtain ⟨earlier,final,shape,rejects,last⟩ := ih succeeded
    refine ⟨a::earlier,final,by simp only [shape,List.cons_append],?_,last⟩
    intro b member
    rcases List.mem_cons.mp member with equal | member
    · subst b; exact rejected
    · exact rejects b member

theorem loop_bounds_success (ctx : Context) (before : State) (out : Result)
    (attempts : List (AttemptExecution ctx)) (source : LoopTrace ctx before out attempts)
    (i : Nat) (entry : Remaining before i) (succeeded : out.flow=.normal) :
    ∃ rejected final, attempts=rejected++[final] ∧
      (∀ a∈rejected, AttemptRejected a) ∧ AttemptAccepted final ∧
      i+attempts.length≤KeygenAttemptCap.limit ∧ Numbered ctx i attempts ∧
      Count out.state (i+attempts.length) := by
  obtain ⟨bound,numbered,normal,_,_⟩ := source_bounds ctx before out attempts source i entry
  obtain ⟨rejected,final,shape,rejects,last⟩ :=
    successful_loop_last_attempt ctx before out attempts source succeeded
  exact ⟨rejected,final,shape,rejects,last,bound,numbered,normal succeeded⟩

end FT1536.Source3.KeygenMakeCertChronology
