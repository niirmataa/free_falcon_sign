import Source3.KeygenCheckIteration
import Source3.C99ModularFlow
import Source3.SmallintsCounter

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenCheckLoopBridge
open C99ArrayReference (State bindValue)
open C99ModularReference (Stmt Exec)
open C99ProcedureReference (Result)
open KeygenCheckExpression (Inputs)
open KeygenFinalCheck (Arrays Loop)

def ready (before : State) : State := bindValue before "u".toList .uint64 (.int32 0)

theorem initial_result (before : State) (old : Option C99IntegerReference.Value) (result : Result)
    (slot : before.locals "u".toList=some (.uint64,old))
    (source : Exec KeygenCheckProgram.counter before result) : result=⟨ready before,.normal⟩ := by
  cases source with
  | assign name e before ty actualOld value declared evaluated =>
      have ht : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
      subst ty
      cases evaluated with
      | scalar _ _ source => cases source; rfl

theorem ready_counter (before : State) : C99CountedWords.Counter (ready before) 0 := by
  simp [C99CountedWords.Counter,ready,bindValue,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem ready_inputs (arrays : Arrays) (p0i target : BitVec 32) (before : State)
    (h : Inputs arrays p0i target before) : Inputs arrays p0i target (ready before) := by
  refine ⟨h.f,h.g,h.bigF,h.bigG,?_,?_,?_,?_⟩
  · simpa [ready,bindValue,C99ScalarReference.set] using h.prime
  · simpa [ready,bindValue,C99ScalarReference.set] using h.inverse
  · simpa [ready,bindValue,C99ScalarReference.set] using h.target
  · simpa [C99CountedWords.Limit,ready,bindValue,C99ScalarReference.set] using h.size

theorem advanced_inputs (arrays : Arrays) (p0i target : BitVec 32) (before : State) (i : Nat)
    (h : Inputs arrays p0i target before) : Inputs arrays p0i target (SmallintsCounter.advanced before i) := by
  refine ⟨h.f,h.g,h.bigF,h.bigG,?_,?_,?_,SmallintsCounter.advanced_limit before i h.size⟩
  · simpa [SmallintsCounter.advanced,C99ScalarReference.set] using h.prime
  · simpa [SmallintsCounter.advanced,C99ScalarReference.set] using h.inverse
  · simpa [SmallintsCounter.advanced,C99ScalarReference.set] using h.target

theorem increment_result (before : State) (i : Nat) (result : Result)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i)
    (source : Exec KeygenCheckProgram.increment before result) :
    result=⟨SmallintsCounter.advanced before i,.normal⟩ := by
  cases source with
  | base code before after body =>
      exact SmallintsCounter.source_increment before i ⟨after,.normal⟩ hi counter (.base _ before after body)

theorem complete (arrays : Arrays) (p0i target : BitVec 32) (code : Stmt) (before : State) (result : Result)
    (source : Exec code before result) (shape : code=KeygenCheckProgram.loop) (i : Nat)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : Inputs arrays p0i target before)
    (success : result.flow=.normal) : Loop arrays before.heap p0i target i true := by
  induction source generalizing i with
  | base | assign | seqNormal | seqExit | scope | branchTrue | branchFalse | ret => cases shape
  | loopFalse condition body increment before v guard zero =>
      cases shape
      exact .done i (C99CountedWords.guard_false before i v hi counter inputs.size guard zero)
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      have strict := C99CountedWords.guard_true before i v hi counter inputs.size guard nonzero
      obtain ⟨hm,step⟩ := KeygenCheckIteration.accepted arrays before middle p0i target i hi counter inputs iteration
      subst middle
      have he := congrArg Result.state (increment_result before i ⟨next,.normal⟩ hi counter update)
      change next=SmallintsCounter.advanced before i at he
      subst next
      have tail := ih3 rfl (i+1) (by omega) (SmallintsCounter.advanced_counter before i)
        (advanced_inputs arrays p0i target before i inputs) success
      exact .next i target true strict step rfl tail
  | loopReturn => cases success

theorem source_loop (arrays : Arrays) (before : State) (p0i target : BitVec 32) (old : Option C99IntegerReference.Value)
    (result : Result) (slot : before.locals "u".toList=some (.uint64,old))
    (inputs : Inputs arrays p0i target before) (source : Exec KeygenCheckProgram.code before result)
    (success : result.flow=.returned (some (.int32 1))) : Loop arrays before.heap p0i target 0 true := by
  cases source with
  | seqNormal first second before middle result head tail =>
      have loop := C99ModularReference.continuation KeygenCheckProgram.counter KeygenCheckProgram.loop
        before (ready before) ⟨middle,.normal⟩ (fun out h => initial_result before old out slot h) head
      exact complete arrays p0i target KeygenCheckProgram.loop (ready before) ⟨middle,.normal⟩ loop rfl 0
        (by decide) (ready_counter before) (ready_inputs arrays p0i target before inputs) rfl
  | seqExit first second before result head exit =>
      have hf := C99ModularFlow.source_flow 0 (.seq KeygenCheckProgram.counter KeygenCheckProgram.loop) before result head (by decide)
      rcases hf with normal | aborted
      · exact False.elim (exit normal)
      · have impossible : C99ProcedureReference.Flow.returned (some (.int32 0))≠.returned (some (.int32 1)) := by decide
        exact False.elim (impossible (aborted.symm.trans success))

theorem accepted_coordinates (arrays : Arrays) (before : State) (p0i target : BitVec 32)
    (old : Option C99IntegerReference.Value) (result : Result)
    (slot : before.locals "u".toList=some (.uint64,old)) (inputs : Inputs arrays p0i target before)
    (canonical : KeygenFinalCheck.Canonical arrays before.heap)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (targetCall : KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i (.uint32 target))
    (source : Exec KeygenCheckProgram.code before result) (success : result.flow=.returned (some (.int32 1))) :
    ∀ j<1536, ∃ a b bigF bigG,
      C99MemoryReference.Load32 before.heap (KeygenSmallOutput.element arrays.f j) a ∧
      C99MemoryReference.Load32 before.heap (KeygenSmallOutput.element arrays.g j) b ∧
      C99MemoryReference.Load32 before.heap (KeygenSmallOutput.element arrays.bigF j) bigF ∧
      C99MemoryReference.Load32 before.heap (KeygenSmallOutput.element arrays.bigG j) bigG ∧
      (a.toNat*bigG.toNat)%KeygenNinv31.prime.toNat=(18433+b.toNat*bigF.toNat)%KeygenNinv31.prime.toNat := by
  intro j hj
  exact KeygenFinalCheck.accepted_coordinates arrays before.heap p0i target 0 canonical initialization targetCall
    (source_loop arrays before p0i target old result slot inputs source success) j (Nat.zero_le j) hj

end FT1536.Source3.KeygenCheckLoopBridge
