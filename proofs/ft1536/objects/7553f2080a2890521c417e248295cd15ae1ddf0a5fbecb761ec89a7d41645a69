import Source3.KeygenMakeLocalFrame
import Source3.KeygenMakeArguments

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual capped search prefix THROUGH the solver and BEFORE the sixth
   (mandatory certificate) gate. Normal means reaching that boundary, NOT
   accepted KeyGen, an executed break or normal fallthrough of an attempt.
   Every relation below executes a fixed source body; none is a callback. -/
namespace FT1536.Source3.KeygenMakeSearchPrefix
open C99ArrayReference (State Name)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenCapWords (Count)

def close (saved : State) (raw : Result) : Result := ⟨KeygenCallerPrefix.close saved raw.state,raw.flow⟩
theorem close_fixed : ∀ n∈KeygenMakeLocalFrame.fixed, n∉["norm".toList,"bound".toList] := by decide
theorem close_local (saved : State) (raw : Result) (n : Name) (member : n∈KeygenMakeLocalFrame.fixed) :
    (close saved raw).state.locals n=raw.state.locals n := by
  have absent : ["norm".toList,"bound".toList].contains n=false := by
    cases value : ["norm".toList,"bound".toList].contains n with
    | false => rfl
    | true => exact (close_fixed n member (List.contains_iff_mem.mp value)).elim
  simp only [close,KeygenCallerPrefix.close,C99ArrayReference.restoreScope,C99ScalarReference.restore,absent,ite_false,Bool.false_eq_true]
theorem public_locals (before after : State) (v : C99IntegerReference.Value) (source : KeygenPublicSource.Call before after v) :
    after.locals=before.locals := by cases source; rfl
theorem public_gate_locals (before : State) (out : Result) (source : KeygenAttemptMaterial.PublicGate before out) :
    out.state.locals=before.locals := by
  cases source with
  | reject after v call zero | accept after v call nonzero => exact public_locals _ _ _ call
theorem root_gate_locals (ctx : Context) (before : State) (out : Result) (source : KeygenCallerSuccess.RootGate ctx before out) :
    out.state.locals=before.locals := by
  cases source with
  | reject after v call zero | accept after v call nonzero => exact (KeygenRootSource.slots _ _ _ _ call).1

inductive Gates (ctx : Context) (saved entry : State) : Result → Prop where
  | ternaryRejected (raw : Result) (source : KeygenCallerPrefix.Ternary ctx entry raw)
      (rejected : raw.flow=.continueLoop) : Gates ctx saved entry (close saved raw)
  | publicRejected (normed : State) (raw : Result)
      (source : KeygenCallerPrefix.Ternary ctx entry ⟨normed,.normal⟩)
      (gate : KeygenAttemptMaterial.PublicGate (KeygenCallerPrefix.close saved normed) raw)
      (rejected : raw.flow=.continueLoop) : Gates ctx saved entry raw
  | solver (normed publicState : State) (raw : Result)
      (source : KeygenCallerPrefix.Ternary ctx entry ⟨normed,.normal⟩)
      (publicGate : KeygenAttemptMaterial.PublicGate (KeygenCallerPrefix.close saved normed) ⟨publicState,.normal⟩)
      (gate : KeygenCallerSuccess.RootGate ctx publicState raw) : Gates ctx saved entry raw
theorem gates_locals (ctx : Context) (saved entry : State) (out : Result) (source : Gates ctx saved entry out)
    (n : Name) (member : n∈KeygenMakeLocalFrame.fixed) : out.state.locals n=entry.locals n := by
  cases source with
  | ternaryRejected raw source rejected =>
    exact (close_local saved raw n member).trans (KeygenMakeLocalFrame.ternary ctx entry raw source n member)
  | publicRejected normed raw source gate rejected =>
    exact (congrFun (public_gate_locals _ _ gate) n).trans
      ((close_local saved ⟨normed,.normal⟩ n member).trans (KeygenMakeLocalFrame.ternary ctx entry _ source n member))
  | solver normed publicState raw source publicGate gate =>
    exact (congrFun (root_gate_locals _ _ _ gate) n).trans
      ((congrFun (public_gate_locals _ _ publicGate) n).trans
        ((close_local saved ⟨normed,.normal⟩ n member).trans (KeygenMakeLocalFrame.ternary ctx entry _ source n member)))
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
inductive Step (ctx : Context) (before : State) : Result → Prop where
  | exhausted (out : Result) (cap : KeygenMakeSampling.CappedSetup ctx before out) (exit : out.flow≠.normal) : Step ctx before out
  | sampled (out : Result) (source : Sampled ctx before out) : Step ctx before out
def Dimensions (s : State) : Prop := C99CountedWords.Limit s ∧
  s.locals "logn".toList=some (.uint32,some (.uint32 10)) ∧ s.locals "ter".toList=some (.uint32,some (.uint32 1))
def Remaining (s : State) (i : Nat) : Prop := Count s i ∧ Dimensions s ∧ i≤KeygenAttemptCap.limit
def updated (ctx : Context) (before : State) (i : Nat) : State :=
  KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced before i)
theorem prepared_local (ctx : Context) (s : State) (n : Name) (member : n∈KeygenMakeLocalFrame.fixed) :
    (KeygenMakeSampling.prepared ctx s).locals n=s.locals n := by
  have absent := close_fixed n member
  simpa only [KeygenMakeSampling.prepared,C99ArrayReference.bindPointer,KeygenCallerInit.rtDeclared,
    C99DeclarationStatements.effect,C99ValueBridge.type] using KeygenMakeLocalFrame.declared .uint64 ["norm".toList,"bound".toList] s.locals n absent
theorem dimensions_advanced (ctx : Context) (s : State) (i : Nat) (source : Dimensions s) : Dimensions (updated ctx s i) := by
  have size := KeygenMakeSampling.prepared_limit ctx (KeygenCapWords.advanced s i) source.1
  refine ⟨size,?_,?_⟩
  · exact (prepared_local ctx _ _ (by decide)).trans source.2.1
  · exact (prepared_local ctx _ _ (by decide)).trans source.2.2
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
theorem exhaustion (ctx : Context) (before : State) (out : Result) (i : Nat)
    (entry : Remaining before i) (cap : KeygenMakeSampling.CappedSetup ctx before out) (exit : out.flow≠.normal) :
    i=KeygenAttemptCap.limit ∧ out=⟨KeygenCapWords.advanced before i,KeygenCapExecution.abortFlow⟩ := by
  rcases KeygenMakeSampling.cap_before_setup ctx before i out entry.2.2 entry.1 entry.2.1.1 cap with exhausted | running
  · exact exhausted
  · exact (exit (congrArg Result.flow running.2.1)).elim
theorem cap_source : KeygenMakeProgram.ternaryParts.take 2=[KeygenMakeProgram.capIncrement,KeygenMakeProgram.capReturn] :=
  KeygenMakeProgram.cap_source
theorem gates_source : KeygenMakeProgram.attemptParts.drop 1=KeygenMakeProgram.expectedTail :=
  KeygenMakeProgram.actual_attempt_tail
theorem no_false_acceptance (ctx : Context) (before : State) (out : Result) (source : Sampled ctx before out) : out.flow≠.breakLoop := by
  cases source with
  | run entry out cap gates => rcases gates_flow ctx _ _ _ gates with h | h <;> rw [h] <;> decide

end FT1536.Source3.KeygenMakeSearchPrefix
