import Source3.KeygenMakeLoopChronology
import Source3.KeygenMakeInvocation
import Source3.KeygenMakeRetryTransport
import Source3.KeygenCallerPrefix134
import Source3.KeygenMakeSearchPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenMakeLoopChronology134
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env)







open KeygenMakeLoopChronology
theorem gates_arrays (ctx : Context) (saved entry : State) (out : Result)
    (source : KeygenMakeSearchPrefix134.Gates ctx saved entry out) (n : Name)
    (outside : n∉KeygenCallerInit.rtNames) : out.state.arrays n=entry.arrays n := by
  cases source with
  | ternaryRejected raw gate _rejected =>
    rw [result_close_arrays saved raw n outside,
      (KeygenCallerPrefix134.ternary_slots ctx entry raw gate).1]
  | publicRejected normed idx source gate _rejected =>
    rw [public_gate_arrays _ out gate,state_close_arrays saved normed n outside,
      (KeygenCallerPrefix134.ternary_slots ctx entry ⟨normed,.normal⟩ source).1]
  | solver normed publicState idx source publicGate gate =>
    rw [root_gate_arrays ctx publicState out gate,
      public_gate_arrays _ ⟨publicState,.normal⟩ publicGate,
      state_close_arrays saved normed n outside,
      (KeygenCallerPrefix134.ternary_slots ctx entry ⟨normed,.normal⟩ source).1]

theorem sampled_arrays (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeSearchPrefix134.Sampled ctx before out) (n : Name)
    (outside : n∉KeygenCallerInit.rtNames) : out.state.arrays n=before.arrays n := by
  cases source with
  | run entry idx cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
      remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
    · have impossible := congrArg Result.flow aborted.2
      cases impossible
    · have entryEq : entry=KeygenMakeSearchPrefix.updated ctx before i :=
        congrArg Result.state running.2.1
      subst entry
      rw [gates_arrays ctx before (KeygenMakeSearchPrefix.updated ctx before i) out gates n outside,
        KeygenMakeSearchPrefix.updated,
        KeygenMakeSampling.prepared_slot ctx (KeygenCapWords.advanced before i) n outside,
        advanced_arrays before i n]

theorem sampled_comp (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeSearchPrefix134.Sampled ctx before out) :
    out.state.locals "comp".toList=before.locals "comp".toList := by
  cases source with
  | run entry idx cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
      remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
    · have impossible := congrArg Result.flow aborted.2
      cases impossible
    · have entryEq : entry=KeygenMakeSearchPrefix.updated ctx before i :=
        congrArg Result.state running.2.1
      subst entry
      rw [KeygenMakeSearchPrefix134.gates_locals ctx before
          (KeygenMakeSearchPrefix.updated ctx before i) out gates "comp".toList (by decide),
        KeygenMakeSearchPrefix.updated,
        KeygenMakeSearchPrefix.prepared_local ctx (KeygenCapWords.advanced before i)
          "comp".toList (by decide),
        advanced_comp before i]

end FT1536.Source3.KeygenMakeLoopChronology134
