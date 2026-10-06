import Source3.KeygenResidueTrace
import Source3.KeygenCheckLoopBridge

namespace FT1536.Source3.KeygenResidueLoop
open C99MemoryReference
open C99ArrayReference (State)
open C99ModularReference (Stmt Exec)
open C99ProcedureReference (Result)
open KeygenResidueTrace (Arrays Inputs Writes slots)

/- This is an observation extracted from the parsed loop derivation. Each
   node retains the four actual input/output memory witnesses in order. -/
inductive Trace (arrays : Arrays) : Nat → Memory → Memory → Prop where
  | done (i : Nat) (heap : Memory) (guard : ¬i<1536) : Trace arrays i heap heap
  | next (i : Nat) (before middle after : Memory) (guard : i<1536)
      (writes : Writes arrays i slots before middle) (rest : Trace arrays (i+1) middle after) :
      Trace arrays i before after

theorem ready_inputs (arrays : Arrays) (before : State) (h : Inputs arrays before) :
    Inputs arrays (KeygenCheckLoopBridge.ready before) := by
  refine ⟨h.input,h.output,?_,?_⟩
  · simpa [KeygenCheckLoopBridge.ready,C99ArrayReference.bindValue,C99ScalarReference.set] using h.prime
  · simpa [C99CountedWords.Limit,KeygenCheckLoopBridge.ready,C99ArrayReference.bindValue,C99ScalarReference.set] using h.size

theorem advanced_inputs (arrays : Arrays) (before : State) (i : Nat) (h : Inputs arrays before) :
    Inputs arrays (SmallintsCounter.advanced before i) := by
  refine ⟨h.input,h.output,?_,SmallintsCounter.advanced_limit before i h.size⟩
  simpa [SmallintsCounter.advanced,C99ScalarReference.set] using h.prime

theorem complete (arrays : Arrays) (code : Stmt) (before : State) (result : Result)
    (source : Exec code before result) (shape : code=KeygenResidueProgram.loop) (i : Nat)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : Inputs arrays before) :
    result.flow=.normal ∧ Inputs arrays result.state ∧ result.state.arrays=before.arrays ∧
      Trace arrays i before.heap result.state.heap := by
  induction source generalizing i with
  | base | assign | store32 | storeRev | seqNormal | seqExit | scope | branchTrue | branchFalse | ret | retVoid => cases shape
  | loopFalse condition body increment before v guard zero =>
      cases shape
      exact ⟨rfl,inputs,rfl,.done i before.heap (C99CountedWords.guard_false before i v hi counter inputs.size guard zero)⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      have strict := C99CountedWords.guard_true before i v hi counter inputs.size guard nonzero
      obtain ⟨_,hl,ha,writes⟩ := KeygenResidueTrace.source_iteration arrays before ⟨middle,.normal⟩ i hi counter inputs iteration
      change middle.locals=before.locals at hl
      change middle.arrays=before.arrays at ha
      have hc : C99CountedWords.Counter middle i := by simpa only [C99CountedWords.Counter,hl] using counter
      have hm := KeygenResidueTrace.inputs_transport arrays before middle hl ha inputs
      have he := congrArg Result.state (KeygenCheckLoopBridge.increment_result middle i ⟨next,.normal⟩ hi hc update)
      change next=SmallintsCounter.advanced middle i at he
      subst next
      have tail := ih3 rfl (i+1) (by omega) (SmallintsCounter.advanced_counter middle i) (advanced_inputs arrays middle i hm)
      exact ⟨tail.1,tail.2.1,tail.2.2.1.trans ha,.next i before.heap middle.heap result.state.heap strict writes tail.2.2.2⟩
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      cases shape
      have normal := (KeygenResidueTrace.source_iteration arrays before ⟨after,.returned (some value)⟩ i hi counter inputs iteration).1
      cases normal

theorem source_trace (arrays : Arrays) (before : State) (old : Option C99IntegerReference.Value) (result : Result)
    (slot : before.locals "u".toList=some (.uint64,old)) (inputs : Inputs arrays before)
    (source : Exec KeygenResidueProgram.code before result) :
    result.flow=.normal ∧ Inputs arrays result.state ∧ result.state.arrays=before.arrays ∧
      Trace arrays 0 before.heap result.state.heap := by
  cases source with
  | seqNormal first second before middle result head tail =>
      have loop := C99ModularReference.continuation KeygenCheckProgram.counter KeygenResidueProgram.loop
        before (KeygenCheckLoopBridge.ready before) ⟨middle,.normal⟩
        (fun out h => KeygenCheckLoopBridge.initial_result before old out slot h) head
      have he := C99ModularReference.skip_result middle result tail
      rw [he]
      exact complete arrays KeygenResidueProgram.loop (KeygenCheckLoopBridge.ready before) ⟨middle,.normal⟩ loop rfl 0
        (by decide) (KeygenCheckLoopBridge.ready_counter before) (ready_inputs arrays before inputs)
  | seqExit first second before result head exit =>
      have loop := C99ModularReference.continuation KeygenCheckProgram.counter KeygenResidueProgram.loop
        before (KeygenCheckLoopBridge.ready before) result
        (fun out h => KeygenCheckLoopBridge.initial_result before old out slot h) head
      have normal := (complete arrays KeygenResidueProgram.loop (KeygenCheckLoopBridge.ready before) result loop rfl 0
        (by decide) (KeygenCheckLoopBridge.ready_counter before) (ready_inputs arrays before inputs)).1
      exact False.elim (exit normal)

end FT1536.Source3.KeygenResidueLoop
