import Source3.KeygenMakeSearchPrefix
import Source3.KeygenMakeLocalFrame
import Source3.KeygenMakeArguments
import Source3.KeygenCallerPrefix134
import Source3.KeygenMakeLocalFrame134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenMakeSearchPrefix134
open C99ArrayReference (State Name)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenCapWords (Count)


open KeygenMakeSearchPrefix
inductive Gates (ctx : Context) (saved entry : State) : Result → Prop where
  | ternaryRejected (raw : Result) (source : KeygenCallerPrefix134.Ternary ctx entry raw)
      (rejected : raw.flow=.continueLoop) : Gates ctx saved entry (close saved raw)
  | publicRejected (normed : State) (raw : Result)
      (source : KeygenCallerPrefix134.Ternary ctx entry ⟨normed,.normal⟩)
      (gate : KeygenAttemptMaterial.PublicGate (KeygenCallerPrefix.close saved normed) raw)
      (rejected : raw.flow=.continueLoop) : Gates ctx saved entry raw
  | solver (normed publicState : State) (raw : Result)
      (source : KeygenCallerPrefix134.Ternary ctx entry ⟨normed,.normal⟩)
      (publicGate : KeygenAttemptMaterial.PublicGate (KeygenCallerPrefix.close saved normed) ⟨publicState,.normal⟩)
      (gate : KeygenCallerSuccess.RootGate ctx publicState raw) : Gates ctx saved entry raw

theorem gates_locals (ctx : Context) (saved entry : State) (out : Result) (source : Gates ctx saved entry out)
    (n : Name) (member : n∈KeygenMakeLocalFrame.fixed) : out.state.locals n=entry.locals n := by
  cases source with
  | ternaryRejected raw source rejected =>
    exact (close_local saved raw n member).trans (KeygenMakeLocalFrame134.ternary ctx entry raw source n member)
  | publicRejected normed raw source gate rejected =>
    exact (congrFun (public_gate_locals _ _ gate) n).trans
      ((close_local saved ⟨normed,.normal⟩ n member).trans (KeygenMakeLocalFrame134.ternary ctx entry _ source n member))
  | solver normed publicState raw source publicGate gate =>
    exact (congrFun (root_gate_locals _ _ _ gate) n).trans
      ((congrFun (public_gate_locals _ _ publicGate) n).trans
        ((close_local saved ⟨normed,.normal⟩ n member).trans (KeygenMakeLocalFrame134.ternary ctx entry _ source n member)))

theorem gates_flow (ctx : Context) (saved entry : State) (out : Result) (source : Gates ctx saved entry out) :
    out.flow=.continueLoop ∨ out.flow=.normal := by
  cases source with
  | ternaryRejected raw source rejected => exact Or.inl rejected
  | publicRejected normed raw source gate rejected => exact Or.inl rejected
  | solver normed publicState raw source publicGate gate => cases gate <;> simp

inductive Sampled (ctx : Context) (before : State) : Result → Prop where
  | run (entry : State) (out : Result)
      (cap : KeygenMakeSampling.CappedSetup ctx before ⟨entry,.normal⟩)
      (gates : Gates ctx before entry out) : Sampled ctx before out

theorem sampled_remaining (ctx : Context) (before : State) (out : Result) (i : Nat)
    (entry : Remaining before i) (source : Sampled ctx before out) :
    i<KeygenAttemptCap.limit ∧ Remaining out.state (i+1) ∧ (out.flow=.continueLoop ∨ out.flow=.normal) := by
  cases source with
  | run samplerEntry out cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨samplerEntry,.normal⟩ entry.2.2 entry.1 entry.2.1.1 cap with exhausted | running
    · have impossible := congrArg Result.flow exhausted.2; cases impossible
    · have equal : samplerEntry=updated ctx before i := congrArg Result.state running.2.1
      subst samplerEntry
      have locals := gates_locals ctx before (updated ctx before i) out gates
      have dimensions := dimensions_advanced ctx before i entry.2.1
      refine ⟨running.1,⟨?_,⟨?_,?_,?_⟩,by omega⟩,gates_flow ctx _ _ _ gates⟩
      · exact (locals _ (by decide)).trans running.2.2
      · exact (locals _ (by decide)).trans dimensions.1
      · exact (locals _ (by decide)).trans dimensions.2.1
      · exact (locals _ (by decide)).trans dimensions.2.2

end FT1536.Source3.KeygenMakeSearchPrefix134
