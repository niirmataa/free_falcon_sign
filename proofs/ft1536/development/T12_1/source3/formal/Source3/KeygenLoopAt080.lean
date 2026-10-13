import Source3.KeygenRetryAt080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual capped chronology with certificate calls at the scratch block.
   Names, counts and successful-vs-emitted distinction mirror the pinned loop. -/
namespace FT1536.Source3.KeygenLoopAt080
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenMakeSearchPrefix (Remaining)
open KeygenCapWords (Count)

structure AttemptExecution (ctx : Context) where
  before : State
  out : Result
  source : KeygenAttemptAt080.Exec ctx before out

def AttemptExecution.exit (a : AttemptExecution ctx) : Flow := a.out.flow
def AttemptAccepted (a : AttemptExecution ctx) : Prop := a.exit=Flow.breakLoop
def AttemptRejected (a : AttemptExecution ctx) : Prop := a.exit=Flow.continueLoop

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
    obtain ⟨strict,remaining,flow⟩ := KeygenRetryAt080.attempt_remaining ctx a.before a.out i entry a.source
    refine ⟨by simpa using remaining.2.2,Numbered.next i a [] entry.1 remaining.1 (.nil _),
      fun _ => remaining.1,?_,Or.inl rfl⟩
    intro aborted
    change (Flow.normal:Flow)=KeygenCapExecution.abortFlow at aborted
    cases aborted
  | retry a out rest rejected tail ih =>
    obtain ⟨strict,remaining,flow⟩ := KeygenRetryAt080.attempt_remaining ctx a.before a.out i entry a.source
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

end FT1536.Source3.KeygenLoopAt080
