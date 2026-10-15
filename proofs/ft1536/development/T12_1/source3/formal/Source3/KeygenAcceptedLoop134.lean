import Source3.KeygenAcceptedLoop079
import Source3.KeygenAcceptedMaterial079
import Source3.KeygenCallerPrefix134
import Source3.KeygenMakeSearchPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenAcceptedLoop134
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeCertChronology


open KeygenAcceptedLoop079
theorem sampled_tables (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeSearchPrefix134.Sampled ctx before out) :
    out.state.tables=before.tables := by
  cases source with
  | run entry out cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
      remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
    · have impossible := congrArg Result.flow aborted.2
      cases impossible
    · have entryEq : entry=KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i) :=
        congrArg Result.state running.2.1
      have entryTables : entry.tables=before.tables := by rw [entryEq]; rfl
      cases gates with
      | ternaryRejected raw source rejected =>
        exact (KeygenCallerPrefix134.ternary_slots ctx entry raw source).2.trans
          entryTables
      | publicRejected normed raw source gate rejected =>
        cases gate with
        | reject after v call zero | accept after v call nonzero =>
          exact (KeygenMakeAttemptSpine.public_slots_state _ _ _ call).2.2.trans
            ((KeygenCallerPrefix134.ternary_slots ctx entry _ source).2.trans
              entryTables)
      | solver normed publicState raw source publicGate gate =>
        have publicTables : publicState.tables=entry.tables := by
          cases publicGate with
          | accept after v call nonzero =>
            exact (KeygenMakeAttemptSpine.public_slots_state _ _ _ call).2.2.trans
              (KeygenCallerPrefix134.ternary_slots ctx entry _ source).2
        cases gate with
        | reject after v call zero | accept after v call nonzero =>
          exact (KeygenRootSource.slots _ _ _ _ call).2.2.trans
            (publicTables.trans entryTables)

end FT1536.Source3.KeygenAcceptedLoop134
